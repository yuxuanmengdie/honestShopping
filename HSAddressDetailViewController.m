//
//  HSAddressDetailViewController.m
//  honestShopping
//
//  Created by 张国俗 on 15-5-26.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "HSAddressDetailViewController.h"
#import "HSAddressDetailTableViewCell.h"
#import "UIView+HSLayout.h"

@interface HSAddressDetailViewController ()<UITableViewDelegate,
UITableViewDataSource>
{
    UIButton *_confirmButton;
    
    NSArray *_detailDataArray;
}

@property (weak, nonatomic) IBOutlet UITableView *addressDetailTableView;

@end

@implementation HSAddressDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    _detailDataArray = @[@"收货人",@"手机号码",@"邮政编码",@"所在地区",@"详细地址"];
    
    [_addressDetailTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HSAddressDetailTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HSAddressDetailTableViewCell class])];
    _addressDetailTableView.dataSource = self;
    _addressDetailTableView.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)footerView
{
    UIView *footerView = [[UIView alloc] init];
    CGRect rect = _addressDetailTableView.bounds;
    rect.size.height = 100;
    footerView.frame = rect;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmButton = button;
    button.contentEdgeInsets = UIEdgeInsetsMake(8, 16, 8, 16);
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setBackgroundImage:[public ImageWithColor:kAPPTintColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5.0;
    [button addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:button];
    [footerView HS_centerXYWithSubView:button];
    [footerView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:footerView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:16]];
    
    _addressDetailTableView.tableFooterView = footerView;
    
}

- (void)confirmAction
{
    
}


#pragma mark -
#pragma mark tableView dataSource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = 0;
    if (section == 0) {
        num = 5;
    }
    else
    {
        num = 1;
    }
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HSAddressDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HSAddressDetailTableViewCell class]) forIndexPath:indexPath];
    cell.separatorInset = UIEdgeInsetsZero;
    
    if (indexPath.section == 1) {
        cell.leftTitleWidthConstraint.constant = 300;
        cell.leftTitleLabel.text = @"删除收货地址";
        cell.leftTitleLabel.textColor = [UIColor redColor];
    }
    else
    {
        cell.leftTitleWidthConstraint.constant = 70;
        cell.leftTitleLabel.text = _detailDataArray[indexPath.row];
        cell.leftTitleLabel.textColor = [UIColor darkGrayColor];
    }
    
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (_palaceCell == nil) {
//        _palaceCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HSAddressTableViewCell class])];
//        _palaceCell.contentView.bounds = tableView.frame;
//    }
//    [_palaceCell.contentView updateConstraintsIfNeeded];
//    [_palaceCell.contentView layoutIfNeeded];
//    CGFloat height = [_palaceCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    return height + 1;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) { /// 删除地址
        
    }
}


@end
