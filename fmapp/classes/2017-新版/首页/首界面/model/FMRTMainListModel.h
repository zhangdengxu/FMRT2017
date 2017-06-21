//
//  FMRTMainListModel.h
//  fmapp
//
//  Created by apple on 2016/11/28.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMRTMainListModel : NSObject

@property (nonatomic, strong) NSMutableArray *scrollArr;
@property (nonatomic, strong) NSMutableArray *mainListArr;
@property (nonatomic, strong) NSMutableArray *tanchuangArr;

@end

@interface FMRTLunboModel : NSObject

@property (nonatomic, copy) NSString *biaoti;
@property (nonatomic, copy) NSString *fenxiangbiaoti;
@property (nonatomic, copy) NSString *fenxianglianjie;
@property (nonatomic, copy) NSString *fenxiangneirong;
@property (nonatomic, copy) NSString *fenxiangpic;
@property (nonatomic, copy) NSString *lianjie;
@property (nonatomic, copy) NSString *pic;

+(NSArray *)lunboArrWithDic:(NSDictionary *)dic;

@end

@interface FMRTXiangmuModel : NSObject

@property (nonatomic, copy) NSString *danbaocompany;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *ended_time;
@property (nonatomic, copy) NSString *huodong;
@property (nonatomic, copy) NSString *jie_id;
@property (nonatomic, copy) NSString *jindu;
@property (nonatomic, copy) NSString *jindut;
@property (nonatomic, copy) NSString *jinduz;
@property (nonatomic, copy) NSString *jiner;
@property (nonatomic, copy) NSString *jinernew;
@property (nonatomic, copy) NSString *kaishi;
@property (nonatomic, copy) NSString *kaishicha;
@property (nonatomic, copy) NSString *leixing;
@property (nonatomic, copy) NSString *lilv;
@property (nonatomic, copy) NSString *qixian;
@property (nonatomic, copy) NSString *recomm_shu;
@property (nonatomic, copy) NSString *rongzifangshi;
@property (nonatomic, copy) NSString *rongzifangshiname;
@property (nonatomic, copy) NSString *rongzitianshu;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *tianshu;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *tiyan;
@property (nonatomic, copy) NSString *yitouqianshu;
@property (nonatomic, copy) NSString *zhuangtai;
@property (nonatomic, copy) NSString *jiaxi;
@property (nonatomic, copy) NSString *ketouqianshu;
@property (nonatomic, copy) NSString *jineryiqi;

+(NSArray *)xiamgmudataArrWithDic:(NSDictionary *)dic;

@end

@interface FMRTTanchuangModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *ID;

@end



