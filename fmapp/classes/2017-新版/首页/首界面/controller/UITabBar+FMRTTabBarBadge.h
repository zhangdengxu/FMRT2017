//
//  UITabBar+FMRTTabBarBadge.h
//  fmapp
//
//  Created by apple on 2016/12/20.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (FMRTTabBarBadge)

- (void)showBadgeOnItemIndex:(NSInteger)index;

- (void)hideBadgeOnItemIndex:(NSInteger)index;

@end
