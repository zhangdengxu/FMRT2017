//
//  XZMyOrderGoodsModel.h
//  fmapp
//
//  Created by admin on 16/5/20.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZMyOrderGoodsModel : NSObject
/** product_id */
@property (nonatomic, copy) NSString *product_id;
/** 商品描述 */
@property (nonatomic, copy) NSString *name;
/** 颜色、尺码 */
@property (nonatomic, copy) NSString *spec_info;
/** 现在的价格 */
@property (nonatomic, copy) NSString *price;
/** 原价 */
@property (nonatomic, copy) NSString *mktprice;
/** 数量 */
@property (nonatomic, copy) NSString *quantity;
/** 图片地址 */
@property (nonatomic, copy) NSString *thumbnail_pic;

@property (nonatomic, copy) NSString *gid;

@property (nonatomic, copy) NSString *order_id;

@property (nonatomic, copy) NSString *aftersales_status;

@property (nonatomic, copy) NSString *bn;
//aftersales字段0 未申请售后，1 已申请售后
@property (nonatomic, strong) NSNumber * aftersales;

@property (nonatomic, copy) NSString *used_jifen;

@property (nonatomic, assign) NSInteger orderStatusFM;
//aftersales=1的有aftersale_id
@property (nonatomic,copy) NSString *aftersale_id;
//是否是积分商品
@property (nonatomic,copy) NSString *order_type;

@end
