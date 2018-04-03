//
//  YKYLineView.m
//  YKCharts
//
//  Created by kang lin on 2018/4/2.
//  Copyright © 2018年 康林. All rights reserved.
//

#import "YKYLineView.h"
#import "YKUIConfig.h"

@interface YKYLineView()
{
    UILabel *_LeftTitleLabel;
    UIView  *_ringtLineView;
}
@end

@implementation YKYLineView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (_LeftTitleLabel == nil) {
            _LeftTitleLabel = [UILabel new];
            _LeftTitleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:10.0f];
            _LeftTitleLabel.textColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
        }
        [self addSubview:_LeftTitleLabel];
        
        if (_ringtLineView == nil) {
            _ringtLineView = [UIView new];
            _ringtLineView.backgroundColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:0.3f];
        }
        [self addSubview:_ringtLineView];
    }
    return self;
}


-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat offsetY = (self.bounds.size.height-_LeftTitleLabel.font.lineHeight)/2;
    if (_isTop) {
        offsetY = 0;
    }
    if (_isBottom) {
        offsetY = self.bounds.size.height - _LeftTitleLabel.font.lineHeight;
    }
    _LeftTitleLabel.frame = CGRectMake(0, offsetY, 100, _LeftTitleLabel.font.lineHeight);
    [_LeftTitleLabel sizeToFit];
    _ringtLineView.frame = CGRectMake(CGRectGetMaxX(_LeftTitleLabel.frame) + 5, _LeftTitleLabel.center.y, self.bounds.size.width - CGRectGetMaxX(_LeftTitleLabel.frame) - 5, 0.5);
    _yLineStartx = _ringtLineView.frame.origin.x;
    
}

-(void)setYValue:(NSString *)yValue suffix:(NSString *)suffix withUIConfgi:(YKUIConfig *)config{
    NSString *stringTotal = [NSString stringWithFormat:@"%@ %@",yValue,suffix];
    _LeftTitleLabel.text = stringTotal;
    _LeftTitleLabel.font = config.yDescFront;
    _LeftTitleLabel.textColor = config.yDescColor;
    _ringtLineView.backgroundColor = config.ylineColor;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
