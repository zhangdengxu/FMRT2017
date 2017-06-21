//
//  YSMyPartyModel.m
//  fmapp
//
//  Created by yushibo on 16/7/5.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "YSMyPartyModel.h"

@implementation YSMyPartyModel

- (instancetype)initWithDict:(NSDictionary *)dict{

    if(self = [super init]){
    
        self.party_theme = dict[@"party_theme"];
        self.party_timeslot = dict[@"party_timeslot"];
        self.party_adder = dict[@"party_adder"];
        self.party_labelArray = dict[@"party_label"];
        self.jieshu = dict[@"jieshu"];
        self.pid = dict[@"pid"];
        self.states = dict[@"state"];
    }
    
    return self;
}
@end
