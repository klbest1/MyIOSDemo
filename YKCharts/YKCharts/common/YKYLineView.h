//
//  YKYLineView.h
//  YKCharts
//
//  Created by kang lin on 2018/4/2.
//  Copyright © 2018年 康林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YKUIConfig;

@interface YKYLineView : UIView

@property(nonatomic,assign) CGFloat yLineStartx;
@property (nonatomic,assign) BOOL isTop;
@property (nonatomic,assign) BOOL isBottom;

-(void)setYValue:(NSString *)yValue suffix:(NSString *)suffix withUIConfgi:(YKUIConfig *)config;

@end
