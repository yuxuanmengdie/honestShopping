//
//  define.h
//  honestShopping
//
//  Created by 张国俗 on 15-3-17.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#ifndef honestShopping_define_h
#define honestShopping_define_h

#pragma mark -
#pragma mark json 中key的宏定义
///JsonArray
static NSString *const kJsonArray = @"JsonArray";

/// json 中key的宏定义
static NSString *const kPostJsonKey = @"key";

static NSString *const kPostJsonUserName = @"username";

static NSString *const kPostJsonPassWord = @"password";

static NSString *const kPostJsonUid = @"uid";

static NSString *const kPostJsonSessionCode = @"sessionCode";

static NSString *const kPostJsonid = @"id";

static NSString *const kPostJsonPhone = @"phone";

static NSString *const kPostJsonEmail = @"email";

static NSString *const kPostJsonConsignee = @"consignee";

static NSString *const kPostJsonGender = @"gender";

static NSString *const kPostJsonIntro = @"intro";

static NSString *const kPostJsonByear = @"byear";

static NSString *const kPostJsonBmonth = @"bmonth";

static NSString *const kPostJsonBday = @"bday";

static NSString *const kPostJsonProvince = @"province";

static NSString *const kPostJsonAddress = @"address";

static NSString *const kPostJsonMobile = @"mobile";

static NSString *const kPostJsonSheng = @"sheng";

static NSString *const kPostJsonShi = @"shi";

static NSString *const kPostJsonQu = @"qu";

static NSString *const kPostJsonOldPassword = @"oldPassword";

static NSString *const kPostJsonNewPassword = @"newPassword";

static NSString *const kPostJsonItemid =  @"itemId";

static NSString *const kPostJsonStatus = @"status";

static NSString *const kPostJsonCid = @"cid";

static NSString *const kPostJsonPage = @"page";

static NSString *const kPostJsonSize = @"size";

static NSString *const kPostJsonCode = @"code";

static NSString *const kPostJsonKeyWord = @"keyWord";

static NSString *const kPostJsonType = @"type";




#pragma mark -
#pragma mark 请求url
/// 注册
#define kRegisterURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=User&a=register"]
/// 登录
#define kLoginURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=User&a=login"]
///获取手机验证码
#define kGetVerifyCodeURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=User&a=getVerifyCode"]
/// 验证手机验证码
#define kVerifyCodeURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=User&a=verifyCode"]
/// 密码设置 找回
#define kSetPasswordURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=User&a=setPassword"]
/// 用户信息
#define kGetUserInfoURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=User&a=getUserInfo"]
/// 个人信息更新
#define kUserInfoUpdateURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=User&a=userInfoUpdate"]
/// 收货地址
#define kGetAddressURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=User&a=getAddress"]
/// 收货地址更新
#define kAddressUpdateURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=User&a=addressUpdate"]
/// 新增收货地址
#define kAddressAddURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=User&a=addressAdd"]
/// 获取默认收货地址
#define kGetDefaultAddressURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=User&a=getDefaultAddress"]
/// 设置默认收货地址
#define kSetDefaultAddressURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=User&a=setDefaultAddress"]
/// 签到
#define kSignURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=User&a=sign"]
/// 修改密码
#define kChangePassWordURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&mUser&a=changePassWord"]
/// 分类列表
#define kGetCateURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=Item&a=getCate"]
/// 搜索列表
#define kGetSearchListURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=Item&a=getSearchList"]
/// 商品信息
#define kGetItemByIdURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=Item&a=getItemById"]
/// 用户优惠劵
#define kGetCouponsByUidURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=User&a=getCouponsByUid"]
/// 列表下的商品信息
#define kGetItemsByCateURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=Item&a=getItemsByCate"]
/// 列表下的广告商品信息
#define kGetAdsByCateURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=Item&a=getAdsByCate"]
/// 收藏
#define kAddFavoriteURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=Item&a=addFavorite"]
/// 发现
#define kGetDiscoverURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=Item&a=getDiscover"]
/// 获取banner
#define kGetBannerURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=Item&a=getBanner"]
/// 三品一标下面分类 获取三品一标(1.有机产品2.绿色产品3.无公害产品4.地理标志)
#define kGetSpybByTypeURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=Item&a=getSpybByType"]
/// 获取用户订单列表(传status值则会根据status筛选) 1.代付款 2.待发货 3.待收获 4.完成 5。关闭
#define kGetOrderListURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=Order&a=getOrderList"]
/// 获取订单详情
#define kGetOrderDetailURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=Order&a=getOrderDetail"]
/// 获取收藏商品列表
#define kGetFavoriteURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=Item&a=getFavorite"]
/// 生成订单（调取下个订单状态）
#define kAddOrderURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=Order&a=addOrder"]
/// 修改订单状态
#define kUpdateOrderNextURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=Order&a=updateOrderNext"]
/// 领取优惠劵
#define kBlindCouponWithUserURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=User&a=blindCouponWithUser"]
/// 判断是否是会员
#define kIsVIPURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=User&a=isVIP"]
/// 获取首页优惠劵列表
#define kGetCouponListURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=Item&a=getCouponList"]
/// 获取用户优惠劵
#define kGetCouponsByUidURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=User&a=getCouponsByUid"]
/// 获取微信支付perpayid
#define kGetWxPerpayidURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=Order&a=getWxPerpayid"]
/// 分享
#define kShareURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=Item&a=share"]


/// banner 图片前缀路径
static NSString *const kBannerImageHeaderURL = @"http://203.192.7.23/data/upload/advert/";

/// 普通图片路径
static NSString *const kImageHeaderURL = @"http://203.192.7.23/data/upload/item/";


#pragma mark -
#pragma mark userdefault中保存用户是否登录 的key
static NSString *const kUserIsLoginKey = @"HS_kUserIsLoginKey";
/// 保存到用户信息保存到doc 的plist文件
static NSString *const kUserInfoPlistName = @"HSuser";


#pragma mark -
#pragma mark 占位图片

#define kPlaceholderImage  [UIImage imageNamed:@"bank_icon_failed"]

#define kAppYellowColor [UIColor yellowColor]

#endif
