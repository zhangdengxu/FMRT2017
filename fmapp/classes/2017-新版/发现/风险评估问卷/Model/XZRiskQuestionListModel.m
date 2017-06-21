//
//  XZRiskQuestionListModel.m
//  fmapp
//
//  Created by admin on 17/3/10.
//  Copyright © 2017年 yk. All rights reserved.
//  问卷调查列表model

#import "XZRiskQuestionListModel.h"

#import "XZRiskQuestionAnswerModel.h" // 里层model

@implementation XZRiskQuestionListModel

- (void)setQuestionListModeWithDic:(NSDictionary *)dic {
    [self setValuesForKeysWithDictionary:dic];
    
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *dict in self.Opt) {
        XZRiskQuestionAnswerModel *modelAnswer = [[XZRiskQuestionAnswerModel alloc] init];
        [modelAnswer setValuesForKeysWithDictionary:dict];
        NSString *content = [NSString stringWithFormat:@"%@、%@",modelAnswer.Code,modelAnswer.Content];
        modelAnswer.ContentHeight = [content getStringCGSizeWithMaxSize:CGSizeMake(KProjectScreenWidth - 50, MAXFLOAT) WithFont:[UIFont systemFontOfSize:15.0f]].height + 30;
        [temp addObject:modelAnswer];
    }
    self.Opt = [NSMutableArray arrayWithArray:temp];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
