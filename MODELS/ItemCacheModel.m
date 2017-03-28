//
//  ItemCacheModel.m
//  Pickers
//
//  Created by Chuan XU on 5/31/12.
//  Copyright (c) 2012 xuchuan. All rights reserved.
//

#import "ItemCacheModel.h"

#define kURLKey @"Url"
#define kDESCKey @"Desc"
#define kPRICEKey @"Price"
#define kSELLKey @"Sell"
#define kFAVKey @"Fav"
#define kID @"Id"
#define kCDATE @"CollectDate"
#define kSTIME @"SortTime"
#define kSTATUS @"Status"
#define kSKU @"Sku"

@implementation ItemCacheModel

@synthesize url;
@synthesize desc;
@synthesize price;
@synthesize sell;
@synthesize fav;
@synthesize item_id;
@synthesize collect_date;
@synthesize sort_time;
@synthesize status;
@synthesize sku_id;

#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:url forKey:kURLKey];
    [aCoder encodeObject:desc forKey:kDESCKey];
    [aCoder encodeObject:price forKey:kPRICEKey];
    [aCoder encodeObject:sell forKey:kSELLKey];
    [aCoder encodeObject:fav forKey:kFAVKey];
    [aCoder encodeObject:item_id forKey:kID];
    [aCoder encodeObject:collect_date forKey:kCDATE];
    [aCoder encodeObject:sort_time forKey:kSTIME];
    [aCoder encodeObject:status forKey:kSTATUS];
    [aCoder encodeObject:sku_id forKey:kSKU];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        url = [aDecoder decodeObjectForKey:kURLKey];
        desc = [aDecoder decodeObjectForKey:kDESCKey];
        price = [aDecoder decodeObjectForKey:kPRICEKey];
        sell = [aDecoder decodeObjectForKey:kSELLKey];
        fav = [aDecoder decodeObjectForKey:kFAVKey];
        item_id = [aDecoder decodeObjectForKey:kID];
        collect_date = [aDecoder decodeObjectForKey:kCDATE];
        sort_time = [aDecoder decodeObjectForKey:kSTIME];
        status = [aDecoder decodeObjectForKey:kSTATUS];
        sku_id = [aDecoder decodeObjectForKey:kSKU];
    }
    return self;
}

#pragma mark -
#pragma mark NSCopying
- (id)copyWithZone:(NSZone *)zone {
    ItemCacheModel *copy = [[[self class] allocWithZone:zone] init];
    copy.url = [self.url copyWithZone:zone];
    copy.desc = [self.desc copyWithZone:zone];
    copy.price = [self.price copyWithZone:zone];
    copy.sell = [self.sell copyWithZone:zone];
    copy.fav = [self.fav copyWithZone:zone];
    copy.item_id = [self.item_id copyWithZone:zone];
    copy.collect_date = [self.collect_date copyWithZone:zone];
    copy.sort_time = [self.sort_time copyWithZone:zone];
    copy.status = [self.status copyWithZone:zone];
    copy.sku_id = [self.sku_id copyWithZone:zone];
    
    return copy;
}

@end
