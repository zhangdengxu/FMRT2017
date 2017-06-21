//
//  YYCardPackageModel.h
//  fmapp
//
//  Created by yushibo on 2017/3/12.
//  Copyright © 2017年 yk. All rights reserved.
//  卡券相关model

#import <Foundation/Foundation.h>
@interface YYCardPackageModel : NSObject 
/**
 *  红包券
 */
/**  红包标识,加息劵标识 */
@property (nonatomic, assign) int Id;
/**  红包金额 */
@property (nonatomic, assign) double Amt;
/**  红包发放时间，格式：时间戳（精确到秒）, 加息劵发放时间，格式：时间戳（精确到秒） */
@property (nonatomic, copy) NSString *AwardTime;
/**  红包过期时间，格式：时间戳（精确到秒）, 加息劵过期时间，格式：时间戳（精确到秒） */
@property (nonatomic, copy) NSString *PastTime;
/**  适用渠道，（预留） */
@property (nonatomic, assign) int AvlTrench;
/**  红包获取渠道。范围参考：“红包获取渠道”, 加息劵获取渠道。范围参考：“加息券获取渠道” */
@property (nonatomic, assign) int GetTrench;
/**  红包当前状态。范围参考：“红包状态”, 加息劵当前状态。范围参考：“加息劵状态” */
@property (nonatomic, assign) int Status;
/**  标题 */
@property (nonatomic, copy) NSString *Title;
/**  描述 */
@property (nonatomic, copy) NSString *Desc;
/**  适用标的期限-最小值，单位：月（预留）, 适用标的期限-最小值，单位：月 */
@property (nonatomic, assign) int ProjDurationMin;
/**  适用标的期限-最大值，单位：月 若为0则不限（预留） */
@property (nonatomic, assign) int ProjDurationMax;
/**  适用投资金额-最小值，单位：元 */
@property (nonatomic, assign) double ProjAmtMin;
/**  适用投资金额-最大值，单位：元 若为0则不限 */
@property (nonatomic, assign) double ProjAmtMax;


/**
 *  加息券
 */
/**  加息利率 */
@property (nonatomic, assign) double Rate;
//@property (nonatomic, copy) NSArray *Rate;


/** 内容高度 */
@property (nonatomic, assign) CGFloat contentH;

@end
