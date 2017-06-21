//
//  WLPublishSuccessViewController.h
//  fmapp
//
//  Created by 秦秦文龙 on 16/6/29.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMViewController.h"
@class XZActivityModel;
@interface WLPublishSuccessViewController : FMViewController
@property (nonatomic, strong) XZActivityModel *modelActivity;
@property (nonatomic, assign) BOOL hasManage;

/** 竞拍和秒杀结束分享 */
@property (nonatomic, strong) NSString *navTitle;
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSString *flag;
@property (nonatomic, strong) UIImage *image;

@end
