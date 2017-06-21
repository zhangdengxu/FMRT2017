//
//  XZChooseTicketModel.h
//  fmapp
//
//  Created by admin on 17/1/3.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZChooseTicketModel : NSObject
/** 购物满300减10 */
@property (nonatomic, copy) NSString *cpns_name;
/** 奖励来源 */
@property (nonatomic, copy) NSString *cpns_desc;
/** 有效期限 */
@property (nonatomic, copy) NSString *endtime;
/** 减的金额 */
@property (nonatomic, copy) NSString *jiner;
/** id */
@property (nonatomic, copy) NSString *cpns_code;
/** 状态 */
@property (nonatomic, copy) NSString *statusText;
/** 暂无数据 */
@property (nonatomic, assign) BOOL isNoData;
/** 是已使用或已过期的 */
@property (nonatomic, assign) BOOL isExpiredOrUnused;
/** 内容高度 */
@property (nonatomic, assign) CGFloat contentH;

@end
