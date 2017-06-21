//
//  FMRTAucDetailRecordModel.h
//  fmapp
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMRTAucDetailRecordModel : NSObject


/**
 "activity_state" = 2;
 "auction_id" = 1000;
 "begin_time" = 1470722223;
 "buy_sate" = 1;
 "cur_max_price" = 110;
 "goods_id" = 2000;
 "goods_img_url" = "http://114.55.115.60/img/mock_images/goods/goods_3.png";
 "goods_name" = "\U5546\U54c11";
 "my_cur_max_price" = 100;
 page = 0;
 state = 0;
 "user_id" = 0;
 */
@property (nonatomic, copy) NSString *activity_state;
@property (nonatomic, copy) NSString *auction_id;
@property (nonatomic, copy) NSString *begin_time;
@property (nonatomic, copy) NSString *buy_state;
@property (nonatomic, copy) NSString *cur_max_price;
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, strong) NSURL *goods_img_url;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *my_cur_max_price;
@property (nonatomic, copy) NSString *page;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *product_id;
@property (nonatomic, copy) NSString *tracking_num;
@property (nonatomic, copy) NSString *express_company;


@end
