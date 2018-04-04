//
//  YKLineChartView.m
//  YKCharts
//
//  Created by kang lin on 2018/3/26.
//  Copyright © 2018年 康林. All rights reserved.
//

#import "YKLineChartView.h"
#import "YKYLineView.h"
#import "YKDrawLineView.h"
#import "FTPopOverMenu.h"


#define xMiniSpace  40


@interface YKLineChartView()<YKDrawLineViewDelegate>
{
    CGFloat _chartYLength;
    NSInteger _numberOfYLines;
    CGFloat yLineStartx;
    CGFloat _xItemWidth;
    
    YKLineDataObject *_dataSource;
    YKUIConfig      *_uiConfig;
    
    NSMutableArray *_yLinesViews;
    NSMutableArray *_xDescriptionViews;
    NSMutableArray *_drawPoints;
    
    UIScrollView *_contentScrollView;
    YKDrawLineView *_drawLineView;
    UIView   *_selectedLineView;
    CGFloat  _topSpaceLength;
    CGFloat _underSpaceLegnth;
    FTPopOverMenu *_popMenu;
}
@end

@implementation YKLineChartView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (instancetype)init
{
    self = [super init];
    if (self) {
      
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    self  =  [super initWithFrame:frame];
    if (self){
        _numberOfYLines = 3;
        if (_yLinesViews == nil) {
            _yLinesViews = [NSMutableArray new];
        }
        
        if (_xDescriptionViews == nil) {
            _xDescriptionViews = [NSMutableArray new];
        }
        
        if (_drawPoints == nil) {
            _drawPoints = [NSMutableArray new];
        }
        
        if (_contentScrollView == nil) {
            _contentScrollView = [UIScrollView new];
        }
        
        [self addSubview:_contentScrollView];
        
        if (_drawLineView == nil) {
            _drawLineView = [YKDrawLineView new];
            _drawLineView.delegate = self;
        }
        [_contentScrollView addSubview:_drawLineView];
        
        if (_selectedLineView == nil) {
            _selectedLineView = [UIView new];
            _selectedLineView.backgroundColor = UIColor.grayColor;
        }
        
        if (_popMenu == nil) {
            _popMenu = [FTPopOverMenu new];
        }
        self.backgroundColor = UIColor.whiteColor;
        [self setupFrame];
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setupFrame];
}

-(void)setupFrame{
    _topSpaceLength = self.bounds.size.height/6;
    _underSpaceLegnth = self.bounds.size.height/5;
    _chartYLength = self.bounds.size.height - _topSpaceLength - _underSpaceLegnth;
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat yStart = _topSpaceLength;
    CGFloat lineHeight = _chartYLength/(_numberOfYLines - 1) ;
    //布局y轴
    for (NSInteger i = _yLinesViews.count-1; i >= 0 ;i--){
        YKYLineView *line = [_yLinesViews objectAtIndex:i];
        line.frame = CGRectMake(0, yStart, self.bounds.size.width, 1);
        yStart += lineHeight;
        yLineStartx = line.yLineStartx;
    }
    
    _contentScrollView.frame = CGRectMake(yLineStartx, 0, self.bounds.size.width - yLineStartx, self.bounds.size.height);
    CGFloat contentWidth = _xItemWidth * (_dataSource.xDescriptionDataSource.count);
    _contentScrollView.contentSize = CGSizeMake(contentWidth, self.bounds.size.height);

    //布局x轴
    for (NSInteger i = 0; i < _xDescriptionViews.count;i++){
        UILabel *label = [_xDescriptionViews objectAtIndex:i];
        label.frame = CGRectMake(_xItemWidth * i, _contentScrollView.bounds.size.height - label.font.lineHeight, _xItemWidth, label.font.lineHeight);
    }
    
    //绘图
    _drawLineView.frame = CGRectMake(0, _topSpaceLength - 20, _contentScrollView.contentSize.width, _chartYLength + 40);
}

-(void)setupDataSource:(YKLineDataObject *)data withUIConfgi:(YKUIConfig *)config{
    _dataSource = data;
    _uiConfig = config;
    [self emptyCharts];
    if (data.showNumbers.count == 0) {
        return;
    }
    [self installYLines];
    [self installXDesctions];
    [self installDrawlines];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)emptyCharts{
    for (UIView *line in _yLinesViews){
        [line removeFromSuperview];
    }
    [_yLinesViews removeAllObjects];
    
    for (UIView *view in _xDescriptionViews){
        [view removeFromSuperview];
    }
    [_xDescriptionViews removeAllObjects];
    
    [_drawPoints removeAllObjects];
}

-(void)installYLines{
    double  yEachValue = (_dataSource.max)/(_numberOfYLines - 1);
    for (NSInteger i = 0; i < _numberOfYLines ; i++) {
        YKYLineView *line = [YKYLineView new];
        float yValue =  i * yEachValue/1000.0;
        //最小值为负数时， 第一轴线为 负数
        if (_dataSource.min < 0 && i == 0) {
            yValue  = _dataSource.min;
        }
        [line setYValue:[NSString stringWithFormat:@"%.1f",yValue] suffix:_dataSource.ySuffix withUIConfgi:_uiConfig];
        [self addSubview:line];
        [_yLinesViews addObject:line];
    }
    [self bringSubviewToFront:_contentScrollView];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)installXDesctions{
    _xItemWidth = (self.bounds.size.width - yLineStartx) / _dataSource.xDescriptionDataSource.count;
    if (_xItemWidth < xMiniSpace) {
        _xItemWidth = xMiniSpace;
    }
    for (NSString *desc in _dataSource.xDescriptionDataSource) {
        UILabel *descLabel = [UILabel new];
        descLabel.text = desc;
        descLabel.font = _uiConfig.xDescFront;
        descLabel.textColor = _uiConfig.xDescColor;
        descLabel.textAlignment = NSTextAlignmentCenter;
        [_xDescriptionViews addObject:descLabel];
        [_contentScrollView addSubview:descLabel];
    }
}

-(void)installDrawlines{
    for (NSInteger i = 0 ; i < _dataSource.showNumbers.count; i ++){
        NSNumber *data = [_dataSource.showNumbers objectAtIndex:i];
        double number = [data doubleValue];
        //计算 y 的位置
        CGFloat percentage = (1 - (fabs(number)-_dataSource.min)/(labs(_dataSource.max) - _dataSource.min));
        CGFloat yOffset = _chartYLength  * percentage + 20;
        CGFloat xOffset = _xItemWidth * (i + 1) - _xItemWidth/2;
        CGPoint drawPoint = CGPointMake(xOffset, yOffset);
        [_drawPoints addObject:[NSValue valueWithCGPoint:drawPoint]];
    }
    [_drawLineView setPoints:_drawPoints uiconfig:_uiConfig];
}


- (void)drawRect:(CGRect)rect {
//     Drawing code
    
}

//MARK: - YKDrawLineViewDelegate
-(double)getItemLength{
    return  _xItemWidth;
}

-(void)touchAtIndex:(NSInteger)index{
    if (index < 1) {
        return;
    }
    if ( index > _drawPoints.count ) {
        return;
    }
    if (_selectedLineView.superview == nil) {
        CGRect lineRect = CGRectMake(0, 0, 1, _drawLineView.bounds.size.height - 40);
        _selectedLineView.frame = lineRect;
        [_drawLineView addSubview:_selectedLineView];
    }
    CGPoint touchItemCenter = CGPointMake(_xItemWidth * index - _xItemWidth/2, _drawLineView.bounds.size.height/2);
    _selectedLineView.center = touchItemCenter;
    
    CGPoint drawPoint = [[_drawPoints objectAtIndex:index-1] CGPointValue];
    CGRect drawRect = CGRectMake(drawPoint.x - _uiConfig.circleWidth, drawPoint.y - _uiConfig.circleWidth,  _uiConfig.circleWidth * 2,  _uiConfig.circleWidth * 2);
    CGRect screenRect = [_drawLineView convertRect:drawRect toView:self.superview];
    NSString *showContent = [NSString stringWithFormat:@"%.2f",[[_dataSource.showNumbers objectAtIndex:index-1] doubleValue]];
    [self showMenuFromButton:screenRect content:showContent];
}

-(CGFloat)contentLength:(NSString *)content{
    UILabel *testLabel = [UILabel new];
    testLabel.font = [UIFont systemFontOfSize:12];
    testLabel.text = content;
    testLabel.frame = CGRectMake(0, 0, 200, [UIFont systemFontOfSize:12].lineHeight);
    testLabel.numberOfLines = 0;
    [testLabel sizeToFit];
    return testLabel.bounds.size.width + 20;
}

- (void)showMenuFromButton:(CGRect )rect content:(NSString *)content;
{
    
    // Do any of the following setting to set the style (Only set what you want to change)
    // Maybe do this when app starts (in AppDelegate) or anywhere you wanna change the style.
    
    
    // uncomment the following line to use custom settings.
    
#define USE_CUSTOM_SETTINGS
    
#ifdef USE_CUSTOM_SETTINGS
    FTPopOverMenuConfiguration *configuration = [FTPopOverMenuConfiguration defaultConfiguration];
    //    configuration.menuRowHeight = 80;
    configuration.textColor = [UIColor whiteColor];
    configuration.textFont = [UIFont systemFontOfSize:12];
    configuration.tintColor = [UIColor orangeColor];
    configuration.textAlignment = NSTextAlignmentCenter;
    configuration.borderColor = [UIColor orangeColor];
    configuration.menuRowHeight = 20;
    configuration.menuWidth = [self contentLength:content];
    configuration.selectedTextColor = UIColor.whiteColor;
    configuration.selectedCellBackgroundColor = UIColor.orangeColor;
    configuration.showDirection =  FTPopOverMenuArrowDirectionDown;
    configuration.showCustomDirection = true;
    configuration.enableUserInteraction = false;
    //    configuration.ignoreImageOriginalColor = YES;// set 'ignoreImageOriginalColor' to YES, images color will be same as textColor
#endif
    
    [FTPopOverMenu showFromSenderFrame:rect superView:self.superview instance:_popMenu  withMenuArray:@[content]  doneBlock:^(NSInteger selectedIndex) {
        
    } dismissBlock:^{
        
    }];
}
@end
