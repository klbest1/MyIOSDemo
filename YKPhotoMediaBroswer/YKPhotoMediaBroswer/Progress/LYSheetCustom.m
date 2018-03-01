//
//  LYSheetCustom.m
//  LYSheetCustom
//
//  Created by liyang on 15/3/12.
//  Copyright © 2015年 LY. All rights reserved.
//  代码地址：https://github.com/YoungerLi/LYSheetCustom

#import "LYSheetCustom.h"

#define WIDTH  [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#define cellHeight 45
#define sectionMargin 5



@interface LYSheetCell : UITableViewCell
@property (nonatomic, copy) NSString *title;
@end

@interface LYSheetCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@end



@implementation LYSheetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];    // #333333
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.5)];
        line.backgroundColor = [UIColor colorWithRed:211/255.0f green:211/255.0f blue:211/255.0f alpha:1];  //#d3d3d3
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = self.bounds;
}

@end



@interface LYSheetCustom ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *cancelButtonTitle;
@property (nonatomic, strong) NSMutableArray *otherButtonTitlesArray;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *footerButton;

@end

@implementation LYSheetCustom

- (instancetype)initWithTitle:(NSString *)title delegate:(id<LYSheetCustomDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitlesArray:(NSArray *)otherButtonTitles
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
        if (title != nil) {
            self.title = title;
        }
        
        if (delegate != nil) {
            self.delegate = delegate;
        }
        
        if (cancelButtonTitle != nil) {
            self.cancelButtonTitle = cancelButtonTitle;
        }
        
        if (otherButtonTitles) {
            self.otherButtonTitlesArray = [[NSMutableArray alloc] initWithArray:otherButtonTitles];
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title delegate:(id<LYSheetCustomDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
        if (title != nil) {
            self.title = title;
        }
        
        if (delegate != nil) {
            self.delegate = delegate;
        }
        
        if (cancelButtonTitle != nil) {
            self.cancelButtonTitle = cancelButtonTitle;
        }
        
        if (otherButtonTitles) {
            NSString *arg = nil;
            va_list argList;
            
            self.otherButtonTitlesArray = [[NSMutableArray alloc] init];
            [self.otherButtonTitlesArray addObject:otherButtonTitles];
            va_start(argList, otherButtonTitles);
            
            while ((arg = va_arg(argList, NSString *))) {
                [self.otherButtonTitlesArray addObject:arg];
            }
            va_end(argList);
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}


- (void)show
{
    if (self.isVisible) {
        return;
    }
    self.isVisible = true;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:.0f alpha:0.5f];
        CGFloat height = [self getTableViewHeight];
        [self addSubview:self.tableView];
        self.tableView.frame = CGRectMake(0, HEIGHT - height, WIDTH, height);
    }];
}

- (void)hide
{
    self.isVisible = false;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        CGFloat height = [self getTableViewHeight];
        self.tableView.frame = CGRectMake(0, HEIGHT, WIDTH, height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

// 解决手势冲突问题
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return [touch.view isKindOfClass:self.class];
}




#pragma mark - *****************UITableView

- (UITableView *)tableView
{
    if (_tableView == nil) {
        CGFloat height = [self getTableViewHeight];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = [UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1];    //#f6f6f6
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;  //去除分割线
        [_tableView registerClass:[LYSheetCell class] forCellReuseIdentifier:@"LYSheetCell"];
        if (self.cancelButtonTitle) {
            _tableView.tableFooterView = self.footerButton;
        }
    }
    return _tableView;
}


- (UIButton *)footerButton
{
    if (_footerButton == nil) {
        _footerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH, cellHeight)];
        _footerButton.backgroundColor = [UIColor whiteColor];
        [_footerButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
        [_footerButton setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1] forState:UIControlStateNormal];
        _footerButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_footerButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerButton;
}


- (CGFloat)getTableViewHeight {
    CGFloat headerHeight  = [self getHeaderViewHeight];
    CGFloat cellsHeight  = self.otherButtonTitlesArray.count * cellHeight;
    CGFloat footerHeight = self.cancelButtonTitle ? cellHeight + 5 : 0;
    return headerHeight + cellsHeight + footerHeight;
}
- (CGFloat)getHeaderViewHeight {
    if (self.title) {
        CGRect frame = [self.title boundingRectWithSize:CGSizeMake(WIDTH-20, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
        return frame.size.height + 40;
    } else {
        return 0;
    }
}




#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.otherButtonTitlesArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.title ? [self getHeaderViewHeight] : CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.title) {
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor = [UIColor whiteColor];
        CGFloat titleHeight  = [self getHeaderViewHeight] - 40;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, WIDTH-20, titleHeight)];
        titleLabel.text = self.title;
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];    // #999999
        [headerView addSubview:titleLabel];
        return headerView;
    } else {
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return sectionMargin;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LYSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LYSheetCell"];
    cell.title = self.otherButtonTitlesArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self hide];
    if ([self.delegate respondsToSelector:@selector(lySheetCustom:clickedButtonAtIndex:)]) {
        [self.delegate lySheetCustom:self clickedButtonAtIndex:indexPath.row];
    }
}




/**
 触发layoutSubviews的情况：
    1、initWithFrame初始化，并且addSubview添加到视图上
    2、设置view的frame，前提保证frame的值前后不同
    3、滚动一个UIScrollView会触发layoutSubviews
    4、旋转Screen会触发父UIView上的layoutSubviews事件
    5、改变一个UIView大小的时候也会触发父UIView上的layoutSubviews事件
 */
- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
