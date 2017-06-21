//
//  WLNewRollsOfUserViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/10/31.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "WLNewRollsOfUserViewController.h"

@interface WLNewRollsOfUserViewController ()

@end
/**
 *规则一
 */
@implementation WLNewRollsOfUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingNavTitle:@"用户使用全民夺宝的前提条件"];
    [self.view setBackgroundColor:KDefaultOrBackgroundColor];
    [self createContentView];
}

-(void)createContentView{
    
    UIScrollView *backView = [[UIScrollView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.showsVerticalScrollIndicator = NO;
    backView.showsHorizontalScrollIndicator = NO;
    if (KProjectScreenWidth>320) {
        
        backView.contentSize = CGSizeMake(KProjectScreenWidth-50,400);
    }else{
        
        backView.contentSize = CGSizeMake(KProjectScreenWidth-50,320);
    }
    
    [self.view addSubview:backView];
    [backView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    UILabel *firstLabel = [[UILabel alloc]init];
    firstLabel.font = [UIFont systemFontOfSize:15];
    [firstLabel setTextColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1]];
    firstLabel.numberOfLines = 0;
    firstLabel.text = @"\n1、用户拥有融托金融帐号用户\n注册成为使用全民夺宝的前提是注册并拥有融托金融帐号。因此，本服务协议是《融托金融用户服务协议》的补充条款，与《融托金融用户服务协议》具有同等法律效力。\n\n2、用户在使用全民夺宝时须具备相应的权利能力和行为能力，能够独立承担法律责任，如果用户在18周岁以下，必须在父母或监护人的监护参与下才能使用本站。";
    [backView addSubview:firstLabel];
    [firstLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(backView.mas_top).offset(10);
    }];
    
}


@end
