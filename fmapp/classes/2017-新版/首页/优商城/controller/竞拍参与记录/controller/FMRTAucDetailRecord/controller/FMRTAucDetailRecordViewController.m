//
//  FMRTAucDetailRecordViewController.m
//  fmapp
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTAucDetailRecordViewController.h"
#import "FMRTAucDetailRecordTableViewCell.h"
#import "FMRTAucDetailRecordModel.h"
#import "WLJPJLViewController.h"
//#import "FMTimeKillShowSelectView.h"
#import "FMButtonStyleModel.h"
#import "FMShopSpecModel.h"
#import "WLFollowingViewController.h"
#import "FMTimeKillSelectView.h"
#import "AppDelegate.h"
#import "XZShoppingOrderAddressModel.h"
#import "XZConfirmOrderKillViewController.h"

@interface FMRTAucDetailRecordViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, strong) UILabel *alertLabel;

@end

@implementation FMRTAucDetailRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self settingNavTitle:@"参与记录"];
    self.currentPage = 1;
    self.view.backgroundColor = KDefaultOrBackgroundColor;
    [self.view addSubview:self.tableView];

    [self.view addSubview:self.alertLabel];
    [self.alertLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-60);
    }];
}

- (UILabel *)alertLabel{
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc]init];
        _alertLabel.font = [UIFont boldSystemFontOfSize:16];
        _alertLabel.textColor = [UIColor darkGrayColor];
        _alertLabel.text = @"暂无数据";
    }
    return _alertLabel;
}


- (void)zj_viewDidLoadForIndex:(NSInteger)index {
    
        switch (index) {
            case 0:
            {
                self.state = index;

                break;
            }
            case 1:
            {
                self.state = index;

                break;
            }
            case 2:
            {
                self.state = index + 1;

                break;
            }
            case 3:
            {
                self.state = index +1;

                break;
            }
            default:
                break;
        }
        [self getDataFromNetWork];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = ({
            UITableView *tableview= [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth , KProjectScreenHeight - 64 - 45) style:(UITableViewStyleGrouped)];
            tableview.backgroundColor = KDefaultOrBackgroundColor;
            tableview.delegate=self;
            tableview.dataSource=self;
            tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
            __weak typeof (self)weakSelf = self;
            tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                _currentPage = 1;

                [weakSelf getDataFromNetWork];
            }];
            tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                _currentPage = _currentPage + 1;
                [weakSelf getDataFromNetWork];
            }];

            tableview;
        });
    }
    return _tableView;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)getDataFromNetWork{
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"tel":[CurrentUserInformation sharedCurrentUserInfo].mobile,
                                 @"page":[NSString stringWithFormat:@"%ld", (long)self.currentPage],
                                 @"state":[NSString stringWithFormat:@"%ld", (long)self.state]};
    
    NSString *testurl =[NSString stringWithFormat:@"%@/public/show/getPlayedAuction",kXZTestEnvironment];
    
    //@"https://www.rongtuojinrong.com/java/public/show/getPlayedAuction"
    [FMHTTPClient postPath:testurl parameters:parameter completion:^(WebAPIResponse *response) {
        
        if (response.code==WebAPIResponseCodeSuccess) {
            
            if (self.currentPage == 1) {
                [self.dataSource removeAllObjects];
            }
            
            NSArray * objectArr = [response.responseObject objectForKey:@"data"];

            for (NSDictionary *dic in objectArr) {
                FMRTAucDetailRecordModel *model = [[FMRTAucDetailRecordModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataSource addObject:model];
            }
            if (self.dataSource.count == 0) {
                self.alertLabel.hidden = NO;
            }else{
                self.alertLabel.hidden = YES;
            }

        }else{
            if (self.dataSource.count == 0) {
                self.alertLabel.hidden = NO;
            }else{
                self.alertLabel.hidden = YES;
            }
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count?self.dataSource.count:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 155;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"FMRTAucDetailRecordTableViewCell";
    __weak typeof (self)weakSelf = self;
    FMRTAucDetailRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[FMRTAucDetailRecordTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    cell.recordBlcok = ^(NSString *auctionId){
        [weakSelf productForRecordWith:auctionId];
    };
    cell.addPriceBlcok = ^(NSString *auctId,NSString *proId){
        [weakSelf addPriceForProductWithAucId:auctId proId:proId];
    };
    
    if (self.dataSource.count) {
        cell.model = self.dataSource[indexPath.section];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.state == 3) {
    
        if (self.dataSource.count) {
            FMRTAucDetailRecordModel *model = self.dataSource[indexPath.section];
            
            if (model.tracking_num.length && model.express_company.length) {
                
                WLFollowingViewController *fllVC = [[WLFollowingViewController alloc]init];
                fllVC.nu = model.tracking_num;
                fllVC.com = model.express_company;
                fllVC.tag = @"1";
                [self.navigationController pushViewController:fllVC animated:YES];
            }else{
                ShowAutoHideMBProgressHUD(self.view, @"您的商品即将发货，物流信息请稍后再试");
            }

        }
        
    }else if (self.state == 0) {
        
        if (self.dataSource.count) {
            
            FMRTAucDetailRecordModel *model = self.dataSource[indexPath.section];
            
            if ([model.buy_state integerValue] == 3) {
                
                if (model.tracking_num.length && model.express_company.length) {
                    WLFollowingViewController *fllVC = [[WLFollowingViewController alloc]init];
                    fllVC.nu = model.tracking_num;
                    fllVC.com = model.express_company;
                    fllVC.tag = @"1";
                    [self.navigationController pushViewController:fllVC animated:YES];
                }else{
                    ShowAutoHideMBProgressHUD(self.view, @"您的商品即将发货，物流信息请稍后再试");
                }
            }

        }
        
    }
}

- (void)addPriceForProductWithAucId:(NSString *)auctId proId:(NSString *)proId{

    
    
    FMTimeKillSelectView * shopView = [[FMTimeKillSelectView alloc]init];
    //添加button
    shopView.isShowCount = NO;
    
    shopView.selectStyle = FMTimeKillShowSelectViewJingPai;
    
    FMSelectShopInfoModel * shopDetailModel = [[FMSelectShopInfoModel alloc]init];
    shopDetailModel.product_id = proId;
    shopDetailModel.auction_id = auctId;
    
    
    [shopView createPresentModel:shopDetailModel];
    
    
    __weak __typeof(&*self)weakSelf = self;
    shopView.successBlock = ^(FMSelectShopInfoModel * selectModel){
        [weakSelf FMShowSelectViewDidSelecrButton:selectModel];
    };
    
    shopView.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.15];
    self.definesPresentationContext = YES;
    //源Controller中跳转方法实现
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        shopView.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        [weakSelf.navigationController presentViewController:shopView animated:NO completion:^{
        }];
        
    } else {
        
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        appdelegate.window.rootViewController.modalPresentationStyle=UIModalPresentationCurrentContext;
        [appdelegate.window.rootViewController presentViewController:shopView animated:YES completion:^{
            shopView.view.backgroundColor=[UIColor clearColor];
            appdelegate.window.rootViewController.modalPresentationStyle=UIModalPresentationFullScreen;
        }];
    }

    
}


-(void)FMShowSelectViewDidSelecrButton:(FMSelectShopInfoModel *)selectModel
{
    
    
    if (![selectModel.address isMemberOfClass:[NSNull class]]){
        if (selectModel.address.length > 0) {
            
            XZShoppingOrderAddressModel *addressModel = [[XZShoppingOrderAddressModel alloc]init];
            
            addressModel.addr = selectModel.address;
            
            addressModel.mobile = selectModel.phone;
            
            addressModel.name = selectModel.recipients;
            addressModel.addr_id = selectModel.address_id;
            
            
            selectModel.addressModel = addressModel;
        }
        
        
    }
    
    XZConfirmOrderKillViewController *confirmOrder = [[XZConfirmOrderKillViewController alloc] init];
    confirmOrder.shopDetailModel = selectModel;
    [self.navigationController pushViewController:confirmOrder animated:YES];
    
    
}

- (void)productForRecordWith:(NSString *)auctionId{

    WLJPJLViewController *wlVC = [[WLJPJLViewController alloc]init];
    wlVC.auction_id = auctionId;
    [self.navigationController pushViewController:wlVC animated:YES];
}

@end
