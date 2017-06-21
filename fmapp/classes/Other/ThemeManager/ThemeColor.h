//
//  ThemeColor.h
//  FM_CZFW
//
//  界面相关配色信息宏定义
//
//  Created by liyuhui on 14-4-1.
//  Copyright (c) 2013年 ETelecom. All rights reserved.
//

#ifndef CZFW_ThemeColor_h
#define CZFW_ThemeColor_h

#define KBarColor                    [UIColor colorWithRed:51.0/255.0 green:181.0/255.0 blue:230.0/255.0 alpha:1.0]


#define HUIRGBColor(r, g, b, a)      [UIColor colorWithRed:(r)/255.00 green:(g)/255.00 blue:(b)/255.00 alpha:(a)]

//文字颜色
#define kColorTextColorClay                 [UIColor colorWithRed:127.0/255.0 green:125.0/255.0 blue:127.0/255.0 alpha:1.0]
#define kColorTextColorDarkClay             [UIColor colorWithRed:74.00/255.00 green:54.00/255.00 blue:33.00/255.00 alpha:1.0]

//标题文本颜色
#define KTitleTextColor                     [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0]

//内容文本颜色
#define KContentTextColor                   [UIColor colorWithRed:65/255.0f green:65/255.0f blue:65/255.0f alpha:1.0f]

//互动文本颜色
#define KMessageTextColor                   KDefaultOrNightTextColor
//[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f]

//禁止文本颜色
#define KDisableTextColor                  [UIColor colorWithRed:172/255.0f green:172/255.0f blue:172/255.0f alpha:1.0f]

//边框颜色设置
#define KBorderColorSetup                  [UIColor colorWithRed:226/255.0f green:226/255.0f blue:226/255.0f alpha:1.0f]


//分割线颜色设置
#define KSepLineColorSetup                 [UIColor colorWithRed:226/255.0f green:226/255.0f blue:226/255.0f alpha:1.0f]

//按键高亮的显示颜色
#define KButtonBackgroundImageColor         [UIColor colorWithRed:240/255.0f green:239/255.0f blue:240/255.0f alpha:1]

//项目背景色
#define KProjectBackGroundViewColor         [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1]

///TableViewCell 选中的颜色
#define KTableViewCellSelectedColor         [UIColor colorWithRed:221/255.0f green:223/255.0f blue:232/255.0f alpha:1]


///导航栏右侧头部按键颜色——白色
#define KRightBarButtonItemColor            [UIColor whiteColor]

///TableViewCell的背景颜色
#define KTableViewCellBackGroundColor       KDefaultOrNightBackGroundColor                

///Cell中副标题的颜色内容
#define KSubTitleContentTextColor           [UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1]



///Cell数字颜色
#define KSubNumbeiTextColor                 [UIColor colorWithRed:129/255.0f green:129/255.0f blue:129/255.0f alpha:0.6]


////UIImageView的默认背景颜色内容
#define KUIImageViewDefaultColor            [UIColor colorWithRed:158/255.0f green:158/255.0f blue:158/255.0f alpha:0.15f]

////默认的浅灰色字体内容
#define KContentTextLightGrayColor          [UIColor colorWithRed:206/255.0f green:206/255.0f blue:206/255.0f alpha:1.0f]

////蓝色可点击或可编辑内容背景色 即蓝色
#define KContentTextCanEditColor            [UIColor colorWithRed:70.0f/255.0f green:142.0f/255.0f blue:188.0f/255.0f alpha:1.0f]

#define KUINavigationBarColor               [UIColor colorWithRed:35.0f/255.0f green:187.0f/255.0f blue:146.0f/255.0f alpha:1.0f]

//有点青的背景色
#define KDefaultOrBackgroundColor            [UIColor colorWithRed:230/255.0f green:235/255.0f blue:240/255.0f alpha:1]
#define KDefaultOrNightBackGroundColor       [[FMThemeManager skin] backgroundColor]
#define KDefaultOrNightTextColor             [[FMThemeManager skin] textColor]
#define KDefaultOrNightSepratorColor         [[FMThemeManager skin] sepratorColor]
#define KDefaultOrNightScrollViewColor       [[FMThemeManager skin] scrollViewBackgroudColor]
#define KDefaultOrNightButtonHighlightColor  [[FMThemeManager skin] buttonHighlightColor]
#define KDefaultOrNightBaseColor             [[FMThemeManager skin] baseTintColor]
#define KDefaultOrNightCellSelected          [[FMThemeManager skin] cellSelectedColor]

#define KMoneyColor                          [UIColor colorWithRed:251.0/255.0 green:90.0/255.0 blue:40.0/255.0 alpha:1.000]


// 随机色
#define XZRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]
// 青背景 e4ebf0
#define XZBackGroundColor XZColor(228, 235, 240)
#endif
