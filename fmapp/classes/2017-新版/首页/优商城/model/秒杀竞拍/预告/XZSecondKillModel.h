//
//  XZSecondKillModel.h
//  fmapp
//
//  Created by admin on 16/8/12.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZSecondKillModel : NSObject
/** 用户昵称 */
@property (nonatomic, copy) NSString *nickname;
/** 用户手机号码（前三后四位） */
@property (nonatomic, copy) NSString *phone;
/** 当前距离下次秒杀活动开始时间的时间差，格式：时间戳 */
//@property (nonatomic, copy) NSString *next_start;
@end
