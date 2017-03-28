//
//  StarCacheModel.h
//  Pickers
//
//  Created by Chuan XU on 5/31/12.
//  Copyright (c) 2012 xuchuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StarCacheModel : NSObject {
    NSString *star_id;
    NSString *username;
    NSString *userImage;
    NSString *desc;
    NSString *fav;
    NSString *publish_date;
    NSString *url;
    NSString *collect_date;
    NSString *sort_time;
    NSString *status;
}

@property (nonatomic, retain) NSString *star_id;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *userImage;
@property (nonatomic, retain) NSString *desc;
@property (nonatomic, retain) NSString *fav;
@property (nonatomic, retain) NSString *publish_date;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *collect_date;
@property (nonatomic, retain) NSString *sort_time;
@property (nonatomic, retain) NSString *status;
@end
