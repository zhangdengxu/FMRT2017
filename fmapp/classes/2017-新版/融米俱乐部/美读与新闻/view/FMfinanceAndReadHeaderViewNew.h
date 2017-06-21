//
//  FMfinanceAndReadHeaderViewNew.h
//  fmapp
//
//  Created by runzhiqiu on 2016/11/28.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMBeautifulModel;
typedef void(^financeAndReadHeaderButtonBlock)(FMBeautifulModel * model);

@interface FMfinanceAndReadHeaderViewNew : UIView

@property (nonatomic, strong) FMBeautifulModel * dataSource;

@property (nonatomic,copy) financeAndReadHeaderButtonBlock buttonBlock;

@end
