//
//  XZRongMiSchoolProjectModel.h
//  fmapp
//
//  Created by admin on 17/3/10.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZRongMiSchoolProjectModel : NSObject
#pragma mark ---- 推荐的项目标
/** 可投钱数 */
@property (nonatomic, copy) NSString *ketouqianshu;
/** 融资金额 */
@property (nonatomic, copy) NSString *jiner;
/** 融资方式名 */
@property (nonatomic, copy) NSString *rongzifangshiname;
/** 融资方式 */
@property (nonatomic, strong) NSNumber *rongzifangshi;
/** title */
@property (nonatomic, copy) NSString *title;
/** jie_id */
@property (nonatomic, copy) NSString *jie_id;
/** 开始时间 */
@property (nonatomic, copy) NSString *start_time;
/** 结束时间 */
@property (nonatomic, copy) NSString *end_time;
/** 利率 */
@property (nonatomic, copy) NSString *lilv;
/** 状态 */
@property (nonatomic, copy) NSString *zhuangtai;
/** 期限 */
@property (nonatomic, copy) NSString *qixian;
/** 类型 */
@property (nonatomic, copy) NSString *leixing;
/** 开始差 */
@property (nonatomic, copy) NSString *kaishicha;


/** 是否展示标和商品的信息:0不显示 1显示最新标 2显示商品 */
@property (nonatomic, strong) NSNumber *extraDisplay;

#pragma mark ---- 推荐的商品

/** 图片：取第一个值 */
@property (nonatomic, strong) NSArray *images;
/** 价格 */
@property (nonatomic, copy) NSString *price;
/** 价格 */
@property (nonatomic, strong) NSDictionary *product_price;
/** 商品id */
@property (nonatomic, copy) NSString *product_id;
/** 积分商品时的积分数 */
@property (nonatomic, copy) NSString *fulljifen_ex;

/** 需要积分数 */
@property (nonatomic, copy) NSString *needjifen;

/** 类型type(判断是否是积分数据)：normal正常商品、全积分 */
@property (nonatomic, copy) NSString *type;

// title \ images数组第一个 \ price \ productID\是否是积分商品\fulljifen_ex
@end

