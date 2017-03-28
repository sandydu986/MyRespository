//
//  Common_param.h
//  mxl_iphone
//
//  Created by Tiger on 13-11-22.
//  Copyright (c) 2013年 duhujun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Common_param : NSObject

@property (nonatomic, assign) int loginDismiss;
@property (nonatomic, assign) int success;//判断loading是否成功

#pragma mark-用户资料
@property (nonatomic, retain) NSString *account;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *user_id;


@end

