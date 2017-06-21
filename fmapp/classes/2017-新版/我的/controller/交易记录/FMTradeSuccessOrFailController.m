//
//  FMTradeSuccessOrFailController.m
//  fmapp
//
//  Created by runzhiqiu on 16/6/16.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMTradeSuccessOrFailController.h"
#import "FMMakeABadResultStatus.h"
#import "XZSaveDetailM.h"
#import "MyClaimController.h"
#import "WLNewProjectDetailViewController.h"
#import "FMShowViewProductSuccess.h"
#import "FMPlaceOrderViewController.h"

@interface FMTradeSuccessOrFailController ()

@end

@implementation FMTradeSuccessOrFailController

-(void)setDetail:(XZSaveDetailM *)detail
{
    _detail = detail;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak __typeof(&*self)weakSelf = self;
    
    [self settingNavTitle:@"投标结果"];
    // 返回
    self.navBackButtonRespondBlock = ^() {
        [weakSelf didClickBackButton];
    };
    
    //    XZSaveDetailM * detail = [[XZSaveDetailM alloc]init];
    //    detail.msg = @"投标成功";//投标失败
    //    detail.jiaoyi = @"2015-12-08 12:34:32";
    //    detail.jiner = @"444元";
    //    detail.tijiao = @"满标后生成";
    //
    FMMakeABadResultStatus * result = [[FMMakeABadResultStatus alloc]initWithFrame:self.view.bounds];
    
    result.withButtonOnClickBlock = ^(NSInteger stasus){
        [weakSelf resultPushController:stasus];
    };
    result.saveM = self.detail;
    [self.view addSubview:result];
    
    
    if (self.detail.productId.length > 0) {
         __weak __typeof(&*self)weakSelf = self;
        FMShowViewProductSuccessModel * proModel = [[FMShowViewProductSuccessModel alloc]init];
        proModel.productId = self.detail.productId;
        proModel.imageUrl = self.detail.imageUrl;
        proModel.productDetail = self.detail.productDetail;

        [FMShowViewProductSuccess showFMMessageViewShow:proModel WithBolok:^(NSString *producrId) {
            [weakSelf goShopDetailController:producrId];
        }];
    }
    // Do any additional setup after loading the view.
}

-(void)goShopDetailController:(NSString *)productId
{
    FMPlaceOrderViewController * placeOrder = [[FMPlaceOrderViewController alloc]init];
    placeOrder.product_id = productId;
    placeOrder.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:placeOrder animated:YES];
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

-(void)resultPushController:(NSInteger)status
{
    if (status == 0) {
        //成功
        MyClaimController * claim = [[MyClaimController alloc]init];
        claim.isComeFromWeb = YES;
        claim.isTradeResult = YES;
        claim.isReturnMyInfo = YES;
        claim.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:claim animated:YES];
    }else
    {
        self.tabBarController.selectedIndex = 3;
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
