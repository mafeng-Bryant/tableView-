//
//  XTContainerCell.m
//  XuanTing
//
//  Created by patpat on 2018/1/22.
//  Copyright © 2018年 test. All rights reserved.
//

#import "XTContainerCell.h"
#import "XTHomePageView.h"

#define kHeight [UIScreen mainScreen].bounds.size.height - 64.0 - 60

@interface XTContainerCell ()<UIScrollViewDelegate>

@end

@implementation XTContainerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.scrollView];
    }
    return self;
}

- (XTScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[XTScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kHeight)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}

- (void)reloadDatas:(NSArray*)datas
{
    if (_scrollView && datas.count>0) {
        [_scrollView reloadData:datas];
    }
}

-(void)setIsCanScroll:(BOOL)isCanScroll
{
    _isCanScroll = isCanScroll;
    for (XTHomePageView* pageView in _scrollView.pageViews) {
        pageView.dataSource.isCanScroll = _isCanScroll;
        if (!_isCanScroll) {
             [pageView.tableView setContentOffset:CGPointZero animated:NO];
        }
    }
}

#pragma mark XTContainerCellDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //没有点击tab情况下
    if (!self.isSelectIndex) {
        if (scrollView == _scrollView) {
            if (self.deleagte) {
                [self.deleagte moveHorizontallyStableScrollViewDidScroll:scrollView];
            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isSelectIndex = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView) {
        if (self.deleagte) {
            [self.deleagte moveHorizontallyStableScrollViewDidEndDecelerating:scrollView];
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
