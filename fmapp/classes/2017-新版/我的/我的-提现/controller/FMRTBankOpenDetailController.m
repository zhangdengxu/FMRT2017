//
//  FMRTBankOpenDetailController.m
//  fmapp
//
//  Created by apple on 2017/6/2.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRTBankOpenDetailController.h"
#import "FMRTBankTypeDetailModel.h"
#import "FMRTRebackMoneyController.h"

@interface FMRTBankOpenDetailController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;

@end

@implementation FMRTBankOpenDetailController

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"开户行列表"];
    
    [self createTableView];
    [self requestTableData];
}

- (void)createTableView{
    
    _tableView = ({
        UITableView *tableview= [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth , KProjectScreenHeight-60) style:(UITableViewStylePlain)];
        tableview.backgroundColor = [HXColor colorWithHexString:@"#e4ebf1"];
        tableview.delegate=self;
        tableview.dataSource=self;
        tableview.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        FMWeakSelf;
        tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf requestTableData];
        }];
        tableview;
    });
    
    [self.view addSubview:_tableView];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)requestTableData{
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSString *string = [NSString stringWithFormat:@"%@&AppId=huiyuan&Token=%@&AppTime=%@&UserId=%@&FlagChnl=%@&CardNo=%@&CityCode=%@",kXZUniversalTestUrl(@"Prcptcdquery"),tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId,@"1",self.signBankCard,self.code];
    
    FMWeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [FMHTTPClient postPath:string parameters:nil completion:^(WebAPIResponse *response) {
       
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (response.responseObject) {
//            NSLog(@"=========%@",response.responseObject);
            if (response.code==WebAPIResponseCodeSuccess){
                [weakSelf.dataSource removeAllObjects];
                if ([response.responseObject objectForKey:@"data"]) {
                    id dicData = [response.responseObject objectForKey:@"data"];
                    if ([dicData isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dic = (NSDictionary *)dicData;
                        if ([dic objectForKey:@"card_list"]) {
                            id card =[dic objectForKey:@"card_list"];
                            if ([card isKindOfClass:[NSArray class]]) {
                                NSArray *cardArr = (NSArray *)card;
                                if (cardArr.count) {
                                    for (NSDictionary *dicton in cardArr) {
                                        FMRTBankTypeDetailModel *model = [FMRTBankTypeDetailModel new];
                                        [model setValuesForKeysWithDictionary:dicton];
                                        [weakSelf.dataSource addObject:model];
                                    }
                                }
                            }
                        }
                    }
                }
                
                [weakSelf.tableView reloadData];
            }else{
                if ([response.responseObject objectForKey:@"msg"]) {
                    
                    NSString *msgStr = [response.responseObject objectForKey:@"msg"];
                    
                    ShowAutoHideMBProgressHUD(weakSelf.view, msgStr);
                }else{
                    ShowAutoHideMBProgressHUD(weakSelf.view, @"请求数据失败！");
                }            }
        }else{
            ShowAutoHideMBProgressHUD(weakSelf.view, @"请求网络数据失败！");
        }
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"FMRTBankTypeDetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataSource.count) {
        FMRTBankTypeDetailModel *model = self.dataSource[indexPath.row];
        cell.textLabel.text = model.brabank_name;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FMRTBankTypeDetailModel *model = self.dataSource[indexPath.row];
    
    FMRTRebackMoneyController * rootViewController;
    for (UIViewController * viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[FMRTRebackMoneyController class]]) {
            rootViewController = (FMRTRebackMoneyController *)viewController;
        }
    }
    if (rootViewController) {
        rootViewController.bankName = model.brabank_name;
        rootViewController.prcptcd = model.prcptcd;
        [self.navigationController popToViewController:rootViewController animated:YES];
    }
    
}

@end
