//
//  XTSegmentView.m
//  XuanTing
//
//  Created by patpat on 2018/1/22.
//  Copyright © 2018年 test. All rights reserved.
//

#import "XTSegmentView.h"

@implementation XTSegmentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [self addSubview:self.segmentControl];
    }
    return self;
}

- (HMSegmentedControl *)segmentControl {
    if (!_segmentControl) {
        NSArray *titles = @[@"page 1",@"page 2",@"page 3"];
        _segmentControl = [[HMSegmentedControl alloc] initWithSectionTitles:titles];
        _segmentControl.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60);
        _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentControl.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _segmentControl.selectionIndicatorHeight = 1.5f;
        _segmentControl.selectionIndicatorColor = [UIColor redColor];
         NSDictionary *attributesNormal = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PingFangSC-Regular" size:14],NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName,nil];
        NSDictionary *attributesSelected = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PingFangSC-Semibold" size:14],NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName,nil];
        _segmentControl.titleTextAttributes = attributesNormal;
        _segmentControl.selectedTitleTextAttributes = attributesSelected;
    }
    return _segmentControl;
}


@end
