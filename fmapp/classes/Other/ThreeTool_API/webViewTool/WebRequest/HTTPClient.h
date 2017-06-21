//
//  HTTPClient.h
//  FM_CZFW
//
//  Created by liyuhui on 14-4-14.
//  Copyright (c) 2014年 ETelecom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "WebAPIDefine.h"
#import "WebAPIResponse.h"
#import "FMStrings.h"
#import "FMFunctions.h"
#import "WebAPIDefine.h"

//定义网络错误提示信息
#define NETERROR_LOADERR_TIP                   @"读取失败"
#define NETERROR_SENDINGSUCCESS_TIP            @"验证码输入成功请设置密码"
#define NETERROR_LOADERR_NETWORKHARD           @"当前网络不佳"
typedef void (^WebAPIRequestCompletionBlock)(WebAPIResponse* response);

#define FMHTTPClient [HTTPClient sharedHTTPClient]

@interface HTTPClient : NSURLSessionDataTask

+ (instancetype)sharedHTTPClient;



//get请求
- (void)getPath:(NSString *)path
                       parameters:(NSDictionary *)parameters
                       completion:(WebAPIRequestCompletionBlock)completionBlock;


//post请求
- (void)postPath:(NSString *)path
                        parameters:(NSDictionary *)parameters
                        completion:(WebAPIRequestCompletionBlock)completionBlock;

//post请求
- (NSURLSessionDataTask *)postReturnPath:(NSString *)path
                              parameters:(NSDictionary *)parameters
                              completion:(WebAPIRequestCompletionBlock)completionBlock;


//get请求
- (NSURLSessionDataTask *)getReturnPath:(NSString *)path
     parameters:(NSDictionary *)parameters
     completion:(WebAPIRequestCompletionBlock)completionBlock;

/**
 *  图片上传
 *  @param urlString       url地址
 *  @param image           上传的图片
 *  @param type            文件名
 *  @param completionBlock 相应block
 */
-(void)postPath:(NSString *)urlString requestImageDataUpload:(NSData *)imageData imageType:(NSString *)fileName withName:(NSString *)name parameters:(NSDictionary *)parameters completion:(WebAPIRequestCompletionBlock)completionBlock;

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
                   uploadProgressBlock:(void(^)(float uploadPercent,long long totalBytesWritten,long long totalBytesExpectedToWrite))uploadProgressBlock;
- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
     successTask:(void (^)(NSURLSessionDataTask * successTask))successTask
     failureTask:(void (^)(NSURLSessionDataTask * failureTask))failureTask
      completion:(WebAPIRequestCompletionBlock)completionBlock;


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
                    uploadProgressBlock:(void(^)(float uploadPercent,long long totalBytesWritten,long long totalBytesExpectedToWrite))uploadProgressBlock;

//- (void)cancelTask;

-(void)postPath:(NSString *)urlString requestFileDataUpload:(NSData *)imageData imageType:(NSString *)fileName withName:(NSString *)name parameters:(NSDictionary *)parameters completion:(WebAPIRequestCompletionBlock)completionBlock;
@end
