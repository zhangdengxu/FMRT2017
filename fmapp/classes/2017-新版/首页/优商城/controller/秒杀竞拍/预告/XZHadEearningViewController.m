//
//  XZHadEearningViewController.m
//  XZProject
//
//  Created by admin on 16/8/9.
//  Copyright © 2016年 admin. All rights reserved.
//  已赚收益页面

#import "XZHadEearningViewController.h"
#import "XZHadEarningWithDayCell.h"
#import "XZSectionHeaderView.h"  // 头视图
#import "XZHadEarningNoDayCell.h" // cell
#import "XZEarningGroupModel.h"  // 年月model
#import "XZEarningModel.h" // 月日model
#import "XZEarningInnerModel.h" // 日model
#import "ShareViewController.h" // web页

#define kXZHadEearning @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/yizhuanlistlinshi" // 已赚收益
// https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/yizhuanlist
#define kXZHadEearningWebUrl @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/zhaiquanxq?"

@interface XZHadEearningViewController ()<UITableViewDelegate,UITableViewDataSource,XZSectionHeaderViewDelegate>
/**  */
@property (nonatomic, strong) UITableView *tableEarnings;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

// 当前页面
@property (nonatomic, assign) int currentPage;
// 当前页面
@property (nonatomic, assign) int pageSize;

@property (nonatomic, strong) UIImageView *labelHeaderView;

@property (nonatomic, assign) BOOL Opended;
@end


@implementation XZHadEearningViewController
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
//            [weakSelf.tableEarnings reloadData];
            weakSelf.currentPage = 1;
            // 请求数据
            [weakSelf getHadEearningDataFromNetWork];
        }];
//        // 加载
//        _tableEarnings.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
//            weakSelf.currentPage = weakSelf.currentPage + 1;
//            // 请求数据
//            [weakSelf getHadEearningDataFromNetWork];
//        }];
    }
    return _tableEarnings;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"已赚收益"];
    self.currentPage = 1;
    self.pageSize = 10;
    self.Opended = YES;
    //
    [self.view addSubview:self.tableEarnings];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // 请求数据
    [self getHadEearningDataFromNetWork];

}

// 请求数据
- (void)getHadEearningDataFromNetWork {
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"page":[NSString stringWithFormat:@"%d",self.currentPage],
                                 @"page_size":[NSString stringWithFormat:@"%d",self.pageSize]};
    
    __weak __typeof(&*self)weakSelf = self;
    
    [FMHTTPClient postPath:kXZHadEearning parameters:parameter completion:^(WebAPIResponse *response) {
        if (self.currentPage == 1) {
            [weakSelf.dataSourceArray removeAllObjects];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        NSLog(@"%@",response.responseObject);
        if (response.code == WebAPIResponseCodeSuccess) {
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
                         [self.dataSourceArray addObject:model];
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
                  if (self.dataSourceArray.count == 0) {
                      [self.tableEarnings addSubview:self.labelHeaderView];
//                      self.tableEarnings.scrollEnabled = NO;
                  }
              }
             }
            }else{
//                ShowAutoHideMBProgressHUD(weakSelf.view,@"加载");
                if (self.dataSourceArray.count == 0) {
                    [self.tableEarnings addSubview:self.labelHeaderView];
                }
            }
        }
        else { // 加载出错
//            ShowAutoHideMBProgressHUD(weakSelf.view,@"");
            if (self.dataSourceArray.count == 0) {
            [self.tableEarnings addSubview:self.labelHeaderView];
            }
        }
        
        [weakSelf.tableEarnings.mj_header endRefreshing];
        [weakSelf.tableEarnings.mj_footer endRefreshing];
        [weakSelf.tableEarnings reloadData];
        self.navigationController.navigationBar.hidden = NO;
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
            cell.modelInner = modelInner;
            
            return cell;
        }
        static NSString *reuseID2 = @"hadEarningNoDayCell";
        XZHadEarningNoDayCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID2];
        if (!cell) {
            cell = [[XZHadEarningNoDayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID2];
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
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    XZSectionHeaderView *sectionHeader = [[XZSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 60)];
    sectionHeader.tag = section + 100;
    sectionHeader.delegate = self;
    if (self.dataSourceArray.count != 0) {
        XZEarningGroupModel *model = self.dataSourceArray[section];
        sectionHeader.modelEarning = model;
    }
    return sectionHeader;
}

- (void)touchAction:(XZSectionHeaderView *)sectionView {
    if (self.dataSourceArray.count > 0) {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    if (self.dataSourceArray.count != 0) {
        XZEarningGroupModel *model = self.dataSourceArray[indexPath.section];
        XZEarningInnerModel *modelInner = model.dataArr[indexPath.row];
        NSString *leixing = [NSString stringWithFormat:@"%@",modelInner.leixing];
        if ([leixing isEqualToString:@"1"]) { // 1为标的回款 可以 点击 2为零钱贯 不需要点击查看
            //
            int timestamp = [[NSDate date] timeIntervalSince1970];
            NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
            NSString *tokenlow=[token lowercaseString];
            NSString *urlString = [NSString stringWithFormat:@"%@user_id=%@&appid=%@&shijian=%@&token=%@&jilu_id=%@",kXZHadEearningWebUrl,[CurrentUserInformation sharedCurrentUserInfo].userId,@"huiyuan",[NSNumber numberWithInt:timestamp],tokenlow,modelInner.jilu_id]; // ,modelInner.jie_id
            ShareViewController *viewController = [[ShareViewController alloc] initWithTitle:@"债权详情" AndWithShareUrl:urlString];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

@end
