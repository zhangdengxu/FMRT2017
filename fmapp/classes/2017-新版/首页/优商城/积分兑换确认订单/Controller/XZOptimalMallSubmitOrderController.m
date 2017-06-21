//
//  XZOptimalMallSubmitOrderController.m
//  fmapp
//
//  Created by admin on 16/12/9.
//  Copyright © 2016年 yk. All rights reserved.
//  优商城确认订单

#import "XZOptimalMallSubmitOrderController.h"
#import "XZIntegralConfirmOrderHeader.h" // 头部地址
#import "SelectDressViewController.h" // 选择地址
#import "XZShoppingOrderAddressModel.h" // 地址model
#import "XZOptimalMallSubmitOrderCell.h" // cell
#import "XZOptimalMallSubmitOrderFooter.h" // footer
#import "XZOptimalMallSubmitOrderTabBar.h" // tabBar
#import "FMShoppingListModel.h" // 详情页的model
#import "XZConfirmOrderModel.h" // 当前页面model
#import "FMSelectAddressBottomView.h" // 配送方式
#import "XZPayOrder.h" // 支付
#import "FMShowPayStatus.h" // 支付状态的view
#import "XZMyOrderViewController.h" // 我的订单页面
#import "FMRTWellStoreViewController.h" // 优商城
#import "XZChooseTicketController.h" //  选择抵价券
#import "XZChooseTicketModel.h" // model
#import "FMSettings.h"

// ,FMSelectAddressBottomViewDelegate
@interface XZOptimalMallSubmitOrderController ()<UITableViewDelegate,UITableViewDataSource,XZPayOrderDelegate,FMShowPayStatusDelegate>
// 头视图
@property (nonatomic, strong) XZIntegralConfirmOrderHeader *headerView;
// 尾视图
@property (nonatomic, strong) XZOptimalMallSubmitOrderFooter *footerView;
//
@property (nonatomic, strong) UITableView *tableSubmitOrder;
// "提交订单一栏"
@property (nonatomic, strong) XZOptimalMallSubmitOrderTabBar *tabBarSubmit;
// 地址数据
@property (nonatomic, strong) NSMutableArray *arrAddress;
// 当前页面的model
@property (nonatomic, strong) XZConfirmOrderModel *confirmModel;
// 快递数据
@property (nonatomic, strong) NSMutableArray *arrDistribution;
// 配送方式
@property (nonatomic, strong) FMSelectAddressBottomView *activity;
// 切换地址
@property (nonatomic, assign) BOOL isChangedAddress;
// 从微信支付宝直接返回
@property (nonatomic, assign) BOOL isBack;
// 支付
@property (nonatomic, strong) XZPayOrder *payOrderStyle;
// 显示支付结果支付成功或者失败的view
@property (nonatomic, strong) FMShowPayStatus *statusShowPay;

// 是否处理回调
@property (nonatomic, assign) BOOL isDealCallBack;
@end

@implementation XZOptimalMallSubmitOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.view.backgroundColor = XZBackGroundColor;
    [self settingNavTitle:@"确认订单"];
    [self.view addSubview:self.tableSubmitOrder];
    [self.view addSubview:self.tabBarSubmit];
    // 默认微信支付
    self.confirmModel.pay_app_id = @"mwxpay";
    self.confirmModel.payment_name = @"微信支付";
    
    // 请求地址
    [self getSubmitOrderAddressDataFromNetWork];
    // 请求总金额
    [self calculateSubmitOrderTotalMoney];
    
    // 从微信或者支付宝直接返回
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(BackFromAlipayOrWechat:)
                                                 name: KBackFromAlipayOrWechat
                                               object: nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isChangedAddress) { // 修改地址
        // 请求快递数据
        [self getSubmitOrderDistributionWayData];
    }
    self.isDealCallBack = YES;
}

#pragma mark ----- 从微信或者支付宝直接返回
- (void)BackFromAlipayOrWechat:(NSNotification *)notification {
    
    if (self.isBack) { // 跳转我的订单
        if (FMShareSetting.backNumber == 3) {
            //查看订单
            XZMyOrderViewController *orderView = [[XZMyOrderViewController alloc] init];
            orderView.isRemoveFather = YES;
            self.isBack = NO;
            [self.navigationController pushViewController:orderView animated:YES];
        }
    }
}

- (void)setShopDataSource:(NSMutableArray *)shopDataSource {
    _shopDataSource = shopDataSource;
    self.confirmModel.isWechatPay = YES;
    // 买家留言
    self.confirmModel.userMsg = @"";
    // 是否使用积分抵扣 1使用
    self.confirmModel.usedJifenDiKou = @"";
    // 用户拥有积分
    self.confirmModel.jifenUser = @"0";
    
    self.confirmModel.shopListModel = [self.shopDataSource firstObject];
//    NSLog(@"商品goods_id:%@-----商品的product_id%@-----md5_cart_info:%@",self.confirmModel.shopListModel.goods_id,self.confirmModel.shopListModel.product_id,self.confirmModel.shopListModel.md5_cart_info);
    if (self.sess_id) {// 购物车
        // 拼接product_id
        NSString *str = @"";
        NSString *number = @"";
        NSInteger totalCount = 0;
        for (FMShoppingListModel *model in shopDataSource) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@",%@",model.product_id]];
            number = [number stringByAppendingString:[NSString stringWithFormat:@",%ld",(long)model.selectCount]];
            totalCount = totalCount + model.selectCount;
        }
        self.confirmModel.shopListArray = self.shopDataSource;
        // 商品总个数
        self.confirmModel.totalCount = [NSString stringWithFormat:@"%ld",(long)totalCount];
        NSString *subGoodIds = [str substringWithRange:NSMakeRange(1, [str length] - 1)];
        self.confirmModel.subGoodIds = subGoodIds;
        NSString *subNuber = [number substringWithRange:NSMakeRange(1, [number length] - 1)];
        self.confirmModel.subNuber = subNuber;
        self.confirmModel.sess_id = self.sess_id;
    }else { // 商品详情
        self.confirmModel.sess_id = self.confirmModel.shopListModel.sess_id;
        self.confirmModel.subGoodIds = self.confirmModel.shopListModel.goods_id;
        self.confirmModel.subNuber = [NSString stringWithFormat:@"%ld",(long)self.confirmModel.shopListModel.selectCount];
        // 用户没有地址
        self.confirmModel.totalCount = self.confirmModel.subNuber;
    }
    
    // 没有地址
    self.footerView.confirmModel = self.confirmModel;
    self.tabBarSubmit.confirmModel = self.confirmModel;
}

#pragma mark ---- 请求地址
- (void)getSubmitOrderAddressDataFromNetWork {
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString *urlStr = [NSString  stringWithFormat:@"%@?from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%d&user_id=%@",KGoodShop_ManageDress,[CurrentUserInformation sharedCurrentUserInfo].mobile,tokenlow,timestamp,[CurrentUserInformation sharedCurrentUserInfo].userId];
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
                            weakSelf.confirmModel.addressModel = modelAddress;
                        }
                        else { // 没有默认地址,取第一个地址返回
                            modelAddress = weakSelf.arrAddress[0];
                            weakSelf.confirmModel.addressModel = modelAddress;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                // 给页面赋值
                                [weakSelf.headerView sendDataWithModel:modelAddress];
                            });
                        }
                        if (weakSelf.confirmModel.addressModel.area_id) {
                            // 地址请求成功之后，请求快递的数据
                            [weakSelf getSubmitOrderDistributionWayData];
                        }
                    }
                }
            }
        }
    }];
}

#pragma mark ---- 请求快递的数据
- (void)getSubmitOrderDistributionWayData {
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];

    // 参数
    NSDictionary *parameters;

    self.confirmModel.isfastbuy = 1;
    
    if (self.sess_id) {
        // 购物车跳转的时候请求数据
        parameters = @{
                       @"is_fastbuy":[NSString stringWithFormat:@"%zi",self.confirmModel.isfastbuy],
                       @"area":[NSString stringWithFormat:@"%@",self.confirmModel.addressModel.area_id],
                       @"product_ids":[NSString stringWithFormat:@"%@",self.confirmModel.subGoodIds],
                       @"goodsnum":[NSString stringWithFormat:@"%@",self.confirmModel.subNuber]
                       };
    }
    else {
        // 详情跳转的时候请求数据
        parameters = @{
                       @"is_fastbuy":[NSString stringWithFormat:@"%zi",self.confirmModel.isfastbuy],
                       @"area":[NSString stringWithFormat:@"%@",self.confirmModel.addressModel.area_id]
                       };
    }
    NSString *html = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/cart-delivery_change.html?from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%@&user_id=%@&area=%@&is_fastbuy=%zi&sess_id=%@",[CurrentUserInformation sharedCurrentUserInfo].mobile,tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId,self.confirmModel.addressModel.area_id,self.confirmModel.isfastbuy,self.confirmModel.sess_id];
    html = [html stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient postPath:html parameters:parameters completion:^(WebAPIResponse *response){
//        NSLog(@"快递信息%@======%@",html,response.responseObject);
        [weakSelf.arrDistribution removeAllObjects];
        if (response.code == WebAPIResponseCodeSuccess) {
            if (![response.responseObject isKindOfClass:[NSNull class]]) {
                if (![response.responseObject[@"data"] isKindOfClass:[NSNull class]]) {
                    NSArray *dataObject = response.responseObject[@"data"];
                    if (dataObject.count > 0) {
                        for (NSDictionary *dict in dataObject) {
                            XZConfirmOrderModel *model = [[XZConfirmOrderModel alloc] init];
                            [model setValuesForKeysWithDictionary:dict];
                            [weakSelf.arrDistribution addObject:model];
                            // 默认申通
                            if ([model.isdefault integerValue] == 1) {
                                weakSelf.confirmModel.dt_name = model.dt_name;
                                weakSelf.confirmModel.money = model.money;
                                weakSelf.confirmModel.has_cod = model.has_cod;
                                weakSelf.confirmModel.isdefault = model.isdefault;
                                weakSelf.confirmModel.ID = model.ID;
                                weakSelf.confirmModel.isSelectedCell = YES;
                                model.isSelectedCell = YES;
                            }
                        }
                    }
                    
                    // 没有默认的申通快递
                    if (!weakSelf.confirmModel.dt_name) {
                        if (weakSelf.arrDistribution.count > 0) {
                            XZConfirmOrderModel *model = weakSelf.arrDistribution[0];
                            model.isSelectedCell = YES;
                            weakSelf.confirmModel.dt_name = model.dt_name;
                            weakSelf.confirmModel.money = model.money;
                            weakSelf.confirmModel.has_cod = model.has_cod;
                            weakSelf.confirmModel.isdefault = model.isdefault;
                            weakSelf.confirmModel.ID = model.ID;
                            weakSelf.confirmModel.isSelectedCell = model.isSelectedCell;
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 如果有默认快递
                        weakSelf.footerView.confirmModel = weakSelf.confirmModel;
                    });
                    
                    if (weakSelf.confirmModel.dt_name) {
                        // 切换地址后请求快递成功,请求总金额数据
                        [weakSelf calculateSubmitOrderTotalMoney];
                    }
                }
            }
        }
    }];
}

#pragma mark ---- 请求总金额的数据
-(void)calculateSubmitOrderTotalMoney
{
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary *parameter;
    if (self.sess_id) {
        // 购物车参数
        parameter = @{@"from":@"rongtuoapp",
                      @"appid":@"huiyuan",
                      @"tel":[CurrentUserInformation sharedCurrentUserInfo].mobile,
                      @"isfastbuy":@1,
                      @"purchase[addr_id]":@"Array",
                      @"purchase[def_area]":@"",
                      @"extends_args":@"{\"get\":[\"true\"],\"post\":{\"modify_quantity\":null}}",
                      @"address":[NSString stringWithFormat:@"{\"addr_id\":%@,\"area\":%@}",self.confirmModel.addressModel.addr_id,self.confirmModel.addressModel.area_id],
                      @"shipping":[NSString stringWithFormat:@"{\"id\":%@,\"has_cod\":\"false\",\"dt_name\":\"%@\",\"money\":\"%@\"}",self.confirmModel.ID,self.confirmModel.dt_name,self.confirmModel.money],
                      @"payment[pay_app_id]":[NSString stringWithFormat:@"{\"pay_app_id\":\"%@\",\"payment_name\":\"%@\"}",self.confirmModel.pay_app_id,self.confirmModel.payment_name],
                      @"payment[currency]":@"CNY",
                      @"memo":@"",
                      @"sess_id":self.confirmModel.sess_id,
                      @"coupon":[NSString stringWithFormat:@"%@",self.confirmModel.chooseTicket.cpns_code],
                      @"btype":@"is_fastbuy",
                      @"goods[goods_id]":[NSString stringWithFormat:@"%@",self.confirmModel.shopListModel.goods_id],
                      @"goods[num]":[NSString stringWithFormat:@"%zi",self.confirmModel.shopListModel.selectCount],
                      @"goods[product_id]":[NSString stringWithFormat:@"%@",self.confirmModel.shopListModel.product_id],
                      @"mini_cart":@"true",
                      @"usejifen":self.confirmModel.usedJifenDiKou,
                      @"product_ids":[NSString stringWithFormat:@"%@",self.confirmModel.subGoodIds],
                      @"goodsnum":[NSString stringWithFormat:@"%@",self.confirmModel.subNuber]
                      };
    }
    else {
        // 商品详情参数
        parameter = @{@"from":@"rongtuoapp",
                      @"appid":@"huiyuan",
                      @"tel":[CurrentUserInformation sharedCurrentUserInfo].mobile,
                      @"isfastbuy":@1,
                      @"purchase[addr_id]":@"Array",
                      @"purchase[def_area]":@"",
                      @"md5_cart_info":self.confirmModel.shopListModel.md5_cart_info,
                      @"extends_args":@"{\"get\":[\"true\"],\"post\":{\"modify_quantity\":null}}",
                      @"address":[NSString stringWithFormat:@"{\"addr_id\":%@,\"area\":%@}",self.confirmModel.addressModel.addr_id,self.confirmModel.addressModel.area_id],
                      @"shipping":[NSString stringWithFormat:@"{\"id\":%@,\"has_cod\":\"false\",\"dt_name\":\"%@\",\"money\":\"%@\"}",self.confirmModel.ID,self.confirmModel.dt_name,self.confirmModel.money],
                      @"payment[pay_app_id]":[NSString stringWithFormat:@"{\"pay_app_id\":\"%@\",\"payment_name\":\"%@\"}",self.confirmModel.pay_app_id,self.confirmModel.payment_name],
                      @"payment[currency]":@"CNY",
                      @"memo":@"",
                      @"sess_id":self.confirmModel.sess_id,
                      @"coupon":[NSString stringWithFormat:@"%@",self.confirmModel.chooseTicket.cpns_code],
                      @"btype":@"is_fastbuy",
                      @"goods[goods_id]":[NSString stringWithFormat:@"%@",self.confirmModel.shopListModel.goods_id],
                      @"goods[num]":[NSString stringWithFormat:@"%zi",self.confirmModel.shopListModel.selectCount],
                      @"goods[product_id]":[NSString stringWithFormat:@"%@",self.confirmModel.shopListModel.product_id],
                      @"mini_cart":@"true",
                      @"usejifen":self.confirmModel.usedJifenDiKou
                      };
    }
    __weak __typeof(&*self)weakSelf = self;
    NSString *html = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/cart-total.html?from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%@&user_id=%@&sess_id=%@",[CurrentUserInformation sharedCurrentUserInfo].mobile,tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId,self.confirmModel.sess_id];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    NSLog(@"请求总金额：%@====参数：%@",html,parameter);
    [FMHTTPClient postPath:html parameters:parameter completion:^(WebAPIResponse *response) {
//        NSLog(@"请求总金额返回数据====%@",response.responseObject);
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if (response.responseObject) {
            if (response.code == WebAPIResponseCodeSuccess) {
                if (![response.responseObject isKindOfClass:[NSNull class]]) {
                    if (![response.responseObject[@"data"] isKindOfClass:[NSNull class]]) {
                        
                        // 将切换地址置为NO
                        weakSelf.isChangedAddress = NO;
                        NSDictionary *dataDict = response.responseObject[@"data"];
                        weakSelf.confirmModel.totalMoney = dataDict[@"total"];
                        weakSelf.confirmModel.usedJifen = dataDict[@"usedJifen"];
                        weakSelf.confirmModel.jifen_discount = dataDict[@"jifen_discount"];
                        
//                        if ([weakSelf.confirmModel.jifen_discount floatValue] <= 0) {
//                            weakSelf.confirmModel.jifen_discount = @"0";
//                        }
                        
                        // 用户获得积分
                        weakSelf.confirmModel.jifen = dataDict[@"jifen"];
                        weakSelf.confirmModel.youhui = dataDict[@"youhui"];
                        weakSelf.confirmModel.tuijianyouhui = dataDict[@"tuijianyouhui"];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // 给页面赋值
                            weakSelf.footerView.confirmModel = weakSelf.confirmModel;
                            weakSelf.tabBarSubmit.confirmModel = weakSelf.confirmModel;
                            
                        });
                        // 请求用户积分数据
                        [weakSelf getUserCoinsDataFromNetwork];
                    }
                }
            }else {
                ShowAutoHideMBProgressHUD(weakSelf.view, response.responseObject[@"msg"]);
            }
        }
        [weakSelf.tableSubmitOrder.mj_header endRefreshing];
    }];
}

#pragma mark ----- 请求用户积分数据
- (void)getUserCoinsDataFromNetwork {
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=jifen&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString *string = [NSString stringWithFormat:@"%@?appid=jifen&user_id=%@&shijian=%d&token=%@",rongMiHeaderViewURL,[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow];
    
    __weak __typeof(&*self)weakSelf = self;
    //    NSLog(@"%@",string);
    [FMHTTPClient getPath:string parameters:nil completion:^(WebAPIResponse *response) {
//        NSLog(@"用户积分数据%@",response.responseObject);
        if (response.code == WebAPIResponseCodeSuccess) {
            if (![response.responseObject isKindOfClass:[NSNull class]]) {
                NSString *jifenUser = [NSString stringWithFormat:@"%@",response.responseObject[@"jifen"]];
                 weakSelf.confirmModel.jifenUser = jifenUser;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            weakSelf.footerView.confirmModel = weakSelf.confirmModel;
        });
    }];
}

#pragma mark --- 点击提交订单按钮
- (void)didClickConfirmOrderButton {
    if (self.isBack) { // 跳转我的订单
        
        //查看订单
        XZMyOrderViewController *orderView = [[XZMyOrderViewController alloc]init];
        orderView.isRemoveFather = YES;
        [self.navigationController pushViewController:orderView animated:YES];
    }else {
        if (!self.confirmModel.addressModel) {
            ShowAutoHideMBProgressHUD(self.view,@"请添加收货地址");
            return;
        }else if (!self.confirmModel.dt_name){
            ShowAutoHideMBProgressHUD(self.view,@"请选择配送方式");
            return;
        }else {
            // 提交订单获取订单号
            [self confirmOrderForOrderID];
        }
    }
}

#pragma mark --- 提交订单获取订单号
- (void)confirmOrderForOrderID {
    if (self.confirmModel.order_id) {
        [self payForOrder];
    }else {
        int timestamp = [[NSDate date] timeIntervalSince1970];
        NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
        NSString *tokenlow=[token lowercaseString];
        NSDictionary *parameter;
        if (self.sess_id) {
            // 购物车参数
            parameter = @{@"from":@"rongtuoapp",
                          @"tel":[CurrentUserInformation sharedCurrentUserInfo].mobile,
                          @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                          @"appid":@"huiyuan",
                          @"shijian":[NSNumber numberWithInt:timestamp],
                          @"sess_id":self.sess_id,
                          @"token":tokenlow,
                          @"is_fulljifen_ex":@"",
                          @"isfastbuy":@1,
                          @"purchase[addr_id]":@"Array",
                          @"purchase[def_area]":@"",
                          @"md5_cart_info":@"", // 购物车无此参数
                          @"extends_args":@"{\"get\":[\"true\"],\"post\":{\"modify_quantity\":null}}",
                          @"address":[NSString stringWithFormat:@"{\"addr_id\":%@,\"area\":%@}",self.confirmModel.addressModel.addr_id,self.confirmModel.addressModel.area_id],
                          @"shipping":[NSString stringWithFormat:@"{\"id\":%@,\"has_cod\":\"false\",\"dt_name\":\"%@\",\"money\":\"%@\"}",self.confirmModel.ID,self.confirmModel.dt_name,self.confirmModel.money],
                          @"payment[pay_app_id]":[NSString stringWithFormat:@"{\"pay_app_id\":\"%@\",\"payment_name\":\"%@\"}",self.confirmModel.pay_app_id,self.confirmModel.payment_name],
                          @"payment[currency]":@"CNY",
                          @"memo":self.confirmModel.userMsg,
                          @"coupon":[NSString stringWithFormat:@"%@",self.confirmModel.chooseTicket.cpns_code],
                          @"btype":@"is_fastbuy",
                          @"goods[goods_id]":[NSString stringWithFormat:@"%@",self.confirmModel.shopListModel.goods_id],
                          @"goods[num]":[NSString stringWithFormat:@"%zi",self.confirmModel.shopListModel.selectCount],
                          @"goods[product_id]":self.confirmModel.shopListModel.product_id,
                          @"mini_cart":@"true",
                          @"usejifen":self.confirmModel.usedJifenDiKou,
                          @"product_ids":[NSString stringWithFormat:@"%@",self.confirmModel.subGoodIds],
                          @"goodsnum":[NSString stringWithFormat:@"%@",self.confirmModel.subNuber]
                          };
        }else {
            // 参数
            parameter = @{@"from":@"rongtuoapp",
                          @"tel":[CurrentUserInformation sharedCurrentUserInfo].mobile,
                          @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                          @"appid":@"huiyuan",
                          @"shijian":[NSNumber numberWithInt:timestamp],
                          @"sess_id":self.confirmModel.sess_id,
                          @"token":tokenlow,
                          @"is_fulljifen_ex":@"",
                          @"isfastbuy":@1,
                          @"purchase[addr_id]":@"Array",
                          @"purchase[def_area]":@"",
                          @"md5_cart_info":self.confirmModel.shopListModel.md5_cart_info,
                          @"extends_args":@"{\"get\":[\"true\"],\"post\":{\"modify_quantity\":null}}",
                          @"address":[NSString stringWithFormat:@"{\"addr_id\":%@,\"area\":%@}",self.confirmModel.addressModel.addr_id,self.confirmModel.addressModel.area_id],
                          @"shipping":[NSString stringWithFormat:@"{\"id\":%@,\"has_cod\":\"false\",\"dt_name\":\"%@\",\"money\":\"%@\"}",self.confirmModel.ID,self.confirmModel.dt_name,self.confirmModel.money],
                          @"payment[pay_app_id]":[NSString stringWithFormat:@"{\"pay_app_id\":\"%@\",\"payment_name\":\"%@\"}",self.confirmModel.pay_app_id,self.confirmModel.payment_name],
                          @"payment[currency]":@"CNY",
                          @"memo":self.confirmModel.userMsg,
                          @"coupon":[NSString stringWithFormat:@"%@",self.confirmModel.chooseTicket.cpns_code],
                          @"btype":@"is_fastbuy",
                          @"goods[goods_id]":[NSString stringWithFormat:@"%@",self.confirmModel.shopListModel.goods_id],
                          @"goods[num]":[NSString stringWithFormat:@"%zi",self.confirmModel.shopListModel.selectCount],
                          @"goods[product_id]":self.confirmModel.shopListModel.product_id,
                          @"mini_cart":@"true",
                          @"usejifen":self.confirmModel.usedJifenDiKou
                          };
        }
//        NSLog(@"提交订单的参数========%@",parameter);
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        __weak __typeof(&*self)weakSelf = self;
        [FMHTTPClient postPath:@"https://www.rongtuojinrong.com/qdy/wap/order-create_client.html" parameters:parameter completion:^(WebAPIResponse *response) {
//            NSLog(@"获取订单号数据 ========== %@",response.responseObject);
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            if (response.responseObject) {
                if (response.code == WebAPIResponseCodeSuccess) {
                    NSDictionary *dataDict = response.responseObject[@"data"];
                    if (dataDict) {
                        if (![dataDict isKindOfClass:[NSString class]]) {
                            if (![dataDict[@"order_id"] isKindOfClass:[NSNull class]]) {
                                // 订单号
                                weakSelf.confirmModel.order_id = dataDict[@"order_id"];
//                                NSLog(@"订单号=======%@",weakSelf.confirmModel.order_id);
                                self.isBack = YES;
                                FMShareSetting.backNumber = 3;
                                // 如果金额为0,直接是支付成功，不用调起支付了
                                if ([weakSelf.confirmModel.totalMoney floatValue] > 0) {
                                    // 支付
                                    [weakSelf payForOrder];
                                }else {
                                    [self XZPayOrderResult:1];
                                }
                            }else {
                                if (response.responseObject[@"msg"]) {
                                    ShowAutoHideMBProgressHUD(weakSelf.view, [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]]);
                                }else {
                                    ShowAutoHideMBProgressHUD(weakSelf.view,@"获取订单号失败，请重试");
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
                }
                else {
                    if (response.responseObject[@"msg"]) {
                        ShowAutoHideMBProgressHUD(weakSelf.view, [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]]);
                    }else {
                        ShowAutoHideMBProgressHUD(weakSelf.view,@"获取订单号失败，请重试");
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
        }];
    }
}

#pragma mark --- 调起支付
- (void)payForOrder {
    
    NSString *totalMoney = self.confirmModel.totalMoney;

    CGFloat price = [totalMoney floatValue];
    // 支付宝支付
    if ([self.confirmModel.pay_app_id isEqualToString:@"alipay"]) {
        // 支付宝支付
        NSString *url = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/paycenter-alipayCheck.html?oid=%@",self.confirmModel.order_id];
        [self.payOrderStyle AliPayShopID:self.confirmModel.order_id withTitle:self.confirmModel.shopListModel.name Detail:self.confirmModel.shopListModel.name Price:[NSString stringWithFormat:@"%.2f",price] Url:url Returl:url];
    }else {
        // 微信支付
        NSString *wUrl = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/paycenter-wxpayCheck.html?oid=%@",self.confirmModel.order_id];
        [self.payOrderStyle WXPayShopID:self.confirmModel.order_id withTitle:self.confirmModel.shopListModel.name Detail:self.confirmModel.shopListModel.name Price:[NSString stringWithFormat:@"%.2f",price] Url:wUrl Returl:wUrl];
    }
}

#pragma mark ----- 回调方法
-(void)XZPayOrderResult:(NSInteger)rest;
{
    if (self.isDealCallBack) {
        if (rest == 1) {
            FMShareSetting.backNumber = 1;
            //成功
            [self.statusShowPay showSuccessWithView:self.view];
        }else
        { // 失败
            FMShareSetting.backNumber = 2;
            //        FMShowPayStatus *showPay = [[FMShowPayStatus alloc] init];
            //        showPay.delegate = self;
            [self.statusShowPay showFaileWithView:self.view];
        }
    }
}

-(void)FMShowPayStatusPayResult:(NSInteger)index
{
    // 将支付Model置空
    _payOrderStyle.delegate = nil;
    _payOrderStyle = nil;
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
        }else { // 跳转优商城
            FMRTWellStoreViewController *goodShop = [[FMRTWellStoreViewController
                                                       alloc] init];
            goodShop.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:goodShop animated:YES];
        }
    }
}


#pragma mark ----- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.shopDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZOptimalMallSubmitOrderCell *cell = [XZOptimalMallSubmitOrderCell CellMallSubmitOrderWithTableView:tableView];
    // self.confirmModel
    if (self.sess_id) { // 购物车跳
        FMShoppingListModel *shopListModel = self.shopDataSource[indexPath.row];
        cell.shopListModel = shopListModel;
    }else { // 商品详情跳
        cell.confirmModel = self.confirmModel;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (KProjectScreenWidth * 0.26 + 20);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
//    NSLog(@"买家留言 ========== %@",self.confirmModel.userMsg);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    self.isDealCallBack = NO;
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
                weakSelf.confirmModel.addressModel = modelAddress;
                // 用户传回来一个地址
                if (weakSelf.confirmModel.addressModel.area_id) {
                    // 将切换地址置为YES
                    weakSelf.isChangedAddress = YES;
                }else {// 没有回传地址
                    // 将切换地址置为NO
                    weakSelf.isChangedAddress = NO;
                    if (weakSelf.confirmModel.dt_name) {
                        [weakSelf.arrDistribution removeAllObjects];
                        weakSelf.confirmModel.dt_name = nil;
                        weakSelf.confirmModel.money = nil;
                        weakSelf.confirmModel.has_cod = nil;
                        weakSelf.confirmModel.isdefault = nil;
                        weakSelf.confirmModel.ID = nil;
                        weakSelf.confirmModel.isSelectedCell = NO;
                        weakSelf.footerView.confirmModel = weakSelf.confirmModel;
                    }
                }
            };
            // .addressModel.addr_id.length != 0
            if (weakSelf.confirmModel.addressModel.area.length != 0) { // 有值
                selectVC.addr_id_address = weakSelf.confirmModel.addressModel.addr_id;
            }
            [weakSelf.navigationController pushViewController:selectVC animated:YES];
        };
    }
    return _headerView;
}

- (XZOptimalMallSubmitOrderFooter *)footerView {
    if (!_footerView) {
        _footerView = [[XZOptimalMallSubmitOrderFooter alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 400)];
        __weak __typeof(&*self)weakSelf = self;
        _footerView.blockDidClickButton = ^(UIButton *button){
            [weakSelf.view endEditing:YES];
        // 601 配送方式  604积分抵扣  605使用优惠券 602 支付宝支付 603 微信支付
            if (button.tag == 601) { // 配送方式
                if (weakSelf.arrDistribution.count > 0) {
                    [weakSelf.activity changeActivityViewTitle:@"请选择配送方式" andCloseTitle:@"关闭"];
                    [weakSelf.activity showActivity];
                    weakSelf.activity.arrDistribution = weakSelf.arrDistribution;
                }else {
                    ShowAutoHideMBProgressHUD(weakSelf.view, @"当前没有配送方式可选择");
                }
            }else if(button.tag == 602) { // 支付宝支付
                //
                weakSelf.confirmModel.isAliPay = YES;
                weakSelf.confirmModel.isWechatPay = NO;
                if (weakSelf.confirmModel.isAliPay) {
                    weakSelf.confirmModel.pay_app_id = @"alipay";
                    weakSelf.confirmModel.payment_name = @"支付宝支付";
                }
            }else if(button.tag == 603) { // 微信支付
                //
                weakSelf.confirmModel.isWechatPay = YES;
                weakSelf.confirmModel.isAliPay = NO;
                if (weakSelf.confirmModel.isWechatPay) {
                    weakSelf.confirmModel.pay_app_id = @"mwxpay";
                    weakSelf.confirmModel.payment_name = @"微信支付";
                }
            }else if(button.tag == 604) { // 积分抵扣
                weakSelf.confirmModel.isCoinPay = !weakSelf.confirmModel.isCoinPay;
                if (weakSelf.confirmModel.isCoinPay) {
                    weakSelf.confirmModel.usedJifenDiKou = @"1";
                    [weakSelf calculateSubmitOrderTotalMoney];
                }else {
                    weakSelf.confirmModel.usedJifenDiKou = @"";
                    [weakSelf calculateSubmitOrderTotalMoney];
                }
                weakSelf.tabBarSubmit.confirmModel = weakSelf.confirmModel;
            }else if(button.tag == 605) { // 使用优惠券
                XZChooseTicketController *chooseTicket = [[XZChooseTicketController alloc] init];
                if (weakSelf.sess_id) {
                    chooseTicket.sess_id = weakSelf.sess_id;
                }else {
                    chooseTicket.sess_id = weakSelf.confirmModel.sess_id;
                }
                
                chooseTicket.blockChooseTicket = ^(XZChooseTicketModel *modelChoose){
                    weakSelf.confirmModel.chooseTicket = modelChoose;
                    [weakSelf calculateSubmitOrderTotalMoney];
                };
                if (weakSelf.confirmModel.chooseTicket.cpns_code.length != 0) {// 传递当前页面的优惠model
                    chooseTicket.cpns_code = weakSelf.confirmModel.chooseTicket.cpns_code;
                }
                [weakSelf.navigationController pushViewController:chooseTicket animated:YES];
            }
            weakSelf.footerView.confirmModel = weakSelf.confirmModel;
        };
        
        // 用户留言
        _footerView.blockSendUserMsg = ^(NSString *userMsg) {
            weakSelf.confirmModel.userMsg = userMsg;
        };
    }
    return _footerView;
}

// 配送方式页面
-(FMSelectAddressBottomView *)activity
{
    if (!_activity) {
        if (self.arrAddress) {
            _activity = [[FMSelectAddressBottomView alloc]init];
            __weak __typeof(&*self)weakSelf = self;
            // 点击关闭按钮
            _activity.blockDidClickClosed = ^(XZConfirmOrderModel *modelConfirm){// 给快递赋值
                weakSelf.confirmModel.dt_name = modelConfirm.dt_name;
                weakSelf.confirmModel.ID = modelConfirm.ID;
                weakSelf.confirmModel.money = modelConfirm.money;
                weakSelf.confirmModel.has_cod = modelConfirm.has_cod;
                weakSelf.confirmModel.isdefault = modelConfirm.isdefault;
                weakSelf.footerView.confirmModel = weakSelf.confirmModel;
                // 计算总金额
                [weakSelf calculateSubmitOrderTotalMoney];
            };
        }
    }
    return _activity;
}

- (XZOptimalMallSubmitOrderTabBar *)tabBarSubmit {
    if (!_tabBarSubmit) {
        _tabBarSubmit = [[XZOptimalMallSubmitOrderTabBar alloc] initWithFrame:CGRectMake(0, KProjectScreenHeight - 64 - 49, KProjectScreenWidth, 49)];
        __weak __typeof(&*self)weakSelf = self;
        _tabBarSubmit.blockClickConfirmOrder = ^(UIButton *button) {
            // 提交订单按钮请求数据
            [weakSelf didClickConfirmOrderButton];
        };
    }
    return _tabBarSubmit;
}

- (UITableView *)tableSubmitOrder {
    if (!_tableSubmitOrder) {
        _tableSubmitOrder =  [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 45 - 64) style:UITableViewStylePlain];
        _tableSubmitOrder.dataSource = self;
        _tableSubmitOrder.delegate = self;
        _tableSubmitOrder.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableSubmitOrder.tableHeaderView = self.headerView;
        _tableSubmitOrder.tableFooterView = self.footerView;
        _tableSubmitOrder.backgroundColor = XZColor(229, 233, 242);
        __weak __typeof(&*self)weakSelf = self;
        _tableSubmitOrder.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            // 如果有地址
            if (weakSelf.confirmModel.addressModel.addr_id) {
                // 地址请求成功之后，请求快递的数据
                [weakSelf getSubmitOrderDistributionWayData];
            }else { // 没有地址
                // 请求地址
                [weakSelf getSubmitOrderAddressDataFromNetWork];
            }
        }];

    }
    return _tableSubmitOrder;
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

-(XZConfirmOrderModel *)confirmModel
{
    if (!_confirmModel) {
        _confirmModel = [[XZConfirmOrderModel alloc] init];
    }
    return _confirmModel;
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
