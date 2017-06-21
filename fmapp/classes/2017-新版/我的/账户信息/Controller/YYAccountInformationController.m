//
//  YYAccountInformationController.m
//  fmapp
//
//  Created by yushibo on 2017/2/21.
//  Copyright © 2017年 yk. All rights reserved.
//  账户信息首页

#import "YYAccountInformationController.h"
#import "LocalDataManagement.h"
#import "OpenUDID.h"
#import "ShareViewController.h"
#import "GestureViewController.h"
#import "UIButton+WebCache.h"
#import "YYPersonalInformationViewController.h" //个人信息
#import "XZRiskQuestionnaireViewController.h"  //  风险评估问卷
#import "YYSecuritySettingsViewController.h"   //安全设置
#import "XZMyBankController.h" //  我的银行卡
#import "XZMyBankController.h" //新的绑定银行卡界面
#import "WLNewEvaluateViewController.h"  //评估结果页
#import "SignOnDeleteView.h"
#import "RegexKitLite.h"
#import "WLZhuCeViewController.h"

#import "YYPlatformClosedView.h"    //平台关闭提示
#import "YYHuifuBalanceCashController.h"  //并行  汇付提现提示
//#import "YYMyBankCardsNewViewController.h"  //徽商银行我的银行卡界面
#import "YYBindBankCardViewController.h"  //绑定银行卡界面.
#import "FMRTAddCardToView.h"
#import "FMTieBankCardViewController.h"
#import "FMMessageViewShow.h"

@interface YYAccountInformationController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic,weak)UIButton  *loginOrLoginOutBtn;
@property (nonatomic, assign)NSInteger logAgain;
@property (nonatomic, strong)UILabel *personalInfoLable;
@property (nonatomic, strong) FMAccountInfoModel * userInfo;

@end

@implementation YYAccountInformationController

-(FMAccountInfoModel *)userInfo
{
    if (!_userInfo) {
        _userInfo = [[FMAccountInfoModel alloc]init];
    }
    return _userInfo;
}
-(NSArray *)titleArray{
    
    if(!_titleArray){
        if ([self.userInfo.avlBal floatValue] > 0) {
            _titleArray = [NSArray arrayWithObjects:@"银行卡",@"安全设置",@"汇付余额提现",@"风险承受能力评估", nil];
        }else
        {
            _titleArray = [NSArray arrayWithObjects:@"银行卡",@"安全设置",@"风险承受能力评估", nil];
        }
            
    }
    return _titleArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.logAgain == 1) {
        [self.navigationController popViewControllerAnimated:NO];
    }
    
    if ([[CurrentUserInformation sharedCurrentUserInfo].huishangshiming integerValue]==1) {
        
        self.personalInfoLable.text = @"个人信息";
        self.personalInfoLable.textColor = [HXColor colorWithHexString:@"#333333"];
    }else{
        
        self.personalInfoLable.text = @"未实名";
        self.personalInfoLable.textColor = [HXColor colorWithHexString:@"#ff6633"];
        
    }

    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.logAgain = 0;
    self.view.backgroundColor = [HXColor colorWithHexString:@"#f4f5f9"];
    [self settingNavTitle:@"账户信息"];

    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(leftloginNotification:)
                                                 name: FMUserLoginNotification
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(leftloginOutNotification:)
                                                 name: FMUserLogoutNotification
                                               object: nil];


    if ([CurrentUserInformation sharedCurrentUserInfo].shiming == 1) {
        [self getDataSourceFromNetWorkWithUserInfo];

    }else
    {
        FMAccountInfoModel * accModel = [[FMAccountInfoModel alloc]init];
        accModel.avlBal = @"0.0";
        accModel.outOfTime = @"1";
        
        self.userInfo = accModel;
        
        [self setupTableView];
        
        [self setupLoginOut];

    }
}

-(void)getDataSourceFromNetWorkWithUserInfo
{
    NSString * url = kXZUniversalTestUrl(@"LLQueryBalanceBg");
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"AppId":@"huiyuan",
                                 @"AppTime":[NSNumber numberWithInt:timestamp],
                                 @"Token":tokenlow,
                                 @"FlagChnl":@1,
                                 @"CmdId":@"LLQueryBalanceBg"
                                 
                                 };
    /**FlagChnl 标记位 iOS端必须传1   !!!  **/
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak __typeof(&*self)weakSelf = self;
    
    [FMHTTPClient postPath:url parameters:parameter completion:^(WebAPIResponse *response) {
        NSLog(@"账户信息中的 =========== %@",response.responseObject);
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view  animated:YES];
        
        if (response.responseObject) {
            if (response.code == WebAPIResponseCodeSuccess) {
                NSDictionary * dict = response.responseObject[@"data"];
                
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    
                    FMAccountInfoModel * accModel = [[FMAccountInfoModel alloc]init];
                    [accModel setValuesForKeysWithDictionary:dict];
                    weakSelf.userInfo = accModel;
                    
                    [weakSelf setupTableView];
                    
                    [weakSelf setupLoginOut];
                }
            }else
            {
                if (response.responseObject[@"msg"]) {
                    ShowAutoHideMBProgressHUD(weakSelf.view, response.responseObject[@"msg"]);
                }else
                {
                    ShowAutoHideMBProgressHUD(weakSelf.view, @"数据加载失败，请稍后重试！");
                }
           }
        }else {
             ShowAutoHideMBProgressHUD(weakSelf.view, @"网络不好，请稍后重试！");
        }
    }];
    

    
}

- (void)setupTableView{
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 280) style:UITableViewStylePlain];
    tableView.backgroundColor = [HXColor colorWithHexString:@"#f4f5f9"];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    self.tableView.scrollEnabled = NO;
    self.tableView.tableHeaderView = [self setupTableHeaderView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.tableView];

}
#pragma mark --  UITableView头视图
-(UIView *)setupTableHeaderView{

    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 80)];
    headerView.backgroundColor = [HXColor colorWithHexString:@"#ffffff"];
    
    /**  头像 */
    UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headBtn.frame = CGRectMake(12, 15, 46, 46);
//    [headBtn addTarget:self action:@selector(didClickLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    headBtn.userInteractionEnabled = YES;
    headBtn.layer.masksToBounds = YES;
    headBtn.layer.cornerRadius = 23.0f;
    if ([[CurrentUserInformation sharedCurrentUserInfo].touxiangsde isEqualToString:@"www.rongtuojinrong.com/Public/app/commtouxiang.png"]) {

        [headBtn setImage:[UIImage imageNamed:@"新版_默认头像_36"] forState:UIControlStateNormal];
    }else{
    
        [headBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[CurrentUserInformation sharedCurrentUserInfo].touxiangsde]]  forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"新版_默认头像_36"]];
    }
    [headerView addSubview:headBtn];
    
    /** 右部箭头 */
    UIImageView *arrowView = [[UIImageView alloc]init];
    arrowView.image = [UIImage imageNamed:@"账户信息_向右小箭头_18_1702"];
    arrowView.contentMode = UIViewContentModeScaleAspectFit;
    [headerView addSubview:arrowView];
    [arrowView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView.mas_right).offset(-16);
        make.centerY.equalTo(headerView.mas_centerY).offset(-3);
        make.width.equalTo(8);
    }];
    
    /** 个人信息 */
    UILabel *personalInfoLable = [[UILabel alloc]init];
    self.personalInfoLable = personalInfoLable;
//    personalInfoLable.backgroundColor = [UIColor redColor];
    personalInfoLable.textAlignment = NSTextAlignmentRight;
    if ([[CurrentUserInformation sharedCurrentUserInfo].huishangshiming integerValue]==1) {
        
        personalInfoLable.text = @"个人信息";
        personalInfoLable.textColor = [HXColor colorWithHexString:@"#333333"];
    }else{
        
        personalInfoLable.text = @"未实名";
        personalInfoLable.textColor = [HXColor colorWithHexString:@"#ff6633"];

    }

    personalInfoLable.font = [UIFont systemFontOfSize:16];
    [headerView addSubview:personalInfoLable];
    [personalInfoLable makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowView.mas_left).offset(-10);
        make.centerY.equalTo(arrowView.mas_centerY);
        make.width.equalTo(75);
    }];
    
    /** 点击事件 */
    UIButton *targetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [targetBtn addTarget:self action:@selector(didClickBtn) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:targetBtn];
    [targetBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView.mas_right);
        make.left.equalTo(personalInfoLable.mas_left);
        make.top.equalTo(headerView.mas_top);
        make.bottom.equalTo(headerView.mas_bottom);
    }];

    /** 姓名 */
    UILabel *nameLable = [[UILabel alloc]init];
    if ([[CurrentUserInformation sharedCurrentUserInfo].huishangshiming integerValue]==1) {

        NSString *zhenshiname = [CurrentUserInformation sharedCurrentUserInfo].zhenshiname;
        NSString *reallyName = [zhenshiname stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"*"];
        nameLable.text = reallyName;
    }
    nameLable.font = [UIFont systemFontOfSize:16];
    nameLable.textColor = [HXColor colorWithHexString:@"#333333"];
    [headerView addSubview:nameLable];
    [nameLable makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(personalInfoLable.mas_left).offset(-10);
        make.top.equalTo(headerView.mas_top).offset(15);
        make.left.equalTo(headBtn.mas_right).offset(13);
    }];
    
    /** 用户名 */
    UILabel *user_nameLable = [[UILabel alloc]init];
    if ([CurrentUserInformation sharedCurrentUserInfo].userName.length > 0) {
        
        // 判断是否为手机号
   //     if ([self isPhoneNumber:[CurrentUserInformation sharedCurrentUserInfo].personName]) {
        
        if([[CurrentUserInformation sharedCurrentUserInfo].personName isMatchedByRegex:@"^1[3|4|5|7|8]\\d{9}$"]){
            user_nameLable.text = [[CurrentUserInformation sharedCurrentUserInfo].personName stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];

        }else{
        
            user_nameLable.text = [CurrentUserInformation sharedCurrentUserInfo].personName;

        }
    }else{
    
        user_nameLable.text = [[CurrentUserInformation sharedCurrentUserInfo].mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    
    if ([[CurrentUserInformation sharedCurrentUserInfo].huishangshiming integerValue]==1) {
        
        user_nameLable.font = [UIFont systemFontOfSize:14];
    }else{
        
        user_nameLable.font = [UIFont systemFontOfSize:16];
    }

    user_nameLable.textColor = [HXColor colorWithHexString:@"#333333"];
    [headerView addSubview:user_nameLable];
    [user_nameLable makeConstraints:^(MASConstraintMaker *make) {
        if ([[CurrentUserInformation sharedCurrentUserInfo].huishangshiming integerValue]==1) {

            make.top.equalTo(nameLable.mas_bottom).offset(8);
        }else{
        
            make.centerY.equalTo(headerView.mas_centerY);
        }
        make.right.equalTo(nameLable.mas_right);
        make.left.equalTo(nameLable.mas_left);
    }];


    

    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 74, KProjectScreenWidth, 5)];
    lineView.backgroundColor = [HXColor colorWithHexString:@"#f4f5f9"];
    [headerView addSubview:lineView];
    return headerView;
}

- (void)didClickBtn{

    YYPersonalInformationViewController *vc = [[YYPersonalInformationViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark --  正则表达式判断是否是手机号

- (BOOL)isPhoneNumber:(NSString *)str {
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[156])\\d{8}$";
    NSString * CT = @"^1((33|53|8|7[09])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    BOOL res1 = [regextestmobile evaluateWithObject:str];
    BOOL res2 = [regextestcm evaluateWithObject:str];
    BOOL res3 = [regextestcu evaluateWithObject:str];
    BOOL res4 = [regextestct evaluateWithObject:str];
    
    if (res1 || res2 || res3 || res4 ) {
        return YES;
    } else {
        return NO;
    }
}
#pragma mark --  UITableView数据源
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return  self.titleArray.count;
}
#pragma mark --  UITableView代理方法

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [HXColor colorWithHexString:@"#333333"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 49, KProjectScreenWidth, 1)];
    lineView.backgroundColor = [HXColor colorWithHexString:@"#f4f5f9"];
    
    if (self.titleArray.count > 3) {
        if (indexPath.row == 2) {
            UILabel * decimalLabel = [[UILabel alloc]initWithFrame:CGRectMake(KProjectScreenWidth - 120 - 50, 0, 120, 50)];
            decimalLabel.text = [NSString stringWithFormat:@"%@元",self.userInfo.avlBal] ;
            decimalLabel.textColor = [HXColor colorWithHexString:@"#333333"];
            decimalLabel.font = [UIFont systemFontOfSize:16];
            decimalLabel.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:decimalLabel];
        }
    }
    [cell addSubview:lineView];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {//银行卡
        XZMyBankController * bankController = [[XZMyBankController alloc]init];
        bankController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bankController animated:YES];
        
    }else if (indexPath.row == 1){//安全设置
        
        YYSecuritySettingsViewController *securityV = [[YYSecuritySettingsViewController alloc]init];
        [self.navigationController pushViewController:securityV animated:YES];
        
    }else if (indexPath.row == 2){//托管账户
        
        if (self.titleArray.count > 3) {
            if ([self.userInfo.avlBal floatValue] > 0) {
                if ([self.userInfo.outOfTime integerValue] == 0) {
                    //未失效
                    //去汇付提现界面
                    YYHuifuBalanceCashController *huifuTXvc = [[YYHuifuBalanceCashController alloc]init];
                    [self.navigationController pushViewController:huifuTXvc animated:YES];
                    

                }else
                {
                    NSString * string1 = @"您好，我平台已关闭汇付，\n您可到汇付天下官网\n";
                    NSString * string2 = @"https://c.chinapnr.com/p2puser/ \n";
                    NSString * string3 = @"登录您的汇付账户通道、查看余额或提现。";
                    NSString * stringALl = [NSString stringWithFormat:@"%@%@%@",string1,string2,string3];
                    
                    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:stringALl];
                    [attributedString addAttribute:NSLinkAttributeName
                                             value:string2
                                             range:[[attributedString string] rangeOfString:string2]];
                    [attributedString addAttribute:NSForegroundColorAttributeName
                                             value:[HXColor colorWithHexString:@"#2280f6"]
                                             range:[[attributedString string] rangeOfString:string2]];
                    
                    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
                    paraStyle.lineBreakMode =NSLineBreakByCharWrapping;
                    paraStyle.alignment =NSTextAlignmentLeft;
                    paraStyle.lineSpacing = 7; //设置行间距
                    //    paraStyle.paragraphSpacing = - 3.0; // 设置段落间距
                    
                    paraStyle.hyphenationFactor = 0.0;
                    paraStyle.firstLineHeadIndent =0.0;
                    paraStyle.paragraphSpacingBefore =0.0;
                    paraStyle.headIndent = 0;
                    paraStyle.tailIndent = 0;
                    
                    [attributedString addAttribute:NSParagraphStyleAttributeName
                                             value:paraStyle
                                             range:[[attributedString string] rangeOfString:stringALl]];
                    
                    
                    [FMMessageViewShow showFMMessageViewShow:attributedString WithBolok:^{
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://c.chinapnr.com/p2puser/"]];
                    }];
                    
                    
                  
                }
            }else
            {
                
            }
            
            
        }else
        {
            [self fengXinChengShouNengLiPingGu];
        }
        
        
        
        
    }else if (indexPath.row == 3){//风险承受能力评估
      
        
        [self fengXinChengShouNengLiPingGu];
    }
}

-(void)fengXinChengShouNengLiPingGu
{
    
    if (!([[CurrentUserInformation sharedCurrentUserInfo].huishangshiming integerValue] == 1)) {
        __weak __typeof(&*self)weakSelf = self;
        [FMRTAddCardToView showWithAddBtn:^{
            FMTieBankCardViewController *tieBank = [[FMTieBankCardViewController alloc]init];
            tieBank.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:tieBank animated:YES];
            
            //!!!!!---!!!!
        }];
         
        return;
    }
    
    if ([self.IsDone isEqualToString:@"0"]) {
        
        XZRiskQuestionnaireViewController *riskQV = [[XZRiskQuestionnaireViewController alloc]init];
        [self.navigationController pushViewController:riskQV animated:YES];
    }else{
        
        WLNewEvaluateViewController *evaluateVc = [[WLNewEvaluateViewController alloc] init];
        evaluateVc.isComeFromYY = YES;
        [self.navigationController pushViewController:evaluateVc animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
}

- (void)setupLoginOut{

    // 退出登录按钮
    UIButton *personalLogoOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [personalLogoOutButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:14/255.0f green:93/255.0f blue:210/255.0f alpha:1])
                                     forState:UIControlStateNormal];
    [personalLogoOutButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:14/255.0f green:93/255.0f blue:210/255.0f alpha:1])
                                     forState:UIControlStateHighlighted];
    [personalLogoOutButton addTarget:self
                              action:@selector(userLoginOut:)
                    forControlEvents:UIControlEventTouchUpInside];
    personalLogoOutButton.titleLabel.font=[UIFont boldSystemFontOfSize:16.0];
    if (![[CurrentUserInformation sharedCurrentUserInfo] userLoginState]) {//未登录
        [personalLogoOutButton setTitle:@"登录"
                               forState:UIControlStateNormal];
    }
    else
    {
        [personalLogoOutButton setTitle:@"退出账户"
                               forState:UIControlStateNormal];
    }
    [personalLogoOutButton setTitleColor:[UIColor whiteColor]
                                forState:UIControlStateNormal];
    
    if (KProjectScreenWidth == 414) {
        [personalLogoOutButton setFrame:CGRectMake(15.0f, 510.0f, KProjectScreenWidth-30, 43.0f)];
    }else if(KProjectScreenWidth == 375)
    {
        [personalLogoOutButton setFrame:CGRectMake(15.0f, 465.0f, KProjectScreenWidth-30, 43.0f)];
    }else{
        [personalLogoOutButton setFrame:CGRectMake(15.0f, 350.0f, KProjectScreenWidth-30, 43.0f)];
    }
    
    [personalLogoOutButton.layer setBorderWidth:0.5f];
    [personalLogoOutButton.layer setCornerRadius:2.0f];
    [personalLogoOutButton.layer setMasksToBounds:YES];
    [personalLogoOutButton setBackgroundColor:KDefaultOrBackgroundColor];
    [personalLogoOutButton.layer setBorderColor:[KDefaultOrNightSepratorColor CGColor]];
    self.loginOrLoginOutBtn=personalLogoOutButton;
//    [self.mainScrollView addSubview:personalLogoOutButton];
    
    [self.view addSubview:personalLogoOutButton];


    
}

- (void)userLoginOut:(UIButton *)btn
{
        UIActionSheet *loginOutActionSheet = [[UIActionSheet alloc] initWithTitle:@"你确定退出本次登录吗?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出" otherButtonTitles:nil];
        [loginOutActionSheet showInView:self.view.window];
    
}
/** 发现--判断用户是否登录 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
        //        退出登录前请求数据
        int timestamp = [[NSDate date]timeIntervalSince1970];
        NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
        NSString *tokenlow=[token lowercaseString];
        NSString *openUDIDString = [[NSString alloc]initWithFormat:@"%@",[OpenUDID value]];
        
        NSString *url=[NSString stringWithFormat:@"%@?user_id=%@&appid=huiyuan&shijian=%d&token=%@&imei=%@",explorerIsLoginURL,[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow,openUDIDString];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        FMWeakSelf;
        [FMHTTPClient getPath:url parameters:nil completion:^(WebAPIResponse *response) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
           if (response.responseObject) {
                
                if (response.code == WebAPIResponseCodeSuccess) {
                    //移除本地文件
                    [[CurrentUserInformation sharedCurrentUserInfo] setUserLoginState:0];//设置用户为未登录状态

                 
                    ////移除用户登录文件
                    [[CurrentUserInformation sharedCurrentUserInfo] cleanAllUserInfo];
                    
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:FMUserLogoutNotification object:nil];//触发退出登录通知
                    
                    //注册控制器
                    FMWeakSelf;
                    LoginController *registerController = [[LoginController alloc] init];
                    registerController.isComFromLoginOut = YES;
                    registerController.successBlock = ^(){
                        weakSelf.logAgain = 1;
                    };
                    
                    registerController.homeBack = ^(){
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    };
                    FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];

                    [self.tabBarController presentViewController:navController animated:YES completion:^{
                        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                    }];
                }else{
                    
                    if ([response.responseObject objectForKey:@"msg"]) {
                        
                        NSString *msgStr = [response.responseObject objectForKey:@"msg"];
                        
                        ShowAutoHideMBProgressHUD(weakSelf.view, msgStr);
                    }else{
                        ShowAutoHideMBProgressHUD(weakSelf.view, @"请求数据失败！");
                    }
                }
            }else{
                ShowAutoHideMBProgressHUD(weakSelf.view, @"请求网络数据失败！");
            }
        }];
    }
}

- (void) leftloginNotification:(NSNotification *) notification{
    
    [self.loginOrLoginOutBtn setTitle:@"退出账户" forState:UIControlStateNormal];

}

- (void) leftloginOutNotification:(NSNotification *) notification{
    
    [self.loginOrLoginOutBtn setTitle:@"登录" forState:UIControlStateNormal];

    
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {
        NSString *url=[NSString stringWithFormat:@"%@?user_id=%@",realNameAuthenKaihuURL,[CurrentUserInformation sharedCurrentUserInfo].userId];
        WLZhuCeViewController *viewController = [[WLZhuCeViewController alloc]init];
        viewController.shareURL = url;
        viewController.navTitle = @"开通汇付";
        viewController.comeForm = 5;
        viewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:viewController animated:YES];

    }
}
    
@end


@implementation FMAccountInfoModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}


@end
     
