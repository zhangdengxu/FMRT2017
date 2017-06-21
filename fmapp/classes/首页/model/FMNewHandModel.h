//
//  FMNewHandModel.h
//  fmapp
//
//  Created by apple on 16/6/4.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMNewHandModel : NSObject

/**
 dizenge = "100.00";
 "ended_time" = 1464264000;
 "jie_id" = 942;
 jiner = 500000;
 leixing = 2;
 lilv = 20;
 qixian = 5;
 "recomm_shu" = 0;
 rongzifangshi = 3;
 rongzitianshu = 30;
 "start_time" = 1464235502;
 tianshu = 5;
 title = "\U65b0\U624b\U4e13\U4eab201602\U671f";
 tiyan = 0;
 yitouqianshu = "33300.00";
 zhuangtai = 10;

 */
@property (nonatomic, copy) NSString *dizenge;
@property (nonatomic, assign) NSInteger lilv;
@property (nonatomic, assign) NSInteger qixian;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *ended_time;
@property (nonatomic, copy) NSString *jie_id;
@property (nonatomic, copy) NSString *jiner;
@property (nonatomic, assign) NSInteger leixing;
@property (nonatomic, assign) NSInteger recomm_shu;
@property (nonatomic, assign) NSInteger rongzifangshi;
@property (nonatomic, assign) NSInteger tianshu;
@property (nonatomic, assign) NSInteger tiyan;
@property (nonatomic, assign) NSInteger zhuangtai;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *yitouqianshu;
@property (nonatomic, assign) NSInteger rongzitianshu;


@end
