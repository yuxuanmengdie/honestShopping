//
//  HSBaseViewController.h
//  honestShopping
//
//  Created by 张国俗 on 15-4-27.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSBaseViewController : UIViewController

/// 请求的manger
@property (strong, nonatomic) AFHTTPRequestOperationManager *httpRequestOperationManager;

/// 导航栏rightitem
- (void)setNavBarRightBarWithTitle:(NSString *)rightTitle action:(SEL)seletor;

/// 默认文字显示加载失败
- (void)showReqeustFailedMsg;

/// 定义加载失败的文字
- (void)showReqeustFailedMsgWithText:(NSString *)text;

/// 隐藏并从父视图移除
- (void)hiddenMsg;

/// 点击重新加载后的响应  子类可重写
- (void)reloadRequestData;

/// 显示等待视图
- (void)showNetLoadingView;

/// hud 2秒后隐藏
- (void)showHudWithText:(NSString *)text;

/// hud 等待视图
- (void)showhudLoadingWithText:(NSString *)text isDimBackground:(BOOL)isDim;

/// 在window层 hud 2秒后hidden
- (void)showHudInWindowWithText:(NSString *)text;

/// 隐藏并移除 hud 等待视图
- (void)hiddenHudLoading;

/// 返回按钮的响应
- (void)backAction:(id)sender;

/// push stroyborad viewcontroller identifier 为类名
- (void)pushViewControllerWithIdentifer:(NSString *)identifier;

@end
