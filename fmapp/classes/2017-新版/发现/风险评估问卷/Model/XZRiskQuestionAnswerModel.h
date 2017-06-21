//
//  XZRiskQuestionAnswerModel.h
//  fmapp
//
//  Created by admin on 17/3/10.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZRiskQuestionAnswerModel : NSObject

/** 选项得分 */
@property (nonatomic, strong) NSNumber *Score;
/** 选项号 */
@property (nonatomic, copy) NSString *Code;
/** 选项序号（顺序号、排序号） */
@property (nonatomic, strong) NSNumber *Num;
/** 选项内容 */
@property (nonatomic, copy) NSString *Content;
/** 选项内容高度 */
@property (nonatomic, assign) CGFloat ContentHeight;
/** 选项标识 */
@property (nonatomic, strong) NSNumber *Id;

// 当前行被选中
@property (nonatomic, assign) BOOL isSelected;

@end
