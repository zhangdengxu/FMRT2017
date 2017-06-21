//
//  YYLatestInformationViewController.m
//  fmapp
//
//  Created by yushibo on 2016/11/29.
//  Copyright © 2016年 yk. All rights reserved.
//  最新资讯展开页

#import "YYLatestInformationViewController.h"
#import "YYLatestInformationCell.h"
#import "HexColor.h"
#import "YYLatestInformationModel.h"
#import "ShareViewController.h"

@interface YYLatestInformationViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, strong) NSString *leixing;
/** 暂无数据 */
@property (nonatomic, strong) UILabel *alertLabel;

@end

@implementation YYLatestInformationViewController
#pragma mark --- 懒加载
- (NSMutableArray *)dataSource{

    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UILabel *)alertLabel
{
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc] initWithFrame:CGRectMake((KProjectScreenWidth/2 - 50), (KProjectScreenHeight/3), 100, 30)];
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        _alertLabel.text = @"暂无数据";
        _alertLabel.textColor = [UIColor darkGrayColor];
        _alertLabel.font = [UIFont boldSystemFontOfSize:16];
        [self.view addSubview:_alertLabel];
    }
    return _alertLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingNavTitle:@"平台公告"];
    
    self.currentPage = 1;
    self.leixing = @"1";
    
//    [self createNavTitle];
    [self createTableView];
    [self getDataSourceFromNetWork];
}

- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 64) style:(UITableViewStylePlain)];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    __weak typeof (self)weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPage = 1;
        [weakSelf getDataSourceFromNetWork];
    }];
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _currentPage = _currentPage + 1;
        [weakSelf getDataSourceFromNetWork];
    }];

    [self.view addSubview:self.tableView];
    
}
#pragma mark --- 更多资讯 -- 网络请求

- (void)getDataSourceFromNetWork {
    
   NSString *urlStr = kFMPhpUniversalBaseUrl(@"Rongtuoxinsoc/indexapp/zixunmore");
    
    NSDictionary *parameter = @{
                                 @"page":[NSString stringWithFormat:@"%d", self.currentPage],
                                 @"leixing":self.leixing
                                };
    
    __weak __typeof(self)weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [FMHTTPClient postPath:urlStr parameters:parameter completion:^(WebAPIResponse *response) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (!response.responseObject) {
            
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
            if (self.currentPage == 1) {
                [weakSelf.dataSource removeAllObjects];
            }
            NSArray *newArray = [NSArray arrayWithArray:response.responseObject[@"data"]];
            
            if (![newArray isMemberOfClass:[NSNull class]]) {
                
                if (newArray.count) {
                    
                    for(NSDictionary *dict in newArray){
                        
                        YYLatestInformationModel *model = [[YYLatestInformationModel alloc]init];
                        [model setValuesForKeysWithDictionary:dict];
                        
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
            
            ShowAutoHideMBProgressHUD(self.view, response.responseObject[@"msg"]);
            /** 暂无数据提示 */
            if (weakSelf.dataSource.count == 0) {
                weakSelf.alertLabel.hidden = NO;
            }else{
                weakSelf.alertLabel.hidden = YES;
            }
            
        }
        
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark ---   UITableView代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSource.count) {
        
        return self.dataSource.count;
    }else{
    
        return 0;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"YYLatestInformationCell";
    
    YYLatestInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[YYLatestInformationCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
        }
    if (self.dataSource.count) {
        
        cell.status = self.dataSource[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 115;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *title = @"平台公告";
    
    YYLatestInformationModel *model = self.dataSource[indexPath.row];
//    if (self.segmentedControl.selectedSegmentIndex == 1) {
//        title = @"投资者教育";
//    }
    ShareViewController *webViewController=[[ShareViewController alloc]initWithTitle:title AndWithShareUrl:[NSString stringWithFormat:@"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/zixunshow?news_id=%@",model.news_id]];
    webViewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:webViewController animated:YES];

}


//- (void)createNavTitle {
//
//    UISegmentedControl *segmentedControl=[[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"平台公告", @"投资者教育", nil]];
//    segmentedControl.tintColor = [UIColor colorWithHexString:@"#0159d5"];
////    [segmentedControl setFrame:CGRectMake((KProjectScreenWidth-240)/2, 7, 240, 30)];
//    CGRect frame = segmentedControl.frame;
//    frame.size.width = 220;
//    segmentedControl.frame = frame;
//    [segmentedControl addTarget:self action:@selector(segmentedControlChange) forControlEvents:UIControlEventValueChanged];
//    segmentedControl.selectedSegmentIndex=0;
//    
//    self.segmentedControl = segmentedControl;
//    self.navigationItem.titleView = segmentedControl;
//}
//
//- (void)segmentedControlChange{
//
//    if (self.segmentedControl.selectedSegmentIndex == 0) {
//        
//        [self.dataSource removeAllObjects];
//        self.currentPage = 1;
//        self.leixing = @"1";
//        
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        [self getDataSourceFromNetWork];
//
//    }else{
//    
//        [self.dataSource removeAllObjects];
//        self.currentPage = 1;
//        self.leixing = @"2";
//        
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        [self getDataSourceFromNetWork];
//
//    }
//    
//}

@end
