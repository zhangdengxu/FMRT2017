//
//  XZMyOrderModel.m
//  fmapp
//
//  Created by admin on 16/5/20.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "XZMyOrderModel.h"

@implementation FMOrderDetailLocationModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

-(void)createDataSourceWithDictionary:(NSDictionary *)dict;
{
    if (dict) {
        self.peopleGoods = [NSString stringWithFormat:@"收货人：%@", dict[@"name"]];
        self.mobile = dict[@"mobile"];
        self.postcode = dict[@"email"];
        self.locationString = [NSString stringWithFormat:@"收货地址：%@%@",dict[@"area"],dict[@"addr"]];
    }
}

@end

@implementation FMOrderDetailGoodsModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end




@implementation XZMyOrderModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

/**
pay_status;
ship_status;
status;
havecomment
waitdiscuss
aftersales_status
*/
//orderStatusFM
-(void)setOederStatusWithOrderInfo;
{
    
    if (![self.status isEqualToString:@"dead"]) {
        //交易处于活动中
    
        //是否申请售后状态
        if ([self.aftersales_status isEqualToString:@"0"]) {
            //交易未申请售后
            
            //是否评论
            if ([self.havecomment isEqualToString:@"0"]) {
                //还没有评论
                
                //是否待评价
                if ([self.waitdiscuss isEqualToString:@"0"]) {
                    //未到待评价状态
                    
                    //是否发货
                    if ([self.ship_status isEqualToString:@"0"]) {
                        //卖家未发货
                        
                        //是否付款
                        if ([self.pay_status isEqualToString:@"0"]) {
                            //买家未付款
                            self.orderStatusFM = 61;
                        }else
                        {
                            //买家已付款，但还未发货
                            self.orderStatusFM = 51;
                        }
                        
                    }else
                    {
                        //卖家发货但用户还未收到货
                        self.orderStatusFM = 41;
                    }
                    
                }else
                {
                    //待评价状态
                    self.orderStatusFM = 31;
                }
                
            }else
            {
                //用户已评价,交易成功
                self.orderStatusFM = 21;
            }
            
        }else
        {
         //交易已申请售后
            
            if ([self.aftersales_status isEqualToString:@"4"] ||[self.aftersales_status isEqualToString:@"5"] || [self.aftersales_status isEqualToString:@"9"] || [self.pay_status isEqualToString:@"4"] || [self.pay_status isEqualToString:@"5"] ) {
                // 申请售后结束
                self.orderStatusFM = 12;
            }else
            {
                // 售后申请中
                self.orderStatusFM = 11;
            }
        }
    }else
    {
        //交易关闭  ===》  1
        self.orderStatusFM = 1;
    }
}
@end



@implementation FMOrderAddress
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end
