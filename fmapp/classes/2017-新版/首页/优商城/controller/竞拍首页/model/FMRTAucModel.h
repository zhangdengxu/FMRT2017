//
//  FMRTAucModel.h
//  fmapp
//
//  Created by apple on 16/8/7.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMRTAucModel : NSObject

@property (nonatomic, copy) NSURL *head_picture_url;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *comment;

@end


@interface FMRTAucFirstModel : NSObject

@property (nonatomic, copy) NSString *product_id;
@property (nonatomic, copy) NSString *activity_state;
@property (nonatomic, copy) NSString *auction_id;
@property (nonatomic, copy) NSString *begin_time;
@property (nonatomic, copy) NSString *current_price;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSURL *image_url;
@property (nonatomic, copy) NSURL *gray_image_url;
@property (nonatomic, copy) NSString *max_price;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *start_price;
@property (nonatomic, strong) NSMutableArray *phoneTitles;

@end

@interface FMRankingModel : NSObject

@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *phone;

@end


