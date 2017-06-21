//
//  YSMyParticipationViewController.m
//  fmapp
//
//  Created by yushibo on 16/6/30.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "YSMyParticipationViewController.h"
#import "YSFootPrintModel.h"
#import "YSFootPrintViewCell.h"
#import "YSSignModel.h"
#import "YSSignViewCell.h"
#import "XZRegistrationCertificateViewController.h"
@interface YSMyParticipationViewController () <UITableViewDataSource, UITableViewDelegate>
/** 报名凭证  */
@property (nonatomic, strong)UIButton *signBtn;
/** 我的足迹  */
@property (nonatomic, strong)UIButton *footprintBtn;
/** 报名凭证底下横线  */
@property (nonatomic, strong)UIView *signLineV;
/** 我的足迹底部横线  */
@property (nonatomic, strong)UIView *footprintLineV;
/**   */
@property(nonatomic, strong)NSMutableArray *dataSource;
/** 报名凭证数据组  */
@property (nonatomic, strong)NSMutableArray *signDataSource;
/** 我的足迹数据组  */
@property (nonatomic, strong)NSMutableArray *footprintDataSource;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)int currentPage;
@end

@implementation YSMyParticipationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self settingNavTitle:@"我的参与"];
    [self setTopSelectTitleView];
    self.currentPage = 1;
    [self setUpTableView];
    [self getSignDataSourceFromNetWork];
}

- (NSMutableArray *)footprintDataSource {
    if (!_footprintDataSource) {
        _footprintDataSource = [NSMutableArray array];
    }
    return _footprintDataSource;
}

- (NSMutableArray *)signDataSource {
    if (!_signDataSource) {
        _signDataSource = [NSMutableArray array];
    }
    return _signDataSource;
}

/**
 *  报名凭证网络请求
 */
- (void)getSignDataSourceFromNetWork{
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString *urlStr = @"https://www.rongtuojinrong.com/rongtuoxinsoc/Juyijuparty/joinvoucherlist";
    NSDictionary * parameter = @{@"appid":@"huiyuan",
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"page":[NSString stringWithFormat:@"%d",self.currentPage],
                                 @"page_size":@"5"
                                 };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak __typeof(self)weakSelf = self;

    [FMHTTPClient postPath:urlStr parameters:parameter completion:^(WebAPIResponse *response) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if (response.responseObject == nil) {
//            ShowAutoHideMBProgressHUD(self.view, NETERROR_LOADERR_TIP);
        }
        
        if(response.code == WebAPIResponseCodeSuccess){
            
            if (response.responseObject) {
                NSArray *newArray = [NSArray arrayWithArray:response.responseObject[@"data"]];
                
                if (![newArray isMemberOfClass:[NSNull class]]) {
                    
                    if (newArray.count) {
                        if (![newArray isKindOfClass:[NSNull class]]) {
 
                            for(NSDictionary *dict in newArray){
                                NSMutableDictionary *infoDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
                                YSSignModel *model = [[YSSignModel alloc]initWithDict:infoDict];
                                [self.signDataSource addObject:model];
                            }
                            
//                            [self.tableView reloadData];
                        }
                        
                    }
               }
            }
        }else{
            
            if (self.signDataSource.count) {
                ShowAutoHideMBProgressHUD(self.view, @"没有更多数据!");

            }else{
//                ShowAutoHideMBProgressHUD(self.view, NETERROR_LOADERR_TIP);
            }
        }
        [self.tableView reloadData];

        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];

    }];
    
}
/**
 *  我的足迹网络请求
 */
- (void)getFootprintDataSourceFromNetWork{
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString *urlStr = @"https://www.rongtuojinrong.com/rongtuoxinsoc/Juyijuparty/myjoinlistapp";
    NSDictionary * parameter = @{@"appid":@"huiyuan",
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"c_page":[NSString stringWithFormat:@"%d",self.currentPage],
                                 @"page_size":@"10",
                                 };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [FMHTTPClient postPath:urlStr parameters:parameter completion:^(WebAPIResponse *response) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (response.responseObject == nil) {
//            ShowAutoHideMBProgressHUD(self.view, NETERROR_LOADERR_TIP);
        }
        
        if(response.code == WebAPIResponseCodeSuccess){
            
            if (response.responseObject) {
                NSArray *newArray = [NSArray arrayWithArray:response.responseObject[@"data"]];

                if (![newArray isMemberOfClass:[NSNull class]]) {
                        
                        if (newArray.count) {
                            if (![newArray isKindOfClass:[NSNull class]]) {
                                
                                for(NSDictionary *dict in newArray){
                                    NSMutableDictionary *infoDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
                                    YSFootPrintModel *model = [[YSFootPrintModel alloc]initWithDict:infoDict];
                                    [self.footprintDataSource addObject:model];
                                }
                                
                                [self.tableView reloadData];
                            }
                        }
                }
            }
        }else{
//            ShowAutoHideMBProgressHUD(self.view, NETERROR_LOADERR_TIP);
        }
        [self.tableView reloadData];

        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark ---   创建UITableView

- (void)setUpTableView{

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, KProjectScreenWidth, KProjectScreenHeight -114) style:(UITableViewStyleGrouped)];
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 20)];
    headerView.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = headerView;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (self.signBtn.selected) {
    
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            _currentPage = 1;
            [self.signDataSource removeAllObjects];
            [self getSignDataSourceFromNetWork];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
                _currentPage = _currentPage+1;
                [self getSignDataSourceFromNetWork];
        }];
    }
    [self.view addSubview:self.tableView];
    
}
#pragma mark ---   UITableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.signBtn.selected == YES) {
        
    
        if (self.signDataSource.count) {
            return self.signDataSource.count;
        }else{
            return 0;
        }
    }else{
    
        if (self.signDataSource.count) {
            return self.footprintDataSource.count;
        }else{
            return 0;
        }

        return self.footprintDataSource.count;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID1 = @"YSFootPrintViewCell";
    static NSString *ID2 = @"YSSignViewCell";
    
    if (self.signBtn.selected == YES) {
        
        YSSignViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID2];
        if (cell == nil) {
            
            cell = [[YSSignViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID2];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.signDataSource.count) {
            
            cell.dataSource = self.signDataSource[indexPath.section];
        }
        return cell;
    }else{
    
        YSFootPrintViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID1];
    
        if (cell == nil) {
        
            cell = [[YSFootPrintViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID1];
    
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.footprintDataSource.count) {
            
            cell.dataSource = self.footprintDataSource[indexPath.section];
        }
        return cell;
    }
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.signBtn.selected == YES) {
        return 105;
    }else{
        return 58;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.signBtn.selected == YES) {
        
        XZRegistrationCertificateViewController *vc = [[XZRegistrationCertificateViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        vc.pid = [self.signDataSource[indexPath.section] pid];
        vc.phone = [self.signDataSource[indexPath.section] phone];
    }else{
        }
}



#pragma mark 报名凭证 + 我的足迹
- (UIButton *)signBtn {
    
    if (!_signBtn) {
        _signBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_signBtn setTitle:@"报名凭证" forState:(UIControlStateNormal)];
        [_signBtn setTitleColor:[UIColor colorWithHexString:@"#888889"] forState:(UIControlStateNormal)];
        [_signBtn setTitleColor:[HXColor colorWithHexString:@"#003399"] forState:(UIControlStateSelected)];
        _signBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_signBtn addTarget:self action:@selector(signAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _signBtn;
}

- (UIButton *)footprintBtn {
    
    if (!_footprintBtn) {
        _footprintBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_footprintBtn setTitle:@"我的足迹" forState:(UIControlStateNormal)];
        [_footprintBtn setTitleColor:[UIColor colorWithHexString:@"#888889"] forState:(UIControlStateNormal)];
        [_footprintBtn setTitleColor:[HXColor colorWithHexString:@"#003399"] forState:(UIControlStateSelected)];
        _footprintBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_footprintBtn addTarget:self action:@selector(footprintAction:) forControlEvents:(UIControlEventTouchUpInside)];

    }
    return _footprintBtn;
}

- (void)setTopSelectTitleView{
    
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    [topView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(@49);
    }];
    self.signBtn.selected = YES;
    self.footprintBtn.selected = NO;
    [topView addSubview:self.signBtn];
    
    [topView addSubview:self.footprintBtn];
    [self.signBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(topView);
        make.right.equalTo(topView.mas_centerX);
    }];
    
    [self.footprintBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(topView);
        make.left.equalTo(topView.mas_centerX);
    }];

    UIView *signLineV = [[UIView alloc]init];
    self.signLineV = signLineV;
    self.signLineV.backgroundColor = [UIColor colorWithHexString:@"#003399"];
    
    UIView *footprintLineV = [[UIView alloc]init];
    self.footprintLineV = footprintLineV;
    self.footprintLineV.backgroundColor = KDefaultOrBackgroundColor;
    [self.view addSubview:self.signLineV];
    [self.signLineV makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.signBtn);
        make.height.equalTo(1);
        make.top.equalTo(topView.mas_bottom);
    }];
    
    [self.view addSubview:self.footprintLineV];
    [self.footprintLineV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.and.right.equalTo(self.footprintBtn);
        make.height.equalTo(1);
    }];
}

- (void)signAction:(UIButton *)sender {
    
    self.currentPage = 1;
    self.footprintBtn.selected = NO;
    self.footprintLineV.backgroundColor = KDefaultOrBackgroundColor;
    self.signLineV.backgroundColor = [UIColor colorWithHexString:@"#003399"];
    sender.selected = YES;
    [self.signDataSource removeAllObjects];
    [self getSignDataSourceFromNetWork];

}

- (void)footprintAction:(UIButton *)sender {
    self.currentPage = 1;

    self.signBtn.selected = NO;
    self.signLineV.backgroundColor = KDefaultOrBackgroundColor;
    self.footprintLineV.backgroundColor = [UIColor colorWithHexString:@"#003399"];
    sender.selected = YES;
    [self.footprintDataSource removeAllObjects];
    [self getFootprintDataSourceFromNetWork];
}


@end
