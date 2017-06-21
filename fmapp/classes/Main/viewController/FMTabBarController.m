//
//  FMTabBarController.h
//  fmapp
//
//  Created by 李 喻辉 on 14-5-8.
//  Copyright (c) 2014年 yk. All rights reserved.
//
#import "FMTabBarController.h"
#import "FMNavigationController.h"
//#import "RoadMainViewController.h"
//#import "InteractionViewController.h"
//#import "WLExploreViewController.h"
#import "FMRTProjectViewController.h"
#import "FMSettings.h"
#import "XZScrollAdsViewController.h"
#import "UITabBar+FMRTTabBarBadge.h"
#import "XZDiscoverController.h" // 发现
#import "FMRTHomeViewController.h" // 首页
#import "YYMineViewController.h"
#import "AppDelegate.h"

@interface FMTabBarController ()<UIAlertViewDelegate>

@end

@implementation FMTabBarController


- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self addAllChildViewController];
    
    [self getNetWorkWithNET];
    
   
    
}
//暂停网络服务的方法
-(void)getNetWorkWithNET
{
    [FMHTTPClient getPath:@"https://www.rongtuojinrong.com/rongtuoxinsoc/helpzhongxin/appzantingjiekou" parameters:nil completion:^(WebAPIResponse *response) {
        
        if (response.code == WebAPIResponseCodeSuccess) {
            NSArray * data = response.responseObject[@"data"];
            if (![data isMemberOfClass:[NSNull class]]) {
                if (data.count > 0) {
                    NSDictionary * dict = data[0];
                    if (![dict isMemberOfClass:[NSNull class]]) {
                        NSString * shifou = dict[@"shifou"];
                        if (![shifou isMemberOfClass:[NSNull class]]) {
                            if ([shifou integerValue] == 1) {
                                [self alertInfoWithTitle:dict[@"biaoti"] withContent:dict[@"shuoming"]];
                            }
                        }
                    }
                    
                    
                }
            }
        }
    }];
}
-(void)alertInfoWithTitle:(NSString *)title withContent:(NSString *)content
{
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:title message:content delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
    [alertView show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0);
{
      exit(0);
}

-(void)addAllChildViewController{
    
    FMRTHomeViewController * roadMain = [[FMRTHomeViewController alloc]init];
    [self setViewController:roadMain image:@"首页_灰_1702" selectImage:@"首页_蓝_1702"  title:@"首页"];
    
    FMRTProjectViewController *projectVC = [[FMRTProjectViewController alloc]init];
    [self setViewController:projectVC image:@"首页_项目-灰_1702" selectImage:@"首页_项目-蓝_1702"  title:@"项目"];
    
    XZDiscoverController *foundVC = [[XZDiscoverController alloc]init];
    [self setViewController:foundVC image:@"首页_发现-灰_1702" selectImage:@"首页_发现-蓝_1702"  title:@"发现"];
    
    YYMineViewController *mineVC = [[YYMineViewController alloc]init];
    [self setViewController:mineVC image:@"首页_我的-灰_1702" selectImage:@"首页_我的-蓝_1702" title:@"我的"];
}

-(void)setViewController:(UIViewController *)childVc image:(NSString *)image selectImage:(NSString *)selectImage title:(NSString *)title{
    
    childVc.title = title;
    UIImage * imageNormal = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.image = imageNormal;
    
    UIImage * imageSelect = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = imageSelect;
    
    NSMutableDictionary * selectTextAttrs=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[UIColor colorWithRed:(7/255.0) green:(64/255.0) blue:(143/255.0) alpha:1],NSForegroundColorAttributeName, nil];
    
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    //设置文字样式
    
    FMNavigationController * nav = [[FMNavigationController alloc]initWithRootViewController:childVc];
    [self addChildViewController:nav];
}

-(BOOL)shouldAutorotate{
    return [self.selectedViewController shouldAutorotate];
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.selectedViewController supportedInterfaceOrientations];
}


- (void)viewWillAppear:(BOOL)animated{
    
    [self becomeFirstResponder];
    [super viewWillAppear:animated];
     [ShareAppDelegate checkAppVsrsion];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [self becomeFirstResponder];
    [super viewDidAppear:animated];
}
- (BOOL)canBecomeFirstResponder{
    return YES;
}

@end
