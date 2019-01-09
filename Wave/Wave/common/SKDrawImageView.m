//
//  SKDrawImageView.m
//  Wave
//
//  Created by lin kang on 18/12/18.
//  Copyright © 2018 lin kang. All rights reserved.
//

#import "SKDrawImageView.h"

@interface SKDrawImageView()
{
    UIImageView *_backGroundImageView;
    NSString *_content;
    UIColor *_backGroundColor;
    NSDictionary *_attributes;
    CGFloat _textWidthRation;
}
@end

@implementation SKDrawImageView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //画背景
    UIBezierPath* p = [UIBezierPath bezierPathWithOvalInRect:rect];
    [_backGroundColor setFill];
    [p fill];
    
    //画文字
    [_content drawInRect:CGRectMake(0,self.bounds.size.height*(1-_textWidthRation)/2, self.bounds.size.width,[UIFont boldSystemFontOfSize:self.bounds.size.height*_textWidthRation].lineHeight ) withAttributes:_attributes];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _textWidthRation = 0.6;
    }
    return self;
}

-(void)setText:(NSString *)text textColor:(UIColor *)textColor backGroundColor:(UIColor *)backColor{
    _content = [text copy];
    _backGroundColor = backColor;
    
    NSMutableParagraphStyle * paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    _attributes  =@{NSFontAttributeName:[UIFont boldSystemFontOfSize:self.bounds.size.height*_textWidthRation],
                    NSForegroundColorAttributeName:textColor,
                    NSParagraphStyleAttributeName : paragraphStyle
                    };
    [self setNeedsDisplay];
}

@end
