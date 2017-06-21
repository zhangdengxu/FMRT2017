//
//  FMTimeKillShopDetailController.h
//  fmapp
//
//  Created by runzhiqiu on 16/8/10.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMViewController.h"
typedef enum  {
    FMTimeKillShopDetailControllerJingPai = 0,
    FMTimeKillShopDetailControllerStyleMiaoSha = 1,
}FMTimeKillShopDetailControllerStyle;


@interface FMTimeKillShopDetailController : FMViewController

@property (nonatomic,copy) NSString *detailURL;
@property (nonatomic,copy) NSString *product_id;


@property (nonatomic, assign) FMTimeKillShopDetailControllerStyle shopDetailStyle;

/**
 *  竞拍与秒杀的标记、主要是竞拍ID与秒杀ID
 */
@property (nonatomic,copy) NSString *actionFlag;

@property (nonatomic,copy) NSString *killPrice;


@property (nonatomic, copy) NSString *  activity_state;

@end



@interface FMShopDetailKillVideoModel : NSObject

@property (nonatomic,copy) NSString *videoString;
@property (nonatomic,copy) NSString *videoHeigh;
@property (nonatomic,copy) NSString *videoWidth;
@property (nonatomic,copy) NSString *video_thumb;


-(void)resetVideoWidthAndHeigh;


@end

