//
//  AppDelegate.h
//  NewRecorder
//
//  Created by Tiger on 3/28/17.
//  Copyright © 2017 Tiger. All rights reserved.
//

#import <UIKit/UIKit.h>

#define sharedApp  ((AppDelegate*)[[UIApplication sharedApplication] delegate])

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

