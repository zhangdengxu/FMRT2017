//
//  XZConfirmPaymentController.m
//  fmapp
//
//  Created by admin on 16/10/29.
//  Copyright © 2016年 yk. All rights reserved.
//  确认支付

#import "XZConfirmPaymentController.h"
#import "XZConfirmPaymentHeader.h" // 头视图
#import "XZConfirmPaymentFooter.h" // 尾视图
#import "XZConfirmPaymentCell.h" // cell
#import "SelectDressViewController.h" // 选择地址
#import "XZShoppingOrderAddressModel.h" // 地址model
#import "XZPayOrder.h" // 支付
#import "FMShowPayStatus.h"
#import "XZIntegralExchangeNewController.h"//  积分兑换
#import "FMRTAllTakeNewBuyViewController.h"// 购买夺宝币
#import "AppDelegate.h"
#import "FMRTAllTakeBuyResultViewController.h" // 支付结果的展示
#import "WLNewServiceAndAgreementViewController.h" // 全民夺宝服务协议

#import "FMDuobaoClass.h"

// 确认支付按钮请求数据
#define kXZSurePayUrl [NSString stringWithFormat:@"%@/public/newon/order/wonOrder",kXZTestEnvironment]
// 可投注信息
#define kXZBettingInformationUrl [NSString stringWithFormat:@"%@/public/newon/order/getCanBetInfo",kXZTestEnvironment]

// 账户余额
#define kXZMySnatchControllerUrl [NSString stringWithFormat:@"%@/public/newon/coin/getUserWonAccount",kXZTestEnvironment]

// 夺宝币支付
#define kXZUseCoinToPay [NSString stringWithFormat:@"%@/public/newon/order/coinPay",kXZTestEnvironment]

@interface XZConfirmPaymentController ()<UITableViewDataSource,UITableViewDelegate,XZPayOrderDelegate>
// 头视图
@property (nonatomic, strong) XZConfirmPaymentHeader *headerView;
// 尾视图
@property (nonatomic, strong) XZConfirmPaymentFooter *footerView;
//
@property (nonatomic, strong) UITableView *tableConfirmOrder;
// 支付
@property (nonatomic, strong) XZPayOrder *payOrderStyle;
// 最终价格
@property (nonatomic, strong) NSString *finalPrice;
// 商品属性
@property (nonatomic, strong) NSString *goodsAttribute;
// 商品属性
@property (nonatomic, assign) BOOL isRequestCoinData;
// 剩余账户余额
@property (nonatomic, strong) NSString *currentCoin;
@end

@implementation XZConfirmPaymentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XZColor(229, 233, 242);
    [self settingNavTitle:@"确认支付"];
    [self.view addSubview:self.tableConfirmOrder];
    // 右侧按钮和确认支付按钮
    [self createRightButtonAndOtherButton];
    if ([self.duobaoShop.selectModel.type integerValue] == 2) { // 老友价
        // 设置默认支付方式
        self.duobaoShop.payment_name = @"微信支付";
        self.duobaoShop.pay_app_id  = @"wxpay";
        self.finalPrice = self.duobaoShop.selectModel.won_cost;
    }else { // 1、5币得
        /** 余额支付 */
        self.duobaoShop.isBalancePay = YES;
        self.finalPrice = self.duobaoShop.selectModel.unit_cost;
    }
    /** 同意全民夺宝服务协议 */
    self.duobaoShop.isAgreeDeal = YES;
    self.goodsAttribute = @"";
    // 拼接商品属性
    if (self.duobaoShop.selectString.length != 0) {
        NSArray *subString = [self.duobaoShop.selectString componentsSeparatedByString:@"   "];
        NSString *beforePart = subString[0];
        NSArray *beforeSubs = [beforePart componentsSeparatedByString:@":"];
        NSString *beforeStr = beforeSubs[1];
        
        NSString *afterPart = subString[1];
        NSArray *afterSubs = [afterPart componentsSeparatedByString:@":"];
        NSString *afterStr = afterSubs[1];
        self.goodsAttribute = [NSString stringWithFormat:@"%@,%@",beforeStr,afterStr];
    }
   
    if ([self.duobaoShop.selectModel.type integerValue] == 1) { // 1、5币得
        // 请求地址
        [self getUserAddressDataFromNetWork:NO];
    }else {
        // 请求地址
        [self getUserAddressDataFromNetWork:YES];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.duobaoShop.selectModel.type integerValue] == 1 && self.isRequestCoinData) { // 1、5币得
        // 请求"账户余额“数据
        [self getMySnathDataFromNetWork:NO];
    }
}

#pragma mark ---- 请求地址
- (void)getUserAddressDataFromNetWork:(BOOL)isOldFriend {
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSString *urlStr = [NSString  stringWithFormat:KGoodShop_ManageDress@"?from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%d&user_id=%@",[CurrentUserInformation sharedCurrentUserInfo].mobile,tokenlow,timestamp,[CurrentUserInformation sharedCurrentUserInfo].userId];
    __weak typeof(self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient  getPath:urlStr parameters:nil completion:^(WebAPIResponse *response) {
//        NSLog(@"response.responseObject ====== %@",response.responseObject);
        if (isOldFriend) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        }
        if (response.code == WebAPIResponseCodeSuccess) {
            // 地址请求成功，请求账户余额数据
            if ([self.duobaoShop.selectModel.type integerValue] == 1) { // 1、5币得
                // 请求"账户余额“数据
                [self getMySnathDataFromNetWork:YES];
            }
        
            NSArray *addressData = response.responseObject[@"data"];
            
            if (addressData.count != 0) { // 有地址
                for (NSDictionary *dic in addressData) {
                    XZShoppingOrderAddressModel *model = [[XZShoppingOrderAddressModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    
                    if (model.def_addr == 1 ) { // 有默认地址
                        [weakSelf.headerView sendDataWithModel:model];
                        weakSelf.duobaoShop.addressModel = model;
                        return;
                    }
                }
                // 没有默认地址
                XZShoppingOrderAddressModel *model = [[XZShoppingOrderAddressModel alloc] init];
                model.def_addr = 0;
                [weakSelf.headerView sendDataWithModel:model];
            }else { // 没有地址
                XZShoppingOrderAddressModel *model = [[XZShoppingOrderAddressModel alloc] init];
                model.def_addr = 0;
                [weakSelf.headerView sendDataWithModel:model];
            }
        }
        else {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        }
    }];
}

#pragma mark ----- 请求"账户余额“数据
- (void)getMySnathDataFromNetWork:(BOOL)isCoinBuy {
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
    if (!isCoinBuy) {// 积分兑换、购买夺宝币、夺宝币支付的时候
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [FMHTTPClient postPath:kXZMySnatchControllerUrl parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if (response.code == WebAPIResponseCodeSuccess) {
            if (![response.responseObject isKindOfClass:[NSNull class]]) {
                NSDictionary *dataDict = response.responseObject[@"data"];
                NSString *currentCoin = [NSString stringWithFormat:@"%@",dataDict[@"coin"]];
                weakSelf.currentCoin = currentCoin;
                // 给头视图赋值
                weakSelf.footerView.accountBalance = [NSString stringWithFormat:@"%@",dataDict[@"coin"]];
            }
        }
        else{ // 请求失败
            ShowAutoHideMBProgressHUD(weakSelf.view,@"加载数据失败");
        }
    }];
}

#pragma mark ---- 点击“确认支付”按钮
- (void)didClickSurePayButton {
    if (self.duobaoShop.addressModel.area.length == 0) {
        ShowAutoHideMBProgressHUD(self.view,@"请添加收货地址");
        return;
    }else if (!self.duobaoShop.isAgreeDeal) {
        ShowAutoHideMBProgressHUD(self.view,@"请同意服务协议");
        return;
    }
    // 要判断是不是1、5币得
    if ([self.duobaoShop.selectModel.type integerValue] == 2) { // 老友价：微信支付宝支付
        // 确认支付按钮请求数据
        [self putAllDataToNetWorkWithType:self.duobaoShop.pay_app_id periods:@""];
        return;
    }else { // 1、5币得 “您的夺宝币余额不足”
        if ([self.finalPrice integerValue] > [self.currentCoin integerValue]) {
            ShowAutoHideMBProgressHUD(self.view,@"您的夺宝币余额不足");
            return;
        }else if (!self.duobaoShop.isBalancePay) {
            ShowAutoHideMBProgressHUD(self.view,@"请选择余额支付");
            return;
        }else {
            // 可投注信息请求数据
            [self getBettingInformationWithType:@"won"];
        }
    }
}

#pragma mark ---- 可投注信息请求数据
- (void)getBettingInformationWithType:(NSString *)payType {
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary *parameter = @{
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"won_id":self.duobaoShop.won_id,
                                 @"way_id":self.duobaoShop.style_id,
                                 @"periods":@"", // 这个就是空字符串
                                 };
    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient postPath:kXZBettingInformationUrl parameters:parameter completion:^(WebAPIResponse *response) {
        if (response.code == WebAPIResponseCodeSuccess) {
            NSDictionary *dict = response.responseObject[@"data"];
            if (![dict isKindOfClass:[NSNull class]]) {
                NSString *periods = [NSString stringWithFormat:@"%@",dict[@"periods"]];
                // 用户是否已经参与过当期  0：否  1：是
                NSString *purchased = [NSString stringWithFormat:@"%@",dict[@"purchased"]];
                if ([purchased integerValue] == 0) { // 没有参与当期
                    // 确认支付按钮请求数据
                    [weakSelf putAllDataToNetWorkWithType:payType periods:periods];
                }else {
                    ShowAutoHideMBProgressHUD(weakSelf.view,@"您已经参与过本期活动");
                }
            }
        }else {// 失败的时候提示
            ShowAutoHideMBProgressHUD(weakSelf.view,@"请求失败,请稍后重试");
        }
    }];
}

#pragma mark ---- 确认支付按钮请求订单号数据
- (void)putAllDataToNetWorkWithType:(NSString *)payType periods:(NSString *)periods {
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    // 手机号
    NSString *phone = @"";
    if (self.duobaoShop.addressModel.mobile.length == 0) {
        phone = self.duobaoShop.addressModel.tel;// 座机号
    }else {
        phone = self.duobaoShop.addressModel.mobile;// 手机号
    }
    // 收件人地址
    NSArray *areaArr = [self.duobaoShop.addressModel.area componentsSeparatedByString:@":"];
    NSString *address = @"";
    if (areaArr.count > 1) { // 有地址编码
        address = [NSString stringWithFormat:@"%@ %@",areaArr[1],self.duobaoShop.addressModel.addr];
    }else {
        address = [NSString stringWithFormat:@"%@ %@",areaArr[0],self.duobaoShop.addressModel.addr];
    }
    NSDictionary *parameter = @{
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"won_id":self.duobaoShop.won_id,
                                 @"way_id":self.duobaoShop.style_id,
                                 @"periods":periods,
                                 @"pay_type":payType,
                                 @"product_id":self.duobaoShop.product_id,
                                 @"goods_spec":self.goodsAttribute,
                                 @"address":address,
                                 @"recipients":self.duobaoShop.addressModel.name,
                                 @"phone":phone
                                 };

    __weak typeof(self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:kXZSurePayUrl parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if (response.code == WebAPIResponseCodeSuccess) {
            NSDictionary *dataDict = response.responseObject[@"data"];
            if (![dataDict isKindOfClass:[NSNull class]]) {
                if (![dataDict[@"record_id"] isKindOfClass:[NSNull class]]) {
                    // 支付订单号
                    weakSelf.duobaoShop.pay_trade_no = [NSString stringWithFormat:@"%@",dataDict[@"pay_trade_no"]];
                    // 交易记录标识
                    weakSelf.duobaoShop.record_id  = [NSString stringWithFormat:@"%@",dataDict[@"record_id"]];
                    // 支付
                    if ([payType isEqualToString:@"won"]) { // 夺宝币支付
                        [weakSelf useCoinToPayOrder:weakSelf.duobaoShop.record_id];
                    }else { // 微信、支付宝支付
                        [self payForOrder];
                    }
                }
                else {
                    ShowAutoHideMBProgressHUD(self.view,@"获取订单号失败，请重试");
                }
            }
        }
        else
        {
            ShowAutoHideMBProgressHUD(self.view,response.responseObject[@"msg"]);
        }
    }];
}

// 使用夺宝币支付订单
- (void)useCoinToPayOrder:(NSString *)record_id {
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * paras = @{@"appid":@"huiyuan",
                             @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                             @"shijian":[NSNumber numberWithInt:timestamp],
                             @"token":tokenlow,
                             @"record_id":record_id,
                             };
    
    __weak typeof(self)weakSelf = self;
    [FMHTTPClient postPath:kXZUseCoinToPay parameters:paras completion:^(WebAPIResponse *response) {
        //支付成功
        if (response.code == WebAPIResponseCodeSuccess) {
            NSDictionary *dict = response.responseObject[@"data"];
            if (![dict isKindOfClass:[NSNull class]]) {
                // 幸运号码
                NSString *lucky_code = dict[@"lucky_code"];
                self.duobaoShop.lucky_code = lucky_code;
                // 消费后用户的夺宝币账户余额
                NSString *balance = dict[@"balance"];
                self.duobaoShop.balance = balance;
                FMRTAllTakeBuyResultViewController *allTakeBuy = [[FMRTAllTakeBuyResultViewController alloc] init];
                allTakeBuy.duobaoShop = self.duobaoShop;
                // 交易状态
                NSString *deal_status = dict[@"deal_status"];
                if ([deal_status integerValue] == 0) { // 交易成功
                    allTakeBuy.resultOfPay = DuobaobiSuccessOfPay;
                    [weakSelf.navigationController pushViewController:allTakeBuy animated:YES];
                }else if ([deal_status integerValue] == 1){ // 订单不存在
                    ShowAutoHideMBProgressHUD(weakSelf.view,@"订单不存在");
                }else if ([deal_status integerValue] == 2){ // 订单参与方式不是抽奖类型
                    ShowAutoHideMBProgressHUD(weakSelf.view,@"订单参与方式不是抽奖类型");
                }else if ([deal_status integerValue] == 3){ // 订单已超时取消，跳转
                    allTakeBuy.resultOfPay = TimeOutFailureOfPay;
                    [weakSelf.navigationController pushViewController:allTakeBuy animated:YES];
                }else if ([deal_status integerValue] == 4){ // 本期结束
                    ShowAutoHideMBProgressHUD(weakSelf.view,@"本期已结束,请重新下单！");
                }else if ([deal_status integerValue] == 5){ // 活动结束,跳
                    allTakeBuy.resultOfPay = ActivityEndedFailureOfPay;
                    [weakSelf.navigationController pushViewController:allTakeBuy animated:YES];
                }else if ([deal_status integerValue] == 6){ // 用户已参与
                    ShowAutoHideMBProgressHUD(weakSelf.view,@"您已经参与过本期活动");
                }else { // 7 账户余额不足
                    allTakeBuy.resultOfPay = DuobaobiFailureOfPay;
                    [weakSelf.navigationController pushViewController:allTakeBuy animated:YES];
                }
            }
        }
        else {
            ShowAutoHideMBProgressHUD(weakSelf.view,@"请求数据失败，请稍后重试！");
        }
    }];
}

// 微信支付宝支付
- (void)payForOrder {
    // 支付宝支付
    if ([self.duobaoShop.pay_app_id isEqualToString:@"alipay"]) {
        // 支付宝支付
        CGFloat price = [self.finalPrice floatValue];
        // 支付宝支付回调
        NSString *url = [NSString stringWithFormat:@"%@/public/newon/pay/buyWonGoodsNoticeFromAlipay",kXZTestEnvironment];
        
        [self.payOrderStyle AliPayShopID:self.duobaoShop.pay_trade_no withTitle:self.duobaoShop.goods_name Detail:self.duobaoShop.goods_name Price:[NSString stringWithFormat:@"%.2f",price] Url:url Returl:url type:11];
    }else {
        // 微信支付
        CGFloat price = [self.finalPrice floatValue];
        // 微信支付回调
        NSString *wUrl = [NSString stringWithFormat:@"%@/public/newon/pay/buyWonGoodsNoticeFromWxpay",kXZTestEnvironment];
    
        [self.payOrderStyle WXPayShopID:self.duobaoShop.pay_trade_no withTitle:self.duobaoShop.goods_name Detail:self.duobaoShop.goods_name Price:[NSString stringWithFormat:@"%.2f",price] Url:wUrl Returl:wUrl type:11];
    }
}

-(void)XZPayOrderResultWithStatus:(NSString *)resultStatus;
{
    void(^blockSuccess)() = ^() { // 支付成功
        FMRTAllTakeBuyResultViewController *allTakeBuy = [[FMRTAllTakeBuyResultViewController alloc] init];
        allTakeBuy.duobaoShop = self.duobaoShop;
        allTakeBuy.resultOfPay = OldFiriendPriceSuccessOfPay;
        [self.navigationController pushViewController:allTakeBuy animated:YES];
    };
    if ([self.duobaoShop.pay_app_id  isEqualToString: @"wxpay"]) {
        // 微信支付
        if ([resultStatus isEqualToString:@"1"]) {
            blockSuccess(); // 支付成功
        }else {
            ShowAutoHideMBProgressHUD(self.view, @"支付失败");
        }
    }else {
        // 支付宝支付
        if ([resultStatus isEqualToString:@"9000"]) {
            blockSuccess(); // 支付成功
        }else {
            ShowAutoHideMBProgressHUD(self.view, @"支付失败");
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

#pragma mark ----- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZConfirmPaymentCell *cell = [XZConfirmPaymentCell cellConfirmOrderWithTableView:tableView];
    cell.duobaoClass = self.duobaoShop;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (KProjectScreenWidth * 0.32); // (KProjectScreenWidth * 0.32)
}

#pragma mark --- 懒加载
- (XZConfirmPaymentHeader *)headerView {
    if (!_headerView) {
        _headerView = [[XZConfirmPaymentHeader alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 110)];
        __weak typeof(self)weakSelf = self;
        _headerView.blockChooseAddress = ^{
            SelectDressViewController *selectVC = [[SelectDressViewController alloc]init];
            selectVC.hidesBottomBarWhenPushed = YES;
            selectVC.naviTitleName = @"选择收货地址";
            // 地址回调
            selectVC.blockAgainBtn = ^(XZShoppingOrderAddressModel *modelAddress){
                [weakSelf.headerView sendDataWithModel:modelAddress];
                weakSelf.duobaoShop.addressModel = modelAddress;
            };
            
            // .addressModel.addr_id.length != 0
            if (weakSelf.duobaoShop.addressModel.area.length != 0) { // 有值
                selectVC.addr_id_address = weakSelf.duobaoShop.addressModel.addr_id;
            }
            [weakSelf.navigationController pushViewController:selectVC animated:YES];
            };
    }
    return _headerView;
}

-(XZConfirmPaymentFooter *)footerView {
    if (!_footerView) {
        _footerView = [[XZConfirmPaymentFooter alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 265)]; // 216
        _footerView.duobaoShop = self.duobaoShop;
        __weak typeof(self)weakSelf = self;
        _footerView.blockPayWay = ^(UIButton *button) {
            // 积分兑换 130 购买夺宝币 140 服务协议 150 微信支付160 支付宝支付170
            if (button.tag == 130) { // 积分兑换
                XZIntegralExchangeNewController *integralExchange = [[XZIntegralExchangeNewController alloc] init];
                weakSelf.isRequestCoinData = YES;
                [weakSelf.navigationController pushViewController:integralExchange animated:YES];
            }else if (button.tag == 140) { // 购买夺宝币
                FMRTAllTakeNewBuyViewController *buyVC = [[FMRTAllTakeNewBuyViewController alloc]init];
                __strong FMRTAllTakeNewBuyViewController *VC = buyVC;
                buyVC.view.backgroundColor = [UIColor clearColor];
                buyVC.dismissBlock = ^() {
                    // 请求"账户余额“数据
                    [weakSelf getMySnathDataFromNetWork:NO];
//                    weakSelf.isRequestCoinData = YES;
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
                
            }else if (button.tag == 150)  { // 同意全民夺宝服务协议
                weakSelf.duobaoShop.isAgreeDeal = !weakSelf.duobaoShop.isAgreeDeal;
            }else if (button.tag == 180)  { // 余额支付
                weakSelf.duobaoShop.isBalancePay = !weakSelf.duobaoShop.isBalancePay;
            }else if (button.tag == 200) { // 服务协议
                WLNewServiceAndAgreementViewController *service = [[WLNewServiceAndAgreementViewController alloc] init];
                [weakSelf.navigationController pushViewController:service animated:YES];
            }
        };
        
        _footerView.blockPay = ^(UIButton *button){
            if (button.tag == 160) { // 微信支付
                weakSelf.duobaoShop.payment_name = @"微信支付";
                weakSelf.duobaoShop.pay_app_id  = @"wxpay";
            }else if (button.tag == 170)  { // 支付宝支付
                weakSelf.duobaoShop.payment_name = @"支付宝支付";
                weakSelf.duobaoShop.pay_app_id  = @"alipay";
            }
//            NSLog(@"当前支付方式：%@",weakSelf.duobaoShop.payment_name);
        };
    }
    return _footerView;
}

- (UITableView *)tableConfirmOrder {
    if (!_tableConfirmOrder) {
        _tableConfirmOrder =  [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 45 - 64) style:UITableViewStylePlain];
        _tableConfirmOrder.dataSource = self;
        _tableConfirmOrder.delegate = self;
        _tableConfirmOrder.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableConfirmOrder.tableHeaderView = self.headerView;
        _tableConfirmOrder.tableFooterView = self.footerView;
        _tableConfirmOrder.backgroundColor = XZColor(229, 233, 242);
        
    }
    return _tableConfirmOrder;
}

-(XZPayOrder *)payOrderStyle
{
    if (!_payOrderStyle) {
        _payOrderStyle = [[XZPayOrder alloc]init];
        _payOrderStyle.delegate = self;
    }
    return _payOrderStyle;
}

// 创建右侧按钮和确认支付按钮
- (void)createRightButtonAndOtherButton {
    // 确认支付
    UIButton *btnSurePay = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btnSurePay];
    btnSurePay.frame = CGRectMake(0, KProjectScreenHeight - 45 - 64, KProjectScreenWidth, 45);
    [btnSurePay setTitle:@"确认支付" forState:UIControlStateNormal];
    [btnSurePay.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [btnSurePay addTarget:self action:@selector(didClickSurePayButton) forControlEvents:UIControlEventTouchUpInside];
    [btnSurePay setBackgroundColor:XZColor(0, 51, 153)];
}

@end
