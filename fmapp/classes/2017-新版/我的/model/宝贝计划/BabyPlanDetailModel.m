//
//  BabyPlanDetailModel.m
//  fmapp
//
//  Created by runzhiqiu on 16/1/4.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "BabyPlanDetailModel.h"

@implementation BabyPlanDetailModel

+(instancetype)babyPlayDetailModelCreateWithDictionary:(NSDictionary *)dict;
{
    BabyPlanDetailModel * planDetail = [[BabyPlanDetailModel alloc]init];
        
    planDetail.xiugaianniu = [dict objectForKey:@"xiugaianniu"];
    
    planDetail.Jiner = [dict objectForKey:@"jiner"];
    
    planDetail.biaoti = [dict objectForKey:@"biaoti"];
    
    planDetail.zongshu = [dict objectForKey:@"zongshu"];
    
    planDetail.yitoushu = [dict objectForKey:@"yitoushu"];
    
    planDetail.yizhuan = [dict objectForKey:@"yizhuan"];
    
    planDetail.mytouziri = [dict objectForKey:@"mytouziri"];
    
    planDetail.cunkuanri = [dict objectForKey:@"cunkuanri"];
    
    planDetail.Zhuangtai = [dict objectForKey:@"zhuangtai"];
    
    planDetail.jilu_id = [dict objectForKey:@"jilu_id"];
    
    planDetail.jiekuaninfo = [dict objectForKey:@"jiekuaninfo"];
    
    planDetail.jie_id = [dict objectForKey:@"jie_id"];
    
    planDetail.autot_id = [dict objectForKey:@"autot_id"];
    
    planDetail.endisornot = [dict objectForKey:@"endisornot"];
    return planDetail;
}
@end


@implementation BabyPlanTitleModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end

