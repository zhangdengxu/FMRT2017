//
//  FMRTAuctionRecordViewController.m
//  fmapp
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTAuctionRecordViewController.h"
#import "ZJScrollPageView.h"

#import "FMRTAucDetailRecordViewController.h"

@interface FMRTAuctionRecordViewController ()<ZJScrollPageViewDelegate>

@property(strong, nonatomic)FMRTAucDetailRecordViewController<ZJScrollPageViewChildVcDelegate> *currentChildVc;

@end

@implementation FMRTAuctionRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"参与记录"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    style.showCover = NO;
    style.scrollTitle = NO;
    style.gradualChangeTitleColor = YES;
    style.showLine = YES;
    style.titleFont = [UIFont systemFontOfSize:15];
    style.normalTitleColor = [HXColor colorWithHexString:@"#1e1e1e"];
    style.selectedTitleColor = [UIColor redColor];
    style.scrollLineColor = [UIColor redColor];
    NSMutableArray *titles = [NSMutableArray arrayWithObjects:@"全部",@"正在进行中",@"竞拍成功",@"竞拍失败", nil];

    ZJScrollPageView *scrollPageView = [[ZJScrollPageView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight) segmentStyle:style titles:titles parentViewController:self delegate:self];
    [self.view addSubview:scrollPageView];
}

- (NSInteger)numberOfChildViewControllers {
    return 4;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    
    if (!childVc) {
        childVc = [[FMRTAucDetailRecordViewController alloc] init];
    }
    _currentChildVc = (FMRTAucDetailRecordViewController *)childVc;
    
    return childVc;
}


@end
