//
//  YSSpikeParticipationRecordViewController.m
//  fmapp
//
//  Created by yushibo on 16/8/10.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "YSSpikeParticipationRecordViewController.h"
#import "YSSpikeParticipationRecordViewCell.h"
#import "YSSpikeParticipationRecordModel.h"
#import "WLFollowingViewController.h"
@interface YSSpikeParticipationRecordViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, strong) UILabel *alertLabel;

@end

@implementation YSSpikeParticipationRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"参与记录"];
    self.currentPage = 1;
    [self setUpTableView];
    [self getDataSourceFromNetWork];
}
- (UILabel *)alertLabel{
    
    if (!_alertLabel) {
        
        _alertLabel = [[UILabel alloc]initWithFrame:CGRectMake((KProjectScreenWidth/2 - 50), (KProjectScreenHeight/2 - 100), 100, 30)];
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        _alertLabel.text = @"暂无数据";
        _alertLabel.textColor = [UIColor darkGrayColor];
        _alertLabel.font = [UIFont boldSystemFontOfSize:16];
        [self.view addSubview:_alertLabel];
        
    }
    return _alertLabel;
}

- (NSMutableArray *)dataSource{

    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)setUpTableView{

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _currentPage = 1;
        [self.dataSource removeAllObjects];
        [self getDataSourceFromNetWork];
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
            _currentPage = _currentPage+1;
            [self getDataSourceFromNetWork];
    }];
    [self.view addSubview:self.tableView];
}

#pragma mark --- 网略请求
- (void)getDataSourceFromNetWork{
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSString *urlStr =[NSString stringWithFormat:@"%@/public/show/getProductsList",kXZTestEnvironment];
    
    //NSString *urlStr = @"https://www.rongtuojinrong.com/java/public/show/getProductsList";
    NSDictionary * parameter = @{@"appid":@"huiyuan",
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"page":[NSString stringWithFormat:@"%d", self.currentPage]
                                 };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak __typeof(self)weakSelf = self;
    [FMHTTPClient postPath:urlStr parameters:parameter completion:^(WebAPIResponse *response) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (response.responseObject == nil) {
            ShowAutoHideMBProgressHUD(self.view, NETERROR_LOADERR_TIP);
            if (self.dataSource.count == 0) {
                
                self.alertLabel.hidden = NO;
                
            }else{
                
                self.alertLabel.hidden = YES;
                
            }

            return ;
        }
        
        if(response.code == WebAPIResponseCodeSuccess){
            
            if (response.responseObject) {
                NSArray *newArray = [NSArray arrayWithArray:response.responseObject[@"data"]];
                
                NSLog(@"=====%@",response.responseObject);
                
                if (![newArray isMemberOfClass:[NSNull class]]) {
                    
                    if (newArray.count) {
                        if (![newArray isKindOfClass:[NSNull class]]) {
                            
                            for(NSDictionary *dict in newArray){
                                NSMutableDictionary *infoDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
//                                YSSpikeParticipationRecordModel *model = [[YSSpikeParticipationRecordModel alloc]initWithDict:infoDict];
                                YSSpikeParticipationRecordModel *model = [[YSSpikeParticipationRecordModel alloc]init];
                                [model setValuesForKeysWithDictionary:infoDict];

                                [self.dataSource addObject:model];
                            }
                            
                        }
                        
                    }
                    if (self.dataSource.count == 0) {
                        
                        self.alertLabel.hidden = NO;
                        
                    }else{
                        
                        self.alertLabel.hidden = YES;
                        
                    }

                }
            }
        }else{
            
            if (self.dataSource.count) {
                ShowAutoHideMBProgressHUD(self.view, @"没有更多数据!");
                if (self.dataSource.count == 0) {
                    
                    self.alertLabel.hidden = NO;
                    
                }else{
                    
                    self.alertLabel.hidden = YES;
                    
                }

                
            }else{
                ShowAutoHideMBProgressHUD(self.view, NETERROR_LOADERR_TIP);
                if (self.dataSource.count == 0) {
                    
                    self.alertLabel.hidden = NO;
                    
                }else{
                    
                    self.alertLabel.hidden = YES;
                    
                }

            }
        }
        [self.tableView reloadData];
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
    }];
    
}

#pragma mark --- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"YSSpikeParticipationRecordViewCell";
    YSSpikeParticipationRecordViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [[YSSpikeParticipationRecordViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    if (self.dataSource.count) {
        
        cell.status = self.dataSource[indexPath.section];
    }
    return cell;
}

#pragma mark --- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 7;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 130;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YSSpikeParticipationRecordModel *model = self.dataSource[indexPath.section];
    
    if (model.tracking_num && model.express_company) {
        
        if ([model.tracking_num length] > 0 && [model.express_company length] > 0) {
            
            WLFollowingViewController *fllVC = [[WLFollowingViewController alloc]init];
            fllVC.nu = model.tracking_num;
            fllVC.com = model.express_company;
            fllVC.tag = @"1";
            [self.navigationController pushViewController:fllVC animated:YES];
        }else{
            ShowAutoHideMBProgressHUD(self.view, @"您的商品即将发货，物流信息请稍后再试");
        }

    }else{
        ShowAutoHideMBProgressHUD(self.view, @"您的商品即将发货，物流信息请稍后再试");
    }


}
@end
