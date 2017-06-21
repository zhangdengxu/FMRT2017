//
//  AppDelegate.h
//  fmapp  身份证  ／户口本  ／银行卡（钱）  ／银行流水近半年  ／收入证明
//
//  Created by lyh on 14-5-5.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#define  ShareAppDelegate ((AppDelegate* )[[UIApplication sharedApplication] delegate])

@interface AppDelegate : UIResponder <UIApplicationDelegate,JPUSHRegisterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) BOOL isMyAcount,isMainVC;

- (void)setTabRootControl;
- (void)createTabBarController;
/** 手势解锁 */
- (void)initWithUserAutoLogin;
- (void)initWithUserAutoLogin:(NSString *)user_id;

/** 检查app版本*/
-(void)checkAppVsrsion;

- (void)setTabBarIndex:(NSInteger)index;


@end
