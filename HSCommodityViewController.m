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

@interface HSCommodityViewController ()<CHTCollectionViewDelegateWaterfallLayout,
UICollectionViewDataSource,
UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *commdityCollectionView;
@end

@implementation HSCommodityViewController


static NSString *const kCommodityCellIndentifier = @"CommodityCellIndentifier";

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
    int hei =  arc4random()%150+50;
    int wid = (CGRectGetWidth(collectionView.frame)-5*2-10)/2.0;//;
    
    
    return CGSizeMake(wid, hei);

}





@end
