//
//  CacheUtil.h
//  Pickers
//
//  Created by Chuan XU on 5/31/12.
//  Copyright (c) 2012 xuchuan. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CacheUtil : NSObject{
    NSString *kFilename;
    NSString *kDataKey;
    NSMutableDictionary *kLocalData;
    NSString *starsKey;
    NSString *itemsKey;
    NSString *userInfoKey;
}
@property (nonatomic) NSString *kFilename;
@property (nonatomic) NSString *kDataKey;
@property (nonatomic) NSMutableDictionary *kLocalData;

+ (CacheUtil *) sharedInstance;

- (NSString *)dataFilePath;
- (NSMutableDictionary *)getCacheData;//CacheData为当前登录用户存储的信息
- (NSMutableDictionary *)getCollectCacheDataMergeLoginCache;//把旧登录数据整合进匿名用户
- (NSMutableDictionary *)getCollectCacheData;//colloectCacheData为该手机当前存储的信息，跟登录无关
- (NSString *)getCacheKey;
- (NSMutableDictionary *)getCacheDataWithKey: (NSString *)openID;
- (void)setCacheKey: (NSString *)key;
- (void)addCacheData: (NSObject *)object;
- (void) addCollectCacheData :(NSObject *) object;
- (void)deleteCacheData: (NSObject *)object;
- (void)deleteCollectCacheData:(NSObject *)object;
- (void)deleteCacheDataWithID: (NSString *)id key:(NSString *)key;
- (void)deleteCollectCacheDataWithID: (NSString *)id key:(NSString *)key;
- (void)changeStatusToString:(NSString *)status type:(NSString *)type key:(NSString *)key;
- (NSString *)getStarsKey;
- (NSString *)getItemsKey;
- (NSString *)getUserInfoKey;
- (NSInteger)getStarsNum;
- (NSInteger)getItemsNum;
-(NSDictionary *)getShareUserCache:(NSString *)key;
-(void)setShareUserCache:(NSDictionary *)data key:(NSString *)key;
- (void)flushCache;
- (void)applicationWillResignActive:(NSNotification *)notification;
- (void)setCacheImageURL:(NSString *)url;
- (NSString *)getCacheImageURL;
@end
