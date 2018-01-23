//
//  XTContainerCell.h
//  XuanTing
//
//  Created by patpat on 2018/1/22.
//  Copyright © 2018年 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTScrollView.h"

@protocol XTContainerCellDelegate

@optional
//横向滚动稳定设置
- (void)moveHorizontallyStableScrollViewDidScroll:(UIScrollView*)scrollView;

- (void)moveHorizontallyStableScrollViewDidEndDecelerating:(UIScrollView*)scrollView;

@end

@interface XTContainerCell : UITableViewCell

@property (nonatomic,strong) XTScrollView* scrollView;
@property (nonatomic,assign) BOOL isCanScroll;
@property (nonatomic,assign) BOOL isSelectIndex;
@property (nonatomic,weak) id<XTContainerCellDelegate>deleagte;

- (void)reloadDatas:(NSArray*)datas;

@end
