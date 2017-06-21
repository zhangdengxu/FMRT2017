//
//  XZRegistrationCertificateModel.h
//  fmapp
//
//  Created by admin on 16/6/29.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZRegistrationCertificateModel : NSObject
/** 活动主题 */
@property (nonatomic, strong) NSString *party_theme;
/** 活动地点 */
@property (nonatomic, strong) NSString *party_address;
/** 是否结束 1结束 0未结束 */
@property (nonatomic, strong) NSString *jieshu;
/** 活动标签（免费）*/
@property (nonatomic, strong) NSString *party_labletitle;
/** 活动时间 */
@property (nonatomic, strong) NSString *party_timelist;
/** 主办方 */
@property (nonatomic, strong) NSString *party_initiator;
/** 报名人 */
@property (nonatomic, strong) NSString *name;
/** 验证码 */
@property (nonatomic, strong) NSString *shuzima;
/** 1即将开始 2已验票 3已结束 4已拒绝 */
@property (nonatomic, strong) NSString *party_joinstatus;

@end
