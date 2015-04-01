//
//  HSCommodityViewController.m
//  honestShopping
//
//  Created by 张国俗 on 15-3-23.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "HSCommodityViewController.h"
#import "HSCommodityCollectionViewCell.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "HSCommodtyItemModel.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "FFScrollView.h"
#import "HSBannerHeaderCollectionReusableView.h"

@interface HSCommodityViewController ()<CHTCollectionViewDelegateWaterfallLayout,
UICollectionViewDataSource,
UICollectionViewDelegate>
{
    NSArray *_itemsData;
    
    NSMutableDictionary *_imageSizeDic;
    
    
    /// 热销顶部的滚动试图
    FFScrollView *_ffScrollView;
    
    
    /// 顶部滚动高度约束
    NSLayoutConstraint *_ffScrollViewHeightConstraint;

    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commodityTopConstraint;

@property (weak, nonatomic) IBOutlet UICollectionView *commdityCollectionView;
@end

@implementation HSCommodityViewController


static NSString *const kCommodityCellIndentifier = @"CommodityCellIndentifier";

static NSString *const kHeaderIdentifier = @"bannerHeaderIdentifier";


static NSString *const kImageURLKey = @"imageURLKey";
static NSString *const kImageSizeKey = @"imageSizeKey";


static const float kFFScrollViewHeight = 200;


- (id)init
{
    LogFunc;
    self = [super init];
    if (self) {
        _isShowBanner = NO;
        
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_commdityCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HSCommodityCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kCommodityCellIndentifier];
    if (_isShowBanner)
    {
        //注册headerView Nib的view需要继承UICollectionReusableView
        [_commdityCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HSBannerHeaderCollectionReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderIdentifier];
    }

    
    
    _commdityCollectionView.dataSource = self;
    _commdityCollectionView.delegate = self;
    
    
    
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.headerHeight = 0;
    layout.footerHeight = 0;
    layout.minimumColumnSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    layout.columnCount = 2;
    _commdityCollectionView.collectionViewLayout = layout;
    
    
    _imageSizeDic = [[NSMutableDictionary alloc] init];
    
    
    __weak typeof(self) weakSelf = self;
    [_commdityCollectionView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf.commdityCollectionView.header endRefreshing];
    }];
    
    [_commdityCollectionView addLegendFooterWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [weakSelf.collectionView reloadData];
//            
//            // 结束刷新
//            [weakSelf.collectionView.footer endRefreshing];
            [weakSelf.commdityCollectionView.footer endRefreshing];
        });

        
    }];
 //   [_commdityCollectionView.footer beginRefreshing];
    

}

#pragma mark 瀑布流

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    LogFunc;
    [_commdityCollectionView reloadData];
//    [self updateLayoutForOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
//    [self updateLayoutForOrientation:toInterfaceOrientation];
//}
//
//
//
//- (void)updateLayoutForOrientation:(UIInterfaceOrientation)orientation {
//    CHTCollectionViewWaterfallLayout *layout =
//    (CHTCollectionViewWaterfallLayout *)_commdityCollectionView.collectionViewLayout;
//    layout.columnCount = UIInterfaceOrientationIsPortrait(orientation) ? 2 : 3;
//}


- (void)ffScrollViewInitWithSubView:(UIView *)spView
{
    if (_ffScrollView != nil && [_ffScrollView superview] == spView) {
        return;
    }
    
    _ffScrollView = [[FFScrollView alloc] initWithFrame:CGRectZero];
    
    [spView addSubview:_ffScrollView];
    _ffScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    NSString *vfl1 = @"H:|[_ffScrollView]|";
    NSString *vfl2 = @"V:|[_ffScrollView]";
    NSDictionary *dic = NSDictionaryOfVariableBindings(_ffScrollView,spView);
    NSArray *arr1 = [NSLayoutConstraint constraintsWithVisualFormat:vfl1 options:0 metrics:nil views:dic];
    NSArray *arr2 = [NSLayoutConstraint constraintsWithVisualFormat:vfl2 options:0 metrics:nil views:dic];
    
    _ffScrollViewHeightConstraint  = [NSLayoutConstraint constraintWithItem:_ffScrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kFFScrollViewHeight];
    [spView addConstraints:arr1];
    [spView addConstraints:arr2];
    [spView addConstraint:_ffScrollViewHeightConstraint];
    
    
}

- (void)setBannerImages:(NSArray *)images
{
    if (!_isShowBanner) {
        return;
    }
    
    _ffScrollView.sourceArr = images;
   
    [_ffScrollView iniSubviewsWithFrame:CGRectMake(0, 0,CGRectGetWidth(_ffScrollView.frame), kFFScrollViewHeight)];
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


- (void)setItemsData:(NSArray *)itemsData
{
    _itemsData = itemsData;
    [_commdityCollectionView reloadData];
}


#pragma  mark collectionView dataSource and delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _itemsData.count;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HSCommodityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCommodityCellIndentifier forIndexPath:indexPath];
    HSCommodtyItemModel *itemModel = _itemsData[indexPath.row];
//    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageHeaderURL,itemModel.img]]];
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageHeaderURL,itemModel.img]]
                                                    options:0
                                                   progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                       // progression tracking code
                                                   }
                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                      if (image) {
                                                          // do something with image
                                                          cell.imgView.image = image;
                                                          
                                                          NSValue *imgSize =  [NSValue valueWithCGSize:image.size];
                                                          NSDictionary *dic = [_imageSizeDic objectForKey:indexPath];
                                                          if (dic != nil ) {
                                                              NSURL *imgURL = dic[kImageURLKey];
                                                              NSValue *sizeValue = dic[kImageSizeKey];
                                                              if ([imgURL isEqual:imageURL] && [sizeValue isEqual:imgSize]) {
                                                                  return ;
                                                              }
                                                          }
                                                          
                                                          NSDictionary *tmpDic = @{kImageSizeKey:imgSize,
                                                                                   kImageURLKey:imageURL};
                                                          
                                                          [_imageSizeDic setObject:tmpDic forKey:indexPath];
                                                          [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                                                      }
                                                  }];

       
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    __block float hei =  20;//arc4random()%150+50;
//    __block float wid = 20;//(CGRectGetWidth(collectionView.frame)-5*2-10)/2.0;//;
//    HSCommodtyItemModel *itemModel = _itemsData[indexPath.row];
////    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageHeaderURL,itemModel.img]] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
////        
////    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
////        
////        wid = image.size.width;
////        hei = image.size.height;
////    }];
//    
//    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageHeaderURL,itemModel.img]]
//                          options:0
//                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//                             // progression tracking code
//                         }
//                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                            if (image) {
//                                // do something with image
//                                wid = image.size.width;
//                                hei = image.size.height;
//
//                            }
//                        }];
////    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageHeaderURL,itemModel.img]]];
    
    NSDictionary *dic = [_imageSizeDic objectForKey:indexPath];
    if (dic != nil) {
        NSValue *sizeValue = dic[kImageSizeKey];
        return CGSizeMake(sizeValue.CGSizeValue.width, sizeValue.CGSizeValue.height);
    }
    
    return CGSizeMake(0, 0);

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier;
    if ([kind isEqualToString: UICollectionElementKindSectionHeader ] && _isShowBanner){
        reuseIdentifier = kHeaderIdentifier;
        HSBannerHeaderCollectionReusableView *view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:reuseIdentifier   forIndexPath:indexPath];
        [self ffScrollViewInitWithSubView:view];
        return view;

    }else{
        
        return nil;
    }
    
//    UICollectionReusableView *view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:reuseIdentifier   forIndexPath:indexPath];
//    
//    UILabel *label = (UILabel *)[view viewWithTag:1];
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
//        label.text = [NSString stringWithFormat:@"这是header:%d",indexPath.section];
//    }
//    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
//        view.backgroundColor = [UIColor lightGrayColor];
//        label.text = [NSString stringWithFormat:@"这是footer:%d",indexPath.section];
//    }
//    return view;
}

////返回头footerView的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    CGSize size={320,45};
//    return size;
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (_isShowBanner) {
        CGSize size = CGSizeMake(CGRectGetWidth(_commdityCollectionView.frame), kFFScrollViewHeight);
        return size;
    }
//    CGSize size={320,45};
    return CGSizeZero;
}

 



@end
