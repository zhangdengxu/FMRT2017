//
//  FMPlaceOrderTabbar.h
//  fmapp
//
//  Created by runzhiqiu on 16/4/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^contractBlock)(UIButton * button);

@interface FMPlaceOrderTabbar : UIView
@property (nonatomic, copy)contractBlock block;
-(void)collectButtonOnClick;

@end
