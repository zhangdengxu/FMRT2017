//
//  YYSecuritySettingsViewController.m
//  fmapp
//
//  Created by yushibo on 2017/2/23.
//  Copyright © 2017年 yk. All rights reserved.
//  安全设置

#import "YYSecuritySettingsViewController.h"
#import "ShareViewController.h"// 实名认证
#import "UserPhoneViewController.h"//修改手机号
#import "SetUpPasswordController.h"// 修改登录密码
#import "GesturerViewController.h" // 手势密码
#import "WLZhuCeViewController.h"
#import "FMRTChangeTradeKeyViewController.h"
#import "FMRTAddCardToView.h"
#import "FMTieBankCardViewController.h"
#import "WLChangePhoneNumberViewController.h"
#import "FMRTAddCardToView.h"

@interface YYSecuritySettingsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic,strong) NSArray *titleArray;

@end

@implementation YYSecuritySettingsViewController

-(NSArray *)titleArray{
    
    if(!_titleArray){
        _titleArray = [NSArray arrayWithObjects:@"实名认证", @"修改手机号", @"修改登录密码", @"修改交易密码", @"修改手势密码",nil];
    }
    return _titleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"安全设置"];
    self.view.backgroundColor = [HXColor colorWithHexString:@"#f4f5f9"];
    [self setupTableView];
    /**
     *出发登录通知，跳转到登录页面
     */
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(notice) name:@"denglu" object:nil];
}
- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];
    [[CurrentUserInformation sharedCurrentUserInfo]checkUserInfoWithNetWork];

}
- (void)setupTableView{
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 280) style:UITableViewStylePlain];
    tableView.backgroundColor = [HXColor colorWithHexString:@"#f4f5f9"];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
}
#pragma mark --  UITableView数据源
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
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
    [cell addSubview:lineView];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {//实名认证
        if ([[CurrentUserInformation sharedCurrentUserInfo].huishangshiming integerValue]==1) {
            ShowImportErrorAlertView(@"您已通过实名认证");
        }
        else
        {
            /*
            NSString *url=[NSString stringWithFormat:@"%@?user_id=%@",realNameAuthenKaihuURL,[CurrentUserInformation sharedCurrentUserInfo].userId];
    
            WLZhuCeViewController *viewController = [[WLZhuCeViewController alloc]init];
            viewController.shareURL = url;
            viewController.navTitle = @"实名认证";
            viewController.comeForm = 5;
            viewController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:viewController animated:YES];
            
            */
  //          [[CurrentUserInformation sharedCurrentUserInfo]checkUserInfoWithNetWork];

            
            
                FMTieBankCardViewController *tieBank = [[FMTieBankCardViewController alloc]init];
                tieBank.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:tieBank animated:YES];
        

            
        }

    }else if (indexPath.row == 1){//修改手机号码
        
        WLChangePhoneNumberViewController * changePhone = [[WLChangePhoneNumberViewController alloc]init];
        [self.navigationController pushViewController:changePhone animated:YES];
        
    }else if (indexPath.row == 2){// 修改登录密码
        
        if (![CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
            [self checkUserIsLogin];
            return;
        }
        SetUpPasswordController *viewController=[[SetUpPasswordController alloc]init];
        [self.navigationController pushViewController:viewController animated:YES];
    
    }else if (indexPath.row == 3){//修改交易密码
        
//        NSString *url=[NSString stringWithFormat:@"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/myyujin?user_id=%@",[CurrentUserInformation sharedCurrentUserInfo].userId];
//    //    NSLog(@"托管账户url ===== %@",url);
//        ShareViewController *viewController = [[ShareViewController alloc]initWithTitle:@"托管账户" AndWithShareUrl:url];
//        viewController.hidesBottomBarWhenPushed=YES;
//        [self.navigationController pushViewController:viewController animated:YES];
//
        if ([[CurrentUserInformation sharedCurrentUserInfo].weishangbang intValue] == 0) {
            
            FMWeakSelf;
            [FMRTAddCardToView showWithAddBtn:^{
                FMTieBankCardViewController *rechargeController = [[FMTieBankCardViewController alloc] init];
                rechargeController.hidesBottomBarWhenPushed=YES;
                [weakSelf.navigationController pushViewController:rechargeController animated:YES];
            }];
        }else{
            FMRTChangeTradeKeyViewController *tradeKeyVC = [[FMRTChangeTradeKeyViewController alloc]init];
            tradeKeyVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:tradeKeyVC animated:YES];
         }

    }else if (indexPath.row == 4){//修改手势密码
        
        GesturerViewController *viewController=[[GesturerViewController alloc]init];
        viewController.hidesBottomBarWhenPushed=YES;
        viewController.enterStyleForPush = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

/**
 *通知方法 跳转到登录页面
 */
-(void)notice{
    
    LoginController *registerController = [[LoginController alloc] init];
    FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
    [self presentViewController:navController animated:NO completion:nil];
}

- (void)checkUserIsLogin {
    
    LoginController *loginController = [[LoginController alloc] init];
    FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:loginController];
    [self presentViewController:navController animated:YES completion:^{
        [self.tabBarController setSelectedIndex:0];
    }];
}


@end
