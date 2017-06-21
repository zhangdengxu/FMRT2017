//
//  XZRiskFirstPageView.m
//  fmapp
//
//  Created by admin on 17/3/10.
//  Copyright © 2017年 yk. All rights reserved.
//  第一页数据

#import "XZRiskFirstPageView.h"
#import "XZRiskQuestionnaireModel.h"
#import "XZQuestionnaireHeaderView.h"

@interface XZRiskFirstPageView ()
@property (nonatomic, strong) UILabel *labelContent;

@property (nonatomic, strong) UILabel *labelTitle;
@end

@implementation XZRiskFirstPageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpRiskFirstPageView];
    }
    return self;
}

- (void)setUpRiskFirstPageView {
    self.backgroundColor = [UIColor whiteColor];
    
    XZQuestionnaireHeaderView *header = [[XZQuestionnaireHeaderView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenWidth * 216 / 640.0)];
    header.imageName = @"调查问卷_海报_1702";
    [self addSubview:header];
    
    UILabel *labelTitle = [[UILabel alloc] init];
    [self addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(header.mas_bottom).offset(20);
    }];
    labelTitle.textColor = [UIColor darkTextColor];
    self.labelTitle = labelTitle;
    labelTitle.font = [UIFont systemFontOfSize:17.0f];
    
    UILabel *labelContent = [[UILabel alloc] init];
    [self addSubview:labelContent];
    [labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelTitle);
        make.right.equalTo(labelTitle);
        make.top.equalTo(labelTitle.mas_bottom).offset(10);
    }];
    labelContent.textColor = [UIColor darkTextColor];
    self.labelContent = labelContent;
    labelContent.font = [UIFont systemFontOfSize:15.0f];
    labelContent.numberOfLines = 0;
}

- (void)setModelRiskQues:(XZRiskQuestionnaireModel *)modelRiskQues {
    _modelRiskQues = modelRiskQues;
    
    NSString *text = [NSString stringWithFormat:@"\t%@",modelRiskQues.Desc];
    
    self.labelTitle.text = [NSString stringWithFormat:@"%@\n",modelRiskQues.Subtitle];
    
    self.labelContent.attributedText = [self setUpLabelLineSpaceWithText:text];
}

// 设置label的行间距
- (NSMutableAttributedString *)setUpLabelLineSpaceWithText:(NSString *)text{
    //创建NSMutableAttributedString实例，并将text传入
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:text];
    //创建NSMutableParagraphStyle实例
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    //设置行距
    [style setLineSpacing:5.0f];
    
    if (KProjectScreenWidth > 350){ // 6s上
        //设置行距
        [style setLineSpacing:10.0f];
    }else if (KProjectScreenWidth > 400) { // plus
        //设置行距
        [style setLineSpacing:15.0f];
    }
    
    //根据给定长度与style设置attStr式样
    [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [text length])];
    return attStr;
}


@end
