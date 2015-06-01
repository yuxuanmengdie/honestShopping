//
//  HSSubmitOrderCommdityTableViewCell.m
//  honestShopping
//
//  Created by 张国俗 on 15-6-1.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "HSSubmitOrderCommdityTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation HSSubmitOrderCommdityTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpWithModel:(HSCommodityItemDetailPicModel *)detailModel imagePreURl:(NSString *)preURL num:(int)num
{
    [_commdityImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[public controlNullString:preURL],[public controlNullString:detailModel.img]]] placeholderImage:kPlaceholderImage];
    _titleLabel.text = [public controlNullString:detailModel.title];
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",[public controlNullString:detailModel.price]];
    _detailLabel.text = [public controlNullString:detailModel.intro];
    _numLabel.text = [NSString stringWithFormat:@"x%d",num];
}


@end
