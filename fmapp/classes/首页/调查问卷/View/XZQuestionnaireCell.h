//
//  XZQuestionnaireCell.h
//  XZProject
//
//  Created by admin on 16/9/28.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XZQuestionnaireModel;
@interface XZQuestionnaireCell : UITableViewCell
@property (nonatomic, copy) void(^blockQuestionnaire)(UIButton *,UIButton *);
@property (nonatomic, strong) XZQuestionnaireModel *modelQues;

/**  */
- (void)sendModelToCell:(XZQuestionnaireModel *)modelQues;
@end
