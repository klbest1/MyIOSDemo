//
//  YKLineDataObject.h
//  YKCharts
//
//  Created by kang lin on 2018/3/26.
//  Copyright © 2018年 康林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKLineDataObject : NSObject

@property (nonatomic,assign) NSInteger max;
@property (nonatomic,assign) NSInteger min;
@property (nonatomic,retain) NSString *ySuffix;
@property (nonatomic,retain) NSArray *xDescriptionDataSource;
@property (nonatomic,retain) NSArray *showNumbers;
@end
