//
//  WXModel.m
//  fmapp
//
//  Created by runzhiqiu on 16/3/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#define KAPPIDWX @"wx72172d3ee537c648"
#define KMCH_IDWX @"1323970501"
#define KSpbill_create_ipWX @"192.168.1.1"
#define KTrade_typeWX @"APP"
#define KKEYWITHSHANGHU @"wx72172d3ee537c648wx72172d3ee537"

#import "WXModel.h"
#import "NSString+Hash.h"
@implementation WXModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.appid = KAPPIDWX;
        self.mch_id = KMCH_IDWX;
        self.spbill_create_ip = KSpbill_create_ipWX;
        self.trade_type = KTrade_typeWX;
        self.keyShanghu = KKEYWITHSHANGHU;
        self.nonce_str = [self retNonceString];
//        self.sign = [self retSignWithWx];
        
    }
    return self;
}

-(NSString *)retNonceString
{
    NSDate * dateStr = [NSDate date];
    Log(@"%@",dateStr);
    NSString * nonceStrOld;
    if (self.out_trade_no) {
         nonceStrOld = [NSString stringWithFormat:@"%@%@%@",dateStr,@"1323970501",self.out_trade_no];
    }else
    {
        nonceStrOld = [NSString stringWithFormat:@"%@%@",dateStr,@"1323970501"];
    }
    
    NSString * nonceStr = nonceStrOld.md5String;
    return nonceStr;
}
-(int)retTimeStampInfo
{
    return [[NSDate date]timeIntervalSince1970];
}
-(void)retSignWithWx
{
    NSString * stringA = [NSString stringWithFormat:@"appid=%@&body=%@&mch_id=%@&nonce_str=%@&notify_url=%@&out_trade_no=%@&spbill_create_ip=%@&total_fee=%@&trade_type=%@",self.appid,self.boby,self.mch_id,self.nonce_str,self.notify_url,self.out_trade_no,self.spbill_create_ip,self.total_fee,self.trade_type];
    
    NSString * stringSignTemp=[NSString stringWithFormat:@"%@&key=%@",stringA,self.keyShanghu];
    
    NSString * currentSign = stringSignTemp.md5String.uppercaseString;
    
    
    self.sign = currentSign;
    
}

@end
