//
//  YYCardPackageController.m
//  fmapp
//
//  Created by yushibo on 2016/12/14.
//  Copyright © 2016年 yk. All rights reserved.
//  我的卡券包

#import "YYCardPackageController.h"
#import "YYCouponCell.h"  //卡券cell
#import "YYItemTargetCell.h" //可投的项目标
#import "YYExpiredOrUsedController.h" //已过期或已使用优惠券
#import "YYRedExplainViewController.h"
#import "YYInstructionsController.h"
//#import "MJExtension.h"
#import "YYCardPackageModel.h"
#import "YYUsedBidModel.h"

#import "WLNewProjectDetailViewController.h"
@interface YYCardPackageController () <UITableViewDataSource, UITableViewDelegate>
/** 红包券按钮  */
@property (nonatomic, strong) UIButton *redPacketsBtn;
/** 加息券按钮  */
@property (nonatomic, strong) UIButton *addInterestBtn;
/** 抵价券按钮  */
@property (nonatomic, strong) UIButton *supportPriceBtn;
/** 体验金按钮  */
@property (nonatomic, strong) UIButton *experienceGoldBtn;
/** 暂无数据 */
@property (nonatomic, strong) UILabel *alertLabel;
/** 已用和已过期view */
@property (nonatomic, strong) UIView *UnusedFooterView;
/** 已用和已过期btn */
@property (nonatomic, strong) UIButton *UnusedBtn;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UIView *line3;
@property (nonatomic, strong) UIView *line4;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *tag;

/** 卡券请求 区别 参数*/
@property (nonatomic, strong) NSString *CmdId;
/** 卡券请求 状态 参数*/
@property (nonatomic, strong) NSString *status;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, strong) NSMutableArray *dataSource;
/**
 *  可投标数组
 */
@property (nonatomic, strong) NSMutableArray *usedBidDataSource;



@end

@implementation YYCardPackageController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentPage = 1;
    self.status = @"0";
    self.CmdId = @"GetRedPacket";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#e5e9f2"];
    
    [self settingNavTitle:@"我的卡券包"];
    [self setTopSelectTitleView];
    [self createTableView];
    [self createInstructionsView];
    [self getUsedBidDataSourceFromNetWork];
    [self getDataSourceFromNetWork];
    [self alertLabel];
    [self UnusedFooterView];
    [self UnusedBtn];
    
}

#pragma mark --- 懒加载
-(NSMutableArray *)dataSource{

    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        
    }
    return _dataSource;
}

- (UILabel *)alertLabel
{
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc]init];
        [self.view addSubview:_alertLabel];
        [_alertLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.redPacketsBtn.mas_bottom).offset(45);
        }];
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        _alertLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _alertLabel.font = [UIFont systemFontOfSize:17];
        if ([self.tag integerValue] == 1) {
            _alertLabel.text = @"暂无红包券";
        }else if ([self.tag integerValue] == 2){
            _alertLabel.text = @"暂无加息券";
        }else if ([self.tag integerValue] == 3){
            _alertLabel.text = @"暂无抵价券";
        }else if ([self.tag integerValue] == 4){
            _alertLabel.text = @"暂无体验金";
        }

        _alertLabel.textColor = [UIColor darkGrayColor];
        _alertLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _alertLabel;
}

-(UIView *)UnusedFooterView{
    if (!_UnusedFooterView) {
        _UnusedFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 60)];
        _UnusedFooterView.userInteractionEnabled = YES;
        
        [self.view addSubview:_UnusedFooterView];
        [_UnusedFooterView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.alertLabel.mas_bottom).offset(5);
            make.height.equalTo(50);
        }];


        UIButton *btn = [[UIButton alloc]init];
        //    btn.backgroundColor = [UIColor redColor];
        [btn addTarget:self action:@selector(clickFooterViewBtn) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor colorWithHexString:@"#aaaaaa"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        self.UnusedBtn = btn;
        if ([self.tag integerValue] == 1) {
            [btn setTitle:@"查看已使用和过期红包" forState:UIControlStateNormal];
        }else if ([self.tag integerValue] == 2){
            [btn setTitle:@"查看已使用和过期加息券" forState:UIControlStateNormal];
        }else if ([self.tag integerValue] == 3){
            [btn setTitle:@"查看已使用和过期抵价券" forState:UIControlStateNormal];
        }else if ([self.tag integerValue] == 4){
            [btn setTitle:@"查看已使用和过期体验金" forState:UIControlStateNormal];
        }
        [self.view addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_UnusedFooterView);
        }];
        
        UIImageView *jianTouView = [[UIImageView alloc]init];
        jianTouView.image = [UIImage imageNamed:@"新版_右箭头_36"];
        [_UnusedFooterView addSubview:jianTouView];
        [jianTouView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(btn.mas_right).offset(2);
            make.centerY.equalTo(btn.mas_centerY);
        }];

    }
    return _UnusedFooterView;

    
}

- (void)clickFooterViewBtn{
    
    YYExpiredOrUsedController *eou= [[YYExpiredOrUsedController alloc]init];
    if ([self.tag integerValue] == 1) {
        eou.navTitle = @"已使用和过期红包";
    }else if ([self.tag integerValue] == 2){
        eou.navTitle = @"已使用和过期加息券";
    }else if ([self.tag integerValue] == 3){
        eou.navTitle = @"已使用和过期抵价券";
    }else if ([self.tag integerValue] == 4){
        eou.navTitle = @"已使用和过期体验金";
    }
    
    eou.tag = self.tag;
    eou.CmdId = self.CmdId;
    [self.navigationController pushViewController:eou animated:YES];
    
}
-(NSMutableArray *)usedBidDataSource{

    if (!_usedBidDataSource) {
        _usedBidDataSource = [NSMutableArray array];
    }
    return _usedBidDataSource;
}
#pragma mark --- 创建TabeView
- (void)createTableView{
    
    UITableView *tableview= [[UITableView alloc]initWithFrame:CGRectMake(0, 81, KProjectScreenWidth, KProjectScreenHeight - 81 - 64 - 50)style:(UITableViewStylePlain)];
    tableview.backgroundColor = [UIColor colorWithHexString:@"#e5e9f2"];
//    tableview.backgroundColor = [UIColor redColor];

    tableview.delegate=self;
    tableview.dataSource=self;
    tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
//    tableview.tableFooterView = [self setUpTableFooterView];
    self.tableView = tableview;
    __weak typeof (self)weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _currentPage = 1;
        if ([self.tag integerValue] == 1 || [self.tag integerValue] == 2) {
            
            [weakSelf.usedBidDataSource removeAllObjects];
            [weakSelf getUsedBidDataSourceFromNetWork];
            
        }
        [weakSelf getDataSourceFromNetWork];
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _currentPage = _currentPage+1;
   //     NSLog(@"%d", _currentPage);
        [weakSelf getDataSourceFromNetWork];
    }];

    [self.view addSubview:self.tableView];
    
}



#pragma mark --- 可投项目标 -- 网络请求
- (void)getUsedBidDataSourceFromNetWork{
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"AppId":@"huiyuan",
                                 @"AppTime":[NSNumber numberWithInt:timestamp],
                                 @"Token":tokenlow,
                              //   @"CmdId":@"CardPackPage",
                                 };
    
    __weak __typeof(self)weakSelf = self;
    //kXZUniversalTestUrl(@"CardPackPage")
    [FMHTTPClient postPath:kFMPhpUniversalBaseUrl(@"rongtuoxinsoc/lend/caparecommproliuer") parameters:parameter completion:^(WebAPIResponse *response) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (response.responseObject == nil) {
            
//            ShowAutoHideMBProgressHUD(self.view, NETERROR_LOADERR_TIP);
            [weakSelf.tableView reloadData];
            return;
        }
        
        if(response.code == WebAPIResponseCodeSuccess){
            NSDictionary *dataDict = response.responseObject[@"data"];
            if (![dataDict isMemberOfClass:[NSNull class]]) {
                
                YYUsedBidModel *model = [[YYUsedBidModel alloc]init];
                [model setValuesForKeysWithDictionary:dataDict];
                [weakSelf.usedBidDataSource addObject:model];
                
            }
        }else{
            
//            ShowAutoHideMBProgressHUD(self.view, response.responseObject[@"msg"]);
            
        }
        
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    
}


#pragma mark --- 卡券包 -- 网络请求
- (void)getDataSourceFromNetWork{
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"AppId":@"huiyuan",
                                 @"AppTime":[NSNumber numberWithInt:timestamp],
                                 @"Token":tokenlow,
                              //   @"CmdId":self.CmdId,
                                 @"Status":self.status,
                                 @"PageNum":[NSString stringWithFormat:@"%d", self.currentPage]
                                 };
    
    __weak __typeof(self)weakSelf = self;
    [FMHTTPClient postPath:kXZUniversalTestUrl(self.CmdId) parameters:parameter completion:^(WebAPIResponse *response) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (response.responseObject == nil) {
            
            ShowAutoHideMBProgressHUD(self.view, NETERROR_LOADERR_TIP);
            /** 暂无数据提示 */
            if (weakSelf.dataSource.count == 0) {
                
                weakSelf.alertLabel.hidden = NO;
                weakSelf.UnusedFooterView.hidden = NO;
                weakSelf.UnusedBtn.hidden = NO;

            }else{
                weakSelf.alertLabel.hidden = YES;
                weakSelf.UnusedFooterView.hidden = NO;
                weakSelf.UnusedBtn.hidden = NO;

                [weakSelf.UnusedFooterView remakeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.view.mas_bottom);
                    make.centerX.equalTo(self.view.mas_centerX);
                    make.height.equalTo(50);
                }];

            }
           
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            return;
        }
        
        if(response.code == WebAPIResponseCodeSuccess){
            
            
            if (weakSelf.currentPage == 1) {
                [weakSelf.dataSource removeAllObjects];
            }
            
            NSDictionary *dataDict = response.responseObject[@"data"];
            NSArray *newArray = [NSArray arrayWithArray:dataDict[@"Detail"]];
            
            if (![newArray isMemberOfClass:[NSNull class]]) {
                
                if (newArray.count) {
                    
                    for(NSDictionary *dict in newArray){
                        
                        YYCardPackageModel *model = [[YYCardPackageModel alloc]init];
                        [model setValuesForKeysWithDictionary:dict];
                        
                        model.contentH = [model.Desc getStringCGSizeWithMaxSize:CGSizeMake(KProjectScreenWidth - 45 -(KProjectScreenWidth / 5), MAXFLOAT) WithFont:[UIFont systemFontOfSize:16.0f]].height;
                        [weakSelf.dataSource addObject:model];
                    }
                
                }
                    /** 暂无数据提示 */
                    if (weakSelf.dataSource.count == 0) {
                        weakSelf.alertLabel.hidden = NO;
                        weakSelf.UnusedFooterView.hidden = NO;
                        weakSelf.UnusedBtn.hidden = NO;

                    }else{
                        weakSelf.alertLabel.hidden = YES;
                        weakSelf.UnusedFooterView.hidden = NO;
                        weakSelf.UnusedBtn.hidden = NO;
                        [weakSelf.UnusedFooterView remakeConstraints:^(MASConstraintMaker *make) {
                            make.bottom.equalTo(self.view.mas_bottom);
                            make.centerX.equalTo(self.view.mas_centerX);
                            make.height.equalTo(50);
                        }];

                    }

                
            }
        }else{
            /** 暂无数据提示 */
            if (weakSelf.dataSource.count == 0) {
                weakSelf.alertLabel.hidden = NO;
                weakSelf.UnusedFooterView.hidden = NO;
                weakSelf.UnusedBtn.hidden = NO;


            }else{
                weakSelf.alertLabel.hidden = YES;
                weakSelf.UnusedFooterView.hidden = NO;
                weakSelf.UnusedBtn.hidden = NO;
                [weakSelf.UnusedFooterView remakeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.view.mas_bottom);
                    make.centerX.equalTo(self.view.mas_centerX);
                    make.height.equalTo(50);
                }];

            }
            ShowAutoHideMBProgressHUD(self.view, response.responseObject[@"msg"]);
            
        }
        
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.dataSource.count) {
        if (self.usedBidDataSource.count) {
            return self.dataSource.count + 1;
        }else{
        return self.dataSource.count;
        }
    }else{
    
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID1 = @"YYItemTargetCell";
    static NSString *ID2 = @"YYCouponCell";

//    if (self.dataSource.count) {
        if (self.usedBidDataSource.count) {
            
            if (indexPath.row == 0) {
                
                YYItemTargetCell *cell = [tableView dequeueReusableCellWithIdentifier:ID1];
                if (cell == nil) {
                    
                    cell = [[YYItemTargetCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID1];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (self.usedBidDataSource.count) {
                    
                    cell.model = self.usedBidDataSource[0];
                }
                return cell;
            }else{
                
                YYCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:ID2];
                
                if (cell == nil) {
                    
                    cell = [[YYCouponCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID2];
                    
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                YYCardPackageModel *model = self.dataSource[indexPath.row - 1];
                
                [cell sendDataWithmodel:model withBtnTag:self.tag];
                return cell;
            }
        }else{
            
            YYCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:ID2];
            
            if (cell == nil) {
                
                cell = [[YYCouponCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID2];
                
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

                [cell sendDataWithmodel:self.dataSource[indexPath.row] withBtnTag:self.tag];
            return cell;

        }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataSource.count) {
        
        
        if (self.usedBidDataSource.count) { // 有项目标
            
            if (indexPath.row == 0) {
                return 130;
            }else{
                YYCardPackageModel *model1 = self.dataSource[indexPath.row - 1];

                if (model1.contentH > 45) {
                    return 120 + 20 + model1.contentH;
                    
                }else{
                    
                    return 165;
                }

            }
            
        }else{ //无项目标
            YYCardPackageModel *model2 = self.dataSource[indexPath.row];

            if (model2.contentH > 45) {
                return 120 + 20 + model2.contentH;
                
            }else{
                
                return 165;
            }
    
        }
    }else{
    
        return 0;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.dataSource.count) {
    
        if (self.usedBidDataSource.count) { // 有项目标
            
            if (indexPath.row == 0) {
                
            
                YYUsedBidModel *model = self.usedBidDataSource[0];
                
                if([model.zhuangtai integerValue]==8){
                    
                    WLNewProjectDetailViewController *viewController=[[WLNewProjectDetailViewController alloc]initWithUserOperationStyle:3 WithProjectId:model.jie_id];
                    viewController.rongzifangshi = [NSString stringWithFormat:@"%@",model.rongzifangshi];
                    viewController.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:viewController animated:YES];
                    
                }else if([model.zhuangtai integerValue]==4||[model.zhuangtai integerValue]==6){
                    
                    WLNewProjectDetailViewController *viewController=[[WLNewProjectDetailViewController alloc]initWithUserOperationStyle:3 WithProjectId:model.jie_id];
                    viewController.rongzifangshi = [NSString stringWithFormat:@"%@",model.rongzifangshi];
                    viewController.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:viewController animated:YES];
                    
                    
                }else{
                    if ([model.kaishicha integerValue] >0) {
                        
                        WLNewProjectDetailViewController *viewController=[[WLNewProjectDetailViewController alloc]initWithUserOperationStyle:1 WithProjectId:model.jie_id];
                        viewController.rongzifangshi = [NSString stringWithFormat:@"%@",model.rongzifangshi];
                        viewController.hidesBottomBarWhenPushed=YES;
                        [self.navigationController pushViewController:viewController animated:YES];
                        
                    }else{
                        
                        WLNewProjectDetailViewController *viewController=[[WLNewProjectDetailViewController alloc]initWithUserOperationStyle:2 WithProjectId:model.jie_id];
                        viewController.rongzifangshi = [NSString stringWithFormat:@"%@",model.rongzifangshi];
                        viewController.hidesBottomBarWhenPushed=YES;
                        [self.navigationController pushViewController:viewController animated:YES];
                    }
            
            
                }
        
            }
        }
    }
    

    
}
#pragma mark ---- 使用说明
- (void)createInstructionsView{

    UIView *instructionsView = [[UIView alloc]initWithFrame:CGRectMake(0, 46, KProjectScreenWidth, 35)];
    instructionsView.backgroundColor = [UIColor colorWithHexString:@"e5e9f2"];
    [self.view addSubview:instructionsView];
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = @"使用说明";
    label1.font = [UIFont systemFontOfSize:14];
    label1.textColor = [UIColor colorWithHexString:@"#333333"];
    [instructionsView addSubview:label1];
    [label1 makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(instructionsView.mas_right).offset(-15);
        make.centerY.equalTo(instructionsView.mas_centerY);
    }];
    UIButton *imageBtn = [[UIButton alloc]init];
    [imageBtn setImage:[UIImage imageNamed:@"新版_我的卡卷包_使用说明_36"] forState:UIControlStateNormal];
    [instructionsView addSubview:imageBtn];
    [imageBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(label1.mas_left).offset(-1);
        make.centerY.equalTo(label1.mas_centerY);
        make.height.width.equalTo(25);
    }];
    
    
    UIButton * btn = [[UIButton alloc]init];
    [btn addTarget:self action:@selector(clickInstructionsButton) forControlEvents:UIControlEventTouchUpInside];
    [instructionsView addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(label1.mas_right);
        make.left.equalTo(imageBtn.mas_left);
        make.centerY.equalTo(label1.mas_centerY);
        make.height.equalTo(25);
    }];
    
    
    
}

- (void)clickInstructionsButton{
    
    YYInstructionsController *redVc = [[YYInstructionsController alloc]init];
    
    if ([self.tag integerValue] == 1) {
        redVc.navTitle =@"红包券使用说明";
    }else if ([self.tag integerValue] == 2){
        redVc.navTitle =@"加息券使用说明";
    }else if ([self.tag integerValue] == 3){
        redVc.navTitle =@"抵价券使用说明";
    }else if ([self.tag integerValue] == 4){
        redVc.navTitle =@"体验金使用说明";
    }
    
    redVc.state = self.tag;
    [self.navigationController pushViewController:redVc animated:YES];

}
#pragma mark ---- 头部选择器
- (void)setTopSelectTitleView{
    
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    [topView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(@45);
    }];
    self.redPacketsBtn.selected = YES;
    self.addInterestBtn.selected = NO;
    self.supportPriceBtn.selected = NO;
    self.experienceGoldBtn.selected = NO;
    self.tag = @"1";
    [topView addSubview:self.redPacketsBtn];
    [topView addSubview:self.addInterestBtn];
    [topView addSubview:self.supportPriceBtn];
    [topView addSubview:self.experienceGoldBtn];
    
    [self.redPacketsBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(topView);
        make.width.equalTo(KProjectScreenWidth / 4);
        make.bottom.equalTo(topView.mas_bottom).offset(-1);

    }];
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = [UIColor colorWithHexString:@"#0159d5"];
    self.line1 = line1;
    [topView addSubview:self.line1];
    
    [line1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.redPacketsBtn.mas_bottom);
        make.left.equalTo(self.redPacketsBtn.mas_left);
        make.width.equalTo(KProjectScreenWidth / 4);
        make.bottom.equalTo(topView.mas_bottom);
        
    }];
    
    [self.addInterestBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top);
        make.left.equalTo(self.redPacketsBtn.mas_right);
        make.width.equalTo(KProjectScreenWidth / 4);
        make.bottom.equalTo(topView.mas_bottom).offset(-1);

    }];
    
    UIView *line2 = [[UIView alloc]init];
    line2.backgroundColor = [UIColor colorWithHexString:@"#0159d5"];
    self.line2 = line2;
    [topView addSubview:self.line2];
    [line2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addInterestBtn.mas_bottom);
        make.left.equalTo(self.addInterestBtn.mas_left);
        make.width.equalTo(KProjectScreenWidth / 4);
        make.bottom.equalTo(topView.mas_bottom);
        
    }];
    
    [self.supportPriceBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView);
        make.left.equalTo(self.addInterestBtn.mas_right);
        make.width.equalTo(KProjectScreenWidth / 4);
        make.bottom.equalTo(topView.mas_bottom).offset(-1);

    }];
    
    UIView *line3 = [[UIView alloc]init];
    line3.backgroundColor = [UIColor colorWithHexString:@"#0159d5"];
    self.line3 = line3;
    [topView addSubview:self.line3];

    [line3 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.supportPriceBtn.mas_bottom);
        make.left.equalTo(self.supportPriceBtn.mas_left);
        make.width.equalTo(KProjectScreenWidth / 4);
        make.bottom.equalTo(topView.mas_bottom);
        
    }];

    [self.experienceGoldBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(topView);
        make.width.equalTo(KProjectScreenWidth / 4);
        make.bottom.equalTo(topView.mas_bottom).offset(-1);
    }];
    
    UIView *line4 = [[UIView alloc]init];
    line4.backgroundColor = [UIColor colorWithHexString:@"#0159d5"];
    self.line4 = line4;
    [topView addSubview:self.line4];

    [line4 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.experienceGoldBtn.mas_bottom);
        make.left.equalTo(self.experienceGoldBtn.mas_left);
        make.width.equalTo(KProjectScreenWidth / 4);
        make.bottom.equalTo(topView.mas_bottom);
        
    }];
    
    self.line1.hidden = NO;
    self.line2.hidden = YES;
    self.line3.hidden = YES;
    self.line4.hidden = YES;
    
}

#pragma mark ---红包券 + 加息券 + 抵价券 + 体验金
- (UIButton *)redPacketsBtn{
    if (!_redPacketsBtn) {
        _redPacketsBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_redPacketsBtn setTitle:@"红包券" forState:(UIControlStateNormal)];
        [_redPacketsBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateNormal)];
        [_redPacketsBtn setTitleColor:[HXColor colorWithHexString:@"#0159d5"] forState:(UIControlStateSelected)];
        _redPacketsBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_redPacketsBtn addTarget:self action:@selector(redPacketsBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _redPacketsBtn;
}
- (UIButton *)addInterestBtn {
    
    if (!_addInterestBtn) {
        _addInterestBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_addInterestBtn setTitle:@"加息券" forState:(UIControlStateNormal)];
        [_addInterestBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateNormal)];
        [_addInterestBtn setTitleColor:[HXColor colorWithHexString:@"#0159d5"] forState:(UIControlStateSelected)];
        _addInterestBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_addInterestBtn addTarget:self action:@selector(addInterestBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _addInterestBtn;
}
- (UIButton *)supportPriceBtn {
    
    if (!_supportPriceBtn) {
        _supportPriceBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_supportPriceBtn setTitle:@"抵价券" forState:(UIControlStateNormal)];
        [_supportPriceBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateNormal)];
        [_supportPriceBtn setTitleColor:[HXColor colorWithHexString:@"#0159d5"] forState:(UIControlStateSelected)];
        _supportPriceBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_supportPriceBtn addTarget:self action:@selector(supportPriceBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _supportPriceBtn;
}
- (UIButton *)experienceGoldBtn {
    
    if (!_experienceGoldBtn) {
        _experienceGoldBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_experienceGoldBtn setTitle:@"体验金" forState:(UIControlStateNormal)];
        [_experienceGoldBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateNormal)];
        [_experienceGoldBtn setTitleColor:[HXColor colorWithHexString:@"#0159d5"] forState:(UIControlStateSelected)];
        _experienceGoldBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_experienceGoldBtn addTarget:self action:@selector(experienceGoldBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _experienceGoldBtn;
}
#pragma mark ---红包券 + 加息券 + 抵价券 + 体验金 -> 点击事件
- (void)redPacketsBtnAction:(UIButton *)sender{
    //红包券
    self.redPacketsBtn.selected = YES;
    self.addInterestBtn.selected = NO;
    self.supportPriceBtn.selected = NO;
    self.experienceGoldBtn.selected = NO;

    self.line1.hidden = NO;
    self.line2.hidden = YES;
    self.line3.hidden = YES;
    self.line4.hidden = YES;
    self.tag = @"1";
//    [self.tableView setTableFooterView:[self setUpTableFooterView]];

    [self.dataSource removeAllObjects];
    [self.usedBidDataSource removeAllObjects];
    [self.tableView reloadData];
    
    _alertLabel.hidden = YES;
    _alertLabel.text = @"暂无红包券";
    _UnusedBtn.hidden = YES;
    [self.UnusedBtn setTitle:@"查看已使用和过期红包" forState:UIControlStateNormal];
    _UnusedFooterView.hidden = YES;
    [_UnusedFooterView remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.alertLabel.mas_bottom).offset(5);
        make.height.equalTo(50);
    }];

    
    self.currentPage = 1;
    self.status = @"0";
    self.CmdId = @"GetRedPacket";
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getUsedBidDataSourceFromNetWork];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getDataSourceFromNetWork];
}
- (void)addInterestBtnAction:(UIButton *)sender{
    //加息券
    self.redPacketsBtn.selected = NO;
    self.addInterestBtn.selected = YES;
    self.supportPriceBtn.selected = NO;
    self.experienceGoldBtn.selected = NO;
    
    self.line1.hidden = YES;
    self.line2.hidden = NO;
    self.line3.hidden = YES;
    self.line4.hidden = YES;
    self.tag = @"2";

    [self.dataSource removeAllObjects];
    [self.usedBidDataSource removeAllObjects];
    _alertLabel.hidden = YES;
    _alertLabel.text = @"暂无加息券";
    _UnusedBtn.hidden = YES;
    [self.UnusedBtn setTitle:@"查看已使用和过期加息券" forState:UIControlStateNormal];
    _UnusedFooterView.hidden = YES;
    [_UnusedFooterView remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.alertLabel.mas_bottom).offset(5);
        make.height.equalTo(50);
    }];
    
    

    [self.tableView reloadData];
    self.status = @"0";
    self.currentPage = 1;
    self.CmdId = @"GetInterestCoupon";
    [self getUsedBidDataSourceFromNetWork];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getDataSourceFromNetWork];
}
- (void)supportPriceBtnAction:(UIButton *)sender{
    //抵价券
    self.redPacketsBtn.selected = NO;
    self.addInterestBtn.selected = NO;
    self.supportPriceBtn.selected = YES;
    self.experienceGoldBtn.selected = NO;
    self.line1.hidden = YES;
    self.line2.hidden = YES;
    self.line3.hidden = NO;
    self.line4.hidden = YES;
    self.tag = @"3";

    [self.dataSource removeAllObjects];
    [self.usedBidDataSource removeAllObjects];
    [self.tableView reloadData];
    _alertLabel.hidden = YES;
    _alertLabel.text = @"暂无抵价券";
    _UnusedBtn.hidden = YES;
    [self.UnusedBtn setTitle:@"查看已使用和过期抵价券" forState:UIControlStateNormal];
    _UnusedFooterView.hidden = YES;
    [_UnusedFooterView remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.alertLabel.mas_bottom).offset(5);
        make.height.equalTo(50);
    }];



    self.status = @"0";
    self.currentPage = 1;
    self.CmdId = @"GetVouchers";
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getDataSourceFromNetWork];
}
- (void)experienceGoldBtnAction:(UIButton *)sender{
    //体验金
    self.redPacketsBtn.selected = NO;
    self.addInterestBtn.selected = NO;
    self.supportPriceBtn.selected = NO;
    self.experienceGoldBtn.selected = YES;
    self.line2.hidden = YES;
    self.line1.hidden = YES;
    self.line3.hidden = YES;
    self.line4.hidden = NO;
    self.tag = @"4";

    [self.dataSource removeAllObjects];
    [self.usedBidDataSource removeAllObjects];
    [self.tableView reloadData];
    _alertLabel.hidden = YES;
    _alertLabel.text = @"暂无体验金";
    _UnusedBtn.hidden = YES;
    [self.UnusedBtn setTitle:@"查看已使用和过期体验金" forState:UIControlStateNormal];
    _UnusedFooterView.hidden = YES;
    [_UnusedFooterView remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.alertLabel.mas_bottom).offset(5);
        make.height.equalTo(50);
    }];
    


    self.status = @"0";
    self.currentPage = 1;
    self.CmdId = @"GetExperienceCoupon";
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getDataSourceFromNetWork];
}

@end
