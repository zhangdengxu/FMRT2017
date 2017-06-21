//
//  ThemeManager.m
//  FM_CZFW
//
//  Created by liyuhui on 14-4-1.
//  Copyright (c) 2013年 ETelecom. All rights reserved.
//

#import "ThemeManager.h"
#import "FMNightSkin.h"
#import "AppDelegate.h"
#import "FMSolidSkin.h"


@implementation ThemeManager


+ (ThemeManager *)sharedThemeManager
{
    static ThemeManager *_themeManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _themeManager = [[ThemeManager alloc] init];
    });
    
    return _themeManager;
}

- (id)init
{
    self = [super init];
    if (self){
        self.skin = [[FMDefaultSkin alloc] init];
    }
    return self;
}
- (FMDefaultSkin* )createSkinById:(NSInteger)skinId
{
    skinId=4;

    //更换主题
    switch (skinId) {
            
        case 2:
            return [[FMSolidSkin alloc] initWithColor:[UIColor colorWithRed:252.0/255.0
                                                                     green:111.0/255.0
                                                                      blue:160.0/255.0
                                                                     alpha:1.0]];
            break;
        case 3:
            return [[FMSolidSkin alloc] initWithColor:[UIColor colorWithRed:0/255.0f
                                                                       green:213/255.0f
                                                                        blue:161/255.0f
                                                                       alpha:1.0]];
            break;
        case 4:
            return [[FMSolidSkin alloc] initWithColor:[UIColor colorWithRed:0.2 green:0.68 blue:0.92 alpha:1]];
        case 5:
            return [[FMNightSkin alloc] init];
            
        default:
            break;
    }
    return  [[FMDefaultSkin alloc] init];
}
- (void)applySkin:(FMDefaultSkin* )skin
{
    self.skin = skin;
    UIViewController *rootViewController = ShareAppDelegate.window.rootViewController;
    
    if(HUISystemVersionAboveOrIs(kHUISystemVersion_7_0)){
        //设置状态栏
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [[UIApplication sharedApplication] setStatusBarStyle:[skin statusbarStyle]];
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
    
    ShareAppDelegate.window.rootViewController = nil;
    
    //
    [self applySkinToTabBar:nil];
    [self applySkinToNavigationBar:nil];
    [self applySkinToTableView:nil];
    
    ShareAppDelegate.window.rootViewController = rootViewController;
    
    
    
}
- (void)applySkinToTabBar:(UITabBar *)tabBarOrAppearance {
    if (!tabBarOrAppearance) {
        tabBarOrAppearance = [UITabBar appearance];
    }
    
    //设置背景
    UIImage* img = createImageWithColor([UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1]);
    if(img){
        [tabBarOrAppearance setBackgroundImage:img];
        
    }else{
        UIColor* color = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
        if (color) {
            
            if(HUISystemVersionBelow(kHUISystemVersion_7_0)){
                tabBarOrAppearance.tintColor = color;
            }else{
                
                tabBarOrAppearance.barTintColor = color;
            }
        }
    }
    //title颜色
    
    NSShadow *shadow = [NSShadow new];
    [shadow setShadowOffset: CGSizeMake(0.0f, 0.0f)];
    
    [[UITabBarItem appearance] setTitleTextAttributes:
     @{NSFontAttributeName: kTableBarFontSize,
       NSShadowAttributeName: shadow,
       NSForegroundColorAttributeName: [self.skin tabBarTitleColor]}
                                             forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:
     @{ NSFontAttributeName: kTableBarFontSize,
        NSShadowAttributeName: shadow,
        NSForegroundColorAttributeName: [self.skin tabBarSelectColor]}
                                             forState:UIControlStateSelected];
    
    //title位置
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0.0, -2.0)];
}

- (void)applySkinToNavigationBar:(UINavigationBar *)navigationBarOrAppearance withColor:(UIColor *)colors
{
    if (!navigationBarOrAppearance) {
        navigationBarOrAppearance = [UINavigationBar appearance];
    }
    
    
    UIImage *img = createImageWithColor(colors);
    if(img){
        if(HUISystemVersionBelow(kHUISystemVersion_7_0)){
            [navigationBarOrAppearance setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
        }else{
            [navigationBarOrAppearance setBackgroundImage:img
                                           forBarPosition:UIBarPositionTopAttached
                                               barMetrics:UIBarMetricsDefault];
            
        }
        navigationBarOrAppearance.shadowImage = createImageWithColor(XZColor(196, 200, 204));
        
    }else{
        
        
        if (colors) {
            if(HUISystemVersionBelow(kHUISystemVersion_7_0)){
                navigationBarOrAppearance.tintColor = colors;
            }else{
                navigationBarOrAppearance.barTintColor = colors;
            }
            
        }
    }
    //设置返回按钮颜色
    if(HUISystemVersionAboveOrIs(kHUISystemVersion_7_0)){
        [navigationBarOrAppearance setTintColor:[self.skin navigationTextColor]];
    }
    
}

- (void)applySkinToNavigationBar:(UINavigationBar *)navigationBarOrAppearance withColor:(UIColor *)colors shadowColor:(UIColor *)shadowColor
{
    if (!navigationBarOrAppearance) {
        navigationBarOrAppearance = [UINavigationBar appearance];
    }
    
    
    UIImage *img = createImageWithColor(colors);
    if(img){
        if(HUISystemVersionBelow(kHUISystemVersion_7_0)){
            [navigationBarOrAppearance setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
        }else{
            [navigationBarOrAppearance setBackgroundImage:img
                                           forBarPosition:UIBarPositionTopAttached
                                               barMetrics:UIBarMetricsDefault];
            
        }
        
        navigationBarOrAppearance.shadowImage = createImageWithColor(shadowColor);
        
    }else{

        
        if (colors) {
            if(HUISystemVersionBelow(kHUISystemVersion_7_0)){
                navigationBarOrAppearance.tintColor = colors;
            }else{
                navigationBarOrAppearance.barTintColor = colors;
            }
            
        }
    }
    //设置返回按钮颜色
    if(HUISystemVersionAboveOrIs(kHUISystemVersion_7_0)){
        [navigationBarOrAppearance setTintColor:[self.skin navigationTextColor]];
    }
    
//    if ([navigationBarOrAppearance respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
//        NSArray *list = navigationBarOrAppearance.subviews;
//        for (id obj in list) {
//            if ([obj isKindOfClass:[UIImageView class]]) {
//                UIImageView *imageView=(UIImageView *)obj;
//                NSArray *list2=imageView.subviews;
//                for (id obj2 in list2) {
//                    if ([obj2 isKindOfClass:[UIImageView class]]) {
//                        UIImageView *imageView2=(UIImageView *)obj2;
//                        imageView2.hidden=YES;
//                    }
//                }
//            }
//        }
//    }
    
}

// 给导航栏设置背景图
- (void)applySkinToNavigationBar:(UINavigationBar *)navigationBarOrAppearance withImage:(NSString *)image
{
    if (!navigationBarOrAppearance) {
        navigationBarOrAppearance = [UINavigationBar appearance];
    }
    
    UIImage *img = [UIImage imageNamed:image];
    if(img){
        if(HUISystemVersionBelow(kHUISystemVersion_7_0)){
            [navigationBarOrAppearance setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
        }else{
            [navigationBarOrAppearance setBackgroundImage:img
                                           forBarPosition:UIBarPositionTopAttached
                                               barMetrics:UIBarMetricsDefault];
        }
//        navigationBarOrAppearance.shadowImage = [UIImage new];
        navigationBarOrAppearance.shadowImage = createImageWithColor([UIColor clearColor]);
//        navigationBarOrAppearance.barStyle = UIBaselineAdjustmentNone;
    }
}

- (void)applySkinToNavigationBar:(UINavigationBar *)navigationBarOrAppearance {
    if (!navigationBarOrAppearance) {
        navigationBarOrAppearance = [UINavigationBar appearance];
    }

    UIImage *img = createImageWithColor([UIColor whiteColor]);
    if(img){
        if(HUISystemVersionBelow(kHUISystemVersion_7_0)){
            [navigationBarOrAppearance setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
        }else{
            [navigationBarOrAppearance setBackgroundImage:img
                                           forBarPosition:UIBarPositionTopAttached
                                               barMetrics:UIBarMetricsDefault];

        }
    }else{
        UIColor* color = [UIColor whiteColor];
        if (color) {
            if(HUISystemVersionBelow(kHUISystemVersion_7_0)){
                navigationBarOrAppearance.tintColor = color;
            }else{                
                navigationBarOrAppearance.barTintColor = color;
            }
            
        }
    }
    //设置返回按钮颜色
    if(HUISystemVersionAboveOrIs(kHUISystemVersion_7_0)){
        [navigationBarOrAppearance setTintColor:[self.skin navigationTextColor]];
    }

}

- (void)applySkinToTableView:(UITableView *)tableView {

    UIColor *backgroundColor = [self.skin backgroundColor];
    if (backgroundColor) {
        [tableView setBackgroundColor:backgroundColor];
        [tableView setBackgroundView:[[UIView alloc] initWithFrame:tableView.backgroundView.frame]];
    }
}

@end
