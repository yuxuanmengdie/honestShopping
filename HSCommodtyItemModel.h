//
//  HSCommodtyItemModel.h
//  honestShopping
//
//  Created by 张国俗 on 15-3-27.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "JSONModel.h"

@interface HSCommodtyItemModel : JSONModel


@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *cate_id;
@property (copy, nonatomic) NSString *orig_id;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *intro;
@property (copy, nonatomic) NSString *img;
@property (copy, nonatomic) NSString *price;
@property (copy, nonatomic) NSString *rates;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *comments;
@property (copy, nonatomic) NSString *cmt_taobao_time;
@property (copy, nonatomic) NSString *add_time;
@property (copy, nonatomic) NSString *ordid;
@property (copy, nonatomic) NSString *status;
@property (copy, nonatomic) NSString *info;
@property (copy, nonatomic) NSString *tuwen;
@property (copy, nonatomic) NSString *news;
@property (copy, nonatomic) NSString *tuijian;
@property (copy, nonatomic) NSString *goods_stock;
@property (copy, nonatomic) NSString *buy_num;
@property (copy, nonatomic) NSString *brand;
@property (copy, nonatomic) NSString *pingyou;
@property (copy, nonatomic) NSString *kuaidi;
@property (copy, nonatomic) NSString *ems;
@property (copy, nonatomic) NSString *free;
@property (copy, nonatomic) NSString *color;
@property (copy, nonatomic) NSString *size;
@property (copy, nonatomic) NSString *maxbuy;
@property (copy, nonatomic) NSString *ischeck;
@property (copy, nonatomic) NSString *standard;
@property (copy, nonatomic) NSString *tuan;
@property (copy, nonatomic) NSString *tuan_price;
@property (copy, nonatomic) NSString *tuan_time;
@property (copy, nonatomic) NSString *maill_price;
@property (copy, nonatomic) NSString *ordernum;
@property (copy, nonatomic) NSString *likes;


@end


/*



 "id":"155",
 "cate_id":"352",
 "orig_id":"0",
 "title":"\u5f52\u6765\u516e\u7ea2\u82b1\u9999\u7c73",
 "intro":"\u65b0\u534e\u793e\u4e3a\u519c\u670d\u52a1\u8bda\u4fe1\u5e73\u53f0\u4e3a\u4f60\u8bda\u610f\u63a8\u8350\r\n",
 "img":"1407\/01\/53b23b659d5e3.png",
 "price":"200.00",
 "rates":"0.00",
 "type":"1",
 "comments":"0",
 "cmt_taobao_time":"0",
 "add_time":"1404189543",
 "ordid":"255",
 "status":"1",
 "info":"",
 "tuwen":"<img alt=\"\" src=\".\/data\/upload\/editer\/image\/2014\/07\/01\/53b23b530ef3c.png\" \/> <img alt=\"\" src=\".\/data\/upload\/editer\/image\/2014\/07\/01\/53b23b53559fc.png\" \/> <img alt=\"\" src=\".\/data\/upload\/editer\/image\/2014\/07\/01\/53b23b539e13b.png\" \/> <img alt=\"\" src=\".\/data\/upload\/editer\/image\/2014\/07\/01\/53b23b5606fd4.png\" \/> <img alt=\"\" src=\".\/data\/upload\/editer\/image\/2014\/07\/01\/53b23b5633d97.png\" \/><img alt=\"\" src=\".\/data\/upload\/editer\/image\/2014\/10\/22\/5447296c52755.jpg\" \/>",
 "news":"0",
 "tuijian":"0",
 "goods_stock":"1000",
 "buy_num":"12",
 "brand":"2",
 "pingyou":"0.00",
 "kuaidi":"0.00",
 "ems":"0.00",
 "free":"1",
 "color":null,
 "size":null,
 "maxbuy":"10",
 "ischeck":"2",
 "standard":"10\u65a4\/\u888b",
 "tuan":"0",
 "tuan_price":"0.00",
 "tuan_time":"0",
 "maill_price":"0",
 "ordernum":"70",
 "likes":"1813"
 },

*/