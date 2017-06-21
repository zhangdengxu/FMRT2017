//
//  FMRTAucTool.m
//  fmapp
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTAucTool.h"
#import "FMRTAucDataModel.h"
#import "FMRTAucModel.h"
#import "FMCollModel.h"

@implementation FMRTAucTool

+(void)getAuctionShareDataWithFlag:(NSString *)flag success:(void(^)(FMRTAuctionShareModel *model))success failure:(void(^)(id object))failure{
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"tel":[CurrentUserInformation sharedCurrentUserInfo].mobile,
                                 @"flag":flag};
    
    NSString *testurl =[NSString stringWithFormat:@"%@/public/other/getShareInfo",kXZTestEnvironment];
    
    
    //@"https://www.rongtuojinrong.com/java/public/other/getShareInfo"
    [FMHTTPClient postPath:testurl parameters:parameter completion:^(WebAPIResponse *response) {
        
        if (response.code==WebAPIResponseCodeSuccess) {
            
            NSDictionary * objectDic = [response.responseObject objectForKey:@"data"];
            
            FMRTAuctionShareModel *model = [[FMRTAuctionShareModel alloc]init];
            [model setValuesForKeysWithDictionary:objectDic];
            
            if (success) {
                success(model);
            }
        }else{
            
            if (failure) {
                failure([response.responseObject objectForKey:@"msg"]);
            }
            
        }
    }];

}

+(void)getAuctionDataWithSuccess:(void(^)(NSMutableArray *aucDataSource, NSMutableArray *topPhotoArr))success failure:(void(^)(id object))failure{
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"tel":[CurrentUserInformation sharedCurrentUserInfo].mobile};
    
    
    NSString *testurl =[NSString stringWithFormat:@"%@/public/show/getAuctionList",kXZTestEnvironment];
    
//@"https://www.rongtuojinrong.com/java/public/show/getAuctionList"
    
    [FMHTTPClient postPath:testurl parameters:parameter completion:^(WebAPIResponse *response) {
        
        if (response.code==WebAPIResponseCodeSuccess) {
            
            NSDictionary * objectDic = [response.responseObject objectForKey:@"data"];
            
//            NSLog(@"竞拍商品%@",objectDic);
            
            NSArray *auctionsBeanList = [objectDic objectForKey:@"auctions"];
            NSMutableArray *auData = [NSMutableArray array];
            for (NSDictionary *dic in auctionsBeanList) {
                FMRTAucFirstModel *model = [[FMRTAucFirstModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [auData addObject:model];
            }
            NSArray *userBeanList = [objectDic objectForKey:@"luck"];
            FMRTAucFirstModel *rModel = [[FMRTAucFirstModel alloc]init];
            for (NSDictionary *dic in userBeanList) {
                FMRankingModel *rankModel = [[FMRankingModel alloc]init];
                [rankModel setValuesForKeysWithDictionary:dic];
                [rModel.phoneTitles addObject:rankModel];
            }
            [auData addObject:rModel];
            
            id banner = [objectDic objectForKey:@"banner"];
            NSMutableArray *baData = [NSMutableArray array];
            if ([banner isKindOfClass:[NSArray class]]) {
                
                NSArray *arr = (NSArray *)banner;
                if (arr.count) {
                    baData = [NSMutableArray arrayWithArray:banner];
                }
            }
            
            if (success) {
                success(auData,baData);
            }
            
        }else{
            
            if (failure) {
                failure([response.responseObject objectForKey:@"msg"]);
            }
            
        }
    }];

}

+(void)getAucCurrentPriceWithArr:(NSMutableArray *)arr
                     successTask:(void (^)(NSURLSessionDataTask * successTask))successTask
                     failureTask:(void (^)(NSURLSessionDataTask * failureTask))failureTask
                         success:(void(^)(NSMutableArray *aucDataSource))success
                         failure:(void(^)(id object))failure{
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"tel":[CurrentUserInformation sharedCurrentUserInfo].mobile};
    
    
    NSString *testurl =[NSString stringWithFormat:@"%@/public/show/getMaxPrice",kXZTestEnvironment];
    

    //@"https://www.rongtuojinrong.com/java/public/show/getMaxPrice"
    [FMHTTPClient postPath:testurl parameters:parameter successTask:^(NSURLSessionDataTask *task) {
        successTask(task);
    } failureTask:^(NSURLSessionDataTask *task) {
        failureTask(task);
    } completion:^(WebAPIResponse *response) {
        
        if (response.code==WebAPIResponseCodeSuccess) {
            
            NSArray * objectArr = [response.responseObject objectForKey:@"data"];
            
//            NSLog(@"====上帝所动===%@",objectArr);
            
            for (int i = 0; i< arr.count - 1; i++) {
                
                FMRTAucFirstModel *model = arr[i];
                
                for (NSDictionary *dic in objectArr) {
                    
                    FMCollModel *priceModel = [[FMCollModel alloc]init];
                    [priceModel setValuesForKeysWithDictionary:dic];
                    
                    if ([model.auction_id intValue] == [priceModel.auction_id intValue]) {
                        

                        model.current_price = priceModel.current_price;
                        model.activity_state = priceModel.activity_state;

                    }
                }
            }

//            NSLog(@"====本人修改===%@",objectArr);

//            for (NSDictionary *dic in objectArr) {
//                    FMCollModel *priceModel = [[FMCollModel alloc]init];
//                    [priceModel setValuesForKeysWithDictionary:dic];
//
//                    for (int i = 0; i< arr.count - 1; i++) {
//                        FMRTAucFirstModel *model = arr[i];
//                        
//                        if ([model.auction_id intValue] == [priceModel.auction_id intValue]) {
//                            model.current_price = priceModel.current_price;
//                            model.activity_state = priceModel.activity_state;
//                        }
//                    }
//                }
                if (success) {
                    success(arr);
                }
        }else{
            if (failure) {
                failure([response.responseObject objectForKey:@"msg"]);
            }
        }
    }];
}

+(void)getRecommntDataWithPage:(NSInteger )page success:(void(^)(NSMutableArray *remData))success failure:(void(^)(id object))failure{
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"tel":[CurrentUserInformation sharedCurrentUserInfo].mobile,
                                 @"page":[NSString stringWithFormat:@"%ld", (long)page] };
    
    NSString *testurl =[NSString stringWithFormat:@"%@/public/comment/getCommentList",kXZTestEnvironment];
    
    
//@"https://www.rongtuojinrong.com/java/public/comment/getCommentList"
    
    
    [FMHTTPClient postPath:testurl parameters:parameter completion:^(WebAPIResponse *response) {
        
        if (response.code==WebAPIResponseCodeSuccess) {
            
            NSArray * objectDic = [response.responseObject objectForKey:@"data"];
            NSMutableArray *dataArr = [NSMutableArray array];
            for (NSDictionary *dic in objectDic) {
                FMRTAucModel *model = [[FMRTAucModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [dataArr addObject:model];
            }
            success(dataArr);
        }else{
            failure([response.responseObject objectForKey:@"msg"]);

        }
    }];
}

@end
