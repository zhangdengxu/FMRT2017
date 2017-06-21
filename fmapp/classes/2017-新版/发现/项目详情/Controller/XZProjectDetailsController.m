//
//  XZProjectDetailsController.m
//  fmapp
//
//  Created by admin on 17/4/10.
//  Copyright © 2017年 yk. All rights reserved.
//  项目信息====查看详情

#import "XZProjectDetailsController.h"
#import "XZProjectDetailSection.h" // section
#import "XZRepayAndRecordHeader.h" // header
#import "XZProjectRepaymentCell.h" // 还款模型
//#import "XZProjectBidRecordsCell.h" // 投标记录

@interface XZProjectDetailsController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableProjectDetails;
// 当前选中index
@property (nonatomic, assign) NSInteger currentIndex;
//
@property (nonatomic, assign) NSInteger currentPage;
// 数据
@property (nonatomic, strong) NSMutableArray *arrProjectDetails;
// 暂无数据
@property (nonatomic, strong) UIImageView *labelNoData;
// 头部
@property (nonatomic, strong) XZRepayAndRecordHeader *headerRepayAndRecord;
// 立即投资
@property (nonatomic, strong) UIButton *btnImmediate;
@end

@implementation XZProjectDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XZBackGroundColor;
    self.currentPage = 1;
    self.currentIndex = 0;
    [self createSegmentControl];
//    [self.view addSubview:self.tableProjectDetails];
    [self createProjectDetailsTableView:YES];
    // 立即投资
    [self createImmediateInvestmentButton];
}

#pragma mark ---- 每个segment的点击事件
- (void)didClickSegmentedControl:(UISegmentedControl *)segment {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    self.currentPage = 1;
    
    NSInteger index = segment.selectedSegmentIndex;
    
    switch (index) {
        case 0:// 描述
        {
            self.currentIndex = 0;
            self.headerRepayAndRecord.currnetIndex = 0;
            [self createProjectDetailsTableView:YES];
             break;
        }
        case 1:  // 还款类型
        {
            self.currentIndex = 1;
            [self.headerRepayAndRecord removeFromSuperview];
            [self.view addSubview:self.headerRepayAndRecord];
            self.headerRepayAndRecord.currnetIndex = 1;
            [self createProjectDetailsTableView:NO];
            break;
        }
        case 2:// 投标记录
        {
            self.currentIndex = 2;
            [self.headerRepayAndRecord removeFromSuperview];
            [self.view addSubview:self.headerRepayAndRecord];
            self.headerRepayAndRecord.currnetIndex = 2;
            [self createProjectDetailsTableView:NO];
            break;
        }
        default:{
            
            break;
        }
    }
}

- (void)fiwo {
    
}

#pragma mark ---- 请求数据
- (void)requestProjectDetailsDataFromNetWork:(NSString *)zhuangtai {
    NSDictionary *parameter = @{
                                @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                @"page_size":@10,
                                @"page":[NSString stringWithFormat:@"%ld",(long)self.currentPage],
                                @"zhuangtai":zhuangtai,
                                };
    
    __weak __typeof(&*self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:@"" parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        //        NSLog(@"站内信======%@",response.responseObject);
        if (!response.responseObject) {
            ShowAutoHideMBProgressHUD(weakSelf.view,@"当前网络不佳！");
        }else {
            if (response.code == WebAPIResponseCodeSuccess) {
                if (weakSelf.currentPage == 1) {
                    [weakSelf.arrProjectDetails removeAllObjects];
                }
                if (!response.responseObject[@"data"]) { // 返回值中没有data数据
                    if (weakSelf.currentPage == 1) {
                        [weakSelf.tableProjectDetails addSubview:weakSelf.labelNoData];
                    }
                }else { // 有数据
                    if (![response.responseObject[@"data"] isKindOfClass:[NSNull class]]) {
                        [weakSelf.labelNoData removeFromSuperview];
                        NSArray *dataArray = response.responseObject[@"data"];
                        if (dataArray.count > 0) { // data中有值
                            for (NSDictionary *dict in dataArray) {
//                                XZStandInsideLetterModel *modelInsideLetter = [[XZStandInsideLetterModel alloc]init];
//                                [modelInsideLetter setValuesForKeysWithDictionary:dict];
//                                modelInsideLetter.cellHeight = [modelInsideLetter.neirong getStringCGSizeWithMaxSize:CGSizeMake(KProjectScreenWidth - 57, MAXFLOAT) WithFont:[UIFont systemFontOfSize:14]].height;
//                                [self.arrProjectDetails addObject:modelInsideLetter];
                            }
                        }
                        else {
                            if (weakSelf.currentPage > 1) {
                                ShowAutoHideMBProgressHUD(weakSelf.view,@"暂无更多数据");
                            }
                        }
                    }
                }
            }
            else {
                ShowAutoHideMBProgressHUD(weakSelf.view,@"请重新加载");
            }
        }
        [weakSelf.tableProjectDetails.mj_header endRefreshing];
        [weakSelf.tableProjectDetails.mj_footer endRefreshing];
        [weakSelf.tableProjectDetails reloadData];
    }];
}

#pragma mark ----- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.currentIndex == 0) { // 描述
        return 5;
    }
    else { // 还款模型、投标记录
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = arc4random() % 8 + 1;
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentIndex == 0) { // 描述
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProjectDetailsCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProjectDetailsCell"];
        }
        return cell;
    }else if (self.currentIndex == 1) { // 还款模型
        XZProjectRepaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProjectRepaymentCell"];
        if (!cell) {
            cell = [[XZProjectRepaymentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProjectRepaymentCell"];
        }
        cell.currnetIndex = 1;
        return cell;
    }else { // 投标记录
//        XZProjectBidRecordsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProjectBidRecordsCell"];
//        if (!cell) {
//            cell = [[XZProjectBidRecordsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProjectBidRecordsCell"];
//        }
//        cell.currnetIndex = 2;
//        return cell;
        XZProjectRepaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProjectRepaymentCell"];
        if (!cell) {
            cell = [[XZProjectRepaymentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProjectRepaymentCell"];
        }
        cell.currnetIndex = 2;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentIndex == 0) { // 描述
        return 110;
    }else { //
        return 50;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.currentIndex == 0) {
        XZProjectDetailSection *setionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ProjectDetailSection"];
        if (!setionView) {
            setionView = [[XZProjectDetailSection alloc] initWithReuseIdentifier:@"ProjectDetailSection"];
        }
        return setionView;
    }else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.currentIndex == 0) {
        return 30;
    }
    else {
        return 0.001f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

#pragma mark ---- 创建"立即投资"按钮
- (void)createImmediateInvestmentButton {
    UIButton *btnImmediate = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btnImmediate];
    [btnImmediate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    [btnImmediate setBackgroundColor:XZColor(169, 170, 171)];
    self.btnImmediate = btnImmediate;
    [btnImmediate setTitle:@"立即投资" forState:UIControlStateNormal];
    [btnImmediate addTarget:self action:@selector(didClickImmediateButton) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark ---- 点击"立即投资"按钮
- (void)didClickImmediateButton {
    NSLog(@"立即投资");
}

#pragma mark ---- 创建segmentControl
- (void)createSegmentControl {
    NSArray *segmentArr = @[@"描述",@"还款模型",@"投标记录"];
    //
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:segmentArr];
    segmentControl.selectedSegmentIndex = 0;
    segmentControl.tintColor = XZColor(14, 93, 210);
    segmentControl.frame = CGRectMake(0, 0, KProjectScreenWidth * 0.6, 30);
    [segmentControl addTarget:self action:@selector(didClickSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentControl;
}

#pragma mark ---- 创建tableView
- (void)createProjectDetailsTableView:(BOOL)isFirst {
    [_tableProjectDetails removeFromSuperview];
    if (isFirst) {
        _tableProjectDetails = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 64 - 50) style:UITableViewStyleGrouped];
    }else {
        _tableProjectDetails = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, KProjectScreenWidth, KProjectScreenHeight - 64 - 50 - 40) style:UITableViewStylePlain];
    }
    _tableProjectDetails.delegate = self;
    _tableProjectDetails.dataSource  = self;
    _tableProjectDetails.backgroundColor = XZBackGroundColor;
    _tableProjectDetails.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableProjectDetails.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableProjectDetails];
    
    __weak __typeof(&*self)weakSelf = self;
    _tableProjectDetails.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        [self requestProjectDetailsDataFromNetWork:@""];
    }];
    
    if (self.currentIndex != 0) {
        _tableProjectDetails.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.currentPage = weakSelf.currentPage + 1;
            [weakSelf requestProjectDetailsDataFromNetWork:@""];
        }];
    }
    
}

#pragma mark ---- 懒加载
- (NSMutableArray *)arrProjectDetails {
    if (!_arrProjectDetails) {
//        _arrProjectDetails = [NSMutableArray array];
        _arrProjectDetails = @[
                               @[
                                   @{@"title":@"借款方简介",
                                     @"content":@[@"本项目投标已结束，为保护借款人隐私暂不支持查看。"],
                                     @"pics":@[],
                                 }],
                               @[
                                   @{@"title":@"借款方相关资料",
                                 @"content":@[@"本项目投标已结束，为保护借款人隐私暂不支持查看。"],
                                 @"pics":@[],
                                 }],
                              @[
                                   @{@"title":@"保理公司简介",
                                 @"content":@[@"本项目投标已结束，为保护借款人隐私暂不支持查看。",@"本项目投标已结束，为保护借款人隐私暂不支持查看。"],
                                 @"pics":@[],
                                 }],
                              @[
                                   @{@"title":@"保理公司相关材料",
                                     @"pics":@[],
                                 }],
                              @[
                                   @{@"title":@"回购承诺函",
                                 @"pics":@[@"图片",@"图片",@"图片",@"图片"],
                                 }],
                              @[ @{@"title":@"风险控制措施",
                                 @"content":@[@"本项目投标已结束，为保护借款人隐私暂不支持查看。"],
                                 @"pics":@[],
                                 }],
                              @[
                                   @{@"title":@"融托金融独立意见",
                                 @"content":@[@"该项目风险低，借款企业发生不按时还本付息等违约事项的可能性极小，保理公司承诺无条件债权回购，具有很强的抗风险能力，该业务风险控制措施到位，各相关手续完善、合法，可有效控制该业务风险。"],
                                 @"pics":@[],
                                 }],
                               ].mutableCopy;
    }
    return _arrProjectDetails;
}

- (UIImageView *)labelNoData {
    if (!_labelNoData) {
        _labelNoData = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth,KProjectScreenWidth * 822 / 486.0 - 50)];
        _labelNoData.image = [UIImage imageNamed:@"暂无数据"];
    }
    return _labelNoData;
}

- (XZRepayAndRecordHeader *)headerRepayAndRecord {
    if (!_headerRepayAndRecord) {
        _headerRepayAndRecord = [[XZRepayAndRecordHeader alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 40)];
    }
    return _headerRepayAndRecord;
}

//- (UITableView *)tableProjectDetails {
//    if (!_tableProjectDetails) {
//        _tableProjectDetails = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 64 - 44) style:UITableViewStyleGrouped];
//        _tableProjectDetails.delegate = self;
//        _tableProjectDetails.dataSource  = self;
//        _tableProjectDetails.backgroundColor = XZBackGroundColor;
//        _tableProjectDetails.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableProjectDetails.showsVerticalScrollIndicator = NO;
//    }
//    return _tableProjectDetails;
//}


@end
