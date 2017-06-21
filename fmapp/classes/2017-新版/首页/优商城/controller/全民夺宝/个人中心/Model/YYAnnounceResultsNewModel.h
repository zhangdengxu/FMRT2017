//
//  YYAnnounceResultsNewModel.h
//  fmapp
//
//  Created by yushibo on 2016/11/10.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYAnnounceResultsNewModel : NSObject
/** 参与方式标识  */
@property (nonatomic, strong) NSString *way_id;
/** 参与类型（1：抽奖 2：购买）  */
@property (nonatomic, strong) NSString *way_type;
/** 期数 */
@property (nonatomic, strong) NSString *way_periods;
/** 夺宝活动标识 */
@property (nonatomic, strong) NSString *won_id;
/** 单次参与价  */
@property (nonatomic, strong) NSString *way_unit_cost;
/** 夺宝商品图片（缩略图） */
@property (nonatomic, strong) NSString *goods_img;
/** 夺宝商品名称 */
@property (nonatomic, strong) NSString *goods_name;
/** 总销售额 */
@property (nonatomic, strong) NSString *sold_sum;
/** 默认产品标识 */
@property (nonatomic, strong) NSString *product_id;
/** 夺宝价 */
@property (nonatomic, strong) NSString *won_cost;

     /**
      *  已经揭晓
     **/

/** 揭晓时间 */
@property (nonatomic, strong) NSString *reveal;
/** 中奖用户（手机号） */
@property (nonatomic, strong) NSString *win_user;
/** 中奖的幸运号码 */
@property (nonatomic, strong) NSString *win_number;
/** 用户是否中奖（0：否 1：是） */
@property (nonatomic, strong) NSString *is_win;
@end
