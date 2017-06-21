//
//  WLDJQTABViewController.h
//  fmapp
//
//  Created by 秦秦文龙 on 16/8/10.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMViewController.h"
@class FMSelectShopInfoModel;
typedef void(^blockSupportTicket)(FMSelectShopInfoModel *modelShopInfo);
typedef void(^blockBottomButton)();
@interface WLDJQTABViewController : FMViewController
@property(strong,nonatomic)NSString *flag;
@property(strong,nonatomic)NSString *state;
@property(strong,nonatomic)NSString *tag;

@property (nonatomic, copy) blockSupportTicket  blockSupportTicket;
@property (nonatomic, copy) blockBottomButton  blockBottomButton;
@end

