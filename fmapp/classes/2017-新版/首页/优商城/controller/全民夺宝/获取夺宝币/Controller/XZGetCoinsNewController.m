//
//  XZGetCoinsNewController.m
//  fmapp
//
//  Created by admin on 16/10/27.
//  Copyright © 2016年 yk. All rights reserved.
//  获取夺宝币

#import "XZGetCoinsNewController.h"
#import "XZMySnatchCell.h" 
#import "XZIntegralExchangeNewController.h" // 积分兑换
#import "XZActivityModel.h" // 分享model
#import "WLPublishSuccessViewController.h" // 分享
#import "ShareViewController.h" // web页
//#import "ProjectDetailController.h"
// 项目信息
#import "WLNewProjectDetailViewController.h"
#import "FMRTAllTakeNewBuyViewController.h" // 购买夺宝币
#import "XZDetailInstructionsController.h"//  详细说明
#import "AppDelegate.h"
#import "XZShareView.h" // 分享成功

// 转发邀请
#define kXZInviteFriendsUrl [NSString stringWithFormat:@"%@/public/other/getShareInfo",kXZTestEnvironment]
// @"http://114.55.115.60:18080/public/other/getShareInfo"

// 注资专标
#define kXZRegisteredDesignedUrl @"https://www.rongtuojinrong.com/rongtuoxinsoc/lend/duobaobiao"

@interface XZGetCoinsNewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableGetCoins;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) XZShareView *share;
@end

@implementation XZGetCoinsNewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [self settingNavTitle:@"获取夺宝币"];
    [self.view addSubview:self.tableGetCoins];
}

#pragma mark ----- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZMySnatchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XZMySnatchCell"];
    if (!cell) {
        cell = [[XZMySnatchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XZMySnatchCell"];
    }
    if (indexPath.section == 0) {
        NSDictionary *dic = self.dataArr[indexPath.row];
        cell.imgPhoto.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",dic[@"image"]]];
        cell.labelTitle.text = [NSString stringWithFormat:@"%@",dic[@"title"]];
    }else {
        NSDictionary *dict = self.dataArr[self.dataArr.count - 1];
        cell.imgPhoto.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",dict[@"image"]]];
        cell.labelTitle.text = [NSString stringWithFormat:@"%@",dict[@"title"]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: // 积分兑换
            {
             XZIntegralExchangeNewController *intergralExchange = [[XZIntegralExchangeNewController alloc] init];
                intergralExchange.isCoinExchange = YES;
             [self.navigationController pushViewController:intergralExchange animated:YES];
            }
                break;
            case 1: // 注资专标
            {
                [self getRegisteredDesignedStandardDataFromNet];
                
            }
                break;
            case 2: // 转发邀请
            {
                [self getForwardingDataFromNet];
            }
                break;
            case 3: // 现金购买
            {
                [self didClickCashToBuy];
            }
                break;
            default:
                break;
        }
    }else { // 详细说明
//        NSLog(@"点击了’详细说明’按钮");
        XZDetailInstructionsController *detailIns = [[XZDetailInstructionsController alloc] init];
        [self.navigationController pushViewController:detailIns animated:YES];
    }
}

// 请求"注册专标"的数据
- (void)getRegisteredDesignedStandardDataFromNet {
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    // /appid/jizhang/user_id/191/shijian/1455779558/token/c2a6ae8dc4835ac377419dc14eb75787
    NSDictionary * parameter = @{
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 };
    __weak __typeof(&*self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:kXZRegisteredDesignedUrl parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (response.code == WebAPIResponseCodeSuccess) {
            if (response.responseObject != nil) {
                NSDictionary *dataDict = response.responseObject[@"data"];
                if ([dataDict isKindOfClass:[NSDictionary class]]) {
                    NSNumber *statusNum = dataDict[@"webxianshi"];
                    NSString *webUrl = [NSString stringWithFormat:@"%@",dataDict[@"weburl"]];
                    NSString *rongzifangshi = [NSString stringWithFormat:@"%@",dataDict[@"rongzifangshi"]];
                    NSString *jie_id = [NSString stringWithFormat:@"%@",dataDict[@"jie_id"]];
                    NSNumber *kaishicha = dataDict[@"kaishicha"];
                    NSNumber *zhuangtai = dataDict[@"zhuangtai"];
                    if ([statusNum integerValue] == 1) { // 加载web页
                        ShareViewController *shareVC = [[ShareViewController alloc]initWithTitle:@"注资专标" AndWithShareUrl:webUrl];
                        [self.navigationController pushViewController:shareVC animated:YES];
                    }else if ([statusNum integerValue] == 2) { // 调原生
                        if([zhuangtai integerValue] == 4 || [zhuangtai integerValue] == 6 || [zhuangtai integerValue]== 8)
                        {
                            WLNewProjectDetailViewController *viewController=[[WLNewProjectDetailViewController alloc]initWithUserOperationStyle:ProjectFinishOperationStyle WithProjectId:jie_id];
                            viewController.rongzifangshi = rongzifangshi;
                            viewController.NoCreateRightBtn = YES; // 不创建分享按钮
                            viewController.hidesBottomBarWhenPushed=YES;
                            [self.navigationController pushViewController:viewController animated:YES];
                        }
                        else
                        {
                            if (kaishicha > 0) {
                                WLNewProjectDetailViewController *viewController=[[WLNewProjectDetailViewController alloc]initWithUserOperationStyle:ProjectStartOperationStyle WithProjectId:jie_id];
                                viewController.rongzifangshi = rongzifangshi;
                                viewController.NoCreateRightBtn = YES; // 不创建分享按钮
                                viewController.hidesBottomBarWhenPushed=YES;
                                [self.navigationController pushViewController:viewController animated:YES];
                            }
                            else
                            {
                                WLNewProjectDetailViewController *viewController=[[WLNewProjectDetailViewController alloc]initWithUserOperationStyle:ProjectInprogressOperationStyle WithProjectId:jie_id];
                                viewController.NoCreateRightBtn = YES; // 不创建分享按钮
                                viewController.rongzifangshi = rongzifangshi;
                                viewController.hidesBottomBarWhenPushed=YES;
                                [self.navigationController pushViewController:viewController animated:YES];
                            }
                        }
                    }
                }
            }else{
                ShowAutoHideMBProgressHUD(weakSelf.view,@"请求注册专标数据失败");
            }
        }
    }];
}

#pragma mark ---- 请求"转发邀请"的数据
- (void)getForwardingDataFromNet {
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"flag":@"newon_invite"
                                 };
    __weak __typeof(&*self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:kXZInviteFriendsUrl parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (response.code == WebAPIResponseCodeSuccess) {
            if (response.responseObject != nil) {
                NSDictionary *dataDict = response.responseObject[@"data"];
                if ([dataDict isKindOfClass:[NSDictionary class]]) {
                    // 数据请求成功XZIndianaCurrencyViewController
                    XZActivityModel *modelForwarding = [[XZActivityModel alloc] init];
                    modelForwarding.shareurl = [NSString stringWithFormat:@"%@?appid=huiyuan&token=%@&shijian=%@&user_id=%@&flag=%@",dataDict[@"link"],tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId,@"9"];
                    modelForwarding.sharepic = dataDict[@"img"];
                    modelForwarding.sharecontent = dataDict[@"content"];
                    modelForwarding.sharetitle = dataDict[@"title"];
                    // 数据请求成功，添加分享界面
                    if (modelForwarding.sharetitle.length != 0) {
                        self.share.modelShare = modelForwarding;
                        [self.view addSubview:[self.share retViewWithSelf]];
                    }
                }
            }else{
                ShowAutoHideMBProgressHUD(weakSelf.view,@"加载转发数据失败");
            }
        }else {
            ShowAutoHideMBProgressHUD(weakSelf.view,@"加载转发数据失败");
        }
    }];
}

// 点击“现金购买”
- (void)didClickCashToBuy {
    FMRTAllTakeNewBuyViewController *buyVC = [[FMRTAllTakeNewBuyViewController alloc]init];
    __strong FMRTAllTakeNewBuyViewController *VC = buyVC;
    buyVC.view.backgroundColor = [UIColor clearColor];
    __weak typeof (self)weakSelf = self;
    buyVC.dismissBlock = ^() {
        // 获取数据
        [VC dismissViewControllerAnimated:YES completion:nil];
    };
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        buyVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        [weakSelf.navigationController presentViewController:buyVC animated:YES completion:^{
        }];
    }else{
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        appdelegate.window.rootViewController.modalPresentationStyle=UIModalPresentationCurrentContext;
        [appdelegate.window.rootViewController presentViewController:buyVC animated:YES completion:^{
            buyVC.view.backgroundColor=[UIColor clearColor];
            appdelegate.window.rootViewController.modalPresentationStyle=UIModalPresentationFullScreen;
        }];
    }
}
#pragma mark --- 懒加载
- (UITableView *)tableGetCoins {
    if (!_tableGetCoins) {
        _tableGetCoins = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 64) style:UITableViewStylePlain];
        _tableGetCoins.delegate = self;
        _tableGetCoins.dataSource  = self;
        _tableGetCoins.backgroundColor = XZColor(229, 233, 242);
        _tableGetCoins.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableGetCoins.showsVerticalScrollIndicator = NO;
    }
    return _tableGetCoins;
}

- (XZShareView *)share {
    if (!_share) {
        _share = [[XZShareView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight)];
        __weak __typeof(&*self.share)weakShare = self.share;
        __weak __typeof(&*self)weakSelf = self;
        _share.blockShareAction = ^(UIButton *button){
            [weakShare shareAction:button handlerDelegate:weakSelf];
        };
        _share.blockShareSuccess = ^ { // 分享成功的回调
            int timestamp = [[NSDate date] timeIntervalSince1970];
            NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
            NSString *tokenlow=[token lowercaseString];
            // trench：幸运大抽奖渠道。share：分享 invite：邀请
            NSString *url = [NSString stringWithFormat:@"%@/slots/index.html?user_id=%@&token=%@&trench=share",kXZShareCallBackUrl,[CurrentUserInformation sharedCurrentUserInfo].userId,tokenlow];
            ShareViewController *shareVC = [[ShareViewController alloc]initWithTitle:@"幸运大抽奖" AndWithShareUrl:url];
            [weakSelf.navigationController pushViewController:shareVC animated:YES];
        };
    }
    return _share;
}

- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = @[
                     @{@"image":@"全新积分",@"title":@"积分兑换"},
                     @{@"image":@"注资专标",@"title":@"注资专标"},
                     @{@"image":@"转发邀请",@"title":@"转发邀请"},
                     @{@"image":@"现金购买",@"title":@"现金购买"},
                     @{@"image":@"详细说明",@"title":@"详细说明"}
                     ];
    }
    return _dataArr;
}

@end
