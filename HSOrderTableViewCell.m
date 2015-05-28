//
//  HSOrderTableViewCell.m
//  honestShopping
//
//  Created by 张国俗 on 15-5-25.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "HSOrderTableViewCell.h"

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

@end
