//
//  YYParticipationRecordModel.h
//  fmapp
//
//  Created by yushibo on 2016/11/9.
//  Copyright © 2016年 yk. All rights reserved.
//  参与记录model

#import <Foundation/Foundation.h>

@interface YYParticipationRecordModel : NSObject

/**
 * 正在进行
 */

/** 夺宝订单编号  */
@property (nonatomic, strong) NSString *record_id;
/** 夺宝活动标识  */
@property (nonatomic, strong) NSString *won_id;
/** 1：抽奖 2：购买 */
@property (nonatomic, strong) NSString *way_type;
/** 单次参与价 */
@property (nonatomic, strong) NSString *way_unit_cost;
/** 夺宝商品名称  */
@property (nonatomic, strong) NSString *goods_name;
/** 夺宝商品图片（缩略图） */
@property (nonatomic, strong) NSString *goods_img;
/** 用户当前参与方式下的夺宝价 */
@property (nonatomic, strong) NSString *goods_price;
/** 用户当前参与方式的总销售额 */
@property (nonatomic, strong) NSString *sold_sum;
/** 用户选择的产品标识 */
@property (nonatomic, strong) NSString *product_id;
/** 用户选择的产品属性（用英文逗号分隔）例：黑色,L */
@property (nonatomic, strong) NSString *product_spec;
/** 下单时间，格式：时间戳  */
@property (nonatomic, strong) NSString *order_time;
/** 下单时间毫秒值  */
@property (nonatomic, strong) NSString *order_time_ms;
/** 付款时间，格式：时间戳（精确到秒)  */
@property (nonatomic, strong) NSString *pay_time;
/** 用户的幸运号码 */
@property (nonatomic, strong) NSString *lucky_number;
/** 抽奖状态，只包含1：投注中 和 2：即将揭晓
 其余状态不在此接口查询范围内 */
@property (nonatomic, strong) NSString *state;
/** 当期揭晓时间  */
@property (nonatomic, strong) NSString *reveal;

/**
 * 已经揭晓
 */
/** 订单状态  */
@property (nonatomic, strong) NSString *record_state;
/** 参与方式标识  */
@property (nonatomic, strong) NSString *way_id;
/** 期数  */
@property (nonatomic, strong) NSString *way_periods;
/** 用户是否中奖（0：否 1：是）  */
@property (nonatomic, strong) NSString *is_win;
/** 中奖用户手机号  */
@property (nonatomic, strong) NSString *win_user_phone;
/** 中奖用户的昵称  */
@property (nonatomic, strong) NSString *win_user_nickname;
/** 中奖的幸运号码  */
@property (nonatomic, strong) NSString *win_number;
@end
