//
//  FMRTAllTakeFailureOfDB.h
//  fmapp
//
//  Created by apple on 2016/10/28.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMRTAllTakeBuyResultModel.h"


@interface FMRTAllTakeFailureOfDB : UIView

@property (nonatomic, strong) FMRTAllTakeBuyResultModel *model;
@property (nonatomic, copy) void(^bottomBlcok)();

@end
