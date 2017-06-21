//
//  FMTimeKillShopModel.m
//  fmapp
//
//  Created by runzhiqiu on 16/8/9.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMTimeKillShopModel.h"

@implementation FMTimeKillShopModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
-(void)changeBaseCount;
{
    NSInteger timestamp = [[NSDate date] timeIntervalSince1970];
    
    
    
  
    NSInteger beginTime = [self.begin_time integerValue];
    self.baseCount = beginTime - timestamp;
    
    NSInteger endTime = [self.end_time integerValue];
    self.toEndTime = endTime - beginTime;
    
}

- (NSDate *)tDate
{
    NSDate *date = [NSDate date];
//    NSLog(@"&&&&&&&&&&>%@",date);
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    return [date  dateByAddingTimeInterval: interval];

}

@end

@implementation FMTimeKillShopSectionHeaderModel



@end

@implementation FMTimeKillShopSectionRefreshModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end

