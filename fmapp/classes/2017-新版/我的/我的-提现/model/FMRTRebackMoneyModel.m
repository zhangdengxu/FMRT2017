//
//  FMRTRebackMoneyModel.m
//  fmapp
//
//  Created by apple on 2017/6/2.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRTRebackMoneyModel.h"

@implementation FMRTRebackMoneyModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+(NSDictionary *)objectClassInArray {
    return @{@"desc":[FMRTDetailModel class]};
}

@end

@implementation FMRTDetailModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{

}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

@end
