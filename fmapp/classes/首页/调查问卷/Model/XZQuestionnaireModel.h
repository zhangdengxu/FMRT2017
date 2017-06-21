//
//  XZQuestionnaireModel.h
//  XZProject
//
//  Created by admin on 16/9/29.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZQuestionnaireModel : NSObject
/** 是否是多选 */
@property (nonatomic, assign) BOOL isMultiple;
/** 是否被选中 */
@property (nonatomic, assign) BOOL isSelected;
/** 问卷题目 */
@property (nonatomic, copy) NSString *name;
/** 问卷分数 */
@property (nonatomic, assign) int score;
/** 选项 */
@property (nonatomic, copy) NSString *type;
/** 题目高度 */
@property (nonatomic, assign) CGFloat nameHeight;
/** 选项高度 */
@property (nonatomic, assign) CGFloat typeHeight;

@end
