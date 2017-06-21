//
//  XZContactServicesModel.h
//  fmapp
//
//  Created by admin on 16/8/24.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZContactServicesModel : NSObject

@property (nonatomic, assign) BOOL isOpened;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) BOOL isCommonProblems;
/** 数据 */
@property (nonatomic, strong) NSMutableArray *detail;
- (void)setContactServicesWithDic:(NSDictionary *)dic;
@end
