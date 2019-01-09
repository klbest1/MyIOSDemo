//
//  SKWaveView.h
//  Wave
//
//  Created by lin kang on 17/12/18.
//  Copyright © 2018 lin kang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SKWaveView : UIView

+ (instancetype)addToView:(UIView *)view withFrame:(CGRect)frame;

- (BOOL)wave;

@end

