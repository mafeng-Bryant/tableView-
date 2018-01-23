//
//  XTDescptionCell.m
//  XuanTing
//
//  Created by patpat on 2018/1/22.
//  Copyright © 2018年 test. All rights reserved.
//

#import "XTDescptionCell.h"

@interface XTDescptionCell ()

@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation XTDescptionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor cyanColor];
        [self.contentView addSubview:self.descLabel];
    }
    return self;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width, 60)];
        _descLabel.text = @"自定义行";
    }
    return _descLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
