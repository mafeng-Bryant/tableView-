//
//  RootViewController.m
//  XuanTing
//
//  Created by patpat on 2018/1/22.
//  Copyright © 2018年 test. All rights reserved.
//

#import "RootViewController.h"
#import "XTSegmentView.h"
#import "XTPosterCell.h"
#import "XTDescptionCell.h"
#import "XTContainerCell.h"
#import "Help.h"

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)]?CGSizeEqualToSize(CGSizeMake(1125, 2436),[[UIScreen mainScreen]currentMode].size):NO)

@interface RootViewController ()<XTContainerCellDelegate>
@property (nonatomic,strong) XTSegmentView* segmentView;
@property (nonatomic,strong) XTContainerCell* containerCell;
@property (nonatomic,assign) BOOL canScroll;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"联动Demo";
     self.canScroll = YES;
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollStatus) name:kLeaveTopName object:nil];
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

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
    cell.deleagte = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 250;
        }
        return 60;
    }
    return self.view.frame.size.height - 64 - 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.segmentView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01f;
    }
    return 60.0f;
}

#pragma mark - Init Views

- (XTSegmentView *)segmentView {
    if (!_segmentView) {
        _segmentView = [[XTSegmentView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
        __weak typeof(self) weakSelf = self;
        [_segmentView.segmentControl setIndexChangeBlock:^(NSInteger index) {
            weakSelf.containerCell.isSelectIndex = YES;
            [weakSelf.containerCell.scrollView setContentOffset:CGPointMake(index*[UIScreen mainScreen].bounds.size.width, 0) animated:YES];
        }];
    }
    return _segmentView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
