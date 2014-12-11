//
//  ProfileHeaderViewController.m
//  TwitterLikeProfileViewSample
//
//  Created by Shinichiro Oba on 2014/11/29.
//  Copyright (c) 2014年 Shinichiro Oba. All rights reserved.
//

#import "ProfileHeaderViewController.h"

@interface ProfileHeaderViewController ()

@property (nonatomic) CGFloat defaultViewHeight;
@property (nonatomic) CGFloat defaultBackgroundImageViewHeight;
@property (nonatomic) CGFloat defaultNavigationTitleViewTop;
@property (nonatomic) CGFloat profileImageBaseMinimumScale;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *profileImageBaseView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (weak, nonatomic) IBOutlet UIView *navigationBarView;
@property (weak, nonatomic) IBOutlet UIView *navigationTitleView;
@property (weak, nonatomic) IBOutlet UIView *segmentedControlBaseView;

@end

@implementation ProfileHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _defaultViewHeight = self.view.frame.size.height;
    _defaultBackgroundImageViewHeight = _backgroundImageView.frame.size.height;
    _defaultNavigationTitleViewTop = _navigationTitleView.frame.origin.y;

    CGFloat profileImageBaseMinimumHeight = _profileImageBaseView.frame.origin.y + _profileImageBaseView.frame.size.height - _defaultBackgroundImageViewHeight;
    _profileImageBaseMinimumScale = profileImageBaseMinimumHeight / _profileImageBaseView.frame.size.height;
    
    _profileImageBaseView.clipsToBounds = YES;
    _profileImageBaseView.layer.cornerRadius = 6;
    _profileImageView.clipsToBounds = YES;
    _profileImageView.layer.cornerRadius = 3;
    
    _profileImageBaseView.layer.anchorPoint = CGPointMake(0.5, 1);
    CGRect frame = _profileImageBaseView.frame;
    frame.origin.y += frame.size.height / 2;
    _profileImageBaseView.frame = frame;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    [self layoutBackgroundImageView];

    [self layoutProfileImageBaseView];
    
    [self layoutNavigationTitleView];
    
    [self updateNavigationBarAppearance];
}

#pragma mark - Property

- (CGFloat)minimumViewHeight {
    return _navigationBarView.frame.size.height + _segmentedControlBaseView.frame.size.height;
}

#pragma mark - Private

- (void)layoutBackgroundImageView {
    CGFloat navigationBarHeight = _navigationBarView.frame.size.height;
    
    CGRect frame = _backgroundImageView.frame;
    
    CGFloat diff = self.view.frame.size.height - _defaultViewHeight;
    if (diff >= 0) {
        frame.size.height = _defaultBackgroundImageViewHeight + diff;
        frame.origin.y = 0;
    } else {
        frame.size.height = _defaultBackgroundImageViewHeight;
        if (diff > navigationBarHeight - _defaultBackgroundImageViewHeight) {
            frame.origin.y = diff;
        } else {
            frame.origin.y = navigationBarHeight - _defaultBackgroundImageViewHeight;
        }
    }
    
    _backgroundImageView.frame = frame;
}

- (void)layoutProfileImageBaseView {
    CGFloat navigationBarHeight = _navigationBarView.frame.size.height;
    
    _profileImageBaseView.transform = CGAffineTransformIdentity;

    CGFloat diff = self.view.frame.size.height - _defaultViewHeight;
    if (diff < 0) {
        if (diff > navigationBarHeight - _defaultBackgroundImageViewHeight) {
            CGFloat scale = 1 + ((_profileImageBaseMinimumScale - 1) * diff / (navigationBarHeight - _defaultBackgroundImageViewHeight));
            _profileImageBaseView.transform = CGAffineTransformScale(_profileImageBaseView.transform, scale, scale);
            [self.view bringSubviewToFront:_profileImageBaseView];
        } else {
            _profileImageBaseView.transform = CGAffineTransformScale(_profileImageBaseView.transform, _profileImageBaseMinimumScale, _profileImageBaseMinimumScale);
            [self.view sendSubviewToBack:_profileImageBaseView];
        }
    }
}

- (void)layoutNavigationTitleView {
    CGRect frame = _navigationTitleView.frame;
    
    CGFloat y = _profileNameLabel.frame.origin.y;
    if (y > _defaultNavigationTitleViewTop) {
        frame.origin.y = _profileNameLabel.frame.origin.y;
    } else {
        frame.origin.y = _defaultNavigationTitleViewTop;
    }
    
    _navigationTitleView.frame = frame;
}

- (void)updateNavigationBarAppearance {
    CGFloat currentTitleY = _navigationTitleView.frame.origin.y;
    CGFloat navigationBarBottom = _navigationBarView.frame.size.height;

    CGFloat alpha = 0;
    if (currentTitleY < navigationBarBottom) {
        alpha = (navigationBarBottom - currentTitleY) / (navigationBarBottom - _defaultNavigationTitleViewTop);
    }

    _navigationTitleView.alpha = alpha;
    _navigationBarView.backgroundColor = [UIColor colorWithWhite:0 alpha:alpha / 2];
}

@end
