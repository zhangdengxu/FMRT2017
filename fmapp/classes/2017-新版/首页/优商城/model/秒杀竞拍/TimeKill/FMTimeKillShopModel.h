//
//  FMTimeKillShopModel.h
//  fmapp
//
//  Created by runzhiqiu on 16/8/9.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMTimeKillShopModel : NSObject

@property (nonatomic,copy) NSString *product_id;
@property (nonatomic, assign) NSNumber * already;


/**
 *  秒杀商品button的状态
 */
@property (nonatomic,copy) NSString *activity_state_button;

/**
 *  秒杀商品的状态
 */
@property (nonatomic,copy) NSString *activity_state;

/**
 *  秒杀商品标识
 */
@property (nonatomic,copy) NSString *kill_id;

/**
 *  商品标识（与ecstoresdb_b2c_goodsgoods_id一致）
 */
@property (nonatomic,copy) NSNumber *goods_id;
/**
 *  商品的描述
 */
@property (nonatomic,copy) NSString *goods_name;
/**
 *  商品图片（缩略图）URL地址
 */
@property (nonatomic,copy) NSString *image_url;
/**
 *  商品原价
 */
@property (nonatomic,copy) NSString *price;
/**
 *  商品秒杀价格
 */
@property (nonatomic,copy) NSString *sale_price;
/**
 *  商品的剩余可销售数量
 */
@property (nonatomic,copy) NSString *online_num;
/**
 *  当前秒杀商品的秒杀开始时间
 */
@property (nonatomic,copy) NSString *begin_time;

/**
 *  当前秒杀商品的秒杀结束时间
 */
@property (nonatomic,copy) NSString *end_time;


@property (nonatomic, assign) NSInteger baseCount;


@property (nonatomic, assign) NSInteger toEndTime;

@property (nonatomic,copy) NSString *gray_image_url;


-(void)changeBaseCount;

@end

@interface FMTimeKillShopSectionHeaderModel : NSObject

@property (nonatomic,copy) NSString *timeStr;

@property (nonatomic,copy) NSString *flag;

@property (nonatomic,copy) NSString *timeDetail;


@property (nonatomic, assign) NSInteger currentTimeDown;


@property (nonatomic, assign) NSInteger startTimeCount;


@property (nonatomic, assign) NSInteger interNetDate;

@end


@interface FMTimeKillShopSectionRefreshModel : NSObject

@property (nonatomic,copy) NSString *kill_id;
@property (nonatomic,copy) NSString *online_num;
@property (nonatomic,copy) NSString *activity_state;

@end



