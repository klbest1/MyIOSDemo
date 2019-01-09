//
//  SKWaveView.m
//  Wave
//
//  Created by lin kang on 17/12/18.
//  Copyright © 2018 lin kang. All rights reserved.
//

#import "SKWaveView.h"
#import "SKWeakTargetOb.h"
#import "SKDrawImageView.h"


@interface SKWaveView ()

@property (strong, nonatomic) CADisplayLink *waveDisplayLink;
@property (strong, nonatomic) CAShapeLayer *waveShapeLayer;

//波浪相关的参数
//波浪宽度
@property (nonatomic, assign) CGFloat waveWidth;
//波浪高度
@property (nonatomic, assign) CGFloat waveHeight;
//波浪震动幅度
@property (nonatomic, assign) CGFloat maxAmplitude;
//X轴上移动长度
@property (nonatomic, assign) CGFloat phaseShift;
//X轴上的当前位置
@property (nonatomic, assign) CGFloat phase;
//单位长度内有几个波浪
@property (nonatomic, assign) CGFloat frequency;
//顶层有波浪的图层
@property (nonatomic, strong) SKDrawImageView *sineImageView;
//波浪最下面的图层
@property (nonatomic, strong) SKDrawImageView *underImageView;

@end

@implementation SKWaveView

-(void)dealloc {
    [self.waveDisplayLink invalidate];
    self.waveDisplayLink = nil;
}

+ (instancetype)addToView:(UIView *)view withFrame:(CGRect)frame {
    SKWaveView *waveView = [[self alloc] initWithFrame:frame];
    [view addSubview:waveView];
    return waveView;
}

- (void)drawRect:(CGRect)rect{
    //左边弧线
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.width/2) radius:self.bounds.size.width/2 startAngle:M_PI * 1.1 endAngle: M_PI * 1.4 clockwise:true];
    [[UIColor colorWithRed:54/255.0 green:107/255.0 blue:119/255.0 alpha:.6] setStroke];
    [UIColor.whiteColor setFill];
    [path stroke];
    [path fill];
    
    //右边弧线
    UIBezierPath *rightCurve = [UIBezierPath bezierPath];
    [rightCurve addArcWithCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.width/2) radius:rect.size.width/2 startAngle:M_PI * 1.6 endAngle:M_PI * 1.9 clockwise:true];
    [[UIColor colorWithRed:54/255.0 green:107/255.0 blue:119/255.0 alpha:.6] setStroke];
    [UIColor.whiteColor setFill];
    
    //给右边加点阴影
    CGContextRef rightContent = UIGraphicsGetCurrentContext();
    CGContextSaveGState(rightContent);
    CGContextSetShadowWithColor(rightContent, CGSizeMake(3, 3), 5, [[UIColor colorWithRed:54/255.0 green:107/255.0 blue:119/255.0 alpha:.6] CGColor]);
    [rightCurve stroke];
    [rightCurve fill];
    CGContextRestoreGState(rightContent);
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.waveHeight = CGRectGetHeight(self.bounds) * 0.3;
        self.waveWidth  = CGRectGetWidth(self.bounds);
        self.frequency = 0.7;
        self.phaseShift = 8;
        self.maxAmplitude = self.waveHeight * .3;
        
        _underImageView = [[SKDrawImageView alloc] initWithFrame:self.bounds];
        [_underImageView setText:@"RD" textColor:[UIColor colorWithRed:84/255.0 green:167/255.0 blue:232/255.0 alpha:1] backGroundColor:[UIColor whiteColor]];
        [self addSubview:_underImageView];
        
        _sineImageView = [[SKDrawImageView alloc] initWithFrame:self.bounds];
        [_sineImageView setText:@"RD" textColor:[UIColor whiteColor] backGroundColor:[UIColor colorWithRed:84/255.0 green:167/255.0 blue:232/255.0 alpha:1]];
        [self addSubview:_sineImageView];
        
   
        [self setOpaque:NO];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ([super initWithCoder:aDecoder]) {
    }
    return self;
}



- (BOOL)wave {
    if (self.waveShapeLayer.path) {
        return NO;
    }
    self.waveShapeLayer = [CAShapeLayer layer];
    self.waveShapeLayer.frame = self.bounds;
    //把波浪设置在上层的mask上面，这样会覆盖到白色RD的一部分，并产生波浪效果
    _sineImageView.layer.mask = self.waveShapeLayer;
    
    //创建30次/秒 刷新产生图层，下面的边界用sin函数根据x轴位置，获取y轴高度，
    self.waveDisplayLink = [CADisplayLink displayLinkWithTarget:[SKWeakTargetOb weakObjectWitherRealTarget:self] selector:@selector(currentWave)];
    [self.waveDisplayLink setPreferredFramesPerSecond:30];
    [self.waveDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    return YES;
}

/*
 以正弦曲线为例，它可以表示为y=Asin(ωx+φ)+k，公式中各符号表示的含义：
 
 A–振幅，即波峰的高度。
 
 (ωx+φ)–相位，反应了变量y所处的位置。
 
 φ–初相，x=0时的相位，反映在坐标系上则为图像的左右移动。
 
 k–偏距，反映在坐标系上则为图像的上移或下移。
 
 ω–角速度，控制正弦周期(单位角度内震动的次数)。
 */
- (void)currentWave {
    self.phase += self.phaseShift;

    //创建Sin函数的贝塞尔path
    UIBezierPath *wavePath = [UIBezierPath bezierPath];
    CGFloat endX = 0;
    for (CGFloat x = 0; x < self.waveWidth + 1; x += 1) {
        endX=x;
        CGFloat y = 0;
        y = self.maxAmplitude * sinf(360.0 / _waveWidth * (x  * M_PI / 180) * self.frequency + self.phase * M_PI/ 180) + self.bounds.size.height*0.5;
        if (x == 0) {
            [wavePath moveToPoint:CGPointMake(x, y)];
        } else {
            [wavePath addLineToPoint:CGPointMake(x, y)];
        }
    }
    
    CGFloat endY = CGRectGetHeight(self.bounds) + 10;
    [wavePath addLineToPoint:CGPointMake(endX, endY)];
    [wavePath addLineToPoint:CGPointMake(0, endY)];
    
    self.waveShapeLayer.path = wavePath.CGPath;
}

- (void)stop {
    [UIView animateWithDuration:1.f animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.waveDisplayLink invalidate];
        self.waveDisplayLink = nil;
        self.waveShapeLayer.path = nil;
        self.alpha = 1.f;
    }];
    
}

@end
