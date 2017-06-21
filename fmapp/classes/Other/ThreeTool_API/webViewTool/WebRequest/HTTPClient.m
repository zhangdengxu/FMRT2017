//
//  HTTPClient.m
//  FM_CZFW
//
//  Created by liyuhui on 14-4-14.
//  Copyright (c) 2013年 ETelecom. All rights reserved.
//

#import "HTTPClient.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSString+Extension.h"

//@interface HTTPClient ()
//@property (nonatomic, strong) AFHTTPRequestOperationManager *operationManager;
//@end

@implementation HTTPClient

+ (instancetype)sharedHTTPClient{
    
    static HTTPClient *_sharedHTTPClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedHTTPClient = [[self alloc]init];
    });
    return _sharedHTTPClient;
}



- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
     successTask:(void (^)(NSURLSessionDataTask * successTask))successTask
     failureTask:(void (^)(NSURLSessionDataTask * failureTask))failureTask
      completion:(WebAPIRequestCompletionBlock)completionBlock{
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kBaseAPIURL]];
    [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/xml",@"text/jcmd",@"text/html;charset=utf-8",nil]];
    
    [manager POST:path parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (successTask) {
            successTask(task);
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        if (httpResponse.statusCode == 200) {
            
            if (completionBlock) {
                completionBlock([WebAPIResponse responseWithUnserializedJSONDic:responseObject]);
            }
        } else {
            
            if (completionBlock) {
                completionBlock([WebAPIResponse responseWithCode:WebAPIResponseCodeNetError]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureTask) {
            failureTask(task);
        }
        if (completionBlock) {
            completionBlock([WebAPIResponse responseWithCode:WebAPIResponseCodeNetError]);
        }
    }];
}


- (NSURLSessionDataTask *)postReturnPath:(NSString *)path
                              parameters:(NSDictionary *)parameters
                              completion:(WebAPIRequestCompletionBlock)completionBlock{
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kBaseAPIURL]];
    
    
    [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/xml",@"text/jcmd",@"text/html;charset=utf-8",nil]];
    
    
    return [manager POST:path parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        if (httpResponse.statusCode == 200) {
            
            if (completionBlock) {
                completionBlock([WebAPIResponse responseWithUnserializedJSONDic:responseObject]);
            }
        } else {
            
            if (completionBlock) {
                completionBlock([WebAPIResponse responseWithCode:WebAPIResponseCodeNetError]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        Log(@"%@",error);
        if (completionBlock) {
            completionBlock([WebAPIResponse responseWithCode:WebAPIResponseCodeNetError]);
        }
    }];
}


- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
      completion:(WebAPIRequestCompletionBlock)completionBlock{
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kBaseAPIURL]];
    [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/xml",@"text/jcmd",@"text/html;charset=utf-8",nil]];
    
    
    
    [manager POST:path parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        if (httpResponse.statusCode == 200) {
            
            if (completionBlock) {
                WebAPIResponse * responseRet = [WebAPIResponse responseWithUnserializedJSONDic:responseObject];
                if (responseRet.responseObject) {
                    completionBlock(responseRet);
                }else
                {
                    [CurrentUserInformation sharedCurrentUserInfo].statusNetWork = 1;
                    NSString * pathUrl = [path retNetWorkCmdidWithKeyValue];
                    if (![path isEqualToString:pathUrl]) {
                        [self postChangeNetWorkPath:pathUrl parameters:parameters completion:completionBlock];
                    }else
                    {
                        completionBlock(responseRet);
                    }
                }
                
            }
        } else {
            // 保存恢复数据
            WebAPIResponse * responseRet = [WebAPIResponse responseWithCode:WebAPIResponseCodeNetError];
            if (!responseRet.responseObject) {
                [CurrentUserInformation sharedCurrentUserInfo].statusNetWork = 1;
                NSString * pathUrl = [path retNetWorkCmdidWithKeyValue];
                if (![path isEqualToString:pathUrl]) {
                    [self postChangeNetWorkPath:pathUrl parameters:parameters completion:completionBlock];
                }else
                {
                    completionBlock(responseRet);
                }
            }else
            {
                if (completionBlock) {
                    completionBlock([WebAPIResponse responseWithCode:WebAPIResponseCodeNetError]);
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        Log(@"%@",error);
        // 保存恢复数据
        WebAPIResponse * responseRet = [WebAPIResponse responseWithCode:WebAPIResponseCodeNetError];
        if (!responseRet.responseObject) {
            [CurrentUserInformation sharedCurrentUserInfo].statusNetWork = 1;
            NSString * pathUrl = [path retNetWorkCmdidWithKeyValue];
            if (![path isEqualToString:pathUrl]) {
                [self postChangeNetWorkPath:pathUrl parameters:parameters completion:completionBlock];
            }else
            {
                completionBlock(responseRet);
            }
        }else
        {
            if (completionBlock) {
                completionBlock([WebAPIResponse responseWithCode:WebAPIResponseCodeNetError]);
            }
        }
        
        
    }];
}

- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
     completion:(WebAPIRequestCompletionBlock)completionBlock{
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kBaseAPIURL]];
    [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/xml",nil]];
    
    [manager GET:path parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        if (httpResponse.statusCode == 200) {
            if (completionBlock) {
                WebAPIResponse * responseRet = [WebAPIResponse responseWithUnserializedJSONDic:responseObject];
                if (responseRet.responseObject) {
                    completionBlock(responseRet);
                }else
                {
                    
                    [CurrentUserInformation sharedCurrentUserInfo].statusNetWork = 1;
                    NSString * pathUrl = [path retNetWorkCmdidWithKeyValue];
                    if (![path isEqualToString:pathUrl]) {
                        [self getChangeNetWorkPath:pathUrl parameters:parameters completion:completionBlock];
                    }else
                    {
                        completionBlock(responseRet);
                    }
                }
                
            }
        } else {
            // 保存恢复数据
            WebAPIResponse * responseRet = [WebAPIResponse responseWithCode:WebAPIResponseCodeNetError];
            if (!responseRet.responseObject) {
                [CurrentUserInformation sharedCurrentUserInfo].statusNetWork = 1;
                NSString * pathUrl = [path retNetWorkCmdidWithKeyValue];
                if (![path isEqualToString:pathUrl]) {
                    [self getChangeNetWorkPath:pathUrl parameters:parameters completion:completionBlock];
                }else
                {
                    completionBlock(responseRet);
                }
            }else
            {
                if (completionBlock) {
                    completionBlock(responseRet);
                }
            }
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 保存恢复数据
        WebAPIResponse * responseRet = [WebAPIResponse responseWithCode:WebAPIResponseCodeNetError];
        if (!responseRet.responseObject) {
            [CurrentUserInformation sharedCurrentUserInfo].statusNetWork = 1;
            NSString * pathUrl = [path retNetWorkCmdidWithKeyValue];
            if (![path isEqualToString:pathUrl]) {
                [self getChangeNetWorkPath:pathUrl parameters:parameters completion:completionBlock];
            }else
            {
                completionBlock(responseRet);
            }
        }else
        {
            if (completionBlock) {
                completionBlock(responseRet);
            }
        }
    }];
}
//get请求
- (NSURLSessionDataTask *)getReturnPath:(NSString *)path
                             parameters:(NSDictionary *)parameters
                             completion:(WebAPIRequestCompletionBlock)completionBlock;
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kBaseAPIURL]];
    [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/xml",nil]];
    return [manager GET:path parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        if (httpResponse.statusCode == 200) {
            if (completionBlock) {
                completionBlock([WebAPIResponse responseWithUnserializedJSONDic:responseObject]);
            }
        } else {
            if (completionBlock) {
                completionBlock([WebAPIResponse responseWithCode:WebAPIResponseCodeNetError]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completionBlock) {
            
            completionBlock([WebAPIResponse responseWithCode:WebAPIResponseCodeNetError]);
        }
    }];
    
}

-(void)postPath:(NSString *)urlString requestImageDataUpload:(NSData *)imageData imageType:(NSString *)fileName withName:(NSString *)name parameters:(NSDictionary *)parameters completion:(WebAPIRequestCompletionBlock)completionBlock {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/xml",nil]];
    
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:imageData
                                    name:name
                                fileName:fileName
                                mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        if (httpResponse.statusCode == 200) {
            if (completionBlock) {
                
                completionBlock([WebAPIResponse responseWithUnserializedJSONDic:responseObject]);
            }
        } else {
            if (completionBlock) {
                
                completionBlock([WebAPIResponse responseWithCode:WebAPIResponseCodeNetError]);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (completionBlock) {
            
            completionBlock([WebAPIResponse responseWithCode:WebAPIResponseCodeNetError]);
        }
    }];
}
/**
 *  上传带图片的内容，允许多张图片上传（URL）POST
 *
 *  @param url                 网络请求地址
 *  @param images              要上传的图片数组（注意数组内容需是图片）
 *  @param parameter           图片数组对应的参数
 *  @param parameters          其他参数字典
 *  @param ratio               图片的压缩比例（0.0~1.0之间）
 *  @param succeedBlock        成功的回调
 *  @param failedBlock         失败的回调
 *  @param uploadProgressBlock 上传进度的回调
 */
-(void)startMultiPartUploadTaskWithURL:(NSString *)url
                           imagesArray:(NSArray *)images
                     parameterOfimages:(NSString *)parameter
                        parametersDict:(NSDictionary *)parameters
                      compressionRatio:(float)ratio
                          succeedBlock:(void(^)(id operation, id responseObject))succeedBlock
                           failedBlock:(void(^)(id operation, NSError *error))failedBlock
                   uploadProgressBlock:(void(^)(float uploadPercent,long long totalBytesWritten,long long totalBytesExpectedToWrite))uploadProgressBlock {
    
    //    if (images.count == 0) {
    //       NSLog(@"上传内容没有包含图片");
    //       return;
    //    }
    //    for (int i = 0; i < images.count; i++) {
    //        if (![images isKindOfClass:[UIImage class]]) {
    //            NSLog(@"images中第%d个元素不是UIImage对象",i+1);
    //            return;
    //        }
    //    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/xml",nil]];
    
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //根据当前系统时间生成图片名称
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        NSString *dateString = [formatter stringFromDate:date];
        for (int count = 0; count < images.count; count ++) {
            UIImage *image = images[count];
            NSString *fileName = [NSString stringWithFormat:@"%@%d.png",dateString,count];
            NSData *imageData;
            
            if (ratio > 0.0f && ratio < 1.0f) {
                imageData = UIImageJPEGRepresentation(image, ratio);
            }else{
                imageData = UIImageJPEGRepresentation(image, 1.0f);
            }
            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"%@[%d]",parameter,count] fileName:fileName mimeType:@"image/jpeg"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        CGFloat percent = uploadProgress.totalUnitCount * 1.0 / uploadProgress.completedUnitCount;
        uploadProgressBlock(percent,uploadProgress.totalUnitCount,uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succeedBlock(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failedBlock(task,error);
    }];
    
}


/**
 *  上传带图片的内容，允许多张图片上传（URL）POST
 *
 *  @param url                 网络请求地址
 *  @param images              要上传的图片数组（注意数组内容需是图片）
 *  @param parameter           图片数组对应的参数
 *  @param parameters          其他参数字典
 *  @param ratio               图片的压缩比例（0.0~1.0之间）
 *  @param succeedBlock        成功的回调
 *  @param failedBlock         失败的回调
 *  @param uploadProgressBlock 上传进度的回调
 */
- (void)startMultiPartUploadTaskWithURL:(NSString *)url
                            imagesArray:(NSArray *)images
                                   imgs:(NSString *)imgs
                      parameterOfimages:(NSString *)parameter
                         parametersDict:(NSDictionary *)parameters
                       compressionRatio:(float)ratio
                           succeedBlock:(void(^)(id operation, id responseObject))succeedBlock
                            failedBlock:(void(^)(id operation, NSError *error))failedBlock
                    uploadProgressBlock:(void(^)(float uploadPercent,long long totalBytesWritten,long long totalBytesExpectedToWrite))uploadProgressBlock {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/xml",nil]];
    
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //根据当前系统时间生成图片名称
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        NSString *dateString = [formatter stringFromDate:date];
        for (int count = 0; count < images.count; count ++) {
            UIImage *image = images[count];
            NSString *fileName = [NSString stringWithFormat:@"%@%d.png",dateString,count];
            NSData *imageData;
            
            if (ratio > 0.0f && ratio < 1.0f) {
                imageData = UIImageJPEGRepresentation(image, ratio);
            }else{
                imageData = UIImageJPEGRepresentation(image, 1.0f);
            }
            if (imgs) {
                [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"%@",imgs] fileName:fileName mimeType:@"image/jpeg"];
            }else {
                [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"%@[%d]",parameter,count] fileName:fileName mimeType:@"image/jpeg"];
            }
            
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        CGFloat percent = uploadProgress.totalUnitCount * 1.0 / uploadProgress.completedUnitCount;
        uploadProgressBlock(percent,uploadProgress.totalUnitCount,uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succeedBlock(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failedBlock(task,error);
    }];
    
}

//- (void)cancelTask {
//    [self cancel];
//}

-(void)postPath:(NSString *)urlString requestFileDataUpload:(NSData *)imageData imageType:(NSString *)fileName withName:(NSString *)name parameters:(NSDictionary *)parameters completion:(WebAPIRequestCompletionBlock)completionBlock {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/xml",nil]];
    
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:imageData
                                    name:name
                                fileName:fileName
                                mimeType:@"audio/amr"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        if (httpResponse.statusCode == 200) {
            if (completionBlock) {
                
                completionBlock([WebAPIResponse responseWithUnserializedJSONDic:responseObject]);
            }
        } else {
            if (completionBlock) {
                
                completionBlock([WebAPIResponse responseWithCode:WebAPIResponseCodeNetError]);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (completionBlock) {
            
            completionBlock([WebAPIResponse responseWithCode:WebAPIResponseCodeNetError]);
        }
    }];
}







#pragma -mark 为避免重复调用，需要特别写的方法


- (void)getChangeNetWorkPath:(NSString *)path
                  parameters:(NSDictionary *)parameters
                  completion:(WebAPIRequestCompletionBlock)completionBlock{
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kBaseAPIURL]];
    [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/xml",nil]];
    
    
    [manager GET:path parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        if (httpResponse.statusCode == 200) {
            if (completionBlock) {
                completionBlock([WebAPIResponse responseWithUnserializedJSONDic:responseObject]);
            }
        } else {
            if (completionBlock) {
                completionBlock([WebAPIResponse responseWithCode:WebAPIResponseCodeNetError]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (completionBlock) {
            completionBlock([WebAPIResponse responseWithCode:WebAPIResponseCodeNetError]);
        }
    }];
}



- (void)postChangeNetWorkPath:(NSString *)path
                   parameters:(NSDictionary *)parameters
                   completion:(WebAPIRequestCompletionBlock)completionBlock{
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kBaseAPIURL]];
    [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/xml",@"text/jcmd",@"text/html;charset=utf-8",nil]];
    
    
    
    [manager POST:path parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        if (httpResponse.statusCode == 200) {
            
            if (completionBlock) {
                completionBlock([WebAPIResponse responseWithUnserializedJSONDic:responseObject]);
            }
        } else {
            
            if (completionBlock) {
                completionBlock([WebAPIResponse responseWithCode:WebAPIResponseCodeNetError]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        Log(@"%@",error);
        // 保存恢复数据
        WebAPIResponse * responseRet = [WebAPIResponse responseWithCode:WebAPIResponseCodeNetError];
        if (completionBlock) {
            completionBlock(responseRet);
        }
    }];
}

@end
