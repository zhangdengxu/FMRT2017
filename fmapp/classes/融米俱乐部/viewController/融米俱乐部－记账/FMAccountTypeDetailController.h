//
//  FMAccountTypeDetailController.h
//  fmapp
//
//  Created by runzhiqiu on 16/6/30.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMViewController.h"
typedef enum : NSUInteger {
    FMAccountTypeDetailControllerTypeDate,
    FMAccountTypeDetailControllerTypeRange
    
} FMAccountTypeDetailControllerType;

@class FMSelectAccountModel;

@interface FMAccountTypeDetailController : FMViewController

typedef void(^FMAccountTypeDetailControllerTypeSelectItem)(FMSelectAccountModel * typeDetail);

@property (nonatomic, assign) FMAccountTypeDetailControllerType accountType;

@property (nonatomic,copy) FMAccountTypeDetailControllerTypeSelectItem selectModel;

@end
