//
//  XZRecommendView.m
//  XZFenLeiJieMian
//
//  Created by rongtuo on 16/4/22.
//  Copyright © 2016年 yuyang. All rights reserved.
//

#import "XZRecommendView.h"
#import "XZLargeButton.h"
@implementation XZRecommendView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 设置RecommendView子视图
        [self setUpRecommendView];
    }
    return self;
}
// 设置RecommendView子视图
- (void)setUpRecommendView {
    self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0f];
    // 白色背景图片
    UIView *view = [[UIView alloc]init];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);//.offset(64)
        make.height.equalTo(@200);
    }];
    view.backgroundColor = [UIColor whiteColor];
    // 今日收入图片
    UIImageView *imgIncome = [[UIImageView alloc]init];
    [view addSubview:imgIncome];
    [imgIncome mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(10);
        make.right.equalTo(view.mas_right).offset(-10);
        make.top.equalTo(view.mas_top).offset(10);
        make.height.equalTo(@180);
    }];
    imgIncome.image = [UIImage imageNamed:@"我的推荐_03"];
    // 今日收入提示
    UILabel *labelIncomePrompt = [[UILabel alloc]init];
    [imgIncome addSubview:labelIncomePrompt];
    [labelIncomePrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgIncome.mas_left).offset(10);
        make.top.equalTo(imgIncome.mas_top).offset(10);
    }];
    labelIncomePrompt.text = [NSString  stringWithFormat:@"今日收入"];
    labelIncomePrompt.textColor = [UIColor whiteColor];
    labelIncomePrompt.font = [UIFont systemFontOfSize:15];
    // 今日收入
    UILabel *labelIncome = [[UILabel alloc]init];
    [imgIncome addSubview:labelIncome];
    [labelIncome mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imgIncome.mas_centerX);
        //        make.right.equalTo(view.mas_right).offset(-10);
        make.centerY.equalTo(imgIncome.mas_centerY).offset(-10);
        //        make.height.equalTo(@180);
    }];
    labelIncome.text = [NSString  stringWithFormat:@"0.00\t元"];
    labelIncome.textColor = [UIColor whiteColor];
    labelIncome.font = [UIFont systemFontOfSize:27];
    self.labelIncome = labelIncome;
    // 月收入
    UILabel *labelMonthlyIncome = [[UILabel alloc]init];
    [imgIncome addSubview:labelMonthlyIncome];
    [labelMonthlyIncome mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelIncomePrompt.mas_left);
        make.right.equalTo(imgIncome.mas_centerX);
        make.bottom.equalTo(imgIncome.mas_bottom).offset(-13);
    }];
    labelMonthlyIncome.text = [NSString  stringWithFormat:@"月收入\t0.00元"];
    labelMonthlyIncome.textColor = [UIColor redColor];
    labelMonthlyIncome.font = [UIFont systemFontOfSize:15];
    labelMonthlyIncome.textAlignment = NSTextAlignmentCenter;
    self.labelMonthlyIncome = labelIncome;
    
    // 总收入
    UILabel *labelTotalIncome = [[UILabel alloc]init];
    [imgIncome addSubview:labelTotalIncome];
    [labelTotalIncome mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgIncome.mas_centerX);
        make.right.equalTo(imgIncome.mas_right);
        make.bottom.equalTo(labelMonthlyIncome.mas_bottom);
    }];
    labelTotalIncome.text = [NSString  stringWithFormat:@"总收入\t0.00元"];
    labelTotalIncome.textColor = [UIColor redColor];
    labelTotalIncome.font = [UIFont systemFontOfSize:15];
    labelTotalIncome.textAlignment = NSTextAlignmentCenter;
    self.labelTotalIncome = labelTotalIncome;
    
    // 我的销售订单
    UIView *viewSalesOrder = [[UIView alloc]init];
    [self addSubview:viewSalesOrder];
    [viewSalesOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_centerX).offset(-1);
        make.height.equalTo(@100);
        make.top.equalTo(view.mas_bottom).offset(5);
    }];
    viewSalesOrder.backgroundColor = [UIColor whiteColor];
    XZLargeButton *btnSalesOrder = [XZLargeButton buttonWithType:UIButtonTypeCustom];
    [viewSalesOrder addSubview:btnSalesOrder];
    [btnSalesOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewSalesOrder.mas_centerX);
        make.centerY.equalTo(viewSalesOrder.mas_centerY);
        make.height.and.width.equalTo(@100);
    }];
    [btnSalesOrder setTitle:@"我的销售订单" forState:UIControlStateNormal];
    [btnSalesOrder setImage:[UIImage imageNamed:@"我的销售订单_07"] forState:UIControlStateNormal];
    btnSalesOrder.titleLabel.font = [UIFont systemFontOfSize:14];
    btnSalesOrder.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btnSalesOrder setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    btnSalesOrder.backgroundColor = [UIColor whiteColor];
    self.btnSalesOrder = btnSalesOrder;
    // 我的推荐人管理
    UIView *viewRefereeMag = [[UIView alloc]init];
    [self addSubview:viewRefereeMag];
    [viewRefereeMag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX).offset(1);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@100);
        make.top.equalTo(view.mas_bottom).offset(5);
    }];
    viewRefereeMag.backgroundColor = [UIColor whiteColor];
    XZLargeButton *btnRefereeMag = [XZLargeButton buttonWithType:UIButtonTypeCustom];
    [viewRefereeMag addSubview:btnRefereeMag];
    [btnRefereeMag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewRefereeMag.mas_centerX);
        make.centerY.equalTo(viewRefereeMag.mas_centerY);
        make.height.and.width.equalTo(@100);
//        make.top.equalTo(btnSalesOrder.mas_top);
    }];
    [btnRefereeMag setTitle:@"我的推荐人管理" forState:UIControlStateNormal];
    [btnRefereeMag setImage:[UIImage imageNamed:@"我的管理人推荐_07"] forState:UIControlStateNormal];
    btnRefereeMag.titleLabel.font = [UIFont systemFontOfSize:14];
    btnRefereeMag.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btnRefereeMag setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    btnRefereeMag.backgroundColor = [UIColor whiteColor];
    self.btnRefereeMag = btnRefereeMag;

    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
