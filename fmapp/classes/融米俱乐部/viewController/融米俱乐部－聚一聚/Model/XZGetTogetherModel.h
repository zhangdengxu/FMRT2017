//
//  XZGetTogetherModel.h
//  fmapp
//
//  Created by admin on 16/6/30.
//  Copyright © 2016年 yk. All rights reserved.
// 首页model

#import <Foundation/Foundation.h>

@interface XZGetTogetherModel : NSObject
/** 摘要 */
@property (nonatomic, strong) NSString *party_abstract;
/** 链接名称 */
@property (nonatomic, strong) NSString *party_linkname;
/** 标题 */
@property (nonatomic, strong) NSString *party_theme;
/** 地点 */
@property (nonatomic, strong) NSString *party_address;
/** 时间段 */
@property (nonatomic, strong) NSString *party_timeslot;
/** 图片 */
@property (nonatomic, strong) NSString *party_pic;
/** 唯一标识 */
@property (nonatomic, strong) NSString *pid;

@end
