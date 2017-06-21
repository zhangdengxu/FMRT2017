//
//  FMMonthAddReduceModel.m
//  fmapp
//
//  Created by runzhiqiu on 16/7/8.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMMonthAddReduceModel.h"

@implementation FMMonthAddReduceModel

-(void)setFMMonthAddReduceModelWithDictionary:(NSDictionary *)dict;
{
    if (dict) {
        self.month = [NSString stringWithFormat:@"%@",dict[@"Month"]];
        self.shouzhicha = [NSString stringWithFormat:@"%@",dict[@"shouzhicha"]];
        self.shouru = [NSString stringWithFormat:@"%@",dict[@"shouru"]];
        self.zhichu = [NSString stringWithFormat:@"%@",dict[@"zhichu"]];

    }
}

@end


@implementation FMMonthAddReduceModelBottom




@end



