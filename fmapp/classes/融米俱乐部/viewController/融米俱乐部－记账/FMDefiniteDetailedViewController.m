//
//  FMDefiniteDetailedViewController.m
//  fmapp
//
//  Created by runzhiqiu on 16/6/27.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMDefiniteDetailedViewController.h"
#import "FMDetailTableViewHeaderView.h"
#import "FMAccountDetailCellheader.h"
#import "FMAccountDetailTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "FMKeepAccount.h"
#import "FMSelectAccountModel.h"
#import "NSDate+CategoryPre.h"
#import "FMAccountSelectViewController.h"
#import "FMAcountWriteInViewController.h"

#import "FMMonthAddReduceModel.h"

#import "FMWWWModel.h"
#import "FMAcountWriteInViewController.h"

@interface FMDefiniteDetailedViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) FMKeepAccountDetailHeaderModel * headerModel;
@property (nonatomic, strong) FMSelectAccountEnd * selectModel;


@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) BOOL isAddData;
@end

@implementation FMDefiniteDetailedViewController
static NSString *definiteDetailedViewControllerTableRegister = @"FMDefiniteDetailedViewControllerTableView";
static NSString *definiteDetailedViewControllerTableSectionHeader = @"FMDefiniteDetailedTableViewSectionHeader";

-(void)setOriginModel:(FMMonthAddReduceModel *)originModel
{
    _originModel = originModel;
    
}

-(FMKeepAccountDetailHeaderModel *)headerModel
{
    if (!_headerModel) {
        _headerModel = [[FMKeepAccountDetailHeaderModel alloc]init];
        if (!self.originModel) {
            _headerModel.dataTime = [[NSDate date] turnToThisDateYearAndmonthWithFormat];
            
        }else
        {
            _headerModel.dataTime = [self.originModel.month stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
        }
        
    }
    return _headerModel;
}

-(FMSelectAccountEnd *)selectModel
{
    if (!_selectModel) {
        _selectModel = [[FMSelectAccountEnd alloc]init];
        _selectModel.grade = 8;
        
    }
    return _selectModel;
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
        
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 1;
    [self settingNavTitle:@"明细"];
    [self createUINavigationRight];
    [self createUItableView];
    
    
    [self selectModelChangeAndGetnetWork];
    // Do any additional setup after loading the view.
}

-(void)createUINavigationRight
{
    
    UIButton * searchButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"搜索图标Map"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(adsActivitybuttonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * searchBar = [[UIBarButtonItem alloc]initWithCustomView:searchButton];
    
    self.navigationItem.rightBarButtonItem = searchBar;
    
}
-(void)adsActivitybuttonOnClick:(UIButton *)button
{
    FMAccountSelectViewController * select = [[FMAccountSelectViewController alloc]init];
    __weak __typeof(&*self)weakSelf = self;
    select.selectModelBlock = ^(FMSelectAccountEnd * selectAccount){
        weakSelf.selectModel = selectAccount;
        if (selectAccount.firstTime&&selectAccount.endTime) {
            FMDetailTableViewHeaderView * headerView = (FMDetailTableViewHeaderView *)weakSelf.tableView.tableHeaderView;
            NSString * title = [NSString stringWithFormat:@"%@ —— %@",selectAccount.firstTime,selectAccount.endTime];
            FMKeepAccountDetailHeaderModel * headerModel = headerView.headerModel;
            headerModel.dataTime =title;
            headerView.headerModel = headerModel;
        }
        else
        {
            
            FMDetailTableViewHeaderView * headerView = (FMDetailTableViewHeaderView *)weakSelf.tableView.tableHeaderView;
            FMKeepAccountDetailHeaderModel * headerModel = headerView.headerModel;
            headerModel.dataTime =  [[NSDate date] turnToThisDateYearAndmonthWithFormat];
            headerView.headerModel = headerModel;
            weakSelf.selectModel.grade = 8;
            

        }
        self.isAddData = NO;
        self.currentPage = 1;
        [weakSelf selectModelChangeAndGetnetWork];
    };
    
    //    select.currentSelectModel = self.selectModel;
    select.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:select animated:YES];
}
-(void)selectModelChangeAndGetnetWork
{
    if (self.selectModel) {
        //获取网络请求
        int timestamp = [[NSDate date]timeIntervalSince1970];
        NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=jizhang&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
        NSString *tokenlow=[token lowercaseString];
        
        NSMutableDictionary * paras = [[NSMutableDictionary alloc]init];
        
        [paras setValue:@"jizhang" forKey:@"appid"];
        [paras setValue:[CurrentUserInformation sharedCurrentUserInfo].userId forKey:@"user_id"];
        [paras setValue:[NSNumber numberWithInt:timestamp] forKey:@"shijian"];
        [paras setValue:tokenlow forKey:@"token"];
        [paras setValue:[NSNumber numberWithInteger:self.currentPage] forKey:@"page"];
        
        NSString  * url = @"https://www.rongtuojinrong.com/rongtuoxinsoc/jizhangbill/detailapp";
        FMDetailTableViewHeaderView * headerView = (FMDetailTableViewHeaderView *)self.tableView.tableHeaderView;
        FMKeepAccountDetailHeaderModel * headerModel = headerView.headerModel;
        if (headerModel.dataTime.length > 8) {
            if (self.selectModel.firstTime) {
                
                [paras setValue:self.selectModel.firstTime forKey:@"dateStart"];
            }
            if (self.selectModel.endTime) {
                
                [paras setValue:self.selectModel.endTime forKey:@"dateEnd"];
            }
            
        }else
        {
            if (self.selectModel.grade == 100) {
                
            }else
            {
                [paras setValue:headerModel.dataTime forKey:@"riqi"];
            }
            
        }
        
        if (self.selectModel.firstMoney) {
            
            [paras setValue:self.selectModel.firstMoney forKey:@"moneyStart"];
        }
        if (self.selectModel.endMoney) {
            
            [paras setValue:self.selectModel.endMoney forKey:@"moneyEnd"];
        }
        
        if (self.selectModel.rangeModel) {
            //accountType   一共有四种类型：1全部  2支出  3收入  4借贷
            [paras setValue:[NSString stringWithFormat:@"%zi",[self.selectModel.rangeModel.title_id integerValue]] forKey:@"accountType"];
        }
        
        if (self.selectModel.keyString) {
            
            [paras setValue:self.selectModel.keyString forKey:@"keyString"];
        }
        
        [self getDataSourceFromNetWorkWithUrl:url WithParameters:paras];
        
        
        
    }
}
-(void)getDataSourceFromNetWorkWithUrl:(NSString *)url WithParameters:(NSDictionary *)parameters
{
 
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [FMHTTPClient postPath:url parameters:parameters completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if (response.code == WebAPIResponseCodeSuccess) {
            
            NSDictionary * data = response.responseObject[@"data"];
            /**
             创建headerModel  头部header数据
             */
            
            if (!(self.currentPage > 1)) {
                
                if (data[@"currrentMonthExpend"]) {
                    self.headerModel.rightBottomMoney = [NSString stringWithFormat:@"%@",data[@"currrentMonthExpend"]];
                    if ([self.headerModel.rightBottomMoney isMemberOfClass:[NSNull class]]) {
                        self.headerModel.rightBottomMoney = @"0.00";
                    }
                }
                if (data[@"currrentMonthExpend"]) {
                    self.headerModel.leftBottomMoney = [NSString stringWithFormat:@"%@",data[@"currrentMonthIncome"]];
                    if ([self.headerModel.leftBottomMoney isMemberOfClass:[NSNull class]]) {
                        self.headerModel.leftBottomMoney = @"0.00";
                    }
                }
                [self getHeaderModelAndSetTableViewHeader:self.headerModel];
            }
            
            
            /**
             创建tableView数据
             */
            NSArray * acountOfAllArr  = data[@"acountOfAllArr"];
            
            
            if (!self.isAddData) {
                [self.dataSource removeAllObjects];
            }else
            {
                self.isAddData = NO;
            }
            
            
            for (NSDictionary * dayWithDict in acountOfAllArr) {
                FMKeepAccount * account1 = [[FMKeepAccount alloc]init];
                [account1 setUpKeepAccountDataWithDictionary:dayWithDict];
                [self.dataSource addObject:account1];
            }
            [self.tableView reloadData];
            
            
        }else if(response.code == WebAPIResponseCodeFailed)
        {
            ShowAutoHideMBProgressHUD(self.view, response.responseObject[@"msg"]);
        }else{
            ShowAutoHideMBProgressHUD(self.view, @"网络获取失败");
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

-(void)getHeaderModelAndSetTableViewHeader:(FMKeepAccountDetailHeaderModel *)headerModel
{
    if (headerModel) {
        FMDetailTableViewHeaderView * headerView = (FMDetailTableViewHeaderView *)self.tableView.tableHeaderView;
        headerView.headerModel = headerModel;
    }
}

-(void)createUItableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, self.view.frame.size.height - 44 - 49) style:UITableViewStyleGrouped];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[FMAccountDetailTableViewCell class] forCellReuseIdentifier:definiteDetailedViewControllerTableRegister];
    //初步预测cell高度
    [self.view addSubview:self.tableView];
    
    FMDetailTableViewHeaderView * headerView = [[FMDetailTableViewHeaderView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 100)];
    headerView.buttonBlock = ^(FMDetailTableViewHeaderViewButtonType type)
    {
        [self headerViewButtonOnCLick:type];
    };
    headerView.headerModel = self.headerModel;
    
    self.tableView.tableHeaderView = headerView;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPage = 1;
        _isAddData = NO;
        [self selectModelChangeAndGetnetWork];
    }];
    self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        _currentPage = _currentPage + 1;
        _isAddData = YES;
        [self selectModelChangeAndGetnetWork];
    }];
    
    
    [self createBottomView];
}
-(void)createBottomView
{
    UIButton * bottom = [[UIButton alloc]init];
    [self.view addSubview:bottom];
    
    [bottom makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@49);

    }];
    
    [bottom addTarget:self action:@selector(bottomButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    bottom.backgroundColor = [HXColor colorWithHexString:@"#0d428d"];
    [bottom setTitle:@"记一笔" forState:UIControlStateNormal];
    [bottom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
   
    
}
-(void)bottomButtonOnClick:(UIButton *)button
{
    FMAcountWriteInViewController * write = [[FMAcountWriteInViewController
                                              alloc]init];
    
    [self.navigationController pushViewController:write animated:YES];
}
-(void)headerViewButtonOnCLick:(FMDetailTableViewHeaderViewButtonType)type
{
    switch (type) {
        case FMDetailTableViewHeaderViewButtonTypeDataTime:
        {
            
        }
            break;
        case FMDetailTableViewHeaderViewButtonTypeDataTimeLeft:
        {
            [self reduceDateWithButton];
            FMDetailTableViewHeaderView * headerView = (FMDetailTableViewHeaderView *)self.tableView.tableHeaderView;
            NSString * title;
            if (self.selectModel.grade == 8) {
                title = [NSString stringWithFormat:@"%@",self.selectModel.firstTime];
            }else
            {
                title = [NSString stringWithFormat:@"%@ —— %@",self.selectModel.firstTime,self.selectModel.endTime];
            }
            headerView.headerModel.dataTime =title;
            FMKeepAccountDetailHeaderModel * headerModel = headerView.headerModel;
            headerModel.dataTime =title;
            headerView.headerModel = headerModel;
            self.currentPage = 1;
            [self selectModelChangeAndGetnetWork];
        }
            break;
        case FMDetailTableViewHeaderViewButtonTypeDataTimeRight:
        {
            [self addDateWithButton];
            FMDetailTableViewHeaderView * headerView = (FMDetailTableViewHeaderView *)self.tableView.tableHeaderView;
            NSString * title;
            if (self.selectModel.grade == 8) {
                title = [NSString stringWithFormat:@"%@",self.selectModel.firstTime];
            }else
            {
                title = [NSString stringWithFormat:@"%@ —— %@",self.selectModel.firstTime,self.selectModel.endTime];
            }
            headerView.headerModel.dataTime =title;
            FMKeepAccountDetailHeaderModel * headerModel = headerView.headerModel;
            headerModel.dataTime =title;
            headerView.headerModel = headerModel;
            self.currentPage = 1;
            [self selectModelChangeAndGetnetWork];
        }
            break;
        case FMDetailTableViewHeaderViewButtonTypeLeftBottom:
        {
            
        }
            break;
        case FMDetailTableViewHeaderViewButtonTypeRightBottom:
        {
            
        }
            break;
            
        default:
            break;
    }
}
-(void)reduceDateWithButton
{
    if (self.selectModel) {
        switch (self.selectModel.grade) {
            case 0:
            {
                //0为天
                NSDate * dateLinshi = [NSDate date];
                self.selectModel.firstTime = [dateLinshi getLastDayWithDayString:self.selectModel.firstTime];
                self.selectModel.endTime = [dateLinshi getLastDayWithDayString:self.selectModel.endTime];
            }
                break;
            case 1:
            {
                NSDate * dateLinshi = [NSDate date];
                NSArray * dateArray = [dateLinshi getLastWeekWithDayString:self.selectModel.firstTime];
                self.selectModel.firstTime = dateArray[0];
                self.selectModel.endTime = dateArray[1];
            }
                break;
            case 2:
            {
                NSDate * dateLinshi = [NSDate date];
                NSArray * dateArray = [dateLinshi getLastMonthWithDayString:self.selectModel.firstTime];
                self.selectModel.firstTime = dateArray[0];
                self.selectModel.endTime = dateArray[1];
            }
                break;
            case 3:
            {
                //3为三个月
                NSDate * dateLinshi = [NSDate date];
                NSArray * dateArray = [dateLinshi getLastThreeMonthWithDayString:self.selectModel.firstTime];
                self.selectModel.firstTime = dateArray[0];
                self.selectModel.endTime = dateArray[1];
            }
                break;
            case 4:
            {
                NSDate * dateLinshi = [NSDate date];
                NSArray * dateArray = [dateLinshi retlastQuarterFirstDayAndEndDayWithStringDate:self.selectModel.firstTime];
                self.selectModel.firstTime = dateArray[0];
                self.selectModel.endTime = dateArray[1];
            }
                break;
            case 5:
            {
                NSDate * dateLinshi = [NSDate date];
                NSArray * dateArray = [dateLinshi retlastYearFirstDayAndEndDayWithStringDate:self.selectModel.firstTime];
                self.selectModel.firstTime = dateArray[0];
                self.selectModel.endTime = dateArray[1];
            }
                break;
            case 6:
            {
                //6为7天
                NSDate * dateLinshi = [NSDate date];
                NSArray * dateArray = [dateLinshi getLastSevenDayWithDayString:self.selectModel.firstTime];
                self.selectModel.firstTime = dateArray[0];
                self.selectModel.endTime = dateArray[1];
            }
                break;
            case 7:
            {
                NSDate * dateLinshi = [NSDate date];
                NSArray * dateArray = [dateLinshi getLastTwentyDayWithDayString:self.selectModel.firstTime];
                self.selectModel.firstTime = dateArray[0];
                self.selectModel.endTime = dateArray[1];
            }
                break;
                
            case 8:
            {
                if (!self.selectModel.firstTime) {
                    [self getDetailTableViewHeaderViewInfo];
                }
                if (self.selectModel.firstTime.length > 7) {
                    self.selectModel.firstTime = [[NSDate date] retCurrentdateWithYYYY_MM];
                    self.selectModel.endTime = self.selectModel.endTime;
                    return;
                }
                NSDate * date = [NSDate retNSStringToNSdateWithYYYY_MM:self.selectModel.firstTime];
                self.selectModel.firstTime = [[date lastMonth] retCurrentdateWithYYYY_MM];
                self.selectModel.endTime = self.selectModel.endTime;
                
            }
                break;
            case 10:
            {
                if (!self.selectModel.firstTime) {
                    [self getDetailTableViewHeaderViewInfo];
                }
                if (self.selectModel.firstTime.length > 7) {
                    self.selectModel.firstTime = [[NSDate date] retCurrentdateWithYYYY_MM];
                    self.selectModel.endTime = self.selectModel.endTime;
                    return;
                }
                NSDate * date = [NSDate retNSStringToNSdateWithYYYY_MM:self.selectModel.firstTime];
                self.selectModel.firstTime = [[date lastMonth] retCurrentdateWithYYYY_MM];
                self.selectModel.endTime = self.selectModel.endTime;
            }
                break;
            default:
                break;
        }
    }
}
-(void)addDateWithButton
{
    if (self.selectModel) {
        switch (self.selectModel.grade) {
            case 0:
            {
                NSDate * dateLinshi = [NSDate date];
                self.selectModel.firstTime = [dateLinshi getNextDayWithDayString:self.selectModel.firstTime];
                self.selectModel.endTime = [dateLinshi getNextDayWithDayString:self.selectModel.endTime];
            }
                break;
            case 1:
            {
                NSDate * dateLinshi = [NSDate date];
                NSArray * dateArray = [dateLinshi getNextWeekWithDayString:self.selectModel.firstTime];
                self.selectModel.firstTime = dateArray[0];
                self.selectModel.endTime = dateArray[1];
            }
                break;
            case 2:
            {
                
                NSDate * dateLinshi = [NSDate date];
                NSArray * dateArray = [dateLinshi getNextMonthWithDayString:self.selectModel.firstTime];
                self.selectModel.firstTime = dateArray[0];
                self.selectModel.endTime = dateArray[1];
            }
                break;
            case 3:
            {
                //3为三个月
                NSDate * dateLinshi = [NSDate date];
                NSArray * dateArray = [dateLinshi getNextThreeMonthWithDayString:self.selectModel.firstTime];
                self.selectModel.firstTime = dateArray[0];
                self.selectModel.endTime = dateArray[1];
            }
                break;
            case 4:
            {
                NSDate * dateLinshi = [NSDate date];
                NSArray * dateArray = [dateLinshi retNextQuarterFirstDayAndEndDayWithStringDate:self.selectModel.firstTime];
                self.selectModel.firstTime = dateArray[0];
                self.selectModel.endTime = dateArray[1];
            }
                break;
            case 5:
            {
                NSDate * dateLinshi = [NSDate date];
                NSArray * dateArray = [dateLinshi retNextYearFirstDayAndEndDayWithStringDate:self.selectModel.firstTime];
                self.selectModel.firstTime = dateArray[0];
                self.selectModel.endTime = dateArray[1];
            }
                break;
            case 6:
            {
                //6为7天
                NSDate * dateLinshi = [NSDate date];
                NSArray * dateArray = [dateLinshi getNextSevenDayWithDayString:self.selectModel.firstTime];
                self.selectModel.firstTime = dateArray[0];
                self.selectModel.endTime = dateArray[1];
            }
                break;
            case 7:
            {
                NSDate * dateLinshi = [NSDate date];
                NSArray * dateArray = [dateLinshi getNextTwentyDayWithDayString:self.selectModel.firstTime];
                self.selectModel.firstTime = dateArray[0];
                self.selectModel.endTime = dateArray[1];
            }
                break;
            case 8:
            {
                if (!self.selectModel.firstTime) {
                    [self getDetailTableViewHeaderViewInfo];
                }
                if (self.selectModel.firstTime.length > 7) {
                    self.selectModel.firstTime = [[NSDate date] retCurrentdateWithYYYY_MM];
                    self.selectModel.endTime = self.selectModel.endTime;
                    return;
                }
                NSDate * date = [NSDate retNSStringToNSdateWithYYYY_MM:self.selectModel.firstTime];
                self.selectModel.firstTime = [[date nextMonth] retCurrentdateWithYYYY_MM];
                self.selectModel.endTime = self.selectModel.endTime;
                
            }
                break;
            case 10:
            {
                if (!self.selectModel.firstTime) {
                    
                    [self getDetailTableViewHeaderViewInfo];
                    
                }
                if (self.selectModel.firstTime.length > 7) {
                    self.selectModel.firstTime = [[NSDate date] retCurrentdateWithYYYY_MM];
                    self.selectModel.endTime = self.selectModel.endTime;
                    return;
                }
                NSDate * date = [NSDate retNSStringToNSdateWithYYYY_MM:self.selectModel.firstTime];
                self.selectModel.firstTime = [[date nextMonth] retCurrentdateWithYYYY_MM];
                self.selectModel.endTime = self.selectModel.endTime;
                
            }
                break;
                
            default:
                break;
        }
    }
    
}

-(void)getDetailTableViewHeaderViewInfo
{
    FMDetailTableViewHeaderView * headerView = (FMDetailTableViewHeaderView *)self.tableView.tableHeaderView;
    FMKeepAccountDetailHeaderModel * headerModel = headerView.headerModel;
    self.selectModel.firstTime = headerModel.dataTime;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    FMKeepAccount * account = self.dataSource[section];
    return account.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FMAccountDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:definiteDetailedViewControllerTableRegister];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}
- (void)configureCell:(FMAccountDetailTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    
    FMKeepAccount * account = self.dataSource[indexPath.section];
    
    FMKeepAccountDetailCellModel * cellModel = account.dataSource[indexPath.row];
    cell.model = cellModel;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat heigh = [tableView fd_heightForCellWithIdentifier:definiteDetailedViewControllerTableRegister  configuration:^(FMAccountDetailTableViewCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
    return heigh;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FMAccountDetailCellheader * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:definiteDetailedViewControllerTableSectionHeader];
    if (!header) {
        header = [[FMAccountDetailCellheader alloc]initWithReuseIdentifier:definiteDetailedViewControllerTableSectionHeader];
    }
    
    FMKeepAccount * account = self.dataSource[section];
    
    FMKeepAccountDetailCellSectionHeaderModel * sectionHeader = account.sectionHeader;
    
    header.sectionModel = sectionHeader;
    return header;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 0.5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FMKeepAccount * account = self.dataSource[indexPath.section];
    FMKeepAccountDetailCellModel * cellModel = account.dataSource[indexPath.row];
    
    
    FMWWWModel * wwwModel = [[FMWWWModel alloc]init];
    wwwModel.pid = cellModel.pid;
    wwwModel.money = cellModel.priceLabel;
    wwwModel.type = cellModel.titleLabel;
    wwwModel.bz = cellModel.bz;
    wwwModel.time = cellModel.time;
    wwwModel.personName = cellModel.personName;
    wwwModel.state = cellModel.state;
    
    
    FMAcountWriteInViewController * accountWrite = [[FMAcountWriteInViewController alloc]init];
    accountWrite.hidesBottomBarWhenPushed = YES;
    accountWrite.jumpType = 2;
    accountWrite.acountWriteModel = wwwModel;
    [self.navigationController pushViewController:accountWrite animated:YES];
    
    
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 删除的操作
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteNoteFromTableView:indexPath];
        /**
         *  删除数据需要的操作
         */
        
    }
}
-(void)deleteNoteFromTableView:(NSIndexPath *)indexPath
{
    FMKeepAccount * account = self.dataSource[indexPath.section];
    FMKeepAccountDetailCellModel * cellModel = account.dataSource[indexPath.row];
    
    //获取网络请求
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=jizhang&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString * html = @"https://www.rongtuojinrong.com/rongtuoxinsoc/jizhangbill/deljilu";
    NSDictionary * paras = @{@"appid":@"jizhang",
                             @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                             @"shijian":[NSNumber numberWithInteger:timestamp],
                             @"token":tokenlow,
                             @"pid":cellModel.pid};
    
    [FMHTTPClient postPath:html parameters:paras completion:^(WebAPIResponse *response) {
        if (response.code == WebAPIResponseCodeSuccess) {
            ShowAutoHideMBProgressHUD(self.view, @"删除成功");
            
            [account.dataSource removeObjectAtIndex:indexPath.row];
            NSArray *indexPaths = @[indexPath]; // 构建 索引处的行数 的数组
            // 删除 索引的方法 后面是动画样式
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:(UITableViewRowAnimationLeft)];
        }else if (response.code == WebAPIResponseCodeFailed)
        {
            ShowAutoHideMBProgressHUD(self.view, response.responseObject[@"msg"]);
        }else
        {
            ShowAutoHideMBProgressHUD(self.view, @"删除失败");
        }
    }];
}

#pragma mark - UITableViewDelegate

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 

 
 
 */

@end
