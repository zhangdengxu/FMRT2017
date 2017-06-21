//
//  FMRTChangeTradeKeyViewController.h
//  fmapp
//
//  Created by apple on 2017/5/12.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMViewController.h"

typedef enum : NSUInteger {
    titleSetting=0,////交易密码设置---初次设置
    titleResetting,//交易密码重置---修改或者忘记
} titleType;

@interface FMRTChangeTradeKeyViewController : FMViewController

@property (nonatomic, assign)titleType typeTitle;

@end
