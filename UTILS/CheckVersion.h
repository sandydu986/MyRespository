//
//  CheckVersion.h
//  xmxcy_iphone
//
//  check app version
//  Created by wodfan on 6/27/12.
//  Copyright (c) 2012 xuchuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckVersion : NSObject<UIAlertViewDelegate>

@property(nonatomic) NSString *sVersionNew;
@property(nonatomic) NSString *sVersionNative;
@property(nonatomic) UIViewController *rootViewController;
@property(nonatomic) UIAlertView *alertViewVersion;


+(CheckVersion *)sharedInstance;
-(void)toUpdate;

-(id)init;
-(void)asynchCheckVersion;
-(void)requestNewestVersion;
-(void)synchCheckVersion;
-(void)alertUpdate;
-(void)alertNewest;




@end
