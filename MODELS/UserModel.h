//
//  UserModel.h
//  Pickers
//
//  Created by wodfan on 5/31/12.
//  Copyright (c) 2012 xuchuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Commont_Utils.h"

#define LOGIN_URL @"%@/user/login?from=%@&open_id=%@&token=%@&username=%@&gender=%@&location=%@&identifier=%@&avatar=%@"

@interface UserModel : NSObject

@property(nonatomic) BOOL isLogin;
@property(nonatomic) BOOL isCollectLogin; //以前只有登录用户才能登录即isLogin=YES,现在匿名也可以登录，所以只改为调用此参数，为常量YES;  
@property(nonatomic, strong) NSString *from; //来自，qq,weibo,taobao 等开放平台
@property(nonatomic) NSString *fromText ; //来自
@property(nonatomic, strong) NSString *openId;   //对于每个from他唯一代表一个用户
@property(nonatomic, strong) NSString *token;   //token
@property(nonatomic, strong) NSString *identify; //唯一标示，用于cache存储  = from + openId
@property(nonatomic, strong) NSString *userNick;   //昵称
@property(nonatomic, strong) NSString *userId;    //id
@property(nonatomic, strong) NSString *userAvatar; //头像
@property(nonatomic, strong) NSString *userLocation; //地区
@property(nonatomic, strong) NSString *userGender;   //性别 用户信息，性别：female女，male男


/*获取全局用户信息唯一实例，请不要再重新为UserModel创建实例*/
+ (UserModel *) sharedInstance;
+ (NSString *)generateFromTextForCollect:(NSString*)from;
+ (NSString *)generateFromText:(NSString *)from;

- (BOOL) login:(NSDictionary *)info;
- (void) loginSuccess:(NSDictionary *)info;
- (void) logout;
@end
