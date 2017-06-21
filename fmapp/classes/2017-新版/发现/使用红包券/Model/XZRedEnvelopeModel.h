//
//  XZRedEnvelopeModel.h
//  fmapp
//
//  Created by admin on 17/2/18.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZRedEnvelopeModel : NSObject

/** 红包券和加息券可用/不可用 */
@property (nonatomic, assign) BOOL isUseful;
/** 当前被选中可用 */
@property (nonatomic, assign) BOOL isSelected;
/** 行高 */
@property (nonatomic, assign) NSInteger contentH;
/** 是红包券 */
@property (nonatomic, assign) BOOL isRedEnvelope;
/** 可用数量 */
@property (nonatomic, assign) NSInteger countRedEnveUse;
/** 不可用数量 */
@property (nonatomic, assign) NSInteger countRedEnveNotUse;
#pragma mark ---- 红包
/** 红包/加息券标识 */
@property (nonatomic, strong) NSNumber *Id;
/** 红包金额 */
@property (nonatomic, strong) NSNumber *Amt;
/** 红包/加息券发放时间 */
@property (nonatomic, copy) NSString *AwardTime;
/** 红包/加息券过期时间 */
@property (nonatomic, copy) NSString *PastTime;

/** 红包适用渠道,（预留） */
@property (nonatomic, strong) NSNumber *AvlTrench;

/** 红包/加息券获取渠道 */
@property (nonatomic, strong) NSNumber *GetTrench;
/** 红包/加息券当前状态 */
@property (nonatomic, strong) NSNumber *Status;
/** 红包/加息券：当前是否可用，传入参数中有用户投标金额和项目编号时，该字段值有效，默认均为适用 */
@property (nonatomic, strong) NSNumber *Usable;
/** 红包/加息券标题 */
@property (nonatomic, copy) NSString *Title;
/** 红包/加息券描述 */
@property (nonatomic, copy) NSString *Desc;
/** 红包/加息券：适用标的期限-最小值，单位：月（预留） */
@property (nonatomic, strong) NSNumber *ProjDurationMin;
/** 红包/加息券：适用标的期限-最大值，单位：月 若为0则不限（预留） */
@property (nonatomic, strong) NSNumber *ProjDurationMax;
/** 红包/加息券：适用投资金额-最小值，单位：元 */
@property (nonatomic, strong) NSNumber *ProjAmtMin;
/** 红包/加息券：适用投资金额-最大值，单位：元 若为0则不限 */
@property (nonatomic, strong) NSNumber *ProjAmtMax;
#pragma mark ---- 加息券
/** 加息利率 */
@property (nonatomic, strong) NSNumber *Rate;


@end
