//
//  XZActivityTabBar.h
//  fmapp
//
//  Created by admin on 16/7/1.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XZActivityModel;
@interface XZActivityTabBar : UIView
@property (nonatomic, copy) void(^blockTabBarBtn)(UIButton *);
@property (nonatomic, strong) XZActivityModel *activityModel;
@property (nonatomic, strong) NSString *praiseNumber;
@end
