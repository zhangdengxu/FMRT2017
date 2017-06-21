//
//  XZActivityTabBar.m
//  fmapp
//
//  Created by admin on 16/7/1.
//  Copyright © 2016年 yk. All rights reserved.
// 活动页面下方的tabBar

#import "XZActivityTabBar.h"
#import "XZLargeButton.h"
// model
#import "XZActivityModel.h"

@interface XZActivityTabBar ()
/** 背景图 */
@property (nonatomic, strong) UIView *viewBackGround;
/** 报名已结束 */
@property (nonatomic, strong) XZLargeButton *btnEnd;
/** 赞 */
@property (nonatomic, strong) XZLargeButton *btnPraise;
/** 评论 */
@property (nonatomic, strong) XZLargeButton *btnComment;

@end

@implementation XZActivityTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpActivityTabBar];
    }
    return self;
}

- (void)setUpActivityTabBar {
    /** 背景图 */
    UIView *viewBackGround = [[UIView alloc]init];
    [self addSubview:viewBackGround];
    [viewBackGround mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.top.equalTo(self.mas_top);
    }];
    self.viewBackGround = viewBackGround;
    viewBackGround.backgroundColor = XZColor(196, 197, 198);
    
    CGFloat width = KProjectScreenWidth / 3.0;
    
    /** 评论 */
    XZLargeButton *btnComment = [self createButtonWithOffSet:0 andWidth:width andTitle:@"评论" andImage:@"5-1" andColor:[UIColor whiteColor]];
    btnComment.tag = 130;
    self.btnComment = btnComment;
    
    /** 赞 */
    XZLargeButton *btnPraise = [self createButtonWithOffSet:(width + 0.5) andWidth:width andTitle:@"赞" andImage:@"6-1" andColor:[UIColor whiteColor]];
    btnPraise.tag = 131;
    self.btnPraise = btnPraise;
    
    /** 报名已结束 */
    XZLargeButton *btnEnd = [self createButtonWithOffSet:(width * 2 + 0.5) andWidth:width andTitle:@"" andImage:@"23" andColor:XZColor(7, 64, 143)];
    self.btnEnd = btnEnd;
    btnEnd.tag = 132;
    
}

- (XZLargeButton *)createButtonWithOffSet:(CGFloat)offSet andWidth:(CGFloat)width andTitle:(NSString *)title andImage:(NSString *)image andColor:(UIColor *)color {
    XZLargeButton *btnComment = [XZLargeButton buttonWithType:UIButtonTypeCustom];
    [self.viewBackGround addSubview:btnComment];
    [btnComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewBackGround.mas_left).offset(offSet);
        make.width.equalTo(width);
        make.top.equalTo(self.viewBackGround.mas_top).offset(0.5);
        make.bottom.equalTo(self.viewBackGround.mas_bottom);
    }];
    [btnComment setTitle:title forState:UIControlStateNormal];
    [btnComment.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [btnComment setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btnComment.titleLabel setFont:[UIFont systemFontOfSize:11]];
    [btnComment.titleLabel setTextColor:[UIColor darkGrayColor]];
    [btnComment setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnComment.buttonTypecu = XZLargeButtonTypeActivityTabBar;
    [btnComment setBackgroundColor:color];
    [btnComment addTarget:self action:@selector(didClickMyBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return btnComment;
}

#pragma mark --- 点击按钮
- (void)didClickMyBtn:(UIButton *)button {
    if (self.blockTabBarBtn) {
        self.blockTabBarBtn(button);
    }
}

-(void)setActivityModel:(XZActivityModel *)activityModel {
    _activityModel = activityModel;
    NSString *joinsucces = [NSString stringWithFormat:@"%@",activityModel.joinsuccess];
    if ([joinsucces isEqualToString:@"0"]) { // 0我要报名
        [self.btnEnd setTitle:@"我要报名" forState:UIControlStateNormal];
        [self.btnEnd setBackgroundColor:XZColor(7, 64, 143)];
        self.btnEnd.userInteractionEnabled = YES;
    }else if ([joinsucces isEqualToString:@"1"]) { // 1报名已结束
        [self.btnEnd setTitle:@"报名已结束" forState:UIControlStateNormal];
        [self.btnEnd setBackgroundColor:[UIColor clearColor]];
        self.btnEnd.userInteractionEnabled = NO;
    }else if ([joinsucces isEqualToString:@"2"]) { // 2已报名
        [self.btnEnd setTitle:@"已报名" forState:UIControlStateNormal];
        [self.btnEnd setBackgroundColor:[UIColor clearColor]];
        self.btnEnd.userInteractionEnabled = NO;
    }else { // 3活动已结束
        [self.btnEnd setTitle:@"活动已结束" forState:UIControlStateNormal];
        [self.btnEnd setBackgroundColor:[UIColor clearColor]];
        self.btnEnd.userInteractionEnabled = NO;
    }
    
    NSString *ispraise = [NSString stringWithFormat:@"%@",activityModel.ispraise];
    if ([ispraise isEqualToString:@"1"]) { // 1已赞
        [self.btnPraise setTitle:[NSString stringWithFormat:@"已赞（%@）",activityModel.praisenum] forState:UIControlStateNormal];
    }else { // 0未赞
        [self.btnPraise setTitle:[NSString stringWithFormat:@"赞（%@）",activityModel.praisenum] forState:UIControlStateNormal];
    }
    
    [self.btnComment setTitle:[NSString stringWithFormat:@"评论（%@）",activityModel.commentnum] forState:UIControlStateNormal];
    
}

- (void)setPraiseNumber:(NSString *)praiseNumber {
    [self.btnPraise setTitle:[NSString stringWithFormat:@"已赞（%@）",praiseNumber] forState:UIControlStateNormal];
}

@end
