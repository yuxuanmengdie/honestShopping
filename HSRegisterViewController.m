//
//  HSRegisterViewController.m
//  honestShopping
//
//  Created by 张国俗 on 15-4-30.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "HSRegisterViewController.h"

@interface HSRegisterViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextFiled;

@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@end

@implementation HSRegisterViewController

///用户textfield表示图片
static NSString *const kUserImageName = @"icon_activity";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"注册";
    [self leftViewWithTextFiled:_phoneTextFiled imgName:kUserImageName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)commitAction:(id)sender {
    if (_phoneTextFiled.text.length < 1 || ![public isPhoneNumberRegex:_phoneTextFiled.text]) {
        [self showHudWithText:@"请输入正确的手机号"];
        return;
    }
}

#pragma mark -
#pragma mark 注册
- (void)regosterRequest
{
    [self showhudLoadingWithText:nil isDimBackground:YES];
    NSDictionary *parametersDic = @{kPostJsonKey:[public getIPAddress:YES],
                                    
                                   
                                    };
    // 142346261  123456
    
    [self.httpRequestOperationManager POST:kLoginURL parameters:@{kJsonArray:[public dictionaryToJson:parametersDic]} success:^(AFHTTPRequestOperation *operation, id responseObject) { /// 失败
        NSLog(@"success\n%@",operation.responseString);
        [self hiddenHudLoading];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed\n%@",operation.responseString);
        [self hiddenHudLoading];
        if (operation.responseData == nil) {
            [self showHudWithText:@"登录失败"];
            return ;
        }
        NSError *jsonError = nil;
        id json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:&jsonError];
        if (jsonError == nil && [json isKindOfClass:[NSDictionary class]]) {
            
        }
        else
        {
            [self showHudWithText:@"登录失败"];
        }
    }];

}


#pragma mark -
#pragma mark textfiled delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
