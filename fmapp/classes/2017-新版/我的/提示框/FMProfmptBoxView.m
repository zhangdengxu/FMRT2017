//
//  FMProfmptBoxView.m
//  fmapp
//
//  Created by runzhiqiu on 16/6/20.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMProfmptBoxView.h"

#import "AutoHeightLabel.h"


@interface FMProfmptBoxView ()

/** 提示的题目 */
@property (nonatomic, strong) UILabel *labelTitle;
/** 提示内容 */
@property (nonatomic, strong) UILabel *labelContent;
/** 确定按钮 */
@property (nonatomic, strong) UIButton *sureBtn;
/** 背景 */
@property (nonatomic, strong) UIView *cover;
/** 背景图 */
@property (nonatomic, strong) UIView *backView;
/** 图片 */
@property (nonatomic, strong) UIImageView *imgPhoto;

/** 提示内容数组 */
@property (nonatomic, strong) NSMutableArray *contentArray;

@property (nonatomic, assign) CGRect oldframe;

@property (nonatomic, strong) UIButton *btnClose;
@end


@implementation FMProfmptBoxView
- (NSMutableArray *)contentArray {
    if (!_contentArray) {
        _contentArray = [NSMutableArray arrayWithObjects:
                         @"系统并行期间，充值只能通过恒丰存管账户进行，原汇付托管账户不再受理充值业务，只可进行资金的转出；",
                         @"如需将汇付托管账户的余额转移到恒丰存管账户上，需要您先将汇付余额提现至您的银行卡，然后再通过充值，充到恒丰存管账户上；",
                         @"系统并行期间，项目所有的结息和回款返还至您的汇付托管账户；",
                         @"并行期结束，汇付托管账户关闭，若账户中还有余额，用户可自行登录汇付天下官网进行取现。", nil];
    }
    return _contentArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.oldframe = frame;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;

        self.frame = window.bounds;
        [self setUpProfmptBoxView];
    }
    return self;
}

-(void)hiddenViewAlertView
{
    [self removeFromSuperview];
}
-(void)showViewAlertView
{
    if (self.superview) {
        [self removeFromSuperview];
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;


    [window addSubview:self];
}
- (void)setUpProfmptBoxView {
    UIView *cover = [[UIView alloc]initWithFrame:self.bounds];
    [self addSubview:cover];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.5;
    self.cover = cover;
    
    /** 背景图 */
    UIView *backView = [[UIView alloc]init];
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.equalTo(@(self.oldframe.size.height));
    }];
    backView.backgroundColor = [UIColor whiteColor];
    [self bringSubviewToFront:backView];
    self.backView = backView;
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 5;
    
    /** 提示的题目 */
    UILabel *labelTitle = [[UILabel alloc]init];
    [backView addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(10);
        make.right.equalTo(backView).offset(-10);
        make.top.equalTo(backView.mas_top).offset(20);
    }];
    labelTitle.numberOfLines = 0;
    self.labelTitle = labelTitle;
    //    labelTitle.backgroundColor = [UIColor purpleColor];
    
    /** 提示内容 */
    UILabel *labelContent = [[UILabel alloc]init];
    [backView addSubview:labelContent];
    [labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelTitle.mas_bottom).offset(15);
        make.left.equalTo(backView.mas_left).offset(10);
        make.right.equalTo(backView.mas_right).offset(-10);
    }];
    labelContent.font = [UIFont systemFontOfSize:15];
    self.labelContent = labelContent;
    labelContent.numberOfLines = 0;
    //    labelContent.backgroundColor = [UIColor greenColor];
    /** 图片 */
    UIImageView *imgPhoto = [[UIImageView alloc]init];
    [backView addSubview:imgPhoto];
    [imgPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(labelContent.mas_right).offset(-5);
        make.top.equalTo(labelContent.mas_bottom).offset(-10);
        make.height.equalTo(@80);
        make.width.equalTo(@60);
    }];
    self.imgPhoto = imgPhoto;
    
    /** 确定按钮 */
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backView.mas_bottom);
        make.left.equalTo(backView.mas_left);
        make.right.equalTo(backView.mas_right);
        make.height.equalTo(@50);
    }];
    [sureBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [sureBtn setBackgroundColor:XZColor(14, 93, 210)];
    self.sureBtn = sureBtn;
    [sureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    /** 右上角的关闭按钮 */
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:btnClose];
    [btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView).offset(-5);
        make.top.equalTo(backView).offset(5);
        make.width.and.height.equalTo(@35);
    }];
    [btnClose setBackgroundImage:[UIImage imageNamed:@"弹窗关闭按钮"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(didClickCloseButton) forControlEvents:UIControlEventTouchUpInside];
}

// 按钮的点击事件
- (void)sureBtnAction:(UIButton *)button {
    
    [self hiddenViewAlertView];
    if (self.blockBtn) {
        self.blockBtn(button);
    }
}

// 点击关闭按钮
- (void)didClickCloseButton {
    [self hiddenViewAlertView];
}

// 赋值
- (void)profmptBoxWithTitle:(NSString *)title andContent:(NSString *)content andBtnTitle:(NSString *)btnTitle andHadImage:(BOOL)hadImage {
    if ([title isEqualToString:@"什么是冻结资金？"]||[title isEqualToString:@"什么是资产总额？"] || [title isEqualToString:@"什么是积分总额？"]) {
        self.labelTitle.textAlignment = NSTextAlignmentCenter;
    }else if ([title isEqualToString:@"新老存管账户并行期间关于充值、取现、投标等注意事项："]) {
        [self.labelContent remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
            make.width.equalTo(@0);
        }];
        // 新老用户并行的提示框
        [self systemProfmptView];
    }
    self.labelTitle.text = title;
    self.labelContent.attributedText = [self setUpLabelLineSpaceWithText:content];
    [self.sureBtn setTitle:btnTitle forState:UIControlStateNormal];
    if (hadImage) {
        self.imgPhoto.image = [UIImage imageNamed:@"登录提示小融_03"];
    }else {
        [self.imgPhoto remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
            make.width.equalTo(@0);
        }];
    }
}

/** 系统并行提示页面 */
- (void)systemProfmptView {
    UILabel *contentOne = [self createLabelWithTopLabel:self.labelTitle andLineSpace:20 andNumber:@"1." andContent:self.contentArray[0]];
    UILabel *contentTwo = [self createLabelWithTopLabel:contentOne andLineSpace:10 andNumber:@"2." andContent:self.contentArray[1]];
    UILabel *contentThree = [self createLabelWithTopLabel:contentTwo andLineSpace:10 andNumber:@"3." andContent:self.contentArray[2]];
    [self createLabelWithTopLabel:contentThree andLineSpace:10 andNumber:@"4." andContent:self.contentArray[3]];
}

/** 并行期间提示框的提示内容label的创建 */
- (UILabel *)createLabelWithTopLabel:(UILabel *)label andLineSpace:(CGFloat)offset andNumber:(NSString *)number andContent:(NSString *)content {
    /** 多条提示内容 */
    UILabel *labelNumber = [[UILabel alloc]init];
    [self.backView addSubview:labelNumber];
    [labelNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(offset); // 20
        make.left.equalTo(self.backView.mas_left).offset(10);
        make.width.equalTo(@15);
    }];
    labelNumber.text = number;
    labelNumber.font = [UIFont systemFontOfSize:15];
    //
    UILabel *labelNumberContent = [[UILabel alloc]init];
    [self.backView addSubview:labelNumberContent];
    [labelNumberContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelNumber.mas_top);
        make.left.equalTo(labelNumber.mas_right);
        make.right.equalTo(self.backView.mas_right).offset(-10);
    }];
    labelNumberContent.numberOfLines = 0;
    labelNumberContent.attributedText = [self setUpLabelLineSpaceWithText:content];
    labelNumberContent.font = [UIFont systemFontOfSize:15];
    return labelNumberContent;
}
// 设置label的行间距
- (NSMutableAttributedString *)setUpLabelLineSpaceWithText:(NSString *)text{
    //创建NSMutableAttributedString实例，并将text传入
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:text];
    //创建NSMutableParagraphStyle实例
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    //设置行距
    [style setLineSpacing:5.0f];
    //根据给定长度与style设置attStr式样
    [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [text length])];
    return attStr;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
