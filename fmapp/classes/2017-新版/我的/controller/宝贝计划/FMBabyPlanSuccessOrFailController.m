//
//  FMBabyPlanSuccessOrFailController.m
//  fmapp
//
//  Created by runzhiqiu on 16/8/29.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMBabyPlanSuccessOrFailController.h"
#import "BabyPlanAccountViewController.h"
#import "FMTabBarController.h"


@interface FMBabyPlanSuccessOrFailController ()

@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, strong) UILabel * detailLabel;
@property (nonatomic, strong) UILabel * numberLabel;

@end

@implementation FMBabyPlanSuccessOrFailController

- (void)viewDidLoad {
    [super viewDidLoad];
     __weak __typeof(&*self)weakSelf = self;
    self.navBackButtonRespondBlock = ^(){
        [weakSelf returViewController];
    };
    //0829融托金融-加入成功切图
    if (self.isSuccess) {
        [self settingNavTitle:@"加入成功"];
    }else
    {
        [self settingNavTitle:@"加入失败"];
    }
    
    if (self.isSuccess) {
        
        [self.iconImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(30);
            make.centerX.equalTo(self.view.mas_centerX);
            make.width.equalTo(KProjectScreenWidth * 0.7);
            make.height.equalTo(KProjectScreenWidth * 0.7);
            
        }];
        
        [self.detailLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImageView.mas_bottom).offset(40);
            make.centerX.equalTo(self.view.mas_centerX);
        }];
        
        self.detailLabel.text = self.detailString;
        
        
        [self babyPlanSuccess];
        
    }else
    {
        [self.iconImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(30);
            make.centerX.equalTo(self.view.mas_centerX);
            make.width.equalTo(KProjectScreenWidth * 0.7);
            make.height.equalTo(KProjectScreenWidth * 0.7);
            
        }];
        
        [self.detailLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImageView.mas_bottom).offset(40);
            make.centerX.equalTo(self.view.mas_centerX);
        }];
        
        self.detailLabel.text = self.detailString;
        
        [self.numberLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.detailLabel.mas_top).offset(30);
            make.centerX.equalTo(self.view.mas_centerX);
        }];
    }
    
    
    [self createRightButton];
    
    // Do any additional setup after loading the view.
}

-(void)returViewController
{
    BabyPlanAccountViewController * viewC ;
    for (UIViewController * vc in self.navigationController.viewControllers) {
        if ([vc isMemberOfClass:[BabyPlanAccountViewController class]]) {
            viewC = (BabyPlanAccountViewController *)vc;
            break;
        }
    }
    if (viewC) {
        [self.navigationController popToViewController:viewC animated:YES];
    }else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];

    }
}

-(void)babyPlanSuccess;
{
    [[NSNotificationCenter defaultCenter]postNotificationName:KdefaultMyViewControllerRefresh object:nil];
    
}
-(void)createRightButton
{
    UIButton * searchButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 18)];
    [searchButton setTitle:@"我的" forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(adsActivitybuttonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * searchBar = [[UIBarButtonItem alloc]initWithCustomView:searchButton];
    
    self.navigationItem.rightBarButtonItem = searchBar;
}

-(void)adsActivitybuttonOnClick:(UIButton *)button
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    FMTabBarController * tabbar =(FMTabBarController *) window.rootViewController;
    tabbar.selectedIndex = 2;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        
        _iconImageView.image = [UIImage imageNamed:@"0829融托金融-加入成功切图"];
        [self.view addSubview:_iconImageView];
    }
    return _iconImageView;
}

-(UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.numberOfLines = 0;
        _detailLabel.font = [UIFont systemFontOfSize:16];
        _detailLabel.textColor = [HXColor colorWithHexString:@"#ff6633"];
        [self.view addSubview:_detailLabel];
    }
    return _detailLabel;
}
-(UILabel *)numberLabel
{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc]init];
        _numberLabel.numberOfLines = 0;
        _numberLabel.text = @"可致电400-878－8686或微信客服rongtuojinrong001";
        _numberLabel.font = [UIFont systemFontOfSize:14];
        _numberLabel.textColor = [HXColor colorWithHexString:@"#999999"];
        [self.view addSubview:_numberLabel];
    }
    return _numberLabel;
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
