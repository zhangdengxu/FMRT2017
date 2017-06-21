//
//  XZGetTogetherCell.m
//  XZLearning
//
//  Created by admin on 16/6/22.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "XZGetTogetherCell.h"
#import "XZGetTogetherModel.h"

#import "AutoHeightLabel.h"
// 判断是否为iOS8.2
#define iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.2)

@interface XZGetTogetherCell ()
/** 活动图片 */
@property (nonatomic, strong) UIImageView *imgPhoto;
/** 活动主题 */
@property (nonatomic, strong) AutoHeightLabel *labelTitle;
/** 举办方 */
@property (nonatomic, strong) UILabel *labelHost;
/** 发布活动 */
@property (nonatomic, strong) UIButton *btnPublish;
/** 时间 */
@property (nonatomic, strong) UILabel *labelTime;

@end

@implementation XZGetTogetherCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 创建子视图
        [self createChildView];
    }
    return self;
}

// 创建子视图
- (void)createChildView {
    UILabel *topLine = [[UILabel alloc]init];
    [self.contentView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.contentView.mas_top);
        make.height.equalTo(@15);
    }];
    topLine.backgroundColor = XZColor(230, 235, 240);
    /** 活动图片 */
    UIImageView *imgPhoto = [[UIImageView alloc]init];
    [self.contentView addSubview:imgPhoto];
    [imgPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topLine.mas_left);
        make.right.equalTo(topLine.mas_right);
        make.top.equalTo(topLine.mas_bottom);
        make.height.equalTo(@(KProjectScreenWidth * 5/8));
    }];
    self.imgPhoto = imgPhoto;
    
    /** 活动主题 */
    AutoHeightLabel *labelTitle = [[AutoHeightLabel alloc]init];
    [self.contentView addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgPhoto.mas_left);
        make.right.equalTo(imgPhoto.mas_right);
        make.bottom.equalTo(imgPhoto.mas_bottom);
    }];
    self.labelTitle = labelTitle;
    labelTitle.font = [UIFont systemFontOfSize:16];
    labelTitle.backgroundColor = [HXColor colorWithHexString:@"1e1e1e" alpha:0.6];
    labelTitle.textColor = [UIColor whiteColor];
    
    /** 地址图标 */
    UIImageView *imgIcon = [[UIImageView alloc]init];
    [self.contentView addSubview:imgIcon];
    [imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgPhoto.mas_left).offset(10);
        make.width.equalTo(@18);
        make.top.equalTo(imgPhoto.mas_bottom).offset(10);
        make.height.equalTo(@22);
    }];
    imgIcon.image = [UIImage imageNamed:@"聚会交友_地址"];
    
    /** 举办方 */
    UILabel *labelHost = [[UILabel alloc]init];
    [self.contentView addSubview:labelHost];
    [labelHost mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgIcon.mas_right).offset(5);
        make.centerY.equalTo(imgIcon.mas_centerY);
    }];
    self.labelHost = labelHost;
    labelHost.font = [UIFont systemFontOfSize:15];
    labelHost.backgroundColor = [UIColor whiteColor];
    labelHost.textColor = [UIColor darkGrayColor];
    
    /** 发布活动 */
    UIButton *btnPublish = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:btnPublish];
    [btnPublish mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imgPhoto.mas_right).offset(-10);
        make.width.equalTo(@70);
        make.top.equalTo(imgIcon.mas_top);
        make.bottom.equalTo(imgIcon.mas_bottom);
       
    }];
    self.btnPublish = btnPublish;
    [btnPublish.titleLabel setTextColor:[UIColor whiteColor]];
    btnPublish.layer.masksToBounds = YES;
    btnPublish.layer.cornerRadius = 5;
    [btnPublish setBackgroundColor:XZColor(7, 64, 143)];
    [btnPublish addTarget:self action:@selector(didClickPublishBtn:) forControlEvents:UIControlEventTouchUpInside];
    if (iOS8) {
         [btnPublish.titleLabel setFont:[UIFont systemFontOfSize:15 weight:2]];
    }else {
         [btnPublish.titleLabel setFont:[UIFont systemFontOfSize:15]];
    }
    
    /** 分隔线 */
    UILabel *line = [[UILabel alloc]init];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgIcon.mas_left);
        make.top.equalTo(imgIcon.mas_bottom).offset(10);
        make.right.equalTo(imgPhoto.mas_right).offset(-10);
        make.height.equalTo(@0.5);
    }];
    line.backgroundColor = XZColor(224, 225, 226);
    
    /** 时间图片 */
    UIImageView *imgTime = [[UIImageView alloc]init];
    [self.contentView addSubview:imgTime];
    [imgTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgPhoto.mas_left).offset(10);
        make.width.and.height.equalTo(@19);
        make.top.equalTo(line.mas_bottom).offset(10);
    }];
    imgTime.image = [UIImage imageNamed:@"融米活动_时间"];
    
    /** 时间 */
    UILabel *labelTime = [[UILabel alloc]init];
    [self.contentView addSubview:labelTime];
    [labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgTime.mas_right).offset(5);
        make.centerY.equalTo(imgTime.mas_centerY);
    }];
    self.labelTime = labelTime;
    labelTime.font = [UIFont systemFontOfSize:15];
    labelTime.backgroundColor = [UIColor whiteColor];
    labelTime.textColor = [UIColor darkGrayColor];
    
}

- (void)didClickPublishBtn:(UIButton *)button {
    if (self.blockBtnPublish) {
        self.blockBtnPublish(button);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

// 赋值
- (void)setModelTother:(XZGetTogetherModel *)modelTother {
    _modelTother = modelTother;
    self.labelTitle.text = modelTother.party_theme;
    self.labelHost.text = modelTother.party_address;
    self.labelTime.text = modelTother.party_timeslot;
    [self.btnPublish setTitle:modelTother.party_linkname forState:UIControlStateNormal];
    [self.imgPhoto sd_setImageWithURL:[NSURL URLWithString:modelTother.party_pic] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];

}

@end
