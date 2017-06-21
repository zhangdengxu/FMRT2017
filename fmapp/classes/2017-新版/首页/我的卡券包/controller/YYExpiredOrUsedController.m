//
//  YYExpiredOrUsedController.m
//  fmapp
//
//  Created by yushibo on 2016/12/19.
//  Copyright © 2016年 yk. All rights reserved.
//  已过期或使用优惠券

#import "YYExpiredOrUsedController.h"
//#import "YYExpiredOrUsedCell.h"
#import "YYExpiredOrUsedCell.h"

@interface YYExpiredOrUsedController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
// model的数组
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 暂无数据 */
@property (nonatomic, strong) UILabel *alertLabel;
/** 暂无数据 */
@property (nonatomic, assign) int currentPage;
@property (nonatomic, strong) NSString *Status;
@end

@implementation YYExpiredOrUsedController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (([self.tag integerValue] == 1) || ([self.tag integerValue] == 2)) {
        self.Status = @"3";
    }else{
        self.Status = @"1,2";
    }
    self.currentPage = 1;
    [self settingNavTitle:self.navTitle];
    [self createTableView];
    
    
    // 请求数据
    [self getDataSourceFromNetWork];
}
#pragma mark --- 懒加载
- (UILabel *)alertLabel
{
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc]initWithFrame:CGRectMake((KProjectScreenWidth/2 - 50), (KProjectScreenHeight/3), 100, 30)];
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
#pragma mark --- 卡券包 -- 网络请求
- (void)getDataSourceFromNetWork{
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"AppId":@"huiyuan",
                                 @"AppTime":[NSNumber numberWithInt:timestamp],
                                 @"Token":tokenlow,
                             //    @"CmdId":self.CmdId,
                                 @"Status":self.Status,
                                 @"PageNum":[NSString stringWithFormat:@"%d", self.currentPage]
                                 };
    
    __weak __typeof(self)weakSelf = self;
    [FMHTTPClient postPath:kXZUniversalTestUrl(self.CmdId) parameters:parameter completion:^(WebAPIResponse *response) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (response.responseObject == nil) {
            
            ShowAutoHideMBProgressHUD(self.view, NETERROR_LOADERR_TIP);
            /** 暂无数据提示 */
            if (weakSelf.dataSource.count == 0) {
                weakSelf.alertLabel.hidden = NO;
            }else{
                weakSelf.alertLabel.hidden = YES;
            }
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            return;
        }
        
        if(response.code == WebAPIResponseCodeSuccess){
            NSDictionary *dataDict = response.responseObject[@"data"];
            NSArray *newArray = [NSArray arrayWithArray:dataDict[@"Detail"]];
            
           
            if (![newArray isMemberOfClass:[NSNull class]]) {
                
                if (newArray.count) {
                    
                    if (weakSelf.currentPage == 1) {
                        [weakSelf.dataSource removeAllObjects];
                    }

                    for(NSDictionary *dict in newArray){
                        
                        YYCardPackageModel *model = [[YYCardPackageModel alloc]init];
                        [model setValuesForKeysWithDictionary:dict];
                        
                        model.contentH = [model.Desc getStringCGSizeWithMaxSize:CGSizeMake(KProjectScreenWidth - 45 -(KProjectScreenWidth / 5), MAXFLOAT) WithFont:[UIFont systemFontOfSize:16.0f]].height;
                        [weakSelf.dataSource addObject:model];
                    }
                }
                
                /** 暂无数据提示 */
                if (weakSelf.dataSource.count == 0) {
                    weakSelf.alertLabel.hidden = NO;
                }else{
                    weakSelf.alertLabel.hidden = YES;
                }
                
                
                
            }
            
        }else{
            
            /** 暂无数据提示 */
            if (weakSelf.dataSource.count == 0) {
                weakSelf.alertLabel.hidden = NO;
            }else{
                weakSelf.alertLabel.hidden = YES;
            }
            
            ShowAutoHideMBProgressHUD(self.view, response.responseObject[@"msg"]);
            
        }
        
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
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
        [weakSelf getDataSourceFromNetWork];
                _currentPage = 1;
                [weakSelf getDataSourceFromNetWork];
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
                _currentPage = _currentPage+1;
                [weakSelf getDataSourceFromNetWork];
    }];
    
    [self.view addSubview:self.tableView];
}

#pragma mark --- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *ID2 = @"YYExpiredOrUsedCell";
    YYExpiredOrUsedCell *cell = [tableView dequeueReusableCellWithIdentifier:ID2];
    if (cell == nil) {
        cell = [[YYExpiredOrUsedCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID2];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.dataSource.count) {
        
        [cell sendDataWithmodel:self.dataSource[indexPath.row] withBtnTag:self.tag];
    }
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataSource.count) {

        YYCardPackageModel *model2 = self.dataSource[indexPath.row];

        if (model2.contentH > 45) {
        
            return 120 + 15 + model2.contentH;
      
        }else{
          
            return 170;
            
        }

    }else{
        
        return 0;
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

@end
