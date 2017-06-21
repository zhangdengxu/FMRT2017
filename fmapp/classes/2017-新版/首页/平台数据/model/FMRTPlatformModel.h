//
//  FMRTPlatformModel.h
//  fmapp
//
//  Created by apple on 2017/2/16.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface zhuceModel : NSObject
@property (nonatomic, copy)NSString *UserSum;
@property (nonatomic, copy)NSString *BidSum;
@property (nonatomic, copy)NSString *IncomeAmt;
@end

@interface fuwuModel : NSObject
@property (nonatomic, copy)NSString *CompanySum;
@property (nonatomic, copy)NSString *MinCost;
@property (nonatomic, copy)NSString *MaxCost;
@property (nonatomic, assign)double RepayRate;
@end

@interface FMOverViewModel : NSObject
@property (nonatomic, strong) zhuceModel *User;
@property (nonatomic, copy)   NSString *DealAmt;
@property (nonatomic, strong) fuwuModel *Company;
@end

//---------近一年累计成交金额-----------
@interface lineModel : NSObject
@property (nonatomic, copy)NSString *Years;
@property (nonatomic, assign)double Amt;
@property (nonatomic, copy)NSString *Desc;
@end

//---------企业数据预览----------
@interface hexin: NSObject
@property (nonatomic, copy)NSString *CoreSum;
@property (nonatomic, copy)NSString *ProjSum;
@end
@interface fukuan: NSObject
@property (nonatomic, copy)NSString *PaidSum;
@property (nonatomic, copy)NSString *PaidProjSum;
@end
@interface rongzi: NSObject
@property (nonatomic, copy)NSString *LoanSum;
@property (nonatomic, copy)NSString *LoadAvgMoney;
@property (nonatomic, copy)NSString *MinLoanCost;
@property (nonatomic, copy)NSString *MaxLoanCost;
@end

@interface Ent : NSObject
@property (nonatomic, strong)hexin *Core;
@property (nonatomic, strong)fukuan *Paid;
@property (nonatomic, strong)rongzi *Loan;
@end

//-------------融资企业注册资本分布-----------------
@interface zibenfenbu : NSObject
@property (nonatomic, copy)NSString *Rate;
@property (nonatomic, copy)NSString *Desc;
@property (nonatomic, copy)NSString *Color;
@end

//-------------成交项目分析-----------------
@interface zcjxmfx : NSObject
@property (nonatomic, copy)NSString *Rate;
@property (nonatomic, copy)NSString *Desc;
@property (nonatomic, copy)NSString *Color;
@end

@interface Proj : NSObject<MJKeyValue>
@property (nonatomic, strong)NSArray *DealStats;
@property (nonatomic, copy)NSString *OverdueRate;
@property (nonatomic, copy)NSString *OverdueAmt;
@property (nonatomic, copy)NSString *DealSum;
@end

//-------------融资项目期限分布-----------------
@interface xmqxfb : NSObject
@property (nonatomic, copy)NSString *Rate;
@property (nonatomic, copy)NSString *Desc;
@property (nonatomic, copy)NSString *Color;
@end

//-------------融资项目类型分布-----------------
@interface xmlxfb : NSObject
@property (nonatomic, copy)NSString *Rate;
@property (nonatomic, copy)NSString *Desc;
@property (nonatomic, copy)NSString *Color;
@end


//-------------投资人情况-----------------
@interface UserGender : NSObject
@property (nonatomic, copy)NSString *Male;
@property (nonatomic, copy)NSString *Female;
@end

//-----------------年龄分布-------------------
@interface UserAgeStats : NSObject
@property (nonatomic, copy)NSString *Sum;
@property (nonatomic, copy)NSString *Rate;
@property (nonatomic, copy)NSString *Desc;
@end

//-----------------用户类型分布-------------------
@interface gradeState : NSObject
@property (nonatomic, copy)NSString *Rate;
@property (nonatomic, copy)NSString *Desc;
@property (nonatomic, copy)NSString *Color;
@end

//-----------------投资金额分布-------------------
@interface bideState : NSObject
@property (nonatomic, copy)NSString *Rate;
@property (nonatomic, copy)NSString *Desc;
@property (nonatomic, copy)NSString *Color;
@end


@interface FMRTPlatformModel : NSObject

@property (nonatomic, strong)NSArray *DealAmtStats;
@property (nonatomic, strong)NSArray *DealAmtStatsY;
@property (nonatomic, strong)NSArray *EntCapitalStats;
@property (nonatomic, strong)NSArray *ProjPeriod;
@property (nonatomic, strong)NSArray *ProjTypeStats;
@property (nonatomic, strong)NSArray *UserAgeStats;
@property (nonatomic, strong)NSArray *UserGradeStats;
@property (nonatomic, strong)NSArray *BidAmtStats;
@property (nonatomic, strong)FMOverViewModel *overViewModel;
@property (nonatomic, strong)Ent *entmodel;
@property (nonatomic, strong)Proj *projModel;
@property (nonatomic, strong)UserGender *UserGendermodel;

@end

