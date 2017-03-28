//
//  CacheUtil.m
//  Pickers
//
//  Created by Chuan XU on 5/31/12.
//  Copyright (c) 2012 xuchuan. All rights reserved.
//

#import "CacheUtil.h"
#import "ItemCacheModel.h"
#import "StarCacheModel.h"
#import "UserModel.h"
#import "UserInfoCacheModel.h"



static NSString * const STARSKEY = @"stars";
static NSString * const ITEMSKEY = @"items";
static NSString * const USERINFOKEY = @"userinfo";
static NSString * const SHAREUSERKEY = @"shareuser";

static NSString * const CURRENTUSERKEY = @"userkey";
static NSString * const ANONYMOUSKEYFORCOLLECT = @"anonymousekeyforcollect";

static NSString * const CACHEIMAGE = @"cacheimage";

@implementation CacheUtil

@synthesize kFilename;
@synthesize kDataKey;
@synthesize kLocalData;

static CacheUtil * instance;

+ (CacheUtil *) sharedInstance {
    if (instance == nil) {
        @synchronized(self) {
            if (instance == nil) {
                instance = [[CacheUtil alloc] init];
            }
        }
    }
    return instance;
}

-(id) init {
    if (self = [super init]) {
        kFilename = @"archive";
        kDataKey = @"data";
        starsKey = STARSKEY;
        itemsKey = ITEMSKEY;
        userInfoKey = USERINFOKEY;
        
        NSData *data = [[NSMutableData alloc] initWithContentsOfFile:[self dataFilePath]];
        if (data) {
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            kLocalData = [unarchiver decodeObjectForKey:kDataKey];
            [unarchiver finishDecoding];
        }
        
        if (!kLocalData) {
            kLocalData = [[NSMutableDictionary alloc] init];
        }
    }
    return self;
}

- (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kFilename];
}

- (void)applicationWillResignActive:(NSNotification *)notification { 
    [self flushCache];
}
- (void)flushCache {
    NSMutableData *data = [[NSMutableData alloc] init]; 
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:kLocalData forKey:kDataKey];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

- (void)addCacheData:(NSObject *)object {
    NSMutableDictionary *userCache = [self getCacheData];
    if([object isKindOfClass:[ItemCacheModel class]]) {
        ItemCacheModel *item = (ItemCacheModel *)object;
        NSMutableDictionary *items = [userCache objectForKey:ITEMSKEY];
        [items setObject:item forKey:item.sku_id];
    } else if ([object isKindOfClass:[StarCacheModel class]]){
        StarCacheModel *star = (StarCacheModel *)object;
        NSMutableDictionary *stars = [userCache objectForKey:STARSKEY];
//        NSLog(@"add %@", star.star_id);
        [stars setObject:star forKey:star.star_id];
    } else if([object isKindOfClass:[UserInfoCacheModel class]]){
        UserInfoCacheModel *userinfo = (UserInfoCacheModel *)object;
        NSMutableDictionary *items = [userCache objectForKey:USERINFOKEY];
//        NSLog(@"add %@", @"userinfo");
        [items setObject:userinfo forKey:@"userinfo"];
    }
    
    [self flushCache];
}
- (void) addCollectCacheData :(NSObject *) object{
    NSMutableDictionary *userCache = [self getCollectCacheData];
    if([object isKindOfClass:[ItemCacheModel class]]) {
        ItemCacheModel *item = (ItemCacheModel *)object;
        NSMutableDictionary *items = [userCache objectForKey:ITEMSKEY];
        [items setObject:item forKey:item.sku_id];
    } else if ([object isKindOfClass:[StarCacheModel class]]){
        StarCacheModel *star = (StarCacheModel *)object;
        NSMutableDictionary *stars = [userCache objectForKey:STARSKEY];
//        NSLog(@"add %@", star.star_id);
        [stars setObject:star forKey:star.star_id];
    } else if([object isKindOfClass:[UserInfoCacheModel class]]){
        UserInfoCacheModel *userinfo = (UserInfoCacheModel *)object;
        NSMutableDictionary *items = [userCache objectForKey:USERINFOKEY];
//        NSLog(@"add %@", @"userinfo");
        [items setObject:userinfo forKey:@"userinfo"];
    }
    
    [self flushCache];
}
- (void)deleteCacheData:(NSObject *)object {
    NSMutableDictionary *userCache = [self getCacheData];
    if([object isKindOfClass:[ItemCacheModel class]]) {
        ItemCacheModel *item = (ItemCacheModel *)object;
        NSMutableDictionary *items = [userCache objectForKey:ITEMSKEY];
//        NSLog(@"......Deleting an item............");
//        NSLog(@"%@", item.status);
        if ([item.status isEqualToString:@"added"]){
            item.status = @"remove";
//            NSLog(@"item's status has been changed to 'remove'");
        } else {
            [items removeObjectForKey:item.sku_id];
//            NSLog(@"item %@ has been removed", item.sku_id);
        }

    } else if ([object isKindOfClass:[StarCacheModel class]]) {
        StarCacheModel *star = (StarCacheModel *)object;
        NSMutableDictionary *stars = [userCache objectForKey:STARSKEY];
//        NSLog(@"......Deleting a star..............");
//        NSLog(@"%@", star.status);
        if ([star.status isEqualToString:@"added"]){
            star.status = @"remove";
//            NSLog(@"star's status has been changed to 'remove'");
        } else {
            [stars removeObjectForKey:star.star_id];
//            NSLog(@"star %@ has been removed", star.star_id);
        }
    }
    [self flushCache];

}
- (void)deleteCollectCacheData:(NSObject *)object {
    NSMutableDictionary *userCache = [self getCollectCacheData];
    if([object isKindOfClass:[ItemCacheModel class]]) {
        ItemCacheModel *item = (ItemCacheModel *)object;
        NSMutableDictionary *items = [userCache objectForKey:ITEMSKEY];
//        NSLog(@"......Deleting an item............");
//        NSLog(@"%@", item.status);
        if ([item.status isEqualToString:@"added"]){
            item.status = @"remove";
//            NSLog(@"item's status has been changed to 'remove'");
        } else {
            [items removeObjectForKey:item.sku_id];
//            NSLog(@"item %@ has been removed", item.sku_id);
        }

    } else if ([object isKindOfClass:[StarCacheModel class]]) {
        StarCacheModel *star = (StarCacheModel *)object;
        NSMutableDictionary *stars = [userCache objectForKey:STARSKEY];
//        NSLog(@"......Deleting a star..............");
//        NSLog(@"%@", star.status);
        if ([star.status isEqualToString:@"added"]){
            star.status = @"remove";
//            NSLog(@"star's status has been changed to 'remove'");
        } else {
            [stars removeObjectForKey:star.star_id];
//            NSLog(@"star %@ has been removed", star.star_id);
        }
    }
    [self flushCache];

}
- (void)changeStatusToString:(NSString *)status type:(NSString *)type key:(NSString *)key {
    NSMutableDictionary *userCache = [self getCollectCacheData];
    if ([type isEqualToString:ITEMSKEY]) {
        NSMutableDictionary *items = [userCache objectForKey:ITEMSKEY];
        ItemCacheModel *item = [items objectForKey:key];
        item.status = status;
//        NSLog(@"Item %@'s status has been changed to %@", key, status);
    } else if ([type isEqualToString:STARSKEY]) {
        NSMutableDictionary *stars = [userCache objectForKey:STARSKEY];
        StarCacheModel *star = [stars objectForKey:key];
        star.status = status;
//        NSLog(@"Star %@'s status has been changed to %@", key, status);
    }
    [self flushCache];
}

- (void)deleteCacheDataWithID: (NSString *)id key:(NSString *)key {
    NSMutableDictionary *userCache = [self getCacheData];
    if ([key isEqualToString:ITEMSKEY]) {
        NSMutableDictionary *items = [userCache objectForKey:ITEMSKEY];
        ItemCacheModel *item  = [items objectForKey:id];
//        NSLog(@"......Deleting an item...............");
//        NSLog(@"%@", item.status);
        if ([item.status isEqualToString:@"added"]){
            item.status = @"remove";
//            NSLog(@"item's status has been changed to 'remove'");
        } else {
            [items removeObjectForKey:id];
//            NSLog(@"item %@ has been removed", id);
        }
    } else if ([key isEqualToString:STARSKEY]) {
        NSMutableDictionary *stars = [userCache objectForKey:STARSKEY];
        StarCacheModel *star  = [stars objectForKey:id];
//        NSLog(@"......Deleting a star..............");
//        NSLog(@"%@", star.status);
        if ([star.status isEqualToString:@"added"]){
            star.status = @"remove";
//            NSLog(@"star's status has been changed to 'remove'");
        } else {
            [stars removeObjectForKey:id];
//            NSLog(@"star %@ has been removed", id);
        }
    }
    [self flushCache];
}
- (void)deleteCollectCacheDataWithID: (NSString *)id key:(NSString *)key {
    NSMutableDictionary *userCache = [self getCollectCacheData];
    if ([key isEqualToString:ITEMSKEY]) {
        NSMutableDictionary *items = [userCache objectForKey:ITEMSKEY];
        ItemCacheModel *item  = [items objectForKey:id];
//        NSLog(@"......Deleting an item...............");
//        NSLog(@"%@", item.status);
        if ([item.status isEqualToString:@"added"]){
            item.status = @"remove";
//            NSLog(@"item's status has been changed to 'remove'");
        } else {
            [items removeObjectForKey:id];
//            NSLog(@"item %@ has been removed", id);
        }
    } else if ([key isEqualToString:STARSKEY]) {
        NSMutableDictionary *stars = [userCache objectForKey:STARSKEY];
        StarCacheModel *star  = [stars objectForKey:id];
//        NSLog(@"......Deleting a star..............");
//        NSLog(@"%@", star.status);
        if ([star.status isEqualToString:@"added"]){
            star.status = @"remove";
//            NSLog(@"star's status has been changed to 'remove'");
        } else {
            [stars removeObjectForKey:id];
//            NSLog(@"star %@ has been removed", id);
        }
    }
    [self flushCache];
}
- (NSMutableDictionary *)getCacheData {
//    NSLog(@"current user open id: %@" , [UserModel sharedInstance].identify);
    if(![UserModel sharedInstance].identify){
        return nil;
    }
    return [self getCacheDataWithKey:[UserModel sharedInstance].identify];
}
- (NSMutableDictionary *)getCollectCacheData{
    return [self getCacheDataWithKey:ANONYMOUSKEYFORCOLLECT];
}
//把从三方登录用户收藏的数据 整合进匿名用户数据后再显示
- (NSMutableDictionary *)getCollectCacheDataMergeLoginCache{
    if([UserModel sharedInstance].identify){
        //save Current identify collect info to 匿名用户
        NSMutableDictionary *cacheData = [self getCacheDataWithKey:[UserModel sharedInstance].identify];
        
        NSDictionary *items = [cacheData objectForKey:[self getItemsKey]];
        NSDictionary *stars = [cacheData objectForKey:[self getStarsKey]];

        if(items.count == 0 && stars.count == 0){
            return [self getCollectCacheData];
        }
        
        NSEnumerator *eItemKey = [items keyEnumerator];
        id itemKey;
        while (itemKey = [eItemKey nextObject]){
            id itemOb = [items objectForKey:itemKey];
            [self addCollectCacheData:itemOb];
        }
        
        NSEnumerator *eStarKey = [stars keyEnumerator];
        id starKey;
        while (starKey = [eStarKey nextObject]){
            id itemOb = [stars objectForKey:starKey];
            [self addCollectCacheData:itemOb];
        }
        [cacheData setValue:[[NSDictionary alloc] init] forKey:[self getItemsKey]];
        [cacheData setValue:[[NSDictionary alloc] init] forKey:[self getStarsKey]];
        [self flushCache];
        NSLog(@"");
    }
    return [self getCollectCacheData];
}

- (NSString *)getCacheKey{
    if (![kLocalData objectForKey:CURRENTUSERKEY]){
        [kLocalData setObject:@"" forKey:CURRENTUSERKEY];
    }
    return [kLocalData objectForKey:CURRENTUSERKEY];
}
-(NSDictionary *) getShareUserCache:(NSString *)key{
    NSDictionary *dic = nil;
    dic = [[kLocalData objectForKey:SHAREUSERKEY] objectForKey:key];
    return dic;
}
-(void) setShareUserCache:(NSDictionary *)data key:(NSString *)key{
    if(![kLocalData objectForKey:SHAREUSERKEY]){
        [kLocalData setObject:[NSMutableDictionary dictionary] forKey:SHAREUSERKEY];
    }
    [[kLocalData objectForKey:SHAREUSERKEY] setObject:data forKey:key];
    [self flushCache];
}
- (NSMutableDictionary *)getCacheDataWithKey: (NSString *)identify {
    if (![kLocalData objectForKey:identify]) {
        NSMutableDictionary *userCache = [[NSMutableDictionary alloc] init];
        [kLocalData setObject:userCache forKey:identify];
        NSMutableDictionary *stars = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *items = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *userinfo = [[NSMutableDictionary alloc] init];
        [userCache setObject:stars forKey:STARSKEY];
        [userCache setObject:items forKey:ITEMSKEY];
        [userCache setObject:userinfo forKey:USERINFOKEY];
        [self flushCache];
    }
    return [kLocalData objectForKey:identify];
}

- (void)setCacheKey:(NSString *)key{
    [kLocalData setObject:key forKey:CURRENTUSERKEY];
    [self flushCache];
}

- (void)setCacheImageURL: (NSString *)url{
    [kLocalData setObject:url forKey:CACHEIMAGE];
    [self flushCache];
}

- (NSString *)getCacheImageURL{
    return [kLocalData objectForKey:CACHEIMAGE];
}

- (NSString *)getItemsKey {
    return itemsKey;
}

- (NSString *)getStarsKey {
    return starsKey;
}
- (NSString *)getUserInfoKey{
    return userInfoKey;
}


- (NSInteger)getStarsNum {
    NSMutableDictionary *userCache = [self getCacheData];
    return [[userCache objectForKey:STARSKEY] count];
}

- (NSInteger)getItemsNum {
    NSMutableDictionary *userCache = [self getCacheData];
    return [[userCache objectForKey:ITEMSKEY] count];
}
@end
