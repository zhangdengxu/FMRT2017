//
//  XZRongMiSchoolCell.m
//  fmapp
//
//  Created by admin on 17/2/24.
//  Copyright © 2017年 yk. All rights reserved.
//  融米学堂cell

#import "XZRongMiSchoolCell.h"
#import "XZRongMiSchoolModel.h"

@interface XZRongMiSchoolCell ()

// 题目
@property (nonatomic, strong) UILabel *labelTitle;
// 内容
@property (nonatomic, strong) UILabel *labelContent;
// 时间
@property (nonatomic, strong) UILabel *labelTime;
// 点赞数量
@property (nonatomic, strong) UILabel *labelThumbUp;

@end

@implementation XZRongMiSchoolCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpRongMiSchoolCell];
    }
    return self;
}

- (void)setUpRongMiSchoolCell {
    self.backgroundColor = [UIColor whiteColor];
    
    // 视频题目
    UILabel *labelTitle = [[UILabel alloc] init];
    [self.contentView addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView).offset(15);
    }];
    self.labelTitle = labelTitle;
    labelTitle.font = [UIFont systemFontOfSize:18.0f];
    labelTitle.textColor = [HXColor colorWithHexString:@"#333333"];
    labelTitle.numberOfLines = 0;
    
    // 内容
    UILabel *labelContent = [[UILabel alloc] init];
    [self.contentView addSubview:labelContent];
    [labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelTitle);
        make.right.equalTo(labelTitle);
        make.top.equalTo(labelTitle.mas_bottom).offset(10);
    }];
    labelContent.font = [UIFont systemFontOfSize:15.0f];
    labelContent.textColor = [HXColor colorWithHexString:@"#5a5a5a"];
    labelContent.numberOfLines = 0;
    self.labelContent = labelContent;
    
    // 时间
    UILabel *labelTime = [[UILabel alloc] init];
    [self.contentView addSubview:labelTime];
    [labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelTitle);
        make.right.equalTo(labelTitle);
        make.top.equalTo(labelContent.mas_bottom).offset(10);
    }];
    labelTime.font = [UIFont systemFontOfSize:13.0f];
    labelTime.textColor = [HXColor colorWithHexString:@"#aaaaaa"];
    self.labelTime = labelTime;
//    labelTime.backgroundColor = [UIColor orangeColor];
    
    // 分享
    UIButton *btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:btnShare];
    [btnShare mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(labelTitle);
        make.top.equalTo(labelTime.mas_bottom).offset(10);
        make.size.equalTo(33); // @(33 * 0.9)
    }];
    btnShare.tag = 200;
//    btnShare.backgroundColor = [UIColor greenColor];
    [btnShare setImage:[UIImage imageNamed:@"融米学堂_转发__1702"] forState:UIControlStateNormal];
    [btnShare addTarget:self action:@selector(didClickRongMiSchoolButton:) forControlEvents:UIControlEventTouchUpInside];
    
    // 点赞数量
    UILabel *labelThumbUp = [[UILabel alloc] init];
    [self.contentView addSubview:labelThumbUp];
    [labelThumbUp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(btnShare.mas_left).offset(-15);
        make.centerY.equalTo(btnShare);
    }];
    labelThumbUp.textColor = [HXColor colorWithHexString:@"#aaaaaa"];
    self.labelThumbUp = labelThumbUp;
    labelThumbUp.font = [UIFont systemFontOfSize:13.0f];
    
    // 点赞图片
    UIImageView *imgThumbUp = [[UIImageView alloc] init];
    [self.contentView addSubview:imgThumbUp];
    [imgThumbUp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(labelThumbUp.mas_left).offset(-5);
        make.width.equalTo(@(29 * 0.65));
        make.height.equalTo(@(32 * 0.65));
        make.centerY.equalTo(btnShare);
    }];
    imgThumbUp.image = [UIImage imageNamed:@"融米学堂_点赞__1702"];
    
    // 点赞 29 32
    UIButton *btnThumbUp = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:btnThumbUp];
    [btnThumbUp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(labelThumbUp).offset(10);
        make.left.equalTo(imgThumbUp).offset(-10);
        make.height.equalTo(@(32 * 0.8));
        make.centerY.equalTo(btnShare);
    }];
    btnThumbUp.tag = 201;
    [btnThumbUp addTarget:self action:@selector(didClickRongMiSchoolButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setModelRongMi:(XZRongMiSchoolModel *)modelRongMi {
    _modelRongMi = modelRongMi;
    // 题目  @"老周教你如何识别网贷平台？"
    self.labelTitle.text = modelRongMi.title;

    if (modelRongMi.content.length != 0) { // 有内容
        // 内容
        self.labelContent.text = modelRongMi.content;
        [self.labelTime mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.labelTitle);
            make.right.equalTo(self.labelTitle);
            make.top.equalTo(self.labelContent.mas_bottom).offset(10);
        }];
    }else {// 没有内容
        [self.labelTime mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.labelTitle);
            make.right.equalTo(self.labelTitle);
            make.top.equalTo(self.labelTitle.mas_bottom).offset(10);
        }];
    }
    
    if (modelRongMi.addtime.length != 0) {
        // 时间 @"官方视频  2016-10-10 16：05"
        self.labelTime.text = [NSString stringWithFormat:@"%@  %@",modelRongMi.from,modelRongMi.addtime];
    }
    
    if (modelRongMi.like) {
        // 点赞 @"120"
        self.labelThumbUp.text = [NSString stringWithFormat:@"%@",modelRongMi.like];
    }
}

#pragma mark ---- 点击按钮
- (void)didClickRongMiSchoolButton:(UIButton *)button {
    if (self.blockRongMiSchool) {
        self.blockRongMiSchool(button);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
