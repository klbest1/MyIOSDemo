//
//  YKUIConfig.h
//  YKCharts
//
//  Created by kang lin on 2018/4/2.
//  Copyright © 2018年 康林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface YKUIConfig : NSObject

//y轴
@property (nonatomic,retain) UIFont *yDescFront ;
@property (nonatomic,retain) UIColor *yDescColor;
@property (nonatomic,retain) UIColor *ylineColor;

//x轴
@property (nonatomic,retain) UIFont *xDescFront ;
@property (nonatomic,retain) UIColor *xDescColor;

//线
@property (nonatomic,assign) CGFloat lineWidth ;
@property (nonatomic,retain) UIColor *lineColor;
@property (nonatomic,assign) CGFloat circleWidth;

@end
