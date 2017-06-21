//
//  YYPlatformClosedView.m
//  fmapp
//
//  Created by yushibo on 2017/5/11.
//  Copyright © 2017年 yk. All rights reserved.
//  平台关闭公告

#import "YYPlatformClosedView.h"

@implementation YYPlatformClosedView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    /**
     *  背景backView
     */
    UIView *backView = [[UIView alloc]init];
    backView.userInteractionEnabled = YES;
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 10.0;
    [self addSubview:backView];
    [backView makeConstraints:^(MASConstraintMaker *make) {
        if (KProjectScreenWidth > 320) {
            make.left.equalTo(self.mas_left).offset(40);
            make.right.equalTo(self.mas_right).offset(-40);
        }else{
            make.left.equalTo(self.mas_left).offset(15);
            make.right.equalTo(self.mas_right).offset(-15);
        }
        
        make.top.equalTo(self.mas_top).offset(KProjectScreenHeight / 4 + 30);
        make.height.equalTo(@202);
    }];

    /**
     *  标题
     */
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = @"温馨提示";
//    self.titleLabel = titleLabel;
    [backView addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left);
        make.right.equalTo(backView.mas_right);
        make.top.equalTo(@15);
    }];
    /**
     *  您好,我平台已关闭汇付通道,
     */
    UILabel *Label1 = [[UILabel alloc]init];
    Label1.textAlignment = NSTextAlignmentLeft;
    Label1.numberOfLines = 0;
    Label1.textColor = [UIColor colorWithHexString:@"#666666"];
    Label1.font = [UIFont systemFontOfSize:15];
    Label1.text = @"您好，我平台已关闭汇付通道，";
//    self.chengweiLabel = chengweiLabel;
    [backView addSubview:Label1];
    [Label1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(20);
        make.right.equalTo(backView.mas_right);
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
    }];
    //
    /** 您可到汇付天下官网  */
    UILabel * Label2 = [[UILabel alloc]init];
    Label2.font = [UIFont systemFontOfSize:15];
    //    neirongLabel.backgroundColor = [UIColor greenColor];
    Label2.numberOfLines = 0;
    Label2.textColor = [UIColor colorWithHexString:@"#666666"];
//    self.neirongLabel = neirongLabel;
    Label2.text = @"您可到汇付天下官网";
    [backView addSubview:Label2];
    [Label2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(Label1.mas_left);
        make.right.equalTo(backView.mas_right);
        make.top.equalTo(Label1.mas_bottom).offset(4);
    }];
    
    /**
     *  汇付天下官网链接跳转
     */
    UIButton *jumpToBtn = [[UIButton alloc]init];
//    jumpToBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    jumpToBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [jumpToBtn setTitle:@"https://c.chinapnr.com/p2puser/" forState:UIControlStateNormal];
    [jumpToBtn setTitleColor:[UIColor colorWithHexString:@"#0159D5"] forState:UIControlStateNormal];
    [jumpToBtn addTarget:self action:@selector(jumpToAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:jumpToBtn];
    [jumpToBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(Label1.mas_left);
//        make.right.equalTo(backView.mas_right);
        make.top.equalTo(Label2.mas_bottom).offset(1);
    }];

    /**
     *  登陆您的汇付账户，查看余额或提现。
     */
    UILabel *Label4 = [[UILabel alloc]init];
    Label4.textAlignment = NSTextAlignmentLeft;
    Label4.textColor = [UIColor colorWithHexString:@"#666666"];
    Label4.font = [UIFont systemFontOfSize:15];
    Label4.text = @"登陆您的汇付账户，查看余额或提现。";
//    self.authorLabel = Label4;
    [backView addSubview:Label4];
    [Label4 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(Label1.mas_left);
        make.right.equalTo(backView.mas_right);
        make.top.equalTo(jumpToBtn.mas_bottom).offset(1);

    }];
    
    /**
     *  我知道了
     */
    UIButton *clickBtn = [[UIButton alloc]init];
    clickBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    clickBtn.titleLabel.font = [UIFont systemFontOfSize:19];
    [clickBtn setTitle:@"我知道了" forState:UIControlStateNormal];
    [clickBtn setTitleColor:[UIColor colorWithHexString:@"#0159D5"] forState:UIControlStateNormal];
    [clickBtn addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
//    [clickBtn setBackgroundColor:[UIColor redColor]];
    [backView addSubview:clickBtn];
    [clickBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left);
        make.right.equalTo(backView.mas_right);
        make.top.equalTo(Label4.mas_bottom);
        make.height.equalTo(60);
    }];
    

    
}

- (void)jumpToAction{

    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://c.chinapnr.com/p2puser/"]];

}
- (void)clickAction{

    [self removeFromSuperview];

}
@end
