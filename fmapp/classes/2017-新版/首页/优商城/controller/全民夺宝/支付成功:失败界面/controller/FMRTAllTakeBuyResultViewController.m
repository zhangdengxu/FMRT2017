//
//  FMRTAllTakeBuyResultViewController.m
//  fmapp
//
//  Created by apple on 2016/10/26.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTAllTakeBuyResultViewController.h"
#import "FMRTAllTakeBuyFailureView.h"
#import "FMRTAllTakeBuySuccessView.h"

#import "FMRTAllTakeBuyResultModel.h"
#import "FMRTAllTakeFailureOfDB.h"
#import "FMRTAllTakeNewBuyViewController.h"
#import "AppDelegate.h"
#import "XZGetCoinsNewController.h"
#import "YYMyOrderNewController.h"
#import "WLAllklBodyViewController.h"
#import "FMShopDetailDuobaoViewController.h"
#import "FMDuobaoClass.h"
#import "XZShareView.h"
#import "XZActivityModel.h"
#import "ShareViewController.h"

@interface FMRTAllTakeBuyResultViewController ()

@property (nonatomic, strong)XZShareView *share;

@end

@implementation FMRTAllTakeBuyResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [HXColor colorWithHexString:@"#e5e9f2"];
    [self settingNavTitle:@""];
    [self createContentView];
}

- (void)createContentView{
    __weak typeof (self)weakSelf = self;

    switch (self.resultOfPay) {
        case TimeOutFailureOfPay:
        {
            FMRTAllTakeBuyResultModel *model = [[FMRTAllTakeBuyResultModel alloc]init];
            model.failureStatus = @"TimeOutFailureOfPay";
            FMRTAllTakeBuyFailureView *failureView = [[FMRTAllTakeBuyFailureView alloc]initWithFrame:CGRectMake(0, 10, KProjectScreenWidth, 200)];
            failureView.model = model;
            
            failureView.bottomBlcok = ^(){
                [weakSelf payForAnotherTime];
                
            };
            [self.view addSubview:failureView];
            break;
        }
        case ActivityEndedFailureOfPay:
        {
            FMRTAllTakeBuyResultModel *model = [[FMRTAllTakeBuyResultModel alloc]init];
            model.failureStatus = @"ActivityEndedFailureOfPay";
            FMRTAllTakeBuyFailureView *failureView = [[FMRTAllTakeBuyFailureView alloc]initWithFrame:CGRectMake(0, 10, KProjectScreenWidth, 200)];
            failureView.model = model;
            
            failureView.bottomBlcok = ^(){
                [weakSelf payForOtherProducts];
                
            };
            [self.view addSubview:failureView];
            break;
        }
        case SoldedZeroFailureOfPay:
        {
            FMRTAllTakeBuyResultModel *model = [[FMRTAllTakeBuyResultModel alloc]init];
            model.failureStatus = @"SoldedZeroFailureOfPay";
            FMRTAllTakeBuyFailureView *failureView = [[FMRTAllTakeBuyFailureView alloc]initWithFrame:CGRectMake(0, 10, KProjectScreenWidth, 200)];
            failureView.model = model;
            
            failureView.bottomBlcok = ^(){
                [weakSelf payWithOhterMathods];
                
            };
            [self.view addSubview:failureView];
            break;
        }
        case OldFiriendPriceFailureOfPay:
        {
            FMRTAllTakeBuyResultModel *model = [[FMRTAllTakeBuyResultModel alloc]init];
            model.failureStatus = @"OldFiriendPriceFailureOfPay";
            FMRTAllTakeBuyFailureView *failureView = [[FMRTAllTakeBuyFailureView alloc]initWithFrame:CGRectMake(0, 10, KProjectScreenWidth, 200)];
            failureView.model = model;
            
            failureView.bottomBlcok = ^(){
                [weakSelf payForAnotherTime];
                
            };
            [self.view addSubview:failureView];
            
            break;
        }
        case DuobaobiFailureOfPay:
        {
            FMRTAllTakeBuyResultModel *model = [[FMRTAllTakeBuyResultModel alloc]init];
            model.failureStatus = @"DuobaobiFailureOfPay";

            model.duobaoStatus = self.duobaoShop.selectModel.unit_cost;
            if ([model.duobaoStatus integerValue] == 5) {
                model.neededDB = @"5币";
            }else{
                model.neededDB = @"1币";
            }
            model.currentDB = [NSString stringWithFormat:@"%@币",self.duobaoShop.balance];
            FMRTAllTakeFailureOfDB *failureView = [[FMRTAllTakeFailureOfDB alloc]initWithFrame:CGRectMake(0, 10, KProjectScreenWidth, 250)];
            failureView.model = model;
            
            failureView.bottomBlcok = ^(){
                [weakSelf getTheIcoreRightNow];
                
            };
            [self.view addSubview:failureView];
            break;
        }
        case DuobaobiSuccessOfPay:
        {
            FMRTAllTakeBuyResultModel *model = [[FMRTAllTakeBuyResultModel alloc]init];
            model.successStatus = @"DuobaobiSuccessOfPay";
            model.productName = self.duobaoShop.goods_name;
            model.number = self.duobaoShop.lucky_code;
            model.duobaoStatus = self.duobaoShop.selectModel.unit_cost;
            
            if ([model.duobaoStatus integerValue] == 5) {
                model.money = @"5币";
            }else{
                model.money = @"1币";
            }
            
            FMRTAllTakeBuySuccessView *successView = [[FMRTAllTakeBuySuccessView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 280)];
            successView.model = model;
            
            successView.orderBlock = ^(){
                [weakSelf checkOrderForResult];
            };
            successView.mainBlock = ^(){
                [weakSelf backForMainFromResult];

            };
            successView.shareBlock = ^(){
                [weakSelf shareOrderForResult];

            };
            [self.view addSubview:successView];
            break;
        }
        case OldFiriendPriceSuccessOfPay:
        {
            FMRTAllTakeBuyResultModel *model = [[FMRTAllTakeBuyResultModel alloc]init];
            model.successStatus = @"OldFiriendPriceSuccessOfPay";
            model.productName = self.duobaoShop.goods_name;
            model.money = [NSString stringWithFormat:@"¥%@元",self.duobaoShop.selectModel.won_cost];
            FMRTAllTakeBuySuccessView *successView = [[FMRTAllTakeBuySuccessView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 235)];
            successView.model = model;
            successView.orderBlock = ^(){
                [weakSelf checkOrderForResult];
            };
            successView.mainBlock = ^(){
                [weakSelf backForMainFromResult];
                
            };
            successView.shareBlock = ^(){
                [weakSelf shareOrderForResult];
                
            };
            [self.view addSubview:successView];
            break;
        }

        default:
            break;
    }
    
}

- (XZShareView *)share{
    if (!_share) {
        _share = [[XZShareView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight)];
//        _share.modelShare = self.modelActivity;
        __weak __typeof(&*self.share)weakShare = self.share;
        __weak __typeof(&*self)weakSelf = self;

        _share.blockShareAction = ^(UIButton *button){
            [weakShare shareAction:button handlerDelegate:weakSelf];
        };
    }
    __weak __typeof(&*self)weakSelf = self;

    _share.blockShareSuccess = ^ { // 分享成功的回调
        int timestamp = [[NSDate date] timeIntervalSince1970];
        NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
        NSString *tokenlow=[token lowercaseString];
        // trench：幸运大抽奖渠道。share：分享 invite：邀请
        NSString *url = [NSString stringWithFormat:@"%@/slots/index.html?user_id=%@&token=%@&trench=share",kXZShareCallBackUrl,[CurrentUserInformation sharedCurrentUserInfo].userId,tokenlow];
        ShareViewController *shareVC = [[ShareViewController alloc]initWithTitle:@"幸运大抽奖" AndWithShareUrl:url];
        [weakSelf.navigationController pushViewController:shareVC animated:YES];
    };
    
    return _share;
}

#pragma mark -分享订单
- (void)shareOrderForResult{
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"flag":@"newon"
                                 };
    
    __weak __typeof(self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@/public/other/getShareInfo",kXZTestEnvironment];
    
    [FMHTTPClient postPath:url parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if (response.code==WebAPIResponseCodeSuccess) {
            if ([response.responseObject objectForKey:@"data"]) {
                NSDictionary *dic = [response.responseObject objectForKey:@"data"];
                XZActivityModel *modelShare  = [[XZActivityModel alloc]init];
                
                modelShare.sharetitle = [dic objectForKey:@"title"];
                NSString *url = [dic objectForKey:@"link"];
                modelShare.shareurl = [NSString stringWithFormat:@"%@?user_id=%@&appid=%@&shijian=%@&token=%@&flag=%@",url,[CurrentUserInformation sharedCurrentUserInfo].userId,@"huiyuan",[NSNumber numberWithInt:timestamp],tokenlow,@"9"];
                
                modelShare.sharepic = [dic objectForKey:@"img"];
                modelShare.sharecontent = [dic objectForKey:@"content"];
                weakSelf.share.modelShare = modelShare;
                
                [weakSelf.view addSubview:[weakSelf.share retViewWithSelf]];
            }
        }else{
            ShowAutoHideMBProgressHUD(weakSelf.view,@"请求分享数据失败！");
        }
    }];
}

#pragma mark -返回首页
- (void)backForMainFromResult{
    
    WLAllklBodyViewController *mainVC;
    for (UIViewController * viewControll in self.navigationController.viewControllers) {
        if ([viewControll isMemberOfClass:[WLAllklBodyViewController class]]) {
            mainVC = (WLAllklBodyViewController *)viewControll;
        }
    }
    if (mainVC) {
        [self.navigationController popToViewController:mainVC animated:YES];
    }
}
#pragma mark -查看订单
- (void)checkOrderForResult{
    YYMyOrderNewController *orderVC = [[YYMyOrderNewController alloc]init];
    [self.navigationController pushViewController:orderVC animated:YES];
}

#pragma mark -重新支付
- (void)payForAnotherTime{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -查看其它商品
- (void)payForOtherProducts{
    WLAllklBodyViewController *mainVC = [[WLAllklBodyViewController alloc]init];
    [self.navigationController pushViewController:mainVC animated:YES];
}

#pragma mark -其他方式获得
- (void)payWithOhterMathods{
    FMShopDetailDuobaoViewController *detailVC = [[FMShopDetailDuobaoViewController alloc]init];
    detailVC.won_id = self.duobaoShop.won_id;
    detailVC.product_id = self.duobaoShop.product_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark -立即获得
- (void)getTheIcoreRightNow{
    XZGetCoinsNewController *coinVC = [[XZGetCoinsNewController alloc]init];
    [self.navigationController pushViewController:coinVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
