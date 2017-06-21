//
//  homeCycleModel.h
//  fmapp
//
//  Created by apple on 16/4/13.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface homeCycleModel : NSObject

@property (nonatomic, copy) NSString *biaoti;
@property (nonatomic, copy) NSString *lianjie;
@property (nonatomic, copy) NSString *pic;

+(NSArray *)homeCycleArrayWithDataArr:(NSArray *)dataArr;

+(NSArray *)homeCycleUrlArrayWithDataArr:(NSArray *)dataArr;
+(NSArray *)homeCycleTitleArrayWithDataArr:(NSArray *)dataArr;

@end
