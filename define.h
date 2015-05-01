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

static NSString *const kPostJsonItemid =  @"itemid";

static NSString *const kPostJsonStatus = @"status";

static NSString *const kPostJsonCid = @"cid";

static NSString *const kPostJsonPage = @"page";

static NSString *const kPostJsonSize = @"size";

static NSString *const kPostJsonCode = @"code";





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
/// 签到
#define kSignURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=User&asign"]
/// 修改密码
#define kChangePassWordURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&mUser&a=changePassWord"]
/// 分类列表
#define kGetCateURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=Item&a=getCate"]
/// 搜索列表
#define kGetSearchListURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=Item&a=getSearchList"]
/// 商品信息
#define kGetItemById  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=Item&a=getItemById"]
/// 用户优惠劵
#define kGetCouponsByUidURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=User&a=getCouponsByUid"]
/// 列表下的商品信息
#define kGetItemsByCate  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=Item&a=getItemsByCate"]

/// 获取banner
#define kGetBannerURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?g=api&m=Item&a=getBanner"]

//#define kGetAddressURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?gapi&mUser&agetAddress"]
//
//#define kGetAddressURL  [NSString stringWithFormat:@"%@%@",kURLHeader,@"/index.php?gapi&mUser&agetAddress"]
//*/

/// banner 图片前缀路径
static NSString *const kBannerImageHeaderURL = @"http://203.192.7.23/data/upload/advert/";

/// 普通图片路径
static NSString *const kImageHeaderURL = @"http://203.192.7.23/data/upload/item/";


#pragma mark -
#pragma mark userdefault中保存用户是否登录 的key
static NSString *const kUserIsLoginKey = @"HS_kUserIsLoginKey";
/// 保存到用户信息保存到doc 的plist文件
static NSString *const kUserInfoPlistName = @"HSuser";

#endif
