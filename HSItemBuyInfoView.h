//
//  HSItemBuyInfoView.h
//  honestShopping
//
//  Created by 张国俗 on 15-4-24.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HSItemBuyInfoCollectActionBlock)(void);
/// 单个商品标题 数量 价格和加入购买车
@interface HSItemBuyInfoView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIButton *collectButton;


@property (nonatomic, copy) HSItemBuyInfoCollectActionBlock colletActionBlock;

@end
