//
//  BabyPlanDetailViewController.m
//  fmapp
//
//  Created by runzhiqiu on 16/1/4.
//  Copyright © 2016年 yk. All rights reserved.
//
#define KDefaultBackGround [UIColor colorWithRed:(231.0/255) green:(234.0/255) blue:(239.0/255) alpha:1]
#define KDefaultTextColor [UIColor colorWithRed:(170.0/255) green:(170.0/255) blue:(170.0/255) alpha:1]
#define KTableViewRegisterBabyPlayDetailTableViewCell @"BabyPlayDetailTableViewCell"
#define kNavTitleImageViewTag   10009
#import "BabyPlanDetailViewController.h"
#import "BabyPlayDetailTableViewCell.h"
#import "BabyPlanDetailModel.h"

#import "PlanDetailViewController.h"
#import "BabyPlanController.h"
#import "FMNavigateMenu.h"
#import "FontAwesome.h"
#import "FMRTBabyAddJIARUJINEViewController.h"



@interface BabyPlanDetailViewController ()<FMNavigateMenuDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, weak) UIView * backgroundView;
@property (nonatomic, weak) UIView * reloadStateView;
//@property (nonatomic, weak) UIActivityIndicatorView *indicator;
@property (nonatomic, weak) UILabel * showReloadView;


@property (nonatomic,weak)UIButton *navTitleButton;        //问题类型按钮
@property (nonatomic, strong) NSMutableArray * titleMutable;

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) BabyPlayDetailTableViewCell  * currentSelectCell;


@property (nonatomic, assign) BOOL isRefresh;
@end

@implementation BabyPlanDetailViewController

-(NSMutableArray *)titleMutable
{
    if (!_titleMutable) {
        _titleMutable = [NSMutableArray array];
    }
    return _titleMutable;
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isRefresh = NO;
//    [self settingNavTitle:@"宝贝计划"];
    [self getTitleButtonWithNavigation];
    [self createNavigationBarStyle];
    self.view.backgroundColor = KDefaultBackGround;
//    [self reloadStateViewOnBackView];
    
    [self loadBabyPlanDataWithHTTPClient];
    // Do any additional setup after loading the view.
}
-(void)getTitleButtonWithNavigation
{
    NSString * getTitle = @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/bbjhshaixuanxiang";
//
    
    [FMHTTPClient postPath:getTitle parameters:nil completion:^(WebAPIResponse *response) {
        if (response.code == WebAPIResponseCodeSuccess) {
            NSArray * data = response.responseObject[@"data"];
            if (data&&![data isMemberOfClass:[NSNull class]]) {
                [self.titleMutable removeAllObjects];
                for (NSDictionary * dict in data) {
                    BabyPlanTitleModel * titleModel = [[BabyPlanTitleModel alloc]init];
                    [titleModel setValuesForKeysWithDictionary:dict];
                    [self.titleMutable addObject:titleModel];
                }
                if (self.titleMutable.count > 0) {
                    [self createNavigationBarStyle];
                }
                
            }
           
        }
    }];
}

-(void)createNavigationBarStyle;
{
    //设置导航栏
    UIButton *navTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    navTitleButton.frame = CGRectMake(0, 2, 140, 40);
    navTitleButton.center = CGPointMake(KProjectScreenWidth * 0.5,  22);
    [navTitleButton setBackgroundImage:createImageWithColor([UIColor clearColor]) forState:UIControlStateNormal];
    // [[ThemeManager sharedThemeManager].skin baseTintColor]
    [navTitleButton setBackgroundImage:createImageWithColor([UIColor whiteColor])
                              forState:UIControlStateHighlighted];
    [navTitleButton addTarget:self action:@selector(navTitleClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    ////设置标题
    [navTitleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [navTitleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [navTitleButton setTitle:@"宝贝计划" forState:UIControlStateNormal];
    navTitleButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    
    
    ////下拉箭头
    UIImageView *titleIndicatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(110, 13,16,16)];
    titleIndicatorImageView.tag = kNavTitleImageViewTag;
    [titleIndicatorImageView setImage:[FontAwesome imageWithIcon:FMIconPullDown
                                                       iconColor:[UIColor blackColor]
                                                        iconSize:16.0]];
    [navTitleButton addSubview:titleIndicatorImageView];
    self.navigationItem.titleView = navTitleButton;
    self.navTitleButton = navTitleButton;
}



-(void)navTitleClicked:(UIButton *)sender
{
    UIButton *titleButton = (UIButton *)sender;
    //旋转箭头
    UIImageView *arrowImageView = (UIImageView *)[titleButton viewWithTag:kNavTitleImageViewTag];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
    arrowImageView.transform = transform;
    [UIView commitAnimations];
    
    //弹出菜单
    FMNavigateMenu* menu = [[FMNavigateMenu alloc] initWithNav:self.navigationController];
    
    for (BabyPlanTitleModel * titleModel in self.titleMutable) {
        [menu addMenuItem:titleModel.title];
    }

    menu.delegate = self;
    [menu showMenu:CGPointMake(0, 0) curIndex:self.currentIndex];
}
#pragma mark-- FMNavigateMenuDelegate
- (void)didItemSelected:(NSInteger)index;
{
        //旋转箭头
        UIImageView *arrowImageView = (UIImageView *)[self.navTitleButton viewWithTag:kNavTitleImageViewTag];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        CGAffineTransform transform = CGAffineTransformMakeRotation(0);
        arrowImageView.transform = transform;
        [UIView commitAnimations];
        
        if(index < 0)
            return;
    
        if (index < (self.titleMutable.count)) {
             BabyPlanTitleModel * titleModel = self.titleMutable[index];
            [self.navTitleButton setTitle:titleModel.title forState:UIControlStateNormal];
            self.currentIndex = index;
        }
       
        self.isRefresh = YES;
        [self loadBabyPlanDataWithHTTPClient];
    

}

//-(void)reloadStateViewOnBackView
//{
//    NSString * string = @"正在加载，请稍后";
//    CGSize stringSize = [string getStringCGSizeWithMaxSize:CGSizeMake(MAXFLOAT, 30) WithFont:[UIFont systemFontOfSize:14]];
//    UILabel * showReloadView = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, stringSize.width, stringSize.height)];
//    showReloadView.textAlignment = NSTextAlignmentCenter;
//    showReloadView.textColor = KDefaultTextColor;
//    showReloadView.font = [UIFont systemFontOfSize:14];
//    showReloadView.text = string;
//    self.showReloadView = showReloadView;
//    [self.view addSubview:showReloadView];
//    showReloadView.center = CGPointMake(self.view.bounds.size.width * 0.5 + 15, 100 + stringSize.height * 0.5);
//    
//    
//    //初始化:
//    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(showReloadView.frame.origin.x - 30, 95, 30, 30)];
//    self.indicator = indicator;
//    //设置显示样式,见UIActivityIndicatorViewStyle的定义
//    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//    //设置背景色
//    indicator.backgroundColor = KDefaultBackGround;
//    //设置显示位置
////    [indicator setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
//    //开始显示Loading动画
//    [indicator startAnimating];
//    
//    [self.view addSubview:indicator];
////
//    
//    [self loadBabyPlanDataWithHTTPClient];
//}


-(void)createFirstLoadThisView
{
    UIView * backgroundView = [[UIView alloc]initWithFrame:self.view.bounds];
    backgroundView.backgroundColor = KDefaultBackGround;
    [self.view addSubview:backgroundView];
    self.backgroundView = backgroundView;
    
    
    UILabel * detalLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 150, self.view.bounds.size.width, 30)];
    detalLabel.textAlignment = NSTextAlignmentCenter;
    detalLabel.textColor = KDefaultTextColor;
    detalLabel.font = [UIFont systemFontOfSize:30];
    detalLabel.text = @"暂无记录";
    [backgroundView addSubview:detalLabel];
    
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:@"BabyPlayDetailTableViewCell" bundle:nil] forCellReuseIdentifier:KTableViewRegisterBabyPlayDetailTableViewCell];
        
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.backgroundColor = KDefaultBackGround;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.isRefresh = YES;
            [self loadBabyPlanDataWithHTTPClient];
        }];
        
       
        [self.view addSubview:_tableView];
    }
    return _tableView;
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
    BabyPlayDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:KTableViewRegisterBabyPlayDetailTableViewCell forIndexPath:indexPath];
    cell.plandetail = self.dataSource[indexPath.row];
     __weak __typeof(&*self)weakSelf = self;
    cell.buttonBlock = ^(BabyPlayDetailTableViewCell * cell){
        weakSelf.currentSelectCell = cell;
        [weakSelf showMessage];
    };
    cell.xiugaiBlcok = ^(){
        [weakSelf xiugaiJumpWith:self.dataSource[indexPath.row]];
    };
    return  cell;
}

- (void)xiugaiJumpWith:(BabyPlanDetailModel *)model{
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"autot_id":model.autot_id,
                                 @"jie_id":model.jie_id};
    
    __weak __typeof(self)weakSelf = self;
//    NSLog(@"%@+++",parameter);

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:@"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/bbjhupinfoact" parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
//        NSLog(@"%@===",response.responseObject);
        
        if (response.code==WebAPIResponseCodeSuccess) {
            NSDictionary  *dic = [response.responseObject objectForKey:@"data"];
            FMRTBabyAddJIARUJINEViewController *VC = [[FMRTBabyAddJIARUJINEViewController alloc]init];
            model.tishineirong = [dic objectForKey:@"tishineirong"];
            
            VC.model = model;
            VC.popBlock = ^(){
                [self.dataSource removeAllObjects];

                [weakSelf loadBabyPlanDataWithHTTPClient];
                
            };
            [weakSelf.navigationController pushViewController:VC animated:YES];

        }else{
            ShowAutoHideMBProgressHUD(weakSelf.view, [response.responseObject objectForKey:@"msg"]);
        }
    }];
}

-(void)showMessage
{
    UIAlertView * alertShow = [[UIAlertView alloc]initWithTitle:nil message:@"点击终止，本期宝贝计划到期后，本金及期间产生的利息全部返还至您的可用余额，不在续投。终止后不可撤销，请确认是否终止？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alertShow show];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlanDetailViewController * viewComtroller = [[PlanDetailViewController alloc]init];
    BabyPlanDetailModel * babyPlan = self.dataSource[indexPath.row];
    viewComtroller.jilu_id = babyPlan.jilu_id;
    viewComtroller.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:viewComtroller animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/** 宝贝计划--详细列表 */
-(void)loadBabyPlanDataWithHTTPClient
{
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString *url;
    if (self.titleMutable.count > 0) {
        
        BabyPlanTitleModel * titleModel = self.titleMutable[self.currentIndex];
         url=[NSString stringWithFormat:@"%@linshi?user_id=%@&appid=huiyuan&shijian=%d&token=%@&type_id=%@",babyPlanDetailListURL,[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow,titleModel.type_id];
    }else
    {
         url=[NSString stringWithFormat:@"%@linshi?user_id=%@&appid=huiyuan&shijian=%d&token=%@",babyPlanDetailListURL,[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow];
    }
    
    [self.backgroundView removeFromSuperview];

    __weak __typeof(&*self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient getPath:url parameters:nil completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.tableView.mj_header endRefreshing];
        NSDictionary * allDictionary = (NSDictionary *)response.responseObject;
        NSNumber * status = allDictionary[@"status"];

        if ([status integerValue] == 1) {
            if (self.isRefresh) {
                self.isRefresh = NO;
                [self.dataSource removeAllObjects];
            }
            
            
            NSArray * array = allDictionary[@"data"];
            for (NSDictionary * dict in array) {
                BabyPlanDetailModel * babyPlan = [BabyPlanDetailModel babyPlayDetailModelCreateWithDictionary:dict];
                [self.dataSource addObject:babyPlan];
            }
            if (self.dataSource.count > 0) {
                
                [self.tableView reloadData];
                
            }else
            {
                [self createFirstLoadThisView];
            }
            
            [self.showReloadView removeFromSuperview];
//            [self.indicator stopAnimating];
//            [self.indicator removeFromSuperview];
//
        }
        else if([status integerValue] == 2)
        {
            [self createFirstLoadThisView];
            [self.showReloadView removeFromSuperview];
//            [self.indicator stopAnimating];
//            [self.indicator removeFromSuperview];
            
            
            
        }else
        {
            ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
            [self.showReloadView removeFromSuperview];
//            [self.indicator stopAnimating];
//            [self.indicator removeFromSuperview];
            
        }

        
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 0) {
        
        
    }else
    {
         [self textEndBabyPlan];
    }
}

/**
 *  宝贝计划终止
 */
-(void)textEndBabyPlan
{
    if (self.currentSelectCell) {
        int timestamp = [[NSDate date]timeIntervalSince1970];
        NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
        NSString *tokenlow=[token lowercaseString];
        
        NSString *url=[NSString stringWithFormat:@"%@?user_id=%@&appid=huiyuan&shijian=%d&token=%@&jie_id=%@",@"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/bbjhendact",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow,self.currentSelectCell.plandetail.jie_id];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        [FMHTTPClient getPath:url parameters:nil completion:^(WebAPIResponse *response) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            if (response.code == WebAPIResponseCodeSuccess) {
                ShowAutoHideMBProgressHUD(self.view, @"终止成功");
                //
                [self loadBabyPlanDataWithHTTPClient];
                
            }else
            {
                ShowAutoHideMBProgressHUD(self.view, response.responseObject[@"msg"]);
            }
        }];

    }
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
