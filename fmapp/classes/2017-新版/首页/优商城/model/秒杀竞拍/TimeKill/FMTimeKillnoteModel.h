//
//  FMTimeKillnoteModel.h
//  fmapp
//
//  Created by runzhiqiu on 16/8/18.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMTimeKillnoteModel : NSObject

@property (nonatomic,copy) NSString *record_id;
@property (nonatomic,copy) NSString *state;
@property (nonatomic,copy) NSString *goods_id;
@property (nonatomic,copy) NSString *goods_name;
@property (nonatomic,copy) NSString *goods_img_url;
@property (nonatomic,copy) NSString *goods_gray_img_url;
@property (nonatomic,copy) NSString *goods_price;
@property (nonatomic,copy) NSString *trans_time;
@property (nonatomic,copy) NSString *trans_num;
@property (nonatomic,copy) NSString *trans_price;


@end
