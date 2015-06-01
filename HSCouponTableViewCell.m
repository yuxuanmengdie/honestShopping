//
//  HSCouponTableViewCell.m
//  honestShopping
//
//  Created by 张国俗 on 15-5-26.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "HSCouponTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation HSCouponTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpWithModel:(HSCouponModel *)couponModle
{
    [_couponImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kCoupImageHeaderURL,couponModle.img]] placeholderImage:kPlaceholderImage];
    
    _validDateLabel.text = [public controlNullString:couponModle.endtime];
    _dateLabel.text = [public controlNullString:couponModle.starttime];
    _introLabel.text = [public controlNullString:couponModle.desc];
    _explainLabel.text = [public controlNullString:couponModle.name];
}

@end