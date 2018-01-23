//
//  XTContainerCell.m
//  XuanTing
//
//  Created by patpat on 2018/1/22.
//  Copyright © 2018年 test. All rights reserved.
//

#import "XTContainerCell.h"
#import "FirstTableViewController.h"
#import "SecondTableViewController.h"
#import "ThirdTableViewController.h"

#define kHeight [UIScreen mainScreen].bounds.size.height - 64.0 - 60


@interface XTContainerCell ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) FirstTableViewController *oneVC;
@property (nonatomic, strong) SecondTableViewController *twoVC;
@property (nonatomic, strong) ThirdTableViewController *threeVC;

@end

@implementation XTContainerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.scrollView];
        [self configScrollView];
    }
    return self;
}

- (void)configScrollView
{
    self.oneVC = [[FirstTableViewController alloc]init];
    self.twoVC = [[SecondTableViewController alloc]init];
    self.threeVC = [[ThirdTableViewController alloc]init];
    
    [self.scrollView addSubview:self.oneVC.view];
    [self.scrollView addSubview:self.twoVC.view];
    [self.scrollView addSubview:self.threeVC.view];

    self.oneVC.view.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, kHeight);
    self.twoVC.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, kHeight);
    self.threeVC.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * 2, 0, [UIScreen mainScreen].bounds.size.width, kHeight);

}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kHeight)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * 3, _scrollView.frame.size.height);
    }
    return _scrollView;
}

-(void)setIsCanScroll:(BOOL)isCanScroll
{
    _isCanScroll = isCanScroll;
    self.oneVC.vcCanScroll = isCanScroll;
    self.twoVC.vcCanScroll = isCanScroll;
    self.threeVC.vcCanScroll = isCanScroll;
    if (!isCanScroll) {
        [self.oneVC.tableView setContentOffset:CGPointZero animated:NO];
        [self.twoVC.tableView setContentOffset:CGPointZero animated:NO];
        [self.threeVC.tableView setContentOffset:CGPointZero animated:NO];
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
