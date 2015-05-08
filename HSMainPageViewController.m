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
#import "HSContentCollectionViewCell.h"
#import "HSCommodityDetailViewController.h"
#import "HSSearchViewController.h"


@interface HSMainPageViewController ()<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
UISearchBarDelegate>
{
    /// 类别数组
    NSArray *_categariesArray;
    
    ///轮播图 model
    NSArray *_bannerArray;
    
    /// 轮播图地址
    NSArray *_bannerImages;
    
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
    
//    /// 滑动内容
//    UICollectionView *_contentCollectionView;
}

@property (weak, nonatomic) IBOutlet UICollectionView *topCategariesCollectionView;

@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView;

@end

@implementation HSMainPageViewController

static NSString *const kCategariesCollectionViewCellIdentifier = @"CommodityCellIdentifier";

static NSString *const kContentCollectionViewIdentifier = @"contentCollectionViewIdentifier";

static const float kFFScrollViewHeight = 200;
//static const float kItemSize = 10;

static const int kContentViewTag = 1000;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    [self setUpNavBar];
    //[self.navigationController.navigationBar setBarTintColor:kAPPTintColor];
    
    
    [_topCategariesCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HSCommodityCategaryCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kCategariesCollectionViewCellIdentifier];
    _topCategariesCollectionView.delegate = self;
    _topCategariesCollectionView.dataSource = self;
    
    
    [_contentCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HSContentCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kContentCollectionViewIdentifier];
    _contentCollectionView.delegate = self;
    _contentCollectionView.dataSource = self;
    _contentCollectionView.pagingEnabled = YES;
    _contentCollectionView.showsHorizontalScrollIndicator = NO;
    _contentCollectionView.showsVerticalScrollIndicator = NO;
   
    _cateItemsDataDic = [[NSMutableDictionary alloc] init];
    
    _selectedCategary = [NSIndexPath indexPathForRow:0 inSection:0];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _commodityViewController = [storyboard instantiateViewControllerWithIdentifier:@"commodityViewController"];
    _sanpinViewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HSSanpinViewController class])];
//    [self addChildViewController:_sanpinViewController];
//    [_sanpinViewController didMoveToParentViewController:self];
    
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


#pragma mark -
#pragma mark 导航栏
- (void)setUpNavBar
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame) - 160, 30)]; //
    searchBar.showsCancelButton = NO;
    searchBar.delegate = self;
    searchBar.tintColor = kAPPTintColor;
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
    self.navigationItem.rightBarButtonItem = barItem;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    imgView.backgroundColor = [UIColor redColor];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:imgView];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}


- (void)setViewControllers:(NSArray *)viewControllers
{
    [viewControllers enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.view superview] == self.view) {
            [obj.view removeFromSuperview];
        }

        
        if ([obj parentViewController] == self) {
            [obj willMoveToParentViewController:nil];
            [obj removeFromParentViewController];

        }
        
        
    }];
    
    _viewControllers = viewControllers;
    
    [_viewControllers enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL *stop) {
        
            [self addChildViewController:obj];
            [obj didMoveToParentViewController:self];
        
        
    }];

}

- (void)commodityViewControllersAddChild:(NSUInteger)num
{
    NSMutableArray *tmp = [[NSMutableArray alloc] init];
    
    
    for (int j= 0; j<num; j++) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HSCommodityViewController *commodityViewController = [storyboard instantiateViewControllerWithIdentifier:@"commodityViewController"];
        
        if (j == 0) {
            commodityViewController.isShowBanner = YES;
        }
        HSCategariesModel *cateModel = _categariesArray[j];
        commodityViewController.cateID = cateModel.id;
        [tmp addObject:commodityViewController];

    }
     [self setViewControllers:tmp];
    
//    dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(queue, ^{
//        dispatch_apply(num, queue, ^(size_t index) {
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            HSCommodityViewController *commodityViewController = [storyboard instantiateViewControllerWithIdentifier:@"commodityViewController"];
//
//            if (num == 0) {
//                commodityViewController.isShowBanner = YES;
//            }
//            [tmp addObject:commodityViewController];
//            
//            dispatch_sync(dispatch_get_main_queue(), ^{
//                [self setViewControllers:tmp];
//            });
//        });
//    });
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
    NSInteger count =_categariesArray.count == 0 ? _categariesArray.count : _categariesArray.count + 1;
    return count;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    HSCategariesModel *model = nil;
    if (indexPath.row < _categariesArray.count) {
        model = _categariesArray[indexPath.row];
    }
    
    if (collectionView == _contentCollectionView) {
        
        HSContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kContentCollectionViewIdentifier forIndexPath:indexPath];
        
        if (indexPath.row == _categariesArray.count) { /// 三品一标
            
            UIView *subView = [cell.contentView viewWithTag:kContentViewTag];
            if (subView != nil ) {
                [subView removeFromSuperview];
            }
            UIView *sView = _sanpinViewController.view;
            sView.tag = kContentViewTag;
            sView.frame =cell.contentView.bounds;
            [cell.contentView addSubview:sView];

        }
        else
        {
            
            HSCommodityViewController *commodityVC = _viewControllers[indexPath.row];
            
            UIView *subView = [cell.contentView viewWithTag:kContentViewTag];
            if (subView != nil ) {
                [subView removeFromSuperview];
            }
            UIView *sView = commodityVC.view;
            sView.tag = kContentViewTag;
            sView.frame =cell.contentView.bounds;
            [cell.contentView addSubview:sView];
            
            if (indexPath.row == 0) {
                commodityVC.isShowBanner = YES;
                [commodityVC setBannerModels:_bannerArray];
            }
            ///push 到商品详情
            __weak typeof(self) wself = self;
            commodityVC.cellSelectedBlock = ^(HSCommodtyItemModel *itemModel){
                UIStoryboard *storyBorad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                HSCommodityDetailViewController *detailVC = [storyBorad instantiateViewControllerWithIdentifier:NSStringFromClass([HSCommodityDetailViewController class])];
                //detailVC.hidesBottomBarWhenPushed = YES;
                detailVC.itemModel = itemModel;
                [wself.navigationController pushViewController:detailVC animated:YES];
            };
            
        }
        
        return cell;
    }
    else
    {
        
        HSCommodityCategaryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCategariesCollectionViewCellIdentifier forIndexPath:indexPath];
        
        if (indexPath.row == _categariesArray.count) {// 三品
            
        }
        
        if ([indexPath isEqual:_selectedCategary]) {
            [cell changeTitleColorAndFont:YES];
        }
        else
        {
            [cell changeTitleColorAndFont:NO];
        }
        
        if (indexPath.row == _categariesArray.count) {
            cell.categaryTitleLabel.text = @"三品一标";
        }
        else
        {
            cell.categaryTitleLabel.text = model.name;
        }
        
        return cell;
    }
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _contentCollectionView) {
        return NO;
    }
    return YES;
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
    // 是否相邻
    BOOL isNear = fabs(tmp.row - indexPath.row) == 1 ? YES : NO;
    [_contentCollectionView scrollToItemAtIndexPath:_selectedCategary atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:isNear];
    
    
//    BOOL isShow = indexPath.row == 1 ? YES : NO;
//    [self sanpinViewShow:isShow];
//    
    
    
//    HSCategariesModel *cateModel = _categariesArray[indexPath.row];
//    [self GetItemsWithCid:cateModel.id size:kItemSize key:[public md5Str:[public getIPAddress:YES]] page:1 index:_selectedCategary];
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _contentCollectionView) {
        
        NSLog(@"");
        return _contentCollectionView.frame.size;
    }
    
    return CGSizeMake(70, 40);
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _contentCollectionView) {
        
      
        int page = _contentCollectionView.contentOffset.x / CGRectGetWidth(_contentCollectionView.frame);
        
          NSLog(@"%d",page);
        NSIndexPath *index = [NSIndexPath indexPathForRow:page inSection:0];
        if ([index isEqual:_selectedCategary]) {
            return;
        }
        
        [_topCategariesCollectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
        NSIndexPath *tmp = _selectedCategary;
        _selectedCategary = index;
        
        [_topCategariesCollectionView reloadItemsAtIndexPaths:@[tmp,index]];
        
        }
}

//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    if (collectionView == _contentCollectionView) {
//        UIEdgeInsetsMake(0, 0, 0, 0);
//    }
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    if (collectionView == _contentCollectionView) {
//        return 0;
//    }
//
//    return 0;
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
#pragma mark - 
#pragma mark
- (void)reloadRequestData
{
    [self getCommofityCategaries:nil];
}



#pragma mark -
#pragma mark 获取数据

- (void)getCommofityCategaries:(NSString *)key
{
    [self showNetLoadingView];
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
        [self showReqeustFailedMsg];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"response=%@",operation.responseString);
        NSString *str = (NSString *)operation.responseString;
        if (str.length <= 1) {
            return ;
        }
        NSString *result = [str substringFromIndex:1];
        
        NSData *data =  [result dataUsingEncoding:NSUTF8StringEncoding];
        if (data == nil) {
            [self showReqeustFailedMsg];
            return ;
        }
        [self hiddenMsg];
        NSError *jsonError = nil;
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
//        NSLog(@"!!!!%@",json);
        if ([json isKindOfClass:[NSArray class]] && jsonError == nil) {
            
            NSArray *jsonArray = (NSArray *)json;
            
            NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
            [jsonArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                
                HSCategariesModel *model = [[HSCategariesModel alloc] initWithDictionary:obj error:nil];
                [tmpArray addObject:model];
            
            }];
            _categariesArray = tmpArray;
            [self commodityViewControllersAddChild:tmpArray.count];
            [_topCategariesCollectionView reloadData];
            [_contentCollectionView reloadData];
        }
    }];

}

#pragma mark -
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
        [self getBannerImages];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"response=%@",operation.responseString);
        
        
        NSString *str = (NSString *)operation.responseString;
        NSString *result = [str substringFromIndex:1];
        
        NSData *data =  [result dataUsingEncoding:NSUTF8StringEncoding];
        if (data == nil) {
            [self getBannerImages];
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
                NSString *fullURL = [NSString stringWithFormat:@"%@%@",kBannerImageHeaderURL,model.content];
                [tmpBannner addObject:fullURL];
                model.content = fullURL;
                [tmpArray addObject:model];
                
            }];
            _bannerArray = tmpArray;
            _bannerImages = tmpBannner;
            
            if (_categariesArray.count > 0 && _contentCollectionView.dataSource != nil) {
                NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
                [_contentCollectionView reloadItemsAtIndexPaths:@[index]];
            }
            }
        
        
    }];

    
}


- (void)GetItemsWithCid:(NSString *)cid size:(NSUInteger)size key:(NSString *)key page:(NSUInteger)page index:(NSIndexPath *)index
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
     //{"id":155,"key":"f528764d624db129b32c21fbca0cb8d6"}
    NSDictionary *parametersDic = @{kPostJsonKey:key,
                                    kPostJsonCid:[NSNumber numberWithLongLong:[cid longLongValue]],
                                    kPostJsonSize:[NSNumber numberWithInteger:size],
                                    kPostJsonPage:[NSNumber numberWithInteger:page]};
    
    [manager POST:kGetItemsByCateURL parameters:@{kJsonArray:[public dictionaryToJson:parametersDic]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
            //[_contentCollectionView reloadItemsAtIndexPaths:@[index]];
            [_contentCollectionView reloadData];
           
            
            
        }
        
        
    }];

    
}

#pragma mark - 
#pragma mark searchBar delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"%s",__func__);
    [self pushViewControllerWithIdentifer:NSStringFromClass([HSSearchViewController class])];
    return NO;
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
   
}

@end
