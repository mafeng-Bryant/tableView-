//
//  XTTabPageView.h
//  XuanTing
//
//  Created by patpat on 2018/1/23.
//  Copyright © 2018年 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XTTabPageView : UIView
@property (nonatomic, strong) id pageInfo;
@property (nonatomic, assign) NSInteger pageIndex;
- (id)initWithFrame:(CGRect)frame;
- (void)initViews;
- (void)setDataSourceClass:(NSString *)classString;

@end
