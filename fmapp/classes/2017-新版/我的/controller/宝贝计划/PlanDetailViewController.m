//
//  PlanDetailViewController.m
//  fmapp
//
//  Created by runzhiqiu on 16/1/4.
//  Copyright © 2016年 yk. All rights reserved.
//
#define KDefaultBackGround [UIColor colorWithRed:(231.0/255) green:(234.0/255) blue:(239.0/255) alpha:1]
#define KDefaultViewHeight 620
#import "PlanDetailViewController.h"
#import "AddBabyPlanListViewController.h"
#import "BabyPlanConfirmViewController.h"
#import "BabyPlandetailView.h"
#import "BabyPlanModel.h"
@interface PlanDetailViewController ()<BabyPlandetailViewDelegate>
@property (nonatomic, strong) BabyPlanModel * babyPlan;

@end

@implementation PlanDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"计划详情"];
    self.view.backgroundColor = KDefaultBackGround;
    [self getDataSourceFromNetWork];
    // Do any additional setup after loading the view.
}
//https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/baobeijihuagrone?user_id=165&jilu_id=2664


-(void)getDataSourceFromNetWork
{
//    NSString * string = @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/baobeijihuagrone?appid=huiyuan&user_id=183&shijian=1451871687&token=18170aaf82201e602525c8cdab0ed193&jilu_id=2725";
//       __weak __typeof(&*self)weakSelf = self;
//    [FMHTTPClient getPath:string parameters:nil completion:^(WebAPIResponse *response) {
//        
//        NSDictionary * allDictionary = (NSDictionary *)response.responseObject;
//        NSNumber * status = allDictionary[@"status"];
//        if ([status integerValue] == 0) {
//            if (allDictionary[@"data"]) {
//                self.babyPlan = [BabyPlanModel babyPlayModelCreateWithDictionary:allDictionary[@"data"]];
//                [self createVontentView];
//            }else
//            {
//                ShowAutoHideMBProgressHUD(weakSelf.view,@"无数据");
//            }
//        }
//        else
//        {
//            ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
//        }
//    }];

    NSDictionary * dictParame = @{@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,@"jilu_id":self.jilu_id};
    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient getPath:[NSString stringWithFormat:@"%@linshi",babyPlanDetailURL] parameters:dictParame completion:^(WebAPIResponse *response) {
        
        NSDictionary * allDictionary = (NSDictionary *)response.responseObject;
        NSNumber * status = allDictionary[@"status"];
        if ([status integerValue] == 0) {
            if (allDictionary[@"data"]) {
                self.babyPlan = [BabyPlanModel babyPlayModelCreateWithDictionary:allDictionary[@"data"]];
                [self createVontentView];
            }else
            {
                ShowAutoHideMBProgressHUD(weakSelf.view,@"无数据");
            }

        }
        else
        {
            ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
        }
        
        
    }];
}

-(void)createVontentView
{
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scrollView.backgroundColor = KDefaultBackGround;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, KDefaultViewHeight);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    
    BabyPlandetailView  * babyPlanView = [[BabyPlandetailView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, KDefaultViewHeight)];
    babyPlanView.delegate = self;
    babyPlanView.babyPlan = self.babyPlan;
    [scrollView addSubview:babyPlanView];
}
-(void)BabyPlandetailView:(BabyPlandetailView *) babyPlanView WithJieid:(BabyPlanModel *)planModel;
{
    AddBabyPlanListViewController * viewController = [[AddBabyPlanListViewController alloc]init];
    viewController.babyPlan = planModel;
    viewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:viewController animated:YES];
}
-(void)BabyPlandetailView:(BabyPlandetailView *)babyPlanView WithAddBabyPlan:(BabyPlanModel *)planModel
{
    BabyPlanConfirmViewController * viewController = [[BabyPlanConfirmViewController alloc]init];
    viewController.babyPlan = planModel;
    viewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:viewController animated:YES];
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
