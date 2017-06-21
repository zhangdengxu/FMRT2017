//
//  HTTPClient+UserLoginOrRegister.h
//  fmapp
//
//  Created by 张利广 on 14-5-15.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#import "HTTPClient.h"

@interface HTTPClient (UserLoginOrRegister)
///发送验证码（注册时）
- (void)getUserRegisterWithUserPersonalPhoneNumber:(NSString *)m_userPhoneNumber
                                                              WithType:(NSInteger)type
                                                            completion:(WebAPIRequestCompletionBlock)completion;
///验证手机验证码（注册时）
- (void)getUserRegisterWithUserPersonalPhoneNumber:(NSString *)m_userPhoneNumber       WithCode:(NSString *)code
                                                              WithType:(NSInteger)type
                                                            completion:(WebAPIRequestCompletionBlock)completion;
///注册
- (void)getUserRegisterWithUserWithUserName:(NSString *)userName WithPassword:(NSString *)password WithSecondPassword:(NSString *)spassword PersonalPhoneNumber:(NSString *)m_userPhoneNumber   withRecommendPeople:(NSString *)recommendStr
                                                            completion:(WebAPIRequestCompletionBlock)completion;

//新的注册
- (void)getUserRegisterNewWithUserWithUserName:(NSString *)yanzheng WithPassword:(NSString *)password WhithLeixing:(NSString *)leixing PersonalPhoneNumber:(NSString *)m_userPhoneNumber imei:(NSString *)imei withRecommendPeopleNOUserID:(NSString *)recommendStrNOUserID completion:(WebAPIRequestCompletionBlock)completion;



///登录
- (void)getUserLoginInforWithUser:(NSString *)userName
                                     withUserPassword:(NSString *)userPassword
                                                                       completion:(WebAPIRequestCompletionBlock)completion;
///找回密码
- (void)getUserFindPasswordWithUserWithDic:(NSDictionary *)parameters   completion:(WebAPIRequestCompletionBlock)completion;



///修改手机

- (void)sendCodeWithUserPersonalPhoneNumber:(NSString *)m_userPhoneNumber
                                                           type:(NSInteger)type
                                                            completion:(WebAPIRequestCompletionBlock)completion;

- (void)confirmCodeWithUserPersonalPhoneNumber:(NSString *)m_userPhoneNumber       WithCode:(NSString *)code
                                                              WithUserId:(NSString *)userId
                                                            completion:(WebAPIRequestCompletionBlock)completion;
- (void)changeTelWithUserPersonalPhoneNumber:(NSString *)m_userPhoneNumber       WithCode:(NSString *)code
                                                        completion:(WebAPIRequestCompletionBlock)completion;



/**
 *  企业版专用方法  ***已作废
 */
- (void)getUserRegisterNewWithUserWithUserName:(NSString *)yanzheng WithPassword:(NSString *)password WhithLeixing:(NSString *)leixing PersonalPhoneNumber:(NSString *)m_userPhoneNumber imei:(NSString *)imei withRecommendPeople:(NSString *)recommendStr completion:(WebAPIRequestCompletionBlock)completion;

//调用企业版最新＊＊＊
- (void)getUserRegisterNewWithUserWithUserName:(NSString *)yanzheng WithPassword:(NSString *)password WhithLeixing:(NSString *)leixing PersonalPhoneNumber:(NSString *)m_userPhoneNumber imei:(NSString *)imei withRecommendPeople:(NSString *)recommendStr recommendUserID:(NSString *)recommendUserID completion:(WebAPIRequestCompletionBlock)completion;

@end
