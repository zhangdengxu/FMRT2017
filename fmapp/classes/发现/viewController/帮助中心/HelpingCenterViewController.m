//
//  HelpingCenterViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 15/12/25.
//  Copyright © 2015年 yk. All rights reserved.
//

#import "HelpingCenterViewController.h"
#import "ShareViewController.h"
//#import "LoginAndRegisterViewController.h"
#import "WLFirstPageHeaderViewController.h" // 跳转新手指引

@interface HelpingCenterViewController ()<UIScrollViewDelegate>
{
    
    UIScrollView *mainScrollView;
}
@property (nonatomic,weak) UIActivityIndicatorView*  indicatorView;

@end

@implementation HelpingCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self settingNavTitle:@"帮助中心"];
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0f green:235/255.f blue:240/255.0f alpha:1];
    [self creatHeaderImageView];
}


-(void)creatHeaderImageView{
    mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    mainScrollView.delegate = self;
    mainScrollView.backgroundColor = [UIColor clearColor];
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 700);
    
    [self.view addSubview:mainScrollView];
    //
    UIImageView *headerImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenWidth*276/750)];
    headerImageV.backgroundColor = [UIColor clearColor];
    [headerImageV setImage:[UIImage imageNamed:@"帮助中心_帮助中心1_1702"]];
    headerImageV.userInteractionEnabled = YES;
    [mainScrollView addSubview:headerImageV];
    
    UIButton *btnNewGuide = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerImageV addSubview:btnNewGuide];
    [btnNewGuide mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(headerImageV);
    }];
    [btnNewGuide addTarget:self action:@selector(didClickNewGuideButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self creatButtonList];
}

-(void)creatButtonList{
    NSArray *imgArr = [[NSArray alloc]initWithObjects:@"帮助中心_注册登录篇_36",@"帮助中心_充值篇_36",@"帮助中心_投资篇_36",@"帮助中心_资产篇_36",@"帮助中心_提现篇_36", nil];
    NSArray *titleArr = [[NSArray alloc]initWithObjects:@"注册登录篇",@"充值篇",@"投资篇",@"资产篇",@"提现篇", nil];
    
    for (int i = 0; i<5; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTag:(1000+i)];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button addTarget:self action:@selector(helpingClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setFrame:CGRectMake(0, KProjectScreenWidth*276/750 + 50*i, KProjectScreenWidth, 49)];
        [mainScrollView addSubview:button];
        
        UIImageView *iconImgV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12, 25, 25)];
        [iconImgV setImage:[UIImage imageNamed:imgArr[i]]];
        [button addSubview:iconImgV];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(45, 0, 200, 49)];
        label.backgroundColor=[UIColor clearColor];
        label.text = titleArr[i];
        label.textColor=[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:.8];
        label.font=[UIFont systemFontOfSize:18.0f];
        [button addSubview:label];
        UIImageView *arrowImage=[[UIImageView alloc]initWithFrame:CGRectMake(KProjectScreenWidth-25, 19, 7, 11)];
        arrowImage.image=[UIImage imageNamed:@"More_CellArrow.png"];
        [button addSubview:arrowImage];
    }

}

// 点击头部的新手指引
- (void)didClickNewGuideButton {
    WLFirstPageHeaderViewController *shareVC = [[WLFirstPageHeaderViewController alloc]init];
    
    NSString *useId = [CurrentUserInformation sharedCurrentUserInfo].userId ? [CurrentUserInformation sharedCurrentUserInfo].userId : @"0";
//    if ([CurrentUserInformation sharedCurrentUserInfo].userId) {
          shareVC.shareURL = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/rongtuoxinsoc/Gengdfwu/xinshouzhiyin?laiyuan=1&user_id=%@",useId];
//    }else
//    {
//        shareVC.shareURL = @"https://www.rongtuojinrong.com/rongtuoxinsoc/Gengdfwu/xinshouzhiyin?laiyuan=1&user_id=0" ;
//    }
  
    shareVC.navTitle = @"新手指引";
    shareVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shareVC animated:YES];
}

-(void)helpingClick:(UIButton *)button{
   
    NSString *useId = [CurrentUserInformation sharedCurrentUserInfo].userId ? [CurrentUserInformation sharedCurrentUserInfo].userId : @"0";
    
    if (button.tag == 1000) {
        
//        NSString *url;
//        if ([CurrentUserInformation sharedCurrentUserInfo].userId) {
        NSString *url = [NSString stringWithFormat:@"%@?user_id=%@",RegisterLoginURL,useId];
//        }else
//        {
//            url = [NSString stringWithFormat:@"%@?user_id=0",RegisterLoginURL];
//        }
        
        ShareViewController *viewController=[[ShareViewController alloc]initWithTitle:@"注册登录篇" AndWithShareUrl:url];
        viewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:viewController animated:YES];

    }else if (button.tag == 1001){
//        NSString *url;

//        if ([CurrentUserInformation sharedCurrentUserInfo].userId) {
          NSString *url = [NSString stringWithFormat:@"%@?user_id=%@",RechargeArticlesURL,useId];
//        }else
//        {
//            url = [NSString stringWithFormat:@"%@?user_id=0",RechargeArticlesURL];
//        }

        ShareViewController *viewController=[[ShareViewController alloc]initWithTitle:@"充值篇" AndWithShareUrl:url];
        viewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:viewController animated:YES];

    }else if(button.tag == 1002){
        
//        NSString *url;
//        
//        if ([CurrentUserInformation sharedCurrentUserInfo].userId) {
        NSString *url = [NSString stringWithFormat:@"%@?user_id=%@",InvestmentArticlesURL,useId];
//        }else
//        {
//            url = [NSString stringWithFormat:@"%@?user_id=0",InvestmentArticlesURL];
//        }

        ShareViewController *viewController=[[ShareViewController alloc]initWithTitle:@"投资篇" AndWithShareUrl:url];
        viewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:viewController animated:YES];

    }else if(button.tag == 1003){
        
//        NSString *url;
//        
//        if ([CurrentUserInformation sharedCurrentUserInfo].userId) {
        NSString *url = [NSString stringWithFormat:@"%@?user_id=%@",AssetArticleURL,useId];
//        }else
//        {
//            url = [NSString stringWithFormat:@"%@?user_id=0",AssetArticleURL];
//        }

        ShareViewController *viewController=[[ShareViewController alloc]initWithTitle:@"资产篇" AndWithShareUrl:url];
        viewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:viewController animated:YES];

    }else{
        
//        NSString *url;
        
//        if ([CurrentUserInformation sharedCurrentUserInfo].userId) {
        NSString *url = [NSString stringWithFormat:@"%@?user_id=%@",WithdrawalsURL,useId];
//        }else
//        {
//            url = [NSString stringWithFormat:@"%@?user_id=0",WithdrawalsURL];
//        }
        ShareViewController *viewController=[[ShareViewController alloc]initWithTitle:@"提现篇" AndWithShareUrl:url];
        viewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:viewController animated:YES];

    }
}

@end
