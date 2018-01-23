//
//  XTTabPageView.m
//  XuanTing
//
//  Created by patpat on 2018/1/23.
//  Copyright © 2018年 test. All rights reserved.
//

#import "XTTabPageView.h"

@implementation XTTabPageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)initViews{
    //rewrite subclass
}

- (void)setDataSourceClass:(NSString *)classString
{
    //rewrite subclass
}
@end
