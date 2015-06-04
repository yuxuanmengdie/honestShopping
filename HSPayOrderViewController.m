//
//  HSPayOrderViewController.m
//  honestShopping
//
//  Created by 张国俗 on 15-6-4.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "HSPayOrderViewController.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

#import "UIView+HSLayout.h"
@interface HSPayOrderViewController ()

@end

@implementation HSPayOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn addTarget:self action:@selector(aliPay) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"点击支付" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:btn];
    [self.view HS_centerXYWithSubView:btn];
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

- (void)aliPay
{
    /*
     *点击获取prodcut实例并初始化订单信息
     */
//    Product *product = [self.productList objectAtIndex:indexPath.row];
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088511141292044";
    NSString *seller = @"jsds@news.cn";//@"alipayrisk10@alipay.com";
    NSString *privateKey = @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBANWYfwyTiW2gNjijRHXywp+QdtvafdR8G/YuP1mg7SmIz0N/DijyVLF3xK86L3TSLG/DOYlI/cq4tzUQvZJQW9hSjSJ9AIdvVbLuVOtwWihdmRIEfF7PVf3yLy6wGghZ6qPaFAADgQ2YQErlmm+jepVW/LeK3diI80Wq1ln0hKtlAgMBAAECgYEA0h4/7Uk9yh/u9ux1rmnvVzSwGDrpyZuFjjmUjEEozNEOw2E7tsAc3K/rRk1A3fTbTd6IvSqWr1PitksPkd2HWotGygrcJgT+Ld3mGXA4gxlJZyZOmBDNpxlgq4hxbY/+txakdykWIfeJOduDowGOjUmzZV3tChKcCxDT4uEus8ECQQD6WJ3EqDX/n4HTfJXNbAwxFPdr2hVKhp281ZYh5CT3MG1pD3wrkxLF4klOKxH2KTkBE6uvS31u67C/no4esaDNAkEA2mtn9OxhF8PG0ClhyTOF5PGR/BCUaUT6ALq2Cd3WvKJP1WTvitew9R+KFQzxUOb6gk014TuFhQLx761p5OxU+QJBAMUIEcPBkB5L7+X/W/d9XmsS0Vi1H6S0JlmE0NCDuwRBvRq+8T9qVZAg9QjspQpUj2Tlkm44v9QY89ccd0Z5DtECQDY9pARTy0zOhondLPZ9QAv53an+KAz4XyldNKXAnHodyLuSpFYTeFN3MKBHpYnUwnMnX3D+igrdD13Y78o00mkCQQC9ivcRNA/ORQ9WuWkJZM8HzylHl8Tek1n3YLQ4ZirhlDtyIW+DiMKhQttZ5bCf0eV71YQbnJ1TrviBmUqZicZo";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = @"1sdwdw";//[self generateTradeNO]; //订单ID（由商家自行制定）
    order.productName = @"商品";//product.subject; //商品标题
    order.productDescription = @"这是一个描述";//product.body; //商品描述
    order.amount = @"0.01";//[NSString stringWithFormat:@"%.2f",product.price]; //商品价格
    order.notifyURL =  @"http://www.xxx.com"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"hsalisdkdemo";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"%s reslut = %@", __func__,resultDic);
        }];
        
    }

}

@end
