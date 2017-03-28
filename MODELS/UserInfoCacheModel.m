//
//  UserInfoCacheModel.m
//  Pickers
//
//  Created by wodfan on 6/1/12.
//  Copyright (c) 2012 xuchuan. All rights reserved.
//

#import "UserInfoCacheModel.h"

@implementation UserInfoCacheModel

@synthesize data = _data;


#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.data forKey:@"data"];

}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.data = [aDecoder decodeObjectForKey:@"data"];
    }
    return self;
}

#pragma mark -
#pragma mark NSCopying
- (id)copyWithZone:(NSZone *)zone {
    UserInfoCacheModel *copy = [[[self class] allocWithZone:zone] init];
    copy.data = [self.data copyWithZone:zone];
    return copy;
}

@end