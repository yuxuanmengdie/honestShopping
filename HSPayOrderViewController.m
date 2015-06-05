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
#import "HSSettleView.h"
#import "HSSubmitOrderAddressTableViewCell.h"
#import "HSSubmitOrderCommdityTableViewCell.h"
#import "HSPayTypeTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "HSOrderStatusTableViewCell.h"

#import "HSCommodityItemDetailPicModel.h"

@interface HSPayOrderViewController ()<UITableViewDataSource,
UITableViewDelegate>
{
     HSSubmitOrderAddressTableViewCell *_placeAddressCell;
    
    /// 支付方式 0 支付宝 1微信
    int _payType;
}

@property (weak, nonatomic) IBOutlet UITableView *orderDetailTableView;

@property (weak, nonatomic) IBOutlet HSSettleView *settleView;

@end

@implementation HSPayOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _payType = 0;
    
    [_orderDetailTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HSSubmitOrderAddressTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HSSubmitOrderAddressTableViewCell class])];
    [_orderDetailTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HSSubmitOrderCommdityTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HSSubmitOrderCommdityTableViewCell class])];
    [_orderDetailTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HSPayTypeTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HSPayTypeTableViewCell class])];
    [_orderDetailTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HSOrderStatusTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HSOrderStatusTableViewCell class])];

    [_orderDetailTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    _orderDetailTableView.dataSource = self;
    _orderDetailTableView.delegate = self;

    [self setupSettleView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark settleView 的设置
- (void)setupSettleView
{
    [_settleView.settltButton setTitle:@"支付订单" forState:UIControlStateNormal];
    _settleView.textLabel.text = [NSString stringWithFormat:@"应付金额：%0.2f",[self totolMoneyWithoutPostage]];
    
    __weak typeof(self) wself = self;
    
    _settleView.settleBlock = ^{
       // [wself aliPay];
    };
}

#pragma mark -
#pragma mark 获取订单详情
- (void)getOrderDetailRequest:(NSString *)orderID
{
    
}


#pragma mark -
#pragma mark 获取商品的总数
- (int)totalNum
{
    __block int num = 0;
    
    [_itemNumDic.allValues enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        num += [obj intValue];
    }];
    
    return num;
}

#pragma mark -
#pragma mark 获取总价格 不包含邮费
- (float)totolMoneyWithoutPostage
{
    __block float total = 0.0;
    [_commdityDataArray enumerateObjectsUsingBlock:^(HSCommodityItemDetailPicModel *obj, NSUInteger idx, BOOL *stop) {
        
        NSString *cid = [public controlNullString:obj.id];
        NSNumber *num = _itemNumDic[cid];
        int count = [num intValue] < 0 ? 0 : [num intValue];
        float price = [obj.price floatValue] < 0 ? 0: [obj.price floatValue];
        
        total += count * price;
        
    }];
    return total;
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
#pragma mark 支付宝支付

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

#pragma mark -
#pragma mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = 0;
    if (section == 0) { // 地址 + 订单状态
        num = 2;
    }
    else // 商品种类  + 运费 + 总计 + 付款方式 + 配送方式
    {
        num = _commdityDataArray.count + 4;
    }
    
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) { /// section 0
        
        if (indexPath.row == 0) {
            HSOrderStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HSOrderStatusTableViewCell class]) forIndexPath:indexPath];
            cell.orderStatusLabel.text = [NSString stringWithFormat:@"订单状态：%@",@"待支付"];
            cell.orderIDLabel.text = [NSString stringWithFormat:@"订单编号：%@",@"A598456261249845"];
            cell.orderTimeLabel.text = [NSString stringWithFormat:@"订单时间：%@",@"2015-06-04 23:59:20"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
        else
        {
            HSSubmitOrderAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HSSubmitOrderAddressTableViewCell class]) forIndexPath:indexPath];
            [cell setUpWithModel:_addressModel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

        }
    }
    else
    {
        if (indexPath.row < _commdityDataArray.count) { /// 商品详情
            HSSubmitOrderCommdityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HSSubmitOrderCommdityTableViewCell class]) forIndexPath:indexPath];
            HSCommodityItemDetailPicModel *detailModel = _commdityDataArray[indexPath.row];
            int num = [_itemNumDic[[public controlNullString:detailModel.id]] intValue];
            [cell setUpWithModel:detailModel imagePreURl:kImageHeaderURL num:num];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            if (indexPath.row == _commdityDataArray.count) // 运费
            {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];

                UILabel *leftLabel = (UILabel *)[cell.contentView viewWithTag:501];
                UILabel *rightLabel = (UILabel *)[cell.contentView viewWithTag:502];
                if (leftLabel == nil) {
                    leftLabel = [[UILabel alloc] init];
                    leftLabel.tag = 501;
                    leftLabel.font = [UIFont systemFontOfSize:14];
                    leftLabel.translatesAutoresizingMaskIntoConstraints = NO;
                    [cell.contentView addSubview:leftLabel];
                    [cell.contentView HS_dispacingWithFisrtView:cell.contentView fistatt:NSLayoutAttributeLeading secondView:leftLabel secondAtt:NSLayoutAttributeLeading constant:-8];
                    [cell.contentView HS_centerYWithSubView:leftLabel];
                    
                }
                
                if (rightLabel == nil) {
                    rightLabel = [[UILabel alloc] init];
                    rightLabel.tag = 502;
                    rightLabel.textColor = kAppYellowColor;
                    rightLabel.font = [UIFont systemFontOfSize:14];
                    rightLabel.translatesAutoresizingMaskIntoConstraints = NO;
                    [cell.contentView addSubview:rightLabel];
                    [cell.contentView HS_dispacingWithFisrtView:cell.contentView fistatt:NSLayoutAttributeTrailing secondView:rightLabel secondAtt:NSLayoutAttributeTrailing constant:8];
                    [cell.contentView HS_centerYWithSubView:rightLabel];
                    
                }
                leftLabel.text = @"运费：";
                rightLabel.text = @"江浙沪包邮，其他省市12元";
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            else  if (indexPath.row == _commdityDataArray.count + 1)// 合计
            {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];

                UILabel *leftLabel = (UILabel *)[cell.contentView viewWithTag:501];
                UILabel *rightLabel = (UILabel *)[cell.contentView viewWithTag:502];
                if (rightLabel == nil) {
                    rightLabel = [[UILabel alloc] init];
                    rightLabel.tag = 502;
                    //rightLabel.textColor = kAppYellowColor;
                    rightLabel.font = [UIFont systemFontOfSize:14];
                    rightLabel.translatesAutoresizingMaskIntoConstraints = NO;
                    [cell.contentView addSubview:rightLabel];
                    [cell.contentView HS_dispacingWithFisrtView:cell.contentView fistatt:NSLayoutAttributeTrailing secondView:rightLabel secondAtt:NSLayoutAttributeTrailing constant:8];
                    [cell.contentView HS_centerYWithSubView:rightLabel];
                    
                }
                
                if (leftLabel == nil) {
                    leftLabel = [[UILabel alloc] init];
                    leftLabel.tag = 501;
                    leftLabel.font = [UIFont systemFontOfSize:14];
                    leftLabel.translatesAutoresizingMaskIntoConstraints = NO;
                    [cell.contentView addSubview:leftLabel];
                    [cell.contentView HS_dispacingWithFisrtView:leftLabel fistatt:NSLayoutAttributeTrailing secondView:rightLabel secondAtt:NSLayoutAttributeLeading constant:-8];
                    [cell.contentView HS_centerYWithSubView:leftLabel];
                    
                }
                int num = [self totalNum]; // 商品总数
                float price = [self totolMoneyWithoutPostage] + 6.00;
                NSString *str1 = @"共有";
                NSString *str2 = @"件商品";
                NSString *str3 = @"合计:";
                NSString *leftStr = [NSString stringWithFormat:@"%@%d%@",str1,num,str2];
                NSString *rightStr = [NSString stringWithFormat:@"%@￥%0.2f",str3,price];
                
                NSMutableAttributedString *left = [[NSMutableAttributedString alloc] initWithString:leftStr];
                NSMutableAttributedString *right = [[NSMutableAttributedString alloc] initWithString:rightStr];
                
                [left addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(0, str1.length)];
                [left addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0] range:NSMakeRange(str1.length, leftStr.length-str2.length-str1.length)];
                [left addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(leftStr.length-str2.length,str2.length)];
                
                [right addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(0,str3.length)];
                [right addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14.0] range:NSMakeRange(str3.length,right.length-str3.length)];
                leftLabel.attributedText = left;
                rightLabel.attributedText = right;
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            else  if (indexPath.row == _commdityDataArray.count + 2)// 付款方式
            {
                HSPayTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HSPayTypeTableViewCell class]) forIndexPath:indexPath];
                cell.leftLabel.text = @"支付方式：";
                if (_payType == 0) {
                    cell.aliPayButton.selected = YES;
                    cell.weixinPayButton.selected = NO;
                }
                else
                {
                    cell.aliPayButton.selected = NO;
                    cell.weixinPayButton.selected = YES;
                }
                __weak typeof(self) wself = self;
                cell.payTypeBlock = ^(int type){ // 0 支付宝 1微信
                    __strong typeof(wself) swself = wself;
                    swself->_payType = type;
                    
                };
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            else /// 配送方式
            {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
                
                UILabel *leftLabel = (UILabel *)[cell.contentView viewWithTag:501];
                UILabel *rightLabel = (UILabel *)[cell.contentView viewWithTag:502];
                if (leftLabel == nil) {
                    leftLabel = [[UILabel alloc] init];
                    leftLabel.tag = 501;
                    leftLabel.font = [UIFont systemFontOfSize:14];
                    leftLabel.translatesAutoresizingMaskIntoConstraints = NO;
                    [cell.contentView addSubview:leftLabel];
                    [cell.contentView HS_dispacingWithFisrtView:cell.contentView fistatt:NSLayoutAttributeLeading secondView:leftLabel secondAtt:NSLayoutAttributeLeading constant:-8];
                    [cell.contentView HS_centerYWithSubView:leftLabel];
                    
                }
                
                if (rightLabel == nil) {
                    rightLabel = [[UILabel alloc] init];
                    rightLabel.tag = 502;
                    rightLabel.textColor = kAppYellowColor;
                    rightLabel.font = [UIFont systemFontOfSize:14];
                    rightLabel.translatesAutoresizingMaskIntoConstraints = NO;
                    [cell.contentView addSubview:rightLabel];
                    [cell.contentView HS_dispacingWithFisrtView:cell.contentView fistatt:NSLayoutAttributeTrailing secondView:rightLabel secondAtt:NSLayoutAttributeTrailing constant:8];
                    [cell.contentView HS_dispacingWithFisrtView:leftLabel fistatt:NSLayoutAttributeTrailing secondView:rightLabel secondAtt:NSLayoutAttributeLeading constant:-8];
                    [cell.contentView HS_centerYWithSubView:rightLabel];
                    
                }
                leftLabel.text = @"配送方式：";
                rightLabel.text = @"一周之内可以收货";
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;

            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0;
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            height = 76;
        }
        else
        {
            if (_placeAddressCell == nil) {
                _placeAddressCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HSSubmitOrderAddressTableViewCell class])];
                _placeAddressCell.bounds = tableView.bounds;
                [_placeAddressCell setNeedsLayout];
            }
            NSLog(@"cell hei %f", _placeAddressCell.detailLabel.frame.size.width);
            [_placeAddressCell setUpWithModel:_addressModel];
            _placeAddressCell.detailLabel.preferredMaxLayoutWidth = _placeAddressCell.detailLabel.frame.size.width;
            [_placeAddressCell.contentView updateConstraintsIfNeeded];
            [_placeAddressCell.contentView layoutIfNeeded];
            height = [_placeAddressCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1.0;

        }
        
    }
    else
    {
        if (indexPath.row < _commdityDataArray.count) {
            height = 80;
        }
        else
        {
            height = 44;
        }
    }
    
    return height;
}


@end
