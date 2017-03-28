//
//  CommonFunctions.h
//  mxl_iphone
//
//  Created by mac on 13-10-13.
//  Copyright (c) 2013年 duhujun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>


#define MD_5 @"vT52WXsLraBu"//public final static String MD5 = "vT52WXsLraBu";



#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@interface CommonFunctions : NSObject<CAAnimationDelegate>
#else
@interface CommonFunctions : NSObject
#endif
@property (nonatomic, retain) CLLocation *Location;

/*
 * 获得root path json，包含所有domain和接口的信息
 */
+ (BOOL)initDomainInfo;

+ (NSDictionary *)getDomainInfo;


+ (void) backAction:(UINavigationController *)navigationcontroller;
+ (NSString *)getVersion;
/*裁切图片*/
+(UIImage*)getSubImage:(CGRect)rect  image:(UIImage *)image;
/*监测网络*/
+(BOOL)checkNetWork;

+ (void) deleteRecord:(NSString *)path;
+(NSData *)decodeAmr:(NSData *)data;
+(NSData *)recoderAmr:(NSData *)data;
+(void) vibratePhone;
+(NSString *)md5:(NSString *)str;

//第三登陆判断
+(void) setThirdIndex:(int) thirdIndex;
+(int) getThirdIndex;

//判断手机号码
+ (BOOL)checkTel:(NSString *)str;

@end
