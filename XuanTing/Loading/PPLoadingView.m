//
//  PPLoadingView.m
//  PatPat
//
//  Created by Yuan on 15/1/13.
//  Copyright (c) 2015年 http://www.patpat.com. All rights reserved.
//

#import "PPLoadingView.h"

@implementation PPLoadingView
@synthesize animationImageView;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initConfigure];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initConfigure];
    }
    return self;
}

- (void)initConfigure
{
    _hideAnimationDuration = kHideAnimationDuration;
    self.backgroundColor = [UIColor clearColor];
    [self addObserver];
}

- (void)hide
{
    [self hide:nil];
}

- (void)hide:(void(^)(BOOL finished))block
{
    [UIView animateWithDuration:_hideAnimationDuration animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (finished && block) {
            block(finished);
        }
    }];
}

#define degreesToRadians(x)(x * M_PI / 180)

+ (PPLoadingView *)showTo:(UIView *)view text:(NSString *)text
{
    PPLoadingView *loading=[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PPLoadingView class]) owner:self options:nil] lastObject];
    [loading restartAnimation];
    loading.textLbl.text = text;
    loading.textLbl.textColor = [UIColor darkGrayColor];
    loading.textLbl.textAlignment = NSTextAlignmentCenter;
    loading.textLbl.backgroundColor = [UIColor clearColor];
    [loading setFrame:view.bounds];
    [view addSubview:loading];
    return loading;
}

+ (PPLoadingView *)showTo:(UIView *)view
{
    return [self showTo:view text:@"Loading"];
}

- (void)restartAnimation
{
    [self.animationImageView.layer removeAnimationForKey:@"rotationAnimation"];
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * -2.0 ];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.repeatCount = 100000;
    [self.animationImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restartAnimation) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
