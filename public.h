//
//  public.h
//  honestShopping
//
//  Created by 张国俗 on 15-3-17.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface public : NSObject


///color画图

+ (UIImage *) ImageWithColor: (UIColor *)color;

+ (UIImage *) ImageWithColor: (UIColor *) color frame:(CGRect)aFrame;

///修改图片尺寸
+ (UIImage*) drawInRectImage:(UIImage*)startImage size:(CGSize)imageSize;

//添加不要云备份属性。
+ (BOOL)addSkipBAckupAttributeItemAtURL:(NSURL *)URL;
/// doc 添加不要保存云备份
+ (BOOL)addSkipBackupAttributeDoc;

///判断是否为邮箱格式
+ (BOOL)isEmaliRegex:(NSString *)email;

//判断是否为手机号码
+ (BOOL)isPhoneNumberRegex:(NSString *)phone;

///返回 md5
+ (NSString *)md5Str:(NSString *)oriStr;

/// 获取ip4地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4;

/// 获取如ip4，ip6，wifi
+ (NSDictionary *)getIPAddresses;

/// 字典转str
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

/// 保存用户信息到plist文件中
+ (void)saveUserInfoToPlist:(NSDictionary *)userDic;

/// 取出用户信息
+ (NSDictionary *)userInfoFromPlist;

/// 是否登录状态
+ (BOOL)isLoginInStatus;

/// 设置登录状态
+ (void)setLoginInStatus:(BOOL)isLogin;

/// 保存上次的用户名称
+ (void)saveLastUserName:(NSString *)userName;

/// 取出上次登录的用户名
+ (NSString *)lastUserName;

/// 保存上次的密码
+ (void)saveLastPassword:(NSString *)password;

/// 取出上次登录的密码
+ (NSString *)lastPassword;

/// 处理字符串 为nil 时返回""
+ (NSString *)controlNullString:(NSString *)ori;
@end
