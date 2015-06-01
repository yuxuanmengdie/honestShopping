//
//  HSOrderTableViewCell.m
//  honestShopping
//
//  Created by 张国俗 on 15-5-25.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "HSOrderTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation HSOrderTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _priceLabel.textColor = kAppYellowColor;
    _stateLabel.textColor = kAppYellowColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupWithModel:(HSOrderModel *)orderModel
{
    [_commodityImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageHeaderURL,[public controlNullString:orderModel.img]]] placeholderImage:kPlaceholderImage];
    
    _orderIDLabel.text = [public controlNullString:orderModel.orderId];
    _timeLabel.text = [public controlNullString:orderModel.add_time];
    _priceLabel.text = [public controlNullString:orderModel.order_sumPrice];
    _stateLabel.text = [public controlNullString:orderModel.status];

}
@end
