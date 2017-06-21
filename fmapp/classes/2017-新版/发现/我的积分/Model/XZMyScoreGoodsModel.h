//
//  XZMyScoreGoodsModel.h
//  fmapp
//
//  Created by admin on 17/3/12.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZMyScoreGoodsModel : NSObject

/** title */
@property (nonatomic, copy) NSString *title;

/** 需要积分数 */
@property (nonatomic, copy) NSString *needjifen;

/** 全钱购买 */
@property (nonatomic, copy) NSString *price;

/** 图片 */
@property (nonatomic, copy) NSString *img;

/** product_id */
@property (nonatomic, copy) NSString *product_id;

/** 类型type(判断是否是积分数据)：normal正常商品、全积分 */
@property (nonatomic, copy) NSString *type;

/** 剩余商品数量 */
@property (nonatomic, strong) NSNumber *remaining;
@end
