//
//  ProjectModel.h
//  fmapp
//
//  Created by apple on 15/3/12.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectModel : NSObject

@property (nonatomic,copy)NSString    *projectId;
@property (nonatomic,copy)NSString    *projectTitle;
@property (nonatomic,copy)NSString    *projectCompany;
@property (nonatomic,copy)NSString    *projectYearEarn;
@property (nonatomic,copy)NSString     *projectMoney;
@property (nonatomic,copy)NSString     *projectDate;
@property (nonatomic,assign)CGFloat    projectProgress;
@property (nonatomic,assign)int        projectStyle;
@property (nonatomic,copy)NSString    *projectRepayType;
@property (nonatomic,assign)int       kaishicha;
@property (nonatomic,assign)int   SurplusTime;
@property (nonatomic,assign)CGFloat    jindut;

@property (nonatomic,copy)NSString    *dizenge;
@property (nonatomic,copy)NSString    *end_time;
@property (nonatomic,copy)NSString    *jiexi_time;
@property (nonatomic,copy)NSString    *rongzifangshi;
@property (nonatomic,copy)NSString    *title;
@property (nonatomic,copy)NSString    *lilv;
@property (nonatomic,copy)NSString    *jiner;
@property (nonatomic,copy)NSString    *shengyu;
@property (nonatomic,copy)NSString    *jindu;
@property (nonatomic,copy)NSString    *zhuangtai;
@property (nonatomic,copy)NSString    *huankuanfangshi;
@property (nonatomic,copy)NSString    *leixing;
@property (nonatomic,copy)NSString    *qixian;
@property (nonatomic,copy)NSString    *qi_id;
@property (nonatomic,copy)NSString    *danbao_id;
@property (nonatomic,copy)NSString    *fdanbao_id;
@property (nonatomic,copy)NSString    *baoxian_id;
@property (nonatomic,copy)NSString    *danbaocompany;
@property (nonatomic,copy)NSString    *start_time;
@property (nonatomic,copy)NSString    *manbiaoshijian;
@property (nonatomic,copy)NSString    *yongtu;
@property (nonatomic,copy)NSString    *miaoshu;
@property (nonatomic,copy)NSString    *fengkong;
@property (nonatomic,copy)NSString    *bianhao;
@property (nonatomic,copy)NSString    *baoxianjigou;
@property (nonatomic,copy)NSString    *touzirenshu;
@property (nonatomic,copy)NSString    *xingji;
@property (nonatomic,copy)NSString    *touzidengijmingcheng;

@property (nonatomic,copy)NSString    *yuanzhaiid;
@property (nonatomic,copy)NSString    *yuanshouyi;
@property (nonatomic,copy)NSString    *huankuanrq;
@property (nonatomic,copy)NSString    *xiacriqi;
@property (nonatomic,copy)NSString    *qitshijian;
@property (nonatomic,copy)NSString    *daoqshijian;
@property (nonatomic,copy)NSString    *jilu_id;
@property (nonatomic,copy)NSString    *jiezhuangtai;
@property (nonatomic,copy)NSString    *xmshouyi;

@property (nonatomic,copy)NSString    *daoqi_time;
@property (nonatomic,copy)NSString    *jinduz;
@property (nonatomic,copy)NSString    *lilvyou;
@property (nonatomic,copy)NSString    *product_id;
@property (nonatomic,copy)NSString    *xianyou;
@property (nonatomic,copy)NSString    *jiaxi;
@property (nonatomic,copy)NSString    *jiaxiyuanyin;
@property (nonatomic,copy)NSString    *yuqizongsy;
@property (nonatomic,copy)NSString    *zddengji;
@property (nonatomic,copy)NSString   *jiaxishuzhi;
@property (nonatomic,copy)NSString    *fengxianwenjuan;

/**
 *{
 data =     {
 baoxianjigou = "";
 danbaocompany = "\U5c71\U4e1c\U9f0e\U6cf0";
 "daoqi_time" = "1970-01-01";
 "end_time" = "1970-01-01";
 "jiexi_time" = "1970-01-01";
 jindu = 0;
 jindut = 0;
 jinduz = "0.00000000";
 lilvyou = "9+1";
 "product_id" = 14104;
 shengyu = 0;
 "start_time" = "1970-01-01 08:00:00";
 touzirenshu = "<null>";
 xianyou = 1;
 };
 msg = "\U6210\U529f";
 status = 0;
 }
 */
@property (nonatomic, assign) int tianshu;

@property (nonatomic,copy)NSString   *kegoujine;

@property (nonatomic,assign)NSInteger guoqi_time;

+(id)modelWithUnserializedJSONDic:(NSDictionary *)dic;

+(id)modelForProjectDetailWithUnserializedJSONDic:(NSDictionary *)dic;

+(id)modelForClaimDetailWithUnserializedJSONDic:(NSDictionary *)dic;

+(id)modelMyClaimDetailWithUnserializedJSONDic:(NSDictionary *)dic;

@end
