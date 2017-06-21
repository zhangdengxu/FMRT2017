//
//  XZRongMiFamilyReusableView.m
//  fmapp
//
//  Created by admin on 16/6/28.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "XZRongMiFamilyReusableView.h"
#import "XZActivityModel.h"
#define LabelFont [UIFont systemFontOfSize:15]

@interface XZRongMiFamilyReusableView ()
/** 报名 */
@property (nonatomic, strong) UILabel *labelEnroll;
/** 阅读 */
@property (nonatomic, strong) UILabel *labelRead;
/** 分享 */
@property (nonatomic, strong) UILabel *labelShare;
/** 评论 */
@property (nonatomic, strong) UILabel *labelComment;
/** 赞 */
@property (nonatomic, strong) UILabel *labelSupport;
/** 主题 */
@property (nonatomic, strong) UILabel *labelRongMiFamily;
@end

@implementation XZRongMiFamilyReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpRongMiFamilyReusableView];
    }
    return self;
}

- (void)setUpRongMiFamilyReusableView {
    self.backgroundColor = XZColor(230, 235, 240);
    
    /** 管理活动 */
    UILabel *labelActivity = [[UILabel alloc]init];
    [self addSubview:labelActivity];
    [labelActivity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@40);
    }];
    labelActivity.text = @"管理活动";
    CGFloat size = (KProjectScreenWidth - 2) / 3.0;
    labelActivity.font = LabelFont;
    
    /** 报名 */
    UILabel *labelEnroll = [[UILabel alloc]init];
    [self addSubview:labelEnroll];
    [labelEnroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(labelActivity.mas_bottom);
        make.width.and.height.equalTo(size);
    }];
    self.labelEnroll = labelEnroll;
    labelEnroll.textAlignment = NSTextAlignmentCenter;
    labelEnroll.textColor = [UIColor lightGrayColor];
    labelEnroll.backgroundColor = [UIColor whiteColor];
    labelEnroll.numberOfLines = 2;
    labelEnroll.font = LabelFont;
    
    /** 阅读 */
    UILabel *labelRead = [self createLabelWithLeft:labelEnroll andTop:labelActivity andOffSet:0]; //  andText:@"阅读\t4"
    self.labelRead = labelRead;
    
     /** 分享 */
    UILabel *labelShare = [self createLabelWithLeft:labelRead andTop:labelActivity andOffSet:0]; //  andText:@"分享\t0"
    self.labelShare = labelShare;
    
    /** 评论 */
    UILabel *labelComment = [self createLabelWithLeft:labelEnroll andTop:labelRead andOffSet:1]; //  andText:@"评论\t0"
    self.labelComment = labelComment;
    
    /** 赞 */
    UILabel *labelSupport = [self createLabelWithLeft:labelComment andTop:labelShare andOffSet:1]; //  andText:@"赞\t0"
    self.labelSupport = labelSupport;
    
    /** 活动信息 */
    UILabel *labelInfomation = [[UILabel alloc]init];
    [self addSubview:labelInfomation];
    [labelInfomation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelActivity.mas_left);
        make.top.equalTo(labelEnroll.mas_bottom);
        make.height.equalTo(@40);
    }];
    labelInfomation.text = @"活动信息";
    labelInfomation.font = LabelFont;
    
    /** 融米一家亲 */
    UIView *viewFamily = [[UIView alloc]init];
    [self addSubview:viewFamily];
    [viewFamily mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(labelInfomation.mas_bottom);
        make.height.equalTo(@100);
    }];
    viewFamily.backgroundColor = [UIColor whiteColor];
    
    UILabel *labelRongMiFamily = [[UILabel alloc]init];
    [viewFamily addSubview:labelRongMiFamily];
    [labelRongMiFamily mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelActivity.mas_left);
        make.top.equalTo(labelInfomation.mas_bottom);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.equalTo(@50);
    }];
    self.labelRongMiFamily = labelRongMiFamily;
    labelRongMiFamily.font = LabelFont;
//    labelRongMiFamily.text = @"融米一家亲";
    // 中间的线
    UILabel *line = [[UILabel alloc]init];
    [viewFamily addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewFamily.mas_left).offset(20);
        make.right.equalTo(viewFamily.mas_right).offset(-20);
        make.centerY.equalTo(viewFamily.mas_centerY);
        make.height.equalTo(@0.5);
    }];
    line.backgroundColor = [UIColor lightGrayColor];
    
    // 修改按钮
    UIButton *btnAlter = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewFamily addSubview:btnAlter];
    [btnAlter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewFamily.mas_centerX);
        make.centerY.equalTo(viewFamily.mas_centerY).offset(25);
        make.width.equalTo(@100);
        make.height.equalTo(@49);
    }];
    [btnAlter setImage:[UIImage imageNamed:@"融米一家亲_修改"] forState:UIControlStateNormal];
    [btnAlter setTitle:@" 修改" forState:UIControlStateNormal];
    [btnAlter setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnAlter addTarget:self action:@selector(didClickAlterButtton:) forControlEvents:UIControlEventTouchUpInside];
    [btnAlter.titleLabel setFont:LabelFont];
    
    /** 你可以进行以下操作 */
    UILabel *labelProject = [[UILabel alloc]init];
    [self addSubview:labelProject];
    [labelProject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelActivity.mas_left);
        make.top.equalTo(viewFamily.mas_bottom);
        make.height.equalTo(@40);
    }];
    labelProject.text = @"你可以进行以下操作";
    labelProject.textColor = XZColor(119, 119, 120);
    labelProject.font = LabelFont;
    
}

// 点击修改按钮
- (void)didClickAlterButtton:(UIButton *)button {
    if (self.blockAlter) {
        self.blockAlter(button);
    }
}

// 创建label
- (UILabel *)createLabelWithLeft:(UILabel *)leftLabel andTop:(UILabel *)topLabel andOffSet:(CGFloat)offSet {
    CGFloat size = (KProjectScreenWidth - 2) / 3.0;
    UILabel *labelRead = [[UILabel alloc]init];
    [self addSubview:labelRead];
    [labelRead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftLabel.mas_right).offset(1);
        make.top.equalTo(topLabel.mas_bottom).offset(offSet);
        make.height.equalTo(@((size - 1) / 2.0));
        make.width.equalTo(size);
    }];
    labelRead.textAlignment = NSTextAlignmentCenter;
    labelRead.backgroundColor = [UIColor whiteColor];
    labelRead.textColor =  XZColor(119, 119, 120);
    labelRead.font = LabelFont;
    return labelRead;
}

// 给label赋值
- (void)setModelRongMi:(XZActivityModel *)modelRongMi {
    
    
    _modelRongMi = modelRongMi;
    NSString *textEnroll = [NSString stringWithFormat:@"报名\n%@",modelRongMi.party_adder];
    NSString *textRead = [NSString  stringWithFormat:@"阅读 %@",modelRongMi.readernum];
    NSString *textShare = [NSString  stringWithFormat:@"分享 %@",modelRongMi.sharenum];
    NSString *textComment = [NSString  stringWithFormat:@"评论 %@",modelRongMi.commentnum];
    NSString *textSupport = [NSString  stringWithFormat:@"赞 %@",modelRongMi.praisenum];
    
    //  让文字是深黑色
    NSMutableAttributedString *(^makeDarkGrayColor)(NSString *,NSInteger) = ^(NSString *text,NSInteger length) {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:text];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, length)];
        return  attrStr;
    };
    // 赋值
    self.labelEnroll.attributedText = makeDarkGrayColor(textEnroll,2);
    self.labelRead.attributedText = makeDarkGrayColor(textRead,2);
    self.labelShare.attributedText = makeDarkGrayColor(textShare,2);
    self.labelComment.attributedText = makeDarkGrayColor(textComment,2);
    self.labelSupport.attributedText = makeDarkGrayColor(textSupport,1);
    self.labelRongMiFamily.text = [NSString stringWithFormat:@"%@",modelRongMi.party_theme];
}

@end
