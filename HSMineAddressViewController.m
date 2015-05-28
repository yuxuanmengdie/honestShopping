//
//  HSMineAddressViewController.m
//  honestShopping
//
//  Created by 张国俗 on 15-5-26.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "HSMineAddressViewController.h"
#import "HSEditAddressViewController.h"
#import "HSAddressDetailViewController.h"

#import "HSAddressTableViewCell.h"

#import "HSAddressModel.h"

@interface HSMineAddressViewController ()<UITableViewDataSource,
UITableViewDelegate>
{
    NSArray *_addressDataArray;
    
    HSAddressTableViewCell *_palaceCell;
}

@property (weak, nonatomic) IBOutlet UITableView *addressTableView;
@end

@implementation HSMineAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarRightBarWithTitle:@"新增地址" action:@selector(addNewAddress)];
    
    [_addressTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HSAddressTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HSAddressTableViewCell class])];
    
    _addressTableView.tableFooterView = [[UIView alloc] init];
    [self addressRequestWithUid:[public controlNullString:_userInfoModel.id] sessionCode:[public controlNullString:_userInfoModel.sessionCode]];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
#pragma mark 获取我的地址
- (void)addressRequestWithUid:(NSString *)uid sessionCode:(NSString *)sessionCode
{
    [self showNetLoadingView];
    NSDictionary *parametersDic = @{kPostJsonKey:[public md5Str:[public getIPAddress:YES]],
                                    kPostJsonUid:uid,
                                    kPostJsonSessionCode:sessionCode
                                    };
    [self.httpRequestOperationManager POST:kGetAddressURL parameters:@{kJsonArray:[public dictionaryToJson:parametersDic]} success:^(AFHTTPRequestOperation *operation, id responseObject) { /// 失败
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
        if (jsonError == nil && [json isKindOfClass:[NSArray class]]) {
            NSArray *jsonArr = (NSArray *)json;
            NSMutableArray *tmpArr = [[NSMutableArray alloc] initWithCapacity:jsonArr.count];
            [jsonArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                @autoreleasepool {
                    HSAddressModel *model = [[HSAddressModel alloc] initWithDictionary:obj error:nil];
                    [tmpArr addObject:model];
                }
                
            }];
            
            _addressDataArray = tmpArr;
            [_addressTableView reloadData];
        }
        else
        {
            
        }
    }];
    
}

#pragma mark -
#pragma mark 添加新地址
- (void)addNewAddress
{
    UIStoryboard *stroyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HSEditAddressViewController *editVC = [stroyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HSEditAddressViewController class])];
    editVC.userInfoModel = _userInfoModel;
    editVC.title = @"新增收货地址";
    editVC.addressChangeType = HSeditaddressByAddType;
    [self.navigationController pushViewController:editVC animated:YES];
}

#pragma mark -
#pragma mark tableView dataSource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = _addressDataArray.count;
    
    if (num == 0) {
        [self placeViewWithImgName:@"search_no_content" text:@"还没有地址信息，请添加。"];
    }
    else
    {
        [self removePlaceView];
    }
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HSAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HSAddressTableViewCell class]) forIndexPath:indexPath];
    cell.separatorInset = UIEdgeInsetsZero;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_palaceCell == nil) {
        _palaceCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HSAddressTableViewCell class])];
        _palaceCell.contentView.bounds = tableView.frame;
    }
    [_palaceCell.contentView updateConstraintsIfNeeded];
     [_palaceCell.contentView layoutIfNeeded];
    CGFloat height = [_palaceCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height + 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HSAddressModel *model = _addressDataArray[indexPath.row];
    UIStoryboard *stroyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HSEditAddressViewController *editVC = [stroyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HSEditAddressViewController class])];
    editVC.addressModel = model;
    editVC.userInfoModel = _userInfoModel;
    editVC.title = @"修改地址信息";
    editVC.addressChangeType = HSeditaddressByUpdateType;
    [self.navigationController pushViewController:editVC animated:YES];
}


@end
