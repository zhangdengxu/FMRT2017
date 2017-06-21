//
//  WLNewEvaluateViewController.h
//  fmapp
//
//  Created by 秦秦文龙 on 17/2/14.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMViewController.h"

@class XZRiskQueSubmitAnswerModel;

@interface WLNewEvaluateViewController : FMViewController

@property (nonatomic, strong) XZRiskQueSubmitAnswerModel *modelRiskSubmit;
@property (nonatomic, assign) BOOL isComeFromYY;

@end
