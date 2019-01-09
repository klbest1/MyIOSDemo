//
//  ViewController.m
//  TableViewCache
//
//  Created by lin kang on 19/12/18.
//  Copyright © 2018 lin kang. All rights reserved.
//

#import "ViewController.h"
#import <ZhuoZhuo/ZhuoZhuo.h>
#import "SKTableViewCell.h"
#import "DetailViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,SKTableViewCellDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataSource;
    NSMutableArray *hightArray;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if (_tableView == nil) {
        _tableView = [UITableView new];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    _tableView.frame = self.view.bounds;
    [self.view addSubview:_tableView];
    
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    //数据源
    NSMutableArray *tempDataSourceArray = [RdTestGetResource__NotAllowedInMainThread() copy];
    [_dataSource addObjectsFromArray:tempDataSourceArray];
    [_dataSource addObjectsFromArray:tempDataSourceArray];
    [_dataSource addObjectsFromArray:tempDataSourceArray];

    //计算cell高度
    if (hightArray == nil) {
        hightArray = [NSMutableArray array];
    }
    
    NSMutableArray *tempHihgtArray = [NSMutableArray array];
    for (ResponseModel *model  in _dataSource){
        CGFloat height = model.ImageSizeInfo.Height + 70 ;
        UITextView *detailTextView = [UITextView new];
        detailTextView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width  - 30, 20);
        detailTextView.font = [UIFont systemFontOfSize:14];
        detailTextView.text = model.Context;
        [detailTextView sizeToFit];
        height += detailTextView.bounds.size.height ;
        [tempHihgtArray addObject:@(height)];
    }
    [hightArray addObjectsFromArray:tempHihgtArray];
    [hightArray addObjectsFromArray:tempHihgtArray];
    [hightArray addObjectsFromArray:tempHihgtArray];

}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"myCell";
    SKTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[SKTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.delegate = self;
    }
    cell.tag = indexPath.row;
    [cell setCell:[_dataSource objectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = [[hightArray objectAtIndex:indexPath.row] floatValue];
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)didTapTextAtIndex:(NSInteger)index forRow:(NSInteger)row{
    NSLog(@"indexTouched:%ld,atRow:%ld",(long)index,(long)row);
    ResponseModel *model = [_dataSource objectAtIndex:row];
    ClickInfo *clickInfo = [model.ClickInfoList objectAtIndex:index];
    DetailViewController *detailVC = [DetailViewController new];
    detailVC.detailURL = [NSURL URLWithString:clickInfo.Url];
    [self.navigationController pushViewController:detailVC animated:true];
}
@end
