//
//  YSFootPrintModel.h
//  fmapp
//
//  Created by yushibo on 16/7/7.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSFootPrintModel : NSObject
/** 时间  */
@property (nonatomic, strong)NSString *party_time;
/** 标题  */
@property (nonatomic, strong)NSString *party_theme;
/** 活动名  */
@property (nonatomic, strong)NSString *party_actname;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end
