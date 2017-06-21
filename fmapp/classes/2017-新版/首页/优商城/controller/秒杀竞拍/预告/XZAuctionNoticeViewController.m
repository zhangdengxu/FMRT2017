//
//  XZAuctionNoticeViewController.m
//  XZProject
//
//  Created by admin on 16/8/8.
//  Copyright © 2016年 admin. All rights reserved.
//  精品竞拍预告

#import "XZAuctionNoticeViewController.h"
#import "XZAuctionNoticeCell.h" // cell
#import "XZAuctionNoticeModel.h"
#import "FMTimeKillShopDetailController.h" // 商品详情
#import "FMPlaceOrderViewController.h" // 优商城的商品详情







@interface XZAuctionNoticeViewController ()<UITableViewDelegate,UITableViewDataSource>
/**  */
@property (nonatomic, strong) UITableView *tableNotice;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) UIImageView *imgNodata;
@end

@implementation XZAuctionNoticeViewController
- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}

- (UIImageView *)imgNodata {
    if (!_imgNodata) {
        _imgNodata = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, KProjectScreenWidth, KProjectScreenWidth * 1136 / 640.0 - 50)];
        _imgNodata.image = [UIImage imageNamed:@"data_empty_iv"];
    }
    return _imgNodata;
}

- (UITableView *)tableNotice {
    if (!_tableNotice) {
        _tableNotice = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 64) style:UITableViewStylePlain];
        _tableNotice.delegate = self;
        _tableNotice.dataSource  = self;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenWidth / 640 * 105)];
        imgView.image = [UIImage imageNamed:@"竞拍秒杀底部视图"];
        _tableNotice.tableFooterView = imgView;
        _tableNotice.tableFooterView.hidden = YES;
        // 刷新
        _tableNotice.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            // 请求数据
            [self getAuctionNoticeDataFromNetWork];
        }];

    }
    return _tableNotice;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.flag isEqualToString:@"auction"]) {
        [self settingNavTitle:@"精品竞拍预告"];
    }else {
        [self settingNavTitle:@"精品秒杀预告"];
    }
    //
    [self.view addSubview:self.tableNotice];
    // 从网络上获取数据
    [self getAuctionNoticeDataFromNetWork];
}

// 从网络上获取数据
- (void)getAuctionNoticeDataFromNetWork {
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    
    NSString *useId = [CurrentUserInformation sharedCurrentUserInfo].userId ? [CurrentUserInformation sharedCurrentUserInfo].userId : @"0";
    
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",useId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary *parameter = @{@"user_id":useId,
                                  @"appid":@"huiyuan",
                                  @"shijian":[NSNumber numberWithInt:timestamp],
                                  @"token":tokenlow,
                                  @"flag":self.flag
                              };
    
//    NSDictionary *parameter ;
//    
//    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) { // 已登录
//        
//        NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
//        NSString *tokenlow=[token lowercaseString];
//        parameter = @{@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
//                                    @"appid":@"huiyuan",
//                                    @"shijian":[NSNumber numberWithInt:timestamp],
//                                    @"token":tokenlow,
//                                    @"flag":self.flag
//                                    };
//        
//    }else { // 未登录
//        
//        NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",@"0",timestamp]);
//        NSString *tokenlow=[token lowercaseString];
//        parameter = @{@"user_id":@"0",
//                        @"appid":@"huiyuan",
//                                    @"shijian":[NSNumber numberWithInt:timestamp],
//                                    @"token":tokenlow,
//                                    @"flag":self.flag
//                                    };
//    }
    
   
    __weak __typeof(&*self)weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *navUrl =[NSString stringWithFormat:@"%@/public/show/getKillChoiceness",kXZTestEnvironment];
    
    
    // @"https://www.rongtuojinrong.com/java/public/show/getKillChoiceness" // 竞拍
    
    [FMHTTPClient postPath:navUrl parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (self.dataSourceArray.count != 0) {
            [self.dataSourceArray removeAllObjects];
        }
        if (response.code == WebAPIResponseCodeSuccess) {
            if (![response.responseObject isKindOfClass:[NSNull class]]) {
                NSArray *dataArray = response.responseObject[@"data"];
                if (dataArray.count != 0) {
                    for (NSDictionary *dic in dataArray) {
                        XZAuctionNoticeModel *modelAuction = [[XZAuctionNoticeModel alloc] init];
                        [modelAuction setValuesForKeysWithDictionary:dic];
                         modelAuction.flag = self.flag;
                        [self.dataSourceArray addObject:modelAuction];
                        // 去掉无数据提示
                        [self.imgNodata removeFromSuperview];
                        self.tableNotice.tableFooterView.hidden = NO;
                    }
                }else {
                    // 无数据
                    if (self.dataSourceArray.count == 0) {
                        [self.view addSubview:self.imgNodata];
                        self.tableNotice.tableFooterView.hidden = YES;
                    }
                }
            }else{
//                ShowAutoHideMBProgressHUD(weakSelf.view,@"请重新加载");
                // 无数据
                if (self.dataSourceArray.count == 0) {
                    [self.view addSubview:self.imgNodata];
                    self.tableNotice.tableFooterView.hidden = YES;
                }
            }
        }
        else { // 请求失败：没联网
            // 无数据
            if (self.dataSourceArray.count == 0) {
                [self.view addSubview:self.imgNodata];
                self.tableNotice.tableFooterView.hidden = YES;
            }
        }
        [weakSelf.tableNotice.mj_header endRefreshing];
        [weakSelf.tableNotice reloadData];
    }];
    
}

#pragma mark ----- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZAuctionNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noticeCell"];
    if (!cell) {
        cell = [[XZAuctionNoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noticeCell"];
    }
    XZAuctionNoticeModel *modelAuction = self.dataSourceArray[indexPath.row];
    cell.modelAuction = modelAuction;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KProjectScreenWidth / 640 * 300 + 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XZAuctionNoticeModel *modelAuction = self.dataSourceArray[indexPath.row];
    NSString *state = [NSString stringWithFormat:@"%@",modelAuction.activity_state];
    NSString *product_id = [NSString stringWithFormat:@"%@",modelAuction.product_id];
    NSString *price = [NSString stringWithFormat:@"%@",modelAuction.sale_price];
    if ([state isEqualToString:@"2"]) { // 跳转
        FMTimeKillShopDetailController *detailVc = [[FMTimeKillShopDetailController alloc] init];
        detailVc.detailURL = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/product/index_client/%@.html",product_id];
        detailVc.product_id = product_id;
        detailVc.actionFlag = modelAuction.kill_id;
        detailVc.killPrice = price;
        detailVc.activity_state = state;
        if ([self.flag isEqualToString:@"kill"]) { // 秒杀
            detailVc.shopDetailStyle = 1;
        }else {
            detailVc.shopDetailStyle = 0;
        }
        // 竞拍：maxPrice 当前界面；limitPrice 最低价格；
        // 秒杀：sale_price
        [self.navigationController pushViewController:detailVc animated:YES];
    }else if ([state isEqualToString:@"0"] || [state isEqualToString:@"1"]) {
        FMPlaceOrderViewController *placeOrder = [[FMPlaceOrderViewController alloc]init];
       
        placeOrder.product_id = product_id;
        [self.navigationController pushViewController:placeOrder animated:YES];
    }
}

@end
