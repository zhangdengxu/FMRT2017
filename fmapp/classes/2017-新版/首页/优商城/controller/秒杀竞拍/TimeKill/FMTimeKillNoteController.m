//
//  FMTimeKillNoteController.m
//  fmapp
//
//  Created by runzhiqiu on 16/8/18.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMTimeKillNoteController.h"
#import "FMTimeKillNoteTableViewCell.h"
#import "FMTimeKillnoteModel.h"
#import "UITableView+FDTemplateLayoutCell.h"
@interface FMTimeKillNoteController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) BOOL isAddData;

@end

@implementation FMTimeKillNoteController

static NSString * FMTimeKillNoteTableViewCellRegister = @"FMTimeKillNoteTableViewCellRegister" ;
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        
        FMTimeKillnoteModel * model = [[FMTimeKillnoteModel alloc]init];
        model.record_id = @"10234";
        model.state = @"1";
        model.goods_id = @"2314";
        model.goods_name = @"笑容珍藏版抱枕／环保原声面／这样那样东西，优质面容";
        model.goods_img_url = @"http://img3.duitang.com/uploads/item/201607/19/20160719172152_FETyf.jpeg";
        model.goods_price = @"13.3";
        model.trans_time = @"1471570162";
        model.trans_num = @"23";
        model.trans_price = @"12.3";
        
        FMTimeKillnoteModel * model1 = [[FMTimeKillnoteModel alloc]init];
        model1.record_id = @"10234";
        model1.state = @"1";
        model1.goods_id = @"2314";
        model1.goods_name = @"笑容珍藏版抱枕／环保原声面／这样那样东西，优质面容";
        model1.goods_img_url = @"http://img3.duitang.com/uploads/item/201607/19/20160719172152_FETyf.jpeg";
        model1.goods_price = @"13.3";
        model1.trans_time = @"1471570162";
        model1.trans_num = @"23";
        model1.trans_price = @"12.3";
        
        _dataSource = [NSMutableArray array];
        [_dataSource addObject:model];
        [_dataSource addObject:model1];
    }
    return _dataSource;
}


-(UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [_tableView registerClass:[FMTimeKillNoteTableViewCell class] forCellReuseIdentifier:FMTimeKillNoteTableViewCellRegister];
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.currentPage = 1;
            self.isAddData = NO;
            [self getDataSourceFromNetWork];
        }];
        _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            self.currentPage = _currentPage + 1;
            self.isAddData = YES;
            [self getDataSourceFromNetWork];
        }];

        
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self settingNavTitle:@"秒杀记录"];
    self.currentPage = 1;
    [self.view addSubview:self.tableView];
    
    [self getDataSourceFromNetWork];
    // Do any additional setup after loading the view.
}


-(void)getDataSourceFromNetWork
{
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    
    NSDictionary * paras = @{@"appid":@"huiyuan",
                             @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                             @"shijian":[NSNumber numberWithInt:timestamp],
                             @"token":[token lowercaseString],
                             @"tel":[CurrentUserInformation sharedCurrentUserInfo].mobile,
                             @"page":[NSNumber numberWithInteger:self.currentPage]};
    
    
    NSString *testurl =[NSString stringWithFormat:@"%@/public/show/getProductsList",kXZTestEnvironment];
    

    //@"https://www.rongtuojinrong.com/java/public/show/getProductsList"
    [FMHTTPClient postPath:testurl parameters:paras completion:^(WebAPIResponse *response) {
        if (response.code == WebAPIResponseCodeSuccess) {
            NSArray * dataAll = response.responseObject[@"data"];
            
            if (!self.isAddData) {
                [self.dataSource removeAllObjects];
            }
            self.isAddData = NO;
            
            for (NSDictionary * dict in dataAll) {
                FMTimeKillnoteModel * model = [[FMTimeKillnoteModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                
                [self.dataSource addObject:model];
            }
            
            [self.tableView reloadData];
            
        }else if (response.code == WebAPIResponseCodeFailed)
        {
            
        }else
        {
            
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FMTimeKillNoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FMTimeKillNoteTableViewCellRegister];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


- (void)configureCell:(FMTimeKillNoteTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    
    FMTimeKillnoteModel * killModel = self.dataSource[indexPath.row];
    
    cell.killNote = killModel;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat heigh = [tableView fd_heightForCellWithIdentifier:FMTimeKillNoteTableViewCellRegister  configuration:^(FMTimeKillNoteTableViewCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
    
    if (heigh > 140) {
        return heigh;
    }else
    {
        return 140;
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
