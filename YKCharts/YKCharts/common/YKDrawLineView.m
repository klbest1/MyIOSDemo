//
//  YKDrawLineView.m
//  YKCharts
//
//  Created by kang lin on 2018/4/2.
//  Copyright © 2018年 康林. All rights reserved.
//

#import "YKDrawLineView.h"

@interface YKDrawLineView()
{
    NSArray *_pointsArray;
    YKUIConfig *_uiconFig;
}
@end

@implementation YKDrawLineView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}

-(void)setPoints:(NSArray *)drawPoints uiconfig:(YKUIConfig *)config{
    _pointsArray = drawPoints;
    _uiconFig = config;
    [self setNeedsDisplay];
}

-(CGRect)getRectWithCenterPoint:(CGPoint)point{
    return  CGRectMake(point.x -_uiconFig.circleWidth,  point.y - _uiconFig.circleWidth,  _uiconFig.circleWidth * 2, _uiconFig.circleWidth * 2);
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    for (NSInteger i = 0 ; i < _pointsArray.count; i++){
        NSValue *pointValue = [_pointsArray objectAtIndex:i];
        NSValue *nextPointValue = nil;
        if (_pointsArray.count > i+1) {
            nextPointValue = [_pointsArray objectAtIndex:i+1];
        }
        CGPoint point = [pointValue CGPointValue];
        CGPoint nextPoint = [nextPointValue CGPointValue];
        //画线
        if (nextPointValue != nil) {
            UIBezierPath *linePath = [UIBezierPath bezierPath];
            linePath.lineWidth = _uiconFig.lineWidth;
            [_uiconFig.lineColor setStroke];
            [linePath moveToPoint:point];
            [linePath addLineToPoint:nextPoint];
            [linePath stroke];
        }
        
        //画圆
        CGRect getCirRect = [self getRectWithCenterPoint:point];
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:getCirRect];
        [_uiconFig.lineColor setStroke];
        [UIColor.whiteColor setFill];
        [circlePath stroke];
        [circlePath fill];
        
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    CGPoint touchPoint = [touches.anyObject locationInView:self];
    double itemLength = [self.delegate getItemLength];
    NSInteger index = touchPoint.x/itemLength + ((NSInteger)touchPoint.x % (NSInteger)itemLength > 0 ? 1 : 0);
    [self.delegate touchAtIndex:index];
    NSLog(@"touchPoint:%f,%f",touchPoint.x,touchPoint.y);
}
@end
