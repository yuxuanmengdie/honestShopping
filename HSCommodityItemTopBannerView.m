//
//  HSCommodityItemTopBannerView.m
//  honestShopping
//
//  Created by 张国俗 on 15-4-25.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "HSCommodityItemTopBannerView.h"

@interface HSCommodityItemTopBannerView ()
{
    NSLayoutConstraint *_bannerHeightConstraint;
}

@end

@implementation HSCommodityItemTopBannerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _bannerHeight = 240;
        
        _bannerView = [[FFScrollView alloc] init];
        _bannerView.translatesAutoresizingMaskIntoConstraints = NO;
        //_bannerView.imageContentMode = UIViewContentModeScaleAspectFit;
        _bannerView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:_bannerView];
        
        _infoView = [[HSItemBuyInfoView alloc] initWithFrame:CGRectZero];
        _infoView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_infoView];
        
        NSString *vfl1 = @"H:|[_bannerView]|";
        NSString *vfl2 = @"H:|[_infoView]|";
        NSString *vfl3 = @"V:|[_bannerView][_infoView]|";
        NSDictionary *dic = NSDictionaryOfVariableBindings(_bannerView,_infoView);
        NSArray *arr1 = [NSLayoutConstraint constraintsWithVisualFormat:vfl1 options:0 metrics:nil views:dic];
        NSArray *arr2 = [NSLayoutConstraint constraintsWithVisualFormat:vfl2 options:0 metrics:nil views:dic];
        NSArray *arr3 = [NSLayoutConstraint constraintsWithVisualFormat:vfl3 options:0 metrics:nil views:dic];
        
        _bannerHeightConstraint = [NSLayoutConstraint constraintWithItem:_bannerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:_bannerHeight];
        [self addConstraints:arr1];
        [self addConstraints:arr2];
        [self addConstraints:arr3];
        [self addConstraint:_bannerHeightConstraint];
        
    
    }
    
    return self;
}


- (void)setBannerHeight:(float)bannerHeight
{
    if (_bannerHeight == bannerHeight) {
        return;
    }
    
    _bannerHeight = bannerHeight;
    _bannerHeightConstraint.constant = bannerHeight;
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}

@end
