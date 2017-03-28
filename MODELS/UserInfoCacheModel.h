//
//  UserInfoCacheModel.h
//  Pickers
//
//  Created by wodfan on 6/1/12.
//  Copyright (c) 2012 xuchuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoCacheModel : NSObject<NSCoding, NSCopying>{

}
@property(nonatomic, strong) NSDictionary *data;
@end
