//
//  SKDownLoadImageCacheHelper.m
//  BaseFrameWork
//
//  Created by lin kang on 19/12/18.
//  Copyright © 2018 lin kang. All rights reserved.
//

#import "SKDownLoadImageCacheHelper.h"
#import "Downloader.h"


static SKDownLoadImageCacheHelper *_shareSKDownLoadImageCaher = nil;

@interface SKDownLoadImageCacheHelper()
{
    NSMutableDictionary    *_imageRequestIDDic;
}
@end
@implementation SKDownLoadImageCacheHelper

+ (SKDownLoadImageCacheHelper *) helper {
    @synchronized(self) {
        if (_shareSKDownLoadImageCaher == nil) {
            _shareSKDownLoadImageCaher = [[SKDownLoadImageCacheHelper alloc] init];
        }
        
        return _shareSKDownLoadImageCaher;
    }
}

-(id)init{
    self = [super init];
    if (self) {
        if (_imageRequestIDDic == nil) {
            _imageRequestIDDic = [[NSMutableDictionary alloc] init];
        }
    }
    return self;
}

+(void)destroyHelper{
    _shareSKDownLoadImageCaher = nil;
}

#if __has_feature(objc_arc)
#else
- (void)dealloc{
    [super dealloc];
}

#endif

+(NSURL * )getDocumenImageFolder{
    NSError *error;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSURL *document = [manager URLForDirectory:NSDocumentDirectory
                                      inDomain:NSUserDomainMask
                             appropriateForURL:nil
                                        create:true
                                         error:&error];
    NSURL *folder = [document URLByAppendingPathComponent:@"images"];
    [manager createDirectoryAtURL:folder withIntermediateDirectories:true attributes:nil error:nil];
    return folder;
}

///Users/linkang/Library/Developer/CoreSimulator/Devices/3F0EACBF-785D-455C-B17A-7AB0E91D008C/data/Containers/Data/Application/990D25F4-314A-4BA6-B3A8-456BD7B5CB85/Documents/images/c68458f78f9295333a481681a8dd38a9.png
-(void)dealWithLocalFileUUID:(NSString *)aUniqueId
                   container:(SKImageView *)aImageView
                    filePath:(NSString *)aFilePath{
    NSURL *documentImageURL = [SKDownLoadImageCacheHelper getDocumenImageFolder];
    NSURL *destination = [documentImageURL URLByAppendingPathComponent:aFilePath];
    aImageView.image = [UIImage imageWithContentsOfFile:destination.path];
}

-(void)downloadWithUUID:(NSString *)aUniqueId
                    url:(NSString *)url
              container:(SKImageView *)aImageView
{
    aImageView.uuID = aUniqueId;
    if (aUniqueId == nil || aUniqueId.length == 0 ) {
        return;
    }
    
    //本地有文件,。
    NSString *vFilePath = [[NSUserDefaults standardUserDefaults] objectForKey:aUniqueId];
    if (vFilePath != nil) {
        [self dealWithLocalFileUUID:aUniqueId container:aImageView filePath:vFilePath];
        return;
    }
    
    // download
    NSString *filename = [url lastPathComponent];
    [[Downloader sharedDownloader] startDownload:[NSURL URLWithString:url] filename:filename container:aImageView];

}

@end
