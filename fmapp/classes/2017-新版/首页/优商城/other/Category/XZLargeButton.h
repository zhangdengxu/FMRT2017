//
//  XZLargeButton.h
//  fmapp
//
//  Created by runzhiqiu on 16/4/18.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    XZLargeButtonTypeNormal=0,//徐雪建的
    XZLargeButtonTypeTabBar,//徐雪建的
    XZLargeButtonTypeActivityTabBar,//徐雪建的
    XZLargeButtonTypeTabBarBottom,//谢兴明建的
    XZLargeButtonTypeGoodShopMenu//谢兴明建的
} XZLargeButtonType;

@interface XZLargeButton : UIButton

@property (nonatomic, assign) XZLargeButtonType buttonTypecu;
@end
