//
//  HSFavoriteTableViewCell.m
//  honestShopping
//
//  Created by 张国俗 on 15-5-26.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "HSFavoriteTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation HSFavoriteTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [_cancelButton setTitle:@"取消关注" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:kAppYellowColor forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)cancelAction:(id)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)setupWirhModel:(HSCommodtyItemModel *)itemModel
{
    _titleLabel.text = [public controlNullString:itemModel.title];
    _introLabel.text = [public controlNullString:itemModel.intro];
    _timeLabel.text = [public controlNullString:itemModel.add_time];
    
    [_commodityImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageHeaderURL,itemModel.img]] placeholderImage:kPlaceholderImage];
}

@end
