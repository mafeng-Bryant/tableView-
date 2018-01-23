//
//  XTHomePageViewDataSource.m
//  XuanTing
//
//  Created by patpat on 2018/1/23.
//  Copyright © 2018年 test. All rights reserved.
//

#import "XTHomePageViewDataSource.h"
#import "Help.h"

@implementation XTHomePageViewDataSource

-(id)initWithTableView:(UITableView *)tableView
{
    self = [super initWithTableView:tableView];
    if (self) {
        
    }
    return self;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.isCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    //如果当前tableview无法滚动，那么外面大的tableView就能滚动
    if (scrollView.contentOffset.y<=0) {
        self.isCanScroll = NO;
        scrollView.contentOffset = CGPointZero;
        [[NSNotificationCenter defaultCenter] postNotificationName:kLeaveTopName object:nil];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第1页————这是第 %@ 行",@(indexPath.row)];
    return cell;
}

- (void)requestDatas:(id)params finished:(void(^)(BOOL result))block
{
    [self.tableView reloadData];
    block(YES);

}


@end
