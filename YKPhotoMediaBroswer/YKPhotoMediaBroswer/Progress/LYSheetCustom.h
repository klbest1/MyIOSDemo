//
//  LYSheetCustom.h
//  LYSheetCustom
//
//  Created by liyang on 15/3/12.
//  Copyright © 2015年 LY. All rights reserved.
//  代码地址：https://github.com/YoungerLi/LYSheetCustom

#import <UIKit/UIKit.h>

@protocol LYSheetCustomDelegate;


@interface LYSheetCustom : UIView

/** 初始化方式一，标题或取消按钮标题为nil不显示 */
- (instancetype)initWithTitle:(NSString *)title
                     delegate:(id<LYSheetCustomDelegate>)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
       otherButtonTitlesArray:(NSArray *)otherButtonTitles;

/** 初始化方式二，标题或取消按钮标题为nil不显示 */
- (instancetype)initWithTitle:(NSString *)title
                     delegate:(id<LYSheetCustomDelegate>)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@property(nonatomic, weak) id<LYSheetCustomDelegate> delegate;
@property (nonatomic,assign) BOOL isVisible;
/** 展示出来 */
- (void)show;

@end


@protocol LYSheetCustomDelegate <NSObject>
@optional

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)lySheetCustom:(LYSheetCustom *)sheetCustom clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
