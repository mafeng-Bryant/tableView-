//
//  XTTableViewDataSource.h
//  XuanTing
//
//  Created by patpat on 2018/1/23.
//  Copyright © 2018年 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PPRefreshHeaderControl.h"
#import "PPRefreshFooterControl.h"

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)]?CGSizeEqualToSize(CGSizeMake(1125, 2436),[[UIScreen mainScreen]currentMode].size):NO)

@interface XTTableViewDataSource : NSObject<UITableViewDataSource,UITableViewDelegate>
{
    BOOL _isLoadingMore;
    BOOL _isDragging;
}
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic,assign)UITableView *tableView;
@property(nonatomic,strong)PPRefreshFooterControl *footerRefreshControl;
@property(nonatomic,strong)PPRefreshHeaderControl *headerRefreshControl;
@property (nonatomic,assign)BOOL isRequesting;
- (void)enablePullRefresh;
- (void)enableLoadMore;
- (void)requestDatas:(id)params finished:(void(^)(BOOL result))block;
- (void)refreshRequest:(void(^)(BOOL result))block;
- (void)loadMoreRequest:(void(^)(BOOL result))block;
- (id)initWithTableView:(UITableView *)tableView;
- (void)destroy;
- (BOOL)isEmpty;
@end


