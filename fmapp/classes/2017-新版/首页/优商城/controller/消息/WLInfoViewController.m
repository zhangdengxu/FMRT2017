//
//  WLInfoViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/4/26.
//  Copyright © 2016年 yk. All rights reserved.
//
#define KDefaultTextColor [UIColor colorWithRed:(170.0/255) green:(170.0/255) blue:(170.0/255) alpha:1]
#import "WLInfoViewController.h"
//#import "WLRongModel.h"
#import "WLInfoTableViewCell.h"
#import "XMFinanceNewsViewController.h"
#import "XMFinaceAndReadTableViewCell.h"
#import "ShareViewController.h"
//#import "WLLingQianTableViewCell.h" ====XZ
#import "XMShareWebViewController.h"
//#import "QCViewController.h" ====XZ
//#import "AllRollOutViewController.h" ====XZ
@interface WLInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) BOOL isAddData;
@property (nonatomic, copy)   NSString *navUrl;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) BOOL isOver;
@property (nonatomic, strong)UIImageView  * backGroundImage;

@end

@implementation WLInfoViewController

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


-(UIImageView *)backGroundImage
{
    if (!_backGroundImage) {
        _backGroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenWidth*822/486)];
        [_backGroundImage setImage:[UIImage imageNamed:@"暂无数据"]];
        [self.view addSubview:_backGroundImage];
    }
    return _backGroundImage;
}

-(void)contueNullDataSource
{
    self.tableView.hidden = YES;
    self.backGroundImage.hidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self settingNavTitle:@"信息通告"];
    _currentPage = 1;
    [super loadView];
    
    [self createTableView];
//    [self setNavItemsWithButton];
    [self getDataSourceFromNetWork];
}

-(void)createTableView{
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -30, KProjectScreenWidth, KProjectScreenHeight-30) style:UITableViewStyleGrouped];
    tableView.backgroundColor = KDefaultOrBackgroundColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.autoresizesSubviews = NO;
    tableView.sectionHeaderHeight = 0;
    tableView.sectionFooterHeight = 0;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.isOver = NO;
        _currentPage = 1;
        _isAddData = NO;
        [self getDataSourceFromNetWork];
    }];
//    tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
//        if (!self.isOver) {
//            _currentPage = _currentPage+1;
//            _isAddData = YES;
//            [self getDataSourceFromNetWork];
//        }
//    }];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

-(void)getDataSourceFromNetWork{
    [self.dataSource removeAllObjects];
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSString *string = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/member-msg_list_client.html?from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%d&user_id=%@&cateid=%@",[CurrentUserInformation sharedCurrentUserInfo].mobile,tokenlow,timestamp,[CurrentUserInformation sharedCurrentUserInfo].userId,@"1"];

    NSString *encoded = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient getPath:encoded parameters:nil completion:^(WebAPIResponse *response) {
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (response.code==WebAPIResponseCodeSuccess) {
                
                
                NSArray *dic = [response.responseObject objectForKey:@"data"];
                if (![dic isKindOfClass:[[NSNull null] class]]) {
                    if (dic.count == 0) {
                        [self contueNullDataSource];
                    }else{
                        for (int i = 0; i<dic.count; i++) {
                            
                            WLInfoModel *model = [[WLInfoModel alloc]init];
                            model.Info = [dic[i] objectForKey:@"info"];
                            model.time = [dic[i] objectForKey:@"time"];
                            model.img = [dic[i] objectForKey:@"img"];
                            model.idStr = [dic[i] objectForKey:@"id"];
                            model.title = [dic[i] objectForKey:@"title"];
                            [self.dataSource addObject:model];
                        }
                    }

                    [self.tableView reloadData];
                }else{
                    
                    [self contueNullDataSource];
                }
               
            }
            else
            {
                ShowAutoHideMBProgressHUD(weakSelf.view,@"请求失败");
                
            }
            [weakSelf.tableView.mj_header endRefreshing];
//            [weakSelf.tableView.mj_footer endRefreshing];
        });
    }];

}


#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [WLInfoTableViewCell hightForCell];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak __typeof(self)weakself = self;
    WLInfoModel *model = self.dataSource[indexPath.row];
    WLInfoTableViewCell *cell = [WLInfoTableViewCell cellLingQianHasSaved:tableView];
    cell.contentView.backgroundColor = KDefaultOrBackgroundColor;
    if (weakself.dataSource.count != 0) {
        cell.model = model;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    WLInfoModel *model = self.dataSource[indexPath.row];
    
    NSString *urlStr = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/jili/index.php/home/login/showeb?appid=huiyuan&user_id=%@&shijian=%d&token=%@&id=%@",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow,model.idStr];
    
    ShareViewController *shareVC = [[ShareViewController alloc]initWithTitle:@"信息通告" AndWithShareUrl:urlStr];
    shareVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shareVC animated:YES];

}

- (void)setNavItemsWithButton {
    
    UIButton *messageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22.5*3/2, 25*3/2)];
    [messageButton setBackgroundImage:[UIImage imageNamed:@"优商城售后_未读消息_36"] forState:UIControlStateNormal];
    [messageButton setBackgroundImage:[UIImage imageNamed:@"优商城售后_已读消息_36"] forState:UIControlStateSelected];
    [messageButton addTarget:self action:@selector(rightAction:) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *navItem = [[UIBarButtonItem alloc]initWithCustomView:messageButton];
    [self.navigationItem setRightBarButtonItem:navItem animated:YES];
    

}

- (void)rightAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
}

@end
