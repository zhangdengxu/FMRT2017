//
//  FMTimeKillShopController.m
//  fmapp
//
//  Created by runzhiqiu on 16/8/5.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMTimeKillShopController.h"
#import "FMTimeKillShopDetailController.h"

#import "FMTimeKillTableViewHeaderView.h"
#import "FMTimeKillTableViewFooterView.h"
#import "NSDate+CategoryPre.h"
#import "FMTimeKillTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "FMTimeKillShopModel.h"
#import "FMTimeKillTableViewSectionHeader.h"
#import "FMTimeKillSectionSectionHeader.h"
#import "FMTimeKillCommentCell.h"
#import "FMKillTimeComment.h"
#import "WLPublishSuccessViewController.h"
#import "FMRTAucTool.h"
#import "XZActivityModel.h"
#import "XZPersonalCenterViewController.h"
#import "XZSecondKillViewController.h"
//#import "FMTimeKillShowSelectView.h"
#import "FMButtonStyleModel.h"
#import "FMShopSpecModel.h"
#import "XZConfirmOrderKillViewController.h"
#import "YSEvaluationRulesViewController.h"

#import "WLEvaluateViewController.h"
#import "YSBiddingRulesViewController.h"
#import "YSSpikeRuleViewController.h"
#import "XZAuctionNoticeViewController.h"

#import "FMTimeKillSelectView.h"
#import "AppDelegate.h"

@interface FMTimeKillShopController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * headerDataSource;
@property (nonatomic, strong) FMTimeKillTableViewHeaderView * tableViewHeaderView;
@property (nonatomic, strong) FMTimeKillTableViewFooterView * tableViewFooterView;
@property (nonatomic, strong) FMTimeKillTableViewSectionHeader * sectionFitstHeader;
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) NSMutableArray * commentDataSource;
@property (nonatomic, assign) NSInteger timeCount;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSArray * time_bucket;
@property (nonatomic, strong) NSURLSessionDataTask * dataTask;
//@property (nonatomic, strong) FMTimeKillShowSelectView * showSelect;
@property (nonatomic, strong) FMSelectShopInfoModel * shopDetailModel;



@end

@implementation FMTimeKillShopController

static NSString * FMTimeKillShopTableViewRegister = @"FMTimeKillShopControllerCellRegister" ;
static NSString * FMTimeKillCommentTableViewRegister = @"FMTimeKillCommentControllerCellRegister" ;
static NSString * FMTimeKillShopTableSectionRegister = @"FMTimeKillShopControllerSectionRegister" ;
static NSString * FMTimeKillCommentTableSectionRegister = @"FMTimeKillCommentControllerSectionRegister" ;

/*
-(FMTimeKillShowSelectView *)showSelect{
    if (!_showSelect) {
        _showSelect = ({
            
            FMButtonStyleModel * buttonTwo = [[FMButtonStyleModel alloc]init];
            buttonTwo.title = @"确定";
            buttonTwo.textFont = 15;
            buttonTwo.titleColor = [UIColor whiteColor];
            buttonTwo.backGroundColor = [HXColor colorWithHexString:@"#003d90"];
            buttonTwo.tag = 10011;
            FMTimeKillShowSelectView * showSelect = [[FMTimeKillShowSelectView alloc]initWithReturnButton:@[buttonTwo]];
            
            showSelect.isShowCount = NO;
            showSelect.delegate = self;
            showSelect.selectStyle = FMTimeKillShowSelectViewStyleMiaoSha;
            showSelect;
            
        });
    }
    return _showSelect;
}


*/
-(FMTimeKillTableViewHeaderView *)tableViewHeaderView
{
    if (!_tableViewHeaderView) {
        _tableViewHeaderView = [[FMTimeKillTableViewHeaderView alloc]init];
        
         __weak __typeof(&*self)weakSelf = self;
        
        _tableViewHeaderView.headButtonOnClick = ^(NSInteger index){
            
            [weakSelf continuWithItem:index];
            
        };
        
    }
    return _tableViewHeaderView;
}
-(void)continuWithItem:(NSInteger)index
{
    XZAuctionNoticeViewController *noticeVC =[[XZAuctionNoticeViewController alloc]init];
    noticeVC.flag = @"kill";
    [self.navigationController pushViewController:noticeVC animated:YES];
}

-(FMTimeKillTableViewFooterView *)tableViewFooterView
{
    if (!_tableViewFooterView) {
        _tableViewFooterView = [[FMTimeKillTableViewFooterView alloc]init];
         __weak __typeof(&*self)weakSelf = self;
        _tableViewFooterView.buttonBlock =  ^(NSInteger index)
        {
            [weakSelf buttonOnClick:index];
        };
        
    }
    return _tableViewFooterView;
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
     
        _dataSource = [NSMutableArray array];
  
    }
    return _dataSource;
}
-(NSMutableArray *)commentDataSource
{
    if (!_commentDataSource) {
        
        _commentDataSource = [NSMutableArray array];
        

    }
    return _commentDataSource;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[FMTimeKillTableViewCell class] forCellReuseIdentifier:FMTimeKillShopTableViewRegister];
        
        [_tableView registerClass:[FMTimeKillCommentCell class] forCellReuseIdentifier:FMTimeKillCommentTableViewRegister];
        _tableView.tableHeaderView = self.tableViewHeaderView;
        _tableView.tableFooterView = self.tableViewFooterView;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}
-(void)setUpTimeDate
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(secondTimeReturnDown) userInfo:nil repeats:YES];
    _timer.fireDate = [NSDate distantFuture];
}
-(void)startTimeInView
{
    [_timer setFireDate:[NSDate distantPast]];
}
-(void)pauseTimeInView
{
    [_timer setFireDate:[NSDate distantFuture]];
}



-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    [FMHTTPClient  cancel];
   
}

-(void)dealloc
{
    Log(@"------释放了－－－－");
    [_timer invalidate];
    self.dataTask = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _timer = nil;

}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}

-(void)secondTimeReturnDown
{
    //创建通知
    
    NSNotification *notification =[NSNotification notificationWithName:KDefaultSecondReduceOnce object:nil userInfo:nil];
    
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    [self settingNavTitle:@"限时秒杀"];
     __weak __typeof(&*self)weakSelf = self;
    
    
    
    self.navBackButtonRespondBlock = ^(){
    
        [weakSelf.timer invalidate];
        weakSelf.dataTask = nil;
        
        [[NSNotificationCenter defaultCenter] removeObserver:weakSelf];
        weakSelf.timer = nil;
        [weakSelf.navigationController popViewControllerAnimated:YES];

    };
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(secondReduceOnceWithKillTime:) name:KDefaultSecondReduceOnce object:nil];
    
    [self setUpTimeDate];
    
    
    
    //添加tableview
    [self.view addSubview: self.tableView];
    
    [self setRightButtonItem];
    
    [self getCommentDataSourceFromNetWork];
    
    [self getDataSourceWithHeaderFromNetWork];
    
    
    
   
    
    // Do any additional setup after loading the view.
}


- (void)setRightButtonItem{
    
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightItemButton setFrame:CGRectMake(0, 0, 30, 29)];
    [rightItemButton setBackgroundImage:[UIImage imageNamed:@"新版_分享_36"] forState:UIControlStateNormal];
    [rightItemButton addTarget:self action:@selector(rightButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIButton *memberCenterBtn = [[UIButton alloc]init];
    [memberCenterBtn setBackgroundImage:[UIImage imageNamed:@"个人中心_03_03"] forState:UIControlStateNormal];
    [memberCenterBtn addTarget:self action:@selector(memberCenterAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:memberCenterBtn];
    [self.view bringSubviewToFront:memberCenterBtn];
    [memberCenterBtn makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-15);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@53);
        make.width.equalTo(@50);
    }];
}

-(void)rightButton
{
    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) { // 已登录
        
    }else { // 未登录
        LoginController *registerController = [[LoginController alloc] init];
        FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
        [self.navigationController presentViewController:navController animated:YES completion:^{
        }];
        return;
    }

    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"tel":[CurrentUserInformation sharedCurrentUserInfo].mobile,
                                 @"flag":@"kill"};
    
    
    NSString *testurl =[NSString stringWithFormat:@"%@/public/other/getShareInfo",kXZTestEnvironment];
    

    
    //@"https://www.rongtuojinrong.com/java/public/other/getShareInfo"
    
    [FMHTTPClient postPath:testurl parameters:parameter completion:^(WebAPIResponse *response) {
        
        if (response.code==WebAPIResponseCodeSuccess) {
            
            NSDictionary * objectDic = [response.responseObject objectForKey:@"data"];
            
            FMRTAuctionShareModel *model = [[FMRTAuctionShareModel alloc]init];
            [model setValuesForKeysWithDictionary:objectDic];
            
            WLPublishSuccessViewController *shareVC = [WLPublishSuccessViewController new];
            shareVC.tag = @"kill";
            XZActivityModel *m = [XZActivityModel new];
            m.sharetitle = model.title;
            m.sharepic = model.img;
            m.shareurl = [NSString stringWithFormat:@"%@?appid=huiyuan&token=%@&shijian=%@&user_id=%@&flag=%@",model.link,tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId,@"1"];

//            m.shareurl = @"https://www.rongtuojinrong.com/rongtuoxinsoc/helpzhongxin/ceshilinshi";
            m.sharecontent = model.content;
            shareVC.modelActivity = m;
            [self.navigationController pushViewController:shareVC animated:YES];
            
        }else{
            ShowAutoHideMBProgressHUD(self.view, @"数据请求失败");
        }
    }];
}

- (void)memberCenterAction{
    
    
    
    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) { // 已登录
        
    }else { // 未登录
        LoginController *registerController = [[LoginController alloc] init];
        FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
        [self.navigationController presentViewController:navController animated:YES completion:^{
        }];
        return;
    }

    
    XZPersonalCenterViewController *centerVC = [[XZPersonalCenterViewController alloc]init];
    centerVC.flag = @"kill";
    [self.navigationController pushViewController:centerVC animated:YES];
}


-(void)getCommentDataSourceFromNetWork
{
    
    
    NSDictionary * paras;
    
    int timestamp = [[NSDate date]timeIntervalSince1970];

    
    
    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) { // 已登录
        NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
        
        paras = @{@"appid":@"huiyuan",
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":[token lowercaseString],
                                 @"tel":[CurrentUserInformation sharedCurrentUserInfo].mobile,
                                 @"page":[NSNumber numberWithInteger:self.page]};
        
    }else { // 未登录
        NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",@"0",timestamp]);
        paras = @{@"appid":@"huiyuan",
                  @"user_id":@"0",
                  @"shijian":[NSNumber numberWithInt:timestamp],
                  @"token":[token lowercaseString],
                  @"page":[NSNumber numberWithInteger:self.page]};
    }

    
    NSString *urlStr =[NSString stringWithFormat:@"%@/public/comment/getCommentList",kXZTestEnvironment];
    
    
    /**
     *  秒杀评论借口
     */
    //@"https://www.rongtuojinrong.com/java/public/comment/getCommentList"
    
    [FMHTTPClient postPath:urlStr parameters:paras completion:^(WebAPIResponse *response) {
        
        if (response.code == WebAPIResponseCodeSuccess) {
            NSArray * data = response.responseObject[@"data"];
            if (data.count > 0) {
                for (NSDictionary * dict in data) {
                    FMKillTimeComment * comment = [[FMKillTimeComment alloc]init];
                    [comment setValuesForKeysWithDictionary:dict];
                    [self.commentDataSource addObject:comment];
                }
                [self.tableView reloadData];
            }else
            {
                FMTimeKillTableViewFooterView * footView = (FMTimeKillTableViewFooterView *)self.tableView.tableFooterView;
                [footView changeBottomTitle];
            }
            
           
        }
        
        
    }];
    

}
-(void)getDataSourceWithHeaderFromNetWork
{
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSDictionary * paras;
    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) { // 已登录
        
        NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
        
        paras = @{@"appid":@"huiyuan",
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":[token lowercaseString],
                                 @"tel":[CurrentUserInformation sharedCurrentUserInfo].mobile};
        
    }else { // 未登录
        
        NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",@"0",timestamp]);
        
        paras = @{@"appid":@"huiyuan",
                  @"user_id":@"0",
                  @"shijian":[NSNumber numberWithInt:timestamp],
                  @"token":[token lowercaseString]
                  };
    }
    NSString *testurl =[NSString stringWithFormat:@"%@/public/show/getKillPageInfo",kXZTestEnvironment];
    

    
    [FMHTTPClient postPath:testurl parameters:paras completion:^(WebAPIResponse *response) {
        
        if (response.code == WebAPIResponseCodeSuccess) {
             NSDictionary * dataAll = response.responseObject[@"data"];
            [self changeTableViewHeaderData:dataAll[@"banner"] Withscrolling_message:dataAll[@"scrolling_message"]];
            
            NSArray * time_bucket = dataAll[@"time_bucket"];
            //创建开始时间model
            if (![self.time_bucket isMemberOfClass:[NSNull class]]) {
                
               
                self.time_bucket = time_bucket;
                
                if (time_bucket.count > 0) {
                    
//                     NSString * headString = [[NSDate date] retCurrentdateWithYYYYMMDD];
//                    NSString * timeString = self.time_bucket[0];
//                    NSString * endString = [timeString stringByReplacingOccurrencesOfString:@":" withString:@""];
                    
                    [self.tableView reloadData];
                    
                    
                    
                }
            }
        }
        
    }];
    
    
}

-(void)getDataSourceFromNetWorkWithString:(NSString *)date WithPart:(NSString *)part
{
    int timestamp = [[NSDate date]timeIntervalSince1970];
    
    NSDictionary * paras ;
    
    
    
    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) { // 已登录
        
        NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);

        
        paras = @{@"appid":@"huiyuan",
                    @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                    @"shijian":[NSNumber numberWithInt:timestamp],
                    @"token":[token lowercaseString],
                    @"tel":[CurrentUserInformation sharedCurrentUserInfo].mobile,
                    @"date":date,
                    @"part":part};
        
    }else { // 未登录
        
        NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",@"0",timestamp]);

        
        paras= @{@"appid":@"huiyuan",
                 @"user_id":@"0",
                 @"shijian":[NSNumber numberWithInt:timestamp],
                 @"token":[token lowercaseString],
                 @"date":date,
                 @"part":part};
    }
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    
    
    NSString *urlStr =[NSString stringWithFormat:@"%@/public/show/getKillsList",kXZTestEnvironment];
    
    
    /**
     *  获取秒杀界面相关信息
     */
    //@"https://www.rongtuojinrong.com/java/public/show/getKillsList"
    
    
    [FMHTTPClient postPath:urlStr parameters:paras completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (response.code == WebAPIResponseCodeSuccess) {
            [self pauseTimeInView];
            NSDictionary * dataAll = response.responseObject[@"data"];
            
            NSArray * kills = dataAll[@"kills"];
            
            [self.dataSource removeAllObjects];
            
            for (NSDictionary * killDict in kills) {
                FMTimeKillShopModel * killShop = [[FMTimeKillShopModel alloc]init];
                [killShop setValuesForKeysWithDictionary:killDict];
                [killShop changeBaseCount];
                killShop.activity_state_button = [NSString stringWithFormat:@"%@",killShop.activity_state];
                [self.dataSource addObject:killShop];
            }
            
            
            
            [self.tableView reloadData];
            [self startTimeInView];
            
        }else if (response.code == WebAPIResponseCodeFailed)
        {
            
        }else
        {
            
        }
    }];
}



-(void)changeTableViewHeaderData:(NSArray *)banner Withscrolling_message:(NSArray *)message
{
    [self.tableViewHeaderView changeTableViewHeaderData:banner Withscrolling_message:message];
}



//秒数减少了
-(void)secondReduceOnceWithKillTime:(NSNotification *)notification
{
    self.timeCount ++;
    
    [self continuWithDataSource];
    
    if (self.timeCount % 5 == 0) {
        //重新请求数据，刷新界面
        
        [self replaceGetTimeKillShop];
    }
    
}
-(void)replaceGetTimeKillShop
{
    [self.dataTask cancel];
    
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    
    NSDictionary * paras ;
    
    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) { // 已登录
        
        NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
        
        
        paras = @{@"appid":@"huiyuan",
                  @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                  @"shijian":[NSNumber numberWithInt:timestamp],
                  @"token":[token lowercaseString],
                  @"tel":[CurrentUserInformation sharedCurrentUserInfo].mobile};
        
    }else { // 未登录
        
        NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",@"0",timestamp]);
        
        
        paras = @{@"appid":@"huiyuan",
                  @"user_id":@"0",
                  @"shijian":[NSNumber numberWithInt:timestamp],
                  @"token":[token lowercaseString],
                  };
    }
    
    NSString *urlStr =[NSString stringWithFormat:@"%@/public/show/getProductBlance",kXZTestEnvironment];
    
    
    /**
     *  重复获取秒杀界面的商品数量
     */
    //@"https://www.rongtuojinrong.com/java/public/show/getProductBlance"
    
   self.dataTask = [FMHTTPClient postReturnPath:urlStr parameters:paras completion:^(WebAPIResponse *response) {
       
       NSArray * data = response.responseObject[@"data"];
//       NSLog(@"%@====",data);
       for (NSDictionary * dict in data) {
           FMTimeKillShopSectionRefreshModel * model = [[FMTimeKillShopSectionRefreshModel alloc]init];
           [model setValuesForKeysWithDictionary:dict];
           for (FMTimeKillShopModel * shopModel in self.dataSource) {
               if ([shopModel.kill_id integerValue] == [model.kill_id integerValue]) {
                   shopModel.online_num = model.online_num;
                   shopModel.activity_state = model.activity_state;
               }
           }
       }
       

       
       
   }];
}

-(void)continuWithDataSource
{
    
    for (NSInteger i=0; i < self.dataSource.count; i++) {
        
        FMTimeKillShopModel * killModel = self.dataSource[i];
        killModel.baseCount --;
        NSInteger currentTime = killModel.baseCount;
        if (currentTime < 0) {
            //已经开始
            NSInteger timeContinue = killModel.toEndTime + currentTime;
            
            if (timeContinue < 0) {
                //已结束
                if ([killModel.activity_state_button isEqualToString:@"2"]) {
                    killModel.activity_state_button = @"3";
                }
                
            }else
            {
                //进行中
                if ([killModel.activity_state_button isEqualToString:@"1"]) {
                    killModel.activity_state_button = @"2";
                    
                }
                
                NSInteger shopNumber = [killModel.online_num integerValue];
                    if (shopNumber <= 0) {
                        //进行中,库存变0了。
                        if ([killModel.activity_state_button isEqualToString:@"2"]) {
                            killModel.activity_state_button = @"3";
                        }
                    }
                }
        }else
        {
            if (![killModel.activity_state_button isEqualToString:@"1"]) {
                killModel.activity_state_button = @"1";
            }
        }


    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.dataSource.count;
    }else
    {
        return self.commentDataSource.count;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        FMTimeKillShopModel * killModel = self.dataSource[indexPath.row];
        
        
        FMTimeKillShopDetailController * shopdetail = [[FMTimeKillShopDetailController
                                                        alloc]init];
        shopdetail.hidesBottomBarWhenPushed = YES;
        shopdetail.shopDetailStyle = FMTimeKillShopDetailControllerStyleMiaoSha;
        NSString * htmlUrl = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/product/index_client/%@.html",killModel.product_id];
        
        shopdetail.activity_state = killModel.activity_state;
        
        shopdetail.detailURL = htmlUrl;
        shopdetail.killPrice = killModel.sale_price;
        shopdetail.actionFlag = killModel.kill_id;
        if (killModel.product_id) {
            shopdetail.product_id = killModel.product_id;
        }
        [self.navigationController pushViewController:shopdetail animated:YES];

        
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        FMTimeKillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FMTimeKillShopTableViewRegister forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        return cell;
    }else if (indexPath.section == 1)
    {
        FMTimeKillCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:FMTimeKillCommentTableViewRegister forIndexPath:indexPath];
        [self configureCellTwo:cell atIndexPath:indexPath];
        return cell;
    }else
    {
        return nil;
    }
   
}


- (void)configureCell:(FMTimeKillTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    
    FMTimeKillShopModel * killModel = self.dataSource[indexPath.row];
    cell.timeKillButton = ^(FMTimeKillShopModel * shopModel){
         __weak __typeof(&*self)weakSelf = self;
        [weakSelf changeViewController:shopModel];
    
    };
    cell.model = killModel;
    
}
-(void)changeViewController:(FMTimeKillShopModel *)shopModel
{
    
    
    
    
    if ([shopModel.activity_state isEqualToString:@"3"]) {
        XZSecondKillViewController * second = [[XZSecondKillViewController alloc]init];
        second.flag = @"kill";
        second.activity_id = shopModel.kill_id;
        second.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:second animated:YES];
    }else if ([shopModel.activity_state isEqualToString:@"2"])
    {
        self.shopDetailModel.sale_price = shopModel.sale_price;
        
//        if ([self.shopDetailModel.kill_id integerValue] == [shopModel.kill_id integerValue]) {
//            
//            [self.showSelect setShopDetailModelWithModel:self.shopDetailModel];
//        }else
//        {
        
            FMSelectShopInfoModel * shopDetailModel = [[FMSelectShopInfoModel alloc]init];
            shopDetailModel.kill_id = shopModel.kill_id;
            shopDetailModel.product_id = [NSString stringWithFormat:@"%@",shopModel.product_id];
            shopDetailModel.sale_price = shopModel.sale_price;
        
        
        [self showSelectModelView:shopDetailModel];
        

        
    }else
    {
        
        
        
        FMTimeKillShopModel * killModel = shopModel;
        
        FMTimeKillShopDetailController * shopdetail = [[FMTimeKillShopDetailController
                                                        alloc]init];
        shopdetail.hidesBottomBarWhenPushed = YES;
        shopdetail.shopDetailStyle = FMTimeKillShopDetailControllerStyleMiaoSha;
        NSString * htmlUrl = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/product/index_client/%@.html",killModel.product_id];
        //秒杀链接地址
        
        shopdetail.activity_state = killModel.activity_state;
        shopdetail.detailURL = htmlUrl;
        shopdetail.killPrice = killModel.sale_price;
        shopdetail.actionFlag = killModel.kill_id;
        if (killModel.product_id) {
            shopdetail.product_id = killModel.product_id;
        }
        [self.navigationController pushViewController:shopdetail animated:YES];

    }
}

-(void)FMShowSelectViewDidSelecrButton:(FMSelectShopInfoModel * )selectModel;
{
    self.shopDetailModel = selectModel;
    XZConfirmOrderKillViewController *confirmOrder = [[XZConfirmOrderKillViewController alloc] init];
    confirmOrder.shopDetailModel = selectModel;
    [self.navigationController pushViewController:confirmOrder animated:YES];
    

}


-(void)showSelectModelView:(FMSelectShopInfoModel * )shopDetailModel
{
    
    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) { // 已登录
        
    }else { // 未登录
        LoginController *registerController = [[LoginController alloc] init];
        FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
        [self.navigationController presentViewController:navController animated:YES completion:^{
        }];
        return;
    }
    

    
    
    FMTimeKillSelectView * shopView = [[FMTimeKillSelectView alloc]init];
    
    //添加button
    
    shopView.isShowCount = NO;
    shopView.selectStyle = FMTimeKillShowSelectViewStyleMiaoSha;
    [shopView createPresentModel:shopDetailModel];
    
    
    __weak __typeof(&*self)weakSelf = self;
    shopView.successBlock = ^(FMSelectShopInfoModel * selectModel){
        [weakSelf FMShowSelectViewDidSelecrButton:selectModel];
    };

    
    shopView.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.15];
    self.definesPresentationContext = YES;
    //源Controller中跳转方法实现
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
 
        
        shopView.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        [weakSelf.navigationController presentViewController:shopView animated:NO completion:^{
        }];
        
    } else {
        
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        appdelegate.window.rootViewController.modalPresentationStyle=UIModalPresentationCurrentContext;
        [appdelegate.window.rootViewController presentViewController:shopView animated:YES completion:^{
            shopView.view.backgroundColor=[UIColor clearColor];
            appdelegate.window.rootViewController.modalPresentationStyle=UIModalPresentationFullScreen;
        }];
    }

}

- (void)configureCellTwo:(FMTimeKillCommentCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    
    FMKillTimeComment * comment = self.commentDataSource[indexPath.row];
    
    cell.commentModel = comment;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        CGFloat heigh = [tableView fd_heightForCellWithIdentifier:FMTimeKillShopTableViewRegister  configuration:^(FMTimeKillTableViewCell *cell) {
            [self configureCell:cell atIndexPath:indexPath];
        }];
        if (heigh < 105) {
            return 105;
        }else
        {
            return heigh + 10;
        }
        
    }else if(indexPath.section == 1)
    {
        CGFloat heigh = [tableView fd_heightForCellWithIdentifier:FMTimeKillCommentTableViewRegister  configuration:^(FMTimeKillCommentCell *cell) {
            [self configureCellTwo:cell atIndexPath:indexPath];
        }];
        if (heigh < 50) {
            return 65;
        }else
        {
            return heigh;
        }
        
    }else 
    {
        return 0;
    }
  
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 90;
    }else if(section == 1){
        return (KProjectScreenWidth * 3 / 16) +  38;
    }else
    {
        return 0;
    }
        
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        FMTimeKillTableViewSectionHeader * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:FMTimeKillShopTableSectionRegister];
        if (self.sectionFitstHeader) {
            if (!header) {
                header = self.sectionFitstHeader;
            }
        }
        if ((!header)&&self.time_bucket.count > 0) {
            header = [[FMTimeKillTableViewSectionHeader alloc]initWithReuseIdentifier:FMTimeKillShopTableSectionRegister];
             __weak __typeof(&*self)weakSelf = self;
            header.buttonBlock = ^(NSInteger index){
                [weakSelf buttonOnClick:index];
            };
            if (self.time_bucket.count > 0) {
                header.titleArray = self.time_bucket;
                
            }
            if (!self.sectionFitstHeader) {
                 self.sectionFitstHeader = header;
            }
           
        }
        
        return header;
    }else if(section == 1)
    {
        FMTimeKillSectionSectionHeader * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:FMTimeKillCommentTableSectionRegister];
        if (!header) {
            header = [[FMTimeKillSectionSectionHeader alloc]initWithReuseIdentifier:FMTimeKillCommentTableSectionRegister];
        }
         __weak __typeof(&*self)weakSelf = self;
        header.buttonBlock = ^(NSInteger index){
            [weakSelf buttonOnClick:index];
        };
        return header;

    }else
    {
        return nil;
    }
}
-(void)buttonOnClick:(NSInteger)index
{
    
    
    
    if (index > 100) {
        switch (index) {
            case 444:
            {
                
                if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) { // 已登录
                    
                }else { // 未登录
                    LoginController *registerController = [[LoginController alloc] init];
                    FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
                    [self.navigationController presentViewController:navController animated:YES completion:^{
                    }];
                    return;
                }
                
                
                
                WLEvaluateViewController *wlVC = [[WLEvaluateViewController alloc]init];
                wlVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:wlVC animated:YES];
            }
                break;
            case 445:
            {
                //评论
                YSEvaluationRulesViewController * commentRules = [[YSEvaluationRulesViewController alloc]init];
                commentRules.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:commentRules animated:YES];
            }
                break;
            case (446 + 50):
            {
                
                YSSpikeRuleViewController * bidding = [[YSSpikeRuleViewController alloc]init];
                bidding.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:bidding animated:YES];
            }
                break;
                
            case 789:
            {
                self.page ++;
                
                [self getCommentDataSourceFromNetWork];
            }
                break;
                
            default:
                break;
        }

    }else
    {
        //小于100；
        if (index >= 50) {
            NSString * headString = [[NSDate date] retCurrentdateWithYYYYMMDD];
            NSString * timeString = self.time_bucket[index - 50];
            NSString * endString = [timeString stringByReplacingOccurrencesOfString:@":" withString:@""];
            
            [self getDataSourceFromNetWorkWithString:headString WithPart:endString];
        }
    }
    
}


- (NSDate *)tDate
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    return [date  dateByAddingTimeInterval: interval];
    
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
