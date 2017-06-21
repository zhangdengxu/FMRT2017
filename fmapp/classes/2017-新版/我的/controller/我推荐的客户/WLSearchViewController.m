//
//  WLSearchViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 17/3/14.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "WLSearchViewController.h"
#import "WLSearchKeHuViewController.h"
#import "FMRTTuijianModel.h"
#import "WLFriendsAtrTableViewCell.h"
#define IMPUT_MAX 11
@interface WLSearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)FMRTTuijianModel *dataModel;
@property(nonatomic,strong)UISearchBar *customSearchBar;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)UIView *bjView;
@property(nonatomic,assign)BOOL isAddData;
@property(nonatomic,assign)int currentPage;
@property(nonatomic,strong)NSArray *startAndEndTime;
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)UIImageView *backGroundImage;
@end

@implementation WLSearchViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:HUIApplicationFrame()];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = KDefaultOrBackgroundColor;
}

-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        __weak __typeof(&*self)weakSelf = self;
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _currentPage ++;
            _isAddData = YES;
            [weakSelf loadMoreListData];
            
        }];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _currentPage = 1;
            _isAddData = NO;
            
            [weakSelf loadMoreListData];
        }];
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSearchBar];
    self.currentPage = 1;
    [self.view addSubview:self.tableView];
//    [self createHeaderView];
}

-(UIImageView *)backGroundImage
{
    if (!_backGroundImage) {
        _backGroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenWidth*822/486)];
        [_backGroundImage setImage:[UIImage imageNamed:@"暂无数据"]];
        [_backGroundImage setBackgroundColor:[UIColor redColor]];
        [self.tableView addSubview:_backGroundImage];
    }
    return _backGroundImage;
}

-(void)contueNullDataSource
{
    //    self.tableView.hidden = YES;
    self.backGroundImage.hidden = NO;
    
}

- (void)loadMoreListData{
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *userId;
    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
        userId = [CurrentUserInformation sharedCurrentUserInfo].userId;
    }else{
        userId = @"0";
    }
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"UserId":userId,
                                 @"AppId":@"huiyuan",
                                 @"AppTime":[NSNumber numberWithInt:timestamp],
                                 @"Token":tokenlow,
                                 @"page":[NSString stringWithFormat:@"%d",self.currentPage],
                                 @"page_size":@"10",
                                 @"shoujihao":self.searchBar.text
                                 
                                 };
    
    __weak __typeof(self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    kXZUniversalTestUrl(@"FriendContribution")
    [FMHTTPClient postPath:kFMPhpUniversalBaseUrl(@"rongtuoxinsoc/Usercenter/myrecommpersasslistliuer") parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if (response.code==WebAPIResponseCodeSuccess) {
            if (_isAddData) {
                
                _isAddData = NO;
            }else
            {
                [weakSelf.dataArr removeAllObjects];
            }
            
            NSArray  *arr = [response.responseObject objectForKey:@"data"];
            for (NSDictionary *dic in arr) {
                FMRTTuijianModel *model = [[FMRTTuijianModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [weakSelf.dataArr addObject:model];
            }
            if (arr.count) {
                [self createHeaderView];
            }else{
                self.tableView.tableHeaderView = nil;
            }
        }else{
            self.tableView.tableHeaderView = nil;
        }
        
        if (weakSelf.dataArr.count == 0) {
            [self contueNullDataSource];
        }else{
            self.backGroundImage.hidden = YES;
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    }];
    
}

-(NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


-(void)createHeaderView{
    
    UIView *bjView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 50)];
    [bjView setBackgroundColor:[UIColor whiteColor]];
    self.tableView.tableHeaderView = bjView;
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 100, 50)];
    [nameLabel setFont:[UIFont systemFontOfSize:16]];
    [nameLabel setTextColor:[HXColor colorWithHexString:@"#333"]];
    [nameLabel setText:@"姓名"];
    [bjView addSubview:nameLabel];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 50)];
    [timeLabel setFont:[UIFont systemFontOfSize:16]];
    [timeLabel setTextAlignment:NSTextAlignmentCenter];
    [timeLabel setTextColor:[HXColor colorWithHexString:@"#333"]];
    [timeLabel setText:@"手机号"];
    [bjView addSubview:timeLabel];
    
    UILabel *ztLabel = [[UILabel alloc]initWithFrame:CGRectMake(KProjectScreenWidth-115, 0, 115, 50)];
    [ztLabel setFont:[UIFont systemFontOfSize:16]];
    [ztLabel setTextAlignment:NSTextAlignmentCenter];
    [ztLabel setTextColor:[HXColor colorWithHexString:@"#333"]];
    [ztLabel setText:@"推荐资产(万元)"];
    [bjView addSubview:ztLabel];
}



-(void)createSearchBar{
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth-150, 30)];
    UIColor *color =  self.navigationController.navigationBar.tintColor;
    [titleView setBackgroundColor:[UIColor colorWithRed:201/255.0 green:201/255.0 blue:206/255.0 alpha:1]];
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    searchBar.frame = CGRectMake(0, 0, KProjectScreenWidth-150, 30);
    searchBar.backgroundColor = color;
    //    searchBar.layer.cornerRadius = 18;
    searchBar.layer.masksToBounds = YES;
    searchBar.delegate = self;
    searchBar.placeholder = @"输入好友手机号";
    searchBar.keyboardType = UIKeyboardTypeNumberPad;
    [titleView addSubview:searchBar];
    self.navigationItem.titleView = titleView;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 44, 44)];
    [button setTitle:@" 搜索" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:201/255.0 green:201/255.0 blue:206/255.0 alpha:1] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.searchBar = searchBar;
}


-(void)searchAction{
    [self.view endEditing:YES];
    if (self.searchBar.text.length != 11) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        ShowAutoHideMBProgressHUD(self.view, @"请输入11位手机号");
        return;
    }
    [self.dataArr removeAllObjects];
    self.currentPage = 1;
    [self loadMoreListData];
}

-(void)cancelAction{
    
    [self.bjView removeFromSuperview];
}

#pragma -mark UISearchBarDelegate

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (searchBar.text.length > IMPUT_MAX){
        searchBar.text = [searchText substringToIndex:11];
//        NSLog(@"---->:%@",searchBar.text);
    }
    
}

- (BOOL)validateNumberByRegExp:(NSString *)string {
    BOOL isValid = YES;
    NSUInteger len = string.length;
    if (len > 0) {
        NSString *numberRegex = @"^[0-9.]*$";
        NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
        isValid = [numberPredicate evaluateWithObject:string];
    }
    return isValid;
}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"SearchCell";
    
    WLFriendsAtrTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[WLFriendsAtrTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row<self.dataArr.count) {
        cell.model = self.dataArr[indexPath.row];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.view endEditing:YES];
    
    
}

#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

@end
