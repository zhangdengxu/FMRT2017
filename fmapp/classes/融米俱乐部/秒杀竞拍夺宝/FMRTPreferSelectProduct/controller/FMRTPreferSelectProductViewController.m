//
//  FMRTPreferSelectProductViewController.m
//  fmapp
//
//  Created by apple on 16/8/20.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTPreferSelectProductViewController.h"
#import "HexColor.h"
#import "FMRTPreferSelectProductTableViewCell.h"
//#import "XZContactServicesViewController.h"
#import "FMWinShopConfirmViewController.h"
#import "FMWinTheShopDetailController.h"
#import "FMRTAllTakeProductModel.h"
#import "FMPlaceOrderViewController.h"

@interface FMRTPreferSelectProductViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UILabel *alertLabel;

@end

@implementation FMRTPreferSelectProductViewController
static NSString *identifier = @"FMRTPreferSelectProductTableViewCell";

- (UILabel *)alertLabel{
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc]init];
        _alertLabel.font = [UIFont boldSystemFontOfSize:16];
        _alertLabel.textColor = [UIColor darkGrayColor];
        _alertLabel.text = @"暂无数据";
    }
    return _alertLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingNavTitle:@"优选商品"];
    [self setRightButtonItem];
    self.view.backgroundColor = [HXColor colorWithHexString:@"#dc2a3b"];
    [self createTableView];
    [self requestRankProductDataForProduct];
    [self.view addSubview:self.alertLabel];
    [self.alertLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)setRightButtonItem{
    
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightItemButton setFrame:CGRectMake(0, 0, 22, 22)];
    [rightItemButton setBackgroundImage:[UIImage imageNamed:@"详细规则"] forState:UIControlStateNormal];
    [rightItemButton addTarget:self action:@selector(rightButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)requestRankProductDataForProduct {
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow};
    
    __weak __typeof(self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *testurl =[NSString stringWithFormat:@"%@/public/won/show/getWonChoiceness",kXZTestEnvironment];
    

    //@"https://www.rongtuojinrong.com/java/public/won/show/getWonChoiceness"
    
    [FMHTTPClient postPath:testurl parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (response.code==WebAPIResponseCodeSuccess) {
            
            NSArray *dataArr = [response.responseObject objectForKey:@"data"];
//                NSLog(@"精品预告%@",dataArr);
            for (NSDictionary *dic in dataArr) {
                FMRTAllTakeProductModel *model = [[FMRTAllTakeProductModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [weakSelf.dataSource addObject:model];
            }
            
            [weakSelf.tableView reloadData];
            if (weakSelf.dataSource.count == 0) {
                self.alertLabel.hidden = NO;
            }else{
                self.alertLabel.hidden = YES;
            }
            
        }else{
            ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
            if (weakSelf.dataSource.count == 0) {
                self.alertLabel.hidden = NO;
            }else{
                self.alertLabel.hidden = YES;
            }
        }
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
//        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}


- (void)createTableView{
    
    UIImageView *topView = [[UIImageView alloc]init];
    topView.image = [UIImage imageNamed:@"photo"];
    [self.view addSubview:topView];
    [topView makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.view.mas_top).offset(15);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    __weak typeof (self)weakSelf = self;
    _tableView = ({
        UITableView *tableview= [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        tableview.backgroundColor = KDefaultOrBackgroundColor;
        tableview.delegate=self;
        tableview.dataSource=self;
        tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [self.dataSource removeAllObjects];
            [weakSelf requestRankProductDataForProduct];
        }];
//        tableview.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
//            
//            [weakSelf requestRankProductDataForProduct];
//            
//        }];
        tableview;
    });
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.bottom.equalTo(self.view.mas_bottom).offset(-15);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count?self.dataSource.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FMRTPreferSelectProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[FMRTPreferSelectProductTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    if (self.dataSource.count) {
        cell.model = self.dataSource[indexPath.row];
    }
    
    __weak typeof (self)weakSelf = self;
    cell.tbBlock = ^(){
        FMRTAllTakeProductModel *model = weakSelf.dataSource[indexPath.row];
        [weakSelf tbRightNowWith:model];
    };
    return cell;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KProjectScreenWidth-175 +65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FMRTAllTakeProductModel *model = self.dataSource[indexPath.row];
    
    if ([model.won_state integerValue]== 0 || [model.won_state integerValue]== 1) {
        
        FMPlaceOrderViewController * placeOrder = [[FMPlaceOrderViewController alloc]init];
        
        placeOrder.product_id = model.product_id;
        [self.navigationController pushViewController:placeOrder animated:YES];

    }else{
        
        FMWinTheShopDetailController * winShop = [[FMWinTheShopDetailController alloc]init];
        winShop.productModel = model;
        [self.navigationController pushViewController:winShop animated:YES];
    }
}

- (void)rightButton{
//    XZContactServicesViewController *contactSer  = [[XZContactServicesViewController alloc]init];
//    [self.navigationController pushViewController:contactSer animated:YES];
}

#pragma mark - 立即投币
- (void)tbRightNowWith:(FMRTAllTakeProductModel *)model{
    FMWinShopConfirmViewController * confirmView = [[FMWinShopConfirmViewController alloc]init];
    [confirmView createBackGroundView];
    confirmView.productModel = model;
    [self.navigationController pushViewController:confirmView animated:NO];
}

@end
