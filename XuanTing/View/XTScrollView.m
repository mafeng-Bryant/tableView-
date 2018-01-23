//
//  XTScrollView.m
//  XuanTing
//
//  Created by patpat on 2018/1/23.
//  Copyright © 2018年 test. All rights reserved.
//

#import "XTScrollView.h"
#import <Masonry.h>

#define kTabPageOffsetTag(x) (x+10000)
#define kConditionTabPageOffsetTag(x) (x+20000)

@implementation XTScrollView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUI];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentSize = CGSizeMake(self.frame.size.width*_totalPage,self.frame.size.height);
}

- (void)setUI
{
    _currentPage = 0;
    _totalPage = 0;
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    [self.panGestureRecognizer addTarget:self action:@selector(scrollHandlePan:)];
    self.bounces = NO;
    _pageViews = [NSMutableArray array];
}

- (void)loadPage:(NSInteger)page
            info:(id)info
{
    if (self.pageDataSource) {

        XTTabPageView *pageView = [self.pageDataSource pageScrollView:self atPage:page];
   //     [self setColor:page view:pageView];
        pageView.tag = kTabPageOffsetTag(page);
        pageView.pageInfo = info;
        pageView.pageIndex = page;
        [self addSubview:pageView];
        [_pageViews addObject:pageView];
        [pageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.mas_width);
            make.top.equalTo(self.mas_bottom).with.offset(0);
            make.left.equalTo(self.mas_left).with.offset([UIScreen mainScreen].bounds.size.width*page);
            make.height.equalTo(self.mas_height).with.offset(0);
        }];
        if (page == _currentPage) {
            //load default page data
            [self scrollToPage:page animated:NO];
        }
    }
}

- (void)setColor:(NSInteger)page view:(UIView*)view
{
    switch (page) {
        case 0:
            view.backgroundColor = [UIColor redColor];
            break;
        case 1:
            view.backgroundColor = [UIColor yellowColor];
            break;
        case 2:
            view.backgroundColor = [UIColor greenColor];
            break;
        case 3:
            view.backgroundColor = [UIColor cyanColor];
            break;
        case 4:
            view.backgroundColor = [UIColor purpleColor];
            break;
        case 5:
            view.backgroundColor = [UIColor blueColor];
            break;
        default:
            break;
    }
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return YES;
}

-(void)scrollHandlePan:(UIPanGestureRecognizer*) panGes
{
    static CGFloat startX;
    static CGFloat lastX;
    static CGFloat durationX;
    CGPoint touchPoint = [panGes locationInView:[[UIApplication sharedApplication] keyWindow]];
    if (panGes.state == UIGestureRecognizerStateBegan){
        startX = touchPoint.x;
        lastX = touchPoint.x;
    }else if (panGes.state == UIGestureRecognizerStateChanged){
        CGFloat currentX = touchPoint.x;
        durationX = currentX - lastX;
        lastX = currentX;
        if (durationX>0&& self.contentOffset.x<=0) {
            //判断是否到左边边界
            if (self.pageDelegate && [self.pageDelegate respondsToSelector:@selector(scrollToLeadingEdge:)]) {
                [self.pageDelegate scrollToLeadingEdge:self];
            }
        }
    }
}

#pragma mark - UIScrollViewDelegate

// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _lastContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.pageDelegate && [self.pageDelegate respondsToSelector:@selector(pageScrollViewScrolling:direction:)]) {
        ScrollviewDicrection directon;
        if (_lastContentOffsetX > scrollView.contentOffset.x){
            directon = ScrollviewDicrectionLeft;
        }else if(_lastContentOffsetX < scrollView.contentOffset.x){
            directon = ScrollviewDicrectionRight;
        }
        [self.pageDelegate pageScrollViewScrolling:self direction:directon];
    }
    _lastContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //page from 0
    NSInteger currentPage = (scrollView.contentOffset.x  + scrollView.frame.size.width )/ scrollView.frame.size.width-1;
    currentPage = MAX(currentPage,0);
    
    //page scrolled to page
    if (self.pageDelegate && [self.pageDelegate respondsToSelector:@selector(pageScrollViewStoped:scrollToPage:)]) {
        [self.pageDelegate pageScrollViewStoped:self scrollToPage:currentPage];
    }
    if (currentPage==_currentPage) {
        return;
    }
    _currentPage = currentPage;
    
    XTTabPageView *pageView = (XTTabPageView *)[self viewWithTag:kTabPageOffsetTag(_currentPage)];
    if (pageView && [pageView isKindOfClass:[UIView class]]) {
        //should reload data
        if (self.pageDelegate && [self.pageDelegate respondsToSelector:@selector(pageScrollView:shouldReloadPageView:atPage:)]) {
            [self.pageDelegate pageScrollView:self shouldReloadPageView:pageView atPage:_currentPage];
        }
    }
}

- (void)loadPageViewData
{
    XTTabPageView *pageView = (XTTabPageView *)[self viewWithTag:kTabPageOffsetTag(_currentPage)];
    if (pageView && [pageView isKindOfClass:[UIView class]]) {
        if (self.pageDelegate && [self.pageDelegate respondsToSelector:@selector(pageScrollView:shouldReloadPageView:atPage:)]) {
            [self.pageDelegate pageScrollView:self shouldReloadPageView:pageView atPage:_currentPage];
        }
    }
}

#pragma mark Public methords

- (XTTabPageView *)tabPageViewWithPage:(NSInteger)page
{
    XTTabPageView *pageView = (XTTabPageView *)[self viewWithTag:kTabPageOffsetTag(page)];
    return pageView;
}

- (XTTabPageView *)currentTabPageView
{
    return [self tabPageViewWithPage:_currentPage];
}

- (void)setDefaultSelectedPage:(NSInteger)page
{
    _currentPage = page;
}

- (void)scrollToPage:(NSInteger)page
{
    [self scrollToPage:page animated:YES];
}

- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated
{
    NSInteger _page = MIN(MAX(page,0),_totalPage);
    _currentPage = _page;
    self.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*_totalPage, 0);
    [self setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width*_currentPage,0) animated:YES];
    [self loadPageViewData];
}

- (void)reloadData:(NSArray *)items
{
    for (UIView *view in self.subviews) {
        if (view && [view isKindOfClass:[XTTabPageView class]]) {
            ((XTTabPageView*)view).pageInfo = nil;
        }
    }
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _totalPage = items.count>0?items.count:0;
    for (NSInteger page = 0; page < _totalPage; page++) {
        [self loadPage:page info:items[page]];
    }
    
}





@end
