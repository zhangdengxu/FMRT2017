//
//  HTTPClient+ExploreModules.h
//  fmapp
//
//  Created by 张利广 on 14-5-28.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#import "HTTPClient.h"


@interface HTTPClient (ExploreModules)

- (void)getLetterId:(NSString *)letterId
                            letterStyle:(NSString *)style
                                  pageIndex:(NSUInteger)pageIndex
                                   pageSize:(NSUInteger)pageSize
                                 completion:(WebAPIRequestCompletionBlock)completion;
- (void)getShouyiquxianWithUserId:(NSString *)userId
                             completion:(WebAPIRequestCompletionBlock)completion;

- (void)getMyShouyiWithUserId:(NSString *)userId
                                     WithUserName:(NSString *)userName
                                           completion:(WebAPIRequestCompletionBlock)completion;

///实名认证获取数据
- (void)getAuthenticateWithUserId:(NSString *)userId
                                                    completion:(WebAPIRequestCompletionBlock)completion;
///实名认证提交数据
- (void)AuthenticateWithUserId:(NSString *)userId
                                      withUserName:(NSString *)userName
                                    WithUserIdCard:(NSString *)userIdCard
                                        completion:(WebAPIRequestCompletionBlock)completion;

- (void)getRongZiQiXianWithcompletion:(WebAPIRequestCompletionBlock)completion;

- (void)getRongZiFangShiWithcompletion:(WebAPIRequestCompletionBlock)completion;

- (void)borrowWithUserId:(NSDictionary *)dic
                                           completion:(WebAPIRequestCompletionBlock)completion;
- (void)FeedBackWithUserId:(NSDictionary *)dic
                                  completion:(WebAPIRequestCompletionBlock)completion;

- (void)DidReadMessageId:(NSString *)messageId
                                    completion:(WebAPIRequestCompletionBlock)completion;

@end
