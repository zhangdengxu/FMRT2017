//
//  YSSpikeRuleModel.m
//  fmapp
//
//  Created by yushibo on 16/8/10.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "YSSpikeRuleModel.h"

@implementation YSSpikeRuleModel

-(instancetype)initWithDict:(NSDictionary *)dict{
    
    if (self = [super init]){
        self.content = dict[@"content"];
    }
    return  self;
}

@end
