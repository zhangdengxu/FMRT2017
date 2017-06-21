//
//  FMUnclearModel.m
//  fmapp
//
//  Created by apple on 16/4/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMUnclearModel.h"

@implementation FMUnclearModel


-(instancetype)initWithDict:(NSDictionary *)dict{
    
    if (self = [super init]){
        
        self.size = dict[@"size"];
        self.color = dict[@"color"];
 
    }
    return  self;
}

@end
