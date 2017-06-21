//
//  YSFootPrintModel.m
//  fmapp
//
//  Created by yushibo on 16/7/7.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "YSFootPrintModel.h"

@implementation YSFootPrintModel
- (instancetype)initWithDict:(NSDictionary *)dict{

    if (self = [super init]) {
        self.party_actname = dict[@"party_actname"];
        self.party_theme = dict[@"party_theme"];
        self.party_time = dict[@"party_time"];
    }

    return self;
}
@end
