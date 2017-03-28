//
//  TapTabBarItemView.m
//  mxl_iphone
//
//  Created by Tiger on 13-10-31.
//  Copyright (c) 2013年 duhujun. All rights reserved.
//

#import "TapTabBarItemView.h"

@implementation TapTabBarItemView
@synthesize title;
@synthesize selectedTabBarItemIndex;
@synthesize imageView;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setTitle:(NSString *)imageName tag:(NSInteger)tag selected:(NSInteger)selected{
    [self setTag:tag];
    self.title = imageName;
    self.selectedTabBarItemIndex = selected;
    //128*106  下导航  640*960
    if (tag==0) {
        [self setFrame:CGRectMake(0, 0, 106, 44)];
    }else if (tag==1) {
        [self setFrame:CGRectMake(106, 0, 108, 44)];
    }else if (tag==2) {
        [self setFrame:CGRectMake(214, 0, 106, 44)];
    }
    [self setBackgroundColor:[UIColor clearColor]];
    if (!imageView) {
        imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        if (tag==1) {
            [imageView setFrame:CGRectMake(0, 0, 108, 44)];
        }else {
            [imageView setFrame:CGRectMake(0, 0, 106, 44)];
        }
        [self addSubview:imageView];
    }else {
        imageView.image = [UIImage imageNamed:imageName];
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapFrom:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)handleTapFrom:(UIGestureRecognizer *)sender {
//    TapTabBarItemView *selectedTabBarItemView = (TapTabBarItemView *)[sender.view hitTest:[sender locationInView:sender.view] withEvent:nil ];
//    NSLog(@"sender.tag = %ld",sender.view.tag);
//    [self handleTapFrom:selectedTabBarItemView.tag];
}

- (void)handleTapFromTag:(NSInteger)tag{
    TapTabBarItemView *selectedTabBarItemView = (TapTabBarItemView *)[self viewWithTag:tag];
    if (selectedTabBarItemView.tag != self.selectedTabBarItemIndex) {
        
    }
    [[NSNotificationCenter defaultCenter  ]postNotificationName:@"change.tabbar.view" object:[NSNumber numberWithInteger:self.tag]];
}



@end
