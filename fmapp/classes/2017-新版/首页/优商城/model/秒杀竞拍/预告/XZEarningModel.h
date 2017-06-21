//
//  XZEarningModel.h
//  XZProject
//
//  Created by admin on 16/8/10.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZEarningModel : NSObject
/** 天 */
@property (nonatomic, copy) NSString *daynum;
/** 月日 */
@property (nonatomic, copy) NSString *day;
/** 收益 */
@property (nonatomic, copy) NSString *daytotal;
/**  */
@property (nonatomic, strong) NSMutableArray *daylist;
//
//- (void)setEarningInnerWithDic:(NSDictionary *)dic;

- (void)setEarningInnerWithDic:(NSDictionary *)dic andModel:(XZEarningModel *)model;
@end
