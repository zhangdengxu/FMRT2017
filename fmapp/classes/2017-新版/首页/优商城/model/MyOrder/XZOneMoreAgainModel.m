//
//  XZOneMoreAgainModel.m
//  fmapp
//
//  Created by admin on 16/6/7.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "XZOneMoreAgainModel.h"

@implementation XZOneMoreAgainModel

- (void)oneMoreOrderAgainWithProductID:(NSString *)productID {
    if ([self.delegate respondsToSelector:@selector(oneOrderAgainWithProductID:)]) {
        [self.delegate oneOrderAgainWithProductID:productID];
    }
}

@end
