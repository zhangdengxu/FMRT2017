//
//  XZIntegralConfirmOrderController.m
//  fmapp
//
//  Created by admin on 16/11/29.
//  Copyright © 2016年 yk. All rights reserved.
//  确认订单---积分购买

#import "XZIntegralConfirmOrderController.h"
#import "XZShoppingOrderAddressModel.h" // 地址model
#import "XZIntegralConfirmOrderHeader.h" // 头部地址
#import "SelectDressViewController.h" // 选择地址
#import "XZIntegralConfirmOrderCell.h" // cell
#import "XZIntegralConfirmOrderFooter.h" // footer
#import "XZConfirmOrderModel.h" // 当前页面model
#import "FMShoppingListModel.h"
#import "XZIntegralConfirmOrderTabBar.h" // 底部提交订单
#import "XZDeliveryOwnModel.h" // 自提地址model
#import "XZExchangeSuccessfulController.h" // 兑换成功
#import "XZPaymentDetailsView.h" //  付款详情
#import "FMGoodShopURLManage.h"
#import "FMRTWellStoreViewController.h"
#import "XZMyOrderViewController.h"
#import "FMShowPayStatus.h"
#import "XZPayOrder.h"
#import "FMSettings.h"

// 自提地址
#define DeliveryOwnAddressUrl @"https://www.rongtuojinrong.com/qdy/wap/member-ziti_client.html"

// 全积分提交订单
#define CoinPayConfirmUrl @"https://www.rongtuojinrong.com/qdy/wap/order-jifenex_client.html"

@interface XZIntegralConfirmOrderController ()<UITableViewDataSource,UITableViewDelegate,XZPayOrderDelegate,FMShowPayStatusDelegate>
// 头视图
@property (nonatomic, strong) XZIntegralConfirmOrderHeader *headerView;
// 尾视图
@property (nonatomic, strong) XZIntegralConfirmOrderFooter *footerView;
//
@property (nonatomic, strong) UITableView *tableIntConfirmOrder;
//
@property (nonatomic, strong) XZIntegralConfirmOrderTabBar *tabBarConfirm;
// 付款详情
@property (nonatomic, strong) XZPaymentDetailsView *paymentView;
// 当前页面的model
@property (nonatomic, strong)  XZConfirmOrderModel *confirmModelCoins;
// 快递数据
@property (nonatomic, strong) NSMutableArray *arrDistribution;
// 地址数据
@property (nonatomic, strong) NSMutableArray *arrAddress;
// 自提地址model
@property (nonatomic, strong) XZDeliveryOwnModel *modelDelivery;
// 自提地址数据
@property (nonatomic, strong) NSMutableArray *arrDelivery;
// 支付
@property (nonatomic, strong) XZPayOrder *payOrderStyle;
// 第一次点击支付宝或者微信支付
@property (nonatomic, assign) BOOL isFirstClick;

// 从微信支付宝直接返回
@property (nonatomic, assign) BOOL isBack;
// 显示支付结果支付成功或者失败的view
@property (nonatomic, strong) FMShowPayStatus *statusShowPay;
@end

@implementation XZIntegralConfirmOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.view.backgroundColor = XZBackGroundColor;
    [self settingNavTitle:@"确认订单"];
    [self.view addSubview:self.tableIntConfirmOrder];
    [self.view addSubview:self.tabBarConfirm];
    
    // 请求自提地址
    [self getDeliveryOwnAddressDataFromNetWork];
    // 请求用户账户积分数据
    [self getUserCoinsDataFromNetwork];
    
    // 从微信或者支付宝直接返回
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(BackFromAlipayOrWechatCoinPay:)
                                                 name: KBackFromAlipayOrWechatCoinPay
                                               object: nil];
}

#pragma mark ----- 从微信或者支付宝直接返回
- (void)BackFromAlipayOrWechatCoinPay:(NSNotification *)notification {
    if (self.isBack) { // 跳转我的订单
        if (FMShareSetting.backNumberCoin == 3) {
            //查看订单
            XZMyOrderViewController *orderView = [[XZMyOrderViewController alloc] init];
            orderView.isRemoveFather = YES;
            self.isBack = NO;
            [self.navigationController pushViewController:orderView animated:YES];
        }
    }
}

#pragma mark --- model的转化
- (void)setShopDataSource:(NSMutableArray *)shopDataSource {
    _shopDataSource = shopDataSource;
    // 商品详情
    self.confirmModelCoins.shopListModel = [self.shopDataSource firstObject];
    // 没有默认的支付方式
    self.confirmModelCoins.pay_app_id = @"";
    self.confirmModelCoins.payment_name = @"";
    // 买家留言
    self.confirmModelCoins.userMsg = @"";
    // 计算总积分和总金额
    self.confirmModelCoins.totalJifen = [NSString stringWithFormat:@"%ld",(long)[self.confirmModelCoins.shopListModel.fulljifen_ex integerValue] * self.confirmModelCoins.shopListModel.selectCount];
    
    // 没有地址
    self.footerView.confirmModelCoins = self.confirmModelCoins;
    self.tabBarConfirm.confirmModelCoins = self.confirmModelCoins;
}

#pragma mark ---- 请求自提地址
- (void)getDeliveryOwnAddressDataFromNetWork {
    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient  getPath:DeliveryOwnAddressUrl parameters:nil completion:^(WebAPIResponse *response) {
//        NSLog(@"自提地址 :========== %@",response.responseObject);
        if (response.responseObject) {
            if (response.code == WebAPIResponseCodeSuccess) {
                if (![response.responseObject[@"data"] isKindOfClass:[NSNull class]]) {
                    NSArray *addressData = response.responseObject[@"data"];
                    if (addressData.count != 0) {
                        for (NSDictionary *dict in addressData) {
                            XZDeliveryOwnModel *modelDelivery = [[XZDeliveryOwnModel alloc] init];
                            [modelDelivery setValuesForKeysWithDictionary:dict];
                            [weakSelf.arrDelivery addObject:modelDelivery];
                        }
                    }
                    // 请求用户地址
                    [weakSelf getSubmitOrderAddressDataFromNetWork];
                }
            }
        }
    }];
}

#pragma mark ---- 请求地址
- (void)getSubmitOrderAddressDataFromNetWork {
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString *urlStr = [NSString stringWithFormat:@"%@?from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%d&user_id=%@",KGoodShop_ManageDress,[CurrentUserInformation sharedCurrentUserInfo].mobile,tokenlow,timestamp,[CurrentUserInformation sharedCurrentUserInfo].userId];
    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient  getPath:urlStr parameters:nil completion:^(WebAPIResponse *response) {
//        NSLog(@"地址response.responseObject = %@",response.responseObject);
        if (response.responseObject) {
            if (response.code == WebAPIResponseCodeSuccess) {
                if (![response.responseObject[@"data"] isKindOfClass:[NSNull class]]) {
                    NSArray *addressData = response.responseObject[@"data"];
                    if (addressData.count == 0) { // 没有地址
                        XZShoppingOrderAddressModel *model = [[XZShoppingOrderAddressModel alloc]init];
                        model.def_addr = 0;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // 给页面赋值
                            [weakSelf.headerView sendDataWithModel:model];
                        });
                    }
                    else { // 有地址
                        XZShoppingOrderAddressModel *modelAddress;
                        for (NSDictionary *dic in addressData) {
                            XZShoppingOrderAddressModel *model = [[XZShoppingOrderAddressModel alloc]init];
                            [model setValuesForKeysWithDictionary:dic];
                            [weakSelf.arrAddress addObject:model];
                            if (model.def_addr == 1 ) { // 默认地址
                                modelAddress = model;
                            }
                        }
                        if (modelAddress) { // 有默认地址
                            dispatch_async(dispatch_get_main_queue(), ^{
                                // 给页面赋值
                                [weakSelf.headerView sendDataWithModel:modelAddress];
                            });
                            weakSelf.confirmModelCoins.addressModel = modelAddress;
                        }
                        else { // 没有默认地址,取第一个地址返回
                            modelAddress = weakSelf.arrAddress[0];
                            weakSelf.confirmModelCoins.addressModel = modelAddress;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                // 给页面赋值
                                [weakSelf.headerView sendDataWithModel:modelAddress];
                            });
                        }
                        weakSelf.modelDelivery = [[XZDeliveryOwnModel alloc] init];
                        // 当前地址在自提范围内,配送方式是自提，否则是包邮
                        if (weakSelf.arrDelivery.count > 0) {
                            for (int i = 0; i < weakSelf.arrDelivery.count; i++) {
                                XZDeliveryOwnModel *modelDelivery = weakSelf.arrDelivery[i];
                                if ([modelAddress.area_id integerValue] == [modelDelivery.area_id integerValue]) {
                                    weakSelf.modelDelivery = modelDelivery;
                                }
                            }
                            
                            // 如果当前页面的自提model有值
                            if (weakSelf.modelDelivery.address.length != 0) {
                                weakSelf.confirmModelCoins.deliveryWay = @"自提";
                                weakSelf.modelDelivery.deliveryWay = @"自提";
                            }else {
                                weakSelf.confirmModelCoins.deliveryWay = @"包邮";
                                weakSelf.modelDelivery.deliveryWay = @"包邮";
                            }
                            weakSelf.footerView.confirmModelCoins = weakSelf.confirmModelCoins;
                        }
                        
                    }
                }
            }
        }
        [weakSelf.tableIntConfirmOrder.mj_header endRefreshing];
    }];
}

#pragma mark ----- 请求总金额
- (void)getTotalMoneyFromNetwork {
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary *parameter = @{@"from":@"rongtuoapp",
                              @"appid":@"huiyuan",
                              @"tel":[CurrentUserInformation sharedCurrentUserInfo].mobile,
                              @"isfastbuy":@1,
                              @"purchase[addr_id]":@"Array",
                              @"purchase[def_area]":@"",
                              @"md5_cart_info":self.confirmModelCoins.md5_cart_info,
                              @"extends_args":@"{\"get\":[\"true\"],\"post\":{\"modify_quantity\":null}}",
                              @"address":[NSString stringWithFormat:@"{\"addr_id\":%@,\"area\":%@}",self.confirmModelCoins.addressModel.addr_id,self.confirmModelCoins.addressModel.area_id],
                              @"shipping":[NSString stringWithFormat:@"{\"id\":%@,\"has_cod\":\"false\",\"dt_name\":\"%@\",\"money\":\"%@\"}",self.confirmModelCoins.ID,self.confirmModelCoins.dt_name,self.confirmModelCoins.money],
                              @"payment[pay_app_id]":[NSString stringWithFormat:@"{\"pay_app_id\":\"%@\",\"payment_name\":\"%@\"}",self.confirmModelCoins.pay_app_id,self.confirmModelCoins.payment_name],
                              @"payment[currency]":@"CNY",
                              @"memo":@"",
                              @"coupon":@"",
                              @"btype":@"is_fastbuy",
                              @"goods[goods_id]":[NSString stringWithFormat:@"%@",self.confirmModelCoins.shopListModel.goods_id],
                              @"goods[num]":[NSString stringWithFormat:@"%zi",self.confirmModelCoins.shopListModel.selectCount],
                              @"goods[product_id]":[NSString stringWithFormat:@"%@",self.confirmModelCoins.shopListModel.product_id],
                              @"mini_cart":@"true",
                              @"sess_id":self.confirmModelCoins.sess_id
                  };
    __weak __typeof(&*self)weakSelf = self;
    NSString *html = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/cart-total.html?from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%@&user_id=%@&sess_id=%@",[CurrentUserInformation sharedCurrentUserInfo].mobile,tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId,self.confirmModelCoins.sess_id];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    NSLog(@"请求总金额：%@====参数：%@",html,parameter);
    [FMHTTPClient postPath:html parameters:parameter completion:^(WebAPIResponse *response) {
//        NSLog(@"请求总金额返回数据====%@",response.responseObject);
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if (response.responseObject) {
            if (response.code == WebAPIResponseCodeSuccess) {
                if (![response.responseObject isKindOfClass:[NSNull class]]) {
                    if (![response.responseObject[@"data"] isKindOfClass:[NSNull class]]) {
                        NSDictionary *dict = response.responseObject[@"data"];
                        self.confirmModelCoins.totalMoney = [NSString stringWithFormat:@"%@",dict[@"total"]];
                        // 给页面赋值
                        weakSelf.footerView.confirmModelCoins = weakSelf.confirmModelCoins;
                        weakSelf.tabBarConfirm.confirmModelCoins = weakSelf.confirmModelCoins;
                    }
                }
            }
        }
        [weakSelf.tableIntConfirmOrder.mj_header endRefreshing];
    }];
    
}

#pragma mark ----- 请求用户积分数据
- (void)getUserCoinsDataFromNetwork {
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=jifen&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString *string = [NSString stringWithFormat:@"%@?appid=jifen&user_id=%@&shijian=%d&token=%@",rongMiHeaderViewURL,[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow];
    
    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient getPath:string parameters:nil completion:^(WebAPIResponse *response) {
//        NSLog(@"用户积分数据%@",response.responseObject);
        if (response.code == WebAPIResponseCodeSuccess) {
            if (![response.responseObject isKindOfClass:[NSNull class]]) {
                NSString *jifenUser = [NSString stringWithFormat:@"%@",response.responseObject[@"jifen"]];
                if ([jifenUser integerValue] > 0) {
                    weakSelf.confirmModelCoins.jifenUser = jifenUser;
                }else {
                    weakSelf.confirmModelCoins.jifenUser = @"0";
                }
            }else {
                weakSelf.confirmModelCoins.jifenUser = @"0";
            }
        }else {
            weakSelf.confirmModelCoins.jifenUser = @"0";
        }
        weakSelf.footerView.confirmModelCoins = weakSelf.confirmModelCoins;
        weakSelf.tabBarConfirm.confirmModelCoins = weakSelf.confirmModelCoins;
        [weakSelf.tableIntConfirmOrder.mj_header endRefreshing];
    }];
}

#pragma mark ----- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZIntegralConfirmOrderCell *cell = [XZIntegralConfirmOrderCell cellConfirmOrderWithTableView:tableView];
    cell.confirmModelCoins = self.confirmModelCoins;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (KProjectScreenWidth * 0.32);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
//    NSLog(@"买家留言 ========== %@",self.confirmModelCoins.userMsg);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self.statusShowPay removeFromSuperview];
}

#pragma mark ---- 初始化
- (XZIntegralConfirmOrderHeader *)headerView {
    if (!_headerView) {
        _headerView = [[XZIntegralConfirmOrderHeader alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 86)];
        __weak __typeof(&*self)weakSelf = self;
        _headerView.blockChooseAddress = ^{
            SelectDressViewController *selectVC = [[SelectDressViewController alloc] init];
            selectVC.hidesBottomBarWhenPushed = YES;
            selectVC.naviTitleName = @"选择收货地址";
            // 地址回调
            selectVC.blockAgainBtn = ^(XZShoppingOrderAddressModel *modelAddress){
                [weakSelf.headerView sendDataWithModel:modelAddress];
                weakSelf.confirmModelCoins.addressModel = modelAddress;
                if (weakSelf.confirmModelCoins.dt_name) {
                    [weakSelf.arrDistribution removeAllObjects];
                    weakSelf.confirmModelCoins.dt_name = nil;
                    weakSelf.confirmModelCoins.money = nil;
                    weakSelf.confirmModelCoins.has_cod = nil;
                    weakSelf.confirmModelCoins.isdefault = nil;
                    weakSelf.confirmModelCoins.ID = nil;
                    weakSelf.confirmModelCoins.isSelectedCell = NO;
                    weakSelf.footerView.confirmModelCoins = weakSelf.confirmModelCoins;
                }
                // 重新创建
                weakSelf.modelDelivery = [[XZDeliveryOwnModel alloc] init];
                // 当前地址在自提范围内,配送方式是自提，否则是包邮
                if (weakSelf.arrDelivery.count > 0) {
                    for (int i = 0; i < weakSelf.arrDelivery.count; i++) {
                        XZDeliveryOwnModel *modelDelivery = weakSelf.arrDelivery[i];
                        if ([modelAddress.area_id integerValue] == [modelDelivery.area_id integerValue]) {
                            weakSelf.modelDelivery = modelDelivery;
//                            NSLog(@"包含当前地址");
                        }
                    }
                    
                    // 如果当前页面的自提model有值
                    if (weakSelf.modelDelivery.address.length != 0) {
                        weakSelf.confirmModelCoins.deliveryWay = @"自提";
                        weakSelf.modelDelivery.deliveryWay = @"自提";
                    }else {
                        weakSelf.confirmModelCoins.deliveryWay = @"包邮";
                        weakSelf.modelDelivery.deliveryWay = @"包邮";
                    }
                    weakSelf.footerView.confirmModelCoins = weakSelf.confirmModelCoins;
                }
                
            };
            
            // .addressModel.addr_id.length != 0
            if (weakSelf.confirmModelCoins.addressModel.area.length != 0) { // 有值
                selectVC.addr_id_address = weakSelf.confirmModelCoins.addressModel.addr_id;
            }
            [weakSelf.navigationController pushViewController:selectVC animated:YES];
        };
    }
    return _headerView;
}

- (XZIntegralConfirmOrderFooter *)footerView {
    if (!_footerView) {
        _footerView = [[XZIntegralConfirmOrderFooter alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 350)];
        __weak __typeof(&*self)weakSelf = self;
        _footerView.confirmModelCoins = self.confirmModelCoins;
        _footerView.blockDidClickButton = ^(UIButton *button){
            // 加405 减406 配送方式404 积分支付403 支付宝401 微信402
            if (button.tag == 401) { // 支付宝支付
                // !weakSelf.modelConfirm.isAliPay
                weakSelf.confirmModelCoins.isAliPay = YES;
                weakSelf.confirmModelCoins.isWechatPay = NO;
                weakSelf.confirmModelCoins.isCoinPay = NO;
                if (weakSelf.confirmModelCoins.isAliPay) {
                    weakSelf.confirmModelCoins.pay_app_id = @"alipay";
                    weakSelf.confirmModelCoins.payment_name = @"支付宝支付";
                    if (!weakSelf.confirmModelCoins.md5_cart_info) {
                        // 全钱支付
                        [weakSelf putGoodsToCart];
                    }
                }
            }else if(button.tag == 402) {// 微信支付
                // !weakSelf.modelConfirm.isWechatPay
                weakSelf.confirmModelCoins.isWechatPay = YES;
                weakSelf.confirmModelCoins.isAliPay = NO;
                weakSelf.confirmModelCoins.isCoinPay = NO;
                if (weakSelf.confirmModelCoins.isWechatPay) {
                    weakSelf.confirmModelCoins.pay_app_id = @"mwxpay";
                    weakSelf.confirmModelCoins.payment_name = @"微信支付";
                    if (!weakSelf.confirmModelCoins.md5_cart_info) {
                        // 全钱支付
                        [weakSelf putGoodsToCart];
                    }
                }
            }else if(button.tag == 403) {// 积分支付
                // !weakSelf.modelConfirm.isCoinPay
                weakSelf.confirmModelCoins.isCoinPay = YES;
                weakSelf.confirmModelCoins.isAliPay = NO;
                weakSelf.confirmModelCoins.isWechatPay = NO;
            }
            weakSelf.footerView.confirmModelCoins = weakSelf.confirmModelCoins;
            weakSelf.tabBarConfirm.confirmModelCoins = weakSelf.confirmModelCoins;
        };
        
        // 用户留言
        _footerView.blockSendUserMsg = ^(NSString *userMsg) {
            weakSelf.confirmModelCoins.userMsg = userMsg;
        };
    }
    return _footerView;
}

#pragma mark ---- 点击了提交订单
- (void)didClickConfrimOrderButton {
    if (self.isBack) { // 跳转我的订单
        //查看订单
        XZMyOrderViewController *orderView = [[XZMyOrderViewController alloc]init];
        orderView.isRemoveFather = YES;
        [self.navigationController pushViewController:orderView animated:YES];
    }else {
        if (!self.confirmModelCoins.addressModel.addr_id) {
            ShowAutoHideMBProgressHUD(self.view,@"请添加收货地址");
            return;
        }else {
            if (self.confirmModelCoins.isCoinPay) { // 积分支付
                // 添加"付款详情"页面
                UIWindow * window = [UIApplication sharedApplication].keyWindow;
                self.paymentView.confirmModelCoins = self.confirmModelCoins;
                [window addSubview:self.paymentView];
            }else { // 提交订单获取订单号
                if (self.confirmModelCoins.md5_cart_info) {
                    [self confirmOrderForOrderID];
                }else {// 全钱支付加入购物车
                    ShowAutoHideMBProgressHUD(self.view, @"请刷新重试");
                }
            }
        }
    }
}

#pragma mark ---- 积分支付确认支付提交订单
- (void)sureToconfirmOrder {
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=jifen&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow = [token lowercaseString];
    
    NSDictionary *parameter = @{
                                @"appid":@"huiyuan",
                                @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                @"shijian":[NSNumber numberWithInt:timestamp],
                                @"token":tokenlow,
                                @"from":@"rongtuoapp",
                                @"tel":[CurrentUserInformation sharedCurrentUserInfo].mobile,
                                @"product_id":self.confirmModelCoins.shopListModel.product_id,
                                @"buy_number":[NSString stringWithFormat:@"%zi",self.confirmModelCoins.shopListModel.selectCount],
                                @"memo":self.confirmModelCoins.userMsg,
                                @"shipping":[NSString stringWithFormat:@"{\"id\":%@,\"has_cod\":\"false\",\"dt_name\":\"%@\",\"money\":\"%@\"}",@"11",@"包邮",@"0"],
                                @"address":[NSString stringWithFormat:@"{\"addr_id\":%@,\"area\":%@}",self.confirmModelCoins.addressModel.addr_id,self.confirmModelCoins.addressModel.area_id],
                                };
//    NSLog(@"参数=========%@",parameter);
    __weak __typeof(&*self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    NSLog(@"url ========== %@",CoinPayConfirmUrl);
    [FMHTTPClient postPath:CoinPayConfirmUrl parameters:parameter completion:^(WebAPIResponse *response) {
//        NSLog(@"提交订单返回数据%@",response.responseObject);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (response.code == WebAPIResponseCodeSuccess) {
            if (![response.responseObject isKindOfClass:[NSNull class]]) {
                NSString *status = response.responseObject[@"status"];
                // 积分支付成功
                if ([status integerValue] == 0) {
                    [weakSelf pushToNextVc];
                }
            }
        }else { //
            if (response.responseObject[@"msg"]) {
                ShowAutoHideMBProgressHUD(weakSelf.view, [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]]);
            }
        }
    }];
}

#pragma mark ---- 全钱支付添加购物车
- (void)putGoodsToCart {
    //购物车
    NSString *baseUrl = [FMGoodShopURLManage getNewNetWorkURLWithBaseURL:KGoodShop_ShopDetail_AddShopList_Url];
    NSString *currentUrl = [NSString stringWithFormat:@"%@&goods[goods_id]=%@&goods[product_id]=%@&goods[num]=%@&mini_cart=%@&btype=is_fastbuy",baseUrl,self.confirmModelCoins.shopListModel.goods_id,self.confirmModelCoins.shopListModel.product_id,[NSNumber numberWithInteger:self.confirmModelCoins.shopListModel.selectCount],@1];
    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient getPath:currentUrl parameters:nil completion:^(WebAPIResponse *response) {
//        NSLog(@"加入购物车的返回值==========%@",response.responseObject);
        if (response.responseObject) {
            if (response.code == WebAPIResponseCodeSuccess) {
                if (![response.responseObject[@"data"] isKindOfClass:[NSNull class]]) {
                    NSDictionary *dict = response.responseObject[@"data"];
                    weakSelf.confirmModelCoins.md5_cart_info = dict[@"md5_cart_info"];
                    weakSelf.confirmModelCoins.sess_id = dict[@"sess_id"];
                    if (weakSelf.confirmModelCoins.sess_id.length != 0) {
                        // 请求总金额
                        [weakSelf getTotalMoneyFromNetwork];
                    }
                }
            }else {
                ShowAutoHideMBProgressHUD(weakSelf.view, @"提交失败,请稍后重试");
            }
        }
        [weakSelf.tableIntConfirmOrder.mj_header endRefreshing];
    }];
}

#pragma mark --- 提交订单获取订单号
- (void)confirmOrderForOrderID {
    if (self.confirmModelCoins.order_id) {
        [self payForOrder];
    }else {
        int timestamp = [[NSDate date] timeIntervalSince1970];
        NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
        NSString *tokenlow=[token lowercaseString];
        // 购物车参数
        NSDictionary *parameter = @{
                      @"from":@"rongtuoapp",
                      @"tel":[CurrentUserInformation sharedCurrentUserInfo].mobile,
                      @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                      @"appid":@"huiyuan",
                      @"shijian":[NSNumber numberWithInt:timestamp],
                      @"sess_id":self.confirmModelCoins.sess_id,
                      @"token":tokenlow,
                      @"isfastbuy":@1,
                      @"purchase[addr_id]":@"Array",
                      @"purchase[def_area]":@"",
                      @"md5_cart_info":self.confirmModelCoins.md5_cart_info,
                      @"extends_args":@"{\"get\":[\"true\"],\"post\":{\"modify_quantity\":null}}",
                      @"address":[NSString stringWithFormat:@"{\"addr_id\":%@,\"area\":%@}",self.confirmModelCoins.addressModel.addr_id,self.confirmModelCoins.addressModel.area_id],
                      @"shipping":[NSString stringWithFormat:@"{\"id\":%@,\"has_cod\":\"false\",\"dt_name\":\"%@\",\"money\":\"%@\"}",@"11",@"包邮",@"0"],
                      @"payment[pay_app_id]":[NSString stringWithFormat:@"{\"pay_app_id\":\"%@\",\"payment_name\":\"%@\"}",self.confirmModelCoins.pay_app_id,self.confirmModelCoins.payment_name],
                      @"payment[currency]":@"CNY",
                      @"memo":self.confirmModelCoins.userMsg,
                      @"coupon":@"",
                      @"btype":@"is_fastbuy",
                      @"goods[goods_id]":[NSString stringWithFormat:@"%@",self.confirmModelCoins.shopListModel.goods_id],
                      @"goods[num]":[NSString stringWithFormat:@"%zi",self.confirmModelCoins.shopListModel.selectCount],
                      @"goods[product_id]":self.confirmModelCoins.shopListModel.product_id,
                      @"is_fulljifen_ex":@"quanjifen",
                      @"mini_cart":@"true",
                    };
        __weak __typeof(&*self)weakSelf = self;
        [FMHTTPClient postPath:@"https://www.rongtuojinrong.com/qdy/wap/order-create_client.html" parameters:parameter completion:^(WebAPIResponse *response) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
//            NSLog(@"上传参数：%@ ======== \n获取订单号的返回值=======%@",parameter,response.responseObject);
            if (response.responseObject) {
                if (response.code == WebAPIResponseCodeSuccess) {
                    NSDictionary *dataDict = response.responseObject[@"data"];
                    if (dataDict) {
                        if (![dataDict isKindOfClass:[NSString class]]) {
                            if (![dataDict[@"order_id"] isKindOfClass:[NSNull class]]) {
                                // 订单号
                                weakSelf.confirmModelCoins.order_id = dataDict[@"order_id"];
                                self.isBack = YES;
                                FMShareSetting.backNumberCoin = 3;
                                if (weakSelf.confirmModelCoins.order_id) {
                                    // 支付
                                    [weakSelf payForOrder];
                                }
                            }else {
                                if (response.responseObject[@"msg"]) {
                                    ShowAutoHideMBProgressHUD(weakSelf.view, [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]]);
                                }else {
                                    ShowAutoHideMBProgressHUD(weakSelf.view,@"获取订单号失败，请重试");
                                }
                            }
                        }
                    }
                }
                else {
                    if (response.responseObject[@"msg"]) {
                        ShowAutoHideMBProgressHUD(weakSelf.view, [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]]);
                    }else {
                        ShowAutoHideMBProgressHUD(weakSelf.view,@"获取订单号失败，请重试");
                    }
                }
            }
        }];
    }
}

#pragma mark --- 调起支付
- (void)payForOrder {
    NSString *totalMoney = self.confirmModelCoins.totalMoney;

    CGFloat price = [totalMoney floatValue];
    // 支付宝支付
    if ([self.confirmModelCoins.pay_app_id isEqualToString:@"alipay"]) {
        // 支付宝支付
        NSString *url = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/paycenter-alipayCheck.html?oid=%@",self.confirmModelCoins.order_id];
        [self.payOrderStyle AliPayShopID:self.confirmModelCoins.order_id withTitle:self.confirmModelCoins.shopListModel.name Detail:self.confirmModelCoins.shopListModel.name Price:[NSString stringWithFormat:@"%.2f",price] Url:url Returl:url];
    }else {
        // 微信支付
        NSString *wUrl = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/paycenter-wxpayCheck.html?oid=%@",self.confirmModelCoins.order_id];
        [self.payOrderStyle WXPayShopID:self.confirmModelCoins.order_id withTitle:self.confirmModelCoins.shopListModel.name Detail:self.confirmModelCoins.shopListModel.name Price:[NSString stringWithFormat:@"%.2f",price] Url:wUrl Returl:wUrl];
    }
}

#pragma mark ----- 回调方法
-(void)XZPayOrderResult:(NSInteger)rest;
{
    if (rest == 1) {
        FMShareSetting.backNumberCoin = 1;
        //成功
        [self.statusShowPay showSuccessWithView:self.view];
    }else
    {
        FMShareSetting.backNumberCoin = 2;
        [self.statusShowPay showFaileWithView:self.view];
    }
}

-(void)FMShowPayStatusPayResult:(NSInteger)index;
{
    if (index == 1) {
        //查看订单
        XZMyOrderViewController *orderView = [[XZMyOrderViewController alloc]init];
        orderView.isRemoveFather = YES;
        [self.navigationController pushViewController:orderView animated:YES];
    }else
    {
        //返回首页
        FMRTWellStoreViewController *rootViewController;
        for (UIViewController * viewController in self.navigationController.viewControllers) {
            if ([viewController isKindOfClass:[FMRTWellStoreViewController class]]) {
                rootViewController = (FMRTWellStoreViewController *)viewController;
            }
        }
        if (rootViewController) {
            self.navigationController.navigationBarHidden = NO;
            [self.navigationController popToViewController:rootViewController animated:NO];
        }
    }
}

#pragma mark ----- 跳转到"兑换成功"的界面
- (void)pushToNextVc {
    XZExchangeSuccessfulController *exchangeSuccessful = [[XZExchangeSuccessfulController alloc] init];
    exchangeSuccessful.modelDelivery = self.modelDelivery;
    [self.navigationController pushViewController:exchangeSuccessful animated:YES];
}

- (UITableView *)tableIntConfirmOrder {
    if (!_tableIntConfirmOrder) {
        _tableIntConfirmOrder =  [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 45 - 64) style:UITableViewStylePlain];
        _tableIntConfirmOrder.dataSource = self;
        _tableIntConfirmOrder.delegate = self;
        _tableIntConfirmOrder.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableIntConfirmOrder.tableHeaderView = self.headerView;
        _tableIntConfirmOrder.tableFooterView = self.footerView;
        _tableIntConfirmOrder.backgroundColor = XZColor(229, 233, 242);
        __weak __typeof(&*self)weakSelf = self;
        _tableIntConfirmOrder.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            // 如果没有地址，请求地址
            if (!weakSelf.confirmModelCoins.addressModel.addr_id) {
                [weakSelf getDeliveryOwnAddressDataFromNetWork];
            }
            // 如果没有总金额，请求总金额
            if (self.confirmModelCoins.isWechatPay || self.confirmModelCoins.isAliPay) { // 提交订单获取订单号
                if (!self.confirmModelCoins.md5_cart_info) {
                    // 全钱支付加入购物车
                    [self putGoodsToCart];
                }
            }
            // 如果没有用户积分数据，请求用户积分数据
//            if (!weakSelf.confirmModelCoins.jifenUser) {
            [weakSelf getUserCoinsDataFromNetwork];
//            }
            
            // 微信或者支付宝支付的时候，如果没有请求到md5参数
            if (weakSelf.confirmModelCoins.isAliPay || weakSelf.confirmModelCoins.isWechatPay) {
                if (!weakSelf.confirmModelCoins.md5_cart_info) {
                    // 全钱支付
                    [weakSelf putGoodsToCart];
                }
            }
        }];
        
    }
    return _tableIntConfirmOrder;
}

- (XZIntegralConfirmOrderTabBar *)tabBarConfirm {
    if (!_tabBarConfirm) {
        _tabBarConfirm = [[XZIntegralConfirmOrderTabBar alloc] initWithFrame:CGRectMake(0, KProjectScreenHeight - 64 - 49, KProjectScreenWidth, 49)];
        _tabBarConfirm.confirmModelCoins = self.confirmModelCoins;
        __weak __typeof(&*self)weakSelf = self;
        _tabBarConfirm.blockClickConfirmOrder = ^(UIButton *button) {
            [weakSelf didClickConfrimOrderButton];
        };
    }
    return _tabBarConfirm;
}

- (XZPaymentDetailsView *)paymentView {
    if (!_paymentView) {
        _paymentView = [[XZPaymentDetailsView alloc] init];
        _paymentView.frame = CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight);
        __weak __typeof(&*self)weakSelf = self;
        _paymentView.blockDidClickClosed = ^{
            [weakSelf sureToconfirmOrder];
        };
    }
    return _paymentView;
}

- (XZConfirmOrderModel *)confirmModelCoins {
    if (!_confirmModelCoins) {
        _confirmModelCoins = [[XZConfirmOrderModel alloc] init];
        _confirmModelCoins.isCoinPay = YES;
    }
    return _confirmModelCoins;
}
- (NSMutableArray *)arrAddress {
    if (!_arrAddress) {
        _arrAddress = [NSMutableArray array];
    }
    return _arrAddress;
}

- (NSMutableArray *)arrDistribution {
    if (!_arrDistribution) {
        _arrDistribution = [NSMutableArray array];
    }
    return _arrDistribution;
}

- (NSMutableArray *)arrDelivery {
    if (!_arrDelivery) {
        _arrDelivery = [NSMutableArray array];
    }
    return _arrDelivery;
}

-(XZPayOrder *)payOrderStyle
{
    if (!_payOrderStyle) {
        _payOrderStyle = [[XZPayOrder alloc]init];
        _payOrderStyle.delegate = self;
    }
    return _payOrderStyle;
}

- (FMShowPayStatus *)statusShowPay {
    if (!_statusShowPay) {
        _statusShowPay = [[FMShowPayStatus alloc] init];
        _statusShowPay.delegate = self;
    }
    return _statusShowPay;
}

@end
