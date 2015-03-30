//
//  HSSanpinViewController.m
//  honestShopping
//
//  Created by 张国俗 on 15-3-23.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "HSSanpinViewController.h"
#import "HSCommodityViewController.h"
#import "HSCommodityCollectionViewCell.h"
#import "CHTCollectionViewWaterfallLayout.h"

@interface HSSanpinViewController ()<
UICollectionViewDataSource,
UICollectionViewDelegate,
CHTCollectionViewDelegateWaterfallLayout>

{
    HSCommodityViewController *_commodityViewController;
}


@property (weak, nonatomic) IBOutlet UICollectionView *sanpinCollectionView;
@end

@implementation HSSanpinViewController

static NSString *const kCommodityCellIndentifier = @"CommodityCellIndentifier";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    [_sanpinCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HSCommodityCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kCommodityCellIndentifier];
    _sanpinCollectionView.delegate = self;
    _sanpinCollectionView.dataSource = self;

    

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _commodityViewController = [storyboard instantiateViewControllerWithIdentifier:@"commodityViewController"];
    [self commodityLatout];
    
//    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
//    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
//    layout.headerHeight = 15;
//    layout.footerHeight = 10;
//    layout.minimumColumnSpacing = 20;
//    layout.minimumInteritemSpacing = 20;
//    layout.columnCount = 2;
//    _sanpinCollectionView.collectionViewLayout = layout;

}


- (void)commodityLatout
{
    
    UIView *commodityView = _commodityViewController.view;
    [self.view addSubview:commodityView];
    commodityView.translatesAutoresizingMaskIntoConstraints = NO;
    NSString *vfl1 = @"H:|[commodityView]|";
    NSString *vfl2 = @"V:[_sanpinCollectionView][commodityView]|";
    NSDictionary *dic = NSDictionaryOfVariableBindings(_sanpinCollectionView,commodityView,self.view);
    NSArray *arr1 = [NSLayoutConstraint constraintsWithVisualFormat:vfl1 options:0 metrics:nil views:dic];
    NSArray *arr2 = [NSLayoutConstraint constraintsWithVisualFormat:vfl2 options:0 metrics:nil views:dic];
    [self.view addConstraints:arr1];
    [self.view addConstraints:arr2];
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
    return 100;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HSCommodityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCommodityCellIndentifier forIndexPath:indexPath];
    cell.imgView.backgroundColor = [UIColor redColor];
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView == _sanpinCollectionView) {
        return CGSizeMake((CGRectGetWidth(collectionView.frame)-5*5)/4.0, 80);
    }
    
    int hei =  80;//arc4random()%150+50;
    int wid = (CGRectGetWidth(collectionView.frame)-5*5)/4.0;//;
    
    
    return CGSizeMake(wid, hei);
    
}


@end
