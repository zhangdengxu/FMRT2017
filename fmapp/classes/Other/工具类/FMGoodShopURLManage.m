//
//  FMGoodShopURLManage.m
//  fmapp
//
//  Created by runzhiqiu on 16/5/13.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMGoodShopURLManage.h"

@implementation FMGoodShopURLManage



+(NSString *)getNewNetWorkURLWithBaseURL:(NSString *)baseUrl
{
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString *string = [NSString stringWithFormat:@"%@?appid=huiyuan&user_id=%@&shijian=%d&token=%@",baseUrl,[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow];
    
    
    NSString *retString = [NSString stringWithFormat:@"%@&from=rongtuoapp&tel=%@",string,[CurrentUserInformation sharedCurrentUserInfo].mobile];
    
    return retString;
}
+(NSString *)getNewNetWorkURLWithBaseData;
{
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString *string = [NSString stringWithFormat:@"&appid=huiyuan&user_id=%@&shijian=%d&token=%@",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow];
    
    NSString *retString = [NSString stringWithFormat:@"%@&from=rongtuoapp&tel=%@",string,[CurrentUserInformation sharedCurrentUserInfo].mobile];
    
    return retString;
}


@end
