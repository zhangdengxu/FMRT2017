//
//  FMRTWellStoreSaledDealViewController.m
//  fmapp
//
//  Created by apple on 2016/12/9.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTWellStoreSaledDealViewController.h"
#import "FMRTWellStoreSaledDealTableViewCell.h"
#import "FMRTWellStoreGrayTableViewCell.h"
#import "FMRTWellStoreSaledDealModel.h"
#import "FMRTWellStoreSaledFooterView.h"
#import "SignOnDeleteView.h"
#import "WLRequestViewController.h"
#import "XZMyOrderGoodsModel.h"
#import "WLXieShangViewController.h"

@interface FMRTWellStoreSaledDealViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) FMRTWellStoreSaledFooterView *footView;

@end

@implementation FMRTWellStoreSaledDealViewController

static NSString *FMRTWellStoreSaledDealTableViewCellID = @"FMRTWellStoreSaledDealTableViewCellID";
static NSString *FMRTWellStoreGrayTableViewCellID = @"FMRTWellStoreGrayTableViewCellID";


- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"协商退款退货"];
    [self createTableView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self requestDataFromNetwork];
}

- (void)requestDataFromNetwork{
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSString *string = [NSString stringWithFormat:@"%@?appid=huiyuan&user_id=%@&from=rongtuoapp&shijian=%@&token=%@&tel=%@&aftersale_id=%@",@"https://www.rongtuojinrong.com/qdy/wap/member-process_client.html",[CurrentUserInformation sharedCurrentUserInfo].userId,[NSNumber numberWithInt:timestamp],tokenlow,[CurrentUserInformation sharedCurrentUserInfo].mobile,self.orderID];

    FMWeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:string parameters:nil completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        if (response.responseObject) {
            
            if (response.code == WebAPIResponseCodeSuccess) {
                
                if ([response.responseObject objectForKey:@"data"]) {
                    
                    [weakSelf.dataSource removeAllObjects];
                    id dicID = [response.responseObject objectForKey:@"data"];
                    
                    if ([dicID isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dic = (NSDictionary *)dicID;
                        if ([dic objectForKey:@"afterSaleStatus"] && [dic objectForKey:@"ProductSendBack"] ) {
                            
                            NSInteger aftersalestaus = [[dic objectForKey:@"afterSaleStatus"] integerValue];
                            NSInteger ProductSendBack = [[dic objectForKey:@"ProductSendBack"] integerValue];
                            [weakSelf changeTableStutsWithNumber:aftersalestaus sendBack:ProductSendBack];
                        }
                        if ([dic objectForKey:@"lists"]) {
                            id lists = [dic objectForKey:@"lists"];
                            if ([lists isKindOfClass:[NSArray class]]) {
                                
                                NSArray *listArr = (NSArray *)lists;
                                
                                if (listArr.count) {
                                    for (NSDictionary *dic in listArr) {
                                        FMRTWellStoreSaledDealModel *model = [[FMRTWellStoreSaledDealModel alloc]init];
                                        [model setValuesForKeysWithDictionary:dic];
                                        [weakSelf.dataSource addObject:model];
                                    }
                                }
                            }
                        }
                    }
                }
            }else{
                ShowAutoHideMBProgressHUD(weakSelf.view, @"请求数据失败");
            }
        }else{
            ShowAutoHideMBProgressHUD(weakSelf.view, @"请求网络数据失败");
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    }];
}

- (void)changeTableStutsWithNumber:(NSInteger)aftersalestaus sendBack:(NSInteger)sendBack{
    //售后处理状态 1 未操作 2 审核中(用户提交申请之后状态即为2) 3 接受申请(同意) 4 退款/退货完成 5 拒绝（拒绝之后左侧显示申请售后-重新申请） 6 已收货 7 已质检 8 补差价 9 已拒绝退款 10 用户已撤销

    self.footView.saleType = aftersalestaus;
    if (aftersalestaus == 4 ||aftersalestaus == 6 ||aftersalestaus == 7 || aftersalestaus == 8 ||aftersalestaus == 1) {//4退款完成,6\7\8隐藏
        self.footView.hidden = YES;
        self.tableView.frame = CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 64);
    }else if(aftersalestaus == 3){//同意
        if (sendBack == 1) {//1 已填快递
            self.tableView.frame = CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 64);
            self.footView.hidden = YES;
        }else{//0未填快递
            self.footView.hidden = NO;
            self.tableView.frame = CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 64 - 60);
        }
    }else{
        self.footView.hidden = NO;
        self.tableView.frame = CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 64 - 60);
        if (aftersalestaus == 2) {

        }else if(aftersalestaus == 5){

        }else if(aftersalestaus == 9){

        }else if(aftersalestaus == 10){

        }
    }
}

- (void)createTableView{
    
    _tableView = ({
        UITableView *tableview= [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth , KProjectScreenHeight - 64 - 60) style:(UITableViewStylePlain)];
        tableview.backgroundColor = [UIColor whiteColor];
        tableview.delegate=self;
        tableview.dataSource=self;
        tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        FMWeakSelf;
        tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf requestDataFromNetwork];
        }];
        tableview;
    });
    [self.view addSubview:_tableView];
}

- (FMRTWellStoreSaledFooterView *)footView{
    if (!_footView) {
        FMWeakSelf;

        _footView = [[FMRTWellStoreSaledFooterView alloc]initWithFrame:CGRectMake(0, KProjectScreenHeight - 60 - 64, KProjectScreenWidth, 60)];
        _footView.changeBlock = ^(){
            [weakSelf changeRequestForSale];
        };
        _footView.cancelBlock = ^(){
            [weakSelf cancelRequestForSale];
        };
        _footView.telBlock = ^(){
            [weakSelf tellForWorkers];
        };
        _footView.afterSaleBlock = ^(){
            [weakSelf afterSaleRequest];
        };
        _footView.tuihuoBlock = ^(){
            [weakSelf tiuhuotuihuo];
        };
        [self.view addSubview:_footView];
    }
    return _footView;
}

#pragma mark - 退货
- (void)tiuhuotuihuo{

    WLXieShangViewController *xiuVC = [WLXieShangViewController new];
    xiuVC.model = self.model;
    xiuVC.aftersale_id = self.orderID;
    [self.navigationController pushViewController:xiuVC animated:YES];
}

#pragma mark - 申请售后
- (void)afterSaleRequest{

    WLRequestViewController *request = [[WLRequestViewController alloc]init];
    request.model = self.model;
    request.tag = @"0";
    FMWeakSelf;
    request.buttonSpread =^(NSString *afterSaleID){
        weakSelf.orderID = afterSaleID;
    };
    [self.navigationController pushViewController:request animated:YES];
}

#pragma mark - 修改申请
- (void)changeRequestForSale{

    WLRequestViewController *request = [[WLRequestViewController alloc]init];
    request.model = self.model;
    request.tag = @"1";
    [self.navigationController pushViewController:request animated:YES];
}

- (void)cancelRequestForSale{
    SignOnDeleteView *signOn = [[SignOnDeleteView alloc]init];
    signOn.chexiao = 1;
    [signOn showSignViewWithTitle:@"确认撤销申请么？" detail:@"是否撤销？如有疑问，请联系客服"];
    FMWeakSelf;
    signOn.sureBlock = ^(UIButton *button) {
        [weakSelf calcelWithSure];
    };
}

#pragma mark - 撤销申请
- (void)calcelWithSure{

    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSString *string = [NSString stringWithFormat:@"%@?appid=huiyuan&user_id=%@&from=rongtuoapp&shijian=%@&token=%@&tel=%@&aftersale_id=%@",@"https://www.rongtuojinrong.com/qdy/wap/member-process_cancel_client.html",[CurrentUserInformation sharedCurrentUserInfo].userId,[NSNumber numberWithInt:timestamp],tokenlow,[CurrentUserInformation sharedCurrentUserInfo].mobile,self.orderID];
    
    FMWeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:string parameters:nil completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];

        if (response.responseObject) {
            
            if (response.code == WebAPIResponseCodeSuccess) {
                
                if ([response.responseObject objectForKey:@"data"]) {
                    id data = [response.responseObject objectForKey:@"data"];
                    
                    if ([data isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dic = (NSDictionary *)data;
                        if ([dic objectForKey:@"afterSaleStatus"]) {
                            NSInteger afterSaleStatus = [[data objectForKey:@"afterSaleStatus"] integerValue];
                            
                            [weakSelf changeTableStutsWithNumber:afterSaleStatus sendBack:0];
                            [weakSelf requestDataFromNetwork];
                        }
                    }
                }
            }else{
                ShowAutoHideMBProgressHUD(weakSelf.view, @"撤销失败");
            }
        }else{
            ShowAutoHideMBProgressHUD(weakSelf.view, @"请求数据失败");
        }
    }];
}

#pragma mark - 联系客服
- (void)tellForWorkers{

    UIWebView *webView = [[UIWebView alloc]init];
    NSURL *url = [NSURL URLWithString:@"tel://400-878-8686"];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FMRTWellStoreSaledDealModel *model = self.dataSource[indexPath.row];
    if ([model.msgType isEqualToString:@"system"]) {
        FMRTWellStoreSaledDealTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FMRTWellStoreSaledDealTableViewCellID];
        if (cell == nil) {
            cell = [[FMRTWellStoreSaledDealTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:FMRTWellStoreSaledDealTableViewCellID];
        }
        cell.model = self.dataSource[indexPath.row];
        return cell;
    }else{
        FMRTWellStoreGrayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FMRTWellStoreGrayTableViewCellID];
        if (cell == nil) {
            cell = [[FMRTWellStoreGrayTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:FMRTWellStoreGrayTableViewCellID];
        }
        cell.model = self.dataSource[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    FMRTWellStoreSaledDealModel *model = self.dataSource[indexPath.row];
    if ([model.msgType isEqualToString:@"system"]) {
        return [FMRTWellStoreSaledDealTableViewCell heightForCellWith:self.dataSource[indexPath.row]];
    }else{
        return [FMRTWellStoreGrayTableViewCell heightForCellWith:self.dataSource[indexPath.row]];
    }
}

@end
