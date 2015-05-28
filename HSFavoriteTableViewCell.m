//
//  HSFavoriteTableViewCell.m
//  honestShopping
//
//  Created by 张国俗 on 15-5-26.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "HSFavoriteTableViewCell.h"

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
@end
