//
//  ItemCacheModel.h
//  Pickers
//
//  Created by Chuan XU on 5/31/12.
//  Copyright (c) 2012 xuchuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemCacheModel : NSObject <NSCoding, NSCopying> {
    NSString *url;
    NSString *desc;
    NSString *price;
    NSString *sell;
    NSString *fav;
    NSString *item_id;
    NSString *collect_date;
    NSString *sort_time;
    NSString *status;
    NSString *sku_id;
}

@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *desc;
@property (nonatomic, retain) NSString *price;
@property (nonatomic, retain) NSString *sell;
@property (nonatomic, retain) NSString *fav;
@property (nonatomic, retain) NSString *item_id;
@property (nonatomic, retain) NSString *collect_date;
@property (nonatomic, retain) NSString *sort_time;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *sku_id;

@end
