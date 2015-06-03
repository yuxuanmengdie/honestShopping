//
//  HSMineFavoriteViewController.m
//  honestShopping
//
//  Created by 张国俗 on 15-5-26.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "HSMineFavoriteViewController.h"
#import "HSFavoriteTableViewCell.h"

#import "HSCommodtyItemModel.h"

@interface HSMineFavoriteViewController ()<UITableViewDataSource,
UITableViewDelegate>
{
    NSArray *_favoriteDataArray;
}

@property (weak, nonatomic) IBOutlet UITableView *favoriteTableView;

@end

@implementation HSMineFavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_favoriteTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HSFavoriteTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HSFavoriteTableViewCell class])];
    
    _favoriteTableView.tableFooterView = [[UIView alloc] init];
    _favoriteTableView.dataSource = self;
    _favoriteTableView.delegate = self;

    [self favoriteRequestWithUid:[public controlNullString:_userInfoModel.id] sessionCode:[public controlNullString:_userInfoModel.sessionCode]];

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
#pragma mark 获取我的收藏 关注
- (void)favoriteRequestWithUid:(NSString *)uid sessionCode:(NSString *)sessionCode
{
    [self showNetLoadingView];
    NSDictionary *parametersDic = @{kPostJsonKey:[public md5Str:[public getIPAddress:YES]],
                                    kPostJsonUid:uid,
                                    kPostJsonSessionCode:sessionCode
                                    };
    [self.httpRequestOperationManager POST:kGetFavoriteURL parameters:@{kJsonArray:[public dictionaryToJson:parametersDic]} success:^(AFHTTPRequestOperation *operation, id responseObject) { /// 失败
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
            NSArray *jsonArr = (NSArray *)json;
            NSMutableArray *tmp = [[NSMutableArray alloc] initWithCapacity:jsonArr.count];
            
            [jsonArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                @autoreleasepool {
                    HSCommodtyItemModel *itemModel = [[HSCommodtyItemModel alloc] initWithDictionary:obj error:nil];
                    [tmp addObject:itemModel];
                }
            }];
            
            _favoriteDataArray = tmp;
            [_favoriteTableView reloadData];
            
        }
        else
        {
            
        }
    }];
    
}

- (void)reloadRequestData
{
    [self favoriteRequestWithUid:[public controlNullString:_userInfoModel.id] sessionCode:[public controlNullString:_userInfoModel.sessionCode]];

}

#pragma mark -
#pragma mark 取消关注

#pragma mark -
#pragma mark tableView dataSource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = _favoriteDataArray.count;
    if (num == 0 && !self.isRequestLoading) {
        [self placeViewWithImgName:nil text:@"还没有收藏"];
    }
    else
    {
        [self removePlaceView];
    }

    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HSFavoriteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HSFavoriteTableViewCell class]) forIndexPath:indexPath];
    HSCommodtyItemModel *model = _favoriteDataArray[indexPath.row];
    [cell setupWirhModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
