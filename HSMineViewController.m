//
//  HSMineViewController.m
//  honestShopping
//
//  Created by 张国俗 on 15-5-4.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "HSMineViewController.h"
#import "HSMineTopTableViewCell.h"
#import "HSLoginInViewController.h"
#import "HSMineTableViewCell.h"
#import "HSUserInfoModel.h"

@interface HSMineViewController ()<UITableViewDataSource,
UITableViewDelegate>
{
    NSArray *_mineDataArray;
    
    HSMineTopTableViewCell *_topCell;
    
    HSUserInfoModel *_userInfoModel;
}

@property (weak, nonatomic) IBOutlet UITableView *mineTableView;

@end

@implementation HSMineViewController

static NSString *const kCellIdentifier = @"HSMineViewControllerCellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的";
    [self setUpDataArray];
    [self getLastetUserInfoModel];
    [_mineTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HSMineTopTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HSMineTopTableViewCell class])];
    [_mineTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HSMineTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HSMineTableViewCell class])];
    _mineTableView.dataSource = self;
    _mineTableView.delegate = self;
    _mineTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
}



- (void)setUpDataArray
{
    _mineDataArray = @[@"待付款订单(0)",
                       @"待发货订单(0)",
                       @"待收获订单(0)",
                       @"已完成订单(0)",
                       @"我的收货地址(0)"];
}

- (void)getLastetUserInfoModel
{
    if ([public isLoginInStatus]) {
        NSDictionary *dic = [public userInfoFromPlist];
        _userInfoModel = [[HSUserInfoModel alloc] initWithDictionary:dic error:nil];
    }
    else
    {
        _userInfoModel = nil;
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getLastetUserInfoModel];
    if ([public isLoginInStatus]) {
        [self userInfoRequest:_userInfoModel.username phone:_userInfoModel.phone];
    }
    
    
    
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
#pragma mark 获取个人信息
- (void)userInfoRequest:(NSString *)userName phone:(NSString *)phone
{

    NSDictionary *parametersDic = @{kPostJsonKey:[public getIPAddress:YES],
                                    kPostJsonUserName:userName,
                                    kPostJsonPhone:phone
                                    };
    // 142346261  123456
    
    [self.httpRequestOperationManager POST:kGetUserInfoURL parameters:@{kJsonArray:[public dictionaryToJson:parametersDic]} success:^(AFHTTPRequestOperation *operation, id responseObject) { /// 失败
        NSLog(@"success\n%@",operation.responseString);
        [self showHudWithText:@"用户信息获取失败"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed\n%@",operation.responseString);
        if (operation.responseData == nil) {
            [self showHudWithText:@"用户信息获取失败"];
            return ;
        }
        NSError *jsonError = nil;
        id json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:&jsonError];
        if (jsonError == nil && [json isKindOfClass:[NSDictionary class]]) {
            [self showHudWithText:@"用户信息获取成功"];
            
            HSUserInfoModel *infoModel = [[HSUserInfoModel alloc] initWithDictionary:json error:nil];
            if (infoModel.sessionCode.length < 1) { /// 获取的信息 不包含session 保存下来
                infoModel.sessionCode = _userInfoModel.sessionCode;
            }
            [public saveUserInfoToPlist:[infoModel toDictionary]];
            _userInfoModel = infoModel;
            [_mineTableView reloadData];
        }
        else
        {
            [self showHudWithText:@"用户信息获取失败"];
        }
    }];

    
}

#pragma mark -
#pragma mark 签到
- (void)signRequestWithUid:(NSString *)uid  sessionCode:(NSString *)sessionCode
{
    NSDictionary *parametersDic = @{kPostJsonKey:[public getIPAddress:YES],
                                    kPostJsonUid:uid,
                                    kPostJsonSessionCode:sessionCode
                                    };
    [self.httpRequestOperationManager POST:kSignURL parameters:@{kJsonArray:[public dictionaryToJson:parametersDic]} success:^(AFHTTPRequestOperation *operation, id responseObject) { /// 失败
        NSLog(@"success\n%@",operation.responseString);
        [self showHudWithText:@"签到失败"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed\n%@",operation.responseString);
        if (operation.responseData == nil) {
            [self showHudWithText:@"签到失败"];
            return ;
        }
        NSError *jsonError = nil;
        id json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:&jsonError];
        if (jsonError == nil && [json isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *tmp = (NSDictionary *)json;
            BOOL isSign = [tmp[kPostJsonStatus] boolValue];
            if (isSign) {
                [self showHudInWindowWithText:@"签到成功"];
                _userInfoModel.sign = isSign;
                [_mineTableView reloadData];
            }
            else
            {
                [self showHudInWindowWithText:@"已签到"];

            }
        }
        else
        {
            [self showHudWithText:@"签到失败"];
        }
    }];

}


#pragma mark - 
#pragma mark tableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = 0;
    if (section != 1) {
        num = 1;
    }
    else
    {
        num = _mineDataArray.count;
    }
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HSMineTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HSMineTopTableViewCell class]) forIndexPath:indexPath];
        if ([public isLoginInStatus]) {
            [cell welcomeText:_userInfoModel.username isLogin:YES];
            [cell signStatus:_userInfoModel.sign];
        }
        else
        {
            [cell signStatus:NO];
            [cell welcomeText:nil isLogin:NO];
        }
        
        __weak typeof(self) wself = self;
        cell.signBlock = ^{ /// 如果没登录  进入登录界面
            __strong typeof(wself) swself = wself;
            if (swself == nil) {
                return ;
            }
            if (![public isLoginInStatus]){ /// 没有登录 提示登录
                [swself pushViewControllerWithIdentifer:NSStringFromClass([HSLoginInViewController class])];
                return;
            }

            [swself signRequestWithUid:swself->_userInfoModel.id sessionCode:swself->_userInfoModel.sessionCode];
        };
        
        return cell;
    }
    else
    {
        HSMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HSMineTableViewCell class]) forIndexPath:indexPath];
        if (indexPath.section == 1) {
            cell.mainTitleLaabel.text = _mineDataArray[indexPath.row];
        }
        else
        {
            cell.mainTitleLaabel.text = @"186-5506-1482";
        }
        
        cell.iconImageView.image = [UIImage imageNamed:@"icon_star_full"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44;
    
    if (indexPath.section == 0) {
        if (_topCell == nil) {
            _topCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HSMineTopTableViewCell class])];
            _topCell.bounds = tableView.bounds;
        }
        [_topCell.contentView updateConstraintsIfNeeded];
        [_topCell.contentView layoutIfNeeded];
        
        height = [_topCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![public isLoginInStatus]){ /// 没有登录 提示登录
        [self pushViewControllerWithIdentifer:NSStringFromClass([HSLoginInViewController class])];
        return;
    }
    
    if (0 == indexPath.section) { // 个人信息
        
    }
    else if (1 == indexPath.section) /// 订单相关
    {
        
    }
    else /// 打电话
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://18655061482"]];
    }
}
@end
