//
//  WLFriendsForgiveViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 17/3/14.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "WLFriendsForgiveViewController.h"
#import "WLFriendsAtrTableViewCell.h"
#import "FMRTTuijianModel.h"
#import "WLSearchViewController.h"
#define IMPUT_MAX 11

@interface WLFriendsForgiveViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIView *bjView;
@property(nonatomic,strong)UISearchBar *customSearchBar;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)FMRTTuijianModel *dataModel;
@property(nonatomic,assign)int currentPage;
@property(nonatomic,assign)BOOL isAddData;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)UILabel *timeTitileLabel;
@property(nonatomic,strong)NSString *startTime;
@property(nonatomic,strong)NSString *endTime;
@property(nonatomic,strong)UIImageView *backGroundImage;
@end

@implementation WLFriendsForgiveViewController

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
    
    [self settingNavTitle:@"好友贡献资产"];
    self.currentPage = 1;
    [self creatContentViews];
    [self.view addSubview:self.tableView];
    [self createHeaderView];
    [self loadMoreListData];
}

-(UIImageView *)backGroundImage
{
    if (!_backGroundImage) {
        _backGroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 50, KProjectScreenWidth, KProjectScreenWidth*822/486)];
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

/*
 shouji = 15006395533;
 tbjiner = "698.43";
 tbjinerwan = 1;
 "user_id" = 112;
 zhenshixingming = "\U5b8b\U6625\U73b2";
 */
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
        }
        
//        else{
//            ShowAutoHideMBProgressHUD(weakSelf.view, [response.responseObject objectForKey:@"msg"]);
//            [weakSelf.dataArr removeAllObjects];
//        }
        
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

- (FMRTTuijianModel *)dataModel{
    if (!_dataModel) {
        _dataModel = [[FMRTTuijianModel alloc]init];
    }
    return _dataModel;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:HUIApplicationFrame()];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = KDefaultOrBackgroundColor;
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



-(void)creatContentViews{
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightItemButton setBackgroundImage:[UIImage imageNamed:@"我的推荐_搜索icon_1702"]
                               forState:UIControlStateNormal];
    [rightItemButton setFrame:CGRectMake(0, 0, 25, 25)];
    [rightItemButton addTarget:self action:@selector(rightNavBtnClick) forControlEvents:UIControlEventTouchUpInside];
    rightItemButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

-(void)rightNavBtnClick{
    
    WLSearchViewController *vc = [[WLSearchViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"KeHuCell";
    
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
    
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
    
}



#pragma mark ----- 日期转换成时间戳
- (NSString *)timeStringToDateValue:(NSString *)timeStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *dateValue = [formatter dateFromString:timeStr];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)       [dateValue timeIntervalSince1970]];
    return timeSp;
}


@end
