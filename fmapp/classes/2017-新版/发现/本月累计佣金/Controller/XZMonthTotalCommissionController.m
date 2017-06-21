//
//  XZMonthTotalCommissionController.m
//  fmapp
//
//  Created by admin on 17/2/22.
//  Copyright © 2017年 yk. All rights reserved.
//  本月累计佣金

#import "XZMonthTotalCommissionController.h"
#import "XZHadEarningWithDayCell.h"
#import "XZMonthTotalCommissionSection.h"  // 头视图
#import "XZHadEarningNoDayCell.h" // cell
#import "XZEarningGroupModel.h"  // 年月model
#import "XZEarningModel.h" // 月日model
#import "XZEarningInnerModel.h" // 日model
#import "ShareViewController.h" // web页

//#define kXZMonthTotalCommission @"https://www.rongtuojinrong.com/rongtuoxinsoc/usercenter/wodeyongjinbenyue" // 本月佣金合计

@interface XZMonthTotalCommissionController ()<UITableViewDelegate,UITableViewDataSource,XZSectionHeaderViewDelegate>
/**  */
@property (nonatomic, strong) UITableView *tableEarnings;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@property (nonatomic, strong) UIImageView *labelHeaderView;

@property (nonatomic, assign) BOOL Opended;

@end

@implementation XZMonthTotalCommissionController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [self settingNavTitle:@"本月累计佣金"];

    self.Opended = YES;
    
    //
    [self.view addSubview:self.tableEarnings];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // 请求数据
    [self getHadEearningDataFromNetWork];
}

#pragma mark ---- 请求数据
- (void)getHadEearningDataFromNetWork {
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow = [token lowercaseString];
    
    NSDictionary *parameter = @{
                                @"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                @"AppId":@"huiyuan",
                                @"AppTime":[NSNumber numberWithInt:timestamp],
                                @"Token":tokenlow
                                };

    __weak __typeof(&*self)weakSelf = self;
    // kXZUniversalTestUrl(@"MonthCommission")
    [FMHTTPClient postPath:kFMPhpUniversalBaseUrl(@"Rongtuoxinsoc/usercenter/wodeyongjinbenyueliuer") parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
//        NSLog(@"本月佣金合计 ========== %@",response.responseObject);
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSourceArray != 0) {
        XZEarningGroupModel *model = [self.dataSourceArray firstObject];
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
        XZEarningGroupModel *model = self.dataSourceArray[0];
        XZEarningInnerModel *modelInner = model.dataArr[indexPath.row];
        
        if (modelInner.daynum.length != 0) {
            static NSString *reuseID = @"hadEarningCell";
            XZHadEarningWithDayCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
            if (!cell) {
                cell = [[XZHadEarningWithDayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
            }
            modelInner.controllerName = @"本月累计佣金";
            cell.modelInner = modelInner;
            return cell;
        }
        static NSString *reuseID2 = @"hadEarningNoDayCell";
        XZHadEarningNoDayCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID2];
        if (!cell) {
            cell = [[XZHadEarningNoDayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID2];
        }
        modelInner.controllerName = @"本月累计佣金";
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
            model.isCanClick = NO;
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
        //        [self.tableEarnings reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableEarnings reloadData];
        if (model.isOpened) {
            [self.tableEarnings scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        
    }
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
            // 请求数据
            [weakSelf getHadEearningDataFromNetWork];
        }];
        
    }
    return _tableEarnings;
}


@end
