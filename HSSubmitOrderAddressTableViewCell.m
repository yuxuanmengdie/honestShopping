//
//  HSSubmitOrderAddressTableViewCell.m
//  honestShopping
//
//  Created by 张国俗 on 15-6-1.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "HSSubmitOrderAddressTableViewCell.h"

@implementation HSSubmitOrderAddressTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpWithModel:(HSAddressModel *)addressModel
{
    if (addressModel == nil) { /// 地址为空
        _userNameLabel.text = @"";
        _phoneLabel.text = @"";
        _detailLabel.text = @"";
        _tipLable.text = @"还没有收货地址，请添加";
        _tipLable.hidden = NO;
    }
    else
    {
        _tipLable.hidden = YES;
        
        _userNameLabel.text = [NSString stringWithFormat:@"收货人：%@",[public controlNullString:addressModel.consignee]];
        _phoneLabel.text = [public controlNullString:addressModel.mobile];
        _detailLabel.text = [NSString stringWithFormat:@"收货地址：%@%@%@%@",[public controlNullString:addressModel.sheng],[public controlNullString:addressModel.shi],[public controlNullString:addressModel.qu],[public controlNullString:addressModel.address]];
    }
}

@end
