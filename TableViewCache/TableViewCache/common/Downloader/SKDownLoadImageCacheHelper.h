//
//  SKDownLoadImageCacheHelper.h
//  BaseFrameWork
//
//  Created by lin kang on 19/12/18.
//  Copyright © 2018 lin kang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SKImageView.h"


@interface SKDownLoadImageCacheHelper : NSObject

+ (SKDownLoadImageCacheHelper *) helper;

+(void)destroyHelper;

+(NSURL * )getDocumenImageFolder;

-(void)downloadWithUUID:(NSString *)aUniqueId
                    url:(NSString *)url
              container:(SKImageView *)aImageView;
@end
