//
//  XZConfirmOrderModel.m
//  fmapp
//
//  Created by admin on 16/5/18.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "XZConfirmOrderModel.h"

@implementation XZConfirmOrderModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (void)setValue:(id)value forKey:(nonnull NSString *)key {
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        _ID = value;
    }
}

@end


//@implementation FMConfirmModelEnd
//- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
//    
//}
//
//@end

