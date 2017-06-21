//
//  XZDiscoverNewModel.h
//  fmapp
//
//  Created by admin on 17/3/3.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZDiscoverNewModel : NSObject

// 已登录
/** id */
@property (nonatomic, copy) NSString *mess_id;

/** 标题 */
@property (nonatomic, copy) NSString *biaoti;

/** title */
@property (nonatomic, copy) NSString *title;

/** url */
@property (nonatomic, copy) NSString *url;

// 未登录
/** id */
@property (nonatomic, copy) NSString *news_id;

@end
