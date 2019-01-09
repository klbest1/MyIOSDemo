//
//  SKTableViewCell.m
//  TableViewCache
//
//  Created by lin kang on 19/12/18.
//  Copyright © 2018 lin kang. All rights reserved.
//

#import "SKTableViewCell.h"
#import "SKDownLoadImageCacheHelper.h"

@interface SKTableViewCell()<UITextViewDelegate>
{
    SKImageView *_headImageView;
    UILabel *_titleLabel;
    UITextView *_detailTextView;
    ResponseModel *_model;
    NSMutableArray *_touchTextRanges;
}

@end

@implementation SKTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        if (_headImageView == nil) {
            _headImageView = [SKImageView new];
        }
        
        if (_titleLabel == nil) {
            _titleLabel = [UILabel new];
            _titleLabel.font = [UIFont systemFontOfSize:18];
            _titleLabel.textColor = [UIColor blackColor];
        }
        
        if (_detailTextView == nil) {
            _detailTextView = [UITextView new];
            _detailTextView.textColor = [UIColor darkGrayColor];
            _detailTextView.font = [UIFont systemFontOfSize:14];
            _detailTextView.editable = false;
            _detailTextView.scrollEnabled = false;
            _detailTextView.delegate = self;
        }
        
        if (_touchTextRanges == nil) {
            _touchTextRanges = [NSMutableArray array];
        }
        
        [self.contentView addSubview:_headImageView];
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_detailTextView];

    }
    return  self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setCell:(ResponseModel *)model{
    _model = model;
    _titleLabel.text = model.Title;
    _headImageView.uuID = model.ImageUrl;
    _headImageView.image = nil;
    [[SKDownLoadImageCacheHelper helper] downloadWithUUID:model.ImageUrl url:model.ImageUrl container:_headImageView];
    
    [_touchTextRanges removeAllObjects];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:model.Context];
   
    //添加链接响应
    for (ClickInfo *touchInfo in model.ClickInfoList) {
        NSRange range = [model.Context rangeOfString:touchInfo.TargetString];
        [attributedString addAttribute:NSLinkAttributeName
                                 value:touchInfo.Url
                                 range:range];
    }
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:14]
                             range:NSMakeRange(0, attributedString.length)];
    NSDictionary *linkAttributes = @{NSForegroundColorAttributeName: [UIColor blueColor],
                                     NSUnderlineColorAttributeName: [UIColor lightGrayColor],
                                      NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)
                                     };
    _detailTextView.linkTextAttributes = linkAttributes;
    _detailTextView.attributedText = attributedString;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    _titleLabel.frame = CGRectMake(20 , 20,[UIScreen mainScreen].bounds.size.width - 30, 20);
    _detailTextView.frame = CGRectMake(15, CGRectGetMaxY(_titleLabel.frame) + 10, [UIScreen mainScreen].bounds.size.width  - 30, 20 );
     [_detailTextView sizeToFit];
    CGSize detailSize = _detailTextView.frame.size;
    _detailTextView.frame = CGRectMake(15, CGRectGetMaxY(_titleLabel.frame) + 10, [UIScreen mainScreen].bounds.size.width - 30, detailSize.height );
   _headImageView.frame =  CGRectMake(20, CGRectGetMaxY(_detailTextView.frame), _model.ImageSizeInfo.Width, _model.ImageSizeInfo.Height);
}

-(NSInteger)findTargetIndex:(NSString *)touchingContent{
    NSInteger index = 0;
    for (ClickInfo *info in _model.ClickInfoList){
        if ([info.Url isEqualToString:touchingContent]) {
            return index;
        }
        index += 1;
    }
    
    return -1;
}


- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction{
    
    NSInteger index = [self findTargetIndex:URL.absoluteString];
    if ([_delegate respondsToSelector:@selector(didTapTextAtIndex:forRow:)]) {
        [_delegate didTapTextAtIndex:index forRow:self.tag];
    }
    return NO; // let the system open this UR
}
@end
