//
//  FMMineModel.h
//  fmapp
//
//  Created by apple on 16/6/13.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"


/**
 {
 data =     {
 baobei =         {
 jiarushu = 0;
 xianshi = 1;
 yizhuan = 0;
 };
 hfkaitong = 0;
 keyong = "1000000.28";
 lingqian =         {
 xianshi = 1;
 zonge = "0.40";
 zuorisy = "20000.39";
 };
 toubiaozhong = 165312;
 yizhuan = "10924.03";
 yuqishouyi = "8288.66";
 zaitujine = 100;
 zichanzongshu = "173601.06";
 };
 msg = "";
 status = 0;
 }

 */


@interface baobei : NSObject

@property (nonatomic, copy) NSString *jiarushu;
@property (nonatomic, copy) NSString *xianshi;
@property (nonatomic, copy) NSString *yizhuan;
@property (nonatomic, copy) NSString *lijijiaru;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *yuejiner;
@property (nonatomic, copy) NSString *yitoucishu;
@property (nonatomic, copy) NSString *benyuecundate;
@property (nonatomic, copy) NSString *jie_id;
@property (nonatomic, copy) NSString *zongshu;

@end

@interface lingqian : NSObject

@property (nonatomic, copy) NSString *xianshi;
@property (nonatomic, copy) NSString *zonge;
@property (nonatomic, copy) NSString *zuorisy;
@property (nonatomic, copy) NSString *lqbiaoti;

@end

@interface FMMineModel : NSObject<MJKeyValue>

@property (nonatomic, copy) NSString *hfkaitong;
@property (nonatomic, copy) NSString *keyong;
@property (nonatomic, copy) NSString *toubiaozhong;
@property (nonatomic, copy) NSString *yizhuan;
@property (nonatomic, copy) NSString *yuqishouyi;
@property (nonatomic, copy) NSString *zaitujine;
@property (nonatomic, copy) NSString *zichanzongshu;
@property (nonatomic, copy) NSString *dongjiezhong;

@property (nonatomic, strong) baobei    *baobei;
@property (nonatomic, strong) lingqian  *lingqian;


@property (nonatomic, assign) NSInteger sectionCount;

/**  添加 眨眼睛 判断 BOOL   ---  于士博 */
//@property (nonatomic, assign) BOOL isEye;
 /*
**  用户积分
 */
@property (nonatomic, assign) double Score;
/*
 **  卡卷数量，红包+加息劵
 */
@property (nonatomic, assign) int CouponSum;
/*
 **  已邀请好友数量
 */
@property (nonatomic, assign) int InviteeSum;
/*
 **  可用余额，原来是调用的汇付查询余额
 */
@property (nonatomic, assign) double Balance;
/*
 **  用户（邀请人）等级，范围参考：“邀请人等级”
 */
@property (nonatomic, assign) int InviterLevel;
/*
 **  用户（邀请人）等级名称，范围参考：“邀请人等级”
 */
@property (nonatomic, copy) NSString *InviterLevelName;

@end
