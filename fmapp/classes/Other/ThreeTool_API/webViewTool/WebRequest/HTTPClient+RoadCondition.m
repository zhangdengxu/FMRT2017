//
//  HTTPClient+Interaction.m
//  FM_CZFW
//
//  Created by liyuhui on 14-4-14.
//  Copyright (c) 2014年 ETelecom. All rights reserved.
//

#import "HTTPClient+RoadCondition.h"

@implementation HTTPClient (RoadCondition)

- (void)getFirstViewTopImagesWithcompletion:(WebAPIRequestCompletionBlock)completion
{
    return [self postPath:KLunBoPicURL
               parameters:nil
               completion:completion];
}
- (void)getLingQianGuanWithcompletion:(WebAPIRequestCompletionBlock)completion
{
    return [self postPath:KFirstLingURL
               parameters:nil
               completion:completion];
}
- (void)getLingAlerDataWithcompletion:(WebAPIRequestCompletionBlock)completion
{
    return [self postPath:KAlerDataURL
               parameters:nil
               completion:completion];
}
- (void)getMyLingQianGuanWithcompletion:(WebAPIRequestCompletionBlock)completion
{
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    AddObjectForKeyIntoDictionary([CurrentUserInformation sharedCurrentUserInfo].userId, @"user_id", parameters); 
    return [self postPath:KlingqianguanURL
               parameters:parameters
               completion:completion];
}



@end
