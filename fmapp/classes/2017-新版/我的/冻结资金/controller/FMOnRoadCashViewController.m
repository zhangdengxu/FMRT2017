//
//  FMOnRoadCashViewController.m
//  fmapp
//
//  Created by apple on 16/6/13.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMOnRoadCashViewController.h"
#import "FMonRoadCashTableViewCell.h"
#import "FMOnRoadModel.h"

@interface FMOnRoadCashViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UILabel *alertLabel;

@end

@implementation FMOnRoadCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingNavTitle:@"冻结资金"];
    [self setUpTableView];
    [self requestDatatoTabelView];
    
    [self.view addSubview:self.alertLabel];
    [self.alertLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
    
}

- (UILabel *)alertLabel{
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc]init];
        _alertLabel.font = [UIFont boldSystemFontOfSize:16];
        _alertLabel.textColor = [UIColor darkGrayColor];
        _alertLabel.text = @"暂无数据";
    }
    return _alertLabel;
}


- (void)requestDatatoTabelView {
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"page":@"1",
                                 @"page_size":@"10"};
    __weak __typeof(self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [FMHTTPClient postPath:@"https://www.rongtuojinrong.com/rongtuoxinsoc/usercenter/dongjielist" parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if (response.code==WebAPIResponseCodeSuccess) {
            
            [weakSelf.dataSource removeAllObjects];
            NSArray *data = [response.responseObject objectForKey:@"data"];
            
            if ([data isKindOfClass:[NSNull class]] || data.count == 0) {
                weakSelf.alertLabel.hidden = NO;
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf.tableView.mj_footer endRefreshing];
                return ;
            }
            
            for (NSDictionary *dic in data) {
                
                FMOnRoadModel *model = [[FMOnRoadModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [weakSelf.dataSource addObject:model];
            }
            [weakSelf.tableView reloadData];
            
            if (weakSelf.dataSource.count) {
                weakSelf.alertLabel.hidden = YES;
            }else{
                weakSelf.alertLabel.hidden = NO;
            }
            
        }else{
            if (weakSelf.dataSource.count == 0) {
                weakSelf.alertLabel.hidden = NO;
            }else{
                weakSelf.alertLabel.hidden = YES;
            }
            ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView reloadData];
    }];
}

- (void)setUpTableView {
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 64) style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = KDefaultOrBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self requestDatatoTabelView];
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FMonRoadCashTableViewCell *cell = [[FMonRoadCashTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"FMonRoadCashTableViewCell"];
    
    FMOnRoadModel *model = self.dataSource[indexPath.section];
    
    [cell sendDataWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

@end
