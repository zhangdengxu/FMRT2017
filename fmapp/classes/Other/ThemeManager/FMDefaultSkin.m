//
//  FMDefaultSkin.m
//  fmapp
//
//  Created by 李 喻辉 on 14-5-8.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#import "FMDefaultSkin.h"

@implementation FMDefaultSkin

- (id)init
{
    self = [super init];
    if (self){
        self.nightMode = FALSE;
    }
    return self;
}
- (UIStatusBarStyle)statusbarStyle
{
    return UIStatusBarStyleDefault;
}
- (UIColor *)backgroundColor
{
    return [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0];
}
- (UIColor *)scrollViewBackgroudColor
{
    return KProjectBackGroundViewColor;;
}
- (UIColor *)buttonHighlightColor
{
    return KButtonBackgroundImageColor;
}
- (UIColor *)cellSelectedColor
{
    return KTableViewCellSelectedColor;
}
- (UIColor *)baseTintColor
{
   /*
    return [UIColor colorWithRed:0/255.0f
                           green:213/255.0f
                            blue:161/255.0f
                           alpha:1.0];
    */
    return [HXColor colorWithHexString:@"#ffffff"];
    
    //return [UIColor colorWithRed:0.18 green:0.56 blue:0.89 alpha:1];
    /*
    return [UIColor colorWithRed:63.0f/255.0f
                           green:122.0f/255.0f
                            blue:228.0f/255.0f
                           alpha:1.0];
    */ 

}
- (UIColor *)textColor
{
    return KContentTextColor;
}
- (UIColor *)sepratorColor
{
    return KSepLineColorSetup;
}
- (UIColor *)navigationTextColor
{
    return [UIColor colorWithRed:131.0f/255.0f
                           green:137.0f/255.0f
                            blue:145.0f/255.0f
                           alpha:1.0];
    
    
//    return [HXColor colorWithHexString:@"#333333"];
}

- (UIColor *)navigationBarTintColor
{
    return [UIColor whiteColor];
    /*
    return [UIColor colorWithRed:45.0f/255.0f
                           green:188.0f/255.0f
                            blue:150.0f/255.0f
                           alpha:1.0];}
     */
}

- (UIColor *)navigationBarNewTintColor{

    return [UIColor colorWithRed:14.0f/255.0f
                           green:93.0f/255.0f
                            blue:122.0f/255.0f
                           alpha:1.0];
}
- (UIImage *)navigationBarBackgroundImage
{
    if(HUISystemVersionBelow(kHUISystemVersion_7_0)){
        return [UIImage imageNamed:@"NavigationBar.png"];
        //return createImageWithColor([self navigationBarTintColor]);
    }
    return nil;
}


- (UIColor *)tabBarTitleColor
{
    return [UIColor colorWithRed:150.0f/255.0f
                           green:150.0f/255.0f
                            blue:150.0f/255.0f
                           alpha:1.0];
}
- (UIColor *)tabBarSelectColor
{
   return  [UIColor colorWithRed:0.18 green:0.56 blue:0.89 alpha:1];
}
- (UIColor *)tabBarTintColor
{
    return [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1];
}
- (UIImage *)tabBarBackgroundImage
{
    
    
    if(HUISystemVersionBelow(kHUISystemVersion_8_0)){
        
        return createImageWithColor([UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1]);
    }
    return nil;
    
//    return [UIImage imageNamed:@"TabBar.png"];
}
@end
