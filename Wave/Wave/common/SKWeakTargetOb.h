//
//  SKWeakTargetOb.h
//  Wave
//
//  Created by lin kang on 17/12/18.
//  Copyright © 2018 lin kang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKWeakTargetOb : NSObject
@property (weak,nonatomic) id realTarget;

-(instancetype)initWithRealTarget:(id)target;

+(instancetype)weakObjectWitherRealTarget:(id)target;
@end

NS_ASSUME_NONNULL_END
