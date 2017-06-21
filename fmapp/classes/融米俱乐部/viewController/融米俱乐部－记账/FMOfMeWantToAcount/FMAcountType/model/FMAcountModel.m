//
//  FMAcountModel.m
//  fmapp
//
//  Created by apple on 16/6/22.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMAcountModel.h"

@implementation FMAcountModel

+ (NSDictionary *)replacedKeyFromPropertyName{

    return @{@"DID":@"jid"};
    
}

+(NSDictionary *)objectClassInArray {
    return @{@"detailListArr":[FMAcountLendModel class]};
}

@end

@implementation FMAcountLendModel

+ (NSDictionary *)replacedKeyFromPropertyName{

    return @{@"ID":@"jid"};
}


@end