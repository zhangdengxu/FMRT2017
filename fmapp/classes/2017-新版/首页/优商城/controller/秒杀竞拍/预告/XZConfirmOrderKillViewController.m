//
//  XZConfirmOrderKillViewController.m
//  fmapp
//
//  Created by admin on 16/8/18.
//  Copyright © 2016年 yk. All rights reserved.
//  秒杀确认订单

#import "XZConfirmOrderKillViewController.h"
#import "XZConfirmOrderKillView.h"
#import "XZConfirmOrderCell.h"
#import "SelectDressViewController.h" // 选择地址
//model
#import "FMShopSpecModel.h"
//
#import "XZConFirmOrderKillBottomView.h"
#import "XZShoppingOrderAddressModel.h"
#import "XZPayOrder.h"
#import "FMShowPayStatus.h"
#import "XZConfirmOrderTabBar.h"
#import "WLDJQTABViewController.h"// 优惠券列表

#import "FMTimeKillShopController.h"
#import "FMRTAuctionViewController.h"

@interface XZConfirmOrderKillViewController ()<UITableViewDataSource,UITableViewDelegate,XZPayOrderDelegate,FMShowPayStatusDelegate>

// tableView尾：支付方式
@property (nonatomic, strong) XZConFirmOrderKillBottomView *footer;
// tableView头：选择地址
@property (nonatomic, strong) XZConfirmOrderKillView *confirmOrderV;
@property (nonatomic, strong) XZPayOrder *payOrderStyle;
@property (nonatomic, strong) UITableView *tableConfirmOrder;
@property (nonatomic, strong) NSString *finalPrice;
@property (nonatomic, strong) XZConfirmOrderTabBar *tabBarOrder;
@end

@implementation XZConfirmOrderKillViewController

- (XZConfirmOrderKillView *)confirmOrderV {
    if (!_confirmOrderV) {
        _confirmOrderV = [[XZConfirmOrderKillView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 86)];
        __weak typeof(self)weakSelf = self;
        _confirmOrderV.modelProduct = self.shopDetailModel;
        if (!self.shopDetailModel.address || [self.shopDetailModel.address isMemberOfClass:[NSNull class]] || self.shopDetailModel.address.length == 0) {
             [self getUserAddressDataFromNetWork];
        }
        
        _confirmOrderV.blockChooseAddress = ^() {
            SelectDressViewController *selectVC = [[SelectDressViewController alloc]init];
            selectVC.hidesBottomBarWhenPushed = YES;
            selectVC.naviTitleName = @"选择收货地址";
            // 地址回调
            selectVC.blockAgainBtn = ^(XZShoppingOrderAddressModel *modelAddress){
                [weakSelf.confirmOrderV sendDataWithModel:modelAddress];
                weakSelf.shopDetailModel.addressModel = modelAddress;

                NSArray *areaArr = [modelAddress.area componentsSeparatedByString:@":"];
                if (areaArr.count > 1) { // 有地址编码
                    weakSelf.shopDetailModel.address = [NSString stringWithFormat:@"%@ %@",areaArr[1],modelAddress.addr];
                }else {
                    weakSelf.shopDetailModel.address = [NSString stringWithFormat:@"%@ %@",areaArr[0],modelAddress.addr];
                }
                weakSelf.shopDetailModel.recipients = modelAddress.name;
                weakSelf.shopDetailModel.phone = modelAddress.mobile;
            };
            // .addressModel.addr_id.length != 0
            if (weakSelf.shopDetailModel.addressModel) { // 有值
              selectVC.addr_id_address = weakSelf.shopDetailModel.addressModel.addr_id;
            }
//            NSLog(@"秒杀竞拍选择地址weakSelf.shopDetailModel.addressModel.addr_id = %@",weakSelf.shopDetailModel.addressModel.addr_id);
            [weakSelf.navigationController pushViewController:selectVC animated:YES];
        };

    }
    return _confirmOrderV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"确认订单"];
    [self.view addSubview:self.tableConfirmOrder];
    if (self.shopDetailModel.kill_id) {
        self.shopDetailModel.price = self.shopDetailModel.sale_price;
    
    }
    self.shopDetailModel.store = @1;
    
    [self addTabBar];

    CGFloat money = [self.shopDetailModel.price floatValue];
    self.finalPrice = [NSString stringWithFormat:@"%.2f",money];
    
    
    self.shopDetailModel.payment_name = @"支付宝支付";
    self.shopDetailModel.pay_app_id  = @"alipay";
    self.view.backgroundColor = KDefaultOrBackgroundColor;
    
    // 如果是第二次出价
    if (self.shopDetailModel.ticket_state) { // 1 抵价券可以使用
        if ([self.shopDetailModel.ticket_amount integerValue] > 0) { // 抵价券前一个页面传过
            CGFloat price = [self.shopDetailModel.price floatValue] - [self.shopDetailModel.ticket_amount floatValue];
//            NSLog(@"price === %f,ticket_amount = %@",price,self.shopDetailModel.ticket_amount);
            if (price > 0) {
                NSString *priceStr = [NSString stringWithFormat:@"%.2f",price];
                self.finalPrice = priceStr;
                [self.tabBarOrder setTabBarWithValue:priceStr];
            }else {
                NSString *priceStr = [NSString stringWithFormat:@"0.00"];
                self.finalPrice = priceStr;
                [self.tabBarOrder setTabBarWithValue:priceStr];
            }
        }
    }
    
//    NSLog(@"self.finalPrice ======== %@",self.finalPrice);
}

// 请求地址
- (void)getUserAddressDataFromNetWork {
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSString *urlStr = [NSString  stringWithFormat:KGoodShop_ManageDress@"?from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%d&user_id=%@",[CurrentUserInformation sharedCurrentUserInfo].mobile,tokenlow,timestamp,[CurrentUserInformation sharedCurrentUserInfo].userId];
    
    [FMHTTPClient  getPath:urlStr parameters:nil completion:^(WebAPIResponse *response) {
//        NSLog(@"response.responseObject = %@",response.responseObject);
        if (response.code == WebAPIResponseCodeSuccess) {
            NSArray *addressData = response.responseObject[@"data"];
            if (addressData.count == 0) {
                XZShoppingOrderAddressModel *model = [[XZShoppingOrderAddressModel alloc]init];
                model.def_addr = 0;
                [self.confirmOrderV sendDataWithModel:model];
//                NSLog(@"%@------%@------%@------%@",model.mobile,model.name,model.addr,model.area);
            }else
            {
                XZShoppingOrderAddressModel *modelAddress;
                for (NSDictionary *dic in addressData) {
                    XZShoppingOrderAddressModel *model = [[XZShoppingOrderAddressModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    
                    if (model.def_addr == 1 ) { // 默认地址
                        modelAddress = model;
                    }
                }
                if (modelAddress) {
                    [self.confirmOrderV sendDataWithModel:modelAddress];
                     self.shopDetailModel.addressModel = modelAddress;
                     NSArray *areaArr = [modelAddress.area componentsSeparatedByString:@":"];
                    if (areaArr.count > 1) { // 有地址编码
                        self.shopDetailModel.address = [NSString stringWithFormat:@"%@ %@",areaArr[1],modelAddress.addr];
                    }else {
                        self.shopDetailModel.address = [NSString stringWithFormat:@"%@ %@",areaArr[0],modelAddress.addr];
                    }
                    self.shopDetailModel.recipients = modelAddress.name;
                    self.shopDetailModel.phone = modelAddress.mobile;
                    
                }else
                {
                    
                }
                
            }
            
        }
    }];
}


- (void)addTabBar {
    __weak typeof(self)weakSelf = self;
    XZConfirmOrderTabBar *tabBarOrder = [[XZConfirmOrderTabBar alloc] initWithFrame:CGRectMake(0, KProjectScreenHeight - 113, KProjectScreenWidth, 49)];
    [self.view addSubview:tabBarOrder];
    self.tabBarOrder = tabBarOrder;
    tabBarOrder.modelProductTab = self.shopDetailModel;
    tabBarOrder.blockSubmitOrderBtn = ^() {
        [weakSelf didClickSubmitOrderBtn];
    };
}

// 提交订单按钮点击事件
- (void)didClickSubmitOrderBtn {
    if (!self.shopDetailModel.addressModel.addr_id) {
        ShowAutoHideMBProgressHUD(self.view,@"请添加收货地址");
        return;
    }else {
         // 提交订单按钮请求数据
        [self putAllDataToNetWork];
    }
}

//  提交订单按钮请求数据
- (void)putAllDataToNetWork {

        int timestamp = [[NSDate date]timeIntervalSince1970];
        NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
        NSString *tokenlow=[token lowercaseString];
//        // 获取area
//        NSArray *areaArr = [self.shopDetailModel.addressModel.area componentsSeparatedByString:@":"];
//        NSDictionary * parameter = [NSDictionary dictionary];
    
    
    NSMutableString * shopspec = [NSMutableString string];
    for (FMShopCollectionInfoModel * shopLocaInfp in self.shopDetailModel.locationArray) {
        [shopspec appendString:shopLocaInfp.contentString];
        [shopspec appendString:@","];
    }
    NSString *goods_spec;
    if (shopspec.length > 0) {
        goods_spec = [shopspec substringToIndex:[shopspec length] - 1];
    }
    
    
        NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
        if (self.shopDetailModel.auction_id) {
            [parameter setObject:self.shopDetailModel.auction_id forKey:@"auction_id"];
            
            [parameter setObject:self.shopDetailModel.price forKey:@"price"];
            
        }else
        {
            [parameter setObject:self.shopDetailModel.kill_id forKey:@"kill_id"];
        }
        
        [parameter setObject:self.shopDetailModel.product_id forKey:@"product_id"];
        
    
        [parameter setObject:[CurrentUserInformation sharedCurrentUserInfo].userId forKey:@"user_id"];
        [parameter setObject:tokenlow forKey:@"token"];
        [parameter setObject:@"appid" forKey:@"appid"];
        [parameter setObject:[NSNumber numberWithInt:timestamp] forKey:@"shijian"];

    
    [parameter setObject:[NSString stringWithFormat:@"%@",self.shopDetailModel.address] forKey:@"address"];
    [parameter setObject:self.shopDetailModel.addressModel.addr_id forKey:@"address_id"];
    [parameter setObject:self.shopDetailModel.recipients forKey:@"recipients"];
    [parameter setObject:self.shopDetailModel.phone forKey:@"phone"];
    [parameter setObject:self.shopDetailModel.pay_app_id forKey:@"pay_type"];
    
    
        if (self.shopDetailModel.ticket_id) {
            [parameter setObject:self.shopDetailModel.ticket_id forKey:@"ticket_id"];
        }
    
        if (goods_spec) {
             [parameter setObject:goods_spec forKey:@"goods_spec"];
        }
    
    
        NSString * htmlGetOrder;
    
    if (self.shopDetailModel.auction_id) {
        
        htmlGetOrder =[NSString stringWithFormat:@"%@/public/order/auctionOrder",kXZTestEnvironment];

        //htmlGetOrder = @"https://www.rongtuojinrong.com/java/public/order/auctionOrder";
    }else
    {
        
        htmlGetOrder =[NSString stringWithFormat:@"%@/public/order/killOrder",kXZTestEnvironment];
        
        //htmlGetOrder = @"https://www.rongtuojinrong.com/java/public/order/killOrder";
    }
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:htmlGetOrder parameters:parameter completion:^(WebAPIResponse *response) {
        
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!response.responseObject) {
            ShowAutoHideMBProgressHUD(self.view,@"获取订单号失败，请重试");
            return;
        }
        if (response.code == WebAPIResponseCodeSuccess) {
            NSDictionary *dataDict = response.responseObject[@"data"];
            if (dataDict) {
                
                if (![dataDict isMemberOfClass:[NSNull class]]) {
                    
                    if (![dataDict[@"record_id"] isMemberOfClass:[NSNull class]]) {
                        // 支付订单号
                        self.shopDetailModel.pay_trade_no = [NSString stringWithFormat:@"%@",dataDict[@"pay_trade_no"]];
                        // 竞拍交易记录标识
                        self.shopDetailModel.record_id  = [NSString stringWithFormat:@"%@",dataDict[@"record_id"]];
                        // 支付
                        if ([self.finalPrice floatValue] == 0) {
                            [self paySuccessAndCallToNetWorkWithState:1];
                        }else
                        {
                            [self payForOrder];
                        }
                        
                    }else {
                        ShowAutoHideMBProgressHUD(self.view,@"获取订单号失败，请重试");
                    }
                }else
                {
                    ShowAutoHideMBProgressHUD(self.view,response.responseObject[@"msg"]);
                }
            }else {
                ShowAutoHideMBProgressHUD(self.view,@"获取订单号失败，请重试");
            }
        }
        
        
        
    }];
}

// 支付
- (void)payForOrder {
    // 支付宝支付
    if ([self.shopDetailModel.pay_app_id isEqualToString:@"alipay"]) {
        // 支付宝支付
        CGFloat price = [self.finalPrice floatValue];

        NSString *url;
        if (self.shopDetailModel.auction_id) {
            
           
            
            url =[NSString stringWithFormat:@"%@/public/callback/pay/buyAuctionNoticeFromAlipay",kXZTestEnvironment];
            
            //竞拍
            //url = @"https://www.rongtuojinrong.com/java/public/callback/pay/buyAuctionNoticeFromAlipay";
        }else
        {
            
             url =[NSString stringWithFormat:@"%@/public/callback/pay/buyKillNoticeFromAlipay",kXZTestEnvironment];
            
            //秒杀
            //url = @"https://www.rongtuojinrong.com/java/public/callback/pay/buyKillNoticeFromAlipay";
        }
        
        
        [self.payOrderStyle AliPayShopID:self.shopDetailModel.pay_trade_no withTitle:self.shopDetailModel.title Detail:self.shopDetailModel.title Price:[NSString stringWithFormat:@"%.2f",price] Url:url Returl:url type:11];
        
    }else {
        // 微信支付
        CGFloat price = [self.finalPrice floatValue];

        NSString *wUrl;
        
        if (self.shopDetailModel.auction_id) {
            
            
             wUrl =[NSString stringWithFormat:@"%@/public/callback/pay/buyAuctionNoticeFromWxpay",kXZTestEnvironment];
            //竞拍
            //wUrl = @"https://www.rongtuojinrong.com/java/public/callback/pay/buyAuctionNoticeFromWxpay";
        }else{
            
           
            
            wUrl =[NSString stringWithFormat:@"%@/public/callback/pay/buyKillNoticeFromWxpay",kXZTestEnvironment];
            
            
            //秒杀
            //wUrl = @"https://www.rongtuojinrong.com/java/public/callback/pay/buyKillNoticeFromWxpay";
        }
        
        [self.payOrderStyle WXPayShopID:self.shopDetailModel.pay_trade_no withTitle:self.shopDetailModel.title Detail:self.shopDetailModel.title Price:[NSString stringWithFormat:@"%.2f",price] Url:wUrl Returl:wUrl type:11];
        
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark ----- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1; // self.shopDataSource.count
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZConfirmOrderCell *cell = [XZConfirmOrderCell cellConfirmOrderWithTableView:tableView];
    cell.modelShopInfo = self.shopDetailModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (KProjectScreenWidth * 0.32);
}

- (XZConFirmOrderKillBottomView *)footer {
    if (!_footer) {
        _footer = [[XZConFirmOrderKillBottomView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 323)];
        __weak typeof(self)weakSelf = self;
        _footer.shopDetailModel = self.shopDetailModel;
        
        // 点击优惠券按钮
        _footer.blockDetailBtn = ^(UIButton *button) {
            if (weakSelf.shopDetailModel.kill_id) { // 秒杀
                if ([self.shopDetailModel.price floatValue] < 10.00) {
                    ShowAutoHideMBProgressHUD(weakSelf.view,@"10元及以下商品，不支持使用抵价券");
                    return;
                }
            }
            WLDJQTABViewController *djq = [[WLDJQTABViewController alloc] init];
            djq.state = @"1";
            djq.tag = @"";
            
            if (weakSelf.shopDetailModel.kill_id) {
                djq.flag = @"kill";
            }else {
                djq.flag = @"auction";
            }
            djq.blockSupportTicket = ^(FMSelectShopInfoModel *modelShopInfo) {
                CGFloat price = [weakSelf.shopDetailModel.price floatValue] - [modelShopInfo.amount floatValue];
                weakSelf.shopDetailModel.ticket_id = modelShopInfo.ticket_id;
                if (price < 0) {
                    NSString *priceStr = [NSString stringWithFormat:@"0.00"];
                    weakSelf.finalPrice = priceStr;
                    [weakSelf.tabBarOrder setTabBarWithValue:priceStr];
                }else {
                    NSString *priceStr = [NSString stringWithFormat:@"%.2f",price];
                    weakSelf.finalPrice = priceStr;
                    [weakSelf.tabBarOrder setTabBarWithValue:priceStr];
                }
                [weakSelf.footer setValueWithModel:modelShopInfo];
            };
            // 暂不使用优惠券
            djq.blockBottomButton = ^(){
                FMSelectShopInfoModel *modelNouseCoupon = [[FMSelectShopInfoModel alloc] init];
                modelNouseCoupon.unUseCoupon = YES;
                [weakSelf.footer setValueWithModel:modelNouseCoupon];
                // 价格变为传过来的商品的价格
                CGFloat money = [weakSelf.shopDetailModel.price floatValue];
                weakSelf.finalPrice = [NSString stringWithFormat:@"%.2f",money];
                [weakSelf.tabBarOrder setTabBarWithValue:weakSelf.finalPrice];
            };
//            NSLog(@"暂不使用优惠券的最终价格%@",weakSelf.finalPrice);
            [weakSelf.navigationController pushViewController:djq animated:YES];
        };
        
        // 点击支付方式和优惠、积分按钮
        _footer.blockPrivilegeBtn = ^(UIButton *button){
            switch (button.tag) {
                case 100: { // 微信支付
                    weakSelf.shopDetailModel.payment_name = @"微信支付";
                    weakSelf.shopDetailModel.pay_app_id  = @"wxpay";
                }
                    break;
                case 101: // 支付宝支付
                {
                    weakSelf.shopDetailModel.payment_name = @"支付宝支付";
                    weakSelf.shopDetailModel.pay_app_id  = @"alipay";
                }
                    break;
                default:
                {
                    
                    break;
                }
            }
        };

    }
    return _footer;
}


-(void)XZPayOrderResultWithStatus:(NSString *)resultStatus;
{
   if ([self.shopDetailModel.pay_app_id  isEqualToString: @"wxpay"]) {
        //微信支付
        if ([resultStatus isEqualToString:@"1"]) {
            
            [self paySuccessAndCallToNetWorkWithState:1];
        }else
        {
             [self paySuccessAndCallToNetWorkWithState:2];

        }
    }else
    {
        //支付宝支付
        if ([resultStatus isEqualToString:@"9000"]) {
            
            [self paySuccessAndCallToNetWorkWithState:1];
        }else
        {
             [self paySuccessAndCallToNetWorkWithState:2];

        }
    }
}

-(void)paySuccessAndCallToNetWorkWithState:(NSInteger)states
{
    
    
    NSString * flagtype;
    if (self.shopDetailModel.kill_id) {
        flagtype = @"kill";
    }else
    {
        flagtype = @"auction";
    }
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * paras = @{@"appid":@"huiyuan",
                             @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                             @"shijian":[NSNumber numberWithInt:timestamp],
                             @"token":tokenlow,
                             @"activity_type":flagtype,
                             @"record_id":self.shopDetailModel.record_id,
                             @"actual_payment":self.finalPrice,
                             @"pay_flag":[NSNumber numberWithInteger:states]
                             };
    
//     NSLog(@"paras=====>%@",paras);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
     NSString *navUrl = [NSString stringWithFormat:@"%@/public/order/paySucceed",kXZTestEnvironment];
    //@"https://www.rongtuojinrong.com/java/public/order/paySucceed"
    
    [FMHTTPClient postPath:navUrl parameters:paras completion:^(WebAPIResponse *response) {
        
//         NSLog(@"response=====>%@",response.responseObject);
        //支付成功
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if (response.code == WebAPIResponseCodeSuccess) {
            if (states == 1) {
                ShowAutoHideMBProgressHUD(self.view,@"支付成功");
                [self performSelector:@selector(retuRootViewController) withObject:nil afterDelay:2.0f];
            }else
            {
                ShowAutoHideMBProgressHUD(self.view,@"支付失败");
            }
        }else
        {
            ShowAutoHideMBProgressHUD(self.view,@"支付失败");
        }
    }];
}

-(void)retuRootViewController
{
    if (self.shopDetailModel.kill_id) {
        FMTimeKillShopController * killVC;
        for (UIViewController * vc in self.navigationController.viewControllers) {
            if ([vc isMemberOfClass:[FMTimeKillShopController class]]) {
                killVC = (FMTimeKillShopController *)vc;
            }
        }
        
        if (killVC) {
            [self.navigationController popToViewController:killVC animated:YES];
        }else
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    }else
    {
        FMRTAuctionViewController * auctiomVC;
        for (UIViewController * vc in self.navigationController.viewControllers) {
            if ([vc isMemberOfClass:[FMRTAuctionViewController class]]) {
                auctiomVC = (FMRTAuctionViewController *)vc;
            }
        }
        
        if (auctiomVC) {
            [self.navigationController popToViewController:auctiomVC animated:YES];
        }else
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}


-(XZPayOrder *)payOrderStyle
{
    if (!_payOrderStyle) {
        _payOrderStyle = [[XZPayOrder alloc]init];
        _payOrderStyle.delegate = self;
    }
    return _payOrderStyle;
}

- (UITableView *)tableConfirmOrder {
    if (!_tableConfirmOrder) {
        _tableConfirmOrder =  [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 49) style:UITableViewStylePlain];
        _tableConfirmOrder.dataSource = self;
        _tableConfirmOrder.delegate = self;
        _tableConfirmOrder.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableConfirmOrder.tableHeaderView = self.confirmOrderV;
        _tableConfirmOrder.tableFooterView = self.footer;
        _tableConfirmOrder.backgroundColor = KDefaultOrBackgroundColor;
        
    }
    return _tableConfirmOrder;
}

@end
