//
//  XZConfirmOrderKillViewController.h
//  fmapp
//
//  Created by admin on 16/8/18.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMViewController.h"

@class FMSelectShopInfoModel;
@interface XZConfirmOrderKillViewController : FMViewController

@property (nonatomic, strong) NSMutableArray *shopDataSource;
//@property (nonatomic, copy) NSString *sess_id;
@property (nonatomic, strong) FMSelectShopInfoModel *shopDetailModel;
@property (nonatomic, strong) NSString *flag;
@end