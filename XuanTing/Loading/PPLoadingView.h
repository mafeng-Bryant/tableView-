//
//  PPLoadingView.h
//  PatPat
//
//  Created by Yuan on 15/1/13.
//  Copyright (c) 2015年 http://www.patpat.com. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const kHideAnimationDuration = 0.25;

@interface PPLoadingView : UIView

@property(nonatomic,strong)IBOutlet UIImageView *animationImageView;
@property(nonatomic,strong)IBOutlet UILabel *textLbl;
@property(nonatomic,readonly)CGFloat hideAnimationDuration;

- (void)restartAnimation;

- (void)hide;

- (void)hide:(void(^)(BOOL finished))block;

+ (PPLoadingView *)showTo:(UIView *)view;
+ (PPLoadingView *)showTo:(UIView *)view text:(NSString *)text;

@end
