//
//  XZMySnatchController.m
//  fmapp
//
//  Created by admin on 16/10/13.
//  Copyright © 2016年 yk. All rights reserved.
//  我的夺宝

#import "XZMySnatchController.h"
#import "XZMySnatchHeaderView.h" // 头视图
#import "XZMySnatchCell.h" // cell
#import "XZGetCoinsNewController.h" //  获取夺宝币
#import "XZIndianaCurrencyModel.h" // model
#import "YYParticipationRecordViewController.h" // 参与记录
#import "YYRechargeRecordViewController.h" // 充值记录
#import "YYMyOrderNewController.h" // 我的订单
// 头部数据
#define kXZMySnatchControllerUrl [NSString stringWithFormat:@"%@/public/newon/coin/getUserWonAccount",kXZTestEnvironment]
// 是否有未读消息
#define kXZUnreadNewsUrl [NSString stringWithFormat:@"%@/public/newon/show/getFontPageInfo",kXZTestEnvironment]

@interface XZMySnatchController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableMySnatch;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) XZIndianaCurrencyModel *modelMySnath;
@property (nonatomic, strong) XZMySnatchHeaderView *mySnatch;
// 是否有中奖记录
@property (nonatomic, strong) NSString *is_unread_record;
// 从获取夺宝币界面回来，要刷新页面
@property (nonatomic, assign) BOOL isGetCoinBack;
@end

@implementation XZMySnatchController
- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = @[
                     @{@"image":@"参与记录_11",@"title":@"参与记录"},
                     @{@"image":@"充值记录icon_14",@"title":@"充值记录"},
                     @{@"image":@"我的订单icon_16",@"title":@"我的订单"}
                    ];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [self settingNavTitle:@"我的夺宝"];
    [self.view addSubview:self.tableMySnatch];
    // 请求我的夺宝的数据
    [self getMySnathDataFromNetWork];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isGetCoinBack) {
        // 请求我的夺宝的数据
        [self getMySnathDataFromNetWork];
    }
}

#pragma mark ----- 请求我的夺宝的数据
- (void)getMySnathDataFromNetWork {
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 };
    __weak __typeof(&*self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:kXZMySnatchControllerUrl parameters:parameter completion:^(WebAPIResponse *response) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (response.code == WebAPIResponseCodeSuccess) {
            if (![response.responseObject isKindOfClass:[NSNull class]]) {
                // 请求未读消息的数据
                [self getUnreadNewsData];
                //
                NSDictionary *dataDict = response.responseObject[@"data"];
                weakSelf.modelMySnath = [[XZIndianaCurrencyModel alloc] init];
                [weakSelf.modelMySnath setValuesForKeysWithDictionary:dataDict];
                // 给头视图赋值
                weakSelf.mySnatch.modelMySnatch = weakSelf.modelMySnath;
            }
        }
        else{ // 请求失败
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            ShowAutoHideMBProgressHUD(weakSelf.view,@"加载数据失败");
        }
    }];
}

// 请求未读消息的数据
- (void)getUnreadNewsData {
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary *parameters = @{
                                 @"appid":@"huiyuan",
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 };
    __weak typeof (self)weakSelf = self;
    [FMHTTPClient postPath:kXZUnreadNewsUrl parameters:parameters completion:^(WebAPIResponse *response) {
//        NSLog(@"%@",response.responseObject);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (response.code == WebAPIResponseCodeSuccess) {
            NSDictionary *dataDict = response.responseObject[@"data"];
            if (![dataDict isKindOfClass:[NSNull class]]) {
                // 是否有未读中奖记录 0：无 1：有
                weakSelf.is_unread_record = [NSString stringWithFormat:@"%@",dataDict[@"is_unread_record"]];
            }
        }
        [weakSelf.tableMySnatch reloadData];
    }];
}

#pragma mark ----- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.dataArr.count - 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZMySnatchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mySnatchCell"];
    if (!cell) {
        cell = [[XZMySnatchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mySnatchCell"];
    }
    if (indexPath.section == 0) {
        NSDictionary *dic = self.dataArr[indexPath.row];
        cell.imgPhoto.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",dic[@"image"]]];
        cell.labelTitle.text = [NSString stringWithFormat:@"%@",dic[@"title"]];
    }else {
        NSDictionary *dict = self.dataArr[self.dataArr.count - 1];
        cell.imgPhoto.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",dict[@"image"]]];
        cell.labelTitle.text = [NSString stringWithFormat:@"%@",dict[@"title"]];
        if ([self.is_unread_record integerValue] == 1) {
            // 是否有未读中奖记录 0：无 1：有
            cell.imgUnread.image = [UIImage imageNamed:@"crowdfund_red_icon"];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.isGetCoinBack = NO;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                YYParticipationRecordViewController *participation = [[YYParticipationRecordViewController alloc] init];
                [self.navigationController pushViewController:participation animated:YES];
            }
                break;
            case 1:
            {
                YYRechargeRecordViewController *rechargeRecord = [[YYRechargeRecordViewController alloc] init];
                [self.navigationController pushViewController:rechargeRecord animated:YES];
            }
                break;
            default:
                break;
        }
    }else {
        // 置为已读
        XZMySnatchCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.imgUnread.image = [UIImage imageNamed:@""];
        
        YYMyOrderNewController *myOrderNew = [[YYMyOrderNewController alloc] init];
        [self.navigationController pushViewController:myOrderNew animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

#pragma mark ---- 懒加载
- (UITableView *)tableMySnatch {
    if (!_tableMySnatch) {
        _tableMySnatch = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 64) style:UITableViewStyleGrouped];
        _tableMySnatch.delegate = self;
        _tableMySnatch.dataSource  = self;
        _tableMySnatch.backgroundColor = KDefaultOrBackgroundColor;
        _tableMySnatch.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableMySnatch.showsVerticalScrollIndicator = NO;
        _tableMySnatch.tableHeaderView = self.mySnatch;
    }
    return _tableMySnatch;
}

- (XZMySnatchHeaderView *)mySnatch {
    if (!_mySnatch) {
        _mySnatch = [[XZMySnatchHeaderView alloc] initWithFrame:CGRectMake(0, 10, KProjectScreenWidth, 75)];
        __weak typeof (self)weakSelf = self;
        _mySnatch.blockMySnatchHeader = ^(UIButton *button){
            XZGetCoinsNewController *getCoins = [[XZGetCoinsNewController alloc] init];
            weakSelf.isGetCoinBack = YES;
            [weakSelf.navigationController pushViewController:getCoins animated:YES];
        };
    }
    return _mySnatch;
}
@end
