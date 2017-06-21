//
//  XZSuccessFailureModel.h
//  fmapp
//
//  Created by admin on 16/10/27.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZSuccessFailureModel : NSObject
/** 兑换的夺宝币数 */
@property (nonatomic, copy) NSString *coinNumber;
/** 兑换成功/失败 */
@property (nonatomic, assign) BOOL isSuccess;
/** 当前积分 */
@property (nonatomic, copy) NSString *currentInter;
@end
