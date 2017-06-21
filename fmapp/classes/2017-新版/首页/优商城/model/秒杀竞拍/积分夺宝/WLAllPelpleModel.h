//
//  WLAllPelpleModel.h
//  fmapp
//
//  Created by 秦秦文龙 on 16/11/2.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLAllPelpleModel : NSObject
//开始时间
@property (nonatomic, copy) NSString *begin_time;
//结束时间
@property (nonatomic, copy) NSString *end_time;
//商品标识
@property (nonatomic, copy) NSString *goods_id;
//商品图片
@property (nonatomic, copy) NSString *goods_img;
//商品名称
@property (nonatomic, copy) NSString *goods_name;
//默认产品标识
@property (nonatomic, copy) NSString *product_id;
//剩余天数
@property (nonatomic, copy) NSString *residue;
//参与总人数
@property (nonatomic, copy) NSString *sum_person;
//参与方式数组
@property (nonatomic, copy) NSArray *ways;
//夺宝活动标识
@property (nonatomic, copy) NSString *won_id;


@end
