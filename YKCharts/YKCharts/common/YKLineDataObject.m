//
//  YKLineDataObject.m
//  YKCharts
//
//  Created by kang lin on 2018/3/26.
//  Copyright © 2018年 康林. All rights reserved.
//

#import "YKLineDataObject.h"

@implementation YKLineDataObject

-(NSInteger)max{
    if (_max != 0) {
        return  _max;
    }
    NSInteger tempMax = 0;
    for (NSNumber *number in self.showNumbers) {
        if ([number integerValue] > tempMax) {
            tempMax = [number integerValue];
        }
    }
    _max = tempMax + 200;
    return _max;
}

-(NSInteger)min{
    if (_min != 0) {
        return  _min;
    }
    NSInteger tempMin = [self.showNumbers.firstObject integerValue];
    for (NSNumber *number in self.showNumbers) {
        if ([number integerValue] < tempMin) {
            tempMin = [number integerValue];
        }
    }
    if (tempMin < 0) {
        _min = tempMin - 200;
    }else{
        _min = 0;
    }
    return _min;
}
@end
