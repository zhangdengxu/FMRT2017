//
//  FMRTCitySelectedController.m
//  fmapp
//
//  Created by apple on 2017/6/2.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRTCitySelectedController.h"
#import "FMRTBankOpenDetailController.h"
#import "FMRTCityModel.h"

@interface FMRTCitySelectedController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;

@end

@implementation FMRTCitySelectedController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"开户行所在市"];
    [self createTableView];
    [self requestTableData];
}
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
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
    
    NSString *string = [NSString stringWithFormat:@"%@&AppId=huiyuan&Token=%@&AppTime=%@&UserId=%@&FlagChnl=%@&Code=%@",kXZUniversalTestUrl(@"LLGetCity"),tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId,@"1",self.code];
    
    FMWeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [FMHTTPClient postPath:string parameters:nil completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (response.responseObject) {

            if (response.code==WebAPIResponseCodeSuccess){
                [weakSelf.dataSource removeAllObjects];
                if ([response.responseObject objectForKey:@"data"]) {
                    id dicData = [response.responseObject objectForKey:@"data"];
                    if ([dicData isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dic = (NSDictionary *)dicData;
                        if ([dic objectForKey:@"City"]) {
                            id provinceArr = [dic objectForKey:@"City"];
                            if ([provinceArr isKindOfClass:[NSArray class]]) {
                                NSArray *arr = (NSArray *)provinceArr;
                                
                                if (arr.count) {
                                    for (NSDictionary *dicDetail in arr) {
                                        FMRTCityModel *model = [[FMRTCityModel alloc]init];
                                        [model setValuesForKeysWithDictionary:dicDetail];
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
    static NSString *identifier = @"FMRTCityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataSource.count) {
    
        FMRTCityModel *model = self.dataSource[indexPath.row];
        cell.textLabel.text = model.Name;;
    }
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FMRTBankOpenDetailController *bankVC = [[FMRTBankOpenDetailController alloc]init];
    FMRTCityModel *model = self.dataSource[indexPath.row];
    bankVC.code = model.CityCode;
    bankVC.signBankCard = self.signBankCard;
    [self.navigationController pushViewController:bankVC animated:YES];
}

@end
