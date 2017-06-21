//
//  XZGetTogetherViewController.m
//
//  Created by admin on 16/6/22.
//  Copyright © 2016年 admin. All rights reserved.
//  聚一聚首页---聚会交友

#import "XZGetTogetherViewController.h"
#import "XZGetTogetherCell.h"
#import "XZLargeButton.h"
#import "WLOrganizationViewController.h"
#import "XZGetTogetherModel.h"
#import "XZTabBar.h"
//#import "WLExchangeViewController.h"
#import "WLTheManageViewController.h"//我的发布
#import "XZActivityViewController.h" // 活动
#import "XZSignUpView.h" // 报名界面
#import "YSMyParticipationViewController.h" // 我的参与
#import "WLAllklBodyViewController.h"
#import "WLNewServiceAndAgreementViewController.h"
#import "DataStoreHelper.h"

#define GetTotherURL @"https://www.rongtuojinrong.com/rongtuoxinsoc/Juyijuparty/indexapp"

@interface XZGetTogetherViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableList;
@property (nonatomic, strong) NSMutableArray *arrGetTother;
@property (nonatomic, assign) NSInteger currentPage;
/** 报名界面 */
@property (nonatomic, strong) XZSignUpView *signUpView;
/** 背景图 */
@property (nonatomic, strong) UIView *viewBackGround;

@end

@implementation XZGetTogetherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XZColor(230, 235, 240);
    self.tableList.backgroundColor = XZColor(230, 235, 240);
    [self settingNavTitle:@"聚一聚"];
    [self createTabBar];
    self.currentPage = 1;
    // 加载数据
    [self getDataFromLocalFile];
}

// 从本地获取数据
- (void)getDataFromLocalFile {
    NSArray *tempArr = [[DataStoreHelper shareDataStore] valueWithKey:@"arrGetTother"];
//    NSLog(@"tempArr:%@ ====== count:%ld",tempArr,(unsigned long)tempArr.count);
    if (tempArr.count != 0) { // 有缓存，加载缓存
        //从数组中读取对象
        for (XZGetTogetherModel *modelGetTogether in tempArr) {
            [self.arrGetTother addObject:modelGetTogether];
        }
        [self.tableList reloadData];
    }
    [self requestGetTotherData];
}

#pragma mark ----- 请求数据
- (void)requestGetTotherData {
    int timestamp = [[NSDate date] timeIntervalSince1970];
   
//    NSDictionary *parameter = [NSDictionary dictionary];
    
     NSString *useId = [CurrentUserInformation sharedCurrentUserInfo].userId ? [CurrentUserInformation sharedCurrentUserInfo].userId : @"0";
    
//    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) { // 已登录
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",useId,timestamp]);
    
    NSString *tokenlow=[token lowercaseString];
   NSDictionary *parameter = @{
                             @"user_id":useId,
                             @"appid":@"huiyuan",
                             @"shijian":[NSNumber numberWithInt:timestamp],
                             @"token":tokenlow,
                             @"c_page":[NSString stringWithFormat:@"%ld",(long)self.currentPage]
                             };
//    }else {
//        NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",@"0",timestamp]);
//        
//        NSString *tokenlow=[token lowercaseString];
//        parameter = @{
//                      @"user_id":@"0",
//                      @"appid":@"huiyuan",
//                      @"shijian":[NSNumber numberWithInt:timestamp],
//                      @"token":tokenlow,
//                      @"c_page":[NSString stringWithFormat:@"%ld",(long)self.currentPage]
//                      };
//    }
//    
    __weak __typeof(&*self)weakSelf = self;
    
    [FMHTTPClient postPath:GetTotherURL parameters:parameter completion:^(WebAPIResponse *response) {
        if (!response.responseObject) {
            ShowAutoHideMBProgressHUD(weakSelf.view,@"当前网络不佳！");
        }else {
            if (response.code == WebAPIResponseCodeSuccess) {
                if (response.responseObject != nil) {
                    if (weakSelf.currentPage == 1) {
                        [weakSelf.arrGetTother removeAllObjects];
                    }
                    if (![response.responseObject[@"data"] isKindOfClass:[NSNull class]]) {
                        NSArray *dataArray = response.responseObject[@"data"];
                        if (dataArray.count != 0) { // data中有值
                            for (NSDictionary *dict in dataArray) {
                                XZGetTogetherModel *modelGetTogether = [[XZGetTogetherModel alloc]init];
                                [modelGetTogether setValuesForKeysWithDictionary:dict];
                                [self.arrGetTother addObject:modelGetTogether];
                            }
                            if (weakSelf.currentPage == 1) {
                                // 存储第一页的数据
                                if (weakSelf.arrGetTother.count != 0) {
                                    //数组的存储
                                    [[DataStoreHelper shareDataStore] storeValue:weakSelf.arrGetTother withKey:@"arrGetTother"];
                                }
                            }
                        }else {
                            ShowAutoHideMBProgressHUD(weakSelf.view,@"请重新加载");
                        }
                    }
                }else{
                    ShowAutoHideMBProgressHUD(weakSelf.view,@"请重新加载");
                }
            }
            else {
                NSArray *tempArr = [[DataStoreHelper shareDataStore] valueWithKey:@"arrGetTother"];
                if (tempArr.count != 0) { // 有缓存，加载缓存
                    [weakSelf.arrGetTother removeAllObjects];
                    //从数组中读取对象
                    for (XZGetTogetherModel *modelGetTogether in tempArr) {
                        [weakSelf.arrGetTother addObject:modelGetTogether];
                    }
                }
                //            [weakSelf.tableList reloadData];
            }
        }
        [weakSelf.tableList.mj_header endRefreshing];
        [weakSelf.tableList.mj_footer endRefreshing];
        [weakSelf.tableList reloadData];
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrGetTother.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        XZGetTogetherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"getTogether"];
        if (!cell) {
            cell = [[XZGetTogetherCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"getTogether"];
        }
        XZGetTogetherModel *modelGetother = self.arrGetTother[indexPath.row];
        cell.modelTother = modelGetother;
        // 点击“发布活动”
        cell.blockBtnPublish = ^(UIButton *button) {
            [self jumpToControllerWithIndexPath:indexPath];
            
        };
        return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self jumpToControllerWithIndexPath:indexPath];
}

- (void)jumpToControllerWithIndexPath:(NSIndexPath *)indexPath {
    XZGetTogetherModel *modelGetother = self.arrGetTother[indexPath.row];
    XZActivityViewController *activityVc = [[XZActivityViewController alloc]init];
    activityVc.pid = modelGetother.pid;
    
    [self.navigationController pushViewController:activityVc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (KProjectScreenWidth * 5/8) + 95;
}

#pragma mark --- 底部的tabBar
- (void)createTabBar {
    XZTabBar *tabBar = [[XZTabBar alloc] initWithFrame:CGRectMake(0, KProjectScreenHeight - 113, KProjectScreenWidth, 49)];
    
    __weak __typeof(&*self)weakSelf = self;
    tabBar.blockTabBarBtn = ^(UIButton *button) {
        if (button.tag == 100) { // 发布
            [weakSelf DetermineWhetherTheLogin:^{
                WLOrganizationViewController *organization = [[WLOrganizationViewController alloc]init];
                [weakSelf.navigationController pushViewController:organization animated:YES];
            }];
        }else if (button.tag == 101) { // 我的参与
            [weakSelf DetermineWhetherTheLogin:^{
                YSMyParticipationViewController *myParticipation = [[YSMyParticipationViewController alloc]init];
                [weakSelf.navigationController pushViewController:myParticipation animated:YES];
            }];
        }else { // 我的发布
            [weakSelf DetermineWhetherTheLogin:^{
                WLTheManageViewController *vc = [[WLTheManageViewController alloc]init];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }];
        }
    };
    [self.view addSubview:tabBar];
}

#pragma mark ----- 判断是否登录
- (void)DetermineWhetherTheLogin:(void(^)()) block {
    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) { // 已登录
        block();
    }else {// 未登录
        LoginController *registerController = [[LoginController alloc] init];
        FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
        [self.navigationController presentViewController:navController animated:YES completion:^{
        }];
    }
}

#pragma mark ---- 懒加载arrGetTother、tableList、signUpView
- (NSMutableArray *)arrGetTother {
    if (!_arrGetTother) {
        _arrGetTother = [NSMutableArray array];
    }
    return _arrGetTother;
}

- (UITableView *)tableList {
    if (!_tableList) {
        _tableList = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width - 20, [UIScreen mainScreen].bounds.size.height - 113) style:UITableViewStylePlain];
        _tableList.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableList.delegate = self;
        _tableList.dataSource = self;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width - 20 , 20)];
        label.backgroundColor = XZColor(230, 235, 240);
        _tableList.showsVerticalScrollIndicator = NO;
        _tableList.tableFooterView = label;
        [self.view addSubview:_tableList];
        __weak __typeof(&*self)weakSelf = self;
        // 刷新
        _tableList.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.currentPage = 1;
            // 请求数据
            [weakSelf requestGetTotherData];
        }];
        _tableList.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            weakSelf.currentPage = weakSelf.currentPage+1;
            // 请求数据
            [weakSelf requestGetTotherData];
        }];
    }
    return _tableList;
}

- (XZSignUpView *)signUpView {
    if (!_signUpView) {
        _signUpView = [[XZSignUpView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        __weak __typeof(&*self)weakSelf = self;
        _signUpView.btnTitle = @"提交";
        _signUpView.blockCloseBtn = ^(UIButton *button) {
            [weakSelf.viewBackGround removeFromSuperview];
        };
    }
    return _signUpView;
}


@end
