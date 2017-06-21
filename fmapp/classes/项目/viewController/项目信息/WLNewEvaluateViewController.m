//
//  WLNewEvaluateViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 17/2/14.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "WLNewEvaluateViewController.h"
#import "XZRiskQuestionnaireViewController.h"
#import "WLNewProjectDetailViewController.h"
#import "XZRiskQueSubmitAnswerModel.h"
#import "WLPingGuBottomTableViewCell.h"
#import "WLNewWebViewController.h"
#import "WLPingGuModel.h"
#import "WLZhuCeViewController.h"
#import "Fm_Tools.h"
#import "FMRTAddCardToView.h"
#import "FMTieBankCardViewController.h"


@interface WLNewEvaluateViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UILabel *middleLabel1;
@property(nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)UILabel *rightTimeLabel;//评估完成时间
@property(nonatomic,strong)UILabel *rightTimeLabel1;//评估失效时间
@property(nonatomic,strong)UILabel *middleLabel;//可重新评估次数
@property(nonatomic,strong)UIButton *reEvalueBtn;//重新评估按钮
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArr;


@end

@implementation WLNewEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self settingNavTitle:@"风险承受能力"];
    __weak __typeof(&*self)weakSelf = self;
    if (!weakSelf.isComeFromYY) {
        self.navBackButtonRespondBlock = ^(){
            [weakSelf returViewController];
        };
    }
    [self creatBackButton];
    [self createTableFooterView];
    [self requestGetUserGradeInfo];
    [self getdataFromeNet];
}

-(void)creatBackButton{
    
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightItemButton setTitle:@"常见问题" forState:UIControlStateNormal];
    [rightItemButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightItemButton setFrame:CGRectMake(0, 0, 80, 32)];

    [rightItemButton addTarget:self action:@selector(rightNavBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)createTableFooterView{

    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 1)];
    [lineView setBackgroundColor:[HXColor colorWithHexString:@"#e5e9f2"]];
    self.tableView.tableFooterView = lineView;
}

-(void)rightNavBtnClick{

    NSString *userId = [CurrentUserInformation sharedCurrentUserInfo].userLoginState?[CurrentUserInformation sharedCurrentUserInfo].userId:@"0";
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    // kXZUniversalTestUrl(@"GetProhibitBehavior")
    NSString *url=[NSString stringWithFormat:@"%@UserId=%@&AppId=huiyuan&AppTime=%@&Token=%@",kFMPhpUniversalBaseUrl(@"Rongtuoxinsoc/helpzhongxin/fxchangjian?"),userId,[NSNumber numberWithInt:timestamp],tokenlow];
    WLNewWebViewController *viewController=[[WLNewWebViewController alloc]initWithTitle:@"" AndWithShareUrl:url];
    viewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
//懒加载
- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight)style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            
            [self getdataFromeNet];
        }];
    }
    return _tableView;
    
}

-(void)returViewController
{
    WLNewProjectDetailViewController * viewC ;
    for (UIViewController * vc in self.navigationController.viewControllers) {
        if ([vc isMemberOfClass:[WLNewProjectDetailViewController class]]) {
            viewC = (WLNewProjectDetailViewController *)vc;
            break;
        }
    }
    if (viewC) {
        [self.navigationController popToViewController:viewC animated:YES];
    }else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
/*
 data =     {
 EvaluateCount = 3;
 EvaluatedCount = 3;
 GradeCode = 2;
 GradeName = "\U7a33\U5065\U578b";
 InvalidTime = 1520849809;
 IsDone = 1;
 IsInvalid = 0;
 LastTime = 1489313809;
 };
 */
#pragma mark ---- 请求GetUserGradeInfo数据
- (void)requestGetUserGradeInfo{
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"AppId":@"huiyuan",
                                 @"AppTime":[NSNumber numberWithInt:timestamp],
                                 @"Token":tokenlow,
                                 };
    FMWeakSelf;
    [FMHTTPClient postPath:kXZUniversalTestUrl(@"GetUserGradeInfo") parameters:parameter completion:^(WebAPIResponse *response) {
        
        if (response.code == WebAPIResponseCodeSuccess) {
            NSDictionary *dataDic = [response.responseObject objectForKey:@"data"];
            if ([dataDic isKindOfClass:[NSNull class]]){
                
            }else{
                [weakSelf createMainView:dataDic];

            }
        }else{
            
        }
        
    }];
}

-(void)getdataFromeNet{

    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString *navUrl = kXZUniversalTestUrl(@"GetUserGradeRecords");
    NSDictionary * parameter = @{@"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"AppId":@"huiyuan",
                                 @"AppTime":[NSNumber numberWithInt:timestamp],
                                 @"Token":tokenlow,
                                 };
    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient postPath:navUrl parameters:parameter completion:^(WebAPIResponse *response) {
        NSString * status = [NSString stringWithFormat:@"%@",response.responseObject[@"status"]];
        if ([status integerValue] == 0) {
            NSDictionary *dic = response.responseObject[@"data"];
            NSArray *arry = [dic objectForKey:@"Detail"];
            [weakSelf.dataArr removeAllObjects];
            for (NSDictionary *pingGuDic in arry) {
                WLPingGuModel *model = [[WLPingGuModel alloc]init];
                [model setValuesForKeysWithDictionary:pingGuDic];
                [weakSelf.dataArr addObject:model];
            }
            [self.tableView reloadData];
            
        }else
        {
            ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
        }
        [self.tableView.mj_header endRefreshing];
    }];
}

/** 评估总次数（本年度）   EvaluateCount*/
/** 已评估次数（本年度）   EvaluatedCount*/
/** 评级失效时间，格式：时间戳（精确到秒）   InvalidTime*/
/** 试卷得分   Results*/
/** 评估等级标识，范围参考：“投资人评估等级"   GradeCode*/
/** 评估等级名称，范围参考：“投资人评估等级”   GradeName*/

-(void)createMainView:(NSDictionary *)dic{
    
    [self.view addSubview:self.tableView];
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 420)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *headerImagV = [[UIImageView alloc]initWithFrame:CGRectMake(13, 30, KProjectScreenWidth-26,(KProjectScreenWidth-26)*341/700)];
    [headerImagV setImage:[UIImage imageNamed:@"项目详情_评估意见背景_1702"]];
    [headerView addSubview:headerImagV];
    
    UIImageView *titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(25*KProjectScreenWidth/414, 25*KProjectScreenWidth/414, 70*KProjectScreenWidth/414,85*KProjectScreenWidth/414)];
    [titleImage setImage:[UIImage imageNamed:@"项目详情_评估意见-图标__1702"]];
    [headerImagV addSubview:titleImage];
    
    UILabel * contentLabel = [[UILabel alloc]init];
    contentLabel.text = @"您的风险承受能力评级：";
    contentLabel.font = [UIFont systemFontOfSize:16*KProjectScreenWidth/414];
    contentLabel.textColor = [HXColor colorWithHexString:@"#333"];
    [headerImagV addSubview:contentLabel];
    [contentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleImage.mas_right).offset(20);
        make.top.equalTo(titleImage.mas_top).offset(15);
    }];
    
    UILabel * rightLabel = [[UILabel alloc]init];
    rightLabel.text = [dic objectForKey:@"GradeName"];
    rightLabel.font = [UIFont systemFontOfSize:18*KProjectScreenWidth/414];
    rightLabel.textColor = [HXColor colorWithHexString:@"ff6633"];
    [headerImagV addSubview:rightLabel];
    [rightLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentLabel.mas_right).offset(5);
        make.centerY.equalTo(contentLabel.centerY);
    }];
    
    UIImageView *lineImage = [[UIImageView alloc]init];
    [lineImage setImage:[UIImage imageNamed:@"项目详情_评估意见--分割线_1702"]];
    [headerImagV addSubview:lineImage];
    [lineImage makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleImage.mas_right).offset(25);
        make.right.equalTo(headerImagV.mas_right).offset(-36);
        make.top.equalTo(contentLabel.bottom).offset(5);
    }];

    UILabel * timeLabel = [[UILabel alloc]init];
    timeLabel.text = @"评估完成时间：";
    timeLabel.font = [UIFont systemFontOfSize:12*KProjectScreenWidth/414];
    timeLabel.textColor = [HXColor colorWithHexString:@"#666"];
    [headerImagV addSubview:timeLabel];
    [timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lineImage.centerX);
        make.top.equalTo(lineImage.bottom).offset(5);
    }];
    
    UILabel * rightTimeLabel = [[UILabel alloc]init];
    rightTimeLabel.text = [Fm_Tools getTimeFromString:[dic objectForKey:@"LastTime"]];
    rightTimeLabel.font = [UIFont systemFontOfSize:12*KProjectScreenWidth/414];
    rightTimeLabel.textColor = [HXColor colorWithHexString:@"#333"];
    [headerImagV addSubview:rightTimeLabel];
    [rightTimeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeLabel.right);
        make.top.equalTo(timeLabel.top);
    }];

    
    UILabel * timeLabel1 = [[UILabel alloc]init];
    timeLabel1.text = @"评估失效时间：";
    timeLabel1.font = [UIFont systemFontOfSize:12*KProjectScreenWidth/414];
    timeLabel1.textColor = [HXColor colorWithHexString:@"#666"];
    [headerImagV addSubview:timeLabel1];
    [timeLabel1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeLabel.left);
        make.top.equalTo(timeLabel.bottom).offset(5);
    }];
    
    UILabel * rightTimeLabel1 = [[UILabel alloc]init];
    rightTimeLabel1.text = [Fm_Tools getTimeFromString:[dic objectForKey:@"InvalidTime"]];
    rightTimeLabel1.font = [UIFont systemFontOfSize:12*KProjectScreenWidth/414];
    rightTimeLabel1.textColor = [HXColor colorWithHexString:@"#333"];
    [headerImagV addSubview:rightTimeLabel1];
    [rightTimeLabel1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeLabel1.right);
        make.top.equalTo(timeLabel1.top);
    }];
    self.rightTimeLabel1 = rightTimeLabel1;
    
    UILabel * middleLabel = [[UILabel alloc]init];
    int numberOfTimes = [[dic objectForKey:@"EvaluateCount"] intValue]-[[dic objectForKey:@"EvaluatedCount"] intValue];
    middleLabel.text = [NSString stringWithFormat:@"今年您还可以重新评估%d次",numberOfTimes];
    middleLabel.font = [UIFont systemFontOfSize:15*KProjectScreenWidth/414];
    middleLabel.textColor = [HXColor colorWithHexString:@"#333"];
    [headerView addSubview:middleLabel];
    [middleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerImagV.centerX);
        make.top.equalTo(headerImagV.bottom).offset(35*KProjectScreenWidth/414);
    }];
    self.middleLabel = middleLabel;

    UIButton *reaEvaluateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (numberOfTimes>0) {
        [reaEvaluateBtn setBackgroundColor:[HXColor colorWithHexString:@"#0159d5"]];
        [reaEvaluateBtn addTarget:self action:@selector(reEvaluateAction) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [reaEvaluateBtn setBackgroundColor:[UIColor colorWithRed:169/255.0f green:170/255.0f blue:171/255.0f alpha:1]];
    }
    
    reaEvaluateBtn.titleLabel.font=[UIFont boldSystemFontOfSize:16.0];
    [reaEvaluateBtn setTitle:@"重新评估" forState:UIControlStateNormal];
    [reaEvaluateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reaEvaluateBtn.layer setBorderWidth:0.5f];
    [reaEvaluateBtn.layer setCornerRadius:2.0f];
    [reaEvaluateBtn.layer setMasksToBounds:YES];
    [reaEvaluateBtn.layer setBorderColor:[KDefaultOrNightSepratorColor CGColor]];
    [headerView addSubview:reaEvaluateBtn];
    [reaEvaluateBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleLabel.bottom).offset(20*KProjectScreenWidth/414);
        make.left.equalTo(headerImagV.left);
        make.right.equalTo(headerImagV.right);
        make.height.equalTo(47);
    }];
    
    if (numberOfTimes<=0) {
        
        NSString *timeOfKetou = [Fm_Tools getTimeFromString:[dic objectForKey:@"InvalidTime"]];
        timeOfKetou = [timeOfKetou substringToIndex:4];
        timeOfKetou = [NSString stringWithFormat:@"%@%@",timeOfKetou,@"-01-01"];
        UILabel * middleLabel1 = [[UILabel alloc]init];
        middleLabel1.text = [NSString stringWithFormat:@"今年评估次数已达3次上限，%@后可重新评估",timeOfKetou];
        middleLabel1.font = [UIFont systemFontOfSize:13*KProjectScreenWidth/414];
        middleLabel1.textColor = [HXColor colorWithHexString:@"#ff6633"];
        [headerView addSubview:middleLabel1];
        [middleLabel1 makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(reaEvaluateBtn.centerX);
            make.top.equalTo(reaEvaluateBtn.bottom).offset(10*KProjectScreenWidth/414);
        }];
        
        UILabel * theTitleLabel = [[UILabel alloc]init];
        theTitleLabel.text = @"评估记录";
        theTitleLabel.font = [UIFont systemFontOfSize:16*KProjectScreenWidth/414];
        theTitleLabel.textColor = [HXColor colorWithHexString:@"#666"];
        [headerView addSubview:theTitleLabel];
        [theTitleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(middleLabel1.bottom).offset(20*KProjectScreenWidth/414);
            make.left.equalTo(reaEvaluateBtn.left).offset(10);
        }];
        [headerView setFrame:CGRectMake(0, 0, KProjectScreenWidth,420*KProjectScreenWidth/414)];
        if (KProjectScreenWidth == 320) {
            [headerView setFrame:CGRectMake(0, 0, KProjectScreenWidth,420*KProjectScreenWidth/414+15)];
        }
    }else{
        UILabel * theTitleLabel = [[UILabel alloc]init];
        theTitleLabel.text = @"评估记录";
        theTitleLabel.font = [UIFont systemFontOfSize:16*KProjectScreenWidth/414];
        theTitleLabel.textColor = [HXColor colorWithHexString:@"#666"];
        [headerView addSubview:theTitleLabel];
        [theTitleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(reaEvaluateBtn.bottom).offset(25*KProjectScreenWidth/414);
            make.left.equalTo(reaEvaluateBtn.left).offset(10);
        }];
        [headerView setFrame:CGRectMake(0, 0, KProjectScreenWidth,400*KProjectScreenWidth/414)];
        if (KProjectScreenWidth == 320) {
            [headerView setFrame:CGRectMake(0, 0, KProjectScreenWidth,400*KProjectScreenWidth/414+15)];
        }
    }
    self.tableView.tableHeaderView = headerView;

}

//判断直投项目的用户评级（PHP）Rongtuoxinsoc/Usercenter/panduantoubiaofou
-(void)reEvaluateAction{
    
    if (!([[CurrentUserInformation sharedCurrentUserInfo].huishangshiming integerValue]==1)) {
        [self notYetToOpenHuiFuTianXia];
        return;
        
    }
    XZRiskQuestionnaireViewController *vc = [[XZRiskQuestionnaireViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)notYetToOpenHuiFuTianXia
{
    
    __weak __typeof(&*self)weakSelf = self;
    [FMRTAddCardToView showWithAddBtn:^{
        FMTieBankCardViewController *tieBank = [[FMTieBankCardViewController alloc]init];
        tieBank.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:tieBank animated:YES];
        
        //!!!!!---!!!!
    }];
}
/*
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *url=[NSString stringWithFormat:@"%@?user_id=%@",realNameAuthenKaihuURL,[CurrentUserInformation sharedCurrentUserInfo].userId];
        WLZhuCeViewController *viewController=[[WLZhuCeViewController alloc]init];
        viewController.shareURL = url;
        viewController.navTitle = @"开通汇付";
        viewController.comeForm = 5;
        viewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:viewController animated:YES];
        
    }else
    {
//        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
 */

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"EvaluateCell";
    
    WLPingGuBottomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[WLPingGuBottomTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellIdentifier];
    }
    if (indexPath.row == 0) {
        cell.isLong = @"1";
    }else{
        cell.isLong = @"0";
    }
    
    cell.model = self.dataArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 50;
    
}

@end
