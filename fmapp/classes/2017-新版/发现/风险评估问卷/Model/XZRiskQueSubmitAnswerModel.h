//
//  XZRiskQueSubmitAnswerModel.h
//  fmapp
//
//  Created by admin on 17/3/12.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZRiskQueSubmitAnswerModel : NSObject

/** 评估总次数（本年度） */
@property (nonatomic, copy) NSString *EvaluateCount;

/** 已评估次数（本年度） */
@property (nonatomic, copy) NSString *EvaluatedCount;

/** 评级失效时间，格式：时间戳（精确到秒） */
@property (nonatomic, copy) NSString *InvalidTime;

/** 试卷得分 */
@property (nonatomic, copy) NSString *Results;

/** 评估等级标识，范围参考：“投资人评估等级" */
@property (nonatomic, copy) NSString *GradeCode;

/** 评估等级名称，范围参考：“投资人评估等级” */
@property (nonatomic, copy) NSString *GradeName;

@end
