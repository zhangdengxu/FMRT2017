//
//  YSSignModel.m
//  fmapp
//
//  Created by yushibo on 16/7/7.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "YSSignModel.h"

@implementation YSSignModel
- (instancetype)initWithDict:(NSDictionary *)dict{

    if (self = [super init]) {
        self.party_theme = dict[@"party_theme"];
        self.party_timelist = dict[@"party_timelist"];
        self.party_joinstatus = dict[@"party_joinstatus"];
        self.party_initiator = dict[@"party_initiator"];
        self.party_address = dict[@"party_address"];
        self.pid = dict[@"pid"];
        self.phone = dict[@"phone"];
    }
    return self;

}
@end
