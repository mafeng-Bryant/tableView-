//
//  XTScrollView.h
//  XuanTing
//
//  Created by patpat on 2018/1/23.
//  Copyright © 2018年 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTTabPageView.h"

typedef enum {
    ScrollviewDicrectionRight, //to right
    ScrollviewDicrectionLeft   //to left
}ScrollviewDicrection;

@protocol PPTabPageScrollViewDataSource,PPTabPageScrollViewDelegate;

@interface XTScrollView : UIScrollView<UIScrollViewDelegate>
{
    CGFloat _lastContentOffsetX;
    NSInteger _totalPage;
}
@property(nonatomic,readonly) NSInteger currentPage;
@property (nonatomic,assign)id<PPTabPageScrollViewDataSource>pageDataSource;
@property (nonatomic,assign)id<PPTabPageScrollViewDelegate>pageDelegate;
@property (nonatomic,strong) NSMutableArray* pageViews;

//重新加载数据
- (void)reloadData:(NSArray *)items;

//设置默认所在页面
- (void)setDefaultSelectedPage:(NSInteger)page;

//滚动到page页面
- (void)scrollToPage:(NSInteger)page;

- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated;

//获取page页面的view
- (XTTabPageView *)currentTabPageView;
- (XTTabPageView *)tabPageViewWithPage:(NSInteger)page;

@end

@protocol PPTabPageScrollViewDataSource <NSObject>

@required

- (XTTabPageView *)pageScrollView:(XTScrollView *)scrollView
                           atPage:(NSInteger )page;

@end

@protocol PPTabPageScrollViewDelegate <NSObject>

@optional

- (void)pageScrollViewScrolling:(XTScrollView *)scrollView
                      direction:(ScrollviewDicrection)direction;


/**
 *  tabpage停止滚动的时候调用此回调
 *
 *  @param scrollView PPTabPageScrollView对象
 *  @param page       滚动到了page页码
 */
- (void)pageScrollViewStoped:(XTScrollView *)scrollView
                scrollToPage:(NSInteger )page;


/**
 *  tabpage滚动到page页面，可以通知pageview做刷新数据等操作
 *
 *  @param scrollView PPTabPageScrollView对象
 *  @param pageView   滚动到的pageview
 *  @param page       页码
 */
- (void)pageScrollView:(XTScrollView *)scrollView
  shouldReloadPageView:(XTTabPageView *)pageView
                atPage:(NSInteger)page;

/**
 *  scrollview滚动到左边的边界
 *
 *  @param scrollView PPTabPageScrollView对象
 */
- (void)scrollToLeadingEdge:(XTScrollView *)scrollView;

@end
