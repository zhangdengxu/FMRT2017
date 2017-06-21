//
//  FMRTAllTakeBuyResultModel.h
//  fmapp
//
//  Created by apple on 2016/10/26.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMRTAllTakeBuyResultModel : NSObject

@property (nonatomic, copy)NSString *productName;
@property (nonatomic, copy)NSString *money;
@property (nonatomic, copy)NSString *number;
@property (nonatomic, copy)NSString *successStatus;
@property (nonatomic, copy)NSString *duobaoStatus;

@property (nonatomic, copy)NSString *failureStatus;
@property (nonatomic, copy)NSString *currentDB;
@property (nonatomic, copy)NSString *neededDB;



@end
