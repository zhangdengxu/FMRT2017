//
//  YYPermissionSettingModel.h
//  fmapp
//
//  Created by yushibo on 2017/3/3.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYPermissionSettingModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL selectedState;

-(instancetype)initWithArray:(NSString *)title selectedState:(BOOL)selectedState;
@end
