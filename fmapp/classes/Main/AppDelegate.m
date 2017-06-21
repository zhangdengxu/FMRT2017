//
//  AppDelegate.m
//  fmapp
//
//  Created by 李 喻辉 on 14-5-5.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#define APP_KEY @"3Qon0WQ5Wz1RSmX2wpjR17Zt"

#import "AppDelegate.h"
#import "OpenUDID.h"
#import "FirstLeadViewController.h"
#import "FMTabBarController.h"
#import "LocalDataManagement.h"
//#import "InteractionViewController.h"
#import "HTTPClient+UserLoginOrRegister.h"
//#import "WLExploreViewController.h"
#import "FMSettings.h"
#import "GesturerViewController.h"
#import <AudioToolbox/AudioToolbox.h>
//#import "RoadMainViewController.h"
#import "UMSocial.h"
#import "ShareViewController.h"
//#import "ProjectDetailController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "LookAdsFromWebView.h"
#import "LookAgreementViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiObject.h"
#import "WXApiManager.h"
#import "Fm_Tools.h"
#import "GestureViewController.h"
#import "GestureVerifyViewController.h"
#import "PCCircleViewConst.h"
#import "XZScrollAdsViewController.h"
#import "NSDate+CategoryPre.h"
#import "YYMineViewController.h"
#import "UITabBar+FMRTTabBarBadge.h"
#import "FMRTHomeViewController.h"
#import "IQKeyboardManager.h"

#define SUPPORT_IOS8 1

@interface AppDelegate () <UITabBarControllerDelegate,FirstLeadViewControllerDelegate>
{
    NSTimer *myTimer;
    
}
@property (nonatomic, strong)  FMTabBarController *tabBar;
@property (nonatomic, assign)  BOOL isFullTime;
@property (nonatomic, assign)  NSInteger userNotificationCount;
@property (strong, nonatomic) UIWindow *gestureWindow;

@end

@implementation AppDelegate


- (void)setTabBarIndex:(NSInteger)index{
    self.tabBar.selectedIndex = 0;
}

- (FMTabBarController *)tabBar{
    if (!_tabBar) {
        _tabBar = [[FMTabBarController alloc]init];
        
        _tabBar.delegate = self;
    }
    return _tabBar;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    //由于开启了旋转屏, 再一进入程序的时候
    [application setStatusBarOrientation:UIInterfaceOrientationPortrait];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    self.isFullTime = NO;
    
    [Fm_Tools initUMSocialAndUMTrack];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIWindow *gestureWindow =[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.gestureWindow = gestureWindow;
    
    self.window.backgroundColor = [UIColor whiteColor];

    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(showCreateGestureViewController)
                                                 name: FMCreateGestureNotificationNew
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(appSuccessInGestureViewController)
                                                 name: KdefaultSuccessInGestureViewController
                                               object: nil];

    [CurrentUserInformation sharedCurrentUserInfo].statusNetWork = 0;
    /**
     *  创建rootViewController
     */ // 首次进入
    if ([FMSettings sharedSettings].openGuideView == nil) {
        [self createGuideScrollView];
    }else if (![[FMSettings sharedSettings].openGuideView isEqualToString:KAppCodeVersion] && [KDefaultNewAppRefresh isEqualToString:@"1"]) {
        
        [self createGuideScrollView];
        
    }else{
        // 获取存储的时间
        double timeInterval = [[NSUserDefaults standardUserDefaults] doubleForKey:@"saveTodayDate"];
        NSDate *date = [NSDate date];
        NSTimeInterval interVal = [date timeIntervalSince1970];
        double TimeDifference = interVal - timeInterval;
        // 判断是否是30天未打开App 30 * 24 * 60 * 60
        if (timeInterval && (TimeDifference > 30 * 24 * 60 * 60)) {
            // 大于30天未打开App,当程序启动时显示启动图片
            [self createGuideScrollView];
        }else {
            [self setTabRootControl];
        }
    }
    
    [WXApi registerApp:@"wx72172d3ee537c648" withDescription:@"demo 2.0"];
    
    [Fm_Tools registerModeForNotificationWithOptions:launchOptions With:self];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    return YES;
}

- (void)appSuccessInGestureViewController{

    if (![self.window isKeyWindow]) {
        [self.window becomeKeyWindow];
        [self.window makeKeyAndVisible];
//        [self.gestureWindow resignKeyWindow];
        self.gestureWindow.hidden = YES;
        
//        self.tabBar.selectedIndex = 0;
    }
}

//// 请求广告页的数据
//- (void)getAdsDataFromNetWork {
//    
//
//    [FMHTTPClient getPath:@"https://www.rongtuojinrong.com/rongtuoxinsoc/helpzhongxin/kaijipingnew" parameters:nil completion:^(WebAPIResponse *response) {
//
//        if (response.responseObject) {
//            if (response.code == WebAPIResponseCodeSuccess) {
//                if ([response.responseObject isKindOfClass:[NSDictionary class]]) {
//                    
//                    if ([response.responseObject objectForKey:@"data"]) {
//                        NSDictionary *data = response.responseObject[@"data"];
//                        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES) firstObject];
//                        NSString *filePath = [docPath stringByAppendingPathComponent:@"scrollAdsData.plist"];
//                        [data writeToFile:filePath atomically:YES];
//                    }
//                }
//            }else {
//                NSFileManager *fileManager = [NSFileManager defaultManager];
//                NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) firstObject];
//                NSString *filePath = [docPath stringByAppendingPathComponent:@"scrollAdsData.plist"];
//                [fileManager removeItemAtPath:filePath error:nil];
//            }
//        }
//    }];
//}

-(void)showCreateGestureViewController{
    GestureViewController *gestureVc = [[GestureViewController alloc] init];
    gestureVc.type = GestureViewControllerTypeSetting;
    FMShareSetting.agreeGestures=YES;
    FMWeakSelf;
    [self.window.rootViewController presentViewController:gestureVc animated:NO completion:^{
        
        if(weakSelf.isMyAcount){
            weakSelf.isMyAcount = NO;
            weakSelf.tabBar.selectedIndex = 3;
        }
    }];
}

-(void)presentFigureUnLuckViewController{
    
    if ([[PCCircleViewConst getGestureWithKey:gestureFinalSaveKey] length]) {
        GestureViewController *gestureVc = [[GestureViewController alloc] init];
        [gestureVc setType:GestureViewControllerTypeLogin];
       
        self.gestureWindow.rootViewController = gestureVc;
        [self.gestureWindow makeKeyAndVisible];
        
    }else{
        GestureViewController *gestureVc = [[GestureViewController alloc] init];
        [gestureVc setType:GestureViewControllerTypeSetting];

        self.window.rootViewController = gestureVc;
        [self.window makeKeyAndVisible];
    }
}

-(void)presentFigureUnLuckViewController:(NSString *)user_id{
    [[NSUserDefaults standardUserDefaults] setObject:user_id forKey:@"zhuceUserId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    GestureViewController *gestureVc = [[GestureViewController alloc] init];
    [gestureVc setType:GestureViewControllerTypeSetting];
     FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:gestureVc];

    [self.window.rootViewController presentViewController:navController animated:NO completion:nil];
}

- (void)createGuideScrollView {
    
    FirstLeadViewController * viewController = [[FirstLeadViewController alloc]init];
    viewController.delegate = self;
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
//    // 请求广告数据并存储
//    [self getAdsDataFromNetWork];
}

// 后台30天或者是首次启动App
-(void)FirstLeadViewControllerTurnToMainView:(FirstLeadViewController *)viewController{
    [self createMainController:NO];
    [self initWithUserAutoLogin]; // 手势解锁
}

// 创建根控制器和显示广告页
-(void)setTabRootControl{
    [self createMainController:YES];
    [self DisplayAdvertisingPage];
}

- (void)createTabBarController{
    FMShareSetting.openGuideView=KAppCodeVersion;
    [self.gestureWindow setHidden:YES];
    self.window.rootViewController = self.tabBar;
    [self.window makeKeyAndVisible];
}

// 创建根控制器
- (void)createMainController:(BOOL)makeKeyVisible {
    FMShareSetting.openGuideView=KAppCodeVersion;

    self.window.rootViewController = self.tabBar;
    if (makeKeyVisible) {
        [self.window makeKeyAndVisible];
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    FMNavigationController * current = (FMNavigationController *)viewController;
    if([current.topViewController isKindOfClass:[YYMineViewController class]]){
        if(![CurrentUserInformation sharedCurrentUserInfo].userLoginState){
            FMNavigationController * nav = [[FMNavigationController alloc]initWithRootViewController:[[LoginController alloc]init]];
            FMWeakSelf;
            [tabBarController presentViewController:nav animated:YES completion:^{
                weakSelf.isMyAcount = YES;
            }];
            return NO;
        }else{
            [self.tabBar.tabBar hideBadgeOnItemIndex:3];
            self.isMyAcount = NO;
            return YES;
        }
    }else{
        if([current.topViewController isKindOfClass:[FMRTHomeViewController class]]){
            self.isMainVC = YES;
        }
        self.isMyAcount = NO;
        return YES;
    }
}

// 显示广告页:不大于30天
- (void)DisplayAdvertisingPage {
    
    // 获取存储的时间
    double timeInterval = [[NSUserDefaults standardUserDefaults] doubleForKey:@"saveTodayDate"];
    NSDate *date = [NSDate date];
    NSTimeInterval interVal = [date timeIntervalSince1970];
    double TimeDifference = interVal - timeInterval;
    // 判断是否是30天未打开App 30 * 24 * 60 * 60
    if (!timeInterval || TimeDifference < 30 * 24 * 60 * 60){
        // 获取今天的时间
        NSString *todayTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"savePresentDateOther"];
        // 存储当日成功显示广告页时间
        NSString *todayYMD = [date retCurrentdateWithYYYY_MM_DD];
        // 有存储今天成功的时间且时间大于1天
        if (!(todayTime && [todayTime isEqualToString:todayYMD])) {
            
            [FMHTTPClient getPath:@"https://www.rongtuojinrong.com/rongtuoxinsoc/helpzhongxin/kaijipingnew" parameters:nil completion:^(WebAPIResponse *response) {
//                NSLog(@"我是开机广告页数据============================");
                if (response.responseObject) {
                    if (response.code == WebAPIResponseCodeSuccess) {
                        if ([response.responseObject isKindOfClass:[NSDictionary class]]) {
                            
                            if ([response.responseObject objectForKey:@"data"]) {
                                NSDictionary *dict = response.responseObject[@"data"];
                                if (dict) { // 判断缓存数据
                                    XZScrollAdsViewController *scrollAds = [[XZScrollAdsViewController alloc] init];
                                    [scrollAds AnalyticalDataWithDict:dict];
                                    FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:scrollAds];
                                    scrollAds.view.backgroundColor = [UIColor whiteColor];
                                    [self.window.rootViewController presentViewController:navController animated:NO completion:^{
                                        [[NSUserDefaults standardUserDefaults] setObject:todayYMD forKey:@"savePresentDateOther"];
                                        self.isMainVC = YES;
                                    }];
                                    self.window.rootViewController.modalPresentationStyle = UIModalPresentationPageSheet;
                                    self.window.rootViewController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
                                }
                            }
                        }
                    }
                    else { // 手势解锁
                        [self initWithUserAutoLogin];
                    }
                }
                else { // 手势解锁
                    [self initWithUserAutoLogin];
                }
            }];
            
        }
        else { // 手势解锁
            [self initWithUserAutoLogin];
        }
    }
    else { // 手势解锁
        [self initWithUserAutoLogin];
    }

    
//    // 获取存储的时间
//    double timeInterval = [[NSUserDefaults standardUserDefaults] doubleForKey:@"saveTodayDate"];
//    NSDate *date = [NSDate date];
//    NSTimeInterval interVal = [date timeIntervalSince1970];
//    double TimeDifference = interVal - timeInterval;
//    //    NSLog(@"timeInterval:%f-------TimeDifference:%f",timeInterval,TimeDifference);
//    // 判断是否是30天未打开App 30 * 24 * 60 * 60
//    if (!timeInterval || TimeDifference < 30 * 24 * 60 * 60){
//        // 不是首次进入，请求广告业的数据
//        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES) firstObject];
//        NSString *filePath = [docPath stringByAppendingPathComponent:@"scrollAdsData.plist"];
//        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
//        // 获取今天的时间
//        NSString *todayTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"savePresentDateOther"];
//        // 存储当日成功显示广告页时间
//        NSString *todayYMD = [date retCurrentdateWithYYYY_MM_DD];
//        // 有存储今天成功的时间且时间大于1天
//        if (!(todayTime && [todayTime isEqualToString:todayYMD])) {
//            if (dict) { // 判断缓存数据
//                XZScrollAdsViewController *scrollAds = [[XZScrollAdsViewController alloc] init];
//                [scrollAds AnalyticalDataWithDict:dict];
//                FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:scrollAds];
//                scrollAds.view.backgroundColor = [UIColor whiteColor];
//                [self.window.rootViewController presentViewController:navController animated:NO completion:^{
//                    [[NSUserDefaults standardUserDefaults] setObject:todayYMD forKey:@"savePresentDateOther"];
//                    self.isMainVC = YES;
//                }];
//                self.window.rootViewController.modalPresentationStyle = UIModalPresentationPageSheet;
//                self.window.rootViewController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
//            }else {
//                [self initWithUserAutoLogin];
//            }
//        }
//        else { // 显示过广告页，直接加载手势页
//            [self initWithUserAutoLogin];
//        }
//        // 请求广告数据并存储
//        [self getAdsDataFromNetWork];
//    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{

    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        }];
    }else if ([url.host isEqualToString:@"platformapi"]){
        //支付宝钱包快登授权返回authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
        }];
    }else if([UMSocialSnsService handleOpenURL:url])
    {        return  YES;
    }else if([WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]])
    {
        return  YES;
    }else{

        if (url.absoluteString.length > 5) {
            NSString * firstString = [url.absoluteString substringToIndex:4];
            if ([firstString isEqualToString:@"rtjr"]) {
                
                [self dealWithTheShareMessageUrl:url];
            }
        }
    }
    return YES;
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
//    // 设置支付方式为NO
    
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //            NSLog(@"%@",resultDic);
        }];
    }else if ([url.host isEqualToString:@"platformapi"]){
        //支付宝钱包快登授权返回authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
         }];
    }else if([UMSocialSnsService handleOpenURL:url])
    {
        return  YES;
    }else if([WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]])
    {
        
        return  YES;
    }else{
        
        if (url.absoluteString.length > 5) {
            NSString * firstString = [url.absoluteString substringToIndex:4];
            if ([firstString isEqualToString:@"rtjr"]) {
                
                [self dealWithTheShareMessageUrl:url];
            }
        }
        return YES;
    }
    return YES;
}

- (void)dealWithTheShareMessageUrl:(NSURL *)url{
    
    NSDictionary *shareDic = [Fm_Tools stringCutFromAppdelegateForShareMessageWith:[NSString stringWithFormat:@"%@",url]];
    
    if ([shareDic objectForKey:@"flag"]) {

        if ([[shareDic objectForKey:@"flag"] integerValue] >20 ) {
            self.tabBar.selectedIndex = 2;
        }else{
            self.tabBar.selectedIndex = 0;
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:FMShareoOpenUrlNotification object:shareDic];
        });
    }
}

-(void)dealAppNotification:(NSDictionary* )apsDic{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    if (![self.window.rootViewController isKindOfClass:[FMTabBarController class]]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.userNotificationCount ++;
            [[NSNotificationCenter defaultCenter] postNotificationName:FMReceivePushNotification object:apsDic];
        });
    }else{
        self.userNotificationCount ++;
        [[NSNotificationCenter defaultCenter] postNotificationName:FMReceivePushNotification object:apsDic];
    }
    
//    NSString *type=StringForKeyInUnserializedJSONDic(apsDic, @"type");
//    if([type isEqualToString:@"6"]){
//        
//        NSLog(@"1234567890");
    
//        //活动积分页面；
//        FMTabBarController * tabbar = (FMTabBarController *)self.window.rootViewController;
//        [tabbar.tabBar hideBadgeOnItemIndex:3];
//    }
}

- (void)applicationWillResignActive:(UIApplication *)application{

}

//已经进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application{
    self.isFullTime = NO;
    
    //    申请更长时间的后台运行
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    myTimer = [NSTimer scheduledTimerWithTimeInterval:180.0 target:self selector:@selector(scrollTimer) userInfo:nil repeats:NO];
    
    // 存储当前时间
    NSDate *date = [NSDate date];
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    [[NSUserDefaults standardUserDefaults] setDouble:timeInterval forKey:@"saveTodayDate"];
}

-(void)scrollTimer{
    self.isFullTime = YES;
}

//将要进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application{
    
    [myTimer invalidate];
    myTimer = nil;
    
    if (self.userNotificationCount > 0) {
        self.userNotificationCount = 0;
    }else{
        if (self.isFullTime) { // 进入后台3分钟
            //        [self initWithUserAutoLogin];
            
            // 获取存储的时间
            double timeInterval = [[NSUserDefaults standardUserDefaults] doubleForKey:@"saveTodayDate"];
            NSDate *date = [NSDate date];
            NSTimeInterval interVal = [date timeIntervalSince1970];
            double TimeDifference = interVal - timeInterval;
            // 判断是否是30天未打开App 30 * 24 * 60 * 60
            if (timeInterval && (TimeDifference > 30 * 24 * 60 * 60)) {
                // 大于30天未打开App,当程序启动时显示启动图片
                [self createGuideScrollView];
            }else {
                // 广告
                [self DisplayAdvertisingPage];
            }
        }
    }
    
    self.isFullTime = NO;
    //设置状态栏
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [self checkAppVsrsion];
}

- (void)initWithUserAutoLogin {
    CurrentUserInformation * userInfo = [CurrentUserInformation sharedCurrentUserInfo];
    if (!(userInfo.userName.length > 0)) {
        [userInfo userFromArachiver];
        if (userInfo.userName.length > 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:FMUserLoginNotification
                                                                object:nil];//触发登录通知
        }
    }
    LocalDataManagement *dataManagement = [[LocalDataManagement alloc] init];
    if ([dataManagement getUserFileWithUserFileType:CYHUserLoginInfoFile]) {
        //用户登录文件存在
        if (FMShareSetting.agreeGestures) {
            [self presentFigureUnLuckViewController];
        }else{
            //            [[CurrentUserInformation sharedCurrentUserInfo]checkFigureJudge];
        }
    }
}

- (void)initWithUserAutoLogin:(NSString *)user_id {
    
    CurrentUserInformation * userInfo = [CurrentUserInformation sharedCurrentUserInfo];
    
    if (!(userInfo.userName.length > 0)) {
        [userInfo userFromArachiver];
        
        if (userInfo.userName.length > 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:FMUserLoginNotification
                                                                object:nil];//触发登录通知
        }
    }
    LocalDataManagement *dataManagement = [[LocalDataManagement alloc] init];
    if ([dataManagement getUserFileWithUserFileType:CYHUserLoginInfoFile]) {
        //用户登录文件存在
        [self presentFigureUnLuckViewController:user_id];
    }
}

//appDelegate进入活跃状态
- (void)applicationDidBecomeActive:(UIApplication *)application{
    // 优商城
    if (FMShareSetting.backNumber == 3) {
        // 直接从支付宝或者微信点左上角返回
        [[NSNotificationCenter defaultCenter] postNotificationName:KBackFromAlipayOrWechat object:nil userInfo:nil];
    }
    // 积分支付
    if (FMShareSetting.backNumberCoin == 3) {
        // 直接从支付宝或者微信点左上角返回
        [[NSNotificationCenter defaultCenter] postNotificationName:KBackFromAlipayOrWechatCoinPay object:nil userInfo:nil];
    }
}

//qpp退出
- (void)applicationWillTerminate:(UIApplication *)application{
    [myTimer invalidate];
    myTimer = nil;
}

#pragma mark -选项卡栏
#if SUPPORT_IOS8
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [application registerForRemoteNotifications];
}
#endif

#pragma mark -注册通知
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [JPUSHService registerDeviceToken:deviceToken];
}

//获取到远程通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    [JPUSHService handleRemoteNotification:userInfo];
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//震动
    
    [self dealAppNotification:userInfo];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void(^)(UIBackgroundFetchResult))completionHandler {
    
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    [self dealAppNotification:userInfo];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==10000) {
        NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/us/app/rong-tuo-jin-rong/id982765411?l=zh&ls=1&mt=8"];
        [[UIApplication sharedApplication]openURL:url];
        
    }
    //创建手势解锁
    if (alertView.tag == 10099) {
        GestureViewController *gestureVc = [[GestureViewController alloc] init];
        gestureVc.type = GestureViewControllerTypeSetting;

        [self.window.rootViewController presentViewController:gestureVc animated:YES completion:nil];
    }
}

#pragma mark ---- 是否支持横屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    
    return UIInterfaceOrientationMaskPortrait;
}


/*
- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier{
    
    if ([extensionPointIdentifier isEqualToString:@"com.apple.keyboard-service"]) {
        return NO;
    }
    return YES;
}
 */

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }else {
        // 判断为本地通知
        
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    [self dealAppNotification:userInfo];
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }else {
        // 判断为本地通知
    }
    
    completionHandler();  // 系统要求执行这个方法
    [self dealAppNotification:userInfo];
}
#endif

-(void)checkAppVsrsion;{
    NSString * enterpriseVersion = kRecommendPersonNamePhoneNumber;
    
    if (enterpriseVersion.length > 1) {
        //此情况为企业版，无需判断版本。
    }else{
        if ([[CurrentUserInformation sharedCurrentUserInfo].banbenhao integerValue] > [KAppCodeVersion integerValue]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新版本更新，请前往更新！" delegate:self cancelButtonTitle:@"更新" otherButtonTitles:nil, nil];
            
            alert.tag = 10000;
            [alert show];
        }
    }
}


@end

