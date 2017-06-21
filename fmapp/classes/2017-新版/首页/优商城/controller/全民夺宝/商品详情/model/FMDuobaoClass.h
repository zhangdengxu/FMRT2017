//
//  FMDuobaoClass.h
//  fmapp
//
//  Created by runzhiqiu on 2016/11/1.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>


@class FMDuobaoClassStyle,FMDuobaoClassSelectStyle;
@interface FMDuobaoClass : NSObject

@property (nonatomic,copy) NSString *goods_id;
@property (nonatomic,copy) NSString *product_id;
@property (nonatomic,copy) NSString *goods_name;
@property (nonatomic,copy) NSString *goods_img;
@property (nonatomic,copy) NSString *begin_time;
@property (nonatomic,copy) NSString *end_time;
@property (nonatomic,copy) NSString *residue;
@property (nonatomic,copy) NSString *state;
@property (nonatomic,copy) NSString *sum_person;
@property (nonatomic,copy) NSString *sum_online;
@property (nonatomic,copy) NSString *brief;
@property (nonatomic,copy) NSString *intro;//商品H5介绍
@property (nonatomic,copy) NSString *video_thumb;

@property (nonatomic, assign) BOOL haveNOStyle;

@property (nonatomic, strong) NSArray * duobaoArray;
@property (nonatomic, strong) FMDuobaoClassStyle * selectStyleModel;
@end




@interface FMDuobaoClassNotes : NSObject


@property (nonatomic,copy) NSString *record_id;
@property (nonatomic,copy) NSString *way_type;
@property (nonatomic,copy) NSString *way_unit_cost;
@property (nonatomic,copy) NSString *head_img;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *lucky_number;
@property (nonatomic,copy) NSString *trans_time;
@property (nonatomic,copy) NSString *trans_time_ms;
@property (nonatomic,copy) NSString *state;



@end

//1币得、5币得、老友价的model
@interface FMDuobaoClassStyle : NSObject

@property (nonatomic,copy) NSString *style_id;

@property (nonatomic,copy) NSString *type;//参与类型（1：抽奖 2：购买）
@property (nonatomic,copy) NSString *unit_cost;//单次参与价-----用来区分几币得，1：1币得，5：5币得

@property (nonatomic,copy) NSString *won_cost;//夺宝价-------老友价使用
@property (nonatomic,copy) NSString *original_cost;//商品原价
@property (nonatomic,copy) NSString *sold_sum;//已销售总额
@property (nonatomic,copy) NSString *online;//剩余库存
@property (nonatomic,copy) NSString *explain;//参与方式的文本说明
@property (nonatomic,copy) NSString *periods;//当前的期数（第几期、第几个商品）
@property (nonatomic,copy) NSString *purchased;//用户是否已经参与过当期（0：否 1：是）
@property (nonatomic,copy) NSString *residue;//剩余天数（以查询时的服务器时间为准）



//以下为自用变量类型
@property (nonatomic,copy) NSString *shop_Status;
@property (nonatomic, assign) BOOL isSpread;

@property (nonatomic, assign) NSInteger spreadNumber;
//判断进度条的状态
@property (nonatomic,copy) NSString *status;
////判断button是否可以点击
//@property (nonatomic, assign) BOOL buttonOnClick;

//判断button是否可以点击
@property (nonatomic, assign) NSInteger buttonStyle;

//改变Model的状态
-(void)changeModelStatus;

@end

@class XZShoppingOrderAddressModel;
@interface FMDuobaoClassSelectStyle : NSObject

@property (nonatomic, strong) FMDuobaoClassStyle * selectModel;

@property (nonatomic,copy) NSString *won_id;
@property (nonatomic,copy) NSString *style_id;

@property (nonatomic,copy) NSString *goods_id;
@property (nonatomic,copy) NSString *product_id;
@property (nonatomic,copy) NSString *goods_name;
@property (nonatomic,copy) NSString *goods_img;

//商品样式 --- 有可能不存在
@property (nonatomic,copy) NSString *selectString;

/** 余额支付 */
@property (nonatomic,assign) BOOL isBalancePay;
/** 同意全民夺宝服务协议 */
@property (nonatomic,assign) BOOL isAgreeDeal;
/** 支付订单号 */
@property (nonatomic,copy) NSString *pay_trade_no;
@property (nonatomic,copy) NSString *record_id;
/** 支付方式 */
@property (nonatomic,copy) NSString *payment_name;
/** 交易记录标识 */
@property (nonatomic,copy) NSString *pay_app_id;
/** 幸运号码 */
@property (nonatomic,copy) NSString *lucky_code;
/** 消费后用户的夺宝币账户余额 */
@property (nonatomic,copy) NSString *balance;
//地址信息
@property (nonatomic, strong) XZShoppingOrderAddressModel *addressModel;
@end
