//
//  YYAnnounceResultsNewViewController.m
//  fmapp
//
//  Created by yushibo on 2016/10/17.
//  Copyright © 2016年 yk. All rights reserved.
//  消息栏  ---  即将揭晓,已经揭晓

#import "YYAnnounceResultsNewViewController.h"

#import "YYAnnounceResultsCell.h"
#import "YYAlreadyAnnounceResultsCell.h"
#import "YYAnnounceResultsNewModel.h"
#import "XZMySnatchController.h"  //我的夺宝界面
#import "XZCommonProblemsController.h"  // 常见问题界面
#import "FMShopDetailDuobaoViewController.h"//商品详情
@interface YYAnnounceResultsNewViewController () <UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
/** 即将揭晓  */
@property (nonatomic, strong)UIButton *announceBtn;
/** 已经揭晓  */
@property (nonatomic, strong)UIButton *alreadyAnnounceBtn;
/** 即将揭晓数据组  */
@property (nonatomic, strong)NSMutableArray *announceDataSource;
/** 已经揭晓数据组  */
@property (nonatomic, strong)NSMutableArray *alreadyAnnouncetDataSource;
@property (nonatomic, assign)int currentPage;
/** 暂无数据 */
@property (nonatomic, strong) UILabel *alertLabel;
@end

@implementation YYAnnounceResultsNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setRightNavItemButton];
    self.currentPage = 1;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#E5E9F2"];
    [self setTopSelectTitleView];
    [self setUpTableView];
    [self creatBackTopView];
    [self getAnnounceDataSourceFromNetWork];
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

#pragma mark --- 即将揭晓 -- 网络请求

- (void)getAnnounceDataSourceFromNetWork{
    int timestamp = [[NSDate date]timeIntervalSince1970];
        NSString *urlStr =[NSString stringWithFormat:@"%@/public/newon/show/getVeiledWonList",kXZTestEnvironment];
    NSDictionary * parameter;
    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
        NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
        NSString *tokenlow=[token lowercaseString];

        parameter = @{@"appid":@"huiyuan",
                      @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                      @"shijian":[NSNumber numberWithInt:timestamp],
                      @"token":tokenlow,
                      @"page":[NSString stringWithFormat:@"%d", self.currentPage],
                      };

    }else{
        NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",@"0",timestamp]);
        NSString *tokenlow=[token lowercaseString];
        parameter = @{@"appid":@"huiyuan",
                      @"user_id":@"0",
                      @"shijian":[NSNumber numberWithInt:timestamp],
                      @"token":tokenlow,
                      @"page":[NSString stringWithFormat:@"%d", self.currentPage],
                      };

    }
    
    __weak __typeof(self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:urlStr parameters:parameter completion:^(WebAPIResponse *response) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if (response.responseObject == nil) {
            ShowAutoHideMBProgressHUD(weakSelf.view, NETERROR_LOADERR_TIP);
            if (weakSelf.announceDataSource.count == 0) {
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
//                        NSMutableDictionary *infoDict = [[NSMutableDictionary alloc]initWithDictionary:dict];

                        YYAnnounceResultsNewModel *announceModel = [[YYAnnounceResultsNewModel alloc]init];
                        [announceModel setValuesForKeysWithDictionary:dict];
                        [weakSelf.announceDataSource addObject:announceModel];
                    }
                }

                if (weakSelf.announceDataSource.count == 0) {
                    weakSelf.alertLabel.hidden = NO;
                }else{
                    weakSelf.alertLabel.hidden = YES;
                }
            }
        }else{
            ShowAutoHideMBProgressHUD(self.view, response.responseObject[@"msg"]);
                if (weakSelf.announceDataSource.count == 0) {
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
    NSString *urlStr =[NSString stringWithFormat:@"%@/public/newon/show/getUnveiledWonList",kXZTestEnvironment];
    NSDictionary * parameter;
    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
        NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
        parameter = @{@"appid":@"huiyuan",
                     @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                     @"shijian":[NSNumber numberWithInt:timestamp],
                     @"token":[token lowercaseString],
                     @"page":[NSString stringWithFormat:@"%d", self.currentPage],
                     };

    }else{
        NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",@"0",timestamp]);
        parameter = @{@"appid":@"huiyuan",
                      @"user_id":@"0",
                      @"shijian":[NSNumber numberWithInt:timestamp],
                      @"token":[token lowercaseString],
                      @"page":[NSString stringWithFormat:@"%d", self.currentPage],
                      };
    }
    
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
                        
                        YYAnnounceResultsNewModel *alreadyModel = [[YYAnnounceResultsNewModel alloc]init];
                        [alreadyModel setValuesForKeysWithDictionary:dict];
                        [weakSelf.alreadyAnnouncetDataSource addObject:alreadyModel];
                        
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
- (NSMutableArray *)announceDataSource {
    if (!_announceDataSource) {
        _announceDataSource = [NSMutableArray array];
    }
    return _announceDataSource;
}

- (NSMutableArray *)alreadyAnnouncetDataSource {
    if (!_alreadyAnnouncetDataSource) {
        _alreadyAnnouncetDataSource = [NSMutableArray array];
    }
    return _alreadyAnnouncetDataSource;
}

#pragma mark ---即将揭晓 + 已经揭晓
- (UIButton *)announceBtn {
    
    if (!_announceBtn) {
        _announceBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_announceBtn setTitle:@"即将揭晓" forState:(UIControlStateNormal)];
        [_announceBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateNormal)];
        [_announceBtn setTitleColor:[HXColor colorWithHexString:@"#FF6633"] forState:(UIControlStateSelected)];
        _announceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_announceBtn addTarget:self action:@selector(announceAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _announceBtn;
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
    self.announceBtn.selected = YES;
    self.alreadyAnnounceBtn.selected = NO;
    [topView addSubview:self.announceBtn];
    [topView addSubview:self.alreadyAnnounceBtn];
    [self.announceBtn makeConstraints:^(MASConstraintMaker *make) {
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

/**  导航条右键  */
- (void)setRightNavItemButton{
    
    UIButton *rightBtn = [[UIButton alloc]init];
    [rightBtn setImage:[UIImage imageNamed:@"新版-我的夺宝"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(jumpMyDuoBaoView) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn sizeToFit];
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
}
- (void)jumpMyDuoBaoView{

    if (![CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
        LoginController *registerController = [[LoginController alloc] init];
        FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
        [self presentViewController:navController animated:YES completion:nil];
    }else{
        XZMySnatchController *vc = [[XZMySnatchController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }

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
        if (weakSelf.announceBtn.selected) {
            
            [weakSelf.announceDataSource removeAllObjects];
            [weakSelf getAnnounceDataSourceFromNetWork];
        }else{
            
            [weakSelf.alreadyAnnouncetDataSource removeAllObjects];
            [weakSelf getAlreadyAnnouncetDataSourceFromNetWork];
        }
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
       
        _currentPage = _currentPage+1;
        if (weakSelf.announceBtn.selected) {
            
            [weakSelf getAnnounceDataSourceFromNetWork];
        }else{
            
            [weakSelf getAlreadyAnnouncetDataSourceFromNetWork];
        }
    }];

    [self.view addSubview:self.tableView];
    
}
#pragma mark ---   UITableView代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.announceBtn.selected == YES) {
        return self.announceDataSource.count;
    }else{
    
        return self.alreadyAnnouncetDataSource.count;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID1 = @"YYAnnounceResultsCell.h";
    static NSString *ID2 = @"YYAlreadyAnnounceResultsCell.h";
    
    if (self.announceBtn.selected == YES) {
        
        YYAnnounceResultsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID1];
        if (cell == nil) {
            
            cell = [[YYAnnounceResultsCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID1];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.announceDataSource.count) {
        
            cell.status = self.announceDataSource[indexPath.row];
                }
        return cell;
    }else{
        
        YYAlreadyAnnounceResultsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID2];
        
        if (cell == nil) {
            
            cell = [[YYAlreadyAnnounceResultsCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID2];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.alreadyAnnouncetDataSource.count) {
            
            cell.status = self.alreadyAnnouncetDataSource[indexPath.row];
        }
        return cell;
    }
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.announceBtn.selected == YES) {
        return 130;
    }else{
        return 140;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.announceBtn.selected == YES) {
        
        FMShopDetailDuobaoViewController *shopD = [[FMShopDetailDuobaoViewController alloc]init];
        YYAnnounceResultsNewModel *announceModel = self.announceDataSource[indexPath.row];
        shopD.product_id =announceModel.product_id;
        shopD.won_id = announceModel.won_id;
        [self.navigationController pushViewController:shopD animated:YES];

    }else{
        FMShopDetailDuobaoViewController *shopD = [[FMShopDetailDuobaoViewController alloc]init];
        YYAnnounceResultsNewModel *alreadyModel = self.alreadyAnnouncetDataSource[indexPath.row];
        shopD.product_id =alreadyModel.product_id;
        shopD.won_id = alreadyModel.won_id;
        [self.navigationController pushViewController:shopD animated:YES];
    }
}

- (void)announceAction:(UIButton *)sender{
    
    self.announceBtn.selected = YES;
    self.alreadyAnnounceBtn.selected = NO;
    self.currentPage = 1;
    [self.announceDataSource removeAllObjects];
    [self.alreadyAnnouncetDataSource removeAllObjects];
    [self getAnnounceDataSourceFromNetWork];
    [self.tableView reloadData];
    
}
- (void)alreadyAnnounceAction:(UIButton *)sender{
    
    self.announceBtn.selected = NO;
    self.alreadyAnnounceBtn.selected = YES;
    self.currentPage = 1;
    [self.announceDataSource removeAllObjects];
    [self.alreadyAnnouncetDataSource removeAllObjects];
    [self getAlreadyAnnouncetDataSourceFromNetWork];
    [self.tableView reloadData];
}

#pragma mark ---回到顶部
- (void)creatBackTopView{
    
    //常见问题
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
