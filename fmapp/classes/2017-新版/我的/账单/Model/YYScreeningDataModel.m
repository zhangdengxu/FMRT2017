//
//  YYScreeningDataModel.m
//  fmapp
//
//  Created by yushibo on 2017/3/8.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "YYScreeningDataModel.h"

@implementation YYScreeningDataModel
-(instancetype)initWithNSString:(NSString *)title selectedState:(BOOL)selectedState
{
    
    if (self = [super init]) {
        
        self.title =[NSString stringWithFormat:@"%@", title];
        self.selectedState = selectedState;
    }
    return self;
}
@end
