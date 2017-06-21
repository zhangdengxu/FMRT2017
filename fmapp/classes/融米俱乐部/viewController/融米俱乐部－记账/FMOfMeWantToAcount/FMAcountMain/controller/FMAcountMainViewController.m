//
//  FMAcountMainViewController.m
//  fmapp
//
//  Created by apple on 16/6/22.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMAcountMainViewController.h"
#import "FMAcountMainHeaderView.h"
#import "FMAcountMainTableViewCell.h"
#import "FMAcountWriteInViewController.h"
#import "FMAcountMainBottomView.h"
#import "FMMainSectionView.h"
#import "FMAcountMainModel.h"
#import "FMDefiniteDetailedViewController.h"
#import "FMMonthAccountViewController.h"

@interface FMAcountMainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FMAcountMainModel *model;
@property (nonatomic, strong) FMAcountMainHeaderView * headerView;

@end

@implementation FMAcountMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingNavTitle:@"记账"];
    
    [self createTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestDatatoTabelView];
}

- (void)createTableView{
    
    _tableView = ({
        UITableView *tableview= [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth , KProjectScreenHeight -64 - 60) style:(UITableViewStyleGrouped)];
        tableview.backgroundColor = KDefaultOrBackgroundColor;
        tableview.delegate=self;
        tableview.dataSource=self;
        tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        tableview;
    });
    [self.view addSubview:_tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestDatatoTabelView];
    }];
    
    __weak typeof (self) weakSelf = self;
    FMAcountMainHeaderView * headerView = [[FMAcountMainHeaderView alloc]init];
    self.headerView = headerView;
    headerView.writeBlcok = ^(){
        [weakSelf writeAcountForFM];
    };
    _tableView.tableHeaderView = headerView;
    
    FMAcountMainBottomView *bottomView = [[FMAcountMainBottomView alloc]init];
    bottomView.detailBlock = ^(){
      
        [weakSelf detailAcountForFM];
    };
    bottomView.formBlock = ^(){
        
        [weakSelf formAcountForFM];
    };
    [self.view addSubview:bottomView];
    [bottomView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@60);
    }];
}

- (void)requestDatatoTabelView {
    
    __weak __typeof(self)weakSelf = self;
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSString *urlStr = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/rongtuoxinsoc/jizhangbill/indexapp?appid=huiyuan&user_id=%@&shijian=%@&token=%@",[CurrentUserInformation sharedCurrentUserInfo].userId,[NSNumber numberWithInt:timestamp],tokenlow];
    
    [FMHTTPClient postPath:urlStr parameters:nil completion:^(WebAPIResponse *response) {
        
        if (response.responseObject == nil) {
            ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
        }
        if (response.responseObject!=nil) {
            
            NSString * status = [NSString stringWithFormat:@"%@",response.responseObject[@"status"]];
            if ([status integerValue] == 0) {
                
                if ([response.responseObject objectForKey:@"data"]) {
                    NSDictionary *dic = [response.responseObject objectForKey:@"data"];
                    FMAcountMainModel *model = [FMAcountMainModel mj_objectWithKeyValues:dic];
                    self.model = model;
                    [self.headerView sendDataWithModel:model];
                }
            }else{
                ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
            }
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView reloadData];
    }];
}

- (void)formAcountForFM{
    
//    FMAcountFormViewController *formVC = [[FMAcountFormViewController alloc]init];
//    [self.navigationController pushViewController:formVC animated:YES];
    FMMonthAccountViewController *formVC = [[FMMonthAccountViewController alloc]init];
    formVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:formVC animated:YES];
}

- (void)detailAcountForFM{
    
//    FMDetailAcountViewController *detailVC = [[FMDetailAcountViewController alloc]init];
//    [self.navigationController pushViewController:detailVC animated:YES];
    
    FMDefiniteDetailedViewController *detailVC = [[FMDefiniteDetailedViewController alloc]init];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)writeAcountForFM{
    
    FMAcountWriteInViewController *acountVC = [[FMAcountWriteInViewController alloc]init];
    acountVC.jumpType = 1;
    [self.navigationController pushViewController:acountVC animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.model.acountOfAllArr.detailListArr.count) {
        return self.model.acountOfAllArr.detailListArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"FMAcountMainTableViewCell";
    
    FMAcountMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[FMAcountMainTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    FMAcountDetailModel *model = self.model.acountOfAllArr.detailListArr[indexPath.row];
    [cell sendDataWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.model.acountOfAllArr.detailListArr.count) {
        return 25;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.model.acountOfAllArr.detailListArr.count) {
        
        FMMainSectionView *seView = [[FMMainSectionView alloc]init];
        
        FMAcountSecModel *model = self.model.acountOfAllArr;
        
        [seView sendDataWithModel:model];
        return seView;
    }
    return nil;
}


@end
