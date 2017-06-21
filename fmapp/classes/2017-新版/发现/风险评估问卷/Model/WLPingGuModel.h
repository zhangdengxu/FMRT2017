//
//  WLPingGuModel.h
//  fmapp
//
//  Created by 秦秦文龙 on 17/3/14.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLPingGuModel : NSObject

/** 试卷得分 */
@property (nonatomic, copy) NSString *Id;

/** 评估等级标识，范围参考：“投资人评估等级" */
@property (nonatomic, copy) NSString *Time;

/** 评估等级名称，范围参考：“投资人评估等级” */
@property (nonatomic, copy) NSString *GradeName;
@end
