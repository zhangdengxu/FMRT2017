//
//  XZFinanceToolsController.m
//  fmapp
//
//  Created by admin on 16/11/26.
//  Copyright © 2016年 yk. All rights reserved.
//  理财小工具

#import "XZFinanceToolsController.h"
#import "XZCalculatorToolsController.h" //  收益计算器/宝贝计划计算器
#import "XZEarningsCalculatorController.h" // 收益计算器
#import "FMAcountMainViewController.h" // 我要记账

@interface XZFinanceToolsController ()

@end

@implementation XZFinanceToolsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XZBackGroundColor;
    //
    [self setTitle:@"理财小工具"];
    //
    [self createFinanceToolsChildView];
}

- (void)createFinanceToolsChildView {
    // 我要记账
    UIView *viewAccount = [self createSingleViewWithTopView:self.view isFirst:YES];
    viewAccount.backgroundColor = [UIColor whiteColor];
    UIImageView *imageAccount = [self createImageWithSuperView:viewAccount imageName:@"理财工具_我要记账_36"];
    [self createLabelWithSuperView:viewAccount leftView:imageAccount text:@"我要记账" color:[UIColor blackColor] isFirst:YES font:15.0f];
    [self createLabelWithSuperView:viewAccount leftView:imageAccount text:@"精打细算就靠你" color:[UIColor grayColor] isFirst:NO font:13.0f];
    [self createButtonWithSuperView:viewAccount btnTag:400];
    
    // 收益计算器
    UIView *viewCalculator = [self createSingleViewWithTopView:viewAccount isFirst:NO];
    viewCalculator.backgroundColor = [UIColor whiteColor];
    UIImageView *imageCalculator = [self createImageWithSuperView:viewCalculator imageName:@"理财工具_收益计算器_36"];
    [self createLabelWithSuperView:viewCalculator leftView:imageCalculator text:@"收益计算器" color:[UIColor blackColor] isFirst:YES font:15.0f];
    [self createLabelWithSuperView:viewCalculator leftView:imageCalculator text:@"理财计划更合理" color:[UIColor grayColor] isFirst:NO font:13.0f];
    [self createButtonWithSuperView:viewCalculator btnTag:401];
}

// 创建label
- (UILabel *)createLabelWithSuperView:(UIView *)superV leftView:(UIView *)leftView text:(NSString *)text color:(UIColor *)color isFirst:(BOOL)isFirst font:(CGFloat)font {
    UILabel *label = [[UILabel alloc] init];
    [superV addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        if (isFirst) {
            make.bottom.equalTo(superV.mas_centerY);
        }else{
            make.top.equalTo(superV.mas_centerY).offset(5);
        }
        make.left.equalTo(leftView.mas_right).offset(10);
    }];
    label.text = text;
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = color;
    return label;
}

// 创建左侧图片
- (UIImageView *)createImageWithSuperView:(UIView *)superView imageName:(NSString *)imageName {
    UIImageView *imageL = [[UIImageView alloc] init];
    [superView addSubview:imageL];
    [imageL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView).offset(10);
        make.centerY.equalTo(superView);
//        make.height.equalTo(@46);
//        make.width.equalTo(@46);
    }];
    imageL.image = [UIImage imageNamed:imageName];
    return imageL;
}

// 创建白色背景view
- (UIView *)createSingleViewWithTopView:(UIView *)topView isFirst:(BOOL)isFirst{
    UIView *viewAccount = [[UIView alloc] init];
    [self.view addSubview:viewAccount];
    __weak __typeof(&*self)weakSelf = self;
    [viewAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        if (isFirst) {
          make.top.equalTo(topView).offset(1);
        }else {
          make.top.equalTo(topView.mas_bottom).offset(1);
        }
        make.height.equalTo(@80);
    }];
    viewAccount.backgroundColor = [UIColor whiteColor];
    return viewAccount;
}

// 创建button
- (void)createButtonWithSuperView:(UIView *)superView btnTag:(NSInteger)btnTag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [superView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView);
        make.right.equalTo(superView);
        make.top.equalTo(superView);
        make.bottom.equalTo(superView);
    }];
    [button addTarget:self action:@selector(didClickFinanceToolsButton:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = btnTag;
}

- (void)didClickFinanceToolsButton:(UIButton *)button {
    if (button.tag == 400) { // 我要记账
        if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) { // 登录
            FMAcountMainViewController *accountMain = [[FMAcountMainViewController alloc] init];
            accountMain.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:accountMain animated:YES];
        }else { // 未登录
            LoginController *registerController = [[LoginController alloc] init];
            FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
            [self.navigationController presentViewController:navController animated:YES completion:^{
            }];
        }
    }else { // 收益计算器
        XZCalculatorToolsController *calculator = [[XZCalculatorToolsController alloc] init];
        calculator.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:calculator animated:YES];
    }
}

@end
