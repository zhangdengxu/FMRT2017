//
//  HTTPClient+Interaction.m
//  FM_CZFW
//
//  Created by liyuhui on 14-4-14.
//  Copyright (c) 2014年 ETelecom. All rights reserved.
//

#import "HTTPClient+Interaction.h"

@implementation HTTPClient (Interaction)

- (void)getQuestionType:(NSUInteger)type
                                  pageIndex:(NSUInteger)pageIndex
                                   pageSize:(NSUInteger)pageSize
                                 completion:(WebAPIRequestCompletionBlock)completion
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    AddObjectForKeyIntoDictionary([NSNumber numberWithUnsignedInteger:pageIndex], kDataKeyPageIndex, parameters);
    AddObjectForKeyIntoDictionary([NSNumber numberWithUnsignedInteger:pageSize], kDataKeyPageSize, parameters);

    if (type==0)
    {
        return [self postPath:KLendLiebiaoURL
                   parameters:parameters
                   completion:completion];
    }
    else if (type==1)
    {
        return [self postPath:KLenddanbaoURL
                   parameters:parameters
                   completion:completion];
    }
    else if (type==2)
    {
        return [self postPath:KLenfDiyaURL
                   parameters:parameters
                   completion:completion];
    }
    else if(type==3)
    {
        return [self postPath:KLenZhaiquanURL
                   parameters:parameters
                   completion:completion];
    }
    else if(type==4)
    {
        
//        return [self postPath:@"lend/tjliebiaoxindeceshi"
//                   parameters:parameters
//                   completion:completion];
        
        //老版本首页推荐标
        
//        return [self postPath:KRecommendURL
//                   parameters:parameters
//                   completion:completion];
        
        
        return [self postPath:KProjectJingyingdai parameters:parameters completion:completion];
 
    }else if (type == 7)
    {
        return [self postPath:KLenfBaoliURL
                   parameters:parameters
                   completion:completion];
    }else{
    
        return [self getPath:@"https://www.rongtuojinrong.com/Rongtuoxinsoc/Lend/ baobeijihua" parameters:nil completion:completion];
        
    }

}
- (void)getQuestionId:(NSString *)projectId
                               completion:(WebAPIRequestCompletionBlock)completion
{
    if ([projectId length]<=0) {
        return ;
    }
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    AddObjectForKeyIntoDictionary(projectId, @"jie_id", parameters);
    return [self postPath:KProjectDetailURL
               parameters:parameters
               completion:completion];

}
- (void)getClaimAreaMoney:(NSUInteger)money
                         withEndDate:(NSInteger)endDate
                           withStyle:(NSInteger)style
                           withTitle:(NSInteger)title
                           pageIndex:(NSUInteger)pageIndex
                            pageSize:(NSUInteger)pageSize
                          completion:(WebAPIRequestCompletionBlock)completion
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    AddObjectForKeyIntoDictionary([NSNumber numberWithUnsignedInteger:pageIndex], kDataKeyPageIndex, parameters);
    AddObjectForKeyIntoDictionary([NSNumber numberWithUnsignedInteger:pageSize], kDataKeyPageSize, parameters);
    AddObjectForKeyIntoDictionary([NSNumber numberWithUnsignedInteger:money], @"jinershu", parameters);
    AddObjectForKeyIntoDictionary([NSNumber numberWithUnsignedInteger:endDate], @"qixianshu", parameters);
    AddObjectForKeyIntoDictionary([NSNumber numberWithUnsignedInteger:style], @"shouyishu", parameters);
    AddObjectForKeyIntoDictionary([NSNumber numberWithUnsignedInteger:title], @"leixingshu", parameters);
    

    return [self postPath:KLendZhaiquanURL
               parameters:parameters
               completion:completion];

 
}
- (void)getClaimId:(NSString *)claimId
                            completion:(WebAPIRequestCompletionBlock)completion
{
    if ([claimId length]<=0) {
        return ;
    }
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    AddObjectForKeyIntoDictionary(claimId, @"zhai_id", parameters);
    return [self postPath:KClaimAreaURL
               parameters:parameters
               completion:completion];
 
}
- (void)getClaimAreaUserId:(NSString *)userId
                                   withProject:(NSInteger)projectType
                                     withTouzi:(NSInteger)TouziType
                                 withZhuanrang:(NSInteger)zhanrangType
                                     pageIndex:(NSUInteger)pageIndex
                                      pageSize:(NSUInteger)pageSize
                                    completion:(WebAPIRequestCompletionBlock)completion
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    AddObjectForKeyIntoDictionary([NSNumber numberWithUnsignedInteger:pageIndex], kDataKeyPageIndex, parameters);
    AddObjectForKeyIntoDictionary([NSNumber numberWithUnsignedInteger:pageSize], kDataKeyPageSize, parameters);
    AddObjectForKeyIntoDictionary(userId, @"user_id", parameters);
    AddObjectForKeyIntoDictionary([NSNumber numberWithUnsignedInteger:projectType], @"xmlx", parameters);
    AddObjectForKeyIntoDictionary([NSNumber numberWithUnsignedInteger:TouziType], @"txlx", parameters);
    AddObjectForKeyIntoDictionary([NSNumber numberWithUnsignedInteger:zhanrangType], @"zrzt", parameters);
    
    Log(@"%@",parameters);
    return [self postPath:KMyClaimURL
               parameters:parameters
               completion:completion];
 
}
- (void)getClaimAreaUserId:(NSString *)userId
                                   withProject:(NSInteger)projectType
                                     withTouzi:(NSInteger)TouziType
                                 withZhuanrang:(NSInteger)zhanrangType
                              WithjiezhuangTai:(NSInteger)JiezhuangtaiType
                                     pageIndex:(NSUInteger)pageIndex
                                      pageSize:(NSUInteger)pageSize
                                    completion:(WebAPIRequestCompletionBlock)completion
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    AddObjectForKeyIntoDictionary([NSNumber numberWithUnsignedInteger:pageIndex], kDataKeyPageIndex, parameters);
    AddObjectForKeyIntoDictionary([NSNumber numberWithUnsignedInteger:pageSize], kDataKeyPageSize, parameters);
    AddObjectForKeyIntoDictionary(userId, @"user_id", parameters);
    AddObjectForKeyIntoDictionary([NSNumber numberWithUnsignedInteger:projectType], @"xmlx", parameters);
    AddObjectForKeyIntoDictionary([NSNumber numberWithUnsignedInteger:TouziType], @"txlx", parameters);

    AddObjectForKeyIntoDictionary([NSNumber numberWithUnsignedInteger:JiezhuangtaiType], @"jkzhuangtai", parameters);
    
    Log(@"%@",parameters);
    return [self postPath:KMyClaimURL
               parameters:parameters
               completion:completion];
    
}

@end
