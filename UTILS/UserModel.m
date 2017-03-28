//
//  UserModel.m
//  Pickers
//
//  Created by wodfan on 5/31/12.
//  Copyright (c) 2012 xuchuan. All rights reserved.
//

#import "UserModel.h"
#import "FanModel.h"
#import "SBJSON.h"
#import "ASIFormDataRequest.h"
#import "NSString+urlEncode.h"
#import "UserInfoCacheModel.h"
#import "CacheUtil.h"


@implementation UserModel{
    SBJSON * jsonTool;
}

@synthesize identify = _identify;
@synthesize userId = _userId;
@synthesize from = _from;
@synthesize fromText = _fromText;
@synthesize isLogin = _isLogin;
@synthesize isCollectLogin = _isCollectLogin;
@synthesize userNick = _userNick;
@synthesize userAvatar = _userAvatar;
@synthesize userGender = _userGender;
@synthesize userLocation = _userLocation;
@synthesize token = _token;
@synthesize openId = _openId;



static UserModel * instance;
+ (UserModel *) sharedInstance {
    if (instance == nil) {
        @synchronized(self) {
            if (instance == nil) {
                CacheUtil *cache = [CacheUtil sharedInstance];
                if ([cache getCacheKey]){
                    UserInfoCacheModel *cacheUser = [[[cache getCacheDataWithKey:[cache getCacheKey]] objectForKey:cache.getUserInfoKey] objectForKey:@"userinfo"]; 
//                    NSLog(@"chacheData for userinfo:%@",cacheUser.data);
                    if(cacheUser){
                        instance = [[UserModel alloc] initWithCacheData:cacheUser.data];
                    } else {
                        instance = [[UserModel alloc] init];
                    }
                }else{
                        instance = [[UserModel alloc] init];
                }
                instance.isCollectLogin = YES;//为true，匿名可收藏
            }
        }
    }
    return instance;
}

-(UserModel *) initWithCacheData:(NSDictionary *) info{
    self = [super init];
    [self sessionData:info];
    return self;
}

//去登录
-(BOOL) login:(NSDictionary *)info{

    NSString *from = [info objectForKey:@"from"];    //必填
    NSString *openId = [info objectForKey:@"openId"];   //必填，用户唯一标示
    NSString *token = [info objectForKey:@"token"];//必填， 用于后台验证用户身份
    NSString *userNick = [info objectForKey:@"userNick"];//可选，用户昵称
    NSString *userGender = [info objectForKey:@"userGender"];//可选，用户信息，性别：female女，male男
    //NSDate *expireDate = [info objectForKey:@"expireDate"];// token过期日期
    NSString *userLocation = [info objectForKey: @"userLocation"]; // 可选，地址
    NSString *userId = [info objectForKey:@"userId"];   //可选，用户信息：userid
    NSString *userAvatar = [info objectForKey:@"userAvatar"];//可选，用户信息：头像
    NSString *urlStr = [NSString stringWithFormat:LOGIN_URL, BasicURL,
        [from urlEncode],
        [openId urlEncode],
        [token urlEncode],
        [userNick urlEncode],
        [userGender urlEncode], 
        [userLocation urlEncode],  
        [userId urlEncode],
        [userAvatar   urlEncode]
    ];

    NSURL *url = [NSURL URLWithString:urlStr];
    NSDictionary *json = [[FanModel sharedInstance] getJSONFromUrl:url];
    if([[json objectForKey:@"result"] intValue] == 1){
        [self loginSuccess:[json objectForKey:@"data"]];
        return YES;
    }
    return NO;
}

-(void) sessionData : (NSDictionary *)info{

    self.isLogin = [[info objectForKey:@"isLogin"] boolValue];
    self.from = [info objectForKey:@"from"];
    self.fromText = [UserModel generateFromText:self.from];
    self.token = [info objectForKey:@"token"];
    self.openId = [info objectForKey:@"openId"];
    self.userId = [info objectForKey:@"userId"];
    self.userAvatar = [info objectForKey:@"userAvatar"];
    self.userGender = [info objectForKey:@"userGender"];
    self.userLocation = [info objectForKey:@"userLocation"];
    self.userNick = [info objectForKey:@"userNick"];
    self.identify = [info objectForKey:@"identify"];
    
    CacheUtil *cache = [CacheUtil sharedInstance];
    [cache setCacheKey:self.identify?self.identify :@""];
    
}
+ (NSString *)generateFromTextForCollect:(NSString *)from{
    NSDictionary *fromName = [[NSDictionary alloc] initWithObjectsAndKeys:
        @"淘宝", @"taobao",
        @"QQ",@"qq",
        @"新浪微博", @"weibo"
    ,nil];
    NSString *fromText = [fromName objectForKey:from];
    return fromText;
}
+ (NSString *)generateFromText:(NSString *)from{
    NSDictionary *fromName = [[NSDictionary alloc] initWithObjectsAndKeys:
        @"淘宝", @"taobao",
        @"QQ",@"qq",
        @"新浪微博", @"weibo"
    ,nil];
    NSString *fromText = [fromName objectForKey:from];
    return fromText;
}
-(void) cacheData : (NSDictionary *)info{
    UserInfoCacheModel *usermode = [[UserInfoCacheModel alloc]init];
    usermode.data = info;
    CacheUtil *cache = [CacheUtil sharedInstance];
    [cache addCacheData:usermode];
}

-(void) loginSuccess:(NSDictionary *)info{
    NSNumber *isLogin = [NSNumber numberWithBool:YES];
    NSString *from = [info objectForKey:@"from"];
    NSString *token = [info objectForKey:@"token"];
    NSString *openId = [info objectForKey:@"open_id"];
    NSString *userId = [info objectForKey:@"user_id"];
    NSString *userAvatar = [info objectForKey:@"avatar"];
    NSString *userGender = [[info objectForKey:@"gender"] intValue] == 0?@"female" : @"male";  //0为女  1男
    NSString *userLocation = [info objectForKey:@"location"];
    NSString *userNick = [info objectForKey:@"username"];
    NSString *identify = [from stringByAppendingString:openId];
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
        isLogin, @"isLogin",
        from, @"from",
        token, @"token",
        openId, @"openId",
        userId, @"userId",
        userAvatar, @"userAvatar",
        userGender,@"userGender",
        userLocation, @"userLocation",
        userNick, @"userNick",
        identify, @"identify",
    nil];
    [self sessionData:data];
    [self cacheData:data];
}

-(void) logout{
    NSDictionary *info =[[NSDictionary alloc]initWithObjectsAndKeys:
        [NSNumber numberWithBool:NO], @"isLogin",
    nil];
    [self sessionData:info];
}

@end
