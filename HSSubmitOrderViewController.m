//
//  HSSubmitOrderViewController.m
//  honestShopping
//
//  Created by 张国俗 on 15-6-1.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "HSSubmitOrderViewController.h"
#import "HSMineAddressViewController.h"

#import "HSSubmitOrderAddressTableViewCell.h"
#import "HSSubmitOrderCommdityTableViewCell.h"
#import "UIView+HSLayout.h"

#import "HSCommodityItemDetailPicModel.h"
#import "HSAddressModel.h"

@interface HSSubmitOrderViewController ()<UITableViewDelegate,
UITableViewDataSource>
{
    NSArray *_commdityDataArray; /// 包含商品的列表
    
    HSSubmitOrderAddressTableViewCell *_placeAddressCell;
    
    HSAddressModel *_addressModel;
}
@property (weak, nonatomic) IBOutlet UITableView *submitOrdertableView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIView *bottomSepView;

@property (weak, nonatomic) IBOutlet UILabel *_totalPriceLabel;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation HSSubmitOrderViewController

static const float kPostagePrice = 6.00;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _commdityDataArray = _itemsDataArray;
    [_submitOrdertableView registerNib:[UINib nibWithNibName:NSStringFromClass([HSSubmitOrderAddressTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HSSubmitOrderAddressTableViewCell class])];
    [_submitOrdertableView registerNib:[UINib nibWithNibName:NSStringFromClass([HSSubmitOrderCommdityTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HSSubmitOrderCommdityTableViewCell class])];
    [_submitOrdertableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    _submitOrdertableView.dataSource = self;
    _submitOrdertableView.delegate = self;
    
    [self getDefaultAddressWithUid:[public controlNullString:_userInfoModel.id] sessionCode:[public controlNullString:_userInfoModel.sessionCode]];
    [self bottomViewSetup];
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
#pragma mark bottomView的状态
- (void)bottomViewSetup
{
    self._totalPriceLabel.textColor = [UIColor redColor];
    self._totalPriceLabel.text = [NSString stringWithFormat:@"应付金额：%0.2f",[self totolMoneyWithoutPostage]+kPostagePrice];

    [_submitButton setBackgroundImage:[public ImageWithColor:kAppYellowColor] forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitButton setTitle:@"确认订单" forState:UIControlStateNormal];
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = 5.0;
}


- (IBAction)submitAction:(id)sender {
    [self addOrderWithUid:[public controlNullString:_userInfoModel.id] couponId:@"" username:[public controlNullString:_addressModel.consignee] addressName:@"" mobile:[public controlNullString:_addressModel.mobile] address:[NSString stringWithFormat:@"%@%@%@%@",[public controlNullString:_addressModel.sheng],[public controlNullString:_addressModel.shi],[public controlNullString:_addressModel.qu],[public controlNullString:_addressModel.address]]supportmethod:@"1" freetype:@"1" sessionCode:[public controlNullString:_userInfoModel.sessionCode] list:[self listOrder]];
    
}

#pragma mark -
#pragma mark 获取默认地址
- (void)getDefaultAddressWithUid:(NSString *)uid sessionCode:(NSString *)sessionCode
{
    [self showNetLoadingView];
    NSDictionary *parametersDic = @{kPostJsonKey:[public md5Str:[public getIPAddress:YES]],
                                    kPostJsonUid:uid,
                                    kPostJsonSessionCode:sessionCode
                                    };
    // 142346261  123456
    
    [self.httpRequestOperationManager POST:kGetDefaultAddressURL parameters:@{kJsonArray:[public dictionaryToJson:parametersDic]} success:^(AFHTTPRequestOperation *operation, id responseObject) { /// 失败
        NSLog(@"success\n%@",operation.responseString);
        
        [self hiddenMsg];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s failed\n%@",__func__,operation.responseString);
        [self hiddenMsg];
        if (operation.responseData == nil) {
            [self showReqeustFailedMsg];
            return ;
        }
        NSError *jsonError = nil;
        id json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:&jsonError];
        if (jsonError == nil && [json isKindOfClass:[NSArray class]]) {
            NSArray *tmpArr = (NSArray *)json;
            [tmpArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                
                HSAddressModel *model = [[HSAddressModel alloc] initWithDictionary:obj error:nil];
                if (model.id.length > 0) {
                    _addressModel = model;
                    [_submitOrdertableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                
                if (idx == 0) {
                    *stop = YES;
                }

            }];
            }
        else
        {
           
        }
    }];

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

#pragma mark -
#pragma mark 根据商品数组组织订单的上传字段
- (NSArray *)listOrder
{
    NSMutableArray *tmp = [[NSMutableArray alloc] initWithCapacity:_commdityDataArray.count];
    
    [_commdityDataArray enumerateObjectsUsingBlock:^(HSCommodityItemDetailPicModel *obj, NSUInteger idx, BOOL *stop) {
        NSString *itemId = obj.id;
        
        NSString *cid = [public controlNullString:obj.id];
        NSNumber *num = _itemNumDic[cid];
        int count = [num intValue] < 0 ? 0 : [num intValue];
        
        NSDictionary *dic = @{kPostJsonItemid:[public controlNullString:itemId],
                              kPostJsonQuantity:[NSNumber numberWithInt:count]};
        [tmp addObject:dic];
        
    }];
    
    return tmp;
}

#pragma mark -
#pragma mark 确认订单
/*
 {"uid":143,"couponId":205,"username":"ssss","addressName":"aaaa","mobile":13916077449,"address":"dddd","supportmethod":1,"freetype":1,"list":[{"itemId":155,"quantity":1},{"itemId":156,"quantity":2}],"sessionCode":"10EEF472-09FE-1B20-900C-E6E4322FF855","key":"f528764d624db129b32c21fbca0cb8d6"}
 */
- (void)addOrderWithUid:(NSString *)uid couponId:(NSString *)couponId username:(NSString *)username addressName:(NSString *)addressName mobile:(NSString *)mobile address:(NSString *)address supportmethod:(NSString *)supportmethod freetype:(NSString *)freetype sessionCode:(NSString *)sessionCode list:(NSArray *)list
{
    [self showhudLoadingInWindowWithText:@"提交订单..." isDimBackground:YES];
    NSDictionary *parametersDic = @{kPostJsonKey:[public md5Str:[public getIPAddress:YES]],
                                    kPostJsonUid:uid,
                                    kPostJsonCouponId:couponId,
                                    kPostJsonUserName:username,
                                    kPostJsonAddressName:addressName,
                                    kPostJsonMobile:mobile,
                                    kPostJsonAddress:address,
                                    kPostJsonSupportmethod:supportmethod,
                                    kPostJsonFreetype:freetype,
                                    kPostJsonSessionCode:sessionCode,
                                    kPostJsonList:list,
                                    };
    // 142346261  123456
    
    [self.httpRequestOperationManager POST:kAddOrderURL parameters:@{kJsonArray:[public dictionaryToJson:parametersDic]} success:^(AFHTTPRequestOperation *operation, id responseObject) { /// 失败
        NSLog(@"success\n%@",operation.responseString);
        
        [self hiddenHudLoading];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s failed\n%@",__func__,operation.responseString);
        [self hiddenHudLoading];
        if (operation.responseData == nil) {
            return ;
        }
        NSError *jsonError = nil;
        id json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:&jsonError];
        if (jsonError == nil && [json isKindOfClass:[NSDictionary class]]) {
            NSDictionary *tmpDic = (NSDictionary *)json;
            NSString *orderNo = tmpDic[kPostJsonOrderNo];
            if (orderNo.length > 0) {
                 [self showHudWithText:@"订单提交成功"];
            }
            
        }
        else
        {
            
        }
    }];

}



#pragma mark -
#pragma mark tableView dataSource and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = 0;
    if (section == 0) {
        num = 1;
    }
    else // 商品种类 + 优惠券 + 运费 + 总计
    {
        num = _commdityDataArray.count + 3;
    }
    
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) { /// 地址
        HSSubmitOrderAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HSSubmitOrderAddressTableViewCell class]) forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell setUpWithModel:_addressModel];
        return cell;
    }
    else
    {
        if (indexPath.row < _commdityDataArray.count) { /// 商品详情
            HSSubmitOrderCommdityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HSSubmitOrderCommdityTableViewCell class]) forIndexPath:indexPath];
            HSCommodityItemDetailPicModel *detailModel = _commdityDataArray[indexPath.row];
            int num = [_itemNumDic[[public controlNullString:detailModel.id]] intValue];
            [cell setUpWithModel:detailModel imagePreURl:kImageHeaderURL num:num];
            
            return cell;
        }
        else
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
            if (indexPath.row == _commdityDataArray.count) { // 优惠券
                 UILabel *leftLabel = (UILabel *)[cell.contentView viewWithTag:501];
                if (leftLabel == nil) {
                    leftLabel = [[UILabel alloc] init];
                    leftLabel.tag = 501;
                    leftLabel.font = [UIFont systemFontOfSize:14];
                    leftLabel.translatesAutoresizingMaskIntoConstraints = NO;
                    [cell.contentView addSubview:leftLabel];
                    [cell.contentView HS_dispacingWithFisrtView:cell.contentView fistatt:NSLayoutAttributeLeading secondView:leftLabel secondAtt:NSLayoutAttributeLeading constant:-8];
                    [cell.contentView HS_centerYWithSubView:leftLabel];
                    
                }
                leftLabel.text = @"优惠券";

            }
            else if (indexPath.row == _commdityDataArray.count + 1) // 运费
            {
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
                leftLabel.text = @"运费";
                rightLabel.text = @"6.00";
            }
            else // 合计
            {
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
                
            }
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0;
    
    if (indexPath.section == 0) {
        
        if (_placeAddressCell == nil) {
            _placeAddressCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HSSubmitOrderAddressTableViewCell class])];
            _placeAddressCell.bounds = tableView.bounds;
            _placeAddressCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [_placeAddressCell setNeedsLayout];
        }
        NSLog(@"cell hei %f", _placeAddressCell.detailLabel.frame.size.width);
        [_placeAddressCell setUpWithModel:_addressModel];
        _placeAddressCell.detailLabel.preferredMaxLayoutWidth = _placeAddressCell.detailLabel.frame.size.width;
        [_placeAddressCell.contentView updateConstraintsIfNeeded];
        [_placeAddressCell.contentView layoutIfNeeded];
        height = [_placeAddressCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1.0;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        UIStoryboard *stroyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HSMineAddressViewController *vc = [stroyBoard instantiateViewControllerWithIdentifier:NSStringFromClass([HSMineAddressViewController class])];
        vc.userInfoModel = _userInfoModel;
        vc.addressType = HSMineAddressSelecteType;
        vc.addressID = _addressModel.id;
        vc.title = @"选择收货地址";
        [self.navigationController pushViewController:vc animated:YES];
        
        __weak typeof(self) wself = self;
        vc.selectBlock = ^(HSAddressModel *addModel){
            __strong typeof(wself) swself = wself;
            swself->_addressModel = addModel;
            [swself->_submitOrdertableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
    }
}
@end
