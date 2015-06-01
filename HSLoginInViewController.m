//
//  HSLoginInViewController.m
//  honestShopping
//
//  Created by 张国俗 on 15-4-29.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "HSLoginInViewController.h"
#import "UIView+HSLayout.h"
#import "HSUserInfoModel.h"
#import "HSRegisterViewController.h"

@interface HSLoginInViewController ()<UITextFieldDelegate>
{
    HSUserInfoModel *_userInfoModel;
    
    HSRegisterViewController *_registerViewController;
}

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UIView *textFieldBackView;

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *passWordTextFiled;

@property (weak, nonatomic) IBOutlet UIButton *remeberPWButton;

@property (weak, nonatomic) IBOutlet UIButton *findPWButton;

@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@end

@implementation HSLoginInViewController

///用户textfield表示图片
static NSString *const kUserImageName = @"icon_userName";
/// 密码表示图片
static NSString *const kPassWordImageName = @"icon_findPW";
/// 记住密码选中图片
static NSString *const kRemeberPWSeletedImageName = @"icon_remeberPW";
///
static NSString *const kRemeberPWNormalImageName = @"icon_remeberPW_unsel";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登录";
    [self setNavBarRightBarWithTitle:@"注册" action:@selector(accoutRegister)];
    self.navigationController.navigationBarHidden = NO;
    [self buttonStyle];
    _iconImageView.image = [UIImage imageNamed:@"icon_logo"];
    [self leftViewWithTextFiled:_userNameTextField imgName:kUserImageName];
    [self leftViewWithTextFiled:_passWordTextFiled imgName:kPassWordImageName];
    NSDictionary *userInfo = [public userInfoFromPlist];
    NSLog(@"userInfo=%@",userInfo);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark 注册
- (void)accoutRegister
{
    [self SetUpregisterVC];
    _registerViewController.title = @"注册";
    _registerViewController.isRegister = YES;
}

- (void)SetUpregisterVC
{
    UIStoryboard *stroyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _registerViewController = [stroyBoard instantiateViewControllerWithIdentifier:NSStringFromClass([HSRegisterViewController class])];
    [self.navigationController pushViewController:_registerViewController animated:YES];
    
    __weak typeof(self) wself = self;
    _registerViewController.registerSuccessBlock = ^(NSString *userName, NSString *password){
        [wself loginRequest:userName password:password];
    };
    

}

#pragma mark -
#pragma mark textfiled 属性 样式
- (void)leftViewWithTextFiled:(UITextField *)textField imgName:(NSString *)imgName
{
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    [img sizeToFit];
    UIView *tmpView = [[UIView alloc] init];
    tmpView.backgroundColor = [UIColor clearColor];
    [tmpView addSubview:img];
    img.frame = CGRectMake(8, 0, img.image.size.width, img.image.size.height);
    tmpView.frame = CGRectMake(0, 0, img.image.size.width+8, img.image.size.height);
    tmpView.bounds = CGRectMake(0, 0, img.image.size.width+8, img.image.size.height);
    textField.leftView = tmpView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.layer.masksToBounds = YES;
    textField.layer.borderColor = kAPPTintColor.CGColor;
    textField.tintColor = kAPPTintColor;
    textField.layer.cornerRadius = 8.0;
    textField.layer.borderWidth = 1.0;
    textField.delegate = self;
    
}

- (void)buttonStyle
{
    [_remeberPWButton setTitle:@"记住密码" forState:UIControlStateNormal];
    [_remeberPWButton setBackgroundColor:[UIColor clearColor]];
    [_remeberPWButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_remeberPWButton setImage:[UIImage imageNamed:kRemeberPWNormalImageName] forState:UIControlStateNormal];
    [_remeberPWButton setImage:[UIImage imageNamed:kRemeberPWSeletedImageName] forState:UIControlStateSelected];
    _remeberPWButton.selected = YES;
    
    [_findPWButton setTitle:@"找回密码" forState:UIControlStateNormal];
    [_findPWButton setBackgroundColor:[UIColor clearColor]];
    [_findPWButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_findPWButton setImage:[UIImage imageNamed:kPassWordImageName] forState:UIControlStateNormal];
    
    [_commitButton setTitle:@"登录" forState:UIControlStateNormal];
    [_commitButton setBackgroundImage:[public ImageWithColor:kAPPTintColor] forState:UIControlStateNormal];
    _commitButton.layer.masksToBounds = YES;
    _commitButton.layer.cornerRadius = 5.0;
    [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _commitButton.contentEdgeInsets = UIEdgeInsetsMake(8, 16, 8, 16);
    
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
#pragma mark 按钮响应

- (IBAction)remeberPWAction:(id)sender {
    _remeberPWButton.selected = !_remeberPWButton.selected;
}

- (IBAction)findPWAction:(id)sender {
    [self SetUpregisterVC];
    _registerViewController.title = @"找回密码";
    _registerViewController.isRegister = NO;
}

- (IBAction)commitAction:(id)sender {
    
    if (_userNameTextField.text.length < 1 || _passWordTextFiled.text.length < 1) {
        [self showHudWithText:@"用户名或密码不能为空"];
        return;
    }
    
    [self loginRequest:_userNameTextField.text password:_passWordTextFiled.text];
}

#pragma mark -
#pragma mark 登录请求
- (void)loginRequest:(NSString *)userName password:(NSString *)passWord
{
    [self showhudLoadingWithText:@"正在登录..." isDimBackground:YES];
    NSDictionary *parametersDic = @{kPostJsonKey:[public md5Str:[public getIPAddress:YES]],
                                    kPostJsonUserName:userName,
                                    kPostJsonPassWord:passWord
                                    };
    // 142346261  123456
    
    [self.httpRequestOperationManager POST:kLoginURL parameters:@{kJsonArray:[public dictionaryToJson:parametersDic]} success:^(AFHTTPRequestOperation *operation, id responseObject) { /// 失败
        NSLog(@"success\n%@",operation.responseString);
        [self showHudWithText:@"登录失败"];
        [self hiddenHudLoading];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s failed\n%@",__func__,operation.responseString);
        [self hiddenHudLoading];
        if (operation.responseData == nil) {
            [self showHudWithText:@"登录失败"];
            return ;
        }
        NSError *jsonError = nil;
        id json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:&jsonError];
        if (jsonError == nil && [json isKindOfClass:[NSDictionary class]]) {
            
            _userInfoModel = [[HSUserInfoModel alloc] initWithDictionary:json error:nil];
            if (_userInfoModel.id.length > 0) { /// 登录后返回有数据
                [self showHudInWindowWithText:@"登录成功"];
                [public saveUserInfoToPlist:[_userInfoModel toDictionary]];
                [public setLoginInStatus:YES];
                
                [public saveLastUserName:userName];
                [public saveLastPassword:passWord];
                if (_remeberPWButton.selected) {
                    
                }
                [self backAction:nil];
            }
        }
        else
        {
            [self showHudWithText:@"登录失败"];
        }
    }];
}

- (void)backAction:(id)sender
{
    [super backAction:sender];
//    self.navigationController.navigationBarHidden = YES;
}


#pragma mark -
#pragma mark textfiled delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark 微信登录

/*
- (void)getAccess_token
 {
 //https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
 
 NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kWXAPP_ID,kWXAPP_SECRET,self.wxCode.text];
 
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
 NSURL *zoneUrl = [NSURL URLWithString:url];
 NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
 NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
 dispatch_async(dispatch_get_main_queue(), ^{
 if (data) {
 NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
 
// {
// "access_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWiusJMZwzQU8kXcnT1hNs_ykAFDfDEuNp6waj-bDdepEzooL_k1vb7EQzhP8plTbD0AgR8zCRi1It3eNS7yRyd5A";
// "expires_in" = 7200;
// openid = oyAaTjsDx7pl4Q42O3sDzDtA7gZs;
// "refresh_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWi2ZzH_XfVVxZbmha9oSFnKAhFsS0iyARkXCa7zPu4MqVRdwyb8J16V8cWw7oNIff0l-5F-4-GJwD8MopmjHXKiA";
// scope = "snsapi_userinfo,snsapi_base";
// }
 

self.access_token.text = [dic objectForKey:@"access_token"];
self.openid.text = [dic objectForKey:@"openid"];

}
});
});
 }

 利用GCD来获取对应的token和openID.

第三步：userinfo
-(void)getUserInfo
{
    // https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",self.access_token.text,self.openid.text];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
 
//                 {
//                 city = Haidian;
//                 country = CN;
//                 headimgurl = "http://wx.qlogo.cn/mmopen/FrdAUicrPIibcpGzxuD0kjfnvc2klwzQ62a1brlWq1sjNfWREia6W8Cf8kNCbErowsSUcGSIltXTqrhQgPEibYakpl5EokGMibMPU/0";
//                 language = "zh_CN";
//                 nickname = "xxx";
//                 openid = oyAaTjsDx7pl4xxxxxxx;
//                 privilege =     (
//                 );
//                 province = Beijing;
//                 sex = 1;
//                 unionid = oyAaTjsxxxxxxQ42O3xxxxxxs;
//                 }
 
                
                self.nickname.text = [dic objectForKey:@"nickname"];
                self.wxHeadImg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"headimgurl"]]]];
                
            }
        });
        
    });
}

*/


@end
