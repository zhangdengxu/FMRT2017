//
//  XZBankListModel.h
//  fmapp
//
//  Created by admin on 16/6/14.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZBankListModel : NSObject

@property (nonatomic, copy) NSString *content;// 显示名称
@property (nonatomic, copy) NSString *yin_id; // Id号
@property (nonatomic, copy) NSString *logodizhi; // Logo地址
@property (nonatomic, copy) NSString *xianer; // 限额信息
@property (nonatomic, copy) NSString *title; // 银行名称缩写

//添加银行卡的model
@property (nonatomic, copy) NSString *bankName;// 显示名称
@property (nonatomic, copy) NSString *payAccNoId; // Id号
@property (nonatomic, copy) NSString *logo; // Logo地址
@property (nonatomic, copy) NSString *isDefault; // 是否为默认卡
@property (nonatomic, copy) NSString *bankNameS; // 银行名称缩写
@property (nonatomic, copy) NSString *cardNo; // 银行卡尾号
// 新增银行卡
/** 银行储蓄卡号 */
@property (nonatomic, copy) NSString *bankCardNumber;
/** 银行预留手机号 */
@property (nonatomic, copy) NSString *bankPhoneNumber;
/** 开户行所属地 */
@property (nonatomic, copy) NSString *bankAddress;
/** 地址id */
@property (nonatomic, copy) NSString *area_id;

//聚一聚
@property (nonatomic, copy) NSString *id;// Id号
@property (nonatomic, copy) NSString *uname; // 显示名称
@property (nonatomic, copy) NSString *pid; // Logo地址
@property (nonatomic, copy) NSString *comment; //
@property (nonatomic, copy) NSString *commentime; // 银行名称缩写
@property (nonatomic, copy) NSString *user_id; // 银行卡尾号
@property (nonatomic, copy) NSString *zhuangtai;
@property (nonatomic, copy) NSString *praisenum;
@property (nonatomic, copy) NSString *avatar;//图片
@end
