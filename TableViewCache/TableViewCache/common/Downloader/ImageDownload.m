//
// ImageDownload.m
//
//  Created by lin kang on 19/12/18.
//  Copyright © 2018 lin kang. All rights reserved.
//


#import "ImageDownload.h"
#import "SKDownLoadImageCacheHelper.h"

static const long long kDefaultImageSize = 1000000; //

@implementation ImageDownload

- (id)initWithURL:(NSURL *)url
         filename:(NSString * _Nullable)filename
        container:(SKImageView *)imageView
          imageId:(NSString * )imageID
{
    self = [super init];
    if (self) {
        _url = url;
        _progress = [NSProgress progressWithTotalUnitCount:kDefaultImageSize];
        _filename = filename ?: url.lastPathComponent;
        _imageContainer = imageView;
        _imageID = imageID ;
    }
    return self;
}

- (void)startDownloadOnSession:(NSURLSession *)session {
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:self.url];
    self.taskIdentifier = task.taskIdentifier;
    [task resume];
}

- (void)updateProgressForTotalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    int64_t totalUnitCount = totalBytesExpectedToWrite;
    
    if (totalBytesExpectedToWrite < totalBytesWritten) {
        if (totalBytesWritten <= 0) {
            totalUnitCount = kDefaultImageSize;
        } else {
            double written = (double)totalBytesWritten;
            double percent = tanh(written / (double)kDefaultImageSize);
            totalUnitCount = written / percent;
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progress.totalUnitCount = totalUnitCount;
        self.progress.completedUnitCount = totalBytesWritten;
    });
}

// MARK: - URLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    [self updateProgressForTotalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
}


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    self.progress.completedUnitCount = self.progress.totalUnitCount;
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error;
    NSURL *documentImageURL = [SKDownLoadImageCacheHelper getDocumenImageFolder];
    NSURL *destination = [documentImageURL URLByAppendingPathComponent:self.filename];
    NSLog(@"%@", destination);
    [manager removeItemAtURL:destination error:nil];
    BOOL success = [manager moveItemAtURL:location toURL:destination error:&error];
    if (!success) {
        // do something useful
        NSLog(@"%s: saving download failed: %@", __FUNCTION__, error);
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.imageContainer.uuID == self.imageID) {
                self.imageContainer.image = [UIImage imageWithContentsOfFile:destination.path];
            }        });
      
        //保存下载路径，就不用存数据库了。
        [[NSUserDefaults standardUserDefaults] setObject:destination.lastPathComponent forKey:_imageContainer.uuID];
    }
}

@end
