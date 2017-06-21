//
//  XZPublishModel.h
//  fmapp
//
//  Created by admin on 16/7/13.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZPublishModel : NSObject

/** 活动主题 */
@property (nonatomic, copy) NSString *party_theme;
/** 开始时间 */
@property (nonatomic, copy) NSString *party_startime;
/** 截止时间 */
@property (nonatomic, copy) NSString *party_endtime;
/** 报名截止 */
@property (nonatomic, copy) NSString *party_enrolltime;
/** 活动地点 */
@property (nonatomic, copy) NSString *party_address;
/** 活动详情 */
@property (nonatomic, copy) NSString *party_info;
/** 人数上限 */
@property (nonatomic, copy) NSString *party_number;

@end
