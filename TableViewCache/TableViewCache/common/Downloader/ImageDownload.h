//
//  ImageDownload.h
//  
//
//  Created by lin kang on 19/12/18.
//  Copyright © 2018 lin kang. All rights reserved.
//


@import Foundation;
@import UIKit;
#import "SKImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImageDownload : NSObject <NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *filename;
//需要设置的图片
@property (nonatomic,assign) SKImageView *imageContainer;
//真正在下载的图片id
@property (nonatomic,copy) NSString *imageID;
//进度
@property (nonatomic) NSProgress *progress;
//下载id
@property (nonatomic) NSUInteger taskIdentifier;


- (id)initWithURL:(NSURL *)url
         filename:(NSString * _Nullable)filename
        container:(SKImageView *)imageView
          imageId:(NSString * _Nullable)imageID;




- (void)updateProgressForTotalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite;

- (void)startDownloadOnSession:(NSURLSession *)session;

@end

NS_ASSUME_NONNULL_END

