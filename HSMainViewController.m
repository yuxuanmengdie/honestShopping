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
#import "HSLoginInViewController.h"

@interface HSMainViewController ()
{
    HSIntroViewController *_introVC;
}

@end

@implementation HSMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.title = @"放心吃";
    self.tabBar.selectedImageTintColor =  kAPPTintColor;
    self.tabBar.translucent = NO;
//    [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightNavItemAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    /// 获取版本号 判断是否需要引导页
    NSString *verson = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    NSString *saveedVerson = [[NSUserDefaults standardUserDefaults] objectForKey:kAPPCurrentVersion];
    
    if (saveedVerson == nil || ![verson isEqualToString:saveedVerson]) {
        [self showIntroView];
        
        [[NSUserDefaults standardUserDefaults] setObject:verson forKey:kAPPCurrentVersion];
    }
    
    
    UITabBarItem *tabBarItem1 = [self.tabBar.items objectAtIndex:2];
    UIImage *img =  [public ImageWithColor:[UIColor blueColor] frame:CGRectMake(0, 0, 50, 300)];
    UIImage *oriImg = [public ImageWithColor:[UIColor yellowColor] frame:CGRectMake(0, 0, 50, 100)];
    //    tabBarItem1.imageInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
    tabBarItem1.selectedImage = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    tabBarItem1.image = [oriImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem1.enabled = YES;

    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem *barItem, NSUInteger idx, BOOL *stop) {
        [barItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    }];

    
//    UIView *customView = [[UIView alloc] init];
//    customView.backgroundColor = [UIColor blueColor];
//    customView.frame = CGRectMake(80, CGRectGetMaxY(self.view.frame)-60, CGRectGetWidth(self.view.frame)/self.tabBar.items.count, 60);
////    [self.view addSubview:customView];
//    self.tabBar.clipsToBounds = NO;
//    NSLog(@"frame=%@,item=%f",NSStringFromCGRect(self.tabBar.frame),self.tabBar.itemWidth);
//
//    UITabBarItem *tabBarItem1 = [self.tabBar.items objectAtIndex:2];
//    [tabBarItem1 setImage:[public ImageWithColor:[UIColor blueColor] frame:customView.bounds]];
//    tabBarItem1.imageInsets = UIEdgeInsetsMake(0, -10, -6, -10);
   
    
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


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{

    UITabBarItem *tabBarItem1 = [self.tabBar.items objectAtIndex:2];
    if (item == tabBarItem1) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HSLoginInViewController *loginVC = [story instantiateViewControllerWithIdentifier:NSStringFromClass([HSLoginInViewController class])];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
}


@end
