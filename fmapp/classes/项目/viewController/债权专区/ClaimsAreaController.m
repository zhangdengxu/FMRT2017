//
//  ClaimsAreaController.m
//  fmapp
//
//  Created by apple on 15/3/21.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "ClaimsAreaController.h"
#import "FMNavigateMenu.h"
#import "FontAwesome.h"
#import "HTTPClient+Interaction.h"
#import "ProjectCell.h"
#import "ProjectModel.h"
#import "WLNewProjectDetailViewController.h"
#import "MXPullDownMenu.h"
#import "ClaimViewController.h"
#import "DataPage.h"
#import "SVPullToRefresh.h"
@interface ClaimsAreaController ()<UITableViewDataSource, UITableViewDelegate,MXPullDownMenuDelegate>

@property (nonatomic,weak)UIButton                      *navTitleButton;        //问题类型按钮
@property (readwrite, strong) DataPage                  *dataSource;            //列表的数据源
@property (nonatomic,weak)    HUILoadMoreCell           *loadMoreCell;
@property (nonatomic, weak)   UITableView                 *tableView;
@property (nonatomic,assign)  BOOL                        loadMore;

@property (nonatomic,assign)  NSInteger                   moneyInt;
@property (nonatomic,assign)  NSInteger                   endDateInt;
@property (nonatomic,assign)  NSInteger                   styleInt;
@property (nonatomic,assign)  NSInteger                   titleInt;

@end

@implementation ClaimsAreaController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.dataSource = [DataPage page];
        self.moneyInt=0;
        self.endDateInt=0;
        self.styleInt=0;
        self.titleInt=0;
    }
    return self;
    
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:HUIApplicationFrame()];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = KProjectBackGroundViewColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self settingNavTitle:@"债权专区"];
    UITableView* tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 36, KProjectScreenWidth, KProjectScreenHeight-36) style:UITableViewStylePlain];
    tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tbView.backgroundColor = [UIColor clearColor];
    tbView.dataSource = self;
    tbView.delegate = self;
    [self.view addSubview:tbView];
    self.tableView = tbView;
    
    __weak __typeof(&*self)weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^(void){
        [weakSelf refreshListData];
    }];
    ConfiguratePullToRefreshViewAppearanceForScrollView(self.tableView);
    [self.tableView triggerPullToRefresh];

    
    [self createTopBtnView];
}
- (void)createTopBtnView
{
    NSArray *testArray;
    testArray = @[ @[@"全部", @"1万以下",@"1-3万",@"3-5万",@"5万以上"], @[@"全部",@"3个月以下",@"3~6个月",@"6~12个月",@"12个月以上"], @[@"全部", @"10%以下", @"10%-15%", @"15%以上"],@[@"全部",@"融担保",@"融抵押"]];
    
    
    MXPullDownMenu *menu = [[MXPullDownMenu alloc] initWithArray:testArray selectedColor:[UIColor colorWithRed:0.18 green:0.56 blue:0.89 alpha:1] WithArray:[NSArray arrayWithObjects:@"转让份额",@"剩余期限",@"认购收益",@"项目类型", nil]];
    menu.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    menu.delegate = self;
    menu.frame = CGRectMake(0, 0, menu.frame.size.width, menu.frame.size.height);
    [self.view addSubview:menu];

}
- (void)PullDownMenu:(MXPullDownMenu *)pullDownMenu didSelectRowAtColumn:(NSInteger)column row:(NSInteger)row
{
//    Log(@"%ld -- %ld", column, row);
    
    if (column==0) {
        self.moneyInt=row;
    }
    else if (column==1)
    {
        self.endDateInt=row;
    }
    else if (column==2)
    {
        self.styleInt=row;
    }
    else if (column==3)
    {
        self.titleInt=row;
    }
    
    [self.tableView triggerPullToRefresh];

}

- (void)refreshListData
{
    
    self.loadMore=YES;
    //停掉当前未完成的请求操作
       
    //清空当前数据源中所有数据
    [self.dataSource cleanAllData];
    [self.tableView reloadData];
    [self loadMoreListData];
}
- (void)loadMoreListData
{
    
    __weak __typeof(&*self)weakSelf = self;
    
    [FMHTTPClient getClaimAreaMoney:self.moneyInt withEndDate:self.endDateInt withStyle:self.styleInt withTitle:self.titleInt pageIndex:[self.dataSource nextPageIndex] pageSize:[self.dataSource pageSize] completion:^(WebAPIResponse *response) {
        
        Log(@"%@",response.responseObject);
        if (weakSelf.tableView.pullToRefreshView.state == SVPullToRefreshStateLoading)
        {
            UpdateLastRefreshDataForPullToRefreshViewOnView([weakSelf tableView]);
            [weakSelf.tableView.pullToRefreshView stopAnimating];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (response.code==WebAPIResponseCodeSuccess) {
                
                NSMutableArray *questionList = [NSMutableArray array];
                NSArray* dataList = [response.responseObject objectForKey:kDataKeyData];
                if ([dataList isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dic in dataList)
                    {
                        ProjectModel *question = [ProjectModel modelWithUnserializedJSONDic:dic];
                        if (question) {
                            
                            [questionList addObject:question];
                            
                        }
                    }
                }
                //避免服务器返回数据异常导致loadmore循环加载
                if ([questionList count] == 0) {
                    
                    self.loadMore=NO;
                }
                [weakSelf.dataSource appendPage:questionList];
                [weakSelf.tableView reloadData];
                
                
            }
            else
            {
//                ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
                
                if (self.loadMoreCell) {
                    [self.loadMoreCell stopLoadingAnimation];
                    self.loadMoreCell.textLabel.text = LOADMORE_LOADOVER;
                }
                
            }
            
        });
        
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count] + 1; //添加一行显示“正在加载”或“加载完毕”;
}
- (UITableViewCell *)createCellWithIdentifier:(NSString *)cellIdentifier
{
    if ([cellIdentifier isEqualToString:kHUILoadMoreCellIdentifier])
    {
        return CreateLoadMoreCell();
        
    }
    ProjectCell* cell = [[ProjectCell alloc] init];
    return cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"QuestionCell";
    BOOL isLoadMoreCell = [self _isLoadMoreCellAtIndexPath:indexPath];
    cellIdentifier = isLoadMoreCell? kHUILoadMoreCellIdentifier: cellIdentifier;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [self createCellWithIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (!isLoadMoreCell)
        [self _configureCell:cell forRowAtIndexPath:indexPath];
    else
    {
        self.loadMoreCell = (HUILoadMoreCell*)cell;
        if (self.loadMore&&[self.dataSource count])
        {
            
            __weak __typeof(&*self)weakSelf = self;
            [(HUILoadMoreCell*)cell setLoadMoreOperationDidStartedBlock:^{
                [weakSelf loadMoreListData];
            }];
            [(HUILoadMoreCell*)cell startLoadMore];
        }
        else
        {
            
            if (self.tableView.pullToRefreshView.state == SVPullToRefreshStateLoading) {
                cell.textLabel.text = LOADMORE_LOADING;
            }else{
                cell.textLabel.text = LOADMORE_LOADOVER;
            }
        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self _isLoadMoreCellAtIndexPath:indexPath])
        return;
    
    ProjectModel *model=[self.dataSource.data objectAtIndex:(indexPath.row)];
    ClaimViewController *viewController=[[ClaimViewController alloc]initWithProjectId:model.projectId];
    viewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:viewController animated:YES];
}
- (void)_configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [self.dataSource.data count]) {
        return;
    }
    
    ProjectModel *question = [self.dataSource.data objectAtIndex:(indexPath.row)];
    ProjectCell* questionCell = (ProjectCell* )cell;
    [questionCell disClaimsArea:question];
    
}

#pragma mark - UITableViewDelegate
- (BOOL)_isLoadMoreCellAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row == [self.dataSource count]);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self _isLoadMoreCellAtIndexPath:indexPath])
        return kSizeLoadMoreCellHeight;
    if (indexPath.row < [self.dataSource.data count]) {
        
        return 130+50-5;
    }
    return 40.0;
}


@end
