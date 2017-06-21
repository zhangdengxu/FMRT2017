//
//  XZRiskQuestionnaireSection.m
//  fmapp
//
//  Created by admin on 17/3/10.
//  Copyright © 2017年 yk. All rights reserved.
//  问卷调查头部

#import "XZRiskQuestionnaireSection.h"
#import "XZRiskQuestionnaireModel.h" // 第一页的model
#import "XZRiskQuestionListModel.h" // 第一页之外的

@interface XZRiskQuestionnaireSection ()
@property (nonatomic, strong) UILabel *labelTitle;
@end

@implementation XZRiskQuestionnaireSection

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpRiskQuestionnaireSection];
    }
    return self;
}

- (void)setUpRiskQuestionnaireSection {
    self.backgroundColor = [UIColor whiteColor];
    
    // title
    UILabel *labelTitle = [[UILabel alloc] init];
    [self addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self);
    }];
    labelTitle.backgroundColor = [UIColor whiteColor];
    labelTitle.textColor = [UIColor darkTextColor];
    self.labelTitle = labelTitle;
    labelTitle.font = [UIFont systemFontOfSize:15.0f];
    labelTitle.numberOfLines = 0;
}

- (void)setModelQuestionnaire:(XZRiskQuestionnaireModel *)modelQuestionnaire {
    _modelQuestionnaire = modelQuestionnaire;
    
    self.labelTitle.text = modelQuestionnaire.Title;
}

- (void)setModelQuesList:(XZRiskQuestionListModel *)modelQuesList {
    _modelQuesList = modelQuesList;
    
    self.labelTitle.text = modelQuesList.Content;
}

@end
