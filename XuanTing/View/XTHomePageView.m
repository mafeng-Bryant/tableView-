//
//  XTHomePageView.m
//  XuanTing
//
//  Created by patpat on 2018/1/23.
//  Copyright © 2018年 test. All rights reserved.
//

#import "XTHomePageView.h"
#import <Masonry.h>
#import "Help.h"
#import "XTTableView.h"

@implementation XTHomePageView

-(void)initViews
{
    if (!_tableView) {
        _tableView = [[XTTableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.pagingEnabled = YES;
        _tableView.rowHeight =  UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_tableView];
    }
}

- (void)setTableViewFrame
{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).with.offset(0);
        make.top.mas_equalTo(self.mas_top).with.offset(0);
        make.right.mas_equalTo(self.mas_right).with.offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(0);
    }];
}

- (void)setDataSourceClass:(NSString *)classString
{
    if (!_dataSource) {
        [self initViews];
        _dataSource = [[NSClassFromString(classString) alloc]initWithTableView:self.tableView];
        [self setTableViewFrame];
    }
}

@end
