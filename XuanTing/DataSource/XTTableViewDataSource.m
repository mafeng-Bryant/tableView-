//
//  XTTableViewDataSource.m
//  XuanTing
//
//  Created by patpat on 2018/1/23.
//  Copyright © 2018年 test. All rights reserved.
//

#import "XTTableViewDataSource.h"

@implementation XTTableViewDataSource

- (id)initWithTableView:(UITableView *)tableView
{
    self = [super init];
    if (self) {
        _isLoadingMore = NO;
        self.isRequesting = NO;
        [self setTableView:tableView];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return self;
}

- (void)enablePullRefresh
{
    [self.tableView addSubview:self.headerRefreshControl];
}

- (void)enableLoadMore
{
    [self.tableView addSubview:self.footerRefreshControl];
}

- (BOOL)isEmpty
{
    return _dataSource.count>0?NO:YES;
}

#pragma mark setter and getter

- (void)setTableView:(UITableView *)tableView
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    [_dataSource removeAllObjects];
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView reloadData];
}

- (void)destroy
{
    [_dataSource removeAllObjects];
    [_tableView reloadData];
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    _tableView = nil;
}

#pragma mark Request
- (void)requestDatas:(id)params
            finished:(void(^)(BOOL result))block
{
    //rewrite subclass
}

- (void)refreshRequest:(void(^)(BOOL result))block
{
    //rewrite subclass
}

- (void)loadMoreRequest:(void(^)(BOOL result))block
{
    //rewrite subclass
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark  UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger lastSectionIndex = [tableView numberOfSections] - 1;
    NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex] - 1;
    if ((indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex)) {
        [_footerRefreshControl beginRefreshing];
    }
}

#pragma mark - Getters and setters

- (PPRefreshHeaderControl *)headerRefreshControl
{
    if (!_headerRefreshControl) {
        _headerRefreshControl = [[PPRefreshHeaderControl alloc]init];
        [_headerRefreshControl addTarget:self action:@selector(pullRefresh) forControlEvents:UIControlEventValueChanged];
    }
    return _headerRefreshControl;
}

- (PPRefreshFooterControl *)footerRefreshControl
{
    if (!_footerRefreshControl) {
        _footerRefreshControl = [[PPRefreshFooterControl alloc]init];
        [_footerRefreshControl addTarget:self action:@selector(loadMoreRefresh) forControlEvents:UIControlEventValueChanged];
    }
    return _footerRefreshControl;
}

- (void)loadMoreRefresh
{
    [self loadMoreRequest:^(BOOL result) {
        if (result) {
            [_footerRefreshControl endRefreshing];
        }
    }];
}

- (void)pullRefresh
{
    [self refreshRequest:^(BOOL result) {
        [_headerRefreshControl endRefreshing];
    }];
}

@end
