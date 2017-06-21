//
//  XZTransferRechargeModel.h
//  fmapp
//
//  Created by admin on 2017/5/15.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZTransferRechargeModel : NSObject

/** 图片名 */
@property (nonatomic, copy) NSString *iconName;
/** 题目 */
@property (nonatomic, copy) NSString *title;
/** 英文题目 */
@property (nonatomic, copy) NSString *EnglishTitle;
/** 内容 */
@property (nonatomic, copy) NSString *content;
/** 内容高 */
@property (nonatomic, assign) CGFloat contentHeight;

@end
