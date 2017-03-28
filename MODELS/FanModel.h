//
//  FanModel.h
//  Wodfan
//
//  Created by TangQiao on 11-12-10.
//  Copyright (c) 2011年 DevTang.com All rights reserved.
//

#import "Foundation/Foundation.h"
#import "SBJSON.h"
#import "ASIFormDataRequest.h"
#import "NSString+urlEncode.h"
#import "Commont_Utils.h"
#import "UserModel.h"

typedef enum REQUESTTAG {
    HEAD_REQUESTTAG = 0,
    MAIN_REQUESTTAG,
    SEARCH_REQUESTTAG,
    STAR_DETAIL_REQUESTTAG
} REQUESTTAG;

@interface FanModel : NSObject{
    NSOperationQueue *queue;
    NSInteger enabledTag;
    NSMutableDictionary *events;
}

@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString * password;
@property (nonatomic, strong) NSString * token;
@property (nonatomic, retain) UIViewController * globalWindow;
/*
@property (nonatomic, retain) UIView * contentView;
@property (nonatomic, retain) UIView * tabBarView;
*/

+ (FanModel *) sharedInstance;

// 配置信息
//- (void) loadData;
//- (void) resetData;
//- (void) saveData;

+ (UIImage *) shrinkImage:(UIImage *) image;

// 登陆
//-(BOOL) login:(NSString *)username password:(NSString*)password;

// 上传图片
//-(NSString*) uploadImage:(UIImage*) image;

//// 发表文章
//-(NSString*) postArticleWithImageId:(NSString*)imageId andDesc:(NSString*)desc toType:(NSString*)type;

// 获得image数组的json表示
- (NSString *) getImageDesc:(NSArray*)imageArray;

// get stars

- (void) getStars: (NSInteger) star_id andGetNum: (NSInteger) num query:(NSString *)query requestTag:(REQUESTTAG)requestTag requestEventName:(NSString *)eventName;

// get stars by category
- (void) getStarsByCategory: (NSInteger) offset num:(NSInteger) num query:(NSString *)query requestTag:(REQUESTTAG)requestTag requestEventName:(NSString *)eventName;

// get star
- (void) getStar:(NSInteger)star_id requestEventName:(NSString *)eventName;

// get related items by star

- (void) getRelatedItemsByStar: (NSString*) star_id requestTag:(REQUESTTAG)requestTag requestEventName:(NSString *)eventName;

// get related items count by star

- (NSDictionary *) getRelatedItemsCountByStar: (NSString*) star_id;

// get style

- (NSDictionary *) getStyle;

// get star list page header

- (NSDictionary *) getStarHeader;

// get star ads list

- (void)getStarHeaderAds: (NSString *)eventName;

// get customized enter image

- (void)getCustomizedEnterImage: (NSString *)eventName;

- (NSDictionary*) getJSONFromUrl:(NSURL*) url andUploadImage:(UIImage*)image;
// common method to get json from URL
- (NSDictionary *)getJSONFromUrl:(NSURL*)url;

// get root fe service api url
- (NSDictionary *)getRootFEUrl;

/*!
 @method
 @abstract 用请求队列发请求
 @discussion 这是一个public的方法
 @\ param text requestTag表明最后一个发送的请求的tag
 @\ param error 错误参照
 @\ result void
 */
- (void) sendRequestURLWithQueue:(NSString *)url requestTag:(REQUESTTAG)tag requestEventName:(NSString *)eventName;

- (NSString *)getEventNameWithID:(NSInteger)id;

- (void)registerEvent: (NSString *)name id:(NSInteger)id;
@end
