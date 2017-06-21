//
//  YSSignModel.h
//  fmapp
//
//  Created by yushibo on 16/7/7.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSSignModel : NSObject
/** 活动时间  */
@property (nonatomic, strong)NSString *party_timelist;
/** 活动标题  */
@property (nonatomic, strong)NSString *party_theme;
/** 主办发  */
@property (nonatomic, strong)NSString *party_initiator;
/** 活动地点  */
@property (nonatomic, strong)NSString *party_address;
/** 活动状态 */
@property (nonatomic, strong)NSString *party_joinstatus;
@property (nonatomic, strong)NSString *pid;
@property (nonatomic, strong)NSString *phone;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
