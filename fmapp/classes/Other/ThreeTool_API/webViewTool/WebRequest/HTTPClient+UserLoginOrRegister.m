//
//  HTTPClient+UserLoginOrRegister.m
//  fmapp
//
//  Created by 张利广 on 14-5-15.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#import "HTTPClient+UserLoginOrRegister.h"
#import "OpenUDID.h"

@implementation HTTPClient (UserLoginOrRegister)

- (void)getUserRegisterWithUserPersonalPhoneNumber:(NSString *)m_userPhoneNumber
                                                              WithType:(NSInteger)type
                                                            completion:(WebAPIRequestCompletionBlock)completion
{
    
    
    
    if (!IsNormalMobileNum(m_userPhoneNumber)) {
        return ;
    }
    
    
    
    NSDictionary *parameters = @{@"tel": m_userPhoneNumber,@"leixing":[NSNumber numberWithInteger:type]};
    return [self postPath:KUserFatelcodeURL
               parameters:parameters
               completion:completion];

}
///验证手机验证码（注册时）
- (void)getUserRegisterWithUserPersonalPhoneNumber:(NSString *)m_userPhoneNumber       WithCode:(NSString *)code
                                                              WithType:(NSInteger)type
                                                            completion:(WebAPIRequestCompletionBlock)completion
{
    NSDictionary *parameters = @{@"tel": m_userPhoneNumber,@"sjcode":code,@"leixing":[NSNumber numberWithInteger:type]};
    return [self postPath:KUserCktelcode
               parameters:parameters
               completion:completion];
  
}
///注册
- (void)getUserRegisterWithUserWithUserName:(NSString *)userName WithPassword:(NSString *)password WithSecondPassword:(NSString *)spassword PersonalPhoneNumber:(NSString *)m_userPhoneNumber   withRecommendPeople:(NSString *)recommendStr
                                                     completion:(WebAPIRequestCompletionBlock)completion
{
    NSDictionary *parameters=nil;
    NSString    *openUDIDString = [[NSString alloc]initWithFormat:@"%@",[OpenUDID value]];

    if(IsStringEmptyOrNull(recommendStr))
    {
    parameters = @{@"user_name":userName,@"password1":password,@"password2":spassword,@"tel": m_userPhoneNumber,@"imei":openUDIDString};
    }
    else
    {
    parameters = @{@"user_name":userName,@"password1":password,@"password2":spassword,@"tel": m_userPhoneNumber,@"tuijianren":recommendStr,@"imei":openUDIDString};
    }
    return [self postPath:KUserRegisterURL
               parameters:parameters
               completion:completion];
  
}

//新的注册  ---  未写死
- (void)getUserRegisterNewWithUserWithUserName:(NSString *)yanzheng WithPassword:(NSString *)password WhithLeixing:(NSString *)leixing PersonalPhoneNumber:(NSString *)m_userPhoneNumber imei:(NSString *)imei withRecommendPeopleNOUserID:(NSString *)recommendStrNOUserID completion:(WebAPIRequestCompletionBlock)completion
{
    NSDictionary *parameters=nil;

   
    parameters = @{@"sjcode":yanzheng,
                   @"password1":password,
                   @"leixing":leixing,
                   @"tel": m_userPhoneNumber,
                   @"imei":imei,
                   @"tuijianren":recommendStrNOUserID};
    return [self postPath:KUserRegisterxindeURL
               parameters:parameters
               completion:completion];
    
}
///找回密码
- (void)getUserFindPasswordWithUserWithDic:(NSDictionary *)parameters   completion:(WebAPIRequestCompletionBlock)completion
{
    return [self postPath:KUserFindPassWordURL
               parameters:parameters
               completion:completion];
}
- (void)getUserLoginInforWithUser:(NSString *)userName
                                     withUserPassword:(NSString *)userPassword
                                           completion:(WebAPIRequestCompletionBlock)completion
{
    NSString    *openUDIDString = [[NSString alloc]initWithFormat:@"%@",[OpenUDID value]];
    

    NSDictionary *parameters = @{@"user_name": userName,@"password":userPassword,@"imei":openUDIDString,@"laiyuan":@1};
//    NSLog(@"===>%@",parameters);
    return [self postPath:KUserLoginURL
               parameters:parameters
               completion:completion];
 
}

- (void)sendCodeWithUserPersonalPhoneNumber:(NSString *)m_userPhoneNumber
                                                           type:(NSInteger)type
                                                     completion:(WebAPIRequestCompletionBlock)completion;

{
    NSDictionary *parameters = @{@"tel": m_userPhoneNumber,@"leixing":[NSNumber numberWithInteger:type]};
    return [self postPath:KUserFatelcodeURL
               parameters:parameters
               completion:completion];

}
- (void)confirmCodeWithUserPersonalPhoneNumber:(NSString *)m_userPhoneNumber       WithCode:(NSString *)code
                                                        WithUserId:(NSString *)userId
                                                        completion:(WebAPIRequestCompletionBlock)completion
{
    NSDictionary *parameters = @{@"tel": m_userPhoneNumber,@"sjcode":code,@"user_id":userId};
    return [self postPath:KUserCkoldshoujiURL
               parameters:parameters
               completion:completion];
}
- (void)changeTelWithUserPersonalPhoneNumber:(NSString *)m_userPhoneNumber       WithCode:(NSString *)code
                                                      completion:(WebAPIRequestCompletionBlock)completion
{
    NSString *userId=[CurrentUserInformation sharedCurrentUserInfo].userId;
    NSDictionary *parameters = @{@"tel": m_userPhoneNumber,@"sjcode":code,@"user_id":userId};
    return [self postPath:KUserCktelcodeURL
               parameters:parameters
               completion:completion];
}







- (void)getUserRegisterNewWithUserWithUserName:(NSString *)yanzheng WithPassword:(NSString *)password WhithLeixing:(NSString *)leixing PersonalPhoneNumber:(NSString *)m_userPhoneNumber imei:(NSString *)imei withRecommendPeople:(NSString *)recommendStr completion:(WebAPIRequestCompletionBlock)completion
{
    NSDictionary *parameters=nil;
    //        NSString    *openUDIDString = [[NSString alloc]initWithFormat:@"%@",[OpenUDID value]];
    
    //    if(IsStringEmptyOrNull(recommendStr)){
    //
    //        parameters = @{@"sjcode":yanzheng,@"password1":password,@"leixing":leixing,@"tel": m_userPhoneNumber,@"imei":imei};
    //        NSLog(@"--------->%@",parameters);
    //    }else{
    parameters =
    @{@"sjcode":yanzheng,@"password1":password,@"leixing":leixing,@"tel": m_userPhoneNumber,@"tuijianren":recommendStr,@"imei":imei,@"tuijianrenuser_id":@"174"};
    Log(@"--------->%@",parameters);
    //    }
    
    return [self postPath:KUserRegisterxindeURL
               parameters:parameters
               completion:completion];
    
}


//调用企业版最新＊＊＊
- (void)getUserRegisterNewWithUserWithUserName:(NSString *)yanzheng WithPassword:(NSString *)password WhithLeixing:(NSString *)leixing PersonalPhoneNumber:(NSString *)m_userPhoneNumber imei:(NSString *)imei withRecommendPeople:(NSString *)recommendStr recommendUserID:(NSString *)recommendUserID completion:(WebAPIRequestCompletionBlock)completion
{
    NSDictionary *parameters=nil;
    parameters = @{
                   @"sjcode":yanzheng,
                   @"password1":password,
                   @"leixing":leixing,
                   @"tel": m_userPhoneNumber,
                   @"tuijianren":recommendStr,
                   @"imei":imei,
                   @"tuijianrenuser_id":recommendUserID
                   };

    
    return [self postPath:KUserRegisterxindeURL
               parameters:parameters
               completion:completion];
    
}



@end
