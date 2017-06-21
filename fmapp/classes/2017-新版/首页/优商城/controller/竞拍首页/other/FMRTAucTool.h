//
//  FMRTAucTool.h
//  fmapp
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMRTAuctionShareModel.h"

@interface FMRTAucTool : NSObject

+(void)getAuctionDataWithSuccess:(void(^)(NSMutableArray *aucDataSource, NSMutableArray *topPhotoArr))success failure:(void(^)(id object))failure;

+(void)getAucCurrentPriceWithArr:(NSMutableArray *)arr
                     successTask:(void (^)(NSURLSessionDataTask * successTask))successTask
                     failureTask:(void (^)(NSURLSessionDataTask * failureTask))failureTask
                         success:(void(^)(NSMutableArray *aucDataSource))success
                         failure:(void(^)(id object))failure;

+(void)getRecommntDataWithPage:(NSInteger )page success:(void(^)(NSMutableArray *remData))success failure:(void(^)(id object))failure;

+(void)getAuctionShareDataWithFlag:(NSString *)flag success:(void(^)(FMRTAuctionShareModel *model))success failure:(void(^)(id object))failure;

@end
