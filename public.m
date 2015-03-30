//
//  public.m
//  honestShopping
//
//  Created by 张国俗 on 15-3-17.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "public.h"
#import <CommonCrypto/CommonDigest.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation public



#pragma mark 用 RGB 画图

+ (UIImage *) ImageWithColor: (UIColor *)color
{
    CGRect          aFrame = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(aFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, aFrame);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;

}


+ (UIImage *) ImageWithColor: (UIColor *) color frame:(CGRect)aFrame
{
    aFrame = CGRectMake(0, 0, aFrame.size.width, aFrame.size.height);
    //    if (CGRectEqualToRect(aFrame, CGRectZero))
    //    {
    //         aFrame = CGRectMake(0, 0, 1, 1);
    //    }
    
    UIGraphicsBeginImageContext(aFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, aFrame);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


//修改图片的尺寸
+ (UIImage*) drawInRectImage:(UIImage*)startImage size:(CGSize)imageSize
{
    float  w = CGImageGetWidth(startImage.CGImage);
    
    float  h = CGImageGetHeight(startImage.CGImage);
    
    float wt = imageSize.width/w;
    
    float ht = imageSize.height/h;
    
    CGRect targetRect;
    
    if (wt<ht) {
        
        targetRect = CGRectMake(0, (imageSize.height-h*wt)/2, imageSize.width, h*wt);
    }else {
        
        targetRect = CGRectMake((imageSize.width-w*ht)/2, 0, w*ht, imageSize.height);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(NULL, imageSize.width, imageSize.height,
                                                 8,
                                                 0,
                                                 colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
      CGContextDrawImage(context, targetRect, startImage.CGImage);
    
    CGContextSaveGState(context);
    
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    
    UIImage* resultImage =[UIImage imageWithCGImage:newCGImage];
    
    CGContextRelease(context);
    CGImageRelease(newCGImage);
    
    return  resultImage;
    
}



#pragma mark 添加不要备份 属性
+ (BOOL)addSkipBAckupAttributeItemAtURL:(NSURL *)URL
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[URL path]])
    {
        NSLog(@"%s,file not exsit",__func__);
        return NO;
    }
    
    NSError *error = nil;
    
    BOOL success = [URL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    //    BOOL success = NO;
    
    if (!success)
    {
        NSLog(@"%s,faile!,error=%@",__FUNCTION__,error);
    }
    return success;
    
}


#pragma mark 判断是否是邮箱
+ (BOOL)isEmaliRegex:(NSString *)email
{
    NSString *red = @"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", red];
    BOOL isMatch = [pred evaluateWithObject:email];
    return isMatch;
}


#pragma mark md5 加密
///返回 md5
+ (NSString *)md5Str:(NSString *)oriStr
{
    if (oriStr == nil) {
        return nil;
    }
    
    const char *cStr = [oriStr UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest ); //这里的用法明显是错误的，但是不知道为什么依然可以在网络上得以流传。当srcString中包含空字符（\0）时??????????????????
    //    CC_MD5( cStr, self.length, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
    
}






#pragma mark 获取ip地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}


#pragma mark 字典转str
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    if (dic == nil) {
        return nil;
    }
    NSError *parseError = nil;
    
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    if (jsonData != nil  && parseError == nil) {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

@end
