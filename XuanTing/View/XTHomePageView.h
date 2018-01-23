//
//  XTHomePageView.h
//  XuanTing
//
//  Created by patpat on 2018/1/23.
//  Copyright © 2018年 test. All rights reserved.
//

#import "XTTabPageView.h"
#import "XTHomePageViewDataSource.h"

@interface XTHomePageView : XTTabPageView

@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) XTHomePageViewDataSource* dataSource;
@property (nonatomic,strong) id object;

@end
