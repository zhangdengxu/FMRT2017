//
//  AboutViewController.m
//  fmapp
//
//  Created by apple on 15/3/10.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "AboutViewController.h"
#import "HTTPClient+MeModulesSetup.h"

#import "SelfButton.h"
#import "CommonShareController.h"
#import "ShareViewController.h"

#define KLeftWidth      10
#define KBtnHeight      47
#define KBtnTag         10000


@interface AboutViewController ()
@property (nonatomic,copy)NSString         *contentStr;
@end

@implementation AboutViewController

- (void)loadView{
    self.view = [[UIView alloc] initWithFrame:HUIApplicationFrame()];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = KDefaultOrNightScrollViewColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingNavTitle:@"关于我们"];
    [self createMainView];
}

- (void)createMainView
{
    
//    self.contentStr=@"        融托金融（rongtuojinrong.com)是为个人投资者及优质中小企业搭建的高效、稳定、安全、透明的投融资普惠平台。投资收益可观，多重安全保障。合作机构实力最强，风险控制业内典范！融托金融，为您托起财富梦想！";
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [mainScrollView setBackgroundColor: [UIColor colorWithRed:230/255.0f green:235/255.f blue:240/255.0f alpha:1]];
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.contentSize = CGSizeMake(self.view.bounds.size.width,self.view.bounds.size.height +20.0f);
    [self.view addSubview:mainScrollView];
//
//    
//    UILabel *contentLabel=[[UILabel alloc]init];
//    contentLabel.backgroundColor=[UIColor clearColor];
//    contentLabel.font=[UIFont systemFontOfSize:17.0f];
//    contentLabel.numberOfLines=0;
//    contentLabel.text=self.contentStr;
//    contentLabel.textColor=KContentTextColor;

//    CGSize size=[self.contentStr sizeWithFont:contentLabel.font constrainedToSize:CGSizeMake(KProjectScreenWidth-20, 1000) lineBreakMode:NSLineBreakByWordWrapping];
//    contentLabel.frame=CGRectMake(10, 15, size.width, size.height);
//    [mainScrollView addSubview:contentLabel];
    
//    NSArray *titleArr=[[NSArray alloc]initWithObjects:@"公司简介",@"网站", nil];
//    
//    for(int i=0;i<2;i++)
//    {
//        SelfButton *btn=[[SelfButton alloc]initWithHelpCenterTitle:titleArr[i] AndWithBtnTag:KBtnTag+i];
//        [btn setFrame:CGRectMake(KLeftWidth,contentLabel.frame.origin.y+contentLabel.frame.size.height+15+(KBtnHeight +0.5f)*i, KProjectScreenWidth-2*KLeftWidth, KBtnHeight)];
//        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [mainScrollView addSubview:btn];
//    }

    NSArray *titleArr = [[NSArray alloc]initWithObjects:@"公司简介_03.png",@"业务领域_03.png",@"合作机构_03.png",@"宣传视频_03.png", nil];
    CGFloat height = (KProjectScreenHeight-64)/4-12;
    for (int i = 0; i<4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTag:(KBtnTag+i)];
        [button setBackgroundImage:[UIImage imageNamed:titleArr[i]] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor]];
        [button addTarget:self action:@selector(aboutUsClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setFrame:CGRectMake(10, 15+(height+5)*i, KProjectScreenWidth-20, height)];
        [mainScrollView addSubview:button];
 
    }
 
}

-(void)aboutUsClick:(UIButton *)button{

    if (button.tag == KBtnTag) {
        ShareViewController *shareVc = [[ShareViewController alloc]initWithTitle:@"企业介绍" AndWithShareUrl:explorerCompanyIntroduceURL];
        shareVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shareVc animated:YES];
  
    }
    if (button.tag == KBtnTag+1) {
        ShareViewController *shareVC = [[ShareViewController alloc]initWithTitle:@"业务领域" AndWithShareUrl:explorerBusinessAreasURL];
        shareVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shareVC animated:YES];
    }
    if (button.tag == KBtnTag+2) {
        ShareViewController *shareVC = [[ShareViewController alloc]initWithTitle:@"合作机构" AndWithShareUrl:explorerCooperationAgencyURL];
        shareVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shareVC animated:YES];
    }
    if (button.tag == KBtnTag+3) {
        ShareViewController *shareVC = [[ShareViewController alloc]initWithTitle:@"企业宣传视频" AndWithShareUrl:explorerBusinessVideoURL];
        shareVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shareVC animated:YES];
   
    }
}

- (void)buttonClick:(UIButton *)btn
{
    if (btn.tag==KBtnTag) {
        
        ShareViewController *viewController=[[ShareViewController alloc]initWithTitle:@"公司简介" AndWithShareUrl:explorerCompanyProfileURL];
        [self.navigationController pushViewController:viewController animated:YES];
     
    }
    else if (btn.tag==KBtnTag+1)
    {
    
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.rongtuojinrong.com"]];
    }
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
