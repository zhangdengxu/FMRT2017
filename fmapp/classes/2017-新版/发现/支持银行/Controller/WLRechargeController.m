//
//  WLRechargeController.m
//  fmapp
//
//  Created by 秦秦文龙 on 17/5/16.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "WLRechargeController.h"
#import "WLRechageCell.h"
#import "WLRechageBankModel.h" // model
#import "ShareViewController.h" // 汇付充值、
#import "WLZhuCeViewController.h" // 实名、开通汇付
#import "HTTPClient+UserLoginOrRegister.h" // 请求用户实名信息
#import "LocalDataManagement.h"

@interface WLRechargeController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableRecharge;

@property (nonatomic, strong) UIView *header;

/** 充值数据 */
@property (nonatomic, strong) NSMutableArray *arrRecharge;
/** 银行卡数据 */
@property (nonatomic, strong) NSMutableArray *arrRechargeBank;
/** 当前页面的model */
@property (nonatomic, strong) WLRechageBankModel *modelRecharge;
/** 充值金额 */
@property (nonatomic, strong)  NSString *TransAmt;

@end

@implementation WLRechargeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingNavTitle:@"支持银行"];
    
    [self.view addSubview:self.tableRecharge];
    
//    UIButton *btnAboutUs = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnAboutUs.frame = CGRectMake(0, 0, 65, 44);
//    [btnAboutUs setTitle:@"返回账户" forState:UIControlStateNormal];
//    [btnAboutUs.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
//    [btnAboutUs setTitleColor:XZColor(13, 89, 209) forState:UIControlStateNormal];
//    btnAboutUs.titleLabel.textAlignment = NSTextAlignmentRight;
//    [btnAboutUs addTarget:self action:@selector(didClickBackToAccount:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnAboutUs];
    
//    [self getRechargeViewData];
    [self getNewRechargeViewDate];
}

-(void)getNewRechargeViewDate {


    NSDictionary *parameter = @{

                                };
    
    __weak __typeof(&*self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:kXZUniversalTestUrl(@"LLBankOfSupport") parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        if (response.responseObject) {
            [weakSelf.arrRechargeBank removeAllObjects];
            if (response.code == WebAPIResponseCodeSuccess) {
                NSDictionary *data = response.responseObject[@"data"];
                if (![data isKindOfClass:[NSNull class]]) {
                    
                    if (![data[@"CardsList"] isKindOfClass:[NSNull class]]) {
                        NSArray *bankArr = data[@"CardsList"];
                        for (NSDictionary *dict in bankArr) {
                            WLRechageBankModel *modelBank = [[WLRechageBankModel alloc] init];
                            [modelBank setValuesForKeysWithDictionary:dict];
                            [weakSelf.arrRechargeBank addObject:modelBank];
                        }
                    }
                }
                else {
                    ShowAutoHideMBProgressHUD(weakSelf.view, [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]]);
                }
            }
            else {
                ShowAutoHideMBProgressHUD(weakSelf.view, [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]]);
            }
        }
        [weakSelf refreshTableView];
    }];

}
#pragma mark ----- 数据请求
-(void)getRechargeViewData
{
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    
    NSString *tokenlow = [token lowercaseString];
    NSDictionary *parameter = @{
                                @"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                @"AppId":@"huiyuan",
                                @"AppTime":[NSNumber numberWithInt:timestamp],
                                @"Token":tokenlow
                                };
    __weak __typeof(&*self)weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // kXZRechargeUrl
    [FMHTTPClient postPath:kXZUniversalTestUrl(@"PhpNateSave") parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        //        NSLog(@"充值页面数据：======= %@",response.responseObject);
        if (response.responseObject) {
            [weakSelf.arrRechargeBank removeAllObjects];
            if (response.code == WebAPIResponseCodeSuccess) {
                NSDictionary *data = response.responseObject[@"data"];
                if (![data isKindOfClass:[NSNull class]]) {
                    
                    if (![data[@"xianer"] isKindOfClass:[NSNull class]]) {
                        NSArray *bankArr = data[@"xianer"];
                        for (NSDictionary *dict in bankArr) {
                            WLRechageBankModel *modelBank = [[WLRechageBankModel alloc] init];
                            [modelBank setValuesForKeysWithDictionary:dict];
                            [weakSelf.arrRechargeBank addObject:modelBank];
                        }
                    }
                }
                else {
                    ShowAutoHideMBProgressHUD(weakSelf.view, [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]]);
                }
            }
            else {
                ShowAutoHideMBProgressHUD(weakSelf.view, [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]]);
            }
        }
        [weakSelf refreshTableView];
    }];
}

#pragma mark ---- 刷新页面
- (void)refreshTableView {
    [self.tableRecharge reloadData];
//    self.footer.modelRecharge = self.modelRecharge;
//    self.footer.frame = CGRectMake(0, 0, KProjectScreenWidth, self.modelRecharge.noteHeight);
//    self.tableRecharge.tableFooterView = self.footer;
    [self.tableRecharge.mj_header endRefreshing];
    
    //    self.modelRecharge.xianshi = @"1";
    // 判断是否显示弹窗
//    if ([self.modelRecharge.xianshi integerValue] == 1) {
//        UIWindow *window = [UIApplication sharedApplication].keyWindow;
//        self.popWindow.frame = window.frame;
//        self.popWindow.modelRecharge = self.modelRecharge;
//        [window addSubview:self.popWindow];
//    }
}

#pragma mark ----- 点击"确定"按钮进行充值
//- (void)didClickSureButtonToRecharge {
//    if ([CurrentUserInformation sharedCurrentUserInfo].shiming == 1) { // 已开通汇付,跳转汇付
//        [self hadRealNamejumpToRecharge];
//    }else { // 未开通
//        // 请求数据
//        [self checkUserInfoWithNetWork];
//    }
//}

#pragma mark ----- 请求数据判断是否开通汇付
//- (void)checkUserInfoWithNetWork
//{
//    __weak __typeof(&*self)weakSelf = self;
//    
//    LocalDataManagement *dataManagement = [[LocalDataManagement alloc] init];
//    if ([dataManagement getUserFileWithUserFileType:CYHUserLoginInfoFile]) {
//        // 用户登录文件存在，用户登录字典
//        NSDictionary *userLoginDic = [[NSDictionary alloc] initWithDictionary:[dataManagement getUserFileWithUserFileType:CYHUserLoginInfoFile]];
//        NSString *userName = [NSString stringWithFormat:@"%@",[userLoginDic objectForKey:@"UserName"]];//用户名
//        NSString *password = [NSString stringWithFormat:@"%@",[userLoginDic objectForKey:@"Password"]];//密码
//        
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        
//        [FMHTTPClient getUserLoginInforWithUser:userName withUserPassword:password completion:^(WebAPIResponse *response) {
//            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
//            if (response.responseObject) {
//                if(response.code == WebAPIResponseCodeSuccess){
//                    //                    NSLog(@"初始化登录信息 ========== %@",response.responseObject);
//                    NSDictionary *dict = response.responseObject[@"data"];
//                    if (dict) {
//                        // 初始化登录信息
//                        [CurrentUserInformation initializaionUserInformation:dict];
//                        NSNumber *shiming = dict[@"shiming"];
//                        if ([shiming intValue] == 1) {
//                            // 已开通汇付，跳转充值
//                            [self hadRealNamejumpToRecharge];
//                        }else { // 未实名，点击"确认提交"，
//                            [self performSelector:@selector(showAlertOrNot) withObject:self afterDelay:0.25];
//                        }
//                    }else {
//                        ShowAutoHideMBProgressHUD(weakSelf.view, @"数据加载失败");
//                    }
//                }else {
//                    ShowAutoHideMBProgressHUD(weakSelf.view, @"数据加载失败");
//                }
//            }else {
//                ShowAutoHideMBProgressHUD(weakSelf.view, @"数据加载失败");
//            }
//        }];
//        
//    }
//}

//- (void)showAlertOrNot {
//    // 未开通汇付，跳转实名
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您尚未开通汇付" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"开通汇付", nil];
//    [alert show];
//}

#pragma mark ----- 已实名，跳转汇付
//- (void)hadRealNamejumpToRecharge {
//    int timestamp = [[NSDate date] timeIntervalSince1970];
//    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
//    NSString *tokenlow = [token lowercaseString];
//    
//    NSString *CmdId = @"NetSave";
//    // 充值金额，金额格式必须是###.00
//    NSString *TransAmt = [NSString stringWithFormat:@"%.2f",[self.TransAmt floatValue]];
//    NSString *shareUrl;
//    if (self.GateBusiId) { // 绑定银行卡跳入
//        shareUrl = [NSString stringWithFormat:@"%@&UserId=%@&AppId=%@&AppTime=%@&Token=%@&TransAmt=%@&GateBusiId=QP",kXZUniversalTestUrl(CmdId),[CurrentUserInformation sharedCurrentUserInfo].userId,@"huiyuan",[NSNumber numberWithInt:timestamp],tokenlow,[NSString stringWithFormat:@"%@",TransAmt]];
//    }else {
//        shareUrl = [NSString stringWithFormat:@"%@&UserId=%@&AppId=%@&AppTime=%@&Token=%@&TransAmt=%@",kXZUniversalTestUrl(CmdId),[CurrentUserInformation sharedCurrentUserInfo].userId,@"huiyuan",[NSNumber numberWithInt:timestamp],tokenlow,[NSString stringWithFormat:@"%@",TransAmt]];
//    }
//    
//    ShareViewController *shareVc = [[ShareViewController alloc]initWithTitle:@"充值" AndWithShareUrl:shareUrl];
//    shareVc.JumpWay = @"recharge";
//    shareVc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:shareVc animated:YES];
//}

#pragma mark ----- 未实名，跳转实名页
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    
//    if (buttonIndex == 1) {
//        NSString *url = [NSString stringWithFormat:@"%@?user_id=%@",realNameAuthenKaihuURL,[CurrentUserInformation sharedCurrentUserInfo].userId];
//        
//        //        ShareViewController *shareVc = [[ShareViewController alloc] initWithTitle:@"开通汇付" AndWithShareUrl:url];
//        //        shareVc.hidesBottomBarWhenPushed = YES;
//        //        [self.navigationController pushViewController:shareVc animated:YES];
//        WLZhuCeViewController *viewController = [[WLZhuCeViewController alloc]init];
//        viewController.shareURL = url;
//        viewController.navTitle = @"开通汇付";
//        viewController.comeForm = 5;
//        viewController.hidesBottomBarWhenPushed=YES;
//        [self.navigationController pushViewController:viewController animated:YES];
//    }
//    
//}

#pragma mark ----- 点击返回账户
//- (void)didClickBackToAccount:(UIButton *)button {
//    if (self.tabBarController.selectedIndex == 3) {// 从”我的“进入
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }else {// 从其他页面进入
//        self.tabBarController.selectedIndex = 3;
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
//}

#pragma mark ----- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrRechargeBank.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 0) {
//        XZRechargeFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XZRechargeFirstCell"];
//        if (!cell) {
//            cell = [[XZRechargeFirstCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XZRechargeFirstCell"];
//        }
//        cell.modelRecharge = self.modelRecharge;
//        return cell;
//    }
//    else {
        WLRechageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XZRechargeCell"];
        if (!cell) {
            cell = [[WLRechageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XZRechargeCell"];
        }
//        if (self.arrRechargeBank.count > 0) {
            cell.modelBank = self.arrRechargeBank[indexPath.row];
//        }
        return cell;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 0) {
//        CGFloat height = self.modelRecharge.contentHeight + 15 + 15 + 10;
//        return height;
//    }else {
        return 50;
//    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark ----- 懒加载
- (UITableView *)tableRecharge {
    if (!_tableRecharge) {
        _tableRecharge = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 64) style:UITableViewStylePlain];
        _tableRecharge.delegate = self;
        _tableRecharge.dataSource  = self;
        _tableRecharge.backgroundColor = XZBackGroundColor;
        _tableRecharge.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableRecharge.showsVerticalScrollIndicator = NO;
        _tableRecharge.tableHeaderView = self.header;
        //        _tableRecharge.tableFooterView = self.footer;
        __weak __typeof(&*self)weakSelf = self;
        _tableRecharge.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf getNewRechargeViewDate];
        }];
    }
    return _tableRecharge;
}

- (UIView *)header {
    if (!_header) {
//        _header = [[XZRechargeHeader alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 140)];
//        
//        __weak __typeof(&*self)weakSelf = self;
//        _header.blockSureButton = ^(NSString *textUseInput){
//            weakSelf.TransAmt = textUseInput;
//            [weakSelf didClickSureButtonToRecharge];
            //            NSLog(@"点击了确认提交==== %@",textUseInput);

//        };
        _header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 50)];
        _header.backgroundColor = [UIColor whiteColor];
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 50)];
        [_header addSubview:labelTitle];
        labelTitle.textColor = XZColor(53, 53, 53);
        labelTitle.text = @"快捷支付可绑定的银行以及限额表";
        labelTitle.font = [UIFont systemFontOfSize:15.0f];
        labelTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _header;
}

//- (XZRechargeFooter *)footer {
//    if (!_footer) {
//        // WithFrame:CGRectMake(0, 0, KProjectScreenWidth, 0)
//        _footer = [[XZRechargeFooter alloc] init];
//    }
//    return _footer;
//}

- (NSMutableArray *)arrRecharge {
    if (!_arrRecharge) {
        _arrRecharge = [NSMutableArray array];
    }
    return _arrRecharge;
}

- (NSMutableArray *)arrRechargeBank {
    if (!_arrRechargeBank) {
        _arrRechargeBank = [NSMutableArray array];
    }
    return _arrRechargeBank;
}

- (WLRechageBankModel *)modelRecharge {
    if (!_modelRecharge) {
        _modelRecharge = [[WLRechageBankModel alloc] init];
    }
    return _modelRecharge;
}

//- (XZRechargePopWindow *)popWindow {
//    if (!_popWindow) {
//        _popWindow = [[XZRechargePopWindow alloc] init];
//        
//        __weak __typeof(&*self)weakSelf = self;
//        _popWindow.blockClosed = ^{
//            [weakSelf.popWindow removeFromSuperview];
//        };
//    }
//    return _popWindow;
//}

@end
