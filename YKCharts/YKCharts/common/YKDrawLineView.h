//
//  YKDrawLineView.h
//  YKCharts
//
//  Created by kang lin on 2018/4/2.
//  Copyright © 2018年 康林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKUIConfig.h"

@protocol YKDrawLineViewDelegate
-(double)getItemLength;
-(void)touchAtIndex:(NSInteger)index;
@end

@interface YKDrawLineView : UIView

@property (nonatomic,assign) id<YKDrawLineViewDelegate> delegate;

-(void)setPoints:(NSArray *)drawPoints uiconfig:(YKUIConfig *)config;

@end
