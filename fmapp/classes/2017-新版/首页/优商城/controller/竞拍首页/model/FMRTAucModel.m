//
//  FMRTAucModel.m
//  fmapp
//
//  Created by apple on 16/8/7.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTAucModel.h"

@implementation FMRTAucModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end

@implementation FMRTAucFirstModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.phoneTitles = [NSMutableArray array];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end

@implementation FMRankingModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end