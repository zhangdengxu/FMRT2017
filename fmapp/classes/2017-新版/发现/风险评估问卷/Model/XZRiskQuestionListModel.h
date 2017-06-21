//
//  XZRiskQuestionListModel.h
//  fmapp
//
//  Created by admin on 17/3/10.
//  Copyright © 2017年 yk. All rights reserved.
// 

#import <Foundation/Foundation.h>

@interface XZRiskQuestionListModel : NSObject

/** 试题题目 */
@property (nonatomic, copy) NSString *Content;
/** 试题题目高度 */
@property (nonatomic, assign) CGFloat contentHeight;
/** 试题号 */
@property (nonatomic, copy) NSString *Code;
/** 试题是否必答:0：非必答  1：必答 */
@property (nonatomic, strong) NSNumber *Must;
/** 试题序号（顺序号、排序号） */
@property (nonatomic, strong) NSNumber *Num;
/** 试题选项列表 */
@property (nonatomic, strong) NSMutableArray *Opt;
/** 试题标识 */
@property (nonatomic, strong) NSNumber *Id;

- (void)setQuestionListModeWithDic:(NSDictionary *)dic;

@end
