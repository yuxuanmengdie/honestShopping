//
//  HSEditAddressContainerTableViewController.h
//  honestShopping
//
//  Created by 张国俗 on 15-5-27.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSEditAddressContainerTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *userNameTextFiled;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextFiled;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UITextView *detailAddressTextView;
/// 占位的地址 "省市县"
@property (copy, nonatomic) NSString *addressPlaceHolder;
/// 占位的详细地址 "详细地址"
@property (copy, nonatomic) NSString *detailPlaceHolder;

@property (copy, nonatomic) NSString *sheng;

@property (copy, nonatomic) NSString *shi;

@property (copy, nonatomic) NSString *qu;

@end
