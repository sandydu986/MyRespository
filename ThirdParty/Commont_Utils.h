//
//  Comment_Utils.h
//  mxl_iphone
//
//  Created by Tiger on 13-10-21.
//  Copyright (c) 2013年 duhujun. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//外网请求
#define BasicURL @"http://210.51.190.245/dmapp/i"
//@"http://barapi.com"

//内网测试
#define TestNetworking @"192.168.73.106:8080"


@protocol Commont_UtilsDelegate <NSObject>

- (void)asyncDownSuccess:(NSMutableDictionary *)responseDic response:(NSString *)responseStr andIndex:(NSInteger)index;
- (void)asyncDownFail:(NSMutableDictionary *)responseDic andIndex:(NSInteger)index;

@end

@interface Commont_Utils : NSObject

@property (nonatomic, retain) id<Commont_UtilsDelegate>delegate;

- (void)httpRequstStart:(NSString *)str andIndex:(NSInteger)index;
- (void)postWithAPIPath:(NSString *)apiPath
                 params:(NSMutableDictionary *) params andIndex:(NSInteger)index;

@end
