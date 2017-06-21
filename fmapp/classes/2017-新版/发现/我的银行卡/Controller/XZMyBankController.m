//
//  XZMyBankController.m
//  fmapp
//
//  Created by admin on 2017/5/31.
//  Copyright © 2017年 yk. All rights reserved.
//  我的银行卡

#import "XZMyBankController.h"
#import "XZMyBankHeader.h" // 绑定银行卡cell
#import "FMTieBankCardViewController.h" // 绑定银行卡
#import "XZChangeBankCell.h" // 更换手机卡
#import "XZMyBankFooter.h" // footer
#import "YYChangeBankCardViewController.h" // 更换银行卡
#import "XZMyBankModel.h" // model

#import "XZBankRechargeModel.h"
#import "YYWarmPromptView.h" // 当账户中有余额时的"温馨提示"

@interface XZMyBankController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableMyBank;

@property (nonatomic, strong) XZMyBankHeader *headerChangeBank;

@property (nonatomic, strong) XZMyBankFooter *footerChangeBank;

//@property (nonatomic, strong) NSMutableArray *arrRechargeBank;

@property (nonatomic, strong) XZMyBankModel *modelMyBank;

@property (nonatomic, strong) XZBankRechargeUserModel *modelBankUser;
@end

@implementation XZMyBankController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [self settingNavTitle:@"我的银行卡"];
    self.view.backgroundColor = [HXColor colorWithHexString:@"#f4f5f9"];
    //
    [self.view addSubview:self.tableMyBank];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //
    [self getMyBankDataFromNetwork];
}

#pragma mark ---- 获取我的银行卡列表数据
- (void)getMyBankDataFromNetwork {
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow = [token lowercaseString];
    
    NSDictionary *parameter = @{
                                @"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                @"AppId":@"huiyuan",
                                @"AppTime":[NSNumber numberWithInt:timestamp],
                                @"Token":tokenlow,
                                @"FlagChnl":@"1"
                                };
    __weak __typeof(&*self)weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // kXZRechargeUrl
    [FMHTTPClient postPath:kXZUniversalTestUrl(@"LLQueryCard") parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        NSLog(@"我的银行卡页面数据：======= %@",response.responseObject);
        if (response.responseObject) {
//            [weakSelf.arrRechargeBank removeAllObjects];
            if (response.code == WebAPIResponseCodeSuccess) {
                NSDictionary *data = response.responseObject[@"data"];
                if ([data isKindOfClass:[NSDictionary class]]) {
                    XZMyBankModel *modelMyBank = [[XZMyBankModel alloc] init];
                    [modelMyBank setValuesForKeysWithDictionary:data];
                    weakSelf.modelMyBank = modelMyBank;
//                    [weakSelf.arrRechargeBank addObject:modelMyBank];
                }
            }
        }

        if (weakSelf.modelMyBank.No.length > 0) { // 有银行卡
            [weakSelf.headerChangeBank removeFromSuperview];
            weakSelf.headerChangeBank = nil;
            weakSelf.tableMyBank.tableFooterView = weakSelf.footerChangeBank;
            weakSelf.tableMyBank.tableHeaderView = nil;
        }else { // 没有银行卡
            weakSelf.tableMyBank.tableHeaderView = weakSelf.headerChangeBank;
            [weakSelf.footerChangeBank removeFromSuperview];
            weakSelf.footerChangeBank = nil;
            weakSelf.tableMyBank.tableFooterView = nil;
        }
        
        [weakSelf.tableMyBank reloadData];
    }];
}

#pragma mark ---- 获取账户资产数据
- (void)getUserTotalMoneyData {
    
    __weak __typeof(&*self)weakSelf = self;
    int timestamp = [[NSDate date] timeIntervalSince1970];
    
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow = [token lowercaseString];
    NSDictionary *parameter = @{
                                @"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                @"AppId":@"huiyuan",
                                @"AppTime":[NSNumber numberWithInt:timestamp],
                                @"Token":tokenlow,
                                @"FlagChnl":@1
                                };
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // kXZRechargeUrl
    [FMHTTPClient postPath:kXZUniversalTestUrl(@"LLQueryEBankAcct") parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        NSLog(@"用户账户信息数据 ======= %@",response.responseObject);
        if (response.responseObject) {
            if (response.code == WebAPIResponseCodeSuccess) {
                NSDictionary *data = response.responseObject[@"data"];
                if ([data isKindOfClass:[NSDictionary class]]) {
                    self.modelBankUser = [[XZBankRechargeUserModel alloc] init];
                    [self.modelBankUser setValuesForKeysWithDictionary:data];
                    
                    if (weakSelf.modelBankUser.acctAmtTotal > 0) {
                        // 当前账户有余额，不可更换银行卡
                        [weakSelf whenHaveMoneyInAccount];
                    }else {
                        // 当前账户没有余额，可更换银行卡
                        YYChangeBankCardViewController *changeBankVC = [[YYChangeBankCardViewController alloc] init];
                        changeBankVC.modelMyBank = weakSelf.modelMyBank;
                        [weakSelf.navigationController pushViewController:changeBankVC animated:YES];
                    }
                    
                }else {
                    ShowAutoHideMBProgressHUD(weakSelf.view, response.responseObject[@"msg"]);
                }
            }else {
                ShowAutoHideMBProgressHUD(weakSelf.view, response.responseObject[@"msg"]);
            }
        }else {
            ShowAutoHideMBProgressHUD(weakSelf.view, @"数据加载失败");
        }
    }];
    
}

// 更换银行卡
-(void)whenHaveMoneyInAccount
{
    YYWarmPromptView *warmView = [[YYWarmPromptView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight)];
    
    warmView.modelBankUser = self.modelBankUser;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:warmView];
    
    NSLog(@"%s",__func__);
}

#pragma mark ----- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.modelMyBank.No.length > 0) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.modelMyBank.No.length > 0) {
        XZChangeBankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XZChangeBankCell"];
        if (!cell) {
            cell = [[XZChangeBankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XZChangeBankCell"];
        }
        if (self.modelMyBank.No) {
            cell.modelMyBank = self.modelMyBank;
        }
        return cell;
    }else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.modelMyBank.No.length > 0) {
        return 140;
    }
    return 0.001f;
}

#pragma mark ---- 懒加载
- (UITableView *)tableMyBank {
    if (!_tableMyBank) {
        _tableMyBank = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 64) style:UITableViewStylePlain];
        _tableMyBank.delegate = self;
        _tableMyBank.dataSource  = self;
        _tableMyBank.backgroundColor = [HXColor colorWithHexString:@"#f4f5f9"];
        _tableMyBank.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableMyBank.showsVerticalScrollIndicator = NO;
        _tableMyBank.scrollEnabled = NO;
    }
    return _tableMyBank;
}

- (XZMyBankFooter *)footerChangeBank {
    if (!_footerChangeBank) {
        _footerChangeBank = [[XZMyBankFooter alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 100)];
        // 点击"更换银行卡"
        __weak __typeof(&*self)weakSelf = self;
        
        _footerChangeBank.blockChangeBank = ^{
            // 获取账户资产数据
            [weakSelf getUserTotalMoneyData];
        };
    }
    return _footerChangeBank;
}

- (XZMyBankHeader *)headerChangeBank {
    if (!_headerChangeBank) {
        _headerChangeBank = [[XZMyBankHeader alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenWidth * 324 / 730.0 + 20)];
    }
    
    __weak __typeof(&*self)weakSelf = self;
    _headerChangeBank.blockCoverButton = ^{
        FMTieBankCardViewController *tieBank = [[FMTieBankCardViewController alloc] init];
        [weakSelf.navigationController pushViewController:tieBank animated:YES];
    };
    return _headerChangeBank;
}


//- (NSMutableArray *)arrRechargeBank {
//    if (!_arrRechargeBank) {
//        _arrRechargeBank = [NSMutableArray array];
//    }
//    return _arrRechargeBank;
//}

@end
