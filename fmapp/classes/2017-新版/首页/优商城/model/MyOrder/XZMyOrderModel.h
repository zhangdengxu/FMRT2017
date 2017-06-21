//
//  XZMyOrderModel.h
//  fmapp
//
//  Created by admin on 16/5/20.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>





@class XZMyOrderGoodsModel,FMOrderDetailLocationModel,FMOrderDetailGoodsModel,FMOrderAddress;
@interface XZMyOrderModel : NSObject
/** order_id */
@property (nonatomic, copy) NSString *order_id;
//是否是积分兑换商品0 普通商品订单 1 全积分兑换订单。
@property (nonatomic, copy) NSString *order_type;
/** pay_status */
@property (nonatomic, copy) NSString *pay_status;
/** ship_status */
@property (nonatomic, copy) NSString *ship_status;
/** status */
@property (nonatomic, copy) NSString *status;
/** waitdiscuss */
@property (nonatomic,copy)  NSString  *waitdiscuss;
/** havecomment */
@property (nonatomic,copy) NSString  *havecomment;
/** total_amount */
@property (nonatomic, copy) NSString *total_amount;
/** cur_amount */
@property (nonatomic, copy) NSString *cur_amount;
/** itemnum */
@property (nonatomic, copy) NSString *itemnum;
/** cost_shipping */
@property (nonatomic, copy) NSString *cost_shipping;
/** createtime */
@property (nonatomic, copy) NSString *createtime;

@property (nonatomic, strong) NSMutableArray *goods_items;

@property (nonatomic,copy) NSString *aftersales_status;

@property (nonatomic, assign) NSInteger orderStatusFM;

@property (nonatomic,copy) NSString *shipping_name2;//com
@property (nonatomic,copy) NSString *shipping_name;
@property (nonatomic,copy) NSString *logi_no;//nu
//@property (nonatomic,copy) NSString *bn;
@property (nonatomic,copy) NSString *used_jifen;

@property (nonatomic, strong) FMOrderDetailLocationModel * headerModel;
@property (nonatomic, strong) FMOrderDetailGoodsModel * footerModel;



-(void)setOederStatusWithOrderInfo;

@end


@interface FMOrderDetailLocationModel : NSObject

@property (nonatomic,copy) NSString *goodsLocation;
@property (nonatomic,copy) NSString *goodsLocationTime;

@property (nonatomic,copy) NSString *peopleGoods;
@property (nonatomic,copy) NSString *mobile;

@property (nonatomic,copy) NSString *locationString;
@property (nonatomic,copy) NSString *postcode;
@property (nonatomic, assign) NSInteger orderStatusFM;

@property (nonatomic, strong) FMOrderAddress * orderAddresss;
-(void)createDataSourceWithDictionary:(NSDictionary *)dict;

@end


@interface FMOrderDetailGoodsModel : NSObject

@property (nonatomic,copy) NSString *cost_shipping;// 运费
@property (nonatomic,copy) NSString *score_u;// 积分抵扣
@property (nonatomic,copy) NSString *coupon;// 优惠券抵扣
@property (nonatomic,copy) NSString *total_amount;// 实付款
@property (nonatomic,copy) NSString *score_g;// 返积分点数

@property (nonatomic,copy) NSString *order_id;// 订单编号
@property (nonatomic,copy) NSString *payNum;// 支付交易号
@property (nonatomic,copy) NSString *createtime;// 创建时间
@property (nonatomic,copy) NSString *paytime;// 付款时间
//@property (nonatomic,copy) NSString *delivTime;// 发货时间
@property (nonatomic,copy) NSString *finishtime;// 成交时间
@property (nonatomic,copy) NSString *used_jifen;

@property (nonatomic,copy) NSString *jifen_discount;//积分抵扣
@property (nonatomic,copy) NSString *quan_discount;//优惠券抵扣

@property (nonatomic,copy) NSString *send_time;//发货时间
@property (nonatomic,copy) NSString *order_type;//用来判断是否是积分商品
@end


@interface FMOrderAddress : NSObject
@property (nonatomic,copy) NSString *time;
@property (nonatomic,copy) NSString *ftime;
@property (nonatomic,copy) NSString *context;
@property (nonatomic,copy) NSString *location;

@end



