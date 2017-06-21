//
//  YYMyBillController.m
//  fmapp
//
//  Created by yushibo on 2017/2/24.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "YYMyBillController.h"
#import "YYMyBillCell.h"
#import "FMRTMonthAcountViewController.h"
#import "YSImportantNoticeSecondNewView.h"
#import "YYScreeningDataView.h"
#import "YYMyBillModel.h"  // 老需求
#import "YYNewMonth.h"   // 新需求 接收月份 模型
@interface YYMyBillController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong) YYMyBillModel *model;
//@property (nonatomic, strong) NSMutableArray *monthList1;
@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) NSString *CurDate;
@property (nonatomic, strong) YYScreeningDataView *ScreeningDataVc;
@property (nonatomic, strong) NSString *DealTrench;
@property (nonatomic, assign) NSInteger currentPage;
@property(nonatomic,strong)UIImageView *backGroundImage;


/**  新需求 */
@property (nonatomic, strong) NSMutableArray *monthArray;
@property (nonatomic, strong) NSMutableArray *recordsArray;
@property (nonatomic, strong) NSString *selectedMonth;
@property (nonatomic, assign) NSInteger senderViewTag;


@end

@implementation YYMyBillController

-(YYScreeningDataView *)ScreeningDataVc{

    if (!_ScreeningDataVc) {
        YYScreeningDataView *vc = [[YYScreeningDataView alloc]initWithFrame:CGRectMake(KProjectScreenWidth , 20, KProjectScreenWidth, KProjectScreenHeight - 20)];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview: vc];
        _ScreeningDataVc = vc;
    }
    return _ScreeningDataVc;
}
- (UIImageView *)backGroundImage{

    if (!_backGroundImage) {
        _backGroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenWidth*822/486)];
        [_backGroundImage setImage:[UIImage imageNamed:@"暂无数据"]];
        [_backGroundImage setBackgroundColor:[UIColor redColor]];
        [self.tableView addSubview:_backGroundImage];
    }
    return _backGroundImage;

}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.monthList1 = [NSMutableArray array];
    
    self.monthArray = [NSMutableArray array];
    self.recordsArray = [NSMutableArray array];

    self.currentPage = 1;
    self.senderViewTag = 0;
    self.view.backgroundColor = [HXColor colorWithHexString:@"#f4f5f9"];
    self.DealTrench = @"0,1,2,3,4,5";
    [self settingNavTitle:@"账单"];
    [self setRightNavItem];
    [self setUpTableView];
    [self requestDatatoCollectionView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.shadowImage = nil;
}

- (void)setRightNavItem{
    
    UIButton * screeningDataBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [screeningDataBtn setImage:[UIImage imageNamed:@"月账单_筛选_03_1702"] forState:UIControlStateNormal];
    [screeningDataBtn sizeToFit];
    [screeningDataBtn addTarget:self action:@selector(screeningDataClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:screeningDataBtn];
    
}

-(void)screeningDataClick{
    

    FMWeakSelf
    self.ScreeningDataVc.modelBlock = ^(NSString *type){
    
        weakSelf.DealTrench = type;
//        NSLog(@"%@",weakSelf.DealTrench);
        weakSelf.senderViewTag = 0;
        weakSelf.currentPage = 1;
        [weakSelf requestDatatoCollectionView];
    };
    [UIView animateWithDuration:0.5 animations:^{
        
        self.ScreeningDataVc.frame = CGRectMake(0, 20, KProjectScreenWidth, KProjectScreenHeight - 20);
    }];
}

#pragma mark -- 请求有月份数据的接口
- (void)requestDatatoCollectionView{
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"AppId":@"huiyuan",
                                 @"AppTime":[NSNumber numberWithInt:timestamp],
                                 @"Token":tokenlow,
                                 //   @"CmdId":@"GetDealList",
                                 @"DealTrench":self.DealTrench,
                                 //                                 @"PageSize":@"10",
                                 @"PageNum":@(self.currentPage)
                                 };
    
    // NSLog(@"参数是%@",parameter);
    
    FMWeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    [FMHTTPClient postPath:kXZUniversalTestUrl(@"GetDealMonthList") parameters:parameter completion:^(WebAPIResponse *response) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        if (!response.responseObject) {
            
            //            ShowAutoHideMBProgressHUD(weakSelf.view, @"请求网络数据失败!");
            if (weakSelf.monthArray.count) {
                
                self.backGroundImage.hidden = YES;
            }else{
                self.backGroundImage.hidden = NO;
                
            }
            
        }else{
            
            if (response.code==WebAPIResponseCodeSuccess) {
                
                
                if (weakSelf.currentPage == 1) {
                    [weakSelf.monthArray removeAllObjects];
                    [weakSelf.recordsArray removeAllObjects];
                }
                
                
                NSDictionary *dataDic = [response.responseObject objectForKey:@"data"];
                NSArray *monthlistA = dataDic[@"MonthList"];
                self.CurDate = dataDic[@"CurDate"];
                
                if ([dataDic isKindOfClass:[NSNull class]]){
                    
                    if (weakSelf.monthArray.count) {
                        
                        self.backGroundImage.hidden = YES;
                    }else{
                        self.backGroundImage.hidden = NO;
                        
                    }
                }else{
                    
                    
                    if ([monthlistA isKindOfClass:[NSArray class]]) {
                        
                        if (monthlistA.count) {
                            for (NSDictionary *dict in monthlistA) {
                                self.backGroundImage.hidden = YES;
                                
                                YYNewMonth *model = [[YYNewMonth alloc]init];
                                [model setValuesForKeysWithDictionary:dict];
                                [_monthArray addObject:model];
                                
                            }
                            
                            if (self.currentPage == 1) {
                                
                                for (int i = 0; i < self.monthArray.count; i++) {
                                    YYNewMonth *model = self.monthArray[i];
                                    if (i == 0) {
                                        model.isOpen = YES;
                                        self.selectedMonth = model.Month;
                                        [self requestMonthRecordsDatatoCollectionView];
                                    }else{
                                        model.isOpen = NO;
                                    }
                                }
                                
                                
                                
                            }
                            
                        }else{
                            if (weakSelf.monthArray.count) {
                                
                                self.backGroundImage.hidden = YES;
                            }else{
                                self.backGroundImage.hidden = NO;
                                
                            }

                        }
                        
                    }else{
                        
                        if (weakSelf.monthArray.count) {
                            
                            self.backGroundImage.hidden = YES;
                        }else{
                            self.backGroundImage.hidden = NO;
                            
                        }
                        
                    }
                }
                
            }else{
                
                //                ShowAutoHideMBProgressHUD(weakSelf.view, @"请求数据失败!");
                if (weakSelf.monthArray.count) {
                    
                    self.backGroundImage.hidden = YES;
                }else{
                    self.backGroundImage.hidden = NO;
                    
                }
                
                
            }
        }
        //        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark -- 请求选中单独月份内的数据
- (void)requestMonthRecordsDatatoCollectionView{

    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"AppId":@"huiyuan",
                                 @"AppTime":[NSNumber numberWithInt:timestamp],
                                 @"Token":tokenlow,
                              //   @"CmdId":@"GetDealList",
                                 @"DealTrench":self.DealTrench,
                                 @"TransMonth":self.selectedMonth
                                 };

   // NSLog(@"参数是%@",parameter);

    FMWeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];


    [FMHTTPClient postPath:kXZUniversalTestUrl(@"GetDealDetailList") parameters:parameter completion:^(WebAPIResponse *response) {

        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];

        if (!response.responseObject) {

            ShowAutoHideMBProgressHUD(weakSelf.view, @"请求网络数据失败!");
        
        }else{

            
            if (response.code==WebAPIResponseCodeSuccess) {

                NSDictionary *monthlistB = [response.responseObject objectForKey:@"data"];
                
                if ([monthlistB isKindOfClass:[NSNull class]]) {
                
                }else{

                    YYMyBillModel *model = [YYMyBillModel mj_objectWithKeyValues:monthlistB];
                    [_recordsArray addObject:model];
                    

                    if (weakSelf.senderViewTag == 0) {
                        
                    }else{
                    
                        YYNewMonth *model = self.monthArray[weakSelf.senderViewTag];

                        /**  判断 再次请求网络后 recordsArray 是否已经存有所点月份的数据 */
                        NSString *tagRecord2 = @"标记";
                        for (int i = 0; i < weakSelf.recordsArray.count; i++){
                            
                            YYMyBillModel *recordsModel2 = self.recordsArray[i];
                            if ([recordsModel2.Month isEqualToString:model.Month]) {
                                tagRecord2 = [NSString stringWithFormat:@"%d", i];
                            }
                        }
                        
                        if ([tagRecord2 isEqualToString:@"标记"]) {
                        }else{
                            
                            YYMyBillModel *recordsModel2 = weakSelf.recordsArray[[tagRecord2 integerValue]];
                            
                            if (recordsModel2.Records.count) {
                                
                                model.isOpen = !model.isOpen;
                                [weakSelf.tableView reloadData];
                                if (model.isOpen) {
                                    
                                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:weakSelf.senderViewTag] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                                }
                            }
                            
                        }

                    }
                }
            
            }else{

                ShowAutoHideMBProgressHUD(weakSelf.view, @"请求数据失败!");
                
            }
        }
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark --  创建UITableView
- (void)setUpTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [HXColor colorWithHexString:@"#f4f5f9"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    [self.view addSubview:self.tableView];
    
    FMWeakSelf;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _currentPage = 1;

        [weakSelf requestDatatoCollectionView];
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _currentPage = _currentPage+1;
        [weakSelf requestDatatoCollectionView];
    }];

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    YYNewMonth *model = self.monthArray[section];
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [HXColor colorWithHexString:@"#f4f5f9"];
    
    /**  左部Label */
    UILabel *timeLabele = [[UILabel alloc]init];
    timeLabele.text = model.Month;
    timeLabele.font = [UIFont systemFontOfSize:16];
    timeLabele.textColor = [HXColor colorWithHexString:@"#333333"];
    [view addSubview:timeLabele];
    [timeLabele makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.mas_centerY);
        make.left.equalTo(view.mas_left).offset(10);
    }];
    
    /**  右部按钮 */
    UIButton *checkBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    if ([self.CurDate isEqualToString:model.Month]) {
        [checkBtn setTitleColor:[HXColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];

    }else{
        [checkBtn addTarget:self action:@selector(checkBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [checkBtn setTitleColor:[HXColor colorWithHexString:@"#0159d5"] forState:UIControlStateNormal];

    }
    [checkBtn setTitle:@"查看月账单" forState:UIControlStateNormal];
    checkBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    checkBtn.backgroundColor = [HXColor colorWithHexString:@"#f4f5f9"];
    checkBtn.tag = section;

    self.checkBtn = checkBtn;
    
    [view addSubview:checkBtn];
    [checkBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.right).offset(-10);
        make.centerY.equalTo(view.centerY);
    }];
    
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [HXColor colorWithHexString:@"#e5e5e5"];
    [view addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(view);
        make.height.equalTo(@1);
    }];
    
    view.tag = section;
    if (view.gestureRecognizers == nil) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewClickedAction:)];
        [view addGestureRecognizer:tap];
    }
    return view;
}

- (void) headerViewClickedAction:(UITapGestureRecognizer *)sender
{
    self.senderViewTag = sender.view.tag;
    
    if (self.monthArray.count > 0) {
        YYNewMonth *model = self.monthArray[sender.view.tag];
       
        /**  如果点击关闭展开 直接关闭 不用再走判断 */
        if (model.isOpen) {
            
            model.isOpen = !model.isOpen;
            [self.tableView reloadData];

        }else{
            
            /**  判断recordsArray 是否已经存有所点月份的数据 */
            NSString *tagRecord = @"标记";
            for (int i = 0; i < self.recordsArray.count; i++){
                
                YYMyBillModel *recordsModel = self.recordsArray[i];
                
                if ([recordsModel.Month isEqualToString:model.Month]) {
                    
                    tagRecord = [NSString stringWithFormat:@"%d", i];
                }
            }
            
            if ([tagRecord isEqualToString:@"标记"]) {
                
                self.selectedMonth = model.Month;
                [self requestMonthRecordsDatatoCollectionView];
                
                
            }else{
                
                YYMyBillModel *recordsModel = self.recordsArray[[tagRecord integerValue]];
                if (recordsModel.Records.count) {
                    
                    model.isOpen = !model.isOpen;
                    [self.tableView reloadData];
                    if (model.isOpen) {
                        
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sender.view.tag] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                        
                    }
                }
                
            }
            
        }
    }
}

- (void)checkBtnAction:(UIButton *)button{

    FMRTMonthAcountViewController *monthVC = [[FMRTMonthAcountViewController alloc]init];
    YYNewMonth *model = self.monthArray[button.tag];
  //  NSLog(@"%@", model.Month);
    monthVC.month = model.Month;
    monthVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:monthVC animated:YES];

    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.monthArray.count) {
        
        return self.monthArray.count;
    }else{
    
        return 0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.monthArray.count) {

        YYNewMonth *model = self.monthArray[section];
        if (model.isOpen) {
            if (self.recordsArray.count) {
                
                /**  判断recordsArray 是否已经存有所点月份的数据 */
                NSString *tagRecord = @"标记";
                for (int i = 0; i < self.recordsArray.count; i++){
                    
                    YYMyBillModel *recordsModel = self.recordsArray[i];
                    if ([recordsModel.Month isEqualToString:model.Month]) {
                        tagRecord = [NSString stringWithFormat:@"%d", i];
                    }
                }
                
                if ([tagRecord isEqualToString:@"标记"]) {
                    return 0;
                }else{
                
                    YYMyBillModel *recordsModel = self.recordsArray[[tagRecord integerValue]];

                    return recordsModel.Records.count;
                }

            }else{
                return 0;
            }
    
        }else{
            return 0;
        }
    }else{

        return 0;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YYNewMonth *MonthModel = self.monthArray[indexPath.section];
    YYMyBillModel *recordModel = [[YYMyBillModel alloc]init];
    for (int i = 0; i < self.recordsArray.count; i++) {
        YYMyBillModel *reModel = self.recordsArray[i];
        if ([reModel.Month isEqualToString:MonthModel.Month]) {
            recordModel = reModel;
        }
    }
    
    NSArray *records = recordModel.Records;
    
    static NSString *ID1 = @"YYMyBillCell";

    YYMyBillCell *cell = [tableView dequeueReusableCellWithIdentifier:ID1];
    if (cell == nil) {
        cell = [[YYMyBillCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID1];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.records = records[indexPath.row];
    return cell;
    
    }
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.1;
}


@end
