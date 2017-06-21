//
//  FMJionFriendListViewController.m
//  fmapp
//
//  Created by runzhiqiu on 2017/2/23.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMJionFriendListViewController.h"
#import "FMJionFriendListTableViewCell.h"
#import "XMAlertTimeView.h"
#import "NSDate+CategoryPre.h"
#import "ShareViewController.h"
#import "WLFirstPageHeaderViewController.h"
#import "XZActivityModel.h"
#import "XZShareView.h"

@interface FMJionFriendListViewController ()<UITableViewDelegate,UITableViewDataSource,XMAlertTimeViewDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic,copy) NSString *currentDataInterval;

@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) BOOL isAddData;
@property (nonatomic, strong) XZShareView * share;


@end

@implementation FMJionFriendListViewController

static NSString * jionFriendListTableViewCellRegister = @"jionFriendListTableViewCellRegister";

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KProjectScreenWidth, KProjectScreenHeight - 100 - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[FMJionFriendListTableViewCell class] forCellReuseIdentifier:jionFriendListTableViewCellRegister];
        
        _tableView.mj_header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _currentPage = 1;
            _isAddData = NO;
            [self getDataSourceFromNetWork];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _currentPage = _currentPage + 1;
            _isAddData = YES;
            [self getDataSourceFromNetWork];
        }];
        

        [self.view addSubview:_tableView];
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"邀请好友列表"];
    self.currentPage = 1;
    self.isAddData = NO;
    [self setUpHeaderView];
    
    [self getDataSourceFromNetWork];
    
    // Do any additional setup after loading the view.
}

-(void)getDataSourceFromNetWork
{
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    

    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionaryWithObject: [NSNumber numberWithInt:self.currentPage] forKey:@"page"];
    
    
    [parameters setObject:@10 forKey:@"page_size"];

    [parameters setObject:@"huiyuan" forKey:@"AppId"];
    
    [parameters setObject:[CurrentUserInformation sharedCurrentUserInfo].userId forKey:@"UserId"];
    
    [parameters setObject:[NSNumber numberWithInt:timestamp] forKey:@"AppTime"];
    
    [parameters setObject:tokenlow forKey:@"Token"];
    
    if (!self.currentDataInterval) {
        NSDate * dateLinshi = [NSDate date];
        
        NSString * currentString =  [dateLinshi retCurrentdateWithYYYY_MM_DD];
        //NSArray * dateArray = [dateLinshi getLastTwentyDayWithDayStringAndToday:currentString];
        
        self.currentDataInterval = [NSString stringWithFormat:@"%@－%@",@"2014-01-01",currentString];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    

    if (self.currentDataInterval) {
        NSArray *array = [self.currentDataInterval componentsSeparatedByString:@"－"];
        
        if (array.count >=2) {
            
            NSString * firstString = [[array firstObject]  stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSDate * dateTime = [NSDate retNSStringToNSdate:firstString];
            NSInteger interNetDate = [dateTime timeIntervalSince1970];//服务器返回的时间戳；
            [parameters setObject:[NSString stringWithFormat:@"%zi",interNetDate] forKey:@"starttime"];//timestop
            
            
            NSString * secondString = [[array lastObject]  stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSDate * seconddateTime = [NSDate retNSStringToNSdate:secondString];
            NSInteger secondinterNetDate = [seconddateTime timeIntervalSince1970];//服务器返回的时间戳；
            [parameters setObject:[NSString stringWithFormat:@"%zi",secondinterNetDate] forKey:@"endtime"];
            
        }
        
    }
    
    
    
    //NSString * stringMuHtml = kXZUniversalTestUrl(@"ListInvitee");

    NSString * stringMuHtml = kFMPhpUniversalBaseUrl(@"Rongtuoxinsoc/Usercenter/beiyaoqingrenliuer");

    [FMHTTPClient postPath:stringMuHtml parameters:parameters completion:^(WebAPIResponse *response) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (response.code == WebAPIResponseCodeSuccess) {
            NSArray * dict = response.responseObject[@"data"];
            if (!([dict isMemberOfClass:[NSArray class]]||[dict isMemberOfClass:[NSNull class]])) {
                if (_isAddData) {
                    
                    _isAddData = NO;
                }else
                {
                    [self.dataSource removeAllObjects];
                }
                self.tableView.tableHeaderView = nil;
                for (NSDictionary * dataObject in dict) {
                    FMJoinFriendModel * model = [[FMJoinFriendModel
                                                  alloc]init];
                    model.mobile = dataObject[@"shouji"];
                    model.timeString = dataObject[@"shijian"];
                    
                    [self.dataSource addObject:model];
                    
                }
                
                [self.tableView reloadData];
                
            }else
            {
                if (!_isAddData) {
                    self.tableView.tableHeaderView = [self retTableViewHeaderView];
                }
                
            }
            
        }else
        {
            NSString * status =  response.responseObject[@"status"];
            if (![status isMemberOfClass:[NSNull class]]) {
                NSInteger staNum = [status integerValue];
                if (staNum == 1) {
                    ShowAutoHideMBProgressHUD(self.view, response.responseObject[@"msg"]);
                    
                }else
                {
                    ShowAutoHideMBProgressHUD(self.view, @"网络不好，请稍后重试！");
                }
            }else
            {
                ShowAutoHideMBProgressHUD(self.view, @"网络不好，请稍后重试！");
                
            }
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

        
    }];
    

}

-(UILabel *)retTableViewHeaderView
{
    UILabel * mobileLabel = [[UILabel alloc]init];
    mobileLabel.numberOfLines = 1;
    mobileLabel.textAlignment = NSTextAlignmentCenter;
    mobileLabel.font = [UIFont systemFontOfSize:16];
    mobileLabel.textColor = [HXColor colorWithHexString:@"#999999"];
    mobileLabel.text = @"暂无数据";
    mobileLabel.frame = CGRectMake(0, 0, KProjectScreenWidth, 50);
    return mobileLabel;
}

-(void)setUpHeaderView
{
    UIView * headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    
    
    UILabel * leftlabel = [[UILabel alloc]init];
    leftlabel.text = @"好友手机号";
    leftlabel.textAlignment = NSTextAlignmentLeft;
    leftlabel.numberOfLines = 1;
    if (KProjectScreenWidth == 320) {
        leftlabel.font = [UIFont systemFontOfSize:14];

    }else
    {
        leftlabel.font = [UIFont systemFontOfSize:16];

    }
    leftlabel.textColor = [HXColor colorWithHexString:@"#333333"];
    [headerView addSubview:leftlabel];
    
    
    UILabel * rightlabel = [[UILabel alloc]init];
    rightlabel.text = @"首次投资时间";
    leftlabel.textAlignment = NSTextAlignmentRight;
    rightlabel.numberOfLines = 1;
    if (KProjectScreenWidth == 320) {
        rightlabel.font = [UIFont systemFontOfSize:14];

    }else
    {
        rightlabel.font = [UIFont systemFontOfSize:16];

    }
    rightlabel.textColor = [HXColor colorWithHexString:@"#333333"];
    [headerView addSubview:rightlabel];
    
    
    [headerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@42);
    }];
    
    [leftlabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_centerX).offset(-KProjectScreenWidth * 0.25 - 20);
       
        make.centerY.equalTo(headerView.mas_centerY).offset(4);
    }];
    
    [rightlabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_centerX).offset(KProjectScreenWidth * 0.25);
        
        make.centerY.equalTo(headerView.mas_centerY).offset(4);
    }];
    
    UIButton * bottomButton = [[UIButton alloc]init];
    [bottomButton setBackgroundColor:[HXColor colorWithHexString:@"#0f5ed2"]];
    bottomButton.tag = 1001;
    [bottomButton addTarget:self action:@selector(bottomCalenderButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomButton setTitle:@"立即邀请" forState:UIControlStateNormal];
    [bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:bottomButton];
    [bottomButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_bottom).offset(-50);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@50);
    }];
    
    
    UIButton * rightDateButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    bottomButton.tag = 1000;
    [rightDateButton setBackgroundColor:[UIColor clearColor]];
    [rightDateButton addTarget:self action:@selector(rightTopCalenderButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightDateButton setTitle:@"日期" forState:UIControlStateNormal];
    [rightDateButton setTitleColor:[HXColor colorWithHexString:@"#0f5ed2"] forState:UIControlStateNormal];
    
    UIBarButtonItem * rightBar = [[UIBarButtonItem alloc]initWithCustomView:rightDateButton];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left);
        make.right.equalTo(headerView.mas_right);
        make.top.equalTo(headerView.mas_bottom);
        make.bottom.equalTo(bottomButton.mas_top);
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FMJionFriendListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:jionFriendListTableViewCellRegister forIndexPath:indexPath];
    cell.joinModel = self.dataSource[indexPath.row];
    return cell;
}

-(void)bottomCalenderButtonOnClick:(UIButton *)button
{
    
    [self getShareDataSourceFromNetWork];
    
}

-(void)getShareDataSourceFromNetWork{
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"shijian=%d&appid=huiyuan&user_id=%@&qita=suiji",timestamp,[CurrentUserInformation sharedCurrentUserInfo].userId]);
    NSString *tokenlow=[token lowercaseString];
    NSString * shareUrlHtml = kDefaultShareUrlBase;
    
    NSDictionary * parameter = @{@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"leixing":@4
                                 };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    FMWeakSelf;
    [FMHTTPClient postPath:shareUrlHtml parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        if (response.responseObject) {
            if (response.code == WebAPIResponseCodeSuccess) {
                NSDictionary *dic = [response.responseObject objectForKey:@"data"];
                if ([dic objectForKey:@"xiayibu"]) {
                    NSString *xiayibu = [dic objectForKey:@"xiayibu"];
                    if ([xiayibu length] > 5) {
                        FMIndexHeaderModel * headerModel = [FMIndexHeaderModel new];
                        WLFirstPageHeaderViewController *viewController=[[WLFirstPageHeaderViewController alloc]init];
                        viewController.shareURL = [dic objectForKey:@"xiayibu"];
                        viewController.navTitle = [dic objectForKey:@"xiayibutitle"];
                        headerModel.fenxiangbiaoti = [dic objectForKey:@"title"];
                        NSString *url = [dic objectForKey:@"url"];
                        headerModel.fenxianglianjie = [NSString stringWithFormat:@"%@",url];
                        headerModel.fenxiangpic = [dic objectForKey:@"picurl"];
                        headerModel.fenxiangneirong = [dic objectForKey:@"content"];
                        
                        viewController.headerModel = headerModel;
                        viewController.hidesBottomBarWhenPushed=YES;
                        [weakSelf.navigationController pushViewController:viewController animated:YES];
                        
                    }else{
                        XZActivityModel *modelShare  = [[XZActivityModel alloc]init];
                        
                        modelShare.sharetitle = [dic objectForKey:@"title"];
                        NSString *url = [dic objectForKey:@"url"];
                        modelShare.shareurl = [NSString stringWithFormat:@"%@?user_id=%@&appid=%@&shijian=%@&token=%@",url,[CurrentUserInformation sharedCurrentUserInfo].userId,@"huiyuan",[NSNumber numberWithInt:timestamp],tokenlow];
                        
                        modelShare.sharepic = [dic objectForKey:@"picurl"];
                        modelShare.sharecontent = [dic objectForKey:@"content"];
                        weakSelf.share.modelShare = modelShare;
                        
                        [weakSelf.view addSubview:[weakSelf.share retViewWithSelf]];
                    }
                    
                }else{
                    XZActivityModel *modelShare  = [[XZActivityModel alloc]init];
                    
                    modelShare.sharetitle = [dic objectForKey:@"title"];
                    NSString *url = [dic objectForKey:@"url"];
                    modelShare.shareurl = [NSString stringWithFormat:@"%@?user_id=%@&appid=%@&shijian=%@&token=%@",url,[CurrentUserInformation sharedCurrentUserInfo].userId,@"huiyuan",[NSNumber numberWithInt:timestamp],tokenlow];
                    
                    modelShare.sharepic = [dic objectForKey:@"picurl"];
                    modelShare.sharecontent = [dic objectForKey:@"content"];
                    weakSelf.share.modelShare = modelShare;
                    
                    [weakSelf.view addSubview:[weakSelf.share retViewWithSelf]];
                    
                }
                
            }else{
                ShowAutoHideMBProgressHUD(weakSelf.view,@"请求分享数据失败！");
            }
        }else{
            ShowAutoHideMBProgressHUD(weakSelf.view,@"请求网络数据失败！");
        }
    }];
}

- (XZShareView *)share{
    if (!_share) {
        _share = [[XZShareView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight)];
        __weak typeof(self.share)weakShare = self.share;
        __weak typeof(self)weakSelf = self;
        
        _share.blockShareAction = ^(UIButton *button){
            [weakShare shareAction:button handlerDelegate:weakSelf];
        };
    }
    return _share;
}


-(void)rightTopCalenderButtonOnClick:(UIButton *)button
{
    if (!self.currentDataInterval) {
        NSDate * dateLinshi = [NSDate date];
        
        NSString * currentString =  [dateLinshi retCurrentdateWithYYYY_MM_DD];
        NSArray * dateArray = [dateLinshi getLastTwentyDayWithDayStringAndToday:currentString];
        
        self.currentDataInterval = [NSString stringWithFormat:@"%@－%@",dateArray[0],dateArray[1]];
        
        //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    
    XMAlertTimeView * alterView = [[XMAlertTimeView alloc]init];
    alterView.title.text = @"请选择日期";
    alterView.delegate = self;
    
    if (!self.currentDataInterval) {
        [alterView showAlertVeiw];
    }else
    {
        [alterView showAlertVeiwWithAllString:self.currentDataInterval];
        
    }
}


-(void)XMAlertTimeView:(XMAlertTimeView *)alertTimeView WithSelectTime:(NSString *)time;
{
    
    [self.dataSource removeAllObjects];
    self.currentPage = 1;
    self.isAddData = NO;
    [self.tableView reloadData];
    self.currentDataInterval = time;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getDataSourceFromNetWork];
    
    
    
}

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
