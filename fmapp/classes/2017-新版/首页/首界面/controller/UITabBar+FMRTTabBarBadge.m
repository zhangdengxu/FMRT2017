//
//  UITabBar+FMRTTabBarBadge.m
//  fmapp
//
//  Created by apple on 2016/12/20.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "UITabBar+FMRTTabBarBadge.h"
#define TabBarItemNums 4.0
#define ViewTag 999
#define RedIconeRadius 5


@implementation UITabBar (FMRTTabBarBadge)

- (void)showBadgeOnItemIndex:(NSInteger)index{

    [self removeBadgeOnItemIndex:index];
    
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = ViewTag + index;
    badgeView.layer.cornerRadius = RedIconeRadius;
    badgeView.backgroundColor = [UIColor redColor];
    CGRect tabFrame = self.frame;
    
    float percentX = (index +0.6) /TabBarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, RedIconeRadius*2, RedIconeRadius*2);
    [self addSubview:badgeView];
}

- (void)hideBadgeOnItemIndex:(NSInteger)index{
    [self removeBadgeOnItemIndex:index];
}

- (void)removeBadgeOnItemIndex:(NSInteger)index{
    for (UIView *subView in self.subviews) {
        if (subView.tag == ViewTag + index) {
            [subView removeFromSuperview];
        }
    }
}

@end
