//
//  WLNewServiceAgreementViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/10/31.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "WLNewServiceAgreementViewController.h"

@interface WLNewServiceAgreementViewController ()

@end
/**
 *规则四
 */
@implementation WLNewServiceAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingNavTitle:@"本服务协议的修改"];
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
        
        backView.contentSize = CGSizeMake(KProjectScreenWidth-50,350);
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
    firstLabel.text = @"\n用户知晓融托金融不时公布或修改的与本服务协议有关的其他规则、条款及公告等是本服务协议的组成部分。融托金融有权在必要时通过在全民夺宝内发出公告等合理方式修改本服务协议，用户在享受各项服务时，应当及时查阅了解修改的内容，并自觉遵守本服务协议。用户如继续使用本服务协议涉及的服务，则视为对修改内容的同意，当发生有关争议时，以最新的服务协议为准；用户在不同意修改内容的情况下，有权停止使用本服务协议涉及的服务。\n\n如用户对本规则内容有任何疑问，如有疑问可联系微信客服rongtuojinrong001或拨打4008788686进行查询。";
    [backView addSubview:firstLabel];
    [firstLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(self.view.mas_top).offset(10);
    }];
    
}

@end
