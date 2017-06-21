//
//  WXModel.h
//  fmapp
//
//  Created by runzhiqiu on 16/3/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXModel : NSObject

@property (nonatomic,copy) NSString *appid;

@property (nonatomic,copy) NSString *mch_id;

@property (nonatomic,copy) NSString *nonce_str;

@property (nonatomic,copy) NSString *sign;

@property (nonatomic,copy) NSString *boby;

@property (nonatomic,copy) NSString *out_trade_no;

@property (nonatomic,copy) NSString *total_fee;

@property (nonatomic,copy) NSString *spbill_create_ip;

@property (nonatomic,copy) NSString *notify_url;

@property (nonatomic,copy) NSString *trade_type;

@property (nonatomic,copy) NSString *keyShanghu;

@property (nonatomic,copy) NSString *ret_notify;
@property (nonatomic,copy) NSString *endTime;


@property (nonatomic, assign) NSInteger type;

-(void)retSignWithWx;
-(NSString *)retNonceString;
-(int)retTimeStampInfo;

@end

