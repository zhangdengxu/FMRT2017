//
//  XZQuestionnaireCell.m
//  XZProject
//
//  Created by admin on 16/9/28.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "XZQuestionnaireCell.h"
#import "XZQuestionnaireModel.h"

@interface XZQuestionnaireCell ()
@property (nonatomic, strong) UILabel *labelContent;
@property (nonatomic, strong) UIButton *btnSelect;
@property (nonatomic, strong) UIButton *btnCover;

@end

@implementation XZQuestionnaireCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 创建子视图
        [self setUpQuestionnaireCell];
    }
    return self;
}

// 创建子视图
- (void)setUpQuestionnaireCell {
    UIButton *btnSelect = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:btnSelect];
    [btnSelect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.contentView);
        make.size.equalTo(@20);
    }];
    [btnSelect setBackgroundImage:[UIImage imageNamed:@"选择-圆_03"] forState:UIControlStateNormal];
    [btnSelect setBackgroundImage:[UIImage imageNamed:@"已选择-圆_03"] forState:UIControlStateSelected];
//    [btnSelect addTarget:self action:@selector(didClickSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
    self.btnSelect = btnSelect;
    
    UILabel *labelContent = [[UILabel alloc] init];
    [self.contentView addSubview:labelContent];
    [labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btnSelect.mas_right).offset(10);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    labelContent.backgroundColor = [UIColor whiteColor];
    labelContent.textColor = [UIColor darkTextColor];
    self.labelContent = labelContent;
    labelContent.font = [UIFont systemFontOfSize:15.0f];
    labelContent.numberOfLines = 0;
    
    UILabel *line = [[UILabel alloc] init];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    line.backgroundColor = [UIColor lightGrayColor];
    
    // 覆盖的button
    UIButton *btnCover = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:btnCover];
    [btnCover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
    [btnCover addTarget:self action:@selector(didClickSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
    self.btnCover = btnCover;
}

- (void)setModelQues:(XZQuestionnaireModel *)modelQues {
    _modelQues = modelQues;
    self.labelContent.text = modelQues.name;
    if (modelQues.type.length == 0) {
        self.btnSelect.hidden = YES;
        self.btnCover.userInteractionEnabled = NO;
        [self.labelContent mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-10);
        }];

    }else {
        self.btnSelect.hidden = NO;
        self.btnCover.userInteractionEnabled = YES;
        [self.labelContent mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.btnSelect.mas_right).offset(10);
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-10);
        }];
    }
    
    if (modelQues.isSelected) {
        self.btnSelect.selected = YES;
    }else {
        self.btnSelect.selected = NO;
    }
}

// 点击button
- (void)didClickSelectedButton:(UIButton *)button {
    if (self.blockQuestionnaire) {
        self.blockQuestionnaire(button,self.btnSelect);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)sendModelToCell:(XZQuestionnaireModel *)modelQues {
    if (modelQues.isSelected) {
        self.btnSelect.selected = !self.btnSelect.selected;
    }
    
}

@end
