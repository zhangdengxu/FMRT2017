//
//  YSCustomerSerViewController.m
//  fmapp
//
//  Created by yushibo on 16/4/26.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "YSCustomerSerViewController.h"
#import "WLRequestViewController.h"
@interface YSCustomerSerViewController ()
@property(nonatomic,strong)UIView *lowV;
@end

@implementation YSCustomerSerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"申请售后"];
    [self setRightNavBarButton];
    [self createSegmentChoice];
    [self createMidLine];
}
/**
       →_→按钮;
 */
- (void)setRightNavBarButton{
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingButton setImage:[UIImage imageNamed:@"优商城售后_未读消息_36"] forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(settingClick) forControlEvents:UIControlEventTouchUpInside];
    [settingButton sizeToFit];
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    self.navigationItem.rightBarButtonItems = @[settingItem];

}

//创建segment
- (void)createSegmentChoice{

    UISegmentedControl *segmentService = [[UISegmentedControl alloc]initWithFrame:CGRectMake(KProjectScreenWidth / 2 - 105, 15, 210, 32)];
    [segmentService insertSegmentWithTitle:@"未收到货" atIndex:0 animated:NO];
    [segmentService insertSegmentWithTitle:@"已收到货" atIndex:1 animated:NO];
    segmentService.tintColor = [UIColor colorWithRed:252/255.0 green:103/255.0 blue:61/255.0 alpha:1];
    segmentService.selectedSegmentIndex = 0;
    [self createLowView];
    [segmentService addTarget:self action:@selector(controlPressed:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentService];
}
//创建segment调用方法
- (void)controlPressed:(UISegmentedControl *)sender{

    NSInteger selectedIndex =sender.selectedSegmentIndex;
    switch (selectedIndex) {
        case 0:
            [self.lowV removeFromSuperview];
            [self createLowView];
            break;
        case 1:
            [self.lowV removeFromSuperview];
            [self createLow2View];
            break;
        default:
            break;
    }
}

//中部灰线
- (void)createMidLine{

    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(15, 61, KProjectScreenWidth-30, 0.5)];
    lineV.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1];
    [self.view addSubview:lineV];
    
}

//创建 未收到货 View
- (void)createLowView{

    UIView *lowV = [[UIView alloc]initWithFrame:CGRectMake(15, 87, KProjectScreenWidth - 30, KProjectScreenHeight - 83)];
//    lowV.backgroundColor = [UIColor redColor];
    //1 label
    UILabel *tipL1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth - 30, 13)];
    tipL1.text = @"温馨提示";
    tipL1.font = [UIFont systemFontOfSize:13];
    tipL1.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
//    tipL1.backgroundColor = [UIColor redColor];
    //2 label
    UILabel *tipL2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 24, CGRectGetWidth(lowV.frame), 27)];
    tipL2.numberOfLines = 0;
    NSString *tipL2Content =@"若您未收到货，且还未有物流信息与卖家达成一致仅退款时，请选择\"退款\"选项";
    tipL2.text =tipL2Content;
    tipL2.font = [UIFont systemFontOfSize:12];
    tipL2.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
//    tipL2.backgroundColor = [UIColor redColor];
    CGSize size2 = CGSizeMake(CGRectGetWidth(lowV.frame), MAXFLOAT);
    CGSize tipL2Size = [tipL2Content sizeWithFont:tipL2.font constrainedToSize:size2 lineBreakMode:NSLineBreakByWordWrapping];
    [tipL2 setFrame:CGRectMake(0, 24, tipL2Size.width, tipL2Size.height)];
    
    //设置行间距
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:tipL2Content];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:10];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [tipL2Content length])];
    [tipL2 setAttributedText:attributedString1];
    [tipL2 sizeToFit];
    
    [lowV addSubview:tipL1];
    [lowV addSubview:tipL2];
//    [lowV addSubview:tipL3];
    [self.view addSubview:lowV];
    
    //创建下部 俩个button
    //取消申请按钮
    UIButton *cancelBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    cancelBtn2.frame = CGRectMake(259, 89, 84, 25);
    [lowV addSubview:cancelBtn2];
    [cancelBtn2 makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lowV);
        make.bottom.equalTo(lowV).offset(- CGRectGetHeight(lowV.frame) + 109);
        make.width.equalTo(84);
        make.height.equalTo(25);
    }];
    cancelBtn2.backgroundColor = [UIColor colorWithRed:9/255.0 green:63/255.0 blue:142/255.0 alpha:1];
    cancelBtn2.layer.masksToBounds = YES;
    cancelBtn2.layer.cornerRadius =2;
    [cancelBtn2 setTitle:@"取消申请" forState:UIControlStateNormal];
    cancelBtn2.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    //添加点击事件
    [cancelBtn2 addTarget:self action:@selector(settingClick) forControlEvents:UIControlEventTouchUpInside];
    
//继续申请按钮
    UIButton *orderBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    //    orderBtn1.frame = CGRectMake(170, 89, 84, 25);
    [lowV addSubview:orderBtn1];
    [orderBtn1 makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(lowV).offset(KProjectScreenWidth - 205);
        make.right.mas_equalTo(cancelBtn2.mas_left).offset(- 6);
        make.bottom.equalTo(cancelBtn2);
        make.width.equalTo(84);
        make.height.equalTo(25);
    }];
    orderBtn1.backgroundColor = [UIColor colorWithRed:9/255.0 green:63/255.0 blue:142/255.0 alpha:1];
    orderBtn1.layer.masksToBounds = YES;
    orderBtn1.layer.cornerRadius =2;
    [orderBtn1 setTitle:@"继续申请" forState:UIControlStateNormal];
    orderBtn1.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    //添加点击事件
    [orderBtn1 addTarget:self action:@selector(continueApply) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.lowV = lowV;

}

//创建 已收到货 界面
- (void)createLow2View{
    
    UIView *lowV2 = [[UIView alloc]initWithFrame:CGRectMake(15, 87, KProjectScreenWidth - 30, KProjectScreenHeight - 83)];

    //1 label
    UILabel *tipL1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth - 30, 13)];
    tipL1.text = @"温馨提示";
    tipL1.font = [UIFont systemFontOfSize:13];
    tipL1.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];

    //2 label
    UILabel *tipL2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 24, KProjectScreenWidth - 30, 12)];

    tipL2.text = @"若您已收到货，且与卖家达成一致，请选择\"退货\"选项";
    tipL2.font = [UIFont systemFontOfSize:12];
    tipL2.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
//    tipL2.backgroundColor = [UIColor redColor];
    [lowV2 addSubview:tipL1];
    [lowV2 addSubview:tipL2];
    [self.view addSubview:lowV2];
    
    //创建下部 俩个button
    //取消申请按钮
    UIButton *cancelBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    //    cancelBtn2.frame = CGRectMake(259, 89, 84, 25);
    [lowV2 addSubview:cancelBtn2];
    [cancelBtn2 makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lowV2);
        make.bottom.equalTo(lowV2).offset(- CGRectGetHeight(lowV2.frame) + 109);
        make.width.equalTo(84);
        make.height.equalTo(25);
    }];
    cancelBtn2.backgroundColor = [UIColor colorWithRed:9/255.0 green:63/255.0 blue:142/255.0 alpha:1];
    cancelBtn2.layer.masksToBounds = YES;
    cancelBtn2.layer.cornerRadius =2;
    [cancelBtn2 setTitle:@"取消申请" forState:UIControlStateNormal];
    cancelBtn2.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    //添加点击事件
    [cancelBtn2 addTarget:self action:@selector(settingClick) forControlEvents:UIControlEventTouchUpInside];
    
    //继续申请按钮
    UIButton *orderBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    //    orderBtn1.frame = CGRectMake(170, 89, 84, 25);
    [lowV2 addSubview:orderBtn1];
    [orderBtn1 makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(lowV2).offset(KProjectScreenWidth - 205);
        make.right.mas_equalTo(cancelBtn2.mas_left).offset(- 6);
        make.bottom.equalTo(cancelBtn2);
        make.width.equalTo(84);
        make.height.equalTo(25);
    }];
    orderBtn1.backgroundColor = [UIColor colorWithRed:9/255.0 green:63/255.0 blue:142/255.0 alpha:1];
    orderBtn1.layer.masksToBounds = YES;
    orderBtn1.layer.cornerRadius =2;
    [orderBtn1 setTitle:@"继续申请" forState:UIControlStateNormal];
    orderBtn1.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    //添加点击事件
    [orderBtn1 addTarget:self action:@selector(continueApply) forControlEvents:UIControlEventTouchUpInside];
    
    [lowV2 addSubview:orderBtn1];
    [lowV2 addSubview:cancelBtn2];
    self.lowV = lowV2;
}

- (void)continueApply{
    WLRequestViewController *continueApply = [[WLRequestViewController alloc]init];
    [self.navigationController pushViewController:continueApply animated:YES];
    
}
- (void)settingClick{
    [self.navigationController popViewControllerAnimated:YES];

}


@end
