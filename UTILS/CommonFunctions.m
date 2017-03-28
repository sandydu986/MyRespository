//
//  CommonFunctions.m
//  mxl_iphone
//
//  Created by mac on 13-10-13.
//  Copyright (c) 2013年 duhujun. All rights reserved.
//

#import "CommonFunctions.h"
#import "Reachability.h"
#include <sys/sysctl.h>
#include <mach/mach.h>
#import "FanModel.h"
//#include "amrFileCodec.h"

@implementation CommonFunctions


@synthesize Location;

static NSDictionary *domainInfo;

#pragma mark-navigation返回动画
+ (void) backAction:(UINavigationController *)navigationcontroller
{
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.5;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionFade;
    animation.subtype = kCATransitionFromRight;
    //    [[self.view layer] addAnimation:animation forKey:@"animation"];
    [navigationcontroller.view.layer addAnimation:animation forKey:nil];
    [navigationcontroller popViewControllerAnimated:NO];
}

#pragma mark-判断ios版本号
+ (NSString *)getVersion
{
    return [NSString stringWithFormat:@"%f",[[[UIDevice currentDevice] systemVersion] floatValue]];
}

/*裁切图片*/
+(UIImage*)getSubImage:(CGRect)rect  image:(UIImage *)image
{
//    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
//    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
//    
//    UIGraphicsBeginImageContext(smallBounds.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextDrawImage(context, smallBounds, subImageRef);
//    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
//    UIGraphicsEndImageContext();
    
//    return smallImage;
    return image;
}

#pragma mark -自动检测网络是否可用
+(BOOL)checkNetWork {
    BOOL isExistenceNetWork = NO;
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reachability currentReachabilityStatus]) {
        case NotReachable://无网络
            isExistenceNetWork = FALSE;
            break;
        case ReachableViaWWAN://使用3G或RPRS
            isExistenceNetWork = TRUE;
            break;
        case ReachableViaWiFi://使用WiFi
            isExistenceNetWork = TRUE;
            break;
    }
    return isExistenceNetWork;
}

#pragma mark -删除路径下资源
+ (void) deleteRecord:(NSString *)path
{
    if (path != nil && [path length] > 0)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cacheDirectory = [paths objectAtIndex:0];
        cacheDirectory = [cacheDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"sound/%@",path]];
        [fileManager removeItemAtPath:cacheDirectory error:nil];
    }
}

+(NSData *)decodeAmr:(NSData *)data{
    if (!data) {
        return data;
    }
    return nil;
//    return DecodeAMRToWAVE(data);
}

+(NSData *)recoderAmr:(NSData *)data
{
    if (!data)
    {
        return data;
    }
    return nil;
//    return EncodeWAVEToAMR(data, 1, 16);
}

+ (void) vibratePhone
{
    NSString *isVibrate = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"isVibrate"];
    if (isVibrate ==nil || [@"0" isEqualToString:isVibrate])
    {
       // AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    }
}

+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[32];
    CC_MD5( cStr, (unsigned int)strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


//第三登陆判断
static int m_thirdIndex = -1;
//设置第三方 下标
+(void) setThirdIndex:(int) thirdIndex
{
    m_thirdIndex =thirdIndex;
}

//获取第三方 下标
+(int) getThirdIndex
{
    return m_thirdIndex;
}

#pragma mark-判断手机号码_正则表达式
+ (BOOL)checkTel:(NSString *)str{
    
    if ([str length] == 0) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"手机号码为空", nil) message:NSLocalizedString(@"请输入手机号", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        return NO;
    }
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        return NO;
        
    }
    return YES;
    
}


+(BOOL)initDomainInfo{
    BOOL f = false;
    NSDictionary *d = [[FanModel sharedInstance] getRootFEUrl];
    if (d) {
        if ([d objectForKey:@"content"]) {
            NSDictionary *dd = [d objectForKey:@"content"];
            if (dd) {
                domainInfo = [dd objectForKey:@"fe"];
                f = true;
            }
        }
    }
    return f;
}

+(NSDictionary*)getDomainInfo{
    return domainInfo;
}




@end
