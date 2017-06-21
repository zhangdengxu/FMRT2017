//
//  FMRTBabyAddJIARUJINEViewController.h
//  fmapp
//
//  Created by apple on 16/9/19.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMViewController.h"
#import "BabyPlanDetailModel.h"

@interface FMRTBabyAddJIARUJINEViewController : FMViewController

@property (nonatomic, strong) BabyPlanDetailModel *model;
@property (nonatomic, copy) void(^popBlock)();

@end
