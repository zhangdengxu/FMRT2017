//
//  FMAcountMainModel.m
//  fmapp
//
//  Created by apple on 16/6/22.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMAcountMainModel.h"

@implementation FMAcountMainModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end

@implementation FMAcountSecModel

+(NSDictionary *)objectClassInArray {
    return @{@"detailListArr":[FMAcountDetailModel class]};
}

@end

@implementation FMAcountDetailModel


@end