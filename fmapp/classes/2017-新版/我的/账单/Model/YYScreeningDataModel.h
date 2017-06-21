//
//  YYScreeningDataModel.h
//  fmapp
//
//  Created by yushibo on 2017/3/8.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYScreeningDataModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL selectedState;

-(instancetype)initWithNSString:(NSString *)title selectedState:(BOOL)selectedState;
@end
