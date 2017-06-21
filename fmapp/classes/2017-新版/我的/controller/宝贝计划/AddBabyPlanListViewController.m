//
//  AddBabyPlanListViewController.m
//  fmapp
//
//  Created by runzhiqiu on 16/1/5.
//  Copyright © 2016年 yk. All rights reserved.
//
#define KDefaultBackGround [UIColor colorWithRed:(231.0/255) green:(234.0/255) blue:(239.0/255) alpha:1]
#define KRegistraterAddbabyPlanTableViewCell @"AddbabyPlanTableViewCell"
#import "AddBabyPlanListViewController.h"
#import "BabyPlanOneScheduled.h"
#import "BabyPlanModel.h"
#import "AddbabyPlanTableViewCell.h"
#import "LookAgreementViewController.h"
@interface AddBabyPlanListViewController ()<UITableViewDelegate,UITableViewDataSource,AddbabyPlanTableViewCellDelegate>

@property (nonatomic, weak) UITableView * tableview;
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) NSInteger page_size;


@property (nonatomic, assign) BOOL isLoad;

@end

@implementation AddBabyPlanListViewController

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.page_size = 12;
    self.isLoad = NO;
    [self settingNavTitle:@"加入列表"];
    self.view.backgroundColor = KDefaultBackGround;
    [self createTableViewOnThisView];
    [self getdataSourceFfromNetWork];
    // Do any additional setup after loading the view.
}
/** 宝贝计划--加入列表 */
-(void)getdataSourceFfromNetWork
{
    NSDictionary * dictParame = @{@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,@"jie_id":self.babyPlan.jie_id,@"page":[NSNumber numberWithInteger:self.page],@"page_size":[NSNumber numberWithInteger:self.self.page_size]};
    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient getPath:babyPlanListURL parameters:dictParame completion:^(WebAPIResponse *response) {
        
        NSDictionary * allDictionary = (NSDictionary *)response.responseObject;
        NSNumber * status = allDictionary[@"status"];
        if ([status integerValue] == 0) {
            
            NSArray * array = allDictionary[@"data"];
            if (self.isLoad) {
                [self.dataSource removeAllObjects];
            }
            if(array.count > 0){
                for (NSDictionary * dict in array) {
                    BabyPlanOneScheduled * schedeled = [BabyPlanOneScheduled babyPlanOneScheduledModelCreateWithDictionary:dict];
                    [self.dataSource addObject:schedeled];
                }
                [self.tableview reloadData];
            }else
            {
                ShowAutoHideMBProgressHUD(weakSelf.view,@"无数据");
            }
        }
        
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        
        
        
    }];

}
-(void)createTableViewOnThisView
{
    UITableView * tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 70) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = KDefaultBackGround;
    [tableview registerNib:[UINib nibWithNibName:@"AddbabyPlanTableViewCell" bundle:nil] forCellReuseIdentifier:KRegistraterAddbabyPlanTableViewCell];
    [self.view addSubview:tableview];
    
     __weak __typeof(&*self)weakSelf = self;
    tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page ++;
        self.isLoad = NO;
        [weakSelf getdataSourceFfromNetWork];
        
    }];
    tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        self.isLoad = YES;
       
        [weakSelf getdataSourceFfromNetWork];
    }];
    self.tableview = tableview;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddbabyPlanTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:KRegistraterAddbabyPlanTableViewCell forIndexPath:indexPath];
    cell.delegate = self;
    cell.scheduled = self.dataSource[indexPath.row];

    return cell;
}
/** 宝贝计划--查看合同 */
-(void)AddbabyPlanTableViewCell:(AddbabyPlanTableViewCell *)addPlanTableViewCell ContractButtonOnClick:(BabyPlanOneScheduled *)scheduled
{
    //查看合同
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSString *url=[NSString stringWithFormat:@"%@?user_id=%@&appid=huiyuan&shijian=%d&token=%@&jilu_id=%@",babyPlanLookContractURL,[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow,scheduled.jilu_id];

    

    LookAgreementViewController * LookView = [[LookAgreementViewController alloc]init];
    LookView.shareURL = url;
    LookView.navTitle = @"借款及保证合同";
    LookView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:LookView animated:YES];

    
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
