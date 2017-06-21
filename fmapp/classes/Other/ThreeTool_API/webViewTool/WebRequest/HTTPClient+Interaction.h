//
//  HTTPClient+Interaction.h
//  FM_CZFW
//
//  Created by liyuhui on 14-4-14.
//  Copyright (c) 2014年 ETelecom. All rights reserved.
//

#import "HTTPClient.h"

@interface HTTPClient (Interaction)

- (void)getQuestionType:(NSUInteger)type
                                  pageIndex:(NSUInteger)pageIndex
                                   pageSize:(NSUInteger)pageSize
                                 completion:(WebAPIRequestCompletionBlock)completion;

- (void)getQuestionId:(NSString *)projectId
                                 completion:(WebAPIRequestCompletionBlock)completion;


- (void)getClaimAreaMoney:(NSUInteger)money
                         withEndDate:(NSInteger)endDate
                           withStyle:(NSInteger)style
                           withTitle:(NSInteger)title
                                  pageIndex:(NSUInteger)pageIndex
                                   pageSize:(NSUInteger)pageSize
                                 completion:(WebAPIRequestCompletionBlock)completion;

- (void)getClaimId:(NSString *)claimId
                               completion:(WebAPIRequestCompletionBlock)completion;

- (void)getClaimAreaUserId:(NSString *)userId
                                  withProject:(NSInteger)projectType
                                    withTouzi:(NSInteger)TouziType
                                    withZhuanrang:(NSInteger)zhanrangType
                                    pageIndex:(NSUInteger)pageIndex
                                     pageSize:(NSUInteger)pageSize
                                   completion:(WebAPIRequestCompletionBlock)completion;
- (void)getClaimAreaUserId:(NSString *)userId
                                   withProject:(NSInteger)projectType
                                     withTouzi:(NSInteger)TouziType
                                 withZhuanrang:(NSInteger)zhanrangType
                              WithjiezhuangTai:(NSInteger)JiezhuangtaiType
                                     pageIndex:(NSUInteger)pageIndex
                                      pageSize:(NSUInteger)pageSize
                                    completion:(WebAPIRequestCompletionBlock)completion;

@end