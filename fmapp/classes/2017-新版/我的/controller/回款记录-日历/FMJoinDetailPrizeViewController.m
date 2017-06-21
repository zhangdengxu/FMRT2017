//
//  FMJoinDetailPrizeViewController.m
//  fmapp
//
//  Created by runzhiqiu on 2017/2/22.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMJoinDetailPrizeViewController.h"

#import "FMJionPrizeHeaderView.h"
#import "FMJoinDetailAndPrizeTableViewCell.h"
#import "FMJoinDetalPrizeModel.h"
#import "FMJionFriendListViewController.h"
#import "FMMyJoinDetailTypeController.h"


@interface FMJoinDetailPrizeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) FMJionPrizeHeaderView * headerView;
@end


@implementation FMJoinDetailPrizeViewController



static NSString * joinDetailAndPrizeTableViewCellRegister = @"joinDetailAndPrizeTableViewCellRegister";


-(FMJionPrizeHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[FMJionPrizeHeaderView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenWidth * 0.88)];
         __weak __typeof(&*self)weakSelf = self;
        _headerView.blockHeaderView = ^(NSInteger index){
            [weakSelf jumpAndTurnToDate:index];
        };
        
    }
    return _headerView;
}

-(void)jumpAndTurnToDate:(NSInteger )index
{
    switch (index) {
        case 0:
        {
            //日历点击
//            FMMyJoinDetailTypeController * joinDetail = [[FMMyJoinDetailTypeController
//                                                          alloc]init];
//            joinDetail.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:joinDetail animated:YES];
        }
            break;
        case 1:
        {
//            累积奖励元的点击
            FMMyJoinDetailTypeController * joinDetail = [[FMMyJoinDetailTypeController
                                                          alloc]init];
            joinDetail.typeWithJoin = 0;

            joinDetail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:joinDetail animated:YES];
        }
            break;
        case 3:
        {
//            左下角的现金奖励
            FMMyJoinDetailTypeController * joinDetail = [[FMMyJoinDetailTypeController
                                                          alloc]init];
            joinDetail.typeWithJoin = 1;

            joinDetail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:joinDetail animated:YES];
        }
            break;
        case 4:
        {
//            中间红包奖励
            FMMyJoinDetailTypeController * joinDetail = [[FMMyJoinDetailTypeController
                                                          alloc]init];
            joinDetail.typeWithJoin = 2;
            joinDetail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:joinDetail animated:YES];
        }
            break;
        case 5:
        {
            
            //有效好友人
            FMJionFriendListViewController * jionFriend = [[FMJionFriendListViewController alloc]init];
            jionFriend.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:jionFriend animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[FMJoinDetailAndPrizeTableViewCell class] forCellReuseIdentifier:joinDetailAndPrizeTableViewCellRegister];
        [self.view addSubview:_tableView];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

            [self getHeaderViewDataSourceFromNetWork];

            
            
        }];

    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"我的邀请"];
    self.tableView.tableHeaderView = self.headerView;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [self getHeaderViewDataSourceFromNetWork];
    // Do any additional setup after loading the view.
}
-(void)getHeaderViewDataSourceFromNetWork
{
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"AppId":@"huiyuan",
                                 @"AppTime":[NSNumber numberWithInt:timestamp],
                                 @"Token":tokenlow
                            };
    NSString * stringHtml = kXZUniversalTestUrl(@"GetInviterStats");
    
    [FMHTTPClient postPath:stringHtml parameters:parameter completion:^(WebAPIResponse *response) {
        
        

        if (response.code == WebAPIResponseCodeSuccess) {
            NSDictionary * dict = response.responseObject[@"data"];
            if (!([dict isMemberOfClass:[NSArray class]]||[dict isMemberOfClass:[NSNull class]])) {
                FMJionPrizeHeaderViewModel * model = [[FMJionPrizeHeaderViewModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                
                
                self.headerView.headerModel = model;
                
            }
        }
        
        [self getDateSourceFromNetWork];
    }];
    

}

-(void)getDateSourceFromNetWork
{
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
//    NSDictionary * parameter = @{@"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
//                                 @"AppId":@"huiyuan",
//                                 @"AppTime":[NSNumber numberWithInt:timestamp],
//                                 @"Token":tokenlow,
//                                 @"PageNum":@"1",
//                                 @"AwardType":@"0",
//                                 @"PageSize":@"10"};
    NSDictionary * parameter = @{@"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"AppId":@"huiyuan",
                                 @"AppTime":[NSNumber numberWithInt:timestamp],
                                 @"Token":tokenlow,
                                 @"AwardType":@"0"};
    NSString * stringHtml = kXZUniversalTestUrl(@"GetInviterAwardList"); //GetInviterAwardList
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [FMHTTPClient postPath:stringHtml parameters:parameter completion:^(WebAPIResponse *response) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.tableView.mj_header endRefreshing];
        if (response.code == WebAPIResponseCodeSuccess) {
            NSDictionary * dict = response.responseObject[@"data"];
            if (!([dict isMemberOfClass:[NSArray class]]||[dict isMemberOfClass:[NSNull class]])) {
                NSArray * array = dict[@"Detail"];
                [self.dataSource removeAllObjects];
                
                for (NSDictionary * dictDate in array) {
                    FMJoinDetalPrizeModel * model = [[FMJoinDetalPrizeModel
                                                      alloc]init];
                    [model setValuesForKeysWithDictionary:dictDate];
                    [self.dataSource addObject:model];
                }
                 
                if (self.dataSource.count == 0) {
                    [self.headerView haveNoAnyDate];
                }else
                {
                    [self.headerView haveALLdataSource];

                }
                
                
                
                
                [self.tableView reloadData];
                
            }else
            {
                ShowAutoHideMBProgressHUD(self.view, @"参数错误，请稍后重试！");
            }
            
        }else
        {
            NSString * status =  response.responseObject[@"status"];
            if (![status isMemberOfClass:[NSNull class]]) {
                NSInteger staNum = [status integerValue];
                if (staNum == 1) {
                    ShowAutoHideMBProgressHUD(self.view, response.responseObject[@"msg"]);
                    
                }else
                {
                    ShowAutoHideMBProgressHUD(self.view, @"网络不好，请稍后重试！");
                }
            }else
            {
                ShowAutoHideMBProgressHUD(self.view, @"网络不好，请稍后重试！");
                
            }
        }
        
        
    }];

    
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FMJoinDetailAndPrizeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:joinDetailAndPrizeTableViewCellRegister forIndexPath:indexPath];
    
    
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
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
