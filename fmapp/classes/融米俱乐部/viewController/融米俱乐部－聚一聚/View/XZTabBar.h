//
//  XZTabBar.h
//  fmapp
//
//  Created by admin on 16/6/30.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZTabBar : UIView
@property (nonatomic, copy) void(^blockTabBarBtn)(UIButton *);
@end
