//
//  YYMyOrderNewController.m
//  fmapp
//
//  Created by yushibo on 2016/10/31.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "YYMyOrderNewController.h"

#import "YYMyOrderNewCell.h"
#import "SignOnDeleteView.h"
#import "YYMyOrderNewModel.h"
#import "FMShopDetailDuobaoViewController.h"
#import "FMDuobaoClass.h"
//跳转界面
#import "XZCommonProblemsController.h"  //常见问题
#import "XZPublishBaskNewController.h"  //发表晒单数据
#import "WLFollowingViewController.h" //物流界面
#import "FMRTAllTakeBuyResultViewController.h" // 支付结果的展示

#import "XZPayOrder.h"

#import "Fm_Tools.h"
// 夺宝币支付
#define kXZUseCoinToPay [NSString stringWithFormat:@"%@/public/newon/order/coinPay",kXZTestEnvironment]
#define iOS8Later ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)

@interface YYMyOrderNewController ()<UITableViewDataSource, UITableViewDelegate, XZPayOrderDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 全部订单按钮  */
@property (nonatomic, strong)UIButton *allOrderBtn;
/** 已完成订单按钮  */
@property (nonatomic, strong)UIButton *alreadyOrderBtn;
/** 失效订单按钮  */
@property (nonatomic, strong)UIButton *failureOrderBtn;

@property (nonatomic, assign) NSString *state;
/** 暂无数据 */
@property (nonatomic, strong) UILabel *alertLabel;
// 最终价格
@property (nonatomic, strong) NSString *finalPrice;
// 支付
@property (nonatomic, strong) XZPayOrder *payOrderStyle;

/**
 *   往支付微信成功回调方法里面传值
 */
@property (nonatomic, assign) NSString *goods_name;
@property (nonatomic, assign) NSString *way_unit_cost;
@property (nonatomic, assign) NSString *pay_type;

/**
 *   服务器当前时间
 */
@property (nonatomic, assign) NSString *sys_time;
@end

@implementation YYMyOrderNewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithHexString:@"#e5e9f2"];
    self.currentPage = 1;
    self.state = @"0,1,10,20,21,22,23,99";
    [self settingNavTitle:@"我的订单"];
    [self setTopSelectTitleView];
    [self createTableView];
    [self creatBackTopView];
    [self getWinningMessageReadFromNetWork];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getOrderDataSourceFromNetWork];
    
}

#pragma mark --- 懒加载
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (UILabel *)alertLabel
{
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc]initWithFrame:CGRectMake((KProjectScreenWidth/2 - 50), (KProjectScreenHeight/3), 100, 30)];
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        _alertLabel.text = @"暂无数据";
        _alertLabel.textColor = [UIColor darkGrayColor];
        _alertLabel.font = [UIFont boldSystemFontOfSize:16];
        [self.view addSubview:_alertLabel];
    }
    return _alertLabel;
}
-(XZPayOrder *)payOrderStyle
{
    if (!_payOrderStyle) {
        _payOrderStyle = [[XZPayOrder alloc]init];
        _payOrderStyle.delegate = self;
    }
    return _payOrderStyle;
}
#pragma mark --- 我的订单 -- 网络请求

- (void)getOrderDataSourceFromNetWork{
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString *urlStr =[NSString stringWithFormat:@"%@/public/newon/show/getUserOrderList",kXZTestEnvironment];
    NSDictionary * parameter = @{@"appid":@"huiyuan",
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"state":self.state,
                                 @"page":[NSString stringWithFormat:@"%d", self.currentPage],
                                 };
    
    __weak __typeof(self)weakSelf = self;
    [FMHTTPClient postPath:urlStr parameters:parameter completion:^(WebAPIResponse *response) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (response.responseObject == nil) {
//            ShowAutoHideMBProgressHUD(self.view, NETERROR_LOADERR_TIP);
            /** 暂无数据提示 */
            if (weakSelf.dataSource.count == 0) {
                weakSelf.alertLabel.hidden = NO;
            }else{
                weakSelf.alertLabel.hidden = YES;
            }
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            return;
        }
        
        if(response.code == WebAPIResponseCodeSuccess){

                NSArray *newArray = [NSArray arrayWithArray:response.responseObject[@"data"]];

                if (![newArray isMemberOfClass:[NSNull class]]) {

                    if (newArray.count) {

                        for(NSDictionary *dict in newArray){
                            
                            YYMyOrderNewModel *model = [[YYMyOrderNewModel alloc]init];
                            [model setValuesForKeysWithDictionary:dict];
                            
                            [weakSelf.dataSource addObject:model];
                        }
                    }
                    /** 暂无数据提示 */
                    if (weakSelf.dataSource.count == 0) {
                        weakSelf.alertLabel.hidden = NO;
                    }else{
                        weakSelf.alertLabel.hidden = YES;
                    }
                }
        }else{
            
            ShowAutoHideMBProgressHUD(self.view, response.responseObject[@"msg"]);
            /** 暂无数据提示 */
            if (weakSelf.dataSource.count == 0) {
                weakSelf.alertLabel.hidden = NO;
            }else{
                weakSelf.alertLabel.hidden = YES;
            }

        }
        
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    
}
#pragma mark --- 隐藏删除订单 -- 网络请求

- (void)getDeleteOrderDataSourceFromNetWorkWithIndexPath:(NSIndexPath *)indexPath withRecord_id:(NSString *)record_id{
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString *urlStr =[NSString stringWithFormat:@"%@/public/newon/show/hideOrderRecord",kXZTestEnvironment];
    NSDictionary * parameter = @{@"appid":@"huiyuan",
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"record_id":record_id,
                                 };
    __weak typeof (self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:urlStr parameters:parameter completion:^(WebAPIResponse *response) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if (response.code == WebAPIResponseCodeSuccess) {
            ShowAutoHideMBProgressHUD(weakSelf.view, @"删除成功");
            
            [weakSelf.dataSource removeObjectAtIndex:indexPath.row];
            NSArray *indexPaths = @[indexPath]; // 构建 索引处的行数 的数组
            // 删除 索引的方法 后面是动画样式
            [weakSelf.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:(UITableViewRowAnimationLeft)];
        }else if (response.code == WebAPIResponseCodeFailed)
        {
            ShowAutoHideMBProgressHUD(weakSelf.view, response.responseObject[@"msg"]);
        }else
        {
            ShowAutoHideMBProgressHUD(weakSelf.view, @"删除失败");
        }
    }];
}

#pragma mark --- 中奖信息已读通知 -- 网络请求

- (void)getWinningMessageReadFromNetWork{
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString *urlStr =[NSString stringWithFormat:@"%@/public/newon/show/readLotteryInfo",kXZTestEnvironment];
    NSDictionary * parameter = @{@"appid":@"huiyuan",
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow                                 };
    [FMHTTPClient postPath:urlStr parameters:parameter completion:^(WebAPIResponse *response) {
        
        if (response.responseObject == nil) {return;}
        if(response.code == WebAPIResponseCodeSuccess){}
        
    }];
    
}
#pragma mark --- 查询服务器系统时间 -- 网络请求

- (void)getSysTimeFromNetWork:(YYMyOrderNewModel *)model{
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString *urlStr =[NSString stringWithFormat:@"%@/public/other/getSysTime",kXZTestEnvironment];
    NSDictionary * parameter = @{@"appid":@"huiyuan",
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
         };
    
    __weak typeof (self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:urlStr parameters:parameter completion:^(WebAPIResponse *response) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];

        if (!response.responseObject) {
            ShowAutoHideMBProgressHUD(weakSelf.view, @"请求数据失败");
            return;
        }
        if(response.code == WebAPIResponseCodeSuccess){
        
            NSDictionary *dict = [NSDictionary dictionaryWithDictionary:response.responseObject[@"data"]];
            self.sys_time = dict[@"sys_time"];
            [self getPayOrder:model];
        }else{
        
            ShowAutoHideMBProgressHUD(weakSelf.view, @"支付失败,请稍后再试");
        }
        
    }];
    
}

#pragma mark --- 延长订单取消时间 -- 网络请求

- (void)getLengthenCancelTimeFromNetWorkWithLengthen:(NSString *)lengthen withRecordId:(NSString *)record_id withEndTime:(NSString *)endTime withModel:(YYMyOrderNewModel *)model{
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString *urlStr =[NSString stringWithFormat:@"%@/public/newon/order/lengthenCancelTime",kXZTestEnvironment];
    NSDictionary * parameter = @{@"appid":@"huiyuan",
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"lengthen":lengthen,
                                 @"record_id":record_id
                                     };
    
    __weak typeof (self)weakSelf = self;
    [FMHTTPClient postPath:urlStr parameters:parameter completion:^(WebAPIResponse *response) {
        
        if (response.responseObject == nil) {
            ShowAutoHideMBProgressHUD(weakSelf.view, @"请求数据失败");

            return;}
        if(response.code == WebAPIResponseCodeSuccess){
        
            [self payEndOrder:model withEndTime:endTime];
        
        }else{
        
            NSString *state = [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]];
            if ([state integerValue] == 0) {//已取消
                ShowAutoHideMBProgressHUD(weakSelf.view, @"订单已取消,请重新下单");
            }else if ([state integerValue] == 10){//已付款
                ShowAutoHideMBProgressHUD(weakSelf.view, @"订单已支付,请刷新界面");
            }else if ([state integerValue] == 20){//等待揭晓
                ShowAutoHideMBProgressHUD(weakSelf.view, @"抽奖即将揭晓,请刷新界面");
            }else if ([state integerValue] == 21){//已中奖
                ShowAutoHideMBProgressHUD(weakSelf.view, @"已中奖,请刷新界面");
            }else if ([state integerValue] == 22){//未中奖
                ShowAutoHideMBProgressHUD(weakSelf.view, @"未中奖,请刷新界面");
            }else if ([state integerValue] == 23){//已退款
                ShowAutoHideMBProgressHUD(weakSelf.view, @"已退款,请刷新界面");
            }else if ([state integerValue] == 99){//已发货
                ShowAutoHideMBProgressHUD(weakSelf.view, @"订单已发货,请刷新界面");
            }
            
        }
        
    }];
    
}

#pragma mark --- 使用夺宝币支付订单
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
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:kXZUseCoinToPay parameters:paras completion:^(WebAPIResponse *response) {
        //        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        NSLog(@"使用夺宝币支付订单response=====%@",response.responseObject);
        //支付成功
        if (response.code == WebAPIResponseCodeSuccess) {
            
            NSDictionary *dict = response.responseObject[@"data"];
            if (![dict isKindOfClass:[NSNull class]]) {
                
                FMDuobaoClassSelectStyle *duobaoShop = [FMDuobaoClassSelectStyle new];
                // 幸运号码
                NSString *lucky_code = dict[@"lucky_code"];
                duobaoShop.lucky_code = lucky_code;
                
                // 消费后用户的夺宝币账户余额
                NSString *balance = dict[@"balance"];
                duobaoShop.balance = balance;
                FMRTAllTakeBuyResultViewController *allTakeBuy = [[FMRTAllTakeBuyResultViewController alloc] init];
                allTakeBuy.duobaoShop = duobaoShop;
                
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
                }else { // 7
                    allTakeBuy.resultOfPay = DuobaobiFailureOfPay;
                    [weakSelf.navigationController pushViewController:allTakeBuy animated:YES];
                }
            }
            
            /**
             *
             */
            [self.dataSource removeAllObjects];
            self.currentPage = 1;
//            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self getOrderDataSourceFromNetWork];
        }else {
            ShowAutoHideMBProgressHUD(weakSelf.view,@"支付失败,请稍后再试");
        }
    }];
}

#pragma mark --- 微信,支付宝---支付
- (void)getPayOrder:(YYMyOrderNewModel *)model{
    YYMyOrderNewModel *payModel = model;
    
    NSString *record_id = payModel.record_id;
    //时间戳转为时间
    NSTimeInterval closeTime=[payModel.close_time doubleValue];
    NSDate *closeDate=[NSDate dateWithTimeIntervalSince1970:closeTime];
    
    NSTimeInterval currentTime=[self.sys_time doubleValue];
    NSDate *currentDate=[NSDate dateWithTimeIntervalSince1970:currentTime];
//    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
//    [dateFormatter1 setDateFormat:@"yyyyMMddHHmmss"];
//    NSString *hhh = [dateFormatter1 stringFromDate:currentDate];
    NSInteger seconds = [closeDate timeIntervalSinceDate:currentDate];
    if (seconds <= 0 ) {
        ShowAutoHideMBProgressHUD(self.view, @"订单已经超时,请重新下单");
        return;
    }
    // 支付宝支付
    if ([payModel.pay_type isEqualToString:@"alipay"]) {
        
        NSString *endTime;
        
        if (seconds >= 60) {
            CGFloat a = seconds / 60.0;
            int b = floor(a);
            endTime = [NSString stringWithFormat:@"%dm", b];
            /**
             *  延迟时间上传
             */
            
            NSString *lengthen = @"1";
            [self getLengthenCancelTimeFromNetWorkWithLengthen:lengthen withRecordId:record_id withEndTime:endTime withModel:model];
        }else{
        
            endTime = @"5m";
            
            /**
             *  延迟时间上传
             */
            CGFloat c = (5 * 60 - seconds) / 60.0;
            int d = ceil(c);
            int f = d * 60;
            NSString *lengthen = [NSString stringWithFormat:@"%d", f];
            [self getLengthenCancelTimeFromNetWorkWithLengthen:lengthen withRecordId:record_id withEndTime:endTime withModel:model];
        }
        
    }else {
        // 微信支付
        
        NSString *endTime;
        
        if (seconds >= 300) {
            CGFloat a = seconds / 60.0;
            int b = floor(a);
            endTime = [NSString stringWithFormat:@"%dm", b];
            NSString *second2 = [NSString stringWithFormat:@"%d",b * 60];
            
            NSDate *date1 = [NSDate dateWithTimeInterval:[second2 longLongValue] sinceDate:currentDate];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
            endTime = [dateFormatter stringFromDate:date1];
            
            /**
             *  延迟时间上传
             */
            
            NSString *lengthen = @"1";
            [self getLengthenCancelTimeFromNetWorkWithLengthen:lengthen withRecordId:record_id withEndTime:endTime withModel:model];
            
            
        }else{
            
            endTime = @"5m";
            NSDate *date2 = [NSDate dateWithTimeInterval:300 sinceDate:currentDate];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
            endTime = [dateFormatter stringFromDate:date2];

            /**
             *  延迟时间上传
             */
            CGFloat c = (5 * 60 - seconds) / 60.0;
            int d = ceil(c);
            int f = d * 60;
            NSString *lengthen = [NSString stringWithFormat:@"%d", f];
            [self getLengthenCancelTimeFromNetWorkWithLengthen:lengthen withRecordId:record_id withEndTime:endTime withModel:model];
        }

    }
}

- (void)payEndOrder:(YYMyOrderNewModel *)model withEndTime:(NSString *)endTime{
    YYMyOrderNewModel *payModel = model;

    // 支付宝支付
    if ([payModel.pay_type isEqualToString:@"alipay"]) {
        
        CGFloat price = [payModel.way_unit_cost floatValue];
        // 支付宝支付回调
        NSString *url = [NSString stringWithFormat:@"%@/public/newon/pay/buyWonGoodsNoticeFromAlipay",kXZTestEnvironment];
        
        [self.payOrderStyle AliPayShopID:payModel.pay_trade_no withTitle:payModel.goods_name Detail:payModel.goods_name Price:[NSString stringWithFormat:@"%.2f",price] Url:url Returl:url type:11 withendTime:endTime];
    }else {
        // 微信支付
        
        CGFloat price = [payModel.way_unit_cost floatValue];
        // 微信支付回调
        NSString *wUrl = [NSString stringWithFormat:@"%@/public/newon/pay/buyWonGoodsNoticeFromWxpay",kXZTestEnvironment];
        
        [self.payOrderStyle WXPayShopID:payModel.pay_trade_no withTitle:payModel.goods_name Detail:payModel.goods_name Price:[NSString stringWithFormat:@"%.2f",price] Url:wUrl Returl:wUrl type:11 withEndTime:endTime];
    }

    
}
#pragma mark --- 微信,支付宝---支付回调
-(void)XZPayOrderResultWithStatus:(NSString *)resultStatus;
{
    __weak typeof (self)weakSelf = self;
    void(^blockSuccess)() = ^() { // 支付成功
        FMRTAllTakeBuyResultViewController *allTakeBuy = [[FMRTAllTakeBuyResultViewController alloc] init];
        
        FMDuobaoClassSelectStyle *duobaoshop = [[FMDuobaoClassSelectStyle alloc]init];
        duobaoshop.goods_name = weakSelf.goods_name;
        
        FMDuobaoClassStyle * duobaoClass = [[FMDuobaoClassStyle alloc]init];
        duobaoClass.won_cost = weakSelf.way_unit_cost;
        
        duobaoshop.selectModel = duobaoClass;
        allTakeBuy.duobaoShop = duobaoshop;
        allTakeBuy.resultOfPay = OldFiriendPriceSuccessOfPay;
        [weakSelf.navigationController pushViewController:allTakeBuy animated:YES];
    };
    if ([self.pay_type  isEqualToString: @"wxpay"]) {
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

#pragma mark --- 创建TabeView
- (void)createTableView{
    
    UITableView *tableview= [[UITableView alloc]initWithFrame:CGRectMake(0, 46, KProjectScreenWidth, KProjectScreenHeight - 46 - 64)style:(UITableViewStylePlain)];
    tableview.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    tableview.delegate=self;
    tableview.dataSource=self;
    tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView = tableview;
    __weak typeof (self)weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _currentPage = 1;
        [weakSelf.dataSource removeAllObjects];
        [weakSelf getOrderDataSourceFromNetWork];
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _currentPage = _currentPage+1;
        [weakSelf getOrderDataSourceFromNetWork];
    }];

    [self.view addSubview:self.tableView];
    
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataSource.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    __weak typeof (self)weakSelf = self;
    static NSString *ID1 = @"YYMyOrderNewCell";
    YYMyOrderNewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID1  ];
    if (cell == nil) {
        cell = [[YYMyOrderNewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID1];
    }

    if (self.dataSource.count) {
        
        cell.status = weakSelf.dataSource[indexPath.row];
    }
    
    cell.shareBlockBtn = ^(){
        XZPublishBaskNewController *publishN = [[XZPublishBaskNewController alloc]init];
        YYMyOrderNewModel *payModel = weakSelf.dataSource[indexPath.row];
        publishN.lucky_record = payModel.record_id;
        [weakSelf.navigationController pushViewController:publishN animated:YES];
    };
    
    cell.wuliuBlockBtn = ^(){
    
        WLFollowingViewController *wuliu = [[WLFollowingViewController alloc]init];
        
        YYMyOrderNewModel *wuliuModel = weakSelf.dataSource[indexPath.row];
        wuliu.com = wuliuModel.express_company;
        wuliu.nu = wuliuModel.tracking_num;
        wuliu.tag = @"1";
        if ([wuliuModel.tracking_num isKindOfClass:[NSNull class]]||wuliuModel.tracking_num.length == 0) {
            wuliu.isFromDuobao = @"yes";
        }else{
            wuliu.isFromDuobao = @"物流信息";
        }
        [weakSelf.navigationController pushViewController:wuliu animated:YES];
    };
    /**
     *  跳转付款页面
     */
        cell.payBlockBtn = ^(){
            
                YYMyOrderNewModel *payModel = weakSelf.dataSource[indexPath.row];
                if ([payModel.way_type integerValue] == 1) {

                    SignOnDeleteView *signOn = [[SignOnDeleteView alloc]init];
                    
                    [signOn showSignViewWithTitle:@"确定进行付款吗？"];
                    // 点击确定按钮
                    signOn.sureBlock = ^(UIButton *button) {
                    [weakSelf useCoinToPayOrder:payModel.record_id];
            
                    };
                }else{
                
                    weakSelf.goods_name = payModel.goods_name;
                    weakSelf.way_unit_cost = payModel.way_unit_cost;
                    weakSelf.pay_type = payModel.pay_type;
                    [weakSelf getSysTimeFromNetWork:payModel];
                    
                }
            
        };
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 140;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    FMShopDetailDuobaoViewController *shopD = [[FMShopDetailDuobaoViewController alloc]init];
    YYMyOrderNewModel *model = self.dataSource[indexPath.row];
    shopD.product_id =model.product_id;
    shopD.won_id = model.won_id;
    [self.navigationController pushViewController:shopD animated:YES];
    
}
#pragma mark --- 左滑删除键

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
        
    if (self.dataSource.count) {
        
    YYMyOrderNewModel *model = self.dataSource[indexPath.row];
    
//    状态 0超时取消,1支付失败,22未中奖,23已退款  有删除按钮
    if (([model.state integerValue] == 0)||([model.state integerValue] == 1)||([model.state integerValue] == 22)||([model.state integerValue] == 23)) {
        return YES;
    }else{
        return NO;
    }
        
    }else{
    
        return NO;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof (self)weakSelf = self;

    if (iOS8Later) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
            SignOnDeleteView *signOn = [[SignOnDeleteView alloc]init];
            [signOn showSignViewWithTitle:@"确定删除订单么？" detail:@"删除订单后就无法恢复订单了"];
            // 点击确定按钮
            signOn.sureBlock = ^(UIButton *button) {
                
                YYMyOrderNewModel *model = weakSelf.dataSource[indexPath.row];
                NSString *record_id = model.record_id;
                /** 调取删除请求 */
                [weakSelf getDeleteOrderDataSourceFromNetWorkWithIndexPath:indexPath withRecord_id:record_id];
            };

        }
    }

}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{

    __weak typeof (self)weakSelf = self;

    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击删除按钮");
        SignOnDeleteView *signOn = [[SignOnDeleteView alloc]init];
        [signOn showSignViewWithTitle:@"确定删除订单么？" detail:@"删除订单后就无法恢复订单了"];

        // 点击确定按钮
        signOn.sureBlock = ^(UIButton *button) {

            YYMyOrderNewModel *model = weakSelf.dataSource[indexPath.row];
            NSString *record_id = model.record_id;
            /** 调取删除请求 */
            [weakSelf getDeleteOrderDataSourceFromNetWorkWithIndexPath:indexPath withRecord_id:record_id];
        };

    }];
    action.backgroundColor = [UIColor colorWithHexString:@"#fb673d"];
    return @[action];
}
#pragma mark ---全部订单 + 已完成订单 + 失效订单
- (UIButton *)allOrderBtn {
    
    if (!_allOrderBtn) {
        _allOrderBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_allOrderBtn setTitle:@"全部订单" forState:(UIControlStateNormal)];
        [_allOrderBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateNormal)];
        [_allOrderBtn setTitleColor:[HXColor colorWithHexString:@"#FF6633"] forState:(UIControlStateSelected)];
        _allOrderBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_allOrderBtn addTarget:self action:@selector(allOrderBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _allOrderBtn;
}

- (UIButton *)alreadyOrderBtn {
    
    if (!_alreadyOrderBtn) {
        _alreadyOrderBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_alreadyOrderBtn setTitle:@"已完成订单" forState:(UIControlStateNormal)];
        [_alreadyOrderBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateNormal)];
        [_alreadyOrderBtn setTitleColor:[HXColor colorWithHexString:@"#FF6633"] forState:(UIControlStateSelected)];
        _alreadyOrderBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_alreadyOrderBtn addTarget:self action:@selector(alreadyOrderBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _alreadyOrderBtn;
}
- (UIButton *)failureOrderBtn {
    
    if (!_failureOrderBtn) {
        _failureOrderBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_failureOrderBtn setTitle:@"失效订单" forState:(UIControlStateNormal)];
        [_failureOrderBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateNormal)];
        [_failureOrderBtn setTitleColor:[HXColor colorWithHexString:@"#FF6633"] forState:(UIControlStateSelected)];
        _failureOrderBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_failureOrderBtn addTarget:self action:@selector(failureOrderBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _failureOrderBtn;
}
- (void)allOrderBtnAction:(UIButton *)sender{
    //全部订单
    self.allOrderBtn.selected = YES;
    self.alreadyOrderBtn.selected = NO;
    self.failureOrderBtn.selected = NO;
    
    [self.dataSource removeAllObjects];
    self.currentPage = 1;
    self.state = @"0,1,10,20,21,22,23,99";
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getOrderDataSourceFromNetWork];
}
- (void)alreadyOrderBtnAction:(UIButton *)sender{
    //已完成订单
    self.allOrderBtn.selected = NO;
    self.alreadyOrderBtn.selected = YES;
    self.failureOrderBtn.selected = NO;
   
    [self.dataSource removeAllObjects];
    self.state = @"10,20,21,22,23,99";
    self.currentPage = 1;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getOrderDataSourceFromNetWork];
}
- (void)failureOrderBtnAction:(UIButton *)sender{
    //失效订单
    self.allOrderBtn.selected = NO;
    self.alreadyOrderBtn.selected = NO;
    self.failureOrderBtn.selected = YES;

    [self.dataSource removeAllObjects];
    self.state = @"0,1";
    self.currentPage = 1;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getOrderDataSourceFromNetWork];
}

#pragma mark ----头部选择器
- (void)setTopSelectTitleView{
    
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    [topView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(@45);
    }];
    self.allOrderBtn.selected = YES;
    self.alreadyOrderBtn.selected = NO;
    self.failureOrderBtn.selected = NO;
    [topView addSubview:self.allOrderBtn];
    [topView addSubview:self.alreadyOrderBtn];
    [topView addSubview:self.failureOrderBtn];

    [self.alreadyOrderBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(topView);
        make.centerX.equalTo(topView.mas_centerX);
        make.width.equalTo(KProjectScreenWidth / 3);
    }];
    UIView *leftLine = [[UIView alloc]init];
    leftLine.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [self.view addSubview:leftLine];
    [leftLine makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.alreadyOrderBtn.mas_left);
        make.width.equalTo(1);
        make.top.equalTo(topView.mas_top).offset(12);
        make.bottom.equalTo(topView.mas_bottom).offset(-12);
    }];

    [self.allOrderBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(topView);
        make.right.equalTo(leftLine.mas_left);
    }];
    
    UIView *rightLine = [[UIView alloc]init];
    rightLine.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [self.view addSubview:rightLine];
    [rightLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.alreadyOrderBtn.mas_right);
        make.width.equalTo(1);
        make.top.equalTo(topView.mas_top).offset(12);
        make.bottom.equalTo(topView.mas_bottom).offset(-12);
    }];
    
    [self.failureOrderBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(topView);
        make.left.equalTo(rightLine.mas_right);
    }];
    
}
#pragma mark ---回到顶部
- (void)creatBackTopView{
    
    //联系客服-改版
    UIButton *questionBtn = [[UIButton alloc]init];
    [questionBtn setImage:[UIImage imageNamed:@"联系客服-改版"] forState:UIControlStateNormal];
    [questionBtn sizeToFit];
    [questionBtn addTarget:self action:@selector(questionToPerson:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:questionBtn];
    [questionBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.top.equalTo(self.view.mas_top).offset(KProjectScreenHeight/5*3);
        make.height.equalTo(35);
        make.width.equalTo(35);
    }];
    
    
    UIButton *backbtn = [[UIButton alloc]init];
    [backbtn setImage:[UIImage imageNamed:@"返回顶部"] forState:UIControlStateNormal];
    [backbtn sizeToFit];
    [backbtn addTarget:self action:@selector(controlLocationButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbtn];
    [backbtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.top.equalTo(questionBtn.mas_bottom).offset(15);
        make.height.equalTo(35);
        make.width.equalTo(35);
    }];
    
    
}
//回到顶部
-(void)controlLocationButtonOnClick:(UIButton *)button
{
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}
- (void)questionToPerson:(UIButton *)button{
    
    XZCommonProblemsController *vc = [[XZCommonProblemsController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
