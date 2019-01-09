//
//  SKTableViewCell.h
//  TableViewCache
//
//  Created by lin kang on 19/12/18.
//  Copyright © 2018 lin kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKImageView.h"
#import <ZhuoZhuo/ZhuoZhuo.h>

@protocol SKTableViewCellDelegate<NSObject>

-(void)didTapTextAtIndex:(NSInteger)index  forRow:(NSInteger)row;

@end

NS_ASSUME_NONNULL_BEGIN

@interface SKTableViewCell : UITableViewCell

@property (nonatomic,assign) id<SKTableViewCellDelegate> delegate;

-(void)setCell:(ResponseModel *)model;

@end

NS_ASSUME_NONNULL_END
