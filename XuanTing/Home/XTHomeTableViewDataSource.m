//
//  XTHomeTableViewDataSource.m
//  XuanTing
//
//  Created by patpat on 2018/1/23.
//  Copyright © 2018年 test. All rights reserved.
//

#import "XTHomeTableViewDataSource.h"
#import "XTPosterCell.h"
#import "XTDescptionCell.h"
#import "XTContainerCell.h"
#import "XTSegmentView.h"
#import "Help.h"
#import "XTHomePageView.h"
#import "XTScrollView.h"
#import "XTHomePageViewDataSource.h"
#import "PPLoadingView.h"

@interface XTHomeTableViewDataSource()<XTContainerCellDelegate,PPTabPageScrollViewDataSource,PPTabPageScrollViewDelegate>
@property (nonatomic,strong) XTContainerCell* containerCell;
@property (nonatomic,assign) BOOL canScroll;
@property (nonatomic,strong) XTSegmentView* segmentView;

@end

@implementation XTHomeTableViewDataSource

-(id)initWithTableView:(UITableView *)tableView
{
    self = [super initWithTableView:tableView];
    if (self) {
        tableView.backgroundColor = [UIColor clearColor];
        tableView.rowHeight =  UITableViewAutomaticDimension;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.estimatedRowHeight = 44;
        self.tableView = tableView;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollStatus) name:kLeaveTopName object:nil];
        self.canScroll = YES;
    }
    return self;
}

- (void)changeScrollStatus
{
    self.canScroll = YES;
    self.containerCell.isCanScroll = NO;
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    if (scrollView == self.tableView) {
        CGFloat offset = 64;
        if (iPhoneX) {
            offset = 88;
        }
        //控制外层tableview滚动的最大高度
        CGFloat sectionOffsetY = [self.tableView rectForSection:1].origin.y;
        CGFloat maxY = sectionOffsetY - offset;
        if (scrollView.contentOffset.y > maxY) { //已经到顶部
            self.tableView.contentOffset = CGPointMake(0, maxY);
            if (self.canScroll) {
                self.canScroll = NO;
                self.containerCell.isCanScroll = YES;
            }
        }else {
            if (!self.canScroll) {
                scrollView.contentOffset = CGPointMake(0, maxY);
            }
        }
    }
}
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 1;
}

// 由于Demo中几个cell个数有限且全部不一样，所以这儿不用重用机制
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 海报
            XTPosterCell *cell = [[XTPosterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"posterCell"];
            return cell;
        }
        // 简介
        XTDescptionCell *cell = [[XTDescptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"descCell"];
        return cell;
    }
    // 重点！横向滑动cell
    XTContainerCell *cell = [[XTContainerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"containerCell"];
    self.containerCell = cell;
    cell.scrollView.pageDataSource = self;
    cell.scrollView.pageDelegate = self;
    cell.deleagte = self;
    [cell reloadDatas:@[@1,@2,@3,@4,@5,@6]];
    return cell;
}
#pragma mark  UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 250;
        }
        return 60;
    }
    return [UIScreen mainScreen].bounds.size.height - 64 - 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.segmentView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01f;
    }
    return 60;
}

//横向滚动稳定设置
- (void)moveHorizontallyStableScrollViewDidScroll:(UIScrollView*)scrollView
{
    self.tableView.scrollEnabled = NO;
}

- (void)moveHorizontallyStableScrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    NSUInteger page = scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    [self.segmentView.segmentControl setSelectedSegmentIndex:page animated:YES];
    self.tableView.scrollEnabled = YES;
}

#pragma mark - Init Views

- (XTSegmentView *)segmentView {
    if (!_segmentView) {
        _segmentView = [[XTSegmentView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
        __weak typeof(self) weakSelf = self;
        [_segmentView.segmentControl setIndexChangeBlock:^(NSInteger index) {
            weakSelf.containerCell.isSelectIndex = YES;
            [weakSelf.containerCell.scrollView setContentOffset:CGPointMake(index*[UIScreen mainScreen].bounds.size.width, 0) animated:YES];
        }];
    }
    return _segmentView;
}

#pragma mark PPTabPageScrollViewDataSource

- (UIView *)pageScrollView:(XTScrollView *)scrollView
                           atPage:(NSInteger )page
{
    XTHomePageView* pageView = [[XTHomePageView alloc]initWithFrame:CGRectZero];
    return pageView;
}

#pragma mark PPTabPageScrollViewDelegate


- (void)pageScrollView:(XTScrollView *)scrollView
  shouldReloadPageView:(XTTabPageView *)pageView
                atPage:(NSInteger)page
{
    if (pageView && [pageView isKindOfClass:[XTHomePageView class]]) {
       XTHomePageView *_pageView = (XTHomePageView *)pageView;
        if (_pageView.pageInfo) {
            NSNumber* number = (NSNumber*)_pageView.pageInfo;
            XTTableViewDataSource* _dataSource = _pageView.dataSource;
            if (!_dataSource) {
               NSString *classString = NSStringFromClass([XTHomePageViewDataSource class]);
                [_pageView setDataSourceClass:classString];
                _dataSource = _pageView.dataSource;
           }
            if (!_dataSource.isEmpty) {
                return;
            }
            PPLoadingView* loading = [PPLoadingView showTo:_pageView];
            [_dataSource requestDatas:number finished:^(BOOL result) {
                [loading hide];
            }];
        }
    }
}


@end
