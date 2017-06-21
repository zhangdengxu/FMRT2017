//
//  YYPermissionSettingModel.m
//  fmapp
//
//  Created by yushibo on 2017/3/3.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "YYPermissionSettingModel.h"

@implementation YYPermissionSettingModel

-(instancetype)initWithArray:(NSString *)title selectedState:(BOOL)selectedState
{
    
    if (self = [super init]) {
        
        self.title =[NSString stringWithFormat:@"%@", title];
        self.selectedState = selectedState;
    }
    return self;
}

@end
