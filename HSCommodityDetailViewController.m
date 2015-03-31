//
//  HSCommodityDetailViewController.m
//  honestShopping
//
//  Created by 张国俗 on 15-3-31.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "HSCommodityDetailViewController.h"
#import "HSBuyNumView.h"

@interface HSCommodityDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@property (weak, nonatomic) IBOutlet HSBuyNumView *buyNumView;

@end

@implementation HSCommodityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buyViewBlock];
}

- (void)buyViewBlock
{
    _buyNumView.buyBlock = ^(int num){
        
    };
    
    _buyNumView.collectBlock = ^(void){
        
    };
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

@end
