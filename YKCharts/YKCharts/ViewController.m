//
//  ViewController.m
//  YKCharts
//
//  Created by kang lin on 2018/3/26.
//  Copyright © 2018年 康林. All rights reserved.
//

#import "ViewController.h"
#import "YKLineChartView.h"
#import "YKUIConfig.h"
#import "YKLineDataObject.h"

@interface ViewController ()
{
    YKLineChartView *_chartView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if (_chartView == nil) {
        _chartView = [[YKLineChartView alloc] initWithFrame:CGRectMake(24, 200, self.view.bounds.size.width - 48, 130)];
    }
    [self.view addSubview:_chartView];
    
     //y轴
    YKUIConfig *config = [YKUIConfig new];
    config.yDescFront = [UIFont fontWithName:@"PingFang-SC-Medium" size:10.0f];
    config.yDescColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
    config.ylineColor =  [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:0.3f];
    
    //x轴
    config.xDescFront = [UIFont fontWithName:@"PingFang-SC-Medium" size:10.0f];
    config.xDescColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
    //线
    config.lineWidth = 2;
    config.lineColor = [UIColor orangeColor];
    config.circleWidth = 3;
    
    YKLineDataObject *dataObject = [YKLineDataObject new];
    dataObject.ySuffix = @"K";
    dataObject.xDescriptionDataSource = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周七"];
    dataObject.showNumbers = @[@(1000.2),@(-100.2),@(2000.23),@(600.62),@(700.82),@(800.2),@(100.72)];
    [_chartView setupDataSource:dataObject withUIConfgi:config];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
