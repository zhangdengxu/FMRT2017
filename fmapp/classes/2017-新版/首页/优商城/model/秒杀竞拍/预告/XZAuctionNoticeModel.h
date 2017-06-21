//
//  XZAuctionNoticeModel.h
//  fmapp
//
//  Created by admin on 16/8/15.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZAuctionNoticeModel : NSObject
/** 秒杀活动标识 */
@property (nonatomic, copy) NSString *kill_id;
/** 商品标识 */
@property (nonatomic, copy) NSString *goods_id;
/** 默认的产品标识*/
@property (nonatomic, copy) NSString *product_id;
/** 商品名称 */
@property (nonatomic, copy) NSString *goods_name;
/** 活动预告图URL */
@property (nonatomic, copy) NSString *notice_img;
/** 商品原价 */
@property (nonatomic, copy) NSString *price;
/** 秒杀活动价 */
@property (nonatomic, copy) NSString *sale_price;
/** 秒杀开始时间，格式：时间戳 */
@property (nonatomic, copy) NSString *begin_time;
/** 秒杀活动商品的状态：
 0：未审核
 1：未开始
 2：活动中
 3：已结束
 4：已过期
*/
@property (nonatomic, copy) NSString *activity_state;
/** 图片地址 */
@property (nonatomic, copy) NSString *image_url;
@property (nonatomic, copy) NSString *gray_image_url;
/** 竞拍还是秒杀 */
@property (nonatomic, copy) NSString *flag;
@end
