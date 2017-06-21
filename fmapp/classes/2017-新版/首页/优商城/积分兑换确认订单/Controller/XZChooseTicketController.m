//
//  XZChooseTicketController.m
//  fmapp
//
//  Created by admin on 17/1/3.
//  Copyright © 2017年 yk. All rights reserved.
//  选择抵价券

#import "XZChooseTicketController.h"
#import "XZChooseTicketHeader.h" // Header
#import "XZChooseTicketCell.h"  // cell
#import "XZChooseTicketModel.h" //  model
#import "XZChooseTicketFooter.h" // footer
#import "XZExpiredOrUsedController.h" // 已使用和过期抵价券
#import "YYInstructionsController.h" // 使用说明

// 抵价券数据
#define XZChooseTicketURL @"https://www.rongtuojinrong.com/qdy/wap/member-coupons_client.html"

@interface XZChooseTicketController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableChooseTicket;
@property (nonatomic, strong) XZChooseTicketHeader *header;
@property (nonatomic, strong) XZChooseTicketFooter *footer;
// model的数组
@property (nonatomic, strong) NSMutableArray *arrChooseTicket;
@end

@implementation XZChooseTicketController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIBarButtonItem appearance] setTintColor:XZColor(51, 51, 51)];
    //
    [self settingNavTitle:@"选择抵价券"];
    self.view.backgroundColor = XZBackGroundColor;
    [self.view addSubview:self.header];
    [self.view addSubview:self.tableChooseTicket];

    //
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"不使用" style:UIBarButtonItemStyleDone target:self action:@selector(didClickDidNotUse)];
    
    __weak __typeof(&*self)weakSelf = self;
    // 点击返回按钮
    self.navBackButtonRespondBlock = ^{
        if (weakSelf.cpns_code) { // 前个页面传递了一个抵价券
            if (weakSelf.arrChooseTicket.count > 0) {
                for (XZChooseTicketModel *modelChoose in weakSelf.arrChooseTicket) {
                    if ([modelChoose.cpns_code isEqualToString:weakSelf.cpns_code]) {
                        if (weakSelf.blockChooseTicket) {
                            weakSelf.blockChooseTicket(modelChoose);
                        }
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }
                }
            }else {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }else { // 前个页面未传递了抵价券
            [weakSelf didClickDidNotUse];
        }
    };
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 加载数据
    [self getChooseTicketDataFromNetWork];
}

#pragma mark ------ 请求当前页面数据
- (void)getChooseTicketDataFromNetWork {
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow = [token lowercaseString];

    __weak __typeof(&*self)weakSelf = self;
    NSString *htmlPath = [NSString stringWithFormat:@"%@?appid=%@&user_id=%@&shijian=%@&token=%@&tel=%@&sess_id=%@",XZChooseTicketURL,@"huiyuan",[CurrentUserInformation sharedCurrentUserInfo].userId,[NSNumber numberWithInt:timestamp],tokenlow,[CurrentUserInformation sharedCurrentUserInfo].mobile,self.sess_id];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [FMHTTPClient getPath:htmlPath parameters:nil completion:^(WebAPIResponse *response) {
//        NSLog(@"抵价券列表的response.responseObject ========= %@",response.responseObject);
        [weakSelf.arrChooseTicket removeAllObjects];
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if (response.responseObject) {
            if (response.code == WebAPIResponseCodeSuccess) {
                NSDictionary *dataDcit = response.responseObject[@"data"];
                if (![dataDcit isKindOfClass:[NSNull class]]) {
                    NSArray *dictArr = dataDcit[@"active"];
                    if (dictArr.count > 0) {
                        for (NSDictionary *dcit in dictArr) {
                            XZChooseTicketModel *chooseTicket = [[XZChooseTicketModel alloc] init];
                            [chooseTicket setValuesForKeysWithDictionary:dcit];
                            chooseTicket.contentH = [chooseTicket.cpns_desc getStringCGSizeWithMaxSize:CGSizeMake(KProjectScreenWidth - 40, MAXFLOAT) WithFont:[UIFont systemFontOfSize:15.0f]].height;
                            [weakSelf.arrChooseTicket addObject:chooseTicket];
                        }
                    }
                }
            }else {
                ShowAutoHideMBProgressHUD(weakSelf.view, @"获取数据失败");
            }
        }
        [weakSelf.tableChooseTicket reloadData];
        [weakSelf.tableChooseTicket.mj_header endRefreshing];
    }];
}

// 点击了"不使用"
- (void)didClickDidNotUse {
    XZChooseTicketModel *chooseTicket = [[XZChooseTicketModel alloc] init];
    if (self.blockChooseTicket) {
        self.blockChooseTicket(chooseTicket);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ----- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrChooseTicket.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XZChooseTicketModel *modelChooseTicket = self.arrChooseTicket[indexPath.row];
    if (self.blockChooseTicket) {
        self.blockChooseTicket(modelChooseTicket);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.arrChooseTicket.count == 0) {
        XZChooseTicketModel *modelChoose = [[XZChooseTicketModel alloc] init];
        modelChoose.isNoData = YES;
        self.footer.modelChoose = modelChoose;
    }else {
        XZChooseTicketModel *modelChoose = self.arrChooseTicket[0];
        self.footer.modelChoose = modelChoose;
    }
    return self.footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.arrChooseTicket.count == 0) {
        return 90;
    }else {
        return 60;
    }
}

#pragma mark ----- 初始化
- (UITableView *)tableChooseTicket {
    if (!_tableChooseTicket) {
        _tableChooseTicket = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, KProjectScreenWidth, KProjectScreenHeight - 64 - 60) style:UITableViewStyleGrouped];
        _tableChooseTicket.delegate = self;
        _tableChooseTicket.dataSource  = self;
        _tableChooseTicket.backgroundColor = XZBackGroundColor;
        _tableChooseTicket.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableChooseTicket.showsVerticalScrollIndicator = NO;
        
        __weak __typeof(&*self)weakSelf = self;
        _tableChooseTicket.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf getChooseTicketDataFromNetWork];
        }];
    }
    return _tableChooseTicket;
}

- (XZChooseTicketHeader *)header {
    if (!_header) {
        _header = [[XZChooseTicketHeader alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 60)];
        __weak __typeof(&*self)weakSelf = self;
        _header.blockDirection = ^{
            YYInstructionsController *instruction = [[YYInstructionsController alloc] init];
            instruction.state = @"3";
            instruction.navTitle = @"抵价券使用说明";
            [weakSelf.navigationController pushViewController:instruction animated:YES];
        };
    }
    return _header;
}

- (XZChooseTicketFooter *)footer {
    if (!_footer) {
        _footer = [[XZChooseTicketFooter alloc] init];
        __weak __typeof(&*self)weakSelf = self;
        _footer.blockUsedAndOverdue = ^{
            XZExpiredOrUsedController *expiredOrUsed = [[XZExpiredOrUsedController alloc] init];
            expiredOrUsed.navTitle = @"已使用和过期抵价券";
            [weakSelf.navigationController pushViewController:expiredOrUsed animated:YES];
        };
    }
    return _footer;
}

- (NSMutableArray *)arrChooseTicket {
    if (!_arrChooseTicket) {
        _arrChooseTicket = [NSMutableArray array];
    }
    return _arrChooseTicket;
}

@end
