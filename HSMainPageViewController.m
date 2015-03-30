//
//  HSMainPageViewController.m
//  honestShopping
//
//  Created by 张国俗 on 15-3-16.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "HSMainPageViewController.h"
#import "HSCommodityCategaryCollectionViewCell.h"
#import "HSCommodityViewController.h"
#import "HSSanpinViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "define.h"
#import "FFScrollView.h"
#import "JSONModel.h"
#import "HSCategariesModel.h"
#import "HSBannerModel.h"
#import "HSItemPageModel.h"
#import "HSCommodtyItemModel.h"


@interface HSMainPageViewController ()<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout>
{
    /// 类别数组
    NSArray *_categariesArray;
    
    ///轮播图
    NSArray *_bannerArray;
    
    
    /// 保存不同类别的item
    NSMutableDictionary *_cateItemsDataDic;
    
    /// 选中的类别
    NSIndexPath *_selectedCategary;
    
    /// 单独商品的vc
    HSCommodityViewController *_commodityViewController;
    
    /// 三品一标
    HSSanpinViewController *_sanpinViewController;
    
    /// 热销顶部的滚动试图
    FFScrollView *_ffScrollView;
    
    /// 顶部滚动高度约束
    NSLayoutConstraint *_ffScrollViewHeightConstraint;
}

@property (weak, nonatomic) IBOutlet UICollectionView *topCategariesCollectionView;


@end

@implementation HSMainPageViewController

static NSString *const kCategariesCollectionViewCellIdentifier = @"CommodityCellIdentifier";

static const float kFFScrollViewHeight = 200;
static const float kItemSize = 10;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }

    
    [_topCategariesCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HSCommodityCategaryCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kCategariesCollectionViewCellIdentifier];
    _topCategariesCollectionView.delegate = self;
    _topCategariesCollectionView.dataSource = self;

   
    _cateItemsDataDic = [[NSMutableDictionary alloc] init];
    
    
//    _categariesArray = @[@"热销",@"三品一标",@"果蔬",@"禽蛋",@"粮油",@"养生",@"干货",@"茶叶",@"特产"];
    
    _selectedCategary = [NSIndexPath indexPathForRow:0 inSection:0];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _commodityViewController = [storyboard instantiateViewControllerWithIdentifier:@"commodityViewController"];
    _sanpinViewController = [storyboard instantiateViewControllerWithIdentifier:@"sanpinViewController"];
    [self ffScrollViewInit];
    [self commodityLatout];
    [self sanpinLayout];
    NSLog(@"ip:%@",[public getIPAddress:YES]);
    
    [self getCommofityCategaries:nil];
    [self getBannerImages];
    
    
       

    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view updateConstraintsIfNeeded];
    [self.view layoutIfNeeded];
    float wid = [_ffScrollView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width;
    NSLog(@"!!!!!wid=%f，sss=%f",wid,CGRectGetWidth(_ffScrollView.frame));

}

- (void)ffScrollViewInit
{
    _ffScrollView = [[FFScrollView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_ffScrollView];
    _ffScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    NSString *vfl1 = @"H:|[_ffScrollView]|";
    NSString *vfl2 = @"V:[_topCategariesCollectionView][_ffScrollView]";
    NSDictionary *dic = NSDictionaryOfVariableBindings(_topCategariesCollectionView,_ffScrollView,self.view);
    NSArray *arr1 = [NSLayoutConstraint constraintsWithVisualFormat:vfl1 options:0 metrics:nil views:dic];
    NSArray *arr2 = [NSLayoutConstraint constraintsWithVisualFormat:vfl2 options:0 metrics:nil views:dic];
    
    _ffScrollViewHeightConstraint  = [NSLayoutConstraint constraintWithItem:_ffScrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kFFScrollViewHeight];
    [self.view addConstraints:arr1];
    [self.view addConstraints:arr2];
    [self.view addConstraint:_ffScrollViewHeightConstraint];

    
}



- (void)commodityLatout
{
    
    UIView *commodityView = _commodityViewController.view;
    [self.view addSubview:commodityView];
    commodityView.translatesAutoresizingMaskIntoConstraints = NO;
    NSString *vfl1 = @"H:|[commodityView]|";
    NSString *vfl2 = @"V:[_ffScrollView][commodityView]|";
    NSDictionary *dic = NSDictionaryOfVariableBindings(_ffScrollView,commodityView,self.view);
    NSArray *arr1 = [NSLayoutConstraint constraintsWithVisualFormat:vfl1 options:0 metrics:nil views:dic];
    NSArray *arr2 = [NSLayoutConstraint constraintsWithVisualFormat:vfl2 options:0 metrics:nil views:dic];
    [self.view addConstraints:arr1];
    [self.view addConstraints:arr2];
}


- (void)sanpinLayout
{
    
    UIView *commodityView = _sanpinViewController.view;
    [self.view addSubview:commodityView];
    commodityView.translatesAutoresizingMaskIntoConstraints = NO;
    NSString *vfl1 = @"H:|[commodityView]|";
    NSString *vfl2 = @"V:[_topCategariesCollectionView][commodityView]|";
    NSDictionary *dic = NSDictionaryOfVariableBindings(_topCategariesCollectionView,commodityView,self.view);
    NSArray *arr1 = [NSLayoutConstraint constraintsWithVisualFormat:vfl1 options:0 metrics:nil views:dic];
    NSArray *arr2 = [NSLayoutConstraint constraintsWithVisualFormat:vfl2 options:0 metrics:nil views:dic];
    [self.view addConstraints:arr1];
    [self.view addConstraints:arr2];
    
    commodityView.hidden = YES;
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


#pragma  mark collectionView dataSource and delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _categariesArray.count;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HSCommodityCategaryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCategariesCollectionViewCellIdentifier forIndexPath:indexPath];
    
    if ([indexPath isEqual:_selectedCategary]) {
        [cell changeTitleColorAndFont:YES];
    }
    else
    {
        [cell changeTitleColorAndFont:NO];
    }
    HSCategariesModel *model = _categariesArray[indexPath.row];
    cell.categaryTitleLabel.text = model.name;
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([_selectedCategary isEqual:indexPath]) {
        return;
    }
    NSIndexPath *tmp = _selectedCategary;
    _selectedCategary = indexPath;
    [collectionView reloadItemsAtIndexPaths:@[tmp]];
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    [collectionView scrollToItemAtIndexPath:_selectedCategary atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    
    BOOL isShow = indexPath.row == 1 ? YES : NO;
    [self sanpinViewShow:isShow];
    
    if (indexPath.row == 0) {
        _ffScrollViewHeightConstraint.constant = kFFScrollViewHeight;
        [self.view updateConstraints];
        [self.view layoutIfNeeded];
    }
    else
    {
        _ffScrollViewHeightConstraint.constant = 0;
        [self.view updateConstraints];
        [self.view layoutIfNeeded];
    }
    
    HSCategariesModel *cateModel = _categariesArray[indexPath.row];
    [self GetItemsWithCid:cateModel.id size:kItemSize key:[public md5Str:[public getIPAddress:YES]] page:1];
    
}

//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(80, 50);
//    
//}
//
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(5, 5, 5, 5);
//}




////
- (void)sanpinViewShow:(BOOL)isShow
{
    if (isShow) {
        /// 点到三品一标 时切换试图
        _sanpinViewController.view.hidden = NO;
        _commodityViewController.view.hidden = YES;
    }
    else
    {
        
        _sanpinViewController.view.hidden = YES;
        _commodityViewController.view.hidden = NO;
    }
}


#pragma mark 获取数据

- (void)getCommofityCategaries:(NSString *)key
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    //    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //    //如果报接受类型不一致请替换一致text/html或别的
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //传入的参数
//    NSDictionary *dic = @{@"1":@"2"};
//    NSLog(@";;;;;%@",[self dictionaryToJson:dic]);
    //@"{\"key\":\"f528764d624db129b32c21fbca0cb8d6\"}"
    NSDictionary *parametersDic = @{@"key":[public md5Str:[public getIPAddress:YES]]};
    [manager POST:kGetCateURL parameters:@{@"JsonArray":[public dictionaryToJson:parametersDic]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSString *str = (NSString *)responseObject;
        NSData *data =  [str dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"!!!!%@",json);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"response=%@",operation.responseString);
        NSString *str = (NSString *)operation.responseString;
        NSString *result = [str substringFromIndex:1];
        
        NSData *data =  [result dataUsingEncoding:NSUTF8StringEncoding];
        if (data == nil) {
            return ;
        }
        NSError *jsonError = nil;
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
//        NSLog(@"!!!!%@",json);
        if ([json isKindOfClass:[NSArray class]] && jsonError == nil) {
            
            NSArray *jsonArray = (NSArray *)json;
            
            NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
            [jsonArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                
                HSCategariesModel *model = [[HSCategariesModel alloc] initWithDictionary:obj error:nil];
                [tmpArray addObject:model];
                
                if (idx == 0) {
                    [self GetItemsWithCid:model.id size:10 key:[public md5Str:[public getIPAddress:YES]] page:1];
                }
                
            }];
            _categariesArray = tmpArray;
            [_topCategariesCollectionView reloadData];
            
        }
        
        
        
        
        
    }];

}


#pragma mark 获取banner 图片
- (void)getBannerImages
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    //    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //    //如果报接受类型不一致请替换一致text/html或别的
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //传入的参数
    //    NSDictionary *dic = @{@"1":@"2"};
    //    NSLog(@";;;;;%@",[self dictionaryToJson:dic]);
    //@"{\"key\":\"f528764d624db129b32c21fbca0cb8d6\"}"
    NSDictionary *parametersDic = @{kPostJsonKey:[public md5Str:[public getIPAddress:YES]]};
    [manager GET:kGetBannerURL parameters:@{kJsonArray:[public dictionaryToJson:parametersDic]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSString *str = (NSString *)responseObject;
        NSData *data =  [str dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"!!!!%@",json);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"response=%@",operation.responseString);
        NSString *str = (NSString *)operation.responseString;
        NSString *result = [str substringFromIndex:1];
        
        NSData *data =  [result dataUsingEncoding:NSUTF8StringEncoding];
        if (data == nil) {
            return ;
        }
        NSError *jsonError = nil;
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        NSLog(@"!!!!%@",json);
        if ([json isKindOfClass:[NSArray class]] && jsonError == nil) {
            
            NSArray *jsonArray = (NSArray *)json;
            
            NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
            NSMutableArray *tmpBannner = [[NSMutableArray alloc] init];
            [jsonArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                
                HSBannerModel *model = [[HSBannerModel alloc] initWithDictionary:obj error:nil];
                [tmpArray addObject:model];
                [tmpBannner addObject:[NSString stringWithFormat:@"%@%@",kBannerImageHeaderURL,model.content]];
                
            }];
            _bannerArray = tmpArray;
            _ffScrollView.sourceArr = tmpBannner;
            [_ffScrollView iniSubviewsWithFrame:CGRectMake(0, 0,CGRectGetWidth(_ffScrollView.frame), kFFScrollViewHeight)];
            
        }
        
        
        
        
        
    }];

    
}


- (void)GetItemsWithCid:(NSString *)cid size:(NSUInteger)size key:(NSString *)key page:(NSUInteger)page
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    NSDictionary *parametersDic = @{kPostJsonKey:key,
                                    kPostJsonCid:[NSNumber numberWithLongLong:[cid longLongValue]],
                                    kPostJsonSize:[NSNumber numberWithInteger:size],
                                    kPostJsonPage:[NSNumber numberWithInteger:page]};
    
    [manager POST:kGetItemsByCate parameters:@{kJsonArray:[public dictionaryToJson:parametersDic]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@/n %@", responseObject,[public dictionaryToJson:parametersDic]);
        
        NSString *str = (NSString *)responseObject;
        NSData *data =  [str dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"!!!!%@",json);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"response=%@",operation.responseString);
         NSLog(@"JSON:  %@",[public dictionaryToJson:parametersDic]);
        NSString *str = (NSString *)operation.responseString;
        
        NSData *data =  [str dataUsingEncoding:NSUTF8StringEncoding];
        if (data == nil) {
            return ;
        }
        NSError *jsonError = nil;
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        NSLog(@"!!!!%@",json);
        
        if ([json isKindOfClass:[NSDictionary class]] && jsonError == nil) {
            
            NSDictionary *jsonDic = (NSDictionary *)json;
            HSItemPageModel *pageModel = [[HSItemPageModel alloc] initWithDictionary:jsonDic error:nil];
            NSArray *itemList = pageModel.item_list;
            
            NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
           
            [itemList enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                
                HSCommodtyItemModel *itemModel = [[HSCommodtyItemModel alloc] initWithDictionary:obj error:nil];
                [tmpArray addObject:itemModel];
                
                
            }];
            [_cateItemsDataDic setObject:tmpArray forKey:cid];
            [_commodityViewController setItemsData:tmpArray];
           
            
            
        }
        
        
        
        
        
    }];

    
}


@end
