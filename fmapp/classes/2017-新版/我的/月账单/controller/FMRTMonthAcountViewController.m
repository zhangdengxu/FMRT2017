//
//  FMRTMonthAcountViewController.m
//  fmapp
//
//  Created by apple on 2017/2/17.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRTMonthAcountViewController.h"
#import "FMRTMonthAcountTableViewCell.h"
#import "FMRTMonthAcountSectionView.h"
#import "FMRTMonthAountSecThirdCell.h"
#import "FMRTMonthAcountModel.h"

@interface FMRTMonthAcountViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)FMRTMonthDataModel *dataModel;

@end

@implementation FMRTMonthAcountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingNavTitle:@"月账单"];
    [self createTableView];
    [self reqestwebDataForTabel];
}

- (FMRTMonthDataModel *)dataModel{
    if (!_dataModel) {
        _dataModel = [[FMRTMonthDataModel alloc]init];
    }
    return _dataModel;
}

- (void)reqestwebDataForTabel{
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    
    NSString *tokenlow=[token lowercaseString];

    NSString *shareUrlHtml = [NSString stringWithFormat:@"%@&AppId=huiyuan&Token=%@&AppTime=%@&UserId=%@&SearchMonth=%@",kXZUniversalTestUrl(@"GetMonthDealStats"),tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId,self.month];
//    NSLog(@"===========%@",shareUrlHtml);

    FMWeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:shareUrlHtml parameters:nil completion:^(WebAPIResponse *response) {
//        NSLog(@"++++++++%@",response.responseObject);
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (response.responseObject) {
            if (response.code ==WebAPIResponseCodeSuccess) {
                
                if ([response.responseObject objectForKey:@"data"]) {
                    id objeee = [response.responseObject objectForKey:@"data"];
                    if ([objeee isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dataDic = (NSDictionary *)objeee;
                        [weakSelf.dataModel setValuesForKeysWithDictionary:dataDic];
                    }
                }
                [weakSelf.tableView reloadData];
            }else{
                if ([response.responseObject objectForKey:@"msg"]) {
                    
                    NSString *msgStr = [response.responseObject objectForKey:@"msg"];
                    
                    ShowAutoHideMBProgressHUD(weakSelf.view, msgStr);
                }else{
                    ShowAutoHideMBProgressHUD(weakSelf.view, @"请求数据失败！");
                }
                
            }
        }else{
            ShowAutoHideMBProgressHUD(weakSelf.view, @"请求网络数据失败");
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    }];
}

- (void)createTableView{
    
    _tableView = ({
        UITableView *tableview= [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth , KProjectScreenHeight-64) style:(UITableViewStyleGrouped)];
        tableview.backgroundColor = KDefaultOrBackgroundColor;
        tableview.delegate=self;
        tableview.dataSource=self;
        tableview.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        tableview;
    });
    [self.view addSubview:_tableView];
    
    FMWeakSelf;
    self.tableView.mj_header  =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf reqestwebDataForTabel];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return section == 0 ?1:2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        static NSString *identifier = @"FMRTMonthAcountTableViewCell";
        
        FMRTMonthAcountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[FMRTMonthAcountTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
        }
        cell.model = self.dataModel;
        return cell;
    }else{
        static NSString *identifier = @"FMRTMonthAountSecThirdCell";
        
        FMRTMonthAountSecThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[FMRTMonthAountSecThirdCell alloc]initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:identifier];
        }
        cell.section = indexPath.section;
        cell.row = indexPath.row;
        cell.model = self.dataModel;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 0 ?250:50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    FMRTMonthAcountSectionView *view = [[FMRTMonthAcountSectionView alloc]init];
    view.section = section;
    view.model = self.dataModel;
    return view;
}

@end
