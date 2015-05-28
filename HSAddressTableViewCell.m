//
//  HSAddressTableViewCell.m
//  honestShopping
//
//  Created by 张国俗 on 15-5-26.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "HSAddressTableViewCell.h"

@implementation HSAddressTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)addressIsDefault:(BOOL)isDefault
{
    if (isDefault) {
        _nickNameLabel.textColor = [UIColor whiteColor];
        _phoneLabel.textColor = [UIColor whiteColor];
        _detailLabel.textColor = [UIColor whiteColor];
        _defaultImageView.hidden = NO;
        self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    else
    {
        _nickNameLabel.textColor = [UIColor blackColor];
        _phoneLabel.textColor = [UIColor blackColor];
        _detailLabel.textColor = [UIColor blackColor];
        _defaultImageView.hidden = YES;
        self.contentView.backgroundColor = [UIColor whiteColor];

    }
}

@end
