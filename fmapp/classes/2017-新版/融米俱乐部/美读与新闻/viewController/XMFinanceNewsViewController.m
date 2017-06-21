//
//  XMFinanceNewsViewController.m
//  fmapp
//
//  Created by runzhiqiu on 16/2/24.
//  Copyright © 2016年 yk. All rights reserved.
//
#define KReuseIdentifierCell @"XMFinaceAndReadTableViewCell"
#import "XMFinanceNewsViewController.h"
#import "FMfinanceAndReadTableViewCell.h"

#import "ShareViewController.h"
#import "FMfinanceAndReadHeaderViewNew.h"
#import "XMShareWebViewController.h"
#import "FMBeautifulModel.h"
//#import "FMSignDownNoteView.h"
@interface XMFinanceNewsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) BOOL isAddData;
@property (nonatomic, strong) NSURLSessionDataTask * dataTask;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation XMFinanceNewsViewController

-(UISegmentedControl *)segmentedControl
{
    if (!_segmentedControl) {
        NSArray * titleArray = @[@"财经新闻",@"美读时光"];
        _segmentedControl = [[UISegmentedControl alloc]initWithItems:titleArray];
        _segmentedControl.frame = CGRectMake(0, 0,200.0, 30.0);
        //设置分段控件点击相应事件
        [_segmentedControl setSelectedSegmentIndex:self.currentIndex];
        [_segmentedControl addTarget:self action:@selector(doSomethingInSegment:)forControlEvents:UIControlEventValueChanged];
        _segmentedControl.tintColor = XZColor(14, 93, 210);
        
    }
    return _segmentedControl;
}
-(void)doSomethingInSegment:(UISegmentedControl *)segment
{
    self.currentIndex = segment.selectedSegmentIndex;
    _currentPage = 1;
    _isAddData = NO;
    //[self.dataSource removeAllObjects];
    [self getDataSourceWithLocation];
    
    if (self.dataSource.count > 0) {
        [self createtableViewHeaderView];
    }
    
    [self.tableView reloadData];
    [self getDataSourceFromNetWork];
}

-(void)getDataSourceWithLocation
{
    FMBeautifulModel * model = [[FMBeautifulModel alloc]init];
    if (self.currentIndex == 0) {
        model.keyString = @"caijingModelArray";
    }else
    {
        model.keyString = @"meiduModelArray";
    }
    
    self.dataSource = [model dataArrayFromArachiver];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage = 1;
    _isAddData = NO;
    [self getDataSourceWithLocation];
    
    [self createtableView];
    
    if (_dataSource.count > 0) {
        
        [self createtableViewHeaderView];
        
    }
    
    self.navigationItem.titleView = self.segmentedControl;
    
    
    [self getDataSourceFromNetWork];
    
    // Do any additional setup after loading the view.
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.dataTask) {
        [self.dataTask cancel];
    }
}
-(void)dealloc
{
    Log(@"-----死了-----");
}

-(void)getDataSourceFromNetWork
{
    NSString * html;
    
    if (self.currentIndex == 0) {
        html = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/Rongtuoxinsoc/api/newsList/cateid/5/p/%d",self.currentPage];
        
    }else
    {
        html = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/Rongtuoxinsoc/api/newsList/cateid/6/p/%d",self.currentPage];
    }
    
    __weak __typeof(&*self)weakSelf = self;
    
    [self.dataTask cancel];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    self.dataTask = [FMHTTPClient postReturnPath:html parameters:nil completion:^(WebAPIResponse *response) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (response.responseObject) {
            
            
            NSString * status = [NSString stringWithFormat:@"%@",response.responseObject[@"status"]];
            
            if ([status integerValue] == 0) {
                NSArray * oldArray = response.responseObject[@"data"];
                if (_isAddData) {
                    
                    
                }else
                {
                    [self.dataSource removeAllObjects];
                }
                if (oldArray.count != 0) {
                    
                    for(NSDictionary * dict in oldArray) {
                        
                        FMBeautifulModel * model = [[FMBeautifulModel alloc]init];
                        [model setValuesForKeysWithDictionary:dict];
                        
                        [self.dataSource addObject:model];
                    }
                    
                    if (!_isAddData) {
                        FMBeautifulModel * modelSave = [[FMBeautifulModel alloc]init];
                        if (self.currentIndex == 0) {
                            modelSave.keyString = @"caijingModelArray";
                        }else
                        {
                            modelSave.keyString = @"meiduModelArray";
                        }
                        [modelSave saveUserObjectWithUser:self.dataSource];
                    }
                    
                    
                    if (self.dataSource.count == 0) {
                        
                        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenWidth*1136/640)];
                        [imgV setImage:[UIImage imageNamed:@"未标题-1.png"]];
                        self.tableView.tableHeaderView  =imgV;
                        
                    }else
                    {
                        [self createtableViewHeaderView];
                    }
                    
                }
                
                if (_isAddData) {
                    
                    _isAddData = NO;
                }else
                {
                    
                }
                [self.tableView reloadData];
                
                
            }else if([status integerValue] == 2)
            {
                ShowAutoHideMBProgressHUD(weakSelf.view,@"加载完毕");
                [self.tableView reloadData];
            }else
            {
                ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
                
                [self.tableView reloadData];
            }
        }else
        {
            //ShowAutoHideMBProgressHUD(weakSelf.view,@"当前网络不佳");
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
-(void)createtableViewHeaderView
{
    FMfinanceAndReadHeaderViewNew * headerView = [[FMfinanceAndReadHeaderViewNew alloc]init];
    headerView.dataSource = self.dataSource[0];
    __weak __typeof(&*self)weakSelf = self;
    headerView.buttonBlock = ^(FMBeautifulModel * model){
        [weakSelf financeAndReadHeaderViewNewButtonOnClick:model];
    };
    self.tableView.tableHeaderView = headerView;
}
-(void)financeAndReadHeaderViewNewButtonOnClick:(FMBeautifulModel *)dataSource
{
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    
    NSString *news_id = dataSource.news_id;
    NSString * html = [NSString stringWithFormat:@"http://ww.rongtuojinrong.com/news/detail/id/%@?appid=huiyuan&user_id=%@&shijian=%d&token=%@",news_id,[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow];
    NSString * htmlNoInfo = [NSString stringWithFormat:@"http://ww.rongtuojinrong.com/news/detail/id/%@",news_id];
    XMShareWebViewController *shareVC = [[XMShareWebViewController alloc]initWithTitle:dataSource.title AndWithShareUrl:html WithShareUrlWithNoUserInfo:htmlNoInfo withContent:dataSource.shareContent];
    shareVC.dataSource = dataSource;
    shareVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shareVC animated:YES];
    
}

-(void)createtableView
{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, self.view.bounds.size.height - 5) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    
    [tableView registerClass:[FMfinanceAndReadTableViewCell class] forCellReuseIdentifier:KReuseIdentifierCell];
    
    
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPage = 1;
        _isAddData = NO;
        [self getDataSourceFromNetWork];
    }];
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _currentPage = _currentPage + 1;
        _isAddData = YES;
        [self getDataSourceFromNetWork];
    }];
    [self.view addSubview:tableView];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (KProjectScreenWidth > 400) {
        return 110;
    }else if(KProjectScreenWidth > 360)
    {
        return 105;
    }else if(KProjectScreenWidth > 360)
    {
        return 100;
    }else
    {
        return 95;
    }
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count - 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FMfinanceAndReadTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:KReuseIdentifierCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dataSource = self.dataSource[indexPath.row + 1];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    FMBeautifulModel *dic = [self.dataSource objectAtIndex:(indexPath.row + 1)];
    NSString *news_id = dic.news_id;
    NSString * html = [NSString stringWithFormat:@"http://ww.rongtuojinrong.com/news/detail/id/%@?appid=huiyuan&user_id=%@&shijian=%d&token=%@",news_id,[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow];
    
    NSString * htmlNoInfo = [NSString stringWithFormat:@"http://ww.rongtuojinrong.com/news/detail/id/%@",news_id];
    XMShareWebViewController *shareVC = [[XMShareWebViewController alloc]initWithTitle:dic.title AndWithShareUrl:html WithShareUrlWithNoUserInfo:htmlNoInfo withContent:dic.shareContent];
    shareVC.dataSource = dic;
    shareVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shareVC animated:YES];
    
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
