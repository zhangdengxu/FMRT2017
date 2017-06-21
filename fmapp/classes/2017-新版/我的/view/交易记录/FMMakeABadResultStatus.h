//
//  FMMakeABadResultStatus.h
//  fmapp
//
//  Created by runzhiqiu on 16/6/13.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
#define KDefaultFMMakeABadResultStatus @"提交成功"

@class XZSaveDetailM;

@interface FMMakeABadResultStatus : UIView

@property (nonatomic, strong) XZSaveDetailM *saveM;
@property (nonatomic, copy) void(^withButtonOnClickBlock)(NSInteger stasus);

@end
