//
//  XMConvertNotesViewController.m
//  fmapp
//
//  Created by runzhiqiu on 16/1/23.
//  Copyright © 2016年 yk. All rights reserved.
//
#define KPageSize 10
#define KReuseIdentifierCell @"XMConverNoteCell"

#import "XmConverNotesModel.h"
#import "XMConvertNotesViewController.h"
#import "FMPlaceOrderViewController.h"
#import "XMConvertNoteHeaderView.h"
#import "XMConverNoteCell.h"
#import "ShareViewController.h"
#import "SignOnDeleteView.h"
@interface XMConvertNotesViewController ()<UITableViewDelegate,UITableViewDataSource,XMConvertNoteHeaderViewDelegate,XMConverNoteCellDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) BOOL isAddData;
@property (nonatomic, assign) int goodsStates;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, weak) NSURLSessionDataTask * task;

@end

@implementation XMConvertNotesViewController
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage = 1;
    [self setUpNavigationBarUI];
    [self createtableView];
    [self createtableViewHeaderView];
    [self getDataSourceFromNetWorkwithChange:NO];
    [self getHeaderViewFromNetWork];
    // Do any additional setup after loading the view.
}
-(void)createtableViewHeaderView
{
    XMConvertNoteHeaderView * headerView = [[XMConvertNoteHeaderView alloc]init];
    headerView.delegate = self;
    self.tableView.tableHeaderView = headerView;
    self.goodsStates = (int)(headerView.currentStatus.selectedSegmentIndex + 1);
    
}
-(void)XMConvertNoteHeaderViewDidSelectSegmentedControl:(XMConvertNoteHeaderView *)headerView
{
    self.goodsStates = (int)(headerView.currentStatus.selectedSegmentIndex + 1);
    self.currentPage = 1;
    [self getDataSourceFromNetWorkwithChange:YES];
}
-(void)setUpNavigationBarUI
{
    self.view.backgroundColor = KDefaultOrBackgroundColor;
    [self settingNavTitle:@"兑换记录"];
}
-(void)createtableView
{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, self.view.bounds.size.height - 49) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    
    [tableView registerNib: [UINib nibWithNibName:@"XMConverNoteCell"  bundle:nil] forCellReuseIdentifier:KReuseIdentifierCell];
    
    tableView.showsVerticalScrollIndicator = NO;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPage = 1;
        _isAddData = NO;
        [self getDataSourceFromNetWorkwithChange:NO];
    }];
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _currentPage = _currentPage + 1;
        _isAddData = YES;
        [self getDataSourceFromNetWorkwithChange:NO];
    }];
    [self.view addSubview:tableView];
}
/** 融米俱乐部--兑换记录*/
-(void)getDataSourceFromNetWorkwithChange:(BOOL)change
{
    if (change) {
        [self.dataSource removeAllObjects];
    }
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=jifen&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString *string;
    if (self.goodsStates == 1) {
        //已发货
        string = [NSString stringWithFormat:@"%@?appid=jifen&user_id=%@&shijian=%d&token=%@&pay_status=%@&npage=%d&tel=%@&from=rongtuoapp",rongMiExchangeRecordURL,[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow,@"shiped",self.currentPage,[CurrentUserInformation sharedCurrentUserInfo].mobile];
    }else
    {
        string = [NSString stringWithFormat:@"%@?appid=jifen&user_id=%@&shijian=%d&token=%@&pay_status=%@&npage=%d&tel=%@&from=rongtuoapp",rongMiExchangeRecordURL,[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow,@"unship",self.currentPage,[CurrentUserInformation sharedCurrentUserInfo].mobile];
    }
    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    __weak __typeof(&*self)weakSelf = self;

    [self.task cancel];
    
    self.task = [FMHTTPClient getReturnPath:string parameters:nil completion:^(WebAPIResponse *response) {
        
            NSString * status = [NSString stringWithFormat:@"%@",response.responseObject[@"status"]];
            
            if ([status integerValue] == 0) {
                NSArray * oldArray = response.responseObject[@"data"];
                if (_isAddData) {
                    
                    _isAddData = NO;
                }else
                {
                    [self.dataSource removeAllObjects];
                }
                for (NSDictionary * dict in oldArray) {
                    XmConverNotesModel * model = [XmConverNotesModel XmConverNotesModelCreateWithDictionary:dict];
                    model.zhuangtai = [NSString stringWithFormat:@"%d",self.goodsStates];
                    [self.dataSource addObject:model];
                }
                [self.tableView reloadData];
            }else if([status integerValue] == 2)
            {
                ShowAutoHideMBProgressHUD(weakSelf.view,@"加载完毕");
                [self.tableView reloadData];
            }else
            {
                ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
            }
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
    }];

}
/** 融米俱乐部--兑换记录--headerView */
/**
 *  tableViewHeaderView  Data
 */
-(void)getHeaderViewFromNetWork
{
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=jifen&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString *string = [NSString stringWithFormat:@"%@?appid=jifen&user_id=%@&shijian=%d&token=%@",rongMiHeaderViewURL,[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow];
   
    __weak __typeof(&*self)weakSelf = self;
//    NSLog(@"%@",string);
    [FMHTTPClient getPath:string parameters:nil completion:^(WebAPIResponse *response) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (response.code==WebAPIResponseCodeSuccess) {
                [self refreshTableViewHeaderView:[NSString stringWithFormat:@"%@", response.responseObject[@"data"]]];
            }
            else
            {
                ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
                
            }
        });
    }];
}

-(void)refreshTableViewHeaderView:(NSString *)myScore
{
    XMConvertNoteHeaderView * headerView = (XMConvertNoteHeaderView *)self.tableView.tableHeaderView;
    headerView.myScoreLabel.text = myScore;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMConverNoteCell * cell = [tableView dequeueReusableCellWithIdentifier:KReuseIdentifierCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setUpConverDeleteButtonLayer];
    cell.noteModel = self.dataSource[indexPath.row];
    cell.delegate = self;
    return cell;
}
/** 融米俱乐部--兑换记录--点击每一行cell */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XmConverNotesModel * model = self.dataSource[indexPath.row];
    
    FMPlaceOrderViewController * placrOrder = [[FMPlaceOrderViewController alloc]init];
    placrOrder.product_id = model.shangpin_id;
    if ([model.type isEqualToString:@"fulljifen_ex"]) {
        placrOrder.isShopFullScore = 1;
    }else
    {
        placrOrder.isShopFullScore = 0;
    }
    [self.navigationController pushViewController:placrOrder animated:YES];
    
}
-(void)ConverNoteCellDidSelectconverDelete:(XMConverNoteCell *)convertNote;
{
    XmConverNotesModel * model = convertNote.noteModel;
    [self deleteFromNetWork:model];
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 删除的操作
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self showDeleteTableViewAlertWithTableView:tableView withIndexPath:indexPath];
    }
}


-(void)showDeleteTableViewAlertWithTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath
{
    
    SignOnDeleteView *signOn = [[SignOnDeleteView alloc]init];
    [signOn showSignViewWithTitle:@" 确定要删除记录吗？" detail:@" 兑换记录删除后不可恢复!"];
     __weak __typeof(&*self)weakSelf = self;
    // 点击确定按钮
    signOn.sureBlock = ^(UIButton *button) {
        [weakSelf delectNetWorkWithTableView:tableView withIndexPath:indexPath];
    };
}
-(void)delectNetWorkWithTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath
{
    XmConverNotesModel * model = self.dataSource[indexPath.row];
    [self deleteFromNetWork:model];
    
    [self.dataSource removeObjectAtIndex:indexPath.row];
    NSArray *indexPaths = @[indexPath]; // 构建 索引处的行数 的数组
    // 删除 索引的方法 后面是动画样式
    [_tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:(UITableViewRowAnimationLeft)];
}


/** 融米俱乐部--兑换记录--删除cell */
-(void)deleteFromNetWork:(XmConverNotesModel *)model
{
        int timestamp = [[NSDate date]timeIntervalSince1970];
        NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=jifen&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
        NSString *tokenlow=[token lowercaseString];
//        NSString *string = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/Rongtuoxinsoc/Rmjifenshop/shchduihuanjilu?appid=jifen&user_id=%@&shijian=%d&jilu_id=%@&token=%@",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,model.jilu_id,tokenlow];
//    NSLog(@"%@",string);
    NSDictionary * dataDict = @{@"action":@"delete",@"order_id":model.jilu_id};
    
        __weak __typeof(&*self)weakSelf = self;
    
    
    NSString * string = [NSString stringWithFormat:@"%@?appid=jifen&user_id=%@&shijian=%d&token=%@&tel=%@&action=%@&order_id=%@&from=rongtuoapp",rongMiDeleteCellURL,[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow,[CurrentUserInformation sharedCurrentUserInfo].mobile,@"delete",model.jilu_id];
    
    
        [FMHTTPClient postPath:string parameters:dataDict completion:^(WebAPIResponse *response) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (response.code==WebAPIResponseCodeSuccess) {
                    if (response.code==WebAPIResponseCodeSuccess) {
                        ShowAutoHideMBProgressHUD(weakSelf.view,@"删除成功");
                    }else
                    {
                         ShowAutoHideMBProgressHUD(weakSelf.view,response.responseObject[@"msg"]);
                    }
                   
                }
                else
                {
                    ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
                    
                }
            });
        }];
    

}

@end
