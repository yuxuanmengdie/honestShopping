//
//  HSCommodityDetailViewController.m
//  honestShopping
//
//  Created by 张国俗 on 15-3-31.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "HSCommodityDetailViewController.h"
#import "HSBuyNumView.h"
#import "HSCommodityItemDetailPicModel.h"
#import "HSCommodityDetailTableViewCell.h"
#import "HSCommodityItemTopBannerView.h"
#import "UIImageView+WebCache.h"
#import "AFHTTPRequestOperationManager.h"

@interface HSCommodityDetailViewController ()<UITableViewDataSource,
UITableViewDelegate>
{
    HSCommodityItemDetailPicModel *_detailPicModel;
    
    
     NSMutableDictionary *_imageSizeDic;
    
    
    
    AFHTTPRequestOperationManager *_operationManager;
}

@property (weak, nonatomic) IBOutlet UITableView *detailTableView;

@property (weak, nonatomic) IBOutlet HSBuyNumView *buyNumView;

@end

@implementation HSCommodityDetailViewController

///顶部的轮播图放到
static const int kTopExistCellNum = 1;

static NSString *const kImageURLKey = @"imageURLKey";
static NSString *const kImageSizeKey = @"imageSizeKey";


//- (void)awakeFromNib
//{
//    self.hidesBottomBarWhenPushed = YES;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _imageSizeDic = [[NSMutableDictionary alloc] init];
    _buyNumView.hidden = YES;
    self.title = @"商品详情";
    [self setNavBarRightBarWithTitle:@"分享" action:@selector(shareAction)];
    [self requestDetailByItemID:_itemModel.id];
    [self buyViewBlock];
    
    [_detailTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HSCommodityDetailTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HSCommodityDetailTableViewCell class])];
    _detailTableView.separatorStyle = UITableViewCellSelectionStyleNone;
//    _detailTableView.dataSource = self;
//    _detailTableView.delegate = self;

    
    
}

#pragma mark -
#pragma mark rightNavBar action
- (void)shareAction
{
    
}

- (void)buyViewBlock
{
   
    
    _buyNumView.buyBlock = ^(int num){
        
    };
    
    _buyNumView.collectBlock = ^(void){
        
    };
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
#pragma mark 获取
- (void)requestDetailByItemID:(NSString *)itemID
{
    [self showNetLoadingView];
    _operationManager = [[AFHTTPRequestOperationManager alloc] init];
    AFHTTPRequestOperationManager *manager = _operationManager;//[AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    NSDictionary *parametersDic = @{kPostJsonKey:[public md5Str:[public getIPAddress:YES]]         ,
                                    kPostJsonid:itemID};
    __weak typeof(self) wself = self;
    [manager POST:kGetItemById parameters:@{kJsonArray:[public dictionaryToJson:parametersDic]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [wself hiddenMsg];
//        NSString *str = (NSString *)responseObject;
//        NSData *data =  [str dataUsingEncoding:NSUTF8StringEncoding];
//        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"!!!!%@",json);
        
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

        NSError *jsonError = nil;
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        NSLog(@"!!!!%@",json);
        if ([json isKindOfClass:[NSDictionary class]] && jsonError == nil) {
            
            swself->_detailPicModel = [[HSCommodityItemDetailPicModel alloc] initWithDictionary:json error:&jsonError];
            
            if (swself->_detailPicModel == nil || jsonError != nil) {
                [swself showReqeustFailedMsg];
                return;
            }
            [swself hiddenMsg];
            swself.buyNumView.hidden = NO;
            swself->_detailTableView.dataSource = swself;
           swself->_detailTableView.delegate = swself;

            [swself->_detailTableView reloadData];
            
            swself->_buyNumView.stepper.maximum = [swself->_detailPicModel.maxbuy intValue];
            
        }
    }];
}

#pragma mark -
#pragma mark  重新加载
- (void)reloadRequestData
{
    [self requestDetailByItemID:_itemModel.id];
}

#pragma mark -
#pragma mark tableview dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _detailPicModel.tuwen.count + kTopExistCellNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {// 顶部轮播图所在的tableviewcell
        static NSString *topCellIndentifier = @"topCellIndentifer";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:topCellIndentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:topCellIndentifier];
            
            HSCommodityItemTopBannerView *headView = [[HSCommodityItemTopBannerView alloc] init];
            headView.translatesAutoresizingMaskIntoConstraints = NO;
            [cell.contentView addSubview:headView];
            headView.tag = 501;
            [self headViewAutoLayoutInCell:cell headView:headView];
            
        }
        HSCommodityItemTopBannerView *headView = (HSCommodityItemTopBannerView *)[cell.contentView viewWithTag:501];
        headView.bannerView.sourceArr = [self controlBannerArr:_detailPicModel.banner];
        [headView.bannerView iniSubviewsWithFrame:CGRectMake(0, 0,CGRectGetWidth(tableView.frame), headView.bannerHeight)];
        headView.bannerView.pageControl.currentPageIndicatorTintColor = kAPPTintColor;

        headView.infoView.titleLabel.text = [NSString stringWithFormat:@"%@ %@",_detailPicModel.title,_detailPicModel.standard];
        headView.infoView.priceLabel.text = [NSString stringWithFormat:@"%@元",_detailPicModel.price];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        
        return cell;
    }
    
    HSCommodityDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HSCommodityDetailTableViewCell class]) forIndexPath:indexPath];
    
    NSString *imgPath = _detailPicModel.tuwen[indexPath.row - kTopExistCellNum];
    cell.detailImageView.image = nil;
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[self p_introImgFullUrl:imgPath]]
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
                                                          [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic ];
                                                          
                                                         
                                                      }
                                                  }];

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 100.0;

    
    if (0 == indexPath.row) {
        
        HSCommodityItemTopBannerView *headView = [[HSCommodityItemTopBannerView alloc] init];
        headView.infoView.titleLabel.text = [NSString stringWithFormat:@"%@ %@",_detailPicModel.title,_detailPicModel.standard];
        headView.infoView.priceLabel.text = [NSString stringWithFormat:@"%@元",_detailPicModel.price];
        headView.bounds = tableView.bounds;
        [headView updateConstraintsIfNeeded];
        [headView layoutIfNeeded];
        
        height = [headView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;

    }
    
    //return height;
    
    else
    {
       
        NSDictionary *dic = [_imageSizeDic objectForKey:[self p_keyFromIndex:indexPath]];
        //NSLog(@"index.row = %d sizeDic = %@ ",indexPath.row, _imageSizeDic);
        if (dic != nil) {
            NSValue *sizeValue = dic[kImageSizeKey];
            if (sizeValue.CGSizeValue.width != 0.0) { /// 宽度为0时 防止除0错误
            float per = (float)sizeValue.CGSizeValue.height / sizeValue.CGSizeValue.width;
            height = per * CGRectGetWidth(tableView.frame);
            }
        }

    }
     NSLog(@"index.row = %ld height   %f",(long)indexPath.row,height);
    
    return height;
     
}



#pragma mark -
#pragma mark tableViewCell 添加的视图添加约束
- (void)headViewAutoLayoutInCell:(UITableViewCell *)cell headView:(UIView *)headView
{
    NSString *vfl1 = @"H:|[headView]|";
    NSString *vfl2 = @"V:|[headView]|";
    NSDictionary *dic = NSDictionaryOfVariableBindings(headView);
    NSArray *cons1 = [NSLayoutConstraint constraintsWithVisualFormat:vfl1 options:0 metrics:nil views:dic];
    NSArray *cons2 = [NSLayoutConstraint constraintsWithVisualFormat:vfl2 options:0 metrics:nil views:dic];
    [cell.contentView addConstraints:cons1];
    [cell.contentView addConstraints:cons2];
    
}

#pragma mark -
#pragma mark tableViewCell 处理banner的路径
- (NSArray *)controlBannerArr:(NSArray *)arr
{
    if (arr.count < 1) {
        return nil;
    }
    
    NSMutableArray *retArr = [[NSMutableArray alloc] init];
    
    [arr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        
        NSString *fullPath = [NSString stringWithFormat:@"%@%@",kImageHeaderURL,obj];
        [retArr addObject:fullPath];
    }];
    
    return retArr;
}


#pragma mark -
#pragma mark tableView 处理介绍图片的url
- (NSString *)p_introImgFullUrl:(NSString *)oriUrl
{
    if (oriUrl.length < 1) {
        return nil;
    }
    
    NSString *result = [oriUrl stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:kCommodityImgURLHeader];
    return result;
}

- (NSString *)p_keyFromIndex:(NSIndexPath *)index
{
    if (index == nil) {
        return @"";
    }
    
    NSString *result = [NSString stringWithFormat:@"indexsec%ldrow%ld",(long)index.section,(long)index.row];
    return result;
}

- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"%s",__func__);
    _detailTableView = nil;
    _detailTableView.dataSource = nil;
    _detailTableView.delegate = nil;
    [[_operationManager operationQueue] cancelAllOperations];
    [super viewDidDisappear:animated];
}


- (void)dealloc
{
    _operationManager = nil;
    NSLog(@"%s",__func__);
   
}
@end
