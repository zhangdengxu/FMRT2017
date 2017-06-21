//
//  FMMonthAddReduceModel.h
//  fmapp
//
//  Created by runzhiqiu on 16/7/8.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMMonthAddReduceModel : NSObject

@property (nonatomic,copy) NSString *month;
@property (nonatomic,copy) NSString *shouzhicha;
@property (nonatomic,copy) NSString *shouru;
@property (nonatomic,copy) NSString *zhichu;


-(void)setFMMonthAddReduceModelWithDictionary:(NSDictionary *)dict;

@end


@interface FMMonthAddReduceModelBottom : NSObject

@property (nonatomic,copy) NSString *yearShouru;
@property (nonatomic,copy) NSString *yearZhichu;
@property (nonatomic,copy) NSString *yearShouzhicha;

@end


