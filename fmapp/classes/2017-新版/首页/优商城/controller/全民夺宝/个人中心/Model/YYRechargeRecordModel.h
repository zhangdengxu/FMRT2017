//
//  YYRechargeRecordModel.h
//  fmapp
//
//  Created by yushibo on 2016/11/10.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYRechargeRecordModel : NSObject
/** 交易标识  */
@property (nonatomic, strong) NSString *ID;
/** 交易时间，格式：时间戳（精确到秒）  */
@property (nonatomic, strong) NSString *deal_time;
/** 交易类型，0：兑换、1：消费  */
@property (nonatomic, strong) NSString *type;
/** 交易（兑换和消费）的夺宝币数量  */
@property (nonatomic, strong) NSString *coin;
/** 中获取或兑换夺宝币的渠道。交易类型为“兑换”的记录，此字段值不为空  */
@property (nonatomic, strong) NSString *trench;
/** 渠道的中文说明  */
@property (nonatomic, strong) NSString *trench_text;
/** 兑换夺宝币的筹码，交易类型为“兑换”的记录，且渠道为“积分”、“注资”、“购买”的记录，此字段值大于零  */
@property (nonatomic, strong) NSString *jetton;
/** 交易后剩余夺宝币的数量  */
@property (nonatomic, strong) NSString *balance;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end
