//
//  XZWebTopView.m
//  fmapp
//
//  Created by admin on 16/7/7.
//  Copyright © 2016年 yk. All rights reserved.
// webView的头视图

#import "XZWebTopView.h"
#import "XZActivityModel.h"
#import "AutoHeightLabel.h"
#define kFont 15

@interface XZWebTopView ()
/** 主题 */
@property (nonatomic, strong) AutoHeightLabel *labelTheme;
/** 头像 */
@property (nonatomic, strong) UIImageView *imgPhoto;
/** 昵称 */
@property (nonatomic, strong) UILabel *labelName;
/** 时间 */
@property (nonatomic, strong) UILabel *labelBeginTime;
/** 阅读量 */
@property (nonatomic, strong) UILabel *labelReadCount;
/** 开始和结束时间 */
@property (nonatomic, strong) UILabel *labelTime;
/** 报名截止时间 */
@property (nonatomic, strong) UILabel *labelEndTime;
/** 地址 */
@property (nonatomic, strong) UILabel *labelAddress;
/** 已报名 */
@property (nonatomic, strong) UILabel *labelNumber;
/** 总报名人数 */
@property (nonatomic, strong) UILabel *labelTotalNumber;

@end

@implementation XZWebTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpWebTopView];
    }
    return self;
}

- (void)setUpWebTopView {
    self.backgroundColor = [UIColor whiteColor];
    /** 主题 */
    AutoHeightLabel *labelTheme = [[AutoHeightLabel alloc]init];
    [self addSubview:labelTheme];
    [labelTheme mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    self.labelTheme = labelTheme;
    
    /** 头像 */
    UIImageView *imgPhoto = [[UIImageView alloc]init];
    [self addSubview:imgPhoto];
    [imgPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelTheme.mas_left);
        make.top.equalTo(labelTheme.mas_bottom).offset(10);
        make.width.and.height.equalTo(@40);
    }];
    self.imgPhoto = imgPhoto;
    imgPhoto.layer.masksToBounds = YES;
    imgPhoto.layer.cornerRadius = 20;
    
    /** 昵称 */
    UILabel *labelName = [[UILabel alloc]init];
    [self addSubview:labelName];
    [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgPhoto.mas_right).offset(3);
        make.centerY.equalTo(imgPhoto.mas_centerY);
    }];
    self.labelName = labelName;
    labelName.font = [UIFont systemFontOfSize:14];
    labelName.textColor = XZColor(17, 63, 115);
    
    /** 发起时间 */
    UILabel *labelBeginTime = [[UILabel alloc]init];
    [self addSubview:labelBeginTime];
    [labelBeginTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelName.mas_right).offset(3);
        make.centerY.equalTo(imgPhoto.mas_centerY);
    }];
    self.labelBeginTime = labelBeginTime;
    labelBeginTime.font = [UIFont systemFontOfSize:kFont];
    labelBeginTime.textColor = [UIColor lightGrayColor];
    
    /** 阅读量 */
    UILabel *labelReadCount = [[UILabel alloc]init];
    [self addSubview:labelReadCount];
    [labelReadCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(imgPhoto.mas_centerY);
    }];
    self.labelReadCount = labelReadCount;
    labelReadCount.font = [UIFont systemFontOfSize:kFont];
    labelReadCount.textColor = [UIColor lightGrayColor];
    
    /** 中间的表格 */
    UIView *middleView = [[UIView alloc]init];
    [self addSubview:middleView];
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(imgPhoto.mas_bottom).offset(10);
        make.height.equalTo(@185);
    }];
    middleView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    middleView.layer.borderWidth = 1.0f;
    middleView.backgroundColor = XZColor(245, 245, 245);
    
    /** 时间图片 */
    UIImageView *imgTimeIcon = [[UIImageView alloc]init];
    [self addSubview:imgTimeIcon];
    [imgTimeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleView.mas_top).offset(10);
        make.left.equalTo(middleView.mas_left).offset(10);
        make.height.and.width.equalTo(@19);
    }];
    imgTimeIcon.image = [UIImage imageNamed:@"融米活动_时间"];
    
    /** 开始和结束时间 */
    UILabel *labelTime = [[UILabel alloc]init];
    [self addSubview:labelTime];
    [labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgTimeIcon.mas_right).offset(10);
        make.centerY.equalTo(imgTimeIcon.mas_centerY);
    }];
    self.labelTime = labelTime;

    /** 报名截止时间 */
    UILabel *labelEndTime = [[UILabel alloc]init];
    [self addSubview:labelEndTime];
    [labelEndTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelTime.mas_left);
        make.top.equalTo(labelTime.mas_bottom).offset(10);
    }];
    self.labelEndTime = labelEndTime;
    labelEndTime.textColor = [UIColor lightGrayColor];
    
    /** 分割线 */
    UILabel *line1 = [self createLineWithTopView:labelEndTime];
    
    /** 地址图片 */
    UIImageView *imgAddressIcon = [[UIImageView alloc]init];
    [self addSubview:imgAddressIcon];
    [imgAddressIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom).offset(10);
        make.left.equalTo(imgTimeIcon.mas_left);
        make.width.equalTo(@18);
        make.height.equalTo(@22);
    }];
    imgAddressIcon.image = [UIImage imageNamed:@"聚会交友_地址"];
    
    /** 地址 */
    UILabel *labelAddress = [[UILabel alloc]init];
    [self addSubview:labelAddress];
    [labelAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelTime.mas_left);
        make.centerY.equalTo(imgAddressIcon.mas_centerY);
    }];
    self.labelAddress = labelAddress;
    labelAddress.textColor = XZColor(17, 63, 115);
    
    /** 分割线*/
    UILabel *line2 = [self createLineWithTopView:labelAddress];
    
    /** 报名图片 */
    UIImageView *imgPersonIcon = [[UIImageView alloc]init];
    [self addSubview:imgPersonIcon];
    [imgPersonIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line2.mas_bottom).offset(10);
        make.left.equalTo(imgTimeIcon.mas_left);
        make.width.equalTo(@20);
        make.height.equalTo(@22);
    }];
    imgPersonIcon.image = [UIImage imageNamed:@"23"];
    
    /** 已报名 */
    UILabel *labelNumber = [[UILabel alloc]init];
    [self addSubview:labelNumber];
    [labelNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgPersonIcon.mas_right).offset(10);
        make.centerY.equalTo(imgPersonIcon.mas_centerY);
    }];
    self.labelNumber = labelNumber;
    
    /** 总报名人数 */
    UILabel *labelTotalNumber = [[UILabel alloc]init];
    [self addSubview:labelTotalNumber];
    [labelTotalNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelNumber.mas_left);
        make.top.equalTo(labelNumber.mas_bottom).offset(10);
    }];
    self.labelTotalNumber = labelTotalNumber;
    labelTotalNumber.textColor = [UIColor lightGrayColor];
    
}

- (UILabel *)createLineWithTopView:(UIView *)topView {
    UILabel *line1 = [[UILabel alloc]init];
    [self addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(topView.mas_bottom).offset(10);
        make.width.equalTo(KProjectScreenWidth - 40);
        make.height.equalTo(0.5);
    }];
    line1.backgroundColor = [UIColor lightGrayColor];
    return line1;
}

// 赋值
- (void)setModelActivity:(XZActivityModel *)modelActivity {
    _modelActivity = modelActivity;
    self.labelTheme.text = [NSString stringWithFormat:@"%@",modelActivity.party_theme];
    [self.imgPhoto sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",modelActivity.avatar]] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
    self.labelName.text = [NSString stringWithFormat:@"%@",modelActivity.username];
    self.labelBeginTime.text = [NSString stringWithFormat:@"发起%@",modelActivity.party_addtime];
    self.labelReadCount.text = [NSString stringWithFormat:@"阅读%@",modelActivity.readernum];
    self.labelTime.text = [NSString stringWithFormat:@"%@",modelActivity.party_timelist];
    self.labelEndTime.text = [NSString stringWithFormat:@"%@",modelActivity.party_enrolltime];
    self.labelAddress.text = [NSString stringWithFormat:@"%@",modelActivity.party_address];
    self.labelNumber.text = [NSString stringWithFormat:@"已有%@报名",modelActivity.party_adder];
    self.labelTotalNumber.text = [NSString stringWithFormat:@"限%@报名",modelActivity.party_number];

}

@end
