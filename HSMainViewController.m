//
//  HSMainViewController.m
//  honestShopping
//
//  Created by 张国俗 on 15-3-16.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "HSMainViewController.h"
#import "define.h"
#import "HSIntroViewController.h"

@interface HSMainViewController ()
{
    HSIntroViewController *_introVC;
}

@end

@implementation HSMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"放心吃";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightNavItemAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    
    NSString *verson = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    NSString *saveedVerson = [[NSUserDefaults standardUserDefaults] objectForKey:kAPPCurrentVersion];
    
    if (saveedVerson == nil || ![verson isEqualToString:saveedVerson]) {
        [self showIntroView];
        
        [[NSUserDefaults standardUserDefaults] setObject:verson forKey:kAPPCurrentVersion];
    }
    
    
    
    
}

- (void)showIntroView
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _introVC = [storyboard instantiateViewControllerWithIdentifier:@"introViewCOntrollerIndentifier"];
    
    [self.navigationController.view addSubview:_introVC.view];
    _introVC.view.bounds = self.navigationController.view.bounds;
    [self.view bringSubviewToFront:_introVC.view];
    
    __weak typeof(_introVC) wIntroVC = _introVC;
    [_introVC setIntroViewFinishedBlock:^{
        
        __strong typeof(wIntroVC) swIntroVC = wIntroVC;
        [wIntroVC.view removeFromSuperview];
        swIntroVC = nil;
    }];

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

- (void)rightNavItemAction
{
    
}

@end
