//
//  FMAcountMainModel.h
//  fmapp
//
//  Created by apple on 16/6/22.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface FMAcountDetailModel : NSObject

@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *detailAbout;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *yanse;

@end

@interface FMAcountSecModel : NSObject<MJKeyValue>

@property (nonatomic, copy) NSString *incomeTotalMoney;
@property (nonatomic, copy) NSString *lendTotalMoney;
@property (nonatomic, copy) NSString *secDate;
@property (nonatomic, strong) NSArray *detailListArr;

@end

@interface FMAcountMainModel : NSObject<MJKeyValue>

@property (nonatomic, copy) NSURL *acountTopImage;
@property (nonatomic, copy) NSString *acountTopImageios;
@property (nonatomic, copy) NSString *currrentMonthExpend;
@property (nonatomic, copy) NSString *currrentMonthGap;
@property (nonatomic, copy) NSString *currrentMonthIncome;
@property (nonatomic, strong) FMAcountSecModel *acountOfAllArr;

@end
