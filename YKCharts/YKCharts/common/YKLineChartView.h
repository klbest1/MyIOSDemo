//
//  YKLineChartView.h
//  YKCharts
//
//  Created by kang lin on 2018/3/26.
//  Copyright © 2018年 康林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKLineDataObject.h"
#import "YKUIConfig.h"


@interface YKLineChartView : UIView

-(void)setupDataSource:(YKLineDataObject *)data withUIConfgi:(YKUIConfig *)config;

@end
