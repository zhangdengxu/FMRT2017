//
//  XZBankRechargeController.m
//  fmapp
//
//  Created by admin on 17/5/10.
//  Copyright © 2017年 yk. All rights reserved.
//  徽商充值页面

#import "XZBankRechargeController.h"
#import "XZBankRechargeHeader.h" // header
#import "XZBankRechargeModel.h" // 徽商充值model
#import "XZBankRechargeCell.h" // 充值cell
#import "XZBankRechargeFooter.h"// footer
#import "XZRechargeSuccessView.h" // 充值成功
#import "XZTransferRechargeView.h"//  转账充值弹窗
#import "XZTransferRechargeModel.h" // model
#import "XZPhoneBankSupportView.h" // 支持的手机银行
#import "XZPhoneBankSupportModel.h"
#import "LLPaySdk.h"
#import "XZPaymentInfoModel.h"
#import "WLChangePhoneNumberViewController.h" // 更换手机号
#pragma mark ----- 徽商充值
#import "XZMyBankController.h" //

@interface XZBankRechargeController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableRecharge;
@property (nonatomic, strong) XZBankRechargeHeader *headerRecharge;
@property (nonatomic, strong) XZBankRechargeModel *modelRecharge;
@property (nonatomic, strong) XZBankRechargeFooter *footerRecharge;
// 充值成功
@property (nonatomic, strong) XZRechargeSuccessView *successView;
// 转账充值数据
@property (nonatomic, strong) NSMutableArray *arrTransfer;
// 转账充值弹窗
@property (nonatomic, strong) XZTransferRechargeView *transferView;
// 手机银行
@property (nonatomic, strong) XZPhoneBankSupportView *phoneBankView;
//快捷充值数据
@property (nonatomic, strong) NSMutableArray *arrQuick;

// 充值金额
@property (nonatomic, strong) NSString *moneyRecharge;
// 转账充值弹窗数据
@property (nonatomic, strong) NSMutableArray *arrTransferPop;
// 银行数据
@property (nonatomic, strong) NSMutableArray *bankArr;
// 电子账户信息
@property (nonatomic, strong) XZBankRechargeUserModel *modelBankUser;

// 是快捷支付
@property (nonatomic, assign) BOOL isQuickPay;

@end

static NSString *reuseID = @"BankRechargeCell";

@implementation XZBankRechargeController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.view.backgroundColor = [HXColor colorWithHexString:@"#f4f5f9"];
    [self settingNavTitle:@"充值"];
    [self.view addSubview:self.tableRecharge];
    // 充值金额
    self.moneyRecharge = @"0.00";
    
    self.isQuickPay = NO;
    
    // 添加监听，当键盘出现时收到消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    // 添加监听，当键盘退出时收到消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getRechargeViewData];
}

#pragma mark ---- 获取充值数据
- (void)getRechargeViewData {
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow = [token lowercaseString];

    __weak __typeof(&*self)weakSelf = self;
    NSDictionary *parameter = @{
                                @"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                @"AppId":@"huiyuan",
                                @"AppTime":[NSNumber numberWithInt:timestamp],
                                @"Token":tokenlow,
                                @"FlagChnl":@"1"
                                };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // kXZRechargeUrl
    [FMHTTPClient postPath:kXZUniversalTestUrl(@"LLQueryEBankAcct") parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        NSLog(@"充值页面数据：======= %@",response.responseObject);
        
        if (response.responseObject) {
            //            [weakSelf.arrRechargeBank removeAllObjects];
            if (response.code == WebAPIResponseCodeSuccess) {
                NSDictionary *data = response.responseObject[@"data"];
                if ([data isKindOfClass:[NSDictionary class]]) {
                    weakSelf.modelBankUser = [[XZBankRechargeUserModel alloc] init];
                    [weakSelf.modelBankUser setValuesForKeysWithDictionary:data];
                    weakSelf.modelBankUser.isQuickPay = weakSelf.isQuickPay;
                    // 给充值金额重新赋值
                    weakSelf.modelBankUser.moneyRecharge = weakSelf.moneyRecharge;
                }else {
                    
                    ShowAutoHideMBProgressHUD(weakSelf.view, response.responseObject[@"msg"]);
                }
            }else {
                ShowAutoHideMBProgressHUD(weakSelf.view, response.responseObject[@"msg"]);
            }
        }
        else {
            ShowAutoHideMBProgressHUD(weakSelf.view, @"网络异常！");
        }
        weakSelf.headerRecharge.modelBankUser = weakSelf.modelBankUser;
        weakSelf.footerRecharge.modelBankUser = weakSelf.modelBankUser;
        [weakSelf.tableRecharge.mj_header endRefreshing];
        // 转账充值数据
        [weakSelf getTransferDataFormLocal];
    }];
    
}

#pragma mark ---- 获取转账充值的方式
- (void)getTransferDataFormLocal {
    
    [self.arrTransfer removeAllObjects];
    [self.arrTransferPop removeAllObjects];
    
    NSArray *arrTransferLocal = @[
                                  @{@"way":@"方式一",
                                    @"wayName":@"手机银行"
                                      },
                                  @{@"way":@"方式二",
                                    @"wayName":@"支付宝"
                                    },
                                  @{@"way":@"方式三",
                                    @"wayName":@"网上银行"
                                    },
                                  @{@"way":@"方式四",
                                    @"wayName":@"柜台办理"
                                    }
                                  ];
    for (NSDictionary *dict in arrTransferLocal) {
        XZBankRechargeModel *modelBR = [[XZBankRechargeModel alloc] init];
        [modelBR setValuesForKeysWithDictionary:dict];
        modelBR.isQuickPay = self.isQuickPay;
        [self.arrTransfer addObject:modelBR];
    }
    
    NSString *content;
    if (self.modelBankUser.acctname) {
        content = [NSString stringWithFormat:@"银行柜台转账需填写信息\n收款人：%@\n收款账号（徽商银行电子交易账号）：%@\n收款开户行：%@",self.modelBankUser.acctname,self.modelBankUser.cardnbr,self.modelBankUser.bankName];
    }else {
        content = @"银行柜台转账需填写信息\n收款人：\n收款账号（徽商银行电子交易账号）：\n收款开户行：";
    }

    NSArray *arrTransferPopLocal = @[
                                     @{
                                         @"iconName":@"微商_弹窗_手机银行",
                                         @"title":@"手机银行",
                                         @"EnglishTitle":@"M-BANKING",
                                         @"content":@"目前手机银行转账大部分免费，建议使用手机银行进行转账充值；\n\n手机银行转账需首先需在网上或银行网点开通绑卡银行的手机银行功能，并下载该银行客户端。银行客户端大部分的转账流程为：\n\n手机银行主菜单里的服务功能中点击“转账汇款”或“转账”按钮---选择银行账号转账（部分银行）---进入转账页面---输入收款人姓名，收款人账号，收款银行及转账金额，获取短信验证码----完成转账充值。",
                                         },
                                     @{
                                         @"iconName":@"微商_弹窗_支付宝",
                                         @"title":@"支付宝",
                                         @"EnglishTitle":@"ALIPAY",
                                         @"content":@"自2016年10月12日起，支付宝对个人用户超出免费额度的提现收取0.1%的服务费，个人用户每人累计享有2万元基础免费提现额度。\n\n第一步：点击支付宝所在模块立即前往文字（徽商账号已被复制），进入支付宝页面；\n\n第二步：点击转账---转账到银行卡--输入姓名、徽商银行电子交易账户账号、选择“徽商银行”、输入转账金额，完成转账操作（付款方式可选择账户余额或银行储蓄卡，余额宝不支持转账到本人银行卡服务）。",
                                         },
                                     @{
                                         @"iconName":@"微商_弹窗_网上银行",
                                         @"title":@"网上银行",
                                         @"EnglishTitle":@"E-BANKING",
                                         @"content":@"网银转账只能在电脑端操作；",
                                         },
                                     @{
                                         @"iconName":@"微商_弹窗_柜台办理",
                                         @"title":@"柜台办理",
                                         @"EnglishTitle":@"B-COUNTER",
                                         @"content":content,
                                         },
                                     ];
    
    for (NSDictionary *dict in arrTransferPopLocal) {
        XZTransferRechargeModel *modelBR = [[XZTransferRechargeModel alloc] init];
        [modelBR setValuesForKeysWithDictionary:dict];
        modelBR.contentHeight = [modelBR.content getStringCGSizeWithMaxSize:CGSizeMake(KProjectScreenWidth - 60 - 20, MAXFLOAT) WithFont:[UIFont systemFontOfSize:15.0f]].height + 50 + 50;
        [self.arrTransferPop addObject:modelBR];
    }
    
    [self.tableRecharge reloadData];
}

#pragma mark ---- 支付创单
- (void)getParameterFromNet {
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow = [token lowercaseString];
    
    // 充值金额保留2位小数 @"9933"
    NSDictionary *parameter = @{
                                @"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                @"AppId":@"huiyuan",
                                @"AppTime":[NSNumber numberWithInt:timestamp],
                                @"Token":tokenlow,
                                @"TransAmt":[NSString stringWithFormat:@"%.2f",[self.moneyRecharge floatValue]],
                                @"FlagChnl":@"1"
                                };
    __weak __typeof(&*self)weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [FMHTTPClient postPath:kXZUniversalTestUrl(@"LLNetSave") parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    
        if (response.responseObject) {
            if (response.code == WebAPIResponseCodeSuccess) {
                if ([response.responseObject objectForKey:@"data"]) {
                    NSDictionary *dataDcit = response.responseObject[@"data"];
                    if ([dataDcit isKindOfClass:[NSDictionary class]]) {
                        XZPaymentInfoModel *modelPayment = [[XZPaymentInfoModel alloc] init];
                        [modelPayment setValuesForKeysWithDictionary:dataDcit];
                        [weakSelf payWithNetWork:modelPayment];
                    }
                }
            }else {
                ShowAutoHideMBProgressHUD(weakSelf.view, response.responseObject[@"msg"]);
            }
        }
        else {
            ShowAutoHideMBProgressHUD(weakSelf.view, @"网络异常!");
        }
        
    }];
}

#pragma mark ---- 调起连连的SDK
-(void)payWithNetWork:(XZPaymentInfoModel *)modelPay
{
    // modelPay.user_id
    NSDictionary *paymentInfohehe = @{
                                       @"token":modelPay.token,
                                       @"oid_partner":modelPay.oid_partner,
                                       @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                       @"no_order":modelPay.no_order,
                                       @"money_order":[NSString stringWithFormat:@"%.2f",[self.moneyRecharge floatValue]]
                                           };
    
    NSMutableDictionary *paymentInfo = [[NSMutableDictionary alloc]initWithDictionary:paymentInfohehe];
    __weak __typeof(&*self)weakSelf = self;
    // 调用SDK充值
    [[LLPaySdk sharedSdk] payApply:[paymentInfo copy] inVC:self completion:^(LLPayResult result, NSDictionary *dic) {
        [weakSelf paymentEnd:result withResultDic:dic];
//        NSLog(@"%u",result);
    }];
}

#pragma mark ---- 支付结果分析
- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic{
    NSString *res_msg = dic[@"ret_msg"];
    switch (resultCode) {
        
        case kLLPayResultSuccess: { // "成功"
            [self.view addSubview:self.successView];
            NSLog(@"=== 充值成功 === modelBankUser.moneyRecharge:%@ ===== self.moneyRecharge:%@",self.modelBankUser.moneyRecharge,self.moneyRecharge);
            
            self.successView.modelBankUser = self.modelBankUser;
            
        } break;
        case kLLPayResultFail: { // "失败"
            [self showAlertWithMsg:res_msg title:@"充值失败" cancelTitle:@"我知道了"];
        } break;
        case kLLPayResultCancel: { // "取消"
            [self showAlertWithMsg:res_msg title:@"充值失败" cancelTitle:@"我知道了"];
        } break;
        case kLLPayResultInitError: { // "sdk初始化异常"
            [self showAlertWithMsg:res_msg title:@"充值失败" cancelTitle:@"我知道了"];
        } break;
        case kLLPayResultInitParamError: { // dic[@"ret_msg"]
            [self showAlertWithMsg:res_msg title:@"充值失败" cancelTitle:@"我知道了"];
        } break;
        default:
            break;
    }
}

- (void)showAlertWithMsg:(NSString *)showMsg  title:(NSString *)title cancelTitle:(NSString *)cancelTitle {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:showMsg delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:nil];
    [alert show];
}

#pragma mark ---- 获取快捷充值的方式
- (void)getQuickDataFormLocal {
    
    NSString *wayName = @"";
    if (self.modelBankUser.signBankCard.length > 0) {
        NSString *lastNumber = [self.modelBankUser.signBankCard substringWithRange:NSMakeRange(self.modelBankUser.signBankCard.length - 4, 4)];
        wayName = [NSString stringWithFormat:@"%@ 尾号%@",self.modelBankUser.signBankName,lastNumber];
    }
    
    NSArray *arrQuickLocal = @[
                               @{@"way":@"银行卡",
                                 @"wayName":wayName
                                },
                               @{@"way":@"金额",
                                @"wayName":@""
                                }
                              ];
    for (NSDictionary *dict in arrQuickLocal) {
        XZBankRechargeModel *modelBR = [[XZBankRechargeModel alloc] init];
        [modelBR setValuesForKeysWithDictionary:dict];
        modelBR.isQuickPay = YES;
        [self.arrQuick addObject:modelBR];
    }
}

// 当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    // 获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    [self.tableRecharge mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.height.equalTo(KProjectScreenHeight - height - 64);
        make.width.equalTo(KProjectScreenWidth);
    }];
}

// 当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [self.tableRecharge mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.height.equalTo(KProjectScreenHeight - 64);
        make.width.equalTo(KProjectScreenWidth);
    }];
}

#pragma mark ----- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isQuickPay) {
        return 2;
    }
    return self.arrTransfer.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZBankRechargeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[XZBankRechargeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    __weak __typeof(&*self)weakSelf = self;
    
    if (self.isQuickPay) { // 快捷充值
        cell.modelRecharge = self.arrQuick[indexPath.row];
        cell.blockMoney = ^(NSString *money) {
            weakSelf.moneyRecharge = money;
            weakSelf.modelBankUser.moneyRecharge = money;
        };
    }else { // 转账充值
        cell.modelRecharge = self.arrTransfer[indexPath.row];
        // 立即前往
        cell.blockImmediateGo = ^{
            UIPasteboard *paste = [UIPasteboard generalPasteboard];
            NSString *string = @"";
            if (weakSelf.modelBankUser.cardnbr) {
                string = weakSelf.modelBankUser.cardnbr;// cell的订单号
                [paste setString:string];
            }
            if (!(string.length > 0)) {
                //
                ShowAutoHideMBProgressHUD(weakSelf.view, @"电子交易账户复制失败，请刷新重试");
            }else
            {
                if (indexPath.row == 0) { // 手机银行
                    [weakSelf setUpPhoneBankData];
                }else {
                    NSURL *url = [NSURL URLWithString:@"alipay://app/"];
                    if ([[UIApplication sharedApplication] openURL:url]) {
                        // 已安装支付宝
                    }
                    else { //
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"需安装支付宝才能完成此操作" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                        [alert show];
                    }
                }
            }

        };
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isQuickPay) { // 快捷充值
       
    }
    else { // 转账充值
        [self.view addSubview:self.transferView];
        XZTransferRechargeModel *modelTransfer = self.arrTransferPop[indexPath.row];
        self.transferView.modelTransfer = modelTransfer;
        
        if (indexPath.row == 1) { // 支付宝
            
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark ---- 请求手机银行的数据
- (void)setUpPhoneBankData {
    __weak __typeof(&*self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:@"https://www.rongtuojinrong.com/rongtuoxinsoc/helpzhongxin/yinhangappios" parameters:nil completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        if (response.responseObject) {
            if (response.code == WebAPIResponseCodeSuccess) {
                [weakSelf.bankArr removeAllObjects];
                if ([response.responseObject objectForKey:@"data"]) {
                    NSArray *dataArr = response.responseObject[@"data"];
                        if (dataArr.count > 0) {
                            for (NSDictionary *dict in dataArr) {
                                XZPhoneBankSupportModel *modelPhone = [[XZPhoneBankSupportModel alloc] init];
                                [modelPhone setValuesForKeysWithDictionary:dict];
                                [self.bankArr addObject:modelPhone];
                        }
                }
                    
                if (weakSelf.bankArr.count > 0) {
                    [weakSelf.view addSubview:weakSelf.phoneBankView];
                    weakSelf.phoneBankView.arrBank = weakSelf.bankArr;
                }else {
                  ShowAutoHideMBProgressHUD(weakSelf.view, response.responseObject[@"msg"]);
                }
            }
                else {
                    ShowAutoHideMBProgressHUD(weakSelf.view, response.responseObject[@"msg"]);
            }
        }else {
                ShowAutoHideMBProgressHUD(weakSelf.view, response.responseObject[@"msg"]);
        }
        }
        else {
           ShowAutoHideMBProgressHUD(weakSelf.view, @"网络异常!");
        }
    }];
}

#pragma mark ---- 懒加载
- (UITableView *)tableRecharge {
    if (!_tableRecharge) {
        _tableRecharge = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 64) style:UITableViewStylePlain];
        _tableRecharge.delegate = self;
        _tableRecharge.dataSource  = self;
        _tableRecharge.backgroundColor = [HXColor colorWithHexString:@"#f4f5f9"];
        _tableRecharge.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableRecharge.showsVerticalScrollIndicator = NO;
        _tableRecharge.tableHeaderView = self.headerRecharge;
        _tableRecharge.tableFooterView = self.footerRecharge;
        
        __weak __typeof(&*self)weakSelf = self;
        _tableRecharge.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf getRechargeViewData];
        }];
    }
    return _tableRecharge;
}

- (XZBankRechargeHeader *)headerRecharge {
    if (!_headerRecharge) {
        if (KProjectScreenWidth < 350) {
            _headerRecharge = [[XZBankRechargeHeader alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 320)];
        }else {
           _headerRecharge = [[XZBankRechargeHeader alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 10 + 210 + 10 + (KProjectScreenWidth - 1) / 2.0  * 120 / 374.0 + 15 + 20 + 15)];
        }
        
        _headerRecharge.modelBankUser = self.modelBankUser;
        
        __weak __typeof(&*self)weakSelf = self;
        _headerRecharge.blockRecharge = ^(UIButton *button){
            if (button.tag == 700) { // 转账充值
                weakSelf.isQuickPay = NO;
                // 转账充值数据
                [weakSelf getTransferDataFormLocal];
            }else if (button.tag == 701) { // 快捷充值
                weakSelf.isQuickPay = YES;
                // 快捷充值数据
                [weakSelf getQuickDataFormLocal];
            }else { // 更换手机号
                [weakSelf.view endEditing:YES];
                WLChangePhoneNumberViewController *changePhone = [[WLChangePhoneNumberViewController alloc] init];
                [weakSelf.navigationController pushViewController:changePhone animated:YES];
            }
            
            for (XZBankRechargeModel *model in weakSelf.arrTransfer) {
                model.isQuickPay = weakSelf.isQuickPay;
            }
//            
//            NSLog(@"weakSelf.modelBankUser.isQuickPay:%d ====== weakSelf.isQuickPay:%d",weakSelf.modelBankUser.isQuickPay,weakSelf.isQuickPay);
//            
//            NSLog(@"weakSelf.modelRecharge.isQuickPay:%d ====== weakSelf.isQuickPay:%d",weakSelf.modelRecharge.isQuickPay,weakSelf.isQuickPay);
            
            weakSelf.modelBankUser.isQuickPay = weakSelf.isQuickPay;
            weakSelf.modelRecharge.isQuickPay = weakSelf.isQuickPay;
            weakSelf.headerRecharge.modelBankUser = weakSelf.modelBankUser;
            weakSelf.footerRecharge.modelBankUser = weakSelf.modelBankUser;
            
            [weakSelf.tableRecharge reloadData];
        };
    }
    return _headerRecharge;
}

- (XZBankRechargeFooter *)footerRecharge {
    if (!_footerRecharge) {
        _footerRecharge = [[XZBankRechargeFooter alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 135)];
        
        _footerRecharge.modelBankUser = self.modelBankUser;
        
        __weak __typeof(&*self)weakSelf = self;
        // 确认充值
        _footerRecharge.blockSurePay = ^(UIButton *button){
            if (weakSelf.moneyRecharge.floatValue < 1000) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"快捷充值最低充值金额为1000元，1000元以下的充值，请使用转账充值！" delegate:weakSelf cancelButtonTitle:@"确认" otherButtonTitles:nil];
//                [alert show];
                [weakSelf showAlertWithMsg:@"快捷充值最低充值金额为1000元，1000元以下的充值，请使用转账充值！" title:@"温馨提示" cancelTitle:@"确认"];
            }else if (weakSelf.moneyRecharge.floatValue > weakSelf.modelBankUser.transLimit) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"快捷充值单笔限额%.0f元！",weakSelf.modelBankUser.transLimit] delegate:weakSelf cancelButtonTitle:@"确认" otherButtonTitles:nil];
//                [alert show];
                [weakSelf showAlertWithMsg:[NSString stringWithFormat:@"快捷充值单笔限额%.0f元！",weakSelf.modelBankUser.transLimit] title:@"温馨提示" cancelTitle:@"确认"];
            }else if (!weakSelf.modelBankUser.transLimit) {
                // 如果当前页面没有数据，点击确认充值，“数据加载中，请稍后”，刷新数据
                ShowAutoHideMBProgressHUD(weakSelf.view, @"数据加载中，请稍后");
                [weakSelf performSelector:@selector(getRechargeViewData) withObject:weakSelf afterDelay:2.0];
            }else {
                [weakSelf getParameterFromNet];
            }
//            NSLog(@"确认充值");
        };
    }
    return _footerRecharge;
}

- (XZRechargeSuccessView *)successView {
    if (!_successView) {
        _successView = [[XZRechargeSuccessView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight)];
        
        __weak __typeof(&*self)weakSelf = self;
        // 充值成功"确认"
        _successView.blockSureRecharge = ^{
            weakSelf.successView = nil;
            
            // 充值成功，刷新当前页面数据
            [weakSelf getRechargeViewData];
        };
    }
    return _successView;
}

- (XZTransferRechargeView *)transferView {
    if (!_transferView) {
        _transferView = [[XZTransferRechargeView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight)];
        
        __weak __typeof(&*self)weakSelf = self;
        // 关闭
        _transferView.blockClosed = ^{
            weakSelf.transferView = nil;
        };
    }
    return _transferView;
}

- (XZPhoneBankSupportView *)phoneBankView {
    if (!_phoneBankView) {
        _phoneBankView = [[XZPhoneBankSupportView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight)];
        
        __weak __typeof(&*self)weakSelf = self;
        _phoneBankView.blockClosed = ^{
            weakSelf.phoneBankView = nil;
        };
    }
    return _phoneBankView;
}

- (XZBankRechargeModel *)modelRecharge {
    if (!_modelRecharge) {
        _modelRecharge = [[XZBankRechargeModel alloc] init];
        _modelRecharge.isQuickPay = NO;
    }
    return _modelRecharge;
}

- (NSMutableArray *)arrTransfer {
    if (!_arrTransfer) {
        _arrTransfer = [NSMutableArray array];
    }
    return _arrTransfer;
}

- (NSMutableArray *)arrQuick {
    if (!_arrQuick) {
        _arrQuick = [NSMutableArray array];
    }
    return _arrQuick;
}

- (NSMutableArray *)arrTransferPop {
    if (!_arrTransferPop) {
        _arrTransferPop = [NSMutableArray array];
    }
    return _arrTransferPop;
}

- (NSMutableArray *)bankArr {
    if (!_bankArr) {
        _bankArr = [NSMutableArray array];
    }
    return _bankArr;
}

//- (XZBankRechargeUserModel *)modelBankUser {
//    if (!_modelBankUser) {
//        _modelBankUser = [[XZBankRechargeUserModel alloc] init];
//    }
//    return _modelBankUser;
//}
@end
