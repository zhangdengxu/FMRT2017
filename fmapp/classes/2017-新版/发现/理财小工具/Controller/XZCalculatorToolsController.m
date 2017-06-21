//
//  XZCalculatorToolsController.m
//  fmapp
//
//  Created by admin on 16/11/26.
//  Copyright © 2016年 yk. All rights reserved.
//  收益计算器/宝贝计划计算器

#import "XZCalculatorToolsController.h"
#import "XZEarningsCalculatorController.h" //  收益计算器
#import "XZBabyPlanCalculatorController.h" //  宝贝计划控制器

@interface XZCalculatorToolsController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollBottom;
@property (nonatomic, strong) XZEarningsCalculatorController *earningCal;
@property (nonatomic, strong) XZBabyPlanCalculatorController *babyPlanCal;
@end

@implementation XZCalculatorToolsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XZBackGroundColor;
    
    //
    [self createNavSegmentControl];
    //
    [self createChildViewAndController];
}

- (void)didClickSegmentedControl:(UISegmentedControl *)segmentSelected {
    NSInteger index = segmentSelected.selectedSegmentIndex;
    switch (index) {
        case 0:{// 收益计算器
            [self.babyPlanCal.view removeFromSuperview];
            [self.scrollBottom addSubview:self.earningCal.view];
            break;
        }
        case 1:{ // 宝贝计划计算器
            [self.earningCal.view removeFromSuperview];
            [self.scrollBottom addSubview:self.babyPlanCal.view];
            break;
        }
        default:
            break;
    }
}

- (void)createChildViewAndController {
    // 收益计算器
    XZEarningsCalculatorController *earningCal = [[XZEarningsCalculatorController alloc] init];
    [self addChildViewController:earningCal];
    [self.scrollBottom addSubview:earningCal.view];
    self.earningCal = earningCal;
    
    // 宝贝计划计算器
    XZBabyPlanCalculatorController *babyPlanCal = [[XZBabyPlanCalculatorController alloc] init];
    [self addChildViewController:babyPlanCal];
    self.babyPlanCal = babyPlanCal;
}

- (void)createNavSegmentControl {
    NSArray *segmentArr = @[@"收益计算器",@"宝贝计划计算器"];
    //
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:segmentArr];
    segmentControl.selectedSegmentIndex = 0;
    segmentControl.tintColor = XZColor(14, 93, 210);
    segmentControl.frame = CGRectMake(0, 0, KProjectScreenWidth * 0.6, 30);
    [segmentControl addTarget:self action:@selector(didClickSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentControl;
}

- (UIScrollView *)scrollBottom {
    if (!_scrollBottom) {
        _scrollBottom = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight)];
        _scrollBottom.delegate = self;
        _scrollBottom.contentSize = CGSizeMake(0, KProjectScreenHeight + 130); // + 45
        _scrollBottom.showsVerticalScrollIndicator = NO;
        _scrollBottom.backgroundColor = XZBackGroundColor;
        [self.view addSubview:_scrollBottom];
    }
    return _scrollBottom;
}

@end
