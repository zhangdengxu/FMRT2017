//
//  MyClaimController.m
//  fmapp
//
//  Created by apple on 15/3/21.
//  Copyright (c) 2015年 yk. All rights reserved.
//



#import "DataPage.h"
#import "MyClaimController.h"
#import "MXPullDownMenu.h"
#import "FontAwesome.h"
#import "HTTPClient+Interaction.h"
#import "ProjectCell.h"
#import "ProjectModel.h"
//#import "ProjectDetailController.h"
#import "WLNewProjectDetailViewController.h" // 项目信息
#import "ClaimViewCell.h"
#import "ShareViewController.h"
#import "SVPullToRefresh.h"
@interface MyClaimController ()<MXPullDownMenuDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak)UIButton                      *navTitleButton;        //问题类型按钮
@property (readwrite, strong) DataPage                  *dataSource;            //列表的数据源
@property (nonatomic,weak)    HUILoadMoreCell           *loadMoreCell;
@property (nonatomic, weak)   UITableView                 *tableView;
@property (nonatomic,assign)  BOOL                        loadMore;

@property (nonatomic,assign)  NSInteger                   projectInt;
@property (nonatomic,assign)  NSInteger                   touZiInt;
@property (nonatomic,assign)  NSInteger                   zhanRangInt;

@property (nonatomic, strong)  NSArray *testArray;

@end

@implementation MyClaimController
-(NSArray *)testArray
{
    if (!_testArray) {
        _testArray =@[ @[@"全部", @"融担保",@"融抵押",@"融保理",@"经营贷"], @[@"全部", @"直投", @"债权"],@[@"全部",@"已到期",@"未到期"]];
    }
    return _testArray;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataSource = [DataPage page];
        self.projectInt=0;
        self.touZiInt=0;
        self.zhanRangInt=0;
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
    [self settingNavTitle:@"我的债权"];
    
    if (self.isTradeResult) {
        __weak __typeof(&*self)weakSelf = self;
        if (self.isReturnMyInfo) {
            //返回新版我的
            self.navBackButtonRespondBlock = ^() {
                [weakSelf didClickBackButtonToMyInfo];
            };
        }else
        {
            // 返回(老版)
            self.navBackButtonRespondBlock = ^() {
                [weakSelf didClickBackButton];
            };
        }
        
        
    }

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
//    [self.tableView triggerPullToRefresh];

    [self createTopBtnView];
}
-(void)didClickBackButtonToMyInfo
{
    self.tabBarController.selectedIndex = 3;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)didClickBackButton
{
    
    WLNewProjectDetailViewController * interaction;
    for (UIViewController * viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[WLNewProjectDetailViewController class]]) {
            interaction = (WLNewProjectDetailViewController *)viewController;
            break;
        }
    }
    
    if (interaction) {
        [self.navigationController popToViewController:interaction animated:YES];
    }else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    
}

- (void)createTopBtnView
{
   
    
    MXPullDownMenu *menu = [[MXPullDownMenu alloc] initWithArray:self.testArray selectedColor:[UIColor colorWithRed:0.18 green:0.56 blue:0.89 alpha:1] WithArray:[NSArray arrayWithObjects:@"项目类型",@"投资类型",@"项目状态", nil]];
    menu.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    menu.delegate = self;
    menu.frame = CGRectMake(0, 0, menu.frame.size.width, menu.frame.size.height);
    [self.view addSubview:menu];
    if (self.isComeFromWeb > 0) {
        
         [self.tableView triggerPullToRefresh];
        
    }else
    {
        [menu didSelectThisItem:2 WithColumn:2];
    }
   

    
}
- (void)PullDownMenu:(MXPullDownMenu *)pullDownMenu didSelectRowAtColumn:(NSInteger)column row:(NSInteger)row
{
    
    if (column==0) {
        self.projectInt=row;
    }
    else if (column==1)
    {
        self.touZiInt=row;
    }
    else if (column==2)
    {
        self.zhanRangInt=row;
        NSArray * array = self.testArray[column];
        pullDownMenu.lastCaTextLayer.string = array[row];
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
    
    Log(@"当前为第%zi页",[self.dataSource nextPageIndex]);
    
    [FMHTTPClient getClaimAreaUserId:[CurrentUserInformation sharedCurrentUserInfo].userId withProject:self.projectInt withTouzi:self.touZiInt withZhuanrang:self.zhanRangInt WithjiezhuangTai: [self jiezhuangtaiReturnToNetWork:self.zhanRangInt] pageIndex:[self.dataSource nextPageIndex] pageSize:[self.dataSource pageSize] completion:^(WebAPIResponse *response) {
        
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
                        ProjectModel *question = [ProjectModel modelMyClaimDetailWithUnserializedJSONDic:dic];
//                        NSLog(@"question.zhuangtai:%@",question);
//                        NSLog(@"question.zhuangtai:%@",question.zhuangtai);
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
//                NSLog(@"%@",weakSelf.dataSource);
                [weakSelf.tableView reloadData];
                
            }
            else
            {
                
                if (self.loadMoreCell) {
                    [self.loadMoreCell stopLoadingAnimation];
                    self.loadMoreCell.textLabel.text = LOADMORE_LOADOVER;
                }
            }
            
        });
        
    }];
}

-(NSInteger)jiezhuangtaiReturnToNetWork:(NSInteger)currentInteger
{
    NSInteger retNumber = 0;
    switch (currentInteger) {
        case 0:
            
            break;
        case 1:
            retNumber = 8;
            break;
        case 2:
            retNumber = 6;
            break;
        default:
            break;
    }
    return retNumber;
}

-(void)addQuestionList:(NSMutableArray *)questionList  withProject:(NSInteger)projectType
             withTouzi:(NSInteger)TouziType
         withZhuanrang:(NSInteger)zhanrangTypeWithZhuanrang With:(ProjectModel *)question
{
    switch (zhanrangTypeWithZhuanrang) {
        case 0:
            [questionList addObject:question];
            break;
        case 1:
            if ([question.zhuangtai isEqualToString:@"8"]) {
                [questionList addObject:question];
            }
            break;
        case 2:
            if ([question.zhuangtai isEqualToString:@"6"]) {
                [questionList addObject:question];
            }
            break;
        default:
            break;
    }
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
    ClaimViewCell* cell = [[ClaimViewCell alloc] init];
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
    
    ProjectModel *model=(ProjectModel *)[self.dataSource.data objectAtIndex:indexPath.row];
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&timestamp=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];

    ShareViewController *viewController=[[ShareViewController alloc]initWithTitle:@"债权详情" AndWithShareUrl:[NSString stringWithFormat:@"%@%@?user_id=%@&jie_id=%@&appid=jiekuan&shijian=%d&jilu_id=%@&token=%@",@"http://p2p.rongtuojinrong.com/Rongtuoxinsoc/",@"Usercenter/zhaiquanxq",[CurrentUserInformation sharedCurrentUserInfo].userId,model.projectId,timestamp,model.jilu_id,tokenlow]];
    [self.navigationController pushViewController:viewController animated:YES];

}
- (void)_configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [self.dataSource.data count]) {
        return;
    }
    
    ProjectModel *question = [self.dataSource.data objectAtIndex:(indexPath.row)];

    ClaimViewCell* questionCell = (ClaimViewCell* )cell;
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
        
        return 130+10;
    }
    return 40.0;
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
