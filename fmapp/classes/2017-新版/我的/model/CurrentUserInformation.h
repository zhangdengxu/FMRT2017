//
//  CurrentUserInformation.h
//  F103CZFW
//
//  Created by 张利广 on 13-5-21.
//  Copyright (c) 2013年 zhang liguang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentUserInformation : NSObject

@property (nonatomic,copy)NSString       *userName;
@property (nonatomic,copy)NSString       *personName; // 新的用户名
@property (nonatomic,copy)NSString       *touxiangsde;// 头像链接
@property (nonatomic,copy)NSString       *userId;
@property (nonatomic,copy)NSString       *vipbiaozhi;
@property (nonatomic,copy)NSString       *vipzigefenxiang;
@property (nonatomic,copy)NSString       *usrcustid;
@property (nonatomic,copy)NSString       *vipzige;

@property (nonatomic,assign)int          shiming; // 实名和开通汇付
@property (nonatomic,copy)NSString       *touxiang;
@property (nonatomic,copy) NSString      *toubiaocishu;
@property (nonatomic,copy) NSString      *mobile;
@property (nonatomic,copy) NSString      *iszdtou;
@property (nonatomic,copy) NSString      *hfkai;// 开通恒丰
@property (nonatomic,copy) NSString      *zhenshiname;
@property (nonatomic,copy) NSString      *shenfenzhenghao;
@property (nonatomic,copy) NSString      *jymimafou;
@property (nonatomic,copy) NSString      *banbenhao;
@property (nonatomic,copy) NSString      *startTime;
@property (nonatomic,copy) NSString      *wenjuanxianshi;

@property (nonatomic,copy) NSString      *fengxianwenjuan;
@property (nonatomic,copy) NSString      *fengxianwenjuanwode;

@property (nonatomic,copy) NSString      *weishangbang;//1已绑定徽商0未绑定 ,只绑卡
@property (nonatomic,copy) NSString      *jiaoyimshezhi;//1设置交易密码0未设置
@property (nonatomic,copy) NSString      *huishangshiming;//徽商实名，开立徽商电子账户 //1实名2未实名



///用户登录状态
@property (nonatomic, assign) NSInteger userLoginState;
// 请求数据成功修改头像
@property (nonatomic, copy) void(^blockChangeUserIcon)(CurrentUserInformation *);

+(CurrentUserInformation *)sharedCurrentUserInfo;

+(void)initializaionUserInformation:(NSDictionary *)userInfoDic;
- (void)cleanAllUserInfo;

-(void)checkUserInfoWithNetWork;
-(void)userQuiteWithApp;

-(void)checkFigureJudge;
- (void)userFromArachiver;
+ (void)saveUserObjectWithUser:(CurrentUserInformation *)user;


//判断java网络状态的参数，1标示java不通，要走php，0标示java可以走；
@property (nonatomic, assign) NSInteger statusNetWork;

@end
