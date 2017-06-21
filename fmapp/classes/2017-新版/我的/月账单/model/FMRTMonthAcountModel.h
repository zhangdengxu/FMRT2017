//
//  FMRTMonthAcountModel.h
//  fmapp
//
//  Created by apple on 2017/2/17.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FMRTMonthAcountModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *color;

@end

@interface FMRTMonthDataModel : NSObject


@property (nonatomic, assign)double BackPrincipalAmt;
@property (nonatomic, assign)double BidAmt;
@property (nonatomic, assign)double CommissionAmt;
@property (nonatomic, assign)double IncomeAmt;
@property (nonatomic, assign)double OtherIncomeAmt;
@property (nonatomic, assign)double RechargeAmt;
@property (nonatomic, assign)double WithdrawAmt;
@property (nonatomic, assign)int ConsumeScore;
@property (nonatomic, assign)int IncomeScore;
@property (nonatomic, assign)int huise;

@end
