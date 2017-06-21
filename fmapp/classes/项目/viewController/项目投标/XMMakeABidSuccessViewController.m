//
//  XMMakeABidSuccessViewController.m
//  fmapp
//
//  Created by runzhiqiu on 16/3/30.
//  Copyright © 2016年 yk. All rights reserved.
//
#define KDefaultViewHeight 667

#import "XMMakeABidSuccessViewController.h"
#import "MyClaimController.h"
@interface XMMakeABidSuccessViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *resultBackageImage;
@property (weak, nonatomic) IBOutlet UILabel *resultTitle;
@property (weak, nonatomic) IBOutlet UILabel *makeABidMoney;
@property (weak, nonatomic) IBOutlet UILabel *profitMoney;
@property (weak, nonatomic) IBOutlet UILabel *profitTime;
@property (weak, nonatomic) IBOutlet UIView *resultContentVeiw;
@property (weak, nonatomic) IBOutlet UILabel *detailProjectLabel;
@property (weak, nonatomic) IBOutlet UIButton *cieditButton;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic,copy) NSString *moneyInfo;
@property (nonatomic,copy) NSString *profitMoneyInfo;
@property (nonatomic,copy) NSString *timeInfo;

@property (nonatomic,copy) NSString *because;

@property (nonatomic, assign) BOOL isSuccess;


@end

@implementation XMMakeABidSuccessViewController

- (IBAction)cieditButtonOnClick:(id)sender {
    MyClaimController *viewController=[[MyClaimController alloc]init];
    viewController.isComeFromWeb = YES;
    viewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)loadView
{
    [super loadView];
    
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"投标成功"];
    [self createUINavigation];
    self.view.backgroundColor = [UIColor colorWithRed:(231/255.0) green:(231/255.0) blue:(231/255.0) alpha:1];
    
    [self createUIScrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self showInfo];
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [wself createUIScrollView];
//        wself.automaticallyAdjustsScrollViewInsets = NO;
//        [wself showInfo];
//    });
    
    // Do any additional setup after loading the view.
}
-(void)createUIScrollView
{
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.scrollView = scrollView;
    scrollView.backgroundColor = [UIColor colorWithRed:(231/255.0) green:(231/255.0) blue:(231/255.0) alpha:1];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, KDefaultViewHeight);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    
    
    
    UIView * loadViewXIB  = [[[NSBundle mainBundle] loadNibNamed:@"XMMakeABidSuccessViewController" owner:self options:nil]lastObject];
    loadViewXIB.userInteractionEnabled = YES;
    loadViewXIB.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, KDefaultViewHeight);
    [scrollView addSubview:loadViewXIB];
    
    
    UIImage * progressSetImage = [UIImage imageNamed:@"融托金融-债权Success-2"];
    progressSetImage = [progressSetImage stretchableImageWithLeftCapWidth:floorf(progressSetImage.size.width * 0.5) topCapHeight:floorf(progressSetImage.size.height * 0.5)];
    self.resultBackageImage.image = progressSetImage;

}
-(void)showSuccessWith:(NSString *)money profit:(NSString *)profitMoney Time:(NSString *)time;
{
    
    self.moneyInfo = money;
    self.profitMoneyInfo = profitMoney;
    self.timeInfo = time;
    self.isSuccess = YES;
    
}
-(void)showInfo
{
    if (self.isSuccess) {
        self.resultTitle.text = @"恭喜您投标成功";
        self.makeABidMoney.text = self.moneyInfo;
        self.profitMoney.text = self.profitMoneyInfo;
        self.profitTime.text = self.timeInfo;

    }else
    {
        self.resultTitle.text = @"投标失败";
        for (UIView * view in self.resultContentVeiw.subviews) {
            [view removeFromSuperview];
        }
        self.detailProjectLabel.hidden = YES;
        self.cieditButton.hidden = YES;
        
        UILabel * resultLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 20, self.resultContentVeiw.frame.size.width - 12 * 2, self.resultContentVeiw.frame.size.height - 15 - 20)];
        resultLabel.numberOfLines = 0;
        resultLabel.font = [UIFont systemFontOfSize:14];
        resultLabel.textColor = [UIColor colorWithRed:(60/255.0) green:(60/255.0) blue:(60/255.0) alpha:1];
        resultLabel.text = self.because;
        [self.resultContentVeiw addSubview:resultLabel];
    }
}

-(void)showFailWith:(NSString *)because;
{
    
    self.because = because;
    self.isSuccess = NO;
}
-(void)createUINavigation
{
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [leftButton setTitle:@"首页" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    leftButton.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 10);
    leftButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [leftButton addTarget:self action:@selector(indexButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    
    UIButton * rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    [rightButton setTitle:@"我的" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
    rightButton.titleEdgeInsets = UIEdgeInsetsMake(5, 15, 0, 0);
    [rightButton addTarget:self action:@selector(myAccountButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
}

-(void)indexButtonOnClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
-(void)myAccountButtonOnClick
{
    self.tabBarController.selectedIndex = 3;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
