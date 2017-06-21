//
//  XZTotalReceivedCommissionController.m
//  fmapp
//
//  Created by admin on 17/2/22.
//  Copyright © 2017年 yk. All rights reserved.
//  累计已收佣金/好友贡献佣金

#import "XZTotalReceivedCommissionController.h"
#import "XZHadEarningWithDayCell.h"
#import "XZMonthTotalCommissionSection.h"  // 头视图
#import "XZHadEarningNoDayCell.h" // cell
#import "XZEarningGroupModel.h"  // 年月model
#import "XZEarningModel.h" // 月日model
#import "XZEarningInnerModel.h" // 日model
#import "ShareViewController.h" // web页
#import "XMAlertTimeView.h" // 选择日期

//// 累计已收佣金
//#define kXZMonthTotalCommission @"https://www.rongtuojinrong.com/rongtuoxinsoc/usercenter/wodeyongjinlist"

//// 累计已收佣金时间选择
//#define kXZMonthTotalCommissionTimeList @"https://www.rongtuojinrong.com/rongtuoxinsoc/usercenter/wodeyongjinshijianlist"

//// 好友贡献佣金
//#define kXZMonthTotalCommissionFriendContribution @"https://www.rongtuojinrong.com/rongtuoxinsoc/usercenter/haoyougxyongjin"

@interface XZTotalReceivedCommissionController ()<UITableViewDelegate,UITableViewDataSource,XZSectionHeaderViewDelegate,XMAlertTimeViewDelegate>
/**  */
@property (nonatomic, strong) UITableView *tableEarnings;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@property (nonatomic, strong) UIImageView *labelHeaderView;

@property (nonatomic, assign) BOOL Opended;

@property (nonatomic, strong) NSString *currentDataInterval;

// 开始时间
@property (nonatomic, strong) NSString *timeBegin;
// 结束时间
@property (nonatomic, strong) NSString *timeEnd;
@end

@implementation XZTotalReceivedCommissionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // @"累计已收佣金"
    [self settingNavTitle:self.titleStr];

    self.Opended = YES;
    
    self.timeBegin = @"";
    self.timeEnd = @"";
    
    //
    [self.view addSubview:self.tableEarnings];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // 请求数据
    [self getDataFromNetWork];
    
    //
    UIButton *btnAboutUs = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAboutUs.frame = CGRectMake(0, 0, 40, 40);
    [btnAboutUs setImage:[UIImage imageNamed:@"我的推荐_累计已收收益--黑色日历icon_1702"] forState:UIControlStateNormal];
    [btnAboutUs.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [btnAboutUs addTarget:self action:@selector(didClickUseinstructions) forControlEvents:UIControlEventTouchUpInside];
   self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithCustomView:btnAboutUs];
}

#pragma mark ----- 请求数据
- (void)getDataFromNetWork {
    // 请求数据
    if ([self.titleStr isEqualToString:@"累计已收佣金"]) {
        // kXZUniversalTestUrl(@"AccumulatedCommission")
        [self getHadEearningDataFromNetWork:kFMPhpUniversalBaseUrl(@"Rongtuoxinsoc/usercenter/wodeyongjinlistliuer") hasNoTime:YES];
    }else { // 好友贡献佣金
        // kXZUniversalTestUrl(@"FriendContributionCommission")
        [self getHadEearningDataFromNetWork:kFMPhpUniversalBaseUrl(@"Rongtuoxinsoc/usercenter/haoyougxyongjinliuer") hasNoTime:NO];
    }
}

#pragma mark ---- 筛选
- (void)didClickUseinstructions {
    XMAlertTimeView *alterView = [[XMAlertTimeView alloc]init];
    alterView.title.text = @"日期";
    alterView.delegate = self;
    if (self.currentDataInterval) {
       [alterView showAlertVeiwWithAllString:self.currentDataInterval];
    }else {
        [alterView showAlertVeiw];
    }
    
}

-(void)XMAlertTimeView:(XMAlertTimeView *)alertTimeView WithSelectTime:(NSString *)time;
{
    self.currentDataInterval = time;
//    NSLog(@"当前选择日期 ======= %@",time);
    
    NSArray *temp = [time componentsSeparatedByString:@" － "];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.timeBegin = [self timeStringToDateValue:temp[0]];
    self.timeEnd = [self timeStringToDateValue:temp[1]];
    
    if ([self.titleStr isEqualToString:@"累计已收佣金"]) {
        // 请求数据
        // kXZUniversalTestUrl(@"TimeSearchCommission")
        [self getHadEearningDataFromNetWork: kFMPhpUniversalBaseUrl(@"Rongtuoxinsoc/usercenter/wodeyongjinshijianlistliuer") hasNoTime:NO];
    }else { // 好友贡献佣金
        // kXZUniversalTestUrl(@"FriendContributionCommission")
        [self getHadEearningDataFromNetWork:kFMPhpUniversalBaseUrl(@"Rongtuoxinsoc/usercenter/haoyougxyongjinliuer") hasNoTime:NO];
    }
    
}

#pragma mark ---- 请求数据
- (void)getHadEearningDataFromNetWork:(NSString *)urlString hasNoTime:(BOOL)hasNoTime {
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    //
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSDictionary *parameter = @{
                                @"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                @"AppId":@"huiyuan",
                                @"AppTime":[NSNumber numberWithInt:timestamp],
                                @"Token":tokenlow,
                                @"kaishi":self.timeBegin,
                                @"jiezhi":self.timeEnd
                                 };
    // 判断加不加时间参数
    if (hasNoTime) {
        parameter = @{
                      //
                      @"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                      @"AppId":@"huiyuan",
                      @"AppTime":[NSNumber numberWithInt:timestamp],
                      @"Token":tokenlow
                      };
    }
    
    __weak __typeof(&*self)weakSelf = self;
    
//    NSString *url = [NSString stringWithFormat:@"%@",];
    [FMHTTPClient postPath:urlString parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
//        NSLog(@"%@ %@ ========",response.responseObject,weakSelf.titleStr);
        if (response.code == WebAPIResponseCodeSuccess) {
            
            [weakSelf.dataSourceArray removeAllObjects];
            
            if (![response.responseObject isKindOfClass:[NSNull class]]) {
                NSArray *dataArray = response.responseObject[@"data"];
                if (response.responseObject != nil) {
                    if (![dataArray isKindOfClass:[NSNull class]]) {
                        if (dataArray.count != 0) {
                            for (NSDictionary *dictionary in dataArray) {
                                XZEarningGroupModel *model = [[XZEarningGroupModel alloc] init];
                                [model setValuesForKeysWithDictionary:dictionary];
                                for (NSDictionary *dict in [dictionary objectForKey:@"Monthlist"]) {
                                    XZEarningModel *modelEarning = [[XZEarningModel alloc] init];
                                    [modelEarning setValuesForKeysWithDictionary:dict];
                                    
                                    NSArray *daylist = [dict objectForKey:@"daylist"];
                                    
                                    
                                    for (int i = 0; i < daylist.count; i++) {
                                        if ([daylist[i] isKindOfClass:[NSDictionary class]]) {
                                            NSDictionary *dic = daylist[i];
                                            if (i == 0) {
                                                
                                                XZEarningInnerModel *modelInner = [[XZEarningInnerModel alloc] init];
                                                modelInner.day = [dict objectForKey:@"day"];
                                                modelInner.daynum = [dict objectForKey:@"daynum"];
                                                modelInner.daytotal = [dict objectForKey:@"daytotal"];
                                                [modelInner setValuesForKeysWithDictionary:dic];
                                                [model.dataArr addObject:modelInner];
                                                
                                            }else{
                                                
                                                XZEarningInnerModel *modelInner = [[XZEarningInnerModel alloc] init];
                                                [modelInner setValuesForKeysWithDictionary:dic];
                                                [model.dataArr addObject:modelInner];
                                            }
                                        }
                                        
                                    }
                                }
                                [weakSelf.dataSourceArray addObject:model];
                            }
                            if (weakSelf.dataSourceArray.count > 0) {
                                // 去掉无数据提示
                                [weakSelf.labelHeaderView removeFromSuperview];
                            }
                        }
                        else {
                            ShowAutoHideMBProgressHUD(weakSelf.view,@"请重新加载");
                        }
                    }
                    else {
                        if (weakSelf.dataSourceArray.count == 0) {
                            [weakSelf.tableEarnings addSubview:weakSelf.labelHeaderView];
                        }
                    }
                }
            }else{
                if (weakSelf.dataSourceArray.count == 0) {
                    [weakSelf.tableEarnings addSubview:weakSelf.labelHeaderView];
                }
            }
        }
        else { // 加载出错
            if (weakSelf.dataSourceArray.count == 0) {
                [weakSelf.tableEarnings addSubview:weakSelf.labelHeaderView];
            }
        }
        
        [weakSelf.tableEarnings.mj_header endRefreshing];
        [weakSelf.tableEarnings.mj_footer endRefreshing];
        [weakSelf.tableEarnings reloadData];
        weakSelf.navigationController.navigationBar.hidden = NO;
    }];
    
}

#pragma mark ----- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSourceArray != 0) {
        XZEarningGroupModel *model = self.dataSourceArray[section];
        if (!model.isFirst) {
            if (section == 0 ) {
                model.isOpened = YES;
            }
        }
        NSInteger count = model.isOpened ? model.dataArr.count : 0;
        return count;
    }else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSourceArray.count != 0) {
        XZEarningGroupModel *model = self.dataSourceArray[indexPath.section];
        XZEarningInnerModel *modelInner = model.dataArr[indexPath.row];
        
        if (modelInner.daynum.length != 0) {
            static NSString *reuseID = @"hadEarningCell";
            XZHadEarningWithDayCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
            if (!cell) {
                cell = [[XZHadEarningWithDayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
            }
            if (self.titleStr) {
                modelInner.controllerName = self.titleStr;
            }
            cell.modelInner = modelInner;
            return cell;
        }
        static NSString *reuseID2 = @"hadEarningNoDayCell";
        XZHadEarningNoDayCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID2];
        if (!cell) {
            cell = [[XZHadEarningNoDayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID2];
        }
        if (self.titleStr) {
            modelInner.controllerName = self.titleStr;
        }
        cell.modelInner = modelInner;
        return cell;
    }else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSourceArray.count != 0) {
        XZEarningGroupModel *model = self.dataSourceArray[indexPath.section];
        XZEarningInnerModel *modelInner = model.dataArr[indexPath.row];
        if (modelInner.daynum.length != 0) {
            return 80;
        }
    }
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.dataSourceArray.count > 0) {
        return 60;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.dataSourceArray.count > 0) {
        XZMonthTotalCommissionSection *sectionHeader = [[XZMonthTotalCommissionSection alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 60)];
        sectionHeader.tag = section + 100;
        sectionHeader.delegate = self;
        if (self.dataSourceArray.count != 0) {
            XZEarningGroupModel *model = self.dataSourceArray[section];
            model.isCanClick = YES;
            
            sectionHeader.modelEarning = model;
        }
        return sectionHeader;
    }
    return nil;
}

- (void)touchAction:(XZMonthTotalCommissionSection *)sectionView {
    if (self.dataSourceArray.count != 0) {
        NSInteger index = sectionView.tag - 100;
        XZEarningGroupModel *model = [self.dataSourceArray objectAtIndex:index];
        model.isFirst = YES;
        model.isOpened = !model.isOpened;
        [self.tableEarnings reloadData];
        if (model.isOpened) {
            [self.tableEarnings scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }
}

#pragma mark ----- 日期转换成时间戳
- (NSString *)timeStringToDateValue:(NSString *)timeStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *dateValue = [formatter dateFromString:timeStr];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)       [dateValue timeIntervalSince1970]];
    return timeSp;
}

#pragma mark ----- 懒加载
- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}

- (UIImageView *)labelHeaderView {
    if (!_labelHeaderView) {
        _labelHeaderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth,KProjectScreenWidth * 822 / 486.0)];
        _labelHeaderView.image = [UIImage imageNamed:@"暂无数据"];
    }
    return _labelHeaderView;
}

- (UITableView *)tableEarnings {
    if (!_tableEarnings) {
        _tableEarnings = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 64) style:UITableViewStylePlain];
        _tableEarnings.delegate = self;
        _tableEarnings.dataSource  = self;
        _tableEarnings.separatorStyle = UITableViewCellSeparatorStyleNone;
        __weak __typeof(&*self)weakSelf = self;
        // 刷新
        _tableEarnings.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            weakSelf.currentPage = 1;
            if ([weakSelf.titleStr isEqualToString:@"累计已收佣金"]) {
                if (weakSelf.timeBegin.length != 0) { // 选时间段
                    // 请求数据 kXZUniversalTestUrl(@"TimeSearchCommission")
                    [weakSelf getHadEearningDataFromNetWork: kFMPhpUniversalBaseUrl(@"Rongtuoxinsoc/usercenter/wodeyongjinshijianlistliuer") hasNoTime:NO];
                }else {
                    // kXZUniversalTestUrl(@"AccumulatedCommission")
                    [weakSelf getHadEearningDataFromNetWork:kFMPhpUniversalBaseUrl(@"Rongtuoxinsoc/usercenter/wodeyongjinlistliuer") hasNoTime:YES];
                }
            }else { // 好友贡献佣金
                // kXZUniversalTestUrl(@"FriendContributionCommission")
                [weakSelf getHadEearningDataFromNetWork:kFMPhpUniversalBaseUrl(@"Rongtuoxinsoc/usercenter/haoyougxyongjinliuer") hasNoTime:NO];
            }
        }];
    }
    return _tableEarnings;
}


@end
