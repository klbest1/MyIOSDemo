

@import Foundation;

@class ImageDownload;
#import "SKImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface Downloader : NSObject

@property (class, nonatomic, strong, readonly) Downloader *sharedDownloader;

@property (nonatomic, strong) NSMutableArray <ImageDownload *> *imageDownloads;

- (instancetype)init __attribute__((unavailable("Use +[Downloader sharedDownloader] instead")));
+ (instancetype)new __attribute__((unavailable("Use +[Downloader sharedDownloader] instead")));

- (ImageDownload *)startDownload:(NSURL *)url filename:(NSString *)filename container:(SKImageView *)imageView;

@end

NS_ASSUME_NONNULL_END
