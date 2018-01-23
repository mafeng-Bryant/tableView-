//
//  XTPosterCell.m
//  XuanTing
//
//  Created by patpat on 2018/1/22.
//  Copyright © 2018年 test. All rights reserved.
//

#import "XTPosterCell.h"

@interface XTPosterCell ()

@property (nonatomic, strong) UIImageView *posterImgView;

@end


@implementation XTPosterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.posterImgView];
    }
    return self;
}

- (UIImageView *)posterImgView {
    if (!_posterImgView) {
        _posterImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 250)];
        _posterImgView.image = [UIImage imageNamed:@"me"];
    }
    return _posterImgView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
