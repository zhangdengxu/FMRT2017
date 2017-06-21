//
//  FMIncomeTypeViewController.h
//  fmapp
//
//  Created by apple on 16/6/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMViewController.h"

@interface FMIncomeTypeViewController : FMViewController

@property (nonatomic, copy) void(^typeSelectBlock)(NSString *type);

@end
