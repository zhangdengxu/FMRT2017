//
//  FMRTRebackMoneyModel.h
//  fmapp
//
//  Created by apple on 2017/6/2.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface FMRTRebackMoneyModel : NSObject<MJKeyValue>

@property (nonatomic, assign)double acctAmt;
@property (nonatomic, copy)NSString *signBankName;
@property (nonatomic, copy)NSString *signBankCard;
@property (nonatomic, assign)double transLimit;
@property (nonatomic, copy)NSString *limitDesc;
@property (nonatomic, assign)double largeLimit;
@property (nonatomic, copy)NSString *largeDesc;
/*
 工作日0为工作日1为非工作日
 */
@property (nonatomic, assign)int isWorkDay;
@property (nonatomic, copy)NSString *beginTime;
@property (nonatomic, copy)NSString *endTime;
@property (nonatomic, copy)NSArray *desc;
@property (nonatomic, assign)NSInteger txtType;
@property (nonatomic, copy)NSString *brabankName;

@end

@interface FMRTDetailModel : NSObject

@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *ID;

@end

