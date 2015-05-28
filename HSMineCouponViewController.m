//
//  HSMineCouponViewController.m
//  honestShopping
//
//  Created by 张国俗 on 15-5-26.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "HSMineCouponViewController.h"
#import "HSCouponTableViewCell.h"

@interface HSMineCouponViewController ()<UITableViewDataSource,
UITableViewDelegate>
{
    NSArray *_couponDataArray;
}

@property (weak, nonatomic) IBOutlet UITableView *couponTableView;
@end

@implementation HSMineCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_couponTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HSCouponTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HSCouponTableViewCell class])];
    
    _couponTableView.tableFooterView = [[UIView alloc] init];
    [self couponRequestWithUid:[public controlNullString:_userInfoModel.id] sessionCode:[public controlNullString:_userInfoModel.sessionCode]];
    
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
#pragma mark 获取优惠券
- (void)couponRequestWithUid:(NSString *)uid sessionCode:(NSString *)sessionCode
{
    [self showNetLoadingView];
    NSDictionary *parametersDic = @{kPostJsonKey:[public md5Str:[public getIPAddress:YES]],
                                    kPostJsonUid:uid,
                                    kPostJsonSessionCode:sessionCode
                                    };
    [self.httpRequestOperationManager POST:kGetCouponsByUidURL parameters:@{kJsonArray:[public dictionaryToJson:parametersDic]} success:^(AFHTTPRequestOperation *operation, id responseObject) { /// 失败
        [self hiddenMsg];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed\n%@",operation.responseString);
        [self hiddenMsg];
        if (operation.responseData == nil) {
            [self showReqeustFailedMsg];
            return ;
        }
        NSError *jsonError = nil;
        id json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:&jsonError];
        if (jsonError == nil && [json isKindOfClass:[NSDictionary class]]) {
            NSDictionary *tmp = (NSDictionary *)json;
        }
        else
        {
            
        }
    }];

}

#pragma mark -
#pragma mark tableView dataSource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = _couponDataArray.count;
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HSCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HSCouponTableViewCell class]) forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
