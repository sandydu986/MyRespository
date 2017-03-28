//
//  CheckNetwork.m
//  xmxcy_iphone
//
//  Created by Weilong Song on 6/14/12.
//  Copyright (c) 2012 xuchuan. All rights reserved.
//

#import "CheckNetwork.h"
@implementation CheckNetwork

+ (BOOL)isOnline
{
	BOOL isExistenceNetwork = false;
	Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
			isExistenceNetwork = FALSE;
            break;
        case ReachableViaWWAN:
			isExistenceNetwork = TRUE;
            break;
        case ReachableViaWiFi:
			isExistenceNetwork = TRUE;
            break;
    }
	return isExistenceNetwork;
}

+ (NSString *)getCurrentNetwork
{
	NSString *isExistenceNetwork;
	Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
			isExistenceNetwork = @"offline";
            break;
        case ReachableViaWWAN:
			isExistenceNetwork = @"3G";
            break;
        case ReachableViaWiFi:
			isExistenceNetwork = @"WIFI";
            break;
    }
	return isExistenceNetwork;
}

@end
