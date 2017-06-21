//
//  YYRechargeRecordModel.m
//  fmapp
//
//  Created by yushibo on 2016/11/10.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "YYRechargeRecordModel.h"

@implementation YYRechargeRecordModel
//- (void)setValue:(id)value forUndefinedKey:(NSString *)key{

//    if([key isEqualToString:@"id"])
//    {
//        self.ID=value;
//    }
//    
//}
-(instancetype)initWithDict:(NSDictionary *)dict
{
    
    if (self = [super init]) {
        
        self.ID =[NSString stringWithFormat:@"%@", dict[@"id"]];
        self.deal_time = [NSString stringWithFormat:@"%@", dict[@"deal_time"]];
        self.type = [NSString stringWithFormat:@"%@", dict[@"type"]];
        self.coin = [NSString stringWithFormat:@"%@", dict[@"coin"]];
        self.trench = [NSString stringWithFormat:@"%@", dict[@"trench"]];
        self.trench_text = [NSString stringWithFormat:@"%@", dict[@"trench_text"]];
        self.jetton = [NSString stringWithFormat:@"%@", dict[@"jetton"]];
        self.balance = [NSString stringWithFormat:@"%@", dict[@"balance"]];
        
    }
    return self;
}

@end
