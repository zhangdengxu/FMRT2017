//
//  XZConfirmOrderModel.h
//  fmapp
//
//  Created by admin on 16/5/18.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XZShoppingOrderAddressModel,FMShoppingListModel,XZChooseTicketModel;
@interface XZConfirmOrderModel : NSObject
#pragma mark ----- 快递
/** id */
@property (nonatomic, copy) NSString *ID;
/** 上一次选择的id */
@property (nonatomic, copy) NSString *IDLast;
/** 快递名 */
@property (nonatomic, copy) NSString *dt_name;
/** 快递钱数 */
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *has_cod;
// 默认申通
@property (nonatomic, copy) NSString *isdefault;
/** 配送方式==当前行是否被选中 */
@property (nonatomic, assign) BOOL isSelectedCell;
/** 积分确认订单：配送方式：包邮或者自提*/
@property (nonatomic, copy) NSString *deliveryWay;
/** 用户账户的总积分数 */
@property (nonatomic, copy) NSString *jifenUser;
/** 用户可得积分 */
@property (nonatomic, copy) NSString *jifen;
/** 积分抵扣的钱数 */
@property (nonatomic, copy) NSString *jifen_discount;
/** 使用抵扣的积分 */
@property (nonatomic, copy) NSString *usedJifen;
// 是否使用积分抵扣：1使用
@property (nonatomic, copy) NSString *usedJifenDiKou;

/** 商品总数量 */
@property (nonatomic, copy) NSString *totalCount;

/** 用户留言 */
@property (nonatomic, copy) NSString *userMsg;

/** 优惠model */
@property (nonatomic, strong) XZChooseTicketModel *chooseTicket;

//购物车校验
@property (nonatomic,copy) NSString *sess_id;
@property (nonatomic,copy) NSString *md5_cart_info;

@property (nonatomic, assign) NSInteger isfastbuy;
// 支付方式id：alipay、mwxpay
@property (nonatomic,copy) NSString *pay_app_id;
// 支付方式名字：支付宝支付、微信支付
@property (nonatomic,copy) NSString *payment_name;

//地址信息

@property (nonatomic, strong) XZShoppingOrderAddressModel *addressModel;

//快递信息
@property (nonatomic, copy) NSString *shipping_id;

/** 控制按钮点击--微信支付 */
@property (nonatomic, assign) BOOL isWechatPay;
/** 控制按钮点击--支付宝支付 */
@property (nonatomic, assign) BOOL isAliPay;
/** 控制按钮点击--积分支付 */
@property (nonatomic, assign) BOOL isCoinPay;

//商品信息
@property (nonatomic, strong) FMShoppingListModel *shopListModel;
@property (nonatomic, strong) NSArray *shopListArray;

/** 合计金额 */
@property (nonatomic, copy) NSString *totalMoney;

/** 合计积分 */
@property (nonatomic, copy) NSString *totalJifen;

/** 优惠 */
@property (nonatomic, copy) NSString *youhui;
/** 推荐优惠（会员优惠金额） */
@property (nonatomic, copy) NSString *tuijianyouhui;
// 订单号
@property (nonatomic, copy) NSString *order_id;

// 在请求总金额时拼接的前一个页面传递的商品id和数量
@property (nonatomic, copy) NSString *subGoodIds;
@property (nonatomic, copy) NSString *subNuber;

@end
