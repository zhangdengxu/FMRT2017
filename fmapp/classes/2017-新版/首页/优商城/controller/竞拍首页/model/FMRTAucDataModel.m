//
//  FMRTAucDataModel.m
//  fmapp
//
//  Created by apple on 16/8/8.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTAucDataModel.h"

@implementation FMRTAucDataModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.aucDataSource = [NSMutableArray array];
        self.remDataSource = [NSMutableArray array];
        self.topPhotoArr = [NSMutableArray array];
    }
    return self;
}

@end
