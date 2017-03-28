//
//  CheckNetwork.h
//  xmxcy_iphone
//
//  Created by Weilong Song on 6/14/12.
//  Copyright (c) 2012 xuchuan. All rights reserved.
//

#import "Foundation/Foundation.h"
#import "Reachability.h"

@interface CheckNetwork : NSObject

+ (BOOL)isOnline;
+ (NSString *)getCurrentNetwork;
@end
