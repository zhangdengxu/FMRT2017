//
//  FMUnclearModel.h
//  fmapp
//
//  Created by apple on 16/4/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMUnclearModel : NSObject

@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSString *color;

@property (nonatomic,copy) NSString * comment;
@property (nonatomic, assign) NSInteger index;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
