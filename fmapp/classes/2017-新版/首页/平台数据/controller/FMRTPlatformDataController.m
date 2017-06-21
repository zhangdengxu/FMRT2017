//
//  FMRTPlatformDataController.m
//  fmapp
//
//  Created by apple on 2017/2/8.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRTPlatformDataController.h"
#import "FMRTPlatformModel.h"
#import "MJExtension.h"
#import "FMRTTopDataCell.h"
#import "FMRTPlatformHeaderView.h"
#import "FMRTLineChartCell.h"
#import "FMRTComDataShowCell.h"
#import "FMRTZCZBFBCell.h"
#import "FMRTchengjiaofenxiCell.h"
#import "FMRTProqixianCell.h"
#import "FMRTXMleixingTableViewCell.h"
#import "FMRTManWomanCell.h"
#import "FMRTnianlingfenbuCell.h"
#import "FMRTyonghuleixingCell.h"
#import "FMRTtouzijinefenbuCell.h"
#import "FMRTRegisterAppController.h"


@interface FMRTPlatformDataController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong)FMRTPlatformModel *dataModel;
@property (nonatomic, strong)UIView *footView;
@property (nonatomic, strong)UIWebView *webView;
@property (nonatomic, assign)NSInteger isShowMap;


@end

@implementation FMRTPlatformDataController

static NSString *FMRTPlatformTableViewCellID = @"FMRTPlatformTableViewCell";
static NSString *FMRTTopDataCellID = @"FMRTTopDataCell";
static NSString *FMRTLineChartCellID = @"FMRTLineChartCell";
static NSString *FMRTComDataShowCellID = @"FMRTComDataShowCell";//
static NSString *FMRTZCZBFBCellID = @"FMRTZCZBFBCellID";//
static NSString *FMRTchengjiaofenxiCellID = @"FMRTchengjiaofenxiCellID";//
static NSString *FMRTProqixianCellID = @"FMRTProqixianCellID";//
static NSString *FMRTXMleixingTableViewCellID = @"FMRTXMleixingTableViewCellID";//
static NSString *FMRTManWomanCellID = @"FMRTManWomanCellID";//
static NSString *FMRTnianlingfenbuCellID = @"FMRTnianlingfenbuCellID";
static NSString *FMRTyonghuleixingCellID = @"FMRTyonghuleixingCellID";
static NSString *FMRTtouzijinefenbuCellID = @"FMRTtouzijinefenbuCellID";
static NSString *FMRTPlatformWebviewCellID = @"FMRTPlatformWebviewCellID";


- (FMRTPlatformModel *)dataModel{
    if (!_dataModel) {
        _dataModel = [[FMRTPlatformModel alloc]init];
    }
    return _dataModel;
}

- (UIView *)footView{
    if (!_footView) {
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 50)];
        footView.backgroundColor = [UIColor colorWithHexString:@"#0159d5"];
        self.footView = footView;
        UIButton *registerBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [registerBtn setTitle:@"免费注册" forState:(UIControlStateNormal)];
        [registerBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        registerBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [footView addSubview:registerBtn];
        [registerBtn addTarget:self action:@selector(registerBtn) forControlEvents:(UIControlEventTouchUpInside)];
        [registerBtn makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(footView.centerX);
            make.centerY.equalTo(footView.centerY);
        }];
        _footView = footView;
    }
    return _footView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"平台数据"];
    
    
    [self createTableView];
    [self reqestwebDataForTabel];

}

- (void)reqestwebDataForTabelWith:(NSString*)weburl{
    
    UIWebView *platWebview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 50, KProjectScreenWidth, 100)];
    _webView = platWebview;
    platWebview.delegate = self;
    platWebview.scrollView.scrollEnabled = NO;
    
    [platWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:weburl]]];
    [platWebview scalesPageToFit];
}

- (void)reqestwebDataForTabel{
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);

    NSString *tokenlow=[token lowercaseString];
//    NSString * shareUrlHtml = @"https://www.rongtuojinrong.com/rongtuoxinsoc/helpzhongxin/pingtaishuju";
    
//    NSString *shareUrlHtml = [NSString stringWithFormat:@"%@&AppId=huiyuan&Token=%@&AppTime=%@&UserId=%@",kXZUniversalTestUrl(@"GetGlobalStats"),tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId];
    NSString *shareUrlHtml = [NSString stringWithFormat:@"%@?AppId=huiyuan&Token=%@&AppTime=%@&UserId=%@",kFMPhpUniversalBaseUrl(@"rongtuoxinsoc/helpzhongxin/pingtaishuju"),tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId];


//    NSString * shareUrlHtml = kFMPhpUniversalBaseUrl(@"rongtuoxinsoc/helpzhongxin/pingtaishuju");

    FMWeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:shareUrlHtml parameters:nil completion:^(WebAPIResponse *response) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if (response.responseObject) {
            if (response.code ==WebAPIResponseCodeSuccess) {
                
                if ( [response.responseObject objectForKey:@"data"]) {
                    NSDictionary *data = [response.responseObject objectForKey:@"data"];
                    
                    if ([data objectForKey:@"Overview"]) {
                        id OverviewDic = [data objectForKey:@"Overview"];
                        
                        if ([OverviewDic isKindOfClass:[NSDictionary class]]) {
                            NSDictionary *dict = (NSDictionary *)OverviewDic;
                            
                            weakSelf.dataModel.overViewModel = [FMOverViewModel mj_objectWithKeyValues:dict];
                        }
                    }
                    
                    if ([data objectForKey:@"DealAmtStats"]) {
                        id DealAmtStatsArr = [data objectForKey:@"DealAmtStats"];
                        if ([DealAmtStatsArr isKindOfClass:[NSArray class]]) {
                            NSArray *arr = (NSArray *)DealAmtStatsArr;
                            NSMutableArray *dataArr = [NSMutableArray array];
                            if (arr.count) {
                                for (NSDictionary *dict in arr) {
                                    lineModel *model = [lineModel mj_objectWithKeyValues:dict];
                                    [dataArr addObject:model];
                                }
                                weakSelf.dataModel.DealAmtStats = [NSArray arrayWithArray:dataArr];
                            }
                        }
                    }
                    
                    if ([data objectForKey:@"DealAmtStatsY"]) {
                        id DealAmtStatsArr = [data objectForKey:@"DealAmtStatsY"];
                        if ([DealAmtStatsArr isKindOfClass:[NSArray class]]) {
                            NSArray *arr = (NSArray *)DealAmtStatsArr;
                            if (arr.count) {
                               
                                weakSelf.dataModel.DealAmtStatsY = [NSArray arrayWithArray:arr];
                            }
                        }
                    }
                    
                    if ([data objectForKey:@"Ent"]) {
                        id EntDic = [data objectForKey:@"Ent"];
                        if ([EntDic isKindOfClass:[NSDictionary class]]) {
                            NSDictionary *dict = (NSDictionary *)EntDic;
                            weakSelf.dataModel.entmodel = [Ent mj_objectWithKeyValues:dict];
                        }
                    }
                    
                    if ([data objectForKey:@"EntCapitalStats"]) {
                        id EntCapitalStatsArr = [data objectForKey:@"EntCapitalStats"];
                        if ([EntCapitalStatsArr isKindOfClass:[NSArray class]]) {
                            NSArray *arr = (NSArray *)EntCapitalStatsArr;
                            NSMutableArray *dataArr = [NSMutableArray array];
                            if (arr.count) {
                                for (NSDictionary *dict in arr) {
                                    zibenfenbu *model = [zibenfenbu mj_objectWithKeyValues:dict];
                                    [dataArr addObject:model];
                                }
                                weakSelf.dataModel.EntCapitalStats = [NSArray arrayWithArray:dataArr];
                            }
                        }
                    }
                    if ([data objectForKey:@"Proj"]) {
                        id Projd = [data objectForKey:@"Proj"];
                        if ([Projd isKindOfClass:[NSDictionary class]]) {
                            NSDictionary *dict = (NSDictionary *)Projd;
                            weakSelf.dataModel.projModel = [Proj mj_objectWithKeyValues:dict];
                        }
                    }
                    
                    if ([data objectForKey:@"ProjPeriod"]) {
                        id ProjPeriodArr = [data objectForKey:@"ProjPeriod"];
                        if ([ProjPeriodArr isKindOfClass:[NSArray class]]) {
                            NSArray *arr = (NSArray *)ProjPeriodArr;
                            NSMutableArray *dataArr = [NSMutableArray array];
                            if (arr.count) {
                                for (NSDictionary *dict in arr) {
                                    xmqxfb *model = [xmqxfb mj_objectWithKeyValues:dict];
                                    [dataArr addObject:model];
                                }
                                weakSelf.dataModel.ProjPeriod = [NSArray arrayWithArray:dataArr];
                            }
                        }
                    }
                    
                    if ([data objectForKey:@"ProjTypeStats"]) {
                        id ProjTypeStatsArr = [data objectForKey:@"ProjTypeStats"];
                        if ([ProjTypeStatsArr isKindOfClass:[NSArray class]]) {
                            NSArray *arr = (NSArray *)ProjTypeStatsArr;
                            NSMutableArray *dataArr = [NSMutableArray array];
                            if (arr.count) {
                                for (NSDictionary *dict in arr) {
                                    xmlxfb *model = [xmlxfb mj_objectWithKeyValues:dict];
                                    [dataArr addObject:model];
                                }
                                weakSelf.dataModel.ProjTypeStats = [NSArray arrayWithArray:dataArr];
                            }
                        }
                    }
                    
                    if ([data objectForKey:@"UserGender"]) {
                        id Projd = [data objectForKey:@"UserGender"];
                        if ([Projd isKindOfClass:[NSDictionary class]]) {
                            NSDictionary *dict = (NSDictionary *)Projd;
                            weakSelf.dataModel.UserGendermodel = [UserGender mj_objectWithKeyValues:dict];
                        }
                    }
                    
                    if ([data objectForKey:@"UserAgeStats"]) {
                        id UserAgeStatsArr = [data objectForKey:@"UserAgeStats"];
                        if ([UserAgeStatsArr isKindOfClass:[NSArray class]]) {
                            NSArray *arr = (NSArray *)UserAgeStatsArr;
                            NSMutableArray *dataArr = [NSMutableArray array];
                            if (arr.count) {
                                for (NSDictionary *dict in arr) {
                                    UserAgeStats *model = [UserAgeStats mj_objectWithKeyValues:dict];
                                    [dataArr addObject:model];
                                }
                                weakSelf.dataModel.UserAgeStats = [NSArray arrayWithArray:dataArr];
                            }
                        }
                    }
                    
                    if ([data objectForKey:@"UserGradeStats"]) {
                        id UserGradeStatsArr = [data objectForKey:@"UserGradeStats"];
                        if ([UserGradeStatsArr isKindOfClass:[NSArray class]]) {
                            NSArray *arr = (NSArray *)UserGradeStatsArr;
                            NSMutableArray *dataArr = [NSMutableArray array];
                            if (arr.count) {
                                for (NSDictionary *dict in arr) {
                                     gradeState*model = [gradeState mj_objectWithKeyValues:dict];
                                    [dataArr addObject:model];
                                }
                                weakSelf.dataModel.UserGradeStats = [NSArray arrayWithArray:dataArr];
                            }
                        }
                    }
                    
                    if ([data objectForKey:@"BidAmtStats"]) {
                        id BidAmtStatsArr = [data objectForKey:@"BidAmtStats"];
                        if ([BidAmtStatsArr isKindOfClass:[NSArray class]]) {
                            NSArray *arr = (NSArray *)BidAmtStatsArr;
                            NSMutableArray *dataArr = [NSMutableArray array];
                            if (arr.count) {
                                for (NSDictionary *dict in arr) {
                                    bideState*model = [bideState mj_objectWithKeyValues:dict];
                                    [dataArr addObject:model];
                                }
                                weakSelf.dataModel.BidAmtStats = [NSArray arrayWithArray:dataArr];
                            }
                        }
                    }
                    
                    NSString *isshowMap = [data objectForKey:@"IsShowMap"];

                    if ([isshowMap integerValue]==0) {
                        
                        if ([data objectForKey:@"IsShowMapUrl"]) {
                            NSString *url = [data objectForKey:@"IsShowMapUrl"];
                            weakSelf.isShowMap = 0;
                            [weakSelf reqestwebDataForTabelWith:url];
                        }
                    }else{
                        weakSelf.isShowMap = 1;
                    }
                    
                    [weakSelf.tableView reloadData];

                }
            }else{

                if ([response.responseObject objectForKey:@"msg"]) {
                    
                    NSString *msgStr = [response.responseObject objectForKey:@"msg"];
                    
                    ShowAutoHideMBProgressHUD(weakSelf.view, msgStr);
                }else{
                    ShowAutoHideMBProgressHUD(weakSelf.view, @"请求数据失败！");
                }
            
            }
            
            [weakSelf.tableView reloadData];
        }else{
            ShowAutoHideMBProgressHUD(weakSelf.view, @"请求网络数据失败");
        }
        
        if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
            self.tableView.tableFooterView = nil;
        }else{
            self.tableView.tableFooterView = self.footView;
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    }];
}

- (void)createTableView{
    
    _tableView = ({
        UITableView *tableview= [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 60) style:(UITableViewStyleGrouped)];
        tableview.backgroundColor = XZColor(249, 249, 249);
        tableview.delegate=self;
        tableview.dataSource=self;
        tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        tableview;
    });
    [self.view addSubview:_tableView];
    
    FMRTPlatformHeaderView *headerview = [[FMRTPlatformHeaderView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 60)];
    self.tableView.tableHeaderView = nil;
    
//    self.tableView.tableFooterView = footView;
    FMWeakSelf;
    self.tableView.mj_header  =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf reqestwebDataForTabel];
    }];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

- (void)registerBtn{
    FMRTRegisterAppController *lovc = [[FMRTRegisterAppController alloc]init];
    [self.navigationController pushViewController:lovc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 7;
    }else{
        return 5;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (!self.dataModel.UserGendermodel && !self.dataModel.UserAgeStats.count &&!self.dataModel.UserGradeStats.count && !self.dataModel.BidAmtStats.count &&!self.isShowMap) {
        return 1;
    }else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            FMRTTopDataCell *cell = [tableView dequeueReusableCellWithIdentifier:FMRTTopDataCellID];
            if (cell == nil) {
                cell = [[FMRTTopDataCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:FMRTTopDataCellID];
            }
            cell.model = self.dataModel.overViewModel;
            return cell;
        }else if (indexPath.row == 1){
            
            FMRTLineChartCell *cell = [[FMRTLineChartCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:FMRTLineChartCellID];
            
            cell.model = self.dataModel;
            return cell;
        }else if (indexPath.row == 2){
            FMRTComDataShowCell *cell = [tableView dequeueReusableCellWithIdentifier:FMRTComDataShowCellID];
            if (cell == nil) {
                cell = [[FMRTComDataShowCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:FMRTComDataShowCellID];
            }
            
            cell.model = self.dataModel.entmodel;
            return cell;
        }else if (indexPath.row == 3){
            FMRTZCZBFBCell *cell = [tableView dequeueReusableCellWithIdentifier:FMRTZCZBFBCellID];
            if (cell == nil) {
                cell = [[FMRTZCZBFBCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:FMRTZCZBFBCellID];
            }
            cell.model = self.dataModel;
            return cell;
        }else if (indexPath.row == 4){
            FMRTchengjiaofenxiCell *cell = [tableView dequeueReusableCellWithIdentifier:FMRTchengjiaofenxiCellID];
            if (cell == nil) {
                cell = [[FMRTchengjiaofenxiCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:FMRTchengjiaofenxiCellID];
            }
            cell.model = self.dataModel.projModel;
            return cell;
        }else if (indexPath.row == 5){
            FMRTProqixianCell *cell = [tableView dequeueReusableCellWithIdentifier:FMRTProqixianCellID];
            if (cell == nil) {
                cell = [[FMRTProqixianCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:FMRTProqixianCellID];
            }
            
            cell.model = self.dataModel;
            return cell;
        }else if (indexPath.row == 6){
            FMRTXMleixingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FMRTXMleixingTableViewCellID];
            if (cell == nil) {
                cell = [[FMRTXMleixingTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:FMRTXMleixingTableViewCellID];
            }
            cell.model = self.dataModel;
            return cell;
        }
        
    }else{
        
        if (indexPath.row == 0) {
            FMRTManWomanCell *cell = [tableView dequeueReusableCellWithIdentifier:FMRTManWomanCellID];
            if (cell == nil) {
                cell = [[FMRTManWomanCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:FMRTManWomanCellID];
            }
            cell.model = self.dataModel.UserGendermodel;
            return cell;
        }else if (indexPath.row == 1){
            FMRTnianlingfenbuCell *cell = [tableView dequeueReusableCellWithIdentifier:FMRTnianlingfenbuCellID];
            if (cell == nil) {
                cell = [[FMRTnianlingfenbuCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:FMRTnianlingfenbuCellID];
            }
            cell.model = self.dataModel;
            return cell;
        }else if (indexPath.row == 2){
            FMRTyonghuleixingCell *cell = [tableView dequeueReusableCellWithIdentifier:FMRTyonghuleixingCellID];
            if (cell == nil) {
                cell = [[FMRTyonghuleixingCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:FMRTyonghuleixingCellID];
            }
            cell.model = self.dataModel;
            return cell;
        }else if (indexPath.row == 3){
            FMRTtouzijinefenbuCell *cell = [tableView dequeueReusableCellWithIdentifier:FMRTtouzijinefenbuCellID];
            if (cell == nil) {
                cell = [[FMRTtouzijinefenbuCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:FMRTtouzijinefenbuCellID];
            }
            cell.model = self.dataModel;
            return cell;
        }else if (indexPath.row == 4){
            
            static NSString *identifier = @"webcell";
            
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            [cell.contentView addSubview:_webView];
            cell.backgroundColor = XZColor(249, 249, 249);
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            UILabel *tzjeLabel = [[UILabel alloc]init];
            tzjeLabel.text = @"投资人地域分布";
            tzjeLabel.font = [UIFont systemFontOfSize:18];
            tzjeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
            [cell.contentView addSubview:tzjeLabel];
            [tzjeLabel makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(cell.contentView.left).offset(25);
                make.top.equalTo(cell.contentView.top).offset(10);
            }];
            
            if (self.isShowMap) {
                [tzjeLabel setHidden:YES];
            }else{
                [tzjeLabel setHidden:NO];
            }
            
            return cell;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0:{
                
                if (self.dataModel.overViewModel) {
//                    return (KProjectScreenWidth - 30)/670*288*3+30+60+80;
                  return  [FMRTTopDataCell hightForTopDataCellWith:self.dataModel.overViewModel] - 140;
                }else{
                    return 0;
                }
                
                break;
            }
            case 1:{
                
                return self.dataModel.DealAmtStats.count?400:0;
                break;
            }
            case 2:{
                
                if (self.dataModel.entmodel) {
                    return [FMRTComDataShowCell heightForCellWithModel:self.dataModel.entmodel];
                }else{
                    return 0;
                }
                break;
            }
            case 3:{
                return self.dataModel.EntCapitalStats.count ? (KProjectScreenWidth - 30):0;
                break;
            }
            case 4:{
                
                if (self.dataModel.projModel) {
                    return KProjectScreenWidth -30;

                }else{
                    return 0;
                }
                break;
            }
            case 5:{
                return self.dataModel.ProjPeriod.count ? (KProjectScreenWidth -50):0;
                break;
            }
            case 6:{
                return self.dataModel.ProjTypeStats.count ? (KProjectScreenWidth -50):0;
                break;
            }
            default:
                break;
        }
        
    }else{
        
        if (indexPath.row == 0) {
            if (self.dataModel.UserGendermodel) {
                return 320;
            }else{
                return 0;
            }
            
        }else if(indexPath.row == 1){
            return self.dataModel.UserAgeStats.count ? 360:0;
        }else if (indexPath.row == 2){
            return self.dataModel.UserGradeStats.count ? (KProjectScreenWidth - 60):0;
        }else if (indexPath.row == 3){
            return self.dataModel.BidAmtStats.count ? (KProjectScreenWidth - 60):0;
        }else if (indexPath.row == 4){
            
            if (self.isShowMap) {
                return 0;
            }else{
                return _webView.frame.size.height + 60;
            }
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        UIView *view = [[UIView alloc]init];
        UILabel *tzrLabel = [[UILabel alloc]init];
        tzrLabel.text = @"投资人情况";
        tzrLabel.font = [UIFont systemFontOfSize:25];
        tzrLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        [view addSubview:tzrLabel];
        [tzrLabel makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(view.centerX);
            make.centerY.equalTo(view.centerY);
        }];
        return view;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 50;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

#pragma mark - UIWebView Delegate Methods
-(void)webViewDidFinishLoad:(UIWebView *)webView{

    CGFloat height = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    
    self.webView.frame = CGRectMake(self.webView.frame.origin.x,self.webView.frame.origin.y, KProjectScreenWidth, height);
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:1]] withRowAnimation:(UITableViewRowAnimationNone)];
}


- (void)dealloc{
    
    self.webView = nil;
    self.webView.delegate = nil;
    self.tableView.delegate = nil;
    self.footView = nil;
    self.tableView = nil;
    self.dataModel = nil;
}

@end
