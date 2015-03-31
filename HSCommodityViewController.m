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

@interface HSCommodityViewController ()<CHTCollectionViewDelegateWaterfallLayout,
UICollectionViewDataSource,
UICollectionViewDelegate>
{
    NSArray *_itemsData;
    
    NSMutableDictionary *_imageSizeDic;
    
    
    
}

@property (weak, nonatomic) IBOutlet UICollectionView *commdityCollectionView;
@end

@implementation HSCommodityViewController


static NSString *const kCommodityCellIndentifier = @"CommodityCellIndentifier";


static NSString *const kImageURLKey = @"imageURLKey";
static NSString *const kImageSizeKey = @"imageSizeKey";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_commdityCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HSCommodityCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kCommodityCellIndentifier];
    
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
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateLayoutForOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self updateLayoutForOrientation:toInterfaceOrientation];
}



- (void)updateLayoutForOrientation:(UIInterfaceOrientation)orientation {
    CHTCollectionViewWaterfallLayout *layout =
    (CHTCollectionViewWaterfallLayout *)_commdityCollectionView.collectionViewLayout;
    layout.columnCount = UIInterfaceOrientationIsPortrait(orientation) ? 2 : 3;
}
*/


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





@end
