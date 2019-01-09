//
//  SKWeakTargetOb.m
//  Wave
//
//  Created by lin kang on 17/12/18.
//  Copyright © 2018 lin kang. All rights reserved.
//

#import "SKWeakTargetOb.h"

@implementation SKWeakTargetOb

- (instancetype)initWithRealTarget:(id)target {
    self = [self init];
    if (self) {
        _realTarget = target;
    }
    return self;
}

+ (instancetype)weakObjectWitherRealTarget:(id)target {
    return [[self alloc] initWithRealTarget:target];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return _realTarget;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSMethodSignature signatureWithObjCTypes:"v@:"];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}
@end
