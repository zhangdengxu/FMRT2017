//
//  XZRiskQuestionnaireSection.h
//  fmapp
//
//  Created by admin on 17/3/10.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XZRiskQuestionnaireModel;
@class XZRiskQuestionListModel;
@interface XZRiskQuestionnaireSection : UIView

/** 第一个model */
@property (nonatomic, strong) XZRiskQuestionnaireModel *modelQuestionnaire;

/** 第一个之外的section */
@property (nonatomic, strong) XZRiskQuestionListModel *modelQuesList;

@end
