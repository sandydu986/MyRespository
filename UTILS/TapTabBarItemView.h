//
//  TapTabBarItemView.h
//  mxl_iphone
//
//  Created by Tiger on 13-10-31.
//  Copyright (c) 2013年 duhujun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TapTabBarItemView : UIView {
    NSString *title;
    NSInteger selectedTabBarItemIndex;
    UIImageView *imageView;
}
@property (nonatomic, retain) NSString *title;
@property (nonatomic) NSInteger selectedTabBarItemIndex;
@property (nonatomic, retain) UIImageView *imageView;

- (void)setTitle:(NSString *)imageName tag:(NSInteger)tag selected:(NSInteger)selected;

@end
