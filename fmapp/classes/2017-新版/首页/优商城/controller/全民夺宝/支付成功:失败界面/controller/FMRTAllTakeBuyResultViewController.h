//
//  FMRTAllTakeBuyResultViewController.h
//  fmapp
//
//  Created by apple on 2016/10/26.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMViewController.h"

typedef enum : NSUInteger {
    TimeOutFailureOfPay=1,
    ActivityEndedFailureOfPay,
    SoldedZeroFailureOfPay,
    OldFiriendPriceFailureOfPay,
    DuobaobiFailureOfPay,
    DuobaobiSuccessOfPay,
    OldFiriendPriceSuccessOfPay
} AllTakePayResult;

@class FMDuobaoClassSelectStyle;
@interface FMRTAllTakeBuyResultViewController : FMViewController

@property (nonatomic, assign) AllTakePayResult resultOfPay;
@property (nonatomic, strong) NSDictionary *productDetail;
@property (nonatomic, strong) FMDuobaoClassSelectStyle *duobaoShop;//nil
@end
