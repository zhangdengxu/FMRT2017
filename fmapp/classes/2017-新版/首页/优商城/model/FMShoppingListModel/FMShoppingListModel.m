//
//  FMShoppingListModel.m
//  fmapp
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMShoppingListModel.h"
#import "FMStyleModel.h"

@implementation FMShoppingListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+(NSDictionary *)objectClassInArray {
    return @{@"spec":[FMStyleModel class]};
}

@end
