//
//  XZMyOrderViewController.m
//  XZFenLeiJieMian
//
//  Created by rongtuo on 16/4/29.
//  Copyright © 2016年 yuyang. All rights reserved.
//

#import "XZMyOrderViewController.h"
#import "WJSegmentMenuVc.h"
#import "XZMyOrderTableViewController.h"
#import "XZMyOrderTableView.h"
#import "FMMessageAlterView.h"
#import "WLMessageViewController.h"
#import "FMRTWellStoreViewController.h"
@interface XZMyOrderViewController ()<WJSegmentMenuVcDelegate,FMMessageAlterViewDelegate,XZMyOrderTableViewControllerDelegate>
/** title */
@property (nonatomic, strong) NSMutableArray *titleDataSource;
/* 创建WJSegmentMenuVc */
@property (nonatomic, strong) WJSegmentMenuVc *segmentMenuVc;
/** 请求的数据 */
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation XZMyOrderViewController
- (NSMutableArray *)titleDataSource {
    if (!_titleDataSource) {
        _titleDataSource = [NSMutableArray arrayWithObjects:@"全部",@"待付款",@"待发货",@"待收货",@"待评价",@"退款/售后", nil];
    }
    return _titleDataSource;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self settingNavTitle:@"我的订单"];
     __weak __typeof(&*self)weakSelf = self;
    // 返回
    self.navBackButtonRespondBlock = ^() {
        [weakSelf didClickBackButton];
    };
    [self createSegmentMenuVc];
    [self setNavItemsWithButton];
}
-(void)didClickBackButton
{
    if (self.isRemoveFather) {
        NSArray * controlls = self.navigationController.viewControllers;
        UIViewController *vc;
        if (controlls.count > 2) {
            vc = controlls[controlls.count - 3];
        }
        if (vc) {
            [self.navigationController popToViewController:vc animated:YES];
        }else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];

    }
}
- (void)createSegmentMenuVc {
    /* 创建WJSegmentMenuVc */
    WJSegmentMenuVc *segmentMenuVc = [[WJSegmentMenuVc alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 45)];
    self.segmentMenuVc = segmentMenuVc;
    [self.view addSubview:segmentMenuVc];
    
    /* 自定义设置(可不设置为默认值) */
    segmentMenuVc.backgroundColor = [UIColor whiteColor];
    segmentMenuVc.titleFont = [UIFont systemFontOfSize:16.0];
    segmentMenuVc.selectTitleFont = [UIFont systemFontOfSize:17.0];
    segmentMenuVc.unlSelectedColor = [UIColor colorWithWhite:0.2 alpha:1];
    segmentMenuVc.selectedColor = [UIColor blackColor];
    segmentMenuVc.MenuVcSlideType = WJSegmentMenuVcSlideTypeSlide;
    segmentMenuVc.delegate = self;
    segmentMenuVc.SlideColor = [UIColor colorWithRed:(255/255.0) green:(103/255.0) blue:(51/255.0) alpha:1];
    segmentMenuVc.advanceLoadNextVc = YES;
    NSMutableArray * muarray = [NSMutableArray array];
    for (int i = 0; i < self.titleDataSource.count; i++) {
        XZMyOrderTableViewController *vc = [[XZMyOrderTableViewController alloc]init];
        [muarray addObject:vc];
        vc.type = i;
        vc.delegate = self;
    }
    /* 导入数据 */
    [self.segmentMenuVc addSubVc:muarray subTitles:self.titleDataSource];
}



- (void)searchItemAction:(UIButton *)sender {
    Log(@"点击了搜索按钮");
}
- (void)setNavItemsWithButton {
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    messageButton.frame =CGRectMake(0, 0, 30, 30);
    [messageButton setImage:[UIImage imageNamed:@"优商城售后_未读消息_36"] forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(moreItemAction:) forControlEvents: UIControlEventTouchUpInside];
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame =CGRectMake(0, 0, 30, 30);
    [editButton setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(searchItemAction:) forControlEvents: UIControlEventTouchUpInside];
    editButton.hidden = YES;
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc]initWithCustomView:editButton];
    UIBarButtonItem *navItem = [[UIBarButtonItem alloc]initWithCustomView:messageButton];
    [self.navigationItem setRightBarButtonItems:@[navItem,titleItem] animated:YES];
}
- (void)moreItemAction:(UIButton *)sender {
    FMMessageModel *one = [[FMMessageModel alloc] initWithTitle:@"消息" imageName:@"优商城消息-消息04" isShowRed:NO];
    FMMessageModel *two = [[FMMessageModel alloc] initWithTitle:@"首页" imageName:@"优商城消息-消息03"  isShowRed:NO];
    NSArray * dataArr = @[one, two];
    
    __block  FMMessageAlterView * messageAlter = [[FMMessageAlterView alloc] initWithDataArray:dataArr origin:CGPointMake(KProjectScreenWidth - 15, 64) width:100 height:40 direction:kFMMessageAlterViewDirectionRight];
    messageAlter.delegate = self;
    messageAlter.dismissOperation = ^(){
        //设置成nil，以防内存泄露
        messageAlter = nil;
    };
    [messageAlter pop];
}

- (void)didSelectedAtIndexPath:(NSIndexPath *)indexPath;
{
    
    if (indexPath.row == 0) {
        
        WLMessageViewController *wlVc = [[WLMessageViewController alloc]init];
        wlVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wlVc animated:YES];
    }else
    {
        FMRTWellStoreViewController * rootViewController;
        for (UIViewController * viewController in self.navigationController.viewControllers) {
            if ([viewController isKindOfClass:[FMRTWellStoreViewController class]]) {
                rootViewController = (FMRTWellStoreViewController *)viewController;
            }
        }
        if (rootViewController) {
            self.navigationController.navigationBarHidden = NO;
            [self.navigationController popToViewController:rootViewController animated:NO];
        }
    }
}


-(void)XZMyOrderTableViewController:(XZMyOrderTableViewController *)viewController didselectTitle:(NSInteger)index;
{
    [self.segmentMenuVc  selectItemTitle:index];
}

-(void)WJSegmentMenuVcChange:(WJSegmentMenuVc *)segmentMenu withController:(UIViewController *)viewController;
{
    if ([viewController isMemberOfClass:[XZMyOrderTableViewController class]]) {
        XZMyOrderTableViewController * order = (XZMyOrderTableViewController *)viewController;
        
        //if (order.type == XZMyOrderTableViewTypeWaitComment) {
            [order refreshView];
        //}
    }
}


@end
