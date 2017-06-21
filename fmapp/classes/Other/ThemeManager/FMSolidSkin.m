//
//  FMSolidSkin.m
//  fmapp
//
//  Created by 李 喻辉 on 14-8-14.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#import "FMSolidSkin.h"

@interface FMSolidSkin ()

@property (nonatomic,strong) UIColor         *color;

@end

@implementation FMSolidSkin

- (id)initWithColor:(UIColor *)tintColor
{
    self = [super init];
    if (self){
        self.nightMode = FALSE;
        self.color = tintColor;
    }
    return self;
}

- (UIStatusBarStyle)statusbarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UIColor *)backgroundColor
{
    return [UIColor colorWithRed:1.0f
                           green:1.0f
                            blue:1.0f
                           alpha:1.0];
}
- (UIColor *)cellSelectedColor
{
    return [self backgroundColor];
}
- (UIColor *)baseTintColor
{
//    return [UIColor colorWithRed:0.18 green:0.56 blue:0.89 alpha:1];
    return [UIColor colorWithRed:7/255.0f green:64/255.0f blue:143/255.0f alpha:1];
}

- (UIColor *)navigationTextColor
{
    return [UIColor whiteColor];
}

- (UIColor *)navigationBarTintColor
{
    return [self baseTintColor];
}

- (UIColor *)navigationBarNewTintColor{
    
    return [UIColor colorWithRed:14/255.0f green:93/255.0f blue:210/255.0f alpha:1];
}

- (UIImage *)navigationBarBackgroundImage
{
    
    if(HUISystemVersionBelow(kHUISystemVersion_7_0)){
        return createImageWithColor(self.color);
    }
    
    return nil;
}
- (UIColor *)tabBarSelectColor
{
    
    return [UIColor colorWithRed:0.18 green:0.56 blue:0.89 alpha:1];
    
}
@end
