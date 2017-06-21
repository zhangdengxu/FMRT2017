//
//  FMRTAllTakeBuyFailureView.h
//  fmapp
//
//  Created by apple on 2016/10/26.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMRTAllTakeBuyResultModel.h"

@interface FMRTAllTakeBuyFailureView : UIView

@property (nonatomic, strong) FMRTAllTakeBuyResultModel *model;
@property (nonatomic, copy) void(^bottomBlcok)();

@end
