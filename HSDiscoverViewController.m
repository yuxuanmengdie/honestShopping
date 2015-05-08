//
//  HSDiscoverViewController.m
//  honestShopping
//
//  Created by 张国俗 on 15-5-4.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "HSDiscoverViewController.h"
#import "HSCommodityDetailTableViewCell.h"
#import "HSBannerModel.h"
#import "UIImageView+WebCache.h"
#import "HSCommodtyItemModel.h"
#import "HSCommodityDetailViewController.h"

@interface HSDiscoverViewController ()<UITableViewDataSource,
UITableViewDelegate>
{
    NSArray *_discoverArray;
    
    NSMutableDictionary *_imageSizeDic;
}

@property (weak, nonatomic) IBOutlet UITableView *discoverTableView;

@end

@implementation HSDiscoverViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发现生活";
    
    [_discoverTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HSCommodityDetailTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HSCommodityDetailTableViewCell class])];
    _discoverTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _discoverTableView.dataSource = self;
    _discoverTableView.delegate = self;
    
    _imageSizeDic = [[NSMutableDictionary alloc] init];
    [self discoverRequest];
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
#pragma mark 获取discover 数据
- (void)discoverRequest
{
    [self showNetLoadingView];
    NSDictionary *parametersDic = @{kPostJsonKey:[public md5Str:[public getIPAddress:YES]]
                                   };
    __weak typeof(self) wself = self;
    [self.httpRequestOperationManager POST:kGetDiscoverURL parameters:@{kJsonArray:[public dictionaryToJson:parametersDic]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [wself showReqeustFailedMsg];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        __strong typeof(wself) swself = wself;
        if (swself == nil) {
            return ;
        }
        
        NSLog(@"response=%@",operation.responseString);
        NSString *str = (NSString *)operation.responseString;
        NSString *result = str;
        
        NSData *data =  [result dataUsingEncoding:NSUTF8StringEncoding];
        if (data == nil) {
            [swself showReqeustFailedMsg];
            [swself showHudWithText:@"加载失败"];
            return ;
        }
        [self hiddenMsg];
       
        NSError *jsonError = nil;
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        NSLog(@"!!!!%@",json);
        if ([json isKindOfClass:[NSArray class]] && jsonError == nil) {
            
            NSArray *tmpJson = (NSArray *)json;
            NSMutableArray *tmp = [[NSMutableArray alloc] init];
            [tmpJson enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                HSBannerModel *model = [[HSBannerModel alloc] initWithDictionary:obj error:nil];
                NSString *fullURL = [NSString stringWithFormat:@"%@%@",kBannerImageHeaderURL,model.content];
                model.content = fullURL;
                [tmp addObject:model];
            }];
            
            _discoverArray = tmp;
            [_discoverTableView reloadData];
        }
    }];

}

- (void)reloadRequestData
{
    [self discoverRequest];
}
#pragma mark -
#pragma mark  tableView dataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HSCommodityDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HSCommodityDetailTableViewCell class]) forIndexPath:indexPath];
    HSBannerModel *model = _discoverArray[indexPath.row];
    
    cell.detailImageView.image = kPlaceholderImage;
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:model.content]
                                                    options:0
                                                   progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                       // progression tracking code
                                                   }
                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                      if (image) {
                                                          // do something with image
                                                          cell.detailImageView.image = image;
                                                          
                                                          NSValue *imgSize =  [NSValue valueWithCGSize:image.size];
                                                          NSDictionary *dic = [_imageSizeDic objectForKey:[self p_keyFromIndex:indexPath]];
                                                          if (dic != nil ) {
                                                              NSURL *imgURL = dic[kImageURLKey];
                                                              NSValue *sizeValue = dic[kImageSizeKey];
                                                              if ([imgURL isEqual:imageURL] && [sizeValue isEqual:imgSize]) {
                                                                  return ;
                                                              }
                                                          }
                                                          
                                                          NSDictionary *tmpDic = @{kImageSizeKey:imgSize,
                                                                                   kImageURLKey:imageURL};
                                                          
                                                          [_imageSizeDic setObject:tmpDic forKey:[self p_keyFromIndex:indexPath]];
                                                          
                                                          
                                                          
                                                          // NSLog(@"cell   %d  ob=%@",indexPath.row,_imageSizeDic[ind]);
                                                          if (tableView.dataSource != nil) {
                                                              [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic ];
                                                          }
                                                          
                                                          
                                                          
                                                      }
                                                  }];
    

    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _discoverArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 200.0;
    NSDictionary *dic = [_imageSizeDic objectForKey:[self p_keyFromIndex:indexPath]];
   
    if (dic != nil) {
        NSValue *sizeValue = dic[kImageSizeKey];
        if (sizeValue.CGSizeValue.width != 0.0) { /// 宽度为0时 防止除0错误
            float per = (float)sizeValue.CGSizeValue.height / sizeValue.CGSizeValue.width;
            height = per * CGRectGetWidth(tableView.frame);
        }
    }

    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HSBannerModel *model = _discoverArray[indexPath.row];
    HSCommodtyItemModel *itemModel = [[HSCommodtyItemModel alloc] init];
    itemModel.id = model.desc;
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HSCommodityDetailViewController *detailVC = [board instantiateViewControllerWithIdentifier:NSStringFromClass([HSCommodityDetailViewController class])];
    detailVC.itemModel = itemModel;
    [self.navigationController pushViewController:detailVC animated:YES];

}


- (NSString *)p_keyFromIndex:(NSIndexPath *)index
{
    if (index == nil) {
        return @"";
    }
    
    NSString *result = [NSString stringWithFormat:@"indexsec%ldrow%ld",(long)index.section,(long)index.row];
    return result;
}


@end
