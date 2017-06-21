//
//  XZExpiredOrUsedController.m
//  fmapp
//
//  Created by admin on 17/1/3.
//  Copyright © 2017年 yk. All rights reserved.
//  已过期或使用优惠券

#import "XZExpiredOrUsedController.h"
#import "XZChooseTicketModel.h"
#import "XZChooseTicketCell.h"

// 抵价券数据
#define XZChooseTicketURL @"https://www.rongtuojinrong.com/qdy/wap/member-coupons_client.html"

@interface XZExpiredOrUsedController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
// model的数组
@property (nonatomic, strong) NSMutableArray *arrChooseTicket;
@end

@implementation XZExpiredOrUsedController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:self.navTitle];
    [self createTableView];
    
    // 请求数据
    [self getChooseTicketDataFromNetWork];
}

#pragma mark ------ 请求当前页面数据
- (void)getChooseTicketDataFromNetWork {
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow = [token lowercaseString];
    
    __weak __typeof(&*self)weakSelf = self;
    NSString *htmlPath = [NSString stringWithFormat:@"%@?appid=%@&user_id=%@&shijian=%@&token=%@&tel=%@",XZChooseTicketURL,@"huiyuan",[CurrentUserInformation sharedCurrentUserInfo].userId,[NSNumber numberWithInt:timestamp],tokenlow,[CurrentUserInformation sharedCurrentUserInfo].mobile];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [FMHTTPClient getPath:htmlPath parameters:nil completion:^(WebAPIResponse *response) {
        [weakSelf.arrChooseTicket removeAllObjects];
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if (response.responseObject) {
            if (response.code == WebAPIResponseCodeSuccess) {
                NSDictionary *dataDcit = response.responseObject[@"data"];
                if (![dataDcit isKindOfClass:[NSNull class]]) {
                    NSArray *dictArr = dataDcit[@"expired"];
                    if (dictArr.count > 0) {
                        for (NSDictionary *dcit in dictArr) {
                            XZChooseTicketModel *chooseTicket = [[XZChooseTicketModel alloc] init];
                            [chooseTicket setValuesForKeysWithDictionary:dcit];
                            chooseTicket.contentH = [chooseTicket.cpns_desc getStringCGSizeWithMaxSize:CGSizeMake(KProjectScreenWidth - 40, MAXFLOAT) WithFont:[UIFont systemFontOfSize:15.0f]].height;
                            chooseTicket.isExpiredOrUnused = YES;
                            [weakSelf.arrChooseTicket addObject:chooseTicket];
                        }
                    }
                }
            }else {
                ShowAutoHideMBProgressHUD(weakSelf.view, @"获取数据失败");
            }
        }
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

#pragma mark --- 创建TabeView
- (void)createTableView{
    
    UITableView *tableview= [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 64)style:(UITableViewStylePlain)];
    tableview.backgroundColor = [UIColor colorWithHexString:@"e5e9f2"];
    
    tableview.delegate=self;
    tableview.dataSource=self;
    tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView = tableview;
    __weak typeof (self)weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getChooseTicketDataFromNetWork];
        //        _currentPage = 1;
        //        [weakSelf.dataSource removeAllObjects];
        //        [weakSelf getOrderDataSourceFromNetWork];
    }];
//    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        
//        //        _currentPage = _currentPage+1;
//        //        [weakSelf getOrderDataSourceFromNetWork];
//    }];
    
    tableview.tableHeaderView = [self setUpTableHeaderView];
    [self.view addSubview:self.tableView];
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrChooseTicket.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XZChooseTicketCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseTicketCell"];
    if (!cell) {
        cell = [[XZChooseTicketCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChooseTicketCell"];
    }
    cell.modelChooseTicket = self.arrChooseTicket[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZChooseTicketModel *model = self.arrChooseTicket[indexPath.row];
    return ((KProjectScreenWidth - 20) * 76 / 600.0 + model.contentH + 45 + 20);
}

- (UIView *)setUpTableHeaderView {
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 20)];
    lineV.backgroundColor = [UIColor colorWithHexString:@"#E5E9F2"];
    return lineV;
}

#pragma mark --  数据
- (NSMutableArray *)arrChooseTicket {
    if (!_arrChooseTicket) {
        _arrChooseTicket = [NSMutableArray array];
    }
    return _arrChooseTicket;
}

@end
