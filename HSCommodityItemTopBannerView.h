//
//  HSCommodityItemTopBannerView.h
//  honestShopping
//
//  Created by 张国俗 on 15-4-25.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFScrollView.h"
#import "HSItemBuyInfoView.h"

/// 商品详情的顶部视图
@interface HSCommodityItemTopBannerView : UIView

@property (nonatomic, strong) FFScrollView *bannerView;

@property (nonatomic, strong) HSItemBuyInfoView *infoView;

@property (nonatomic, assign) float bannerHeight;

@end
