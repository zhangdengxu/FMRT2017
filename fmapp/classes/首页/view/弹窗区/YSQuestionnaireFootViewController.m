//
//  YSQuestionnaireFootViewController.m
//  fmapp
//
//  Created by yushibo on 2016/9/29.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "YSQuestionnaireFootViewController.h"


@interface YSQuestionnaireFootViewController ()

/**  您的投资类型分析 */
@property (nonatomic, strong)UILabel *explainLabel;
/**  您的投资类型属于 */
@property (nonatomic, strong)UILabel *specificTypeLabel;
/**  适合投资类型 */
@property (nonatomic, strong)UILabel *rightSuitLabel;

@end

@implementation YSQuestionnaireFootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self settingNavTitle:@"调查问卷"];
    [self createContentView];
    
    __weak __typeof(&*self)weakSelf = self;
    self.navBackButtonRespondBlock = ^() {
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    };
    
}

-(void)setTotalNumber:(NSString *)totalNumber{
    _totalNumber = totalNumber;
    if ([totalNumber intValue] <= 30) {
    
        self.specificTypeLabel.text = @"保守型";
        self.rightSuitLabel.text = @"低风险投资";
        self.explainLabel.text = @"     经风险评级确定为低风险等级投资，包括本金安全，且预期收益不受损失的投资。";
    }
    if ( 30 < [totalNumber intValue] && [totalNumber intValue] <= 50) {
        
        self.specificTypeLabel.text = @"稳健型";
        self.rightSuitLabel.text = @"低风险投资";
        self.explainLabel.text = @"     经风险评级确定为低风险等级投资，包括本金安全，且收益预期不能实现的概率较低的投资。";
    }
    if (50 < [totalNumber intValue] && [totalNumber intValue] <= 75) {
        
        self.specificTypeLabel.text = @"平衡型";
        self.rightSuitLabel.text = @"中等风险投资";
        self.explainLabel.text = @"     经风险评级确定为中等风险等级投资，该类投资本金亏损概率较低，但预期收益存在一定的不确定性。";
    }
    if (75 < [totalNumber intValue] && [totalNumber intValue] <= 90) {
        
        self.specificTypeLabel.text = @"风险型";
        self.rightSuitLabel.text = @"高风险投资";
        self.explainLabel.text = @"     经风险评级确定为高风险等级投资，本金亏损概率较高，收益波动性大。";
    }

}
- (void)createContentView{
    
    
    CGFloat margin = (KProjectScreenWidth - 30)/612*22;
    CGFloat upHeight = ((KProjectScreenWidth - 30) * 303) / 612;
    
    /**  上部图 */
    UIImageView *upView = [[UIImageView alloc]init];
    upView.image = [UIImage imageNamed:@"调查结果页--上背景_03"];
    [self.view addSubview:upView];
    [upView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(self.view.mas_top).offset(80);
        make.height.equalTo(upHeight);
        
    }];
    

    /**  上部图 下部图 中间线 约束以他为中心 */
    
    UIView *lineV = [[UIView alloc]init];
    lineV.backgroundColor = [UIColor colorWithHexString:@"#ababab"];
    [self.view addSubview:lineV];
    [lineV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(upView.mas_left).offset(margin);
        make.right.equalTo(upView.mas_right).offset(-margin);
        make.top.equalTo(upView.mas_bottom);
        make.height.equalTo(@1);
    }];
    
    /**  适合投资类型 */
    UILabel *suitableLabel = [[UILabel alloc]init];
    suitableLabel.text = @"适合投资类型";
    suitableLabel.textAlignment = NSTextAlignmentLeft;
    suitableLabel.font = [UIFont systemFontOfSize:15];
    suitableLabel.textColor = [UIColor colorWithHexString:@"#lelele"];
    [upView addSubview:suitableLabel];
    [suitableLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineV.mas_left).offset(2*margin);
        make.bottom.equalTo(lineV.mas_top);
        make.height.equalTo(upHeight / 4);
        
    }];
    
    /**  低风险投资 */
    UILabel *rightSuitLabel = [[UILabel alloc]init];
//    rightSuitLabel.text = @"低风险投资";
    rightSuitLabel.textAlignment = NSTextAlignmentRight;
    rightSuitLabel.font = [UIFont systemFontOfSize:15];
    rightSuitLabel.textColor = [UIColor colorWithHexString:@"#003D90"];
    self.rightSuitLabel = rightSuitLabel;
    [upView addSubview:rightSuitLabel];
    [rightSuitLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(suitableLabel.mas_right);
        make.right.equalTo(lineV.mas_right).offset(-(2*margin));
        make.bottom.equalTo(lineV.mas_top);
        make.height.equalTo(upHeight / 4);
        
    }];

    /**  投资类型 适合投资类型 中间线 */
    UIView *suitLine = [[UIView alloc]init];
    suitLine.backgroundColor = [UIColor colorWithHexString:@"#ababab"];
    [upView addSubview:suitLine];
    [suitLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(upView.mas_left).offset(margin);
        make.right.equalTo(upView.mas_right).offset(-margin);
        make.bottom.equalTo(suitableLabel.mas_top);
        make.height.equalTo(@1);
    }];

    /**  您的投资类型属于 */
    UILabel *styleLabel = [[UILabel alloc]init];
    styleLabel.text = @"您的投资类型属于";
    styleLabel.textAlignment = NSTextAlignmentLeft;
    styleLabel.font = [UIFont systemFontOfSize:15];
    styleLabel.textColor = [UIColor colorWithHexString:@"#lelele"];
    [upView addSubview:styleLabel];
    [styleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineV.mas_left).offset(2*margin);
        make.bottom.equalTo(suitLine.mas_top);
        make.height.equalTo(upHeight / 4);
        
    }];
    
    /**  稳健型 */
    UILabel *specificTypeLabel = [[UILabel alloc]init];
//    specificTypeLabel.text = @"稳健型";
    specificTypeLabel.textAlignment = NSTextAlignmentRight;
    specificTypeLabel.font = [UIFont systemFontOfSize:15];
    specificTypeLabel.textColor = [UIColor colorWithHexString:@"#003D90"];
    self.specificTypeLabel = specificTypeLabel;
    [upView addSubview:specificTypeLabel];
    [specificTypeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(styleLabel.mas_right);
        make.right.equalTo(lineV.mas_right).offset(-(2*margin));
        make.bottom.equalTo(suitLine.mas_top);
        make.height.equalTo(upHeight / 4);
        
    }];
    /**  投资类型 上部线 */
    UIView *upLine = [[UIView alloc]init];
    upLine.backgroundColor = [UIColor colorWithHexString:@"#ababab"];
    [upView addSubview:upLine];
    [upLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(upView.mas_left).offset(margin);
        make.right.equalTo(upView.mas_right).offset(-margin);
        make.bottom.equalTo(styleLabel.mas_top);
        make.height.equalTo(@1);
    }];
    
    /** 最上面的小图 */
    UIImageView *juanV = [[UIImageView alloc]init];
    juanV.image = [UIImage imageNamed:@"调查问卷结果图标_03"];
    [upView addSubview:juanV];
    [juanV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(upView.mas_top).offset(margin);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    /**  调查问卷结果 */
    UILabel *resultLabel = [[UILabel alloc]init];
    resultLabel.text = @"调查问卷结果";
    resultLabel.font = [UIFont systemFontOfSize:18];
    resultLabel.textColor = [UIColor colorWithHexString:@"#lelele"];
    [upView addSubview:resultLabel];
    [resultLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(juanV.mas_bottom).offset(margin/2);
        make.centerX.equalTo(self.view.mas_centerX);
        
    }];
    

    /**  下部图 */
    UIImageView *downView = [[UIImageView alloc]init];
    downView.image = [UIImage imageNamed:@"调查结果页面--下背景_03"];
    [self.view addSubview:downView];
    [downView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(lineV.mas_bottom);
        
    }];
    
    UILabel *explainLabel = [[UILabel alloc]init];
//    explainLabel.text = @"      经风险评级确定为中等风险等级投资，该类投资本金亏损概率较低，但预期收益存在一定的不确定性";
    explainLabel.font = [UIFont systemFontOfSize:14];
    explainLabel.textColor = [UIColor colorWithHexString:@"#989898"];
    explainLabel.numberOfLines = 0;
    self.explainLabel = explainLabel;
    [downView addSubview:explainLabel];
    [explainLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineV.mas_left).offset(margin);
        make.right.equalTo(lineV.mas_right).offset(-margin);
        make.top.equalTo(downView.mas_top).offset(5);

    }];
    
    UIButton *completeBtn = [[UIButton alloc]init];
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    completeBtn.backgroundColor = [UIColor colorWithHexString:@"#f9bc5d"];
    [completeBtn setTitleColor:[UIColor colorWithHexString:@"#fb402e"] forState:UIControlStateNormal];
    completeBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    downView.userInteractionEnabled = YES;
    [completeBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:completeBtn];
    [completeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(downView.mas_bottom).offset(-margin);
        make.height.equalTo(33);
        make.width.equalTo(100);
    }];
    
}
- (void)clickBtn:(UIButton *)button{

    NSLog(@"******");
    [self.navigationController popToRootViewControllerAnimated:YES];

}
@end
