//
//  FMShareModel.h
//  fmapp
//
//  Created by runzhiqiu on 16/7/27.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMShareModel : NSObject
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *shareStr;
@property (nonatomic,copy) NSString *picurl;


+(instancetype)initWithShareModelDictionary:(NSDictionary *)dictionary;

@end
