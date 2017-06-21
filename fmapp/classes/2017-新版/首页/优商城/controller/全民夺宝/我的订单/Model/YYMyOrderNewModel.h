//
//  YYMyOrderNewModel.h
//  fmapp
//
//  Created by yushibo on 2016/11/8.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYMyOrderNewModel : NSObject
/** 夺宝订单编号  */
@property (nonatomic, strong) NSString *record_id;
/** 夺宝活动标识  */
@property (nonatomic, strong) NSString *won_id;
/** 参与方式标识 */
@property (nonatomic, strong) NSString *way_id;
/** 期数 */
@property (nonatomic, strong) NSString *way_periods;
/** 1：抽奖 2：购买 */
@property (nonatomic, strong) NSString *way_type;
/** 单次参与价 */
@property (nonatomic, strong) NSString *way_unit_cost;
/** 夺宝订单的状态。值域参考“夺宝活动订单记录的状态 */
@property (nonatomic, strong) NSString *state;
/** 夺宝商品名称  */
@property (nonatomic, strong) NSString *goods_name;
/** 夺宝商品图片（缩略图） */
@property (nonatomic, strong) NSString *goods_img;
/** 用户选择的产品标识 */
@property (nonatomic, strong) NSString *product_id;
/** 用户选择的产品属性（用英文逗号分隔）例：黑色,L */
@property (nonatomic, strong) NSString *product_spec;
/** 下单时间，格式：时间戳  */
@property (nonatomic, strong) NSString *order_time;
/** 快递单号（状态为已发货的，此字段不为空） */
@property (nonatomic, strong) NSString *tracking_num;
/** 快递公司（代号）  */
@property (nonatomic, strong) NSString *express_company;
/** 支付方式 */
@property (nonatomic, strong) NSString *pay_type;
/** 交易订单号  */
@property (nonatomic, strong) NSString *pay_trade_no;
/** 订单关闭时间，格式：时间戳  */
@property (nonatomic, strong) NSString *close_time;

@end
