//
//  WLNewServiceAndAgreementViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/10/31.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "WLNewServiceAndAgreementViewController.h"
#import "WLNewUerManagerViewController.h"
#import "WLNewRollsOfUserViewController.h"
#import "WLNewViewController.h"
#import "WLNewServiceAgreementViewController.h"
#define WLBUTTONTAG 10000
@interface WLNewServiceAndAgreementViewController ()
@property(strong,nonatomic)UIButton *slectCtn;
@end

@implementation WLNewServiceAndAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingNavTitle:@"服务协议与规则"];
    [self.view setBackgroundColor:KDefaultOrBackgroundColor];
    [self createContentView];
}

-(void)createContentView{
    
    UIScrollView *backView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 10, KProjectScreenWidth-20, KProjectScreenHeight-20)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.showsVerticalScrollIndicator = NO;
    backView.showsHorizontalScrollIndicator = NO;
    if (KProjectScreenWidth>380) {
        
        backView.contentSize = CGSizeMake(KProjectScreenWidth-50,700);
        
    }else if (KProjectScreenWidth<375){
        
        backView.contentSize = CGSizeMake(KProjectScreenWidth-50,680);
        
    }else{
        
        backView.contentSize = CGSizeMake(KProjectScreenWidth-50,620);
        
    }
    [self.view addSubview:backView];
//    [backView makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.view.mas_right).offset(-10);
//        make.left.equalTo(self.view.mas_left).offset(10);
//        make.top.equalTo(self.view.mas_top).offset(10);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
//    }];
    NSString *content = @"\n欢迎访问全民夺宝，申请使用融托金融提供的全民夺宝服务（以下简称“全民夺宝”，“全民夺宝”指用户使用融托金融APP赠送的夺宝币，或花费1元购买优商城夺宝币1枚，用户可使用夺宝币参与商品抽奖的服务），请您（下列简称为“用户”）仔细阅读以下全部内容。如用户不同意本服务条款任意内容，请勿使用全民夺宝。如用户通过进入注册程序并勾选“我已阅读并同意”，即表示用户与融托金融已达成协议，自愿接受本服务条款的所有内容。此后，用户不得以未阅读本服务条款内容作任何形式的抗辩。";
    UILabel *firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, KProjectScreenWidth-50, [self heitForLabel:content])];
    firstLabel.font = [UIFont systemFontOfSize:14];
    [firstLabel setTextColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1]];
    firstLabel.numberOfLines = 0;
    
    firstLabel.text = content;
    [backView addSubview:firstLabel];
    
    UIView *bjView = [[UIView alloc]init];
    [backView addSubview:bjView];
    [bjView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.left.equalTo(self.view.mas_left).offset(30);
        make.top.equalTo(firstLabel.mas_bottom).offset(38);
        make.height.equalTo(200);
    }];
    UIView *lineView = [[UIView alloc]init];
    [lineView setBackgroundColor:KDefaultOrBackgroundColor];
    [bjView addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bjView.mas_right);
        make.left.equalTo(bjView.mas_left);
        make.top.equalTo(bjView.mas_top);
        make.height.equalTo(1);
    }];
    NSArray *tittleASrr = [NSArray arrayWithObjects:@"一、用户使用全民夺宝的前提条件",@"二、用户管理",@"三、全民夺宝的使用规则",@"四、本服务协议的修改", nil];
    for (int i=0; i<4; i++) {
        UIView *lineView = [[UIView alloc]init];
        [lineView setBackgroundColor:KDefaultOrBackgroundColor];
        [bjView addSubview:lineView];
        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bjView.mas_right);
            make.left.equalTo(bjView.mas_left);
            make.top.equalTo(bjView.mas_top).offset(50*(i+1)-1);
            make.height.equalTo(1);
        }];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        
        if (KProjectScreenWidth<330) {
            [titleLabel setFont:[UIFont systemFontOfSize:14]];
        }if (KProjectScreenWidth>380) {
            [titleLabel setFont:[UIFont systemFontOfSize:16]];
        }else{
            [titleLabel setFont:[UIFont systemFontOfSize:15]];
        }
        [titleLabel setTextColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1]];
        [titleLabel setText:tittleASrr[i]];
        [bjView addSubview:titleLabel];
        [titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bjView.mas_right);
            make.left.equalTo(bjView.mas_left);
            make.top.equalTo(bjView.mas_top).offset(50*i);
            make.height.equalTo(50);
        }];
        
        
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(KProjectScreenWidth-67, 19.5+50*i, 6, 11)];
        [imgV setImage:[UIImage imageNamed:@"首页零钱贯-箭头_07"]];
        [bjView addSubview:imgV];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:WLBUTTONTAG+i];
        [bjView addSubview:button];
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bjView.mas_right);
            make.left.equalTo(bjView.mas_left);
            make.top.equalTo(bjView.mas_top).offset(50*i);
            make.height.equalTo(50);
        }];
        
    }
    
    UIButton *besureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [besureBtn setBackgroundColor:[UIColor colorWithRed:15/255.0f green:94/255.0f blue:210/255.0f alpha:1]];
    [besureBtn addTarget:self action:@selector(BeSureAction)
        forControlEvents:UIControlEventTouchUpInside];
    besureBtn.titleLabel.font=[UIFont systemFontOfSize:16.0];
    [besureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [besureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [besureBtn.layer setBorderWidth:0.5f];
    [besureBtn.layer setCornerRadius:2.0f];
    [besureBtn.layer setMasksToBounds:YES];
    [besureBtn.layer setBorderColor:[KDefaultOrNightSepratorColor CGColor]];
    [backView addSubview:besureBtn];
    [besureBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-80);
        make.left.equalTo(self.view.mas_left).offset(80);
        make.top.equalTo(bjView.mas_bottom).offset(60);
        make.height.equalTo(40);
        make.centerX.equalTo(self.view.mas_centerX);
        
    }];
    
    
    UILabel *delegateLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 198, KProjectScreenWidth-40, 20)];
    delegateLabel.text = @"《我已阅读并同意本服务协议》";
    delegateLabel.font = [UIFont boldSystemFontOfSize:12];
    [delegateLabel setTextColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.8]];
    [backView addSubview:delegateLabel];
    [delegateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(besureBtn.mas_top).offset(-40);
        make.height.equalTo(24);
        make.centerX.equalTo(self.view.mas_centerX).offset(13);
        
    }];
    
    UIButton *slectCtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [slectCtn setImage:[UIImage imageNamed:@"选择框"] forState:UIControlStateNormal];
    [slectCtn setImage:[UIImage imageNamed:@"选择框副本"] forState:UIControlStateSelected];
    [slectCtn addTarget:self action:@selector(bottomSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [slectCtn setSelected:NO];
    [backView addSubview:slectCtn];
    [slectCtn setSelected:YES];
    [slectCtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(delegateLabel.mas_left).offset(-2);
        make.top.equalTo(delegateLabel.mas_top);
        make.height.equalTo(24);
        make.width.equalTo(24);
    }];
    self.slectCtn = slectCtn;
}

-(CGFloat)heitForLabel:(NSString *)content{
    
    CGFloat chengweiW = KProjectScreenWidth - 50;
    CGSize chengweiMaxSize = CGSizeMake(chengweiW, MAXFLOAT);
    NSDictionary *chengweiAttrs = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
    CGFloat chengweiH = [content boundingRectWithSize:chengweiMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:chengweiAttrs context:nil].size.height;
    return chengweiH;
}

-(void)bottomSelectAction:(UIButton*)button{
    
    button.selected =! button.selected;
}

//确定按钮
-(void)BeSureAction{
    
    if (!self.slectCtn.selected) {
        
        ShowAutoHideMBProgressHUD(self.view,@"请先阅读并同意本服务协议");
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


-(void)buttonAction:(UIButton *)button{
    
    if (button.tag == WLBUTTONTAG) {
        //条件
        WLNewRollsOfUserViewController *vc = [[WLNewRollsOfUserViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (button.tag == WLBUTTONTAG+1){
        //用户管理
        WLNewUerManagerViewController *vc = [[WLNewUerManagerViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (button.tag == WLBUTTONTAG+2){
        //全民夺宝的使用规则
        WLNewViewController *vc = [[WLNewViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        //本服务协议的修改
        WLNewServiceAgreementViewController *vc = [[WLNewServiceAgreementViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
@end
