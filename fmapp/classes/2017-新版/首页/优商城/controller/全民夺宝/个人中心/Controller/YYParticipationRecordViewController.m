//
//  YYParticipationRecordViewController.m
//  fmapp
//
//  Created by yushibo on 2016/10/29.
//  Copyright © 2016年 yk. All rights reserved.
//  参与记录  ---  正在进行,已经揭晓

#import "YYParticipationRecordViewController.h"
#import "YYDoingParticipationRecordViewCell.h"
#import "YYAlreadyParticipationRecordViewCell.h"

#import "YYParticipationRecordModel.h"
#import "XZCommonProblemsController.h"
#import "FMShopDetailDuobaoViewController.h"
@interface YYParticipationRecordViewController () <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
/** 正在进行    */
@property (nonatomic, strong)UIButton *doingBtn;
/** 已经揭晓  */
@property (nonatomic, strong)UIButton *alreadyAnnounceBtn;
/** 正在进行数据组  */
@property (nonatomic, strong)NSMutableArray *doingDataSource;
/** 已经揭晓数据组  */
@property (nonatomic, strong)NSMutableArray *alreadyAnnouncetDataSource;
@property (nonatomic, assign)int currentPage;
/** 暂无数据 */
@property (nonatomic, strong) UILabel *alertLabel;

@end

@implementation YYParticipationRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingNavTitle:@"参与记录"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#E5E9F2"];
    self.currentPage = 1;
    [self setTopSelectTitleView];
    [self setUpTableView];
    [self creatBackTopView];
    [self getDoingDataSourceFromNetWork];
}

- (UILabel *)alertLabel{
    
    if (!_alertLabel) {
        
        _alertLabel = [[UILabel alloc]initWithFrame:CGRectMake((KProjectScreenWidth/2 - 50), (KProjectScreenHeight/3), 100, 30)];
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        _alertLabel.text = @"暂无数据";
        _alertLabel.textColor = [UIColor darkGrayColor];
        _alertLabel.font = [UIFont boldSystemFontOfSize:16];
        [self.view addSubview:_alertLabel];
        
    }
    return _alertLabel;
}

#pragma mark --- 正在进行 -- 网络请求

- (void)getDoingDataSourceFromNetWork{
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString *urlStr =[NSString stringWithFormat:@"%@/public/newon/show/getUserVeiledWonList",kXZTestEnvironment];

    NSDictionary * parameter = @{@"appid":@"huiyuan",
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"page":[NSString stringWithFormat:@"%d", self.currentPage],
                                 };
    
    __weak __typeof(self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:urlStr parameters:parameter completion:^(WebAPIResponse *response) {
        
    
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if (response.responseObject == nil) {
            ShowAutoHideMBProgressHUD(weakSelf.view, NETERROR_LOADERR_TIP);
            
            if (weakSelf.doingDataSource.count == 0) {
                weakSelf.alertLabel.hidden = NO;
            }else{
                weakSelf.alertLabel.hidden = YES;
            }
            
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            return;
        }
        
        if(response.code == WebAPIResponseCodeSuccess){
            
            NSArray *newArray = [NSArray arrayWithArray:response.responseObject[@"data"]];
            
            if (![newArray isMemberOfClass:[NSNull class]]) {
                if (newArray.count) {
                    for(NSDictionary *dict in newArray){
                        NSMutableDictionary *infoDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
                        YYParticipationRecordModel *particiModel = [[YYParticipationRecordModel alloc]init];
                        [particiModel setValuesForKeysWithDictionary:infoDict];
                        [weakSelf.doingDataSource addObject:particiModel];
                    }
                }
                if (weakSelf.doingDataSource.count == 0) {
                    weakSelf.alertLabel.hidden = NO;
                }else{
                    weakSelf.alertLabel.hidden = YES;
                }
            }
        }else{
            ShowAutoHideMBProgressHUD(weakSelf.view, response.responseObject[@"msg"]);
            if (weakSelf.doingDataSource.count == 0) {
                weakSelf.alertLabel.hidden = NO;
            }else{
                weakSelf.alertLabel.hidden = YES;
            }
        }
        
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark --- 已经揭晓 -- 网络请求

- (void)getAlreadyAnnouncetDataSourceFromNetWork{
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString *urlStr =[NSString stringWithFormat:@"%@/public/newon/show/getUserUnveiledWonList",kXZTestEnvironment];

    NSDictionary * parameter = @{@"appid":@"huiyuan",
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"page":[NSString stringWithFormat:@"%d", self.currentPage],
                                 };
    
    __weak __typeof(self)weakSelf = self;

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:urlStr parameters:parameter completion:^(WebAPIResponse *response) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if (response.responseObject == nil) {
            ShowAutoHideMBProgressHUD(weakSelf.view, NETERROR_LOADERR_TIP);
            if (weakSelf.alreadyAnnouncetDataSource.count == 0) {
                weakSelf.alertLabel.hidden = NO;
            }else{
                weakSelf.alertLabel.hidden = YES;
            }
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            return;
        }
        
        if(response.code == WebAPIResponseCodeSuccess){
            
            NSArray *newArray = [NSArray arrayWithArray:response.responseObject[@"data"]];
            
            if (![newArray isMemberOfClass:[NSNull class]]) {
                
                if (newArray.count) {

                    for(NSDictionary *dict in newArray){
                        NSMutableDictionary *infoDict = [[NSMutableDictionary alloc]initWithDictionary:dict];

                        YYParticipationRecordModel *alreadModel = [[YYParticipationRecordModel alloc]init];
                        [alreadModel setValuesForKeysWithDictionary:infoDict];
                        [weakSelf.alreadyAnnouncetDataSource addObject:alreadModel];

                    }
                }
                if (weakSelf.alreadyAnnouncetDataSource.count == 0) {
                    weakSelf.alertLabel.hidden = NO;
                }else{
                    weakSelf.alertLabel.hidden = YES;
                }
            }
        }else{
            ShowAutoHideMBProgressHUD(weakSelf.view, response.responseObject[@"msg"]);
            if (weakSelf.alreadyAnnouncetDataSource.count == 0) {
                weakSelf.alertLabel.hidden = NO;
            }else{
                weakSelf.alertLabel.hidden = YES;
            }
        }
        
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark ---懒加载
- (NSMutableArray *)doingDataSource {
    if (!_doingDataSource) {
        _doingDataSource = [NSMutableArray array];
    }
    return _doingDataSource;
}

- (NSMutableArray *)alreadyAnnouncetDataSource {
    if (!_alreadyAnnouncetDataSource) {
        _alreadyAnnouncetDataSource = [NSMutableArray array];
    }
    return _alreadyAnnouncetDataSource;
}

#pragma mark ---正在进行 + 已经揭晓
- (UIButton *)doingBtn {
    
    if (!_doingBtn) {
        _doingBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_doingBtn setTitle:@"正在进行" forState:(UIControlStateNormal)];
        [_doingBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateNormal)];
        [_doingBtn setTitleColor:[HXColor colorWithHexString:@"#FF6633"] forState:(UIControlStateSelected)];
        _doingBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_doingBtn addTarget:self action:@selector(_doingBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _doingBtn;
}

- (UIButton *)alreadyAnnounceBtn {
    
    if (!_alreadyAnnounceBtn) {
        _alreadyAnnounceBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_alreadyAnnounceBtn setTitle:@"已经揭晓" forState:(UIControlStateNormal)];
        [_alreadyAnnounceBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateNormal)];
        [_alreadyAnnounceBtn setTitleColor:[HXColor colorWithHexString:@"#FF6633"] forState:(UIControlStateSelected)];
        _alreadyAnnounceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_alreadyAnnounceBtn addTarget:self action:@selector(alreadyAnnounceAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _alreadyAnnounceBtn;
}

#pragma mark ----头部选择器
- (void)setTopSelectTitleView{
    
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    [topView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(@45);
    }];
    self.doingBtn.selected = YES;
    self.alreadyAnnounceBtn.selected = NO;
    [topView addSubview:self.doingBtn];
    [topView addSubview:self.alreadyAnnounceBtn];
    [self.doingBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(topView);
        make.right.equalTo(topView.mas_centerX);
    }];
    
    [self.alreadyAnnounceBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(topView);
        make.left.equalTo(topView.mas_centerX);
    }];
    
    UIView *midLine = [[UIView alloc]init];
    midLine.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [self.view addSubview:midLine];
    [midLine makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView.mas_centerX);
        make.width.equalTo(1);
        make.top.equalTo(topView.mas_top).offset(12);
        make.bottom.equalTo(topView.mas_bottom).offset(-12);
    }];
    
}

#pragma mark ---   创建UITableView

- (void)setUpTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 45, KProjectScreenWidth, KProjectScreenHeight -109) style:(UITableViewStylePlain)];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    __weak typeof (self)weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _currentPage = 1;
        if (weakSelf.doingBtn.selected) {
    
            [weakSelf.doingDataSource removeAllObjects];
            [weakSelf getDoingDataSourceFromNetWork];
        }else{
        
            [weakSelf.alreadyAnnouncetDataSource removeAllObjects];
            [weakSelf getAlreadyAnnouncetDataSourceFromNetWork];
        }
        
    }];
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _currentPage = _currentPage+1;
        if (weakSelf.doingBtn.selected) {
        
            [weakSelf getDoingDataSourceFromNetWork];
        }else{
            
            [weakSelf getAlreadyAnnouncetDataSourceFromNetWork];
        }
        
    }];
    [self.view addSubview:self.tableView];
    
}
#pragma mark ---   UITableView代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.doingBtn.selected == YES) {
        return self.doingDataSource.count;
    }else{
        return self.alreadyAnnouncetDataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID1 = @"YYDoingParticipationRecordViewCell";
    static NSString *ID2 = @"YYAlreadyParticipationRecordViewCell";
    
    if (self.doingBtn.selected == YES) {
        
        YYDoingParticipationRecordViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID1];
        if (cell == nil) {
            
            cell = [[YYDoingParticipationRecordViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID1];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.doingDataSource.count) {
            cell.status = self.doingDataSource[indexPath.row];
        }
        
        return cell;
    
    }else{
        
        YYAlreadyParticipationRecordViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID2];
        
        if (cell == nil) {
            
            cell = [[YYAlreadyParticipationRecordViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID2];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.alreadyAnnouncetDataSource.count) {
            
            cell.status = self.alreadyAnnouncetDataSource[indexPath.row];
        }
        return cell;
    }
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.doingBtn.selected == YES) {
        return 130;
    }else{
        return 140;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.doingBtn.selected == YES) {
        
        FMShopDetailDuobaoViewController *shopD = [[FMShopDetailDuobaoViewController alloc]init];
        YYParticipationRecordModel *doinModel = self.doingDataSource[indexPath.row];
        shopD.product_id =doinModel.product_id;
        shopD.won_id = doinModel.won_id;
        [self.navigationController pushViewController:shopD animated:YES];
        
    }else{
        FMShopDetailDuobaoViewController *shopD = [[FMShopDetailDuobaoViewController alloc]init];
        YYParticipationRecordModel *alreadyModel = self.alreadyAnnouncetDataSource[indexPath.row];
        shopD.product_id =alreadyModel.product_id;
        shopD.won_id = alreadyModel.won_id;
        [self.navigationController pushViewController:shopD animated:YES];

    }
}

- (void)_doingBtnAction:(UIButton *)sender{
    
    self.doingBtn.selected = YES;
    self.alreadyAnnounceBtn.selected = NO;
    self.currentPage = 1;
    [self.doingDataSource removeAllObjects];
    [self.alreadyAnnouncetDataSource removeAllObjects];
    [self getDoingDataSourceFromNetWork];
    [self.tableView reloadData];
    
}
- (void)alreadyAnnounceAction:(UIButton *)sender{
    
    self.doingBtn.selected = NO;
    self.alreadyAnnounceBtn.selected = YES;
    self.currentPage = 1;
    [self.doingDataSource removeAllObjects];
    [self.alreadyAnnouncetDataSource removeAllObjects];
    [self getAlreadyAnnouncetDataSourceFromNetWork];
    [self.tableView reloadData];
}

#pragma mark ---回到顶部
- (void)creatBackTopView{
    
    //联系客服-改版
    UIButton *questionBtn = [[UIButton alloc]init];
    [questionBtn setImage:[UIImage imageNamed:@"联系客服-改版"] forState:UIControlStateNormal];
    [questionBtn sizeToFit];
    [questionBtn addTarget:self action:@selector(questionToPerson:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:questionBtn];
    [questionBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.top.equalTo(self.view.mas_top).offset(KProjectScreenHeight/5*3);
        make.height.equalTo(35);
        make.width.equalTo(35);
    }];
    
    
    UIButton *backbtn = [[UIButton alloc]init];
    [backbtn setImage:[UIImage imageNamed:@"返回顶部"] forState:UIControlStateNormal];
    [backbtn sizeToFit];
    [backbtn addTarget:self action:@selector(controlLocationButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbtn];
    [backbtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.top.equalTo(questionBtn.mas_bottom).offset(15);
        make.height.equalTo(35);
        make.width.equalTo(35);
    }];
    
    
}
//回到顶部
-(void)controlLocationButtonOnClick:(UIButton *)button
{
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}
- (void)questionToPerson:(UIButton *)button{
    
    XZCommonProblemsController *vc = [[XZCommonProblemsController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
