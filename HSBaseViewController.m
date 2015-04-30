//
//  HSBaseViewController.m
//  honestShopping
//
//  Created by 张国俗 on 15-4-27.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "HSBaseViewController.h"
#import "UIView+HSLayout.h"
#import "HSRotateAnimationView.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"

@interface HSBaseViewController ()
{
     //AFHTTPRequestOperationManager *_httpRequestOperationManager;
    
     UIControl *_showMsgView;
    
    MBProgressHUD *_loadingHud;
}

@end

@implementation HSBaseViewController
@synthesize httpRequestOperationManager = _httpRequestOperationManager;

/// 重新加载 的label tag
static const int kShowMsgLabelTag = 5000;
/// 请求失败的图片 tag
static const int kShowMsgImgViewTag = 5001;
/// 加载中的动画视图 tag
static const int kShowMsgLoadingTag = 5002;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initOperationManager];
    [self addBackButton];
    
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

#pragma mark -
#pragma mark 定义rightItem
- (void)setNavBarRightBarWithTitle:(NSString *)rightTitle action:(SEL)seletor
{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:rightTitle style:UIBarButtonItemStylePlain target:self action:seletor];
   
}

#pragma mark -
#pragma mark 初始化请求列表

- (void)initOperationManager
{
    _httpRequestOperationManager = [[AFHTTPRequestOperationManager alloc] init];
}


#pragma mark -
- (void)setUpShowMsgView
{
    [self hiddenMsg];
    
    _showMsgView = [[UIControl alloc] initWithFrame:CGRectZero];
    _showMsgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_showMsgView];
    [self.view HS_edgeFillWithSubView:_showMsgView];
    [_showMsgView addTarget:self action:@selector(reloadRequestData) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.tag = kShowMsgLabelTag;
    label.font = [UIFont systemFontOfSize:14];
    [_showMsgView addSubview:label];
    label.text = @"点击重新加载";
    label.textColor = UIColorFromRGB(0x999999);
    [_showMsgView HS_centerXYWithSubView:label];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.tag = kShowMsgImgViewTag;
    imgView.image = [UIImage imageNamed:@"list_network_error"];
    [_showMsgView addSubview:imgView];
    [_showMsgView HS_dispacingWithFisrtView:label fistatt:NSLayoutAttributeTop secondView:imgView secondAtt:NSLayoutAttributeBottom constant:20];
    [_showMsgView HS_centerXWithSubView:imgView];
    
    HSRotateAnimationView *rotateView = [[HSRotateAnimationView alloc] initWithFrame:CGRectZero];
    rotateView.image = [UIImage imageNamed:@"icon_activity"];
    rotateView.tag = kShowMsgLoadingTag;
    [_showMsgView addSubview:rotateView];
    [_showMsgView HS_centerXYWithSubView:rotateView];
    
    
    [self.view bringSubviewToFront:_showMsgView];

}


- (void)rotateViewHidden
{
    HSRotateAnimationView *ratateView = (HSRotateAnimationView *)[_showMsgView viewWithTag:kShowMsgLoadingTag];
    [ratateView stopRotating];
    ratateView.hidden = YES;
}

- (void)showReqeustFailedMsg
{
    [self setUpShowMsgView];
    [self rotateViewHidden];
}


- (void)showReqeustFailedMsgWithText:(NSString *)text
{
    [self showReqeustFailedMsg];
    UILabel *label = (UILabel *)[_showMsgView viewWithTag:kShowMsgLabelTag];
    label.text = text;
}

#pragma mark - 
#pragma mark 显示加载视图
- (void)showNetLoadingView
{
    [self setUpShowMsgView];
    [_showMsgView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        obj.hidden = YES;
    }];
    _showMsgView.userInteractionEnabled = NO;
    
    HSRotateAnimationView *ratateView = (HSRotateAnimationView *)[_showMsgView viewWithTag:kShowMsgLoadingTag];
    ratateView.hidden = NO;
    [ratateView startRotating];
}


- (void)hiddenMsg
{
    [_showMsgView removeFromSuperview];
    _showMsgView = nil;
}

#pragma mark -
#pragma mark hud 显示
- (void)showHudWithText:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.alpha = 0.9;
    hud.labelText = text;
    hud.margin = 10.f;
    hud.yOffset = 150;
    hud.animationType = MBProgressHUDAnimationZoomOut;// | MBProgressHUDAnimationZoomIn;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2.0];
}


- (void)showhudLoadingWithText:(NSString *)text isDimBackground:(BOOL)isDim
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _loadingHud = hud;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.dimBackground = isDim;
    hud.alpha = 0.9;
    hud.labelText = text;
    hud.margin = 5.f;
    //hud.animationType = MBProgressHUDAnimationZoomOut;// | MBProgressHUDAnimationZoomIn;
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
}

- (void)hiddenHudLoading
{
    [_loadingHud hide:YES];
}

#pragma mark -
#pragma mark 添加返回按钮

- (void)addBackButton
{
    NSInteger count = [self.navigationController.viewControllers count];
    if (count >= 2)
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(backAction:)];
    }
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark 点击重新加载
- (void)reloadRequestData
{
    
}

- (void)dealloc
{
    [_httpRequestOperationManager.operationQueue cancelAllOperations];
}
@end
