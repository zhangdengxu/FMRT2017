//
//  XZBaskOrderNewController.m
//  fmapp
//
//  Created by admin on 16/10/28.
//  Copyright © 2016年 yk. All rights reserved.
//  晒单列表/专区

#import "XZBaskOrderNewController.h"
#import "XZBaskOrderNewCell.h" //  晒单专区cell
#import "XZBaskOrderModel.h" // model

#import "XZMySnatchController.h" // 我的夺宝
#import "XZCommonProblemsController.h"//  常见问题

#define kXZBaskOrderListUrl [NSString stringWithFormat:@"%@/public/newon/comment/getComments",kXZTestEnvironment]
// @"http://114.55.115.60:18080/public/newon/comment/getComments"


@interface XZBaskOrderNewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

/** table */
@property (nonatomic, strong) UITableView *tableBaskOrderList;
/** 数据 */
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@property (nonatomic, assign) int currentPage;
@property (nonatomic, strong) UIImageView *labelHeaderView;

@end

@implementation XZBaskOrderNewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.view.backgroundColor = XZColor(229, 233, 242);
    [self settingNavTitle:@"晒单专区"];
    self.currentPage = 1;
    // tableView
    [self.view addSubview:self.tableBaskOrderList];
    [self createRightButtonAndOtherButton];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // 获取数据
    [self getDataFromNetwork];
}

#pragma mark --- 晒单列表数据请求
- (void)getDataFromNetwork {
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"page":[NSString stringWithFormat:@"%d",self.currentPage],
                                 };
    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient postPath:kXZBaskOrderListUrl parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (self.currentPage == 1) {
            [self.dataSourceArray removeAllObjects];
        }
//        NSLog(@"response.responseObject = %@",response.responseObject);
        if (response.code == WebAPIResponseCodeSuccess) {
            if (![response.responseObject isKindOfClass:[NSNull class]]) {
                // 数据请求成功
                NSArray *dataArray = response.responseObject[@"data"];
                if (dataArray.count != 0) {
                    for (NSDictionary *dict in dataArray) {
                        XZBaskOrderModel *model = [[XZBaskOrderModel alloc] init];
                        [model setValuesForKeysWithDictionary:dict];
//                        model.isNewIndiana = YES;
                        model.contentH = [model.comment_content getStringCGSizeWithMaxSize:CGSizeMake(KProjectScreenWidth - 80, MAXFLOAT) WithFont:[UIFont systemFontOfSize:14]].height;
                        [self.dataSourceArray addObject:model];
                        if (self.dataSourceArray.count > 0) {
                            // 去掉无数据提示
                            [self.labelHeaderView removeFromSuperview];
                        }
                    }
                } else {
                    // 无数据
                    if (self.dataSourceArray.count == 0) {
                        [self.tableBaskOrderList addSubview:self.labelHeaderView];
                    }
                }
            }else{
                // 无数据
                if (self.dataSourceArray.count == 0) {
                    [self.tableBaskOrderList addSubview:self.labelHeaderView];
                }
            }
        }else {
            // 无数据
            if (self.dataSourceArray.count == 0) {
                [self.tableBaskOrderList addSubview:self.labelHeaderView];
            }
        }
        [weakSelf.tableBaskOrderList reloadData];
        [weakSelf.tableBaskOrderList.mj_header endRefreshing];
        [weakSelf.tableBaskOrderList.mj_footer endRefreshing];
    }];
    
}

#pragma mark ----- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZBaskOrderNewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaskOrderListCell"];
    if (!cell) {
        cell = [[XZBaskOrderNewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BaskOrderListCell"];
    }
    XZBaskOrderModel *model = self.dataSourceArray[indexPath.row];
    cell.modelBaskOrder = model;
//    __weak __typeof(&*self)weakSelf = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZBaskOrderModel *model = self.dataSourceArray[indexPath.row];
    CGFloat size = (KProjectScreenWidth - 80 - KProjectScreenWidth * 0.06) / 3.0;
    return  model.contentH + 110 + size; // 110 --- 145
}

// 创建右侧按钮和返回顶部、联系客服
- (void)createRightButtonAndOtherButton {
    // 返回顶部
    CGFloat returTopView_width = 35;
    UIButton * returTopView = [[UIButton alloc]initWithFrame:CGRectMake(KProjectScreenWidth - returTopView_width - 5, self.view.frame.size.height - 64 - returTopView_width - 30, returTopView_width, returTopView_width)];
    [returTopView setBackgroundImage:[UIImage imageNamed:@"返回顶部"] forState:UIControlStateNormal];
    [returTopView addTarget:self action:@selector(didClickScrollToTopButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returTopView];
    [self.view bringSubviewToFront:returTopView];
    
    // 联系客服
    UIButton * callTelephoneView = [[UIButton alloc]initWithFrame:CGRectMake(KProjectScreenWidth - returTopView_width - 5 , self.view.frame.size.height - 64 - returTopView_width - 30 - 10 - returTopView_width, returTopView_width, returTopView_width)];
    [callTelephoneView setBackgroundImage:[UIImage imageNamed:@"联系客服-改版"] forState:UIControlStateNormal];
    [callTelephoneView addTarget:self action:@selector(didClickContactServiceButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:callTelephoneView];
    [self.view bringSubviewToFront:callTelephoneView];
}

// 回到顶部
-(void)didClickScrollToTopButton:(UIButton *)button
{
    [self.tableBaskOrderList setContentOffset:CGPointMake(0, 0) animated:YES];
}

// 常见问题
-(void)didClickContactServiceButton:(UIButton *)button
{

    XZCommonProblemsController *commonProblem = [[XZCommonProblemsController alloc] init];
    [self.navigationController pushViewController:commonProblem animated:YES];
}

#pragma mark ---- 懒加载
- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}

- (UITableView *)tableBaskOrderList {
    if (!_tableBaskOrderList) {
        _tableBaskOrderList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 64) style:UITableViewStylePlain];
        _tableBaskOrderList.showsVerticalScrollIndicator = NO;
        _tableBaskOrderList.delegate = self;
        _tableBaskOrderList.dataSource  = self;
        _tableBaskOrderList.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableBaskOrderList.backgroundColor = XZColor(229, 233, 242);
        __weak __typeof(&*self)weakSelf = self;
        _tableBaskOrderList.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.currentPage = 1;
            [weakSelf getDataFromNetwork];
        }];
        _tableBaskOrderList.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.currentPage = weakSelf.currentPage + 1;
            [weakSelf getDataFromNetwork];
        }];
    }
    return _tableBaskOrderList;
}

- (UIImageView *)labelHeaderView {
    if (!_labelHeaderView) {
        _labelHeaderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth,KProjectScreenWidth * 822 / 486.0)];
        _labelHeaderView.image = [UIImage imageNamed:@"暂无数据"];
    }
    return _labelHeaderView;
}


@end
