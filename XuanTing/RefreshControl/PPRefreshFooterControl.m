//
//  PPRefreshFooterControl.m
//  PatPat
//
//  Created by Bruce He on 15/7/25.
//  Copyright (c) 2015年 http://www.patpat.com. All rights reserved.
//
#import <UIKit/UIKit.h>


static CGFloat const   kRefreshControlHeight    = 50.0f;
static CGFloat const   kAnimateWithDuration     = 0.15;

#import "PPRefreshFooterControl.h"

@implementation PPRefreshFooterControl

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
    self.backgroundColor = [UIColor clearColor];
    self.hidden = YES;
    self.enabled = YES;
    _titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(107,12, 145, 21)];
    [_titleLbl setText:@"more"];
    [_titleLbl setTextColor:[UIColor blackColor]];
    [_titleLbl setBackgroundColor:[UIColor clearColor]];
    [_titleLbl setTextAlignment:NSTextAlignmentCenter];
//    [_titleLbl setFont:PPF2];
    [self addSubview:_titleLbl];
    [_titleLbl sizeToFit];
    
    _animationImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20.0, 20.0)];
    _animationImageView.image = [UIImage imageNamed:@"loading_gray"];
    [self addSubview:_animationImageView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startAnimation) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!_scrollView && newSuperview  && [newSuperview isKindOfClass:[UIScrollView class]]) {
        _scrollView = (UIScrollView *)newSuperview;
        self.frame = CGRectMake(0, 0, _scrollView.frame.size.width, kRefreshControlHeight);
        _scrollViewInitInset = _scrollView.contentInset;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _titleLbl.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGRect rect = _animationImageView.frame;
    rect.origin.x = _titleLbl.frame.origin.x-10-_animationImageView.frame.size.width;
    rect.origin.y = (self.frame.size.height - _animationImageView.frame.size.height)/2.0;
    _animationImageView.frame = rect;
}

- (void)startAnimation
{
    if (self.hidden) {
        return;
    }
    CABasicAnimation* rotationAnimation = (CABasicAnimation *)[_animationImageView.layer animationForKey:@"rotationAnimation"];
    if (!rotationAnimation) {
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * -2.0 ];
        rotationAnimation.duration = 1;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = 100000;
        rotationAnimation.removedOnCompletion = NO;
        [_animationImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }
}

- (void)endAnimation
{
    [UIView animateWithDuration:kAnimateWithDuration animations:^{
        self.alpha = 0.0;
    }completion:^(BOOL finished) {
        [_animationImageView.layer removeAnimationForKey:@"rotationAnimation"];
        _isLoading = NO;
        self.hidden = YES;
    }];
}

- (void)adjustFrame:(CGSize)size block:(void(^)())block
{
    if (!CGSizeEqualToSize(_lastContentSize, size)) {
        _lastContentSize = size;
        CGFloat contentHeight = _scrollView.contentSize.height;
        CGFloat scrollHeight = _scrollView.frame.size.height - _scrollViewInitInset.top - _scrollViewInitInset.bottom;
        CGFloat y = MAX(contentHeight, scrollHeight);
        self.frame = CGRectMake(0, y, _scrollView.frame.size.width, kRefreshControlHeight);
        UIEdgeInsets inset = _scrollViewInitInset;
        inset.bottom = kRefreshControlHeight;
        [UIView animateWithDuration:kAnimateWithDuration animations:^{
            _scrollView.contentInset = inset;
        }completion:^(BOOL finished) {
            if (block) {
                block();
            }
        }];
    }else{
        if (block) {
            block();
        }
    }
}

#pragma mark - Public methord

- (void)beginRefreshing
{
    if (_isLoading || !self.enabled || !self.hidden) {
        if (!self.enabled && _scrollView && !UIEdgeInsetsEqualToEdgeInsets(_scrollView.contentInset, _scrollViewInitInset)) {
            [UIView animateWithDuration:kAnimateWithDuration animations:^{
                _scrollView.contentInset = _scrollViewInitInset;
            }];
        }
        return;
    }
    _isLoading = YES;
    self.alpha = 1.0;
    self.hidden = NO;
    [self startAnimation];
    [self adjustFrame:_scrollView.contentSize block:nil];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)endRefreshing
{
    [self adjustFrame:_scrollView.contentSize block:^{
        [self endAnimation];
    }];
}

#pragma mark - dealloc

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
