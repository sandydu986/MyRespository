//
//  StarCacheModel.m
//  Pickers
//
//  Created by Chuan XU on 5/31/12.
//  Copyright (c) 2012 xuchuan. All rights reserved.
//

#import "StarCacheModel.h"

#define kUNKey @"Username"
#define kUIKey @"UserImage"
#define kDESCKey @"Desc"
#define kFAVKey @"Fav"
#define kID @"Id"
#define kPDKey @"Date"
#define kURL @"Url"
#define kCDATE @"CollectDate"
#define kSTIME @"SortTime"
#define kSTATUS @"Status"

@implementation StarCacheModel

@synthesize star_id;
@synthesize username;
@synthesize userImage;
@synthesize desc;
@synthesize publish_date;
@synthesize fav;
@synthesize url;
@synthesize collect_date;
@synthesize sort_time;
@synthesize status;

#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:username forKey:kUNKey];
    [aCoder encodeObject:userImage forKey:kUIKey];
    [aCoder encodeObject:desc forKey:kDESCKey];
    [aCoder encodeObject:publish_date forKey:kPDKey];
    [aCoder encodeObject:fav forKey:kFAVKey];
    [aCoder encodeObject:star_id forKey:kID];
    [aCoder encodeObject:url forKey:kURL];
    [aCoder encodeObject:collect_date forKey:kCDATE];
    [aCoder encodeObject:sort_time forKey:kSTIME];
    [aCoder encodeObject:status forKey:kSTATUS];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        username = [aDecoder decodeObjectForKey:kUNKey];
        userImage = [aDecoder decodeObjectForKey:kUIKey];
        desc = [aDecoder decodeObjectForKey:kDESCKey];
        publish_date = [aDecoder decodeObjectForKey:kPDKey];
        fav = [aDecoder decodeObjectForKey:kFAVKey];
        star_id = [aDecoder decodeObjectForKey:kID];
        url = [aDecoder decodeObjectForKey:kURL];
        collect_date = [aDecoder decodeObjectForKey:kCDATE];
        sort_time = [aDecoder decodeObjectForKey:kSTIME];
        status = [aDecoder decodeObjectForKey:kSTATUS];
    }
    return self;
}

#pragma mark -
#pragma mark NSCopying
- (id)copyWithZone:(NSZone *)zone {
    StarCacheModel *copy = [[[self class] allocWithZone:zone] init];
    copy.username = [self.username copyWithZone:zone];
    copy.userImage = [self.userImage copyWithZone:zone];
    copy.desc = [self.desc copyWithZone:zone];
    copy.publish_date = [self.publish_date copyWithZone:zone];
    copy.fav = [self.fav copyWithZone:zone];
    copy.star_id = [self.star_id copyWithZone:zone];
    copy.url = [self.url copyWithZone:zone];
    copy.collect_date = [self.collect_date copyWithZone:zone];
    copy.sort_time = [self.sort_time copyWithZone:zone];
    copy.status = [self.status copyWithZone:zone];
    
    return copy;
}

@end
