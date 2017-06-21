//
//  YYMineHeaderView.m
//  fmapp
//
//  Created by yushibo on 2017/2/20.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "YYMineHeaderView.h"

@interface YYMineHeaderView ()
@property (nonatomic, strong) UILabel *totalMoneyText;
@property (nonatomic, strong) UILabel *onRoadMoneyLabel;
@property (nonatomic, strong) UILabel *indevertText;
@property (nonatomic, strong) UILabel *expectedText;
@property (nonatomic, strong) UILabel *earnedText;
@property (nonatomic, strong) UILabel *usingText;
@property (nonatomic, strong) UILabel *indevertLabel;
@property (nonatomic, strong) UILabel *expectedLabel;
@property (nonatomic, strong) UILabel *usingLabel;

@property (nonatomic, strong) UIView *downBackView;

@property (nonatomic, strong) UIButton *eyeBtn;
@property (nonatomic, strong) UIButton *indicateButton;
@property (nonatomic, strong) UIButton *totalMoneyLabel;
//@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *backView;

/** 是否睁眼 */
@property (nonatomic, assign) BOOL isEye;

@property (nonatomic, strong) FMMineModel *eyeModel;
@property (nonatomic, strong) UILabel *testLabel;
@end
@implementation YYMineHeaderView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createHeaderView];
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"IsEyeUser_Id"] isEqualToString:[NSString stringWithFormat:@"%@", [CurrentUserInformation sharedCurrentUserInfo].userId]]) {
            
            self.isEye = [[NSUserDefaults standardUserDefaults] boolForKey:@"IsEye"];
            
            [[NSUserDefaults standardUserDefaults] setObject:[CurrentUserInformation sharedCurrentUserInfo].userId forKey:@"IsEyeUser_Id"];

        }else{
            
            self.isEye = YES;
            
            [[NSUserDefaults standardUserDefaults] setBool:self.isEye forKey:@"IsEye"];

            [[NSUserDefaults standardUserDefaults] setObject:[CurrentUserInformation sharedCurrentUserInfo].userId forKey:@"IsEyeUser_Id"];

            
        }
        
    }
    return self;
}

- (void)createHeaderView {
    UIView *backView = [[UIView alloc]init];
    backView.userInteractionEnabled = YES;
    
    backView.backgroundColor = [HXColor colorWithHexString:@"#0159d5"];
    
    self.backView = backView;
    [self addSubview:backView];
    [backView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        if (KProjectScreenWidth > 320) {
            make.height.equalTo(@170);
            
        }else{
            make.height.equalTo(@160);
            
        }
    }];
    
    
    UIButton *totalMoneyLabel = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [totalMoneyLabel setTitle:@"资产总额 (元)" forState:(UIControlStateNormal)];
    self.totalMoneyLabel = totalMoneyLabel;
    totalMoneyLabel.titleLabel.font = [UIFont systemFontOfSize:13];
    [totalMoneyLabel setTitleColor:[HXColor colorWithHexString:@"#ffffff"] forState:(UIControlStateNormal)];
    [backView addSubview:totalMoneyLabel];
    [totalMoneyLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView.centerX);
        make.top.equalTo(backView.top).offset(10);
    }];
    
    UIButton *questionTotalBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [questionTotalBtn setImage:[UIImage imageNamed:@"我的_小问号_03_1702"] forState:(UIControlStateNormal)];
    [questionTotalBtn addTarget:self action:@selector(indevertAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [backView addSubview:questionTotalBtn];
    [questionTotalBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(totalMoneyLabel.centerY);
        make.right.equalTo(totalMoneyLabel.left).offset(4);
        make.width.height.equalTo(@36);
    }];
    
    UIButton *eyeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [eyeBtn setImage:[UIImage imageNamed:@"我的_眼睛（关闭）_03_1702"] forState:(UIControlStateSelected)];
    [eyeBtn setImage:[UIImage imageNamed:@"我的_眼睛（睁开）_06_1702"] forState:(UIControlStateNormal)];
    [eyeBtn addTarget:self action:@selector(eyeBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    self.eyeBtn = eyeBtn;
    [backView addSubview:eyeBtn];
    [eyeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(totalMoneyLabel.centerY);
        make.left.equalTo(totalMoneyLabel.right).offset(-4);
        make.width.height.equalTo(@38);
        
    }];
    
    
    [backView addSubview:self.totalMoneyText];
    [self.totalMoneyText makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView.centerX);
        make.top.equalTo(totalMoneyLabel.bottom);
    }];
    
    [backView addSubview:self.onRoadMoneyLabel];
    [self.onRoadMoneyLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalMoneyText.bottom).offset(5);
        make.centerX.equalTo(backView.centerX);
    }];
    
    UILabel *indevertLabel = [[UILabel alloc]init];
    self.indevertLabel = indevertLabel;
    indevertLabel.text = @"投标中资金";
    indevertLabel.textColor = [HXColor colorWithHexString:@"#ffffff"];
    indevertLabel.font = [UIFont systemFontOfSize:13];
    [backView addSubview:indevertLabel];
    [indevertLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.onRoadMoneyLabel.bottom).offset(10);
        make.centerX.equalTo(backView.centerX).dividedBy(3);
    }];
    
    [backView addSubview:self.indevertText];
    [self.indevertText makeConstraints:^(MASConstraintMaker *make) {
        if (KProjectScreenWidth > 320) {
            make.top.equalTo(indevertLabel.bottom).offset(8);
        }else{
            make.top.equalTo(indevertLabel.bottom).offset(4);
            
        }
        
        
        make.centerX.equalTo(indevertLabel.centerX);
        make.width.equalTo(KProjectScreenWidth / 3);
    }];
    
    UILabel *expectedLabel = [[UILabel alloc]init];
    self.expectedLabel = expectedLabel;
    expectedLabel.text = @"预期收益";
    expectedLabel.font = [UIFont systemFontOfSize:13];
    expectedLabel.textColor = [HXColor colorWithHexString:@"#ffffff"];
    [backView addSubview:expectedLabel];
    [expectedLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(indevertLabel.top);
        make.centerX.equalTo(backView.centerX);
    }];
    
    [backView addSubview:self.expectedText];
    [self.expectedText makeConstraints:^(MASConstraintMaker *make) {
        if (KProjectScreenWidth > 320) {
            make.top.equalTo(expectedLabel.bottom).offset(8);
        }else{
            make.top.equalTo(expectedLabel.bottom).offset(4);
            
        }
        make.centerX.equalTo(expectedLabel.centerX);
        make.width.equalTo(KProjectScreenWidth / 3);
    }];
    
    
    UILabel *usingLabel = [[UILabel alloc]init];
    usingLabel.text = @"可用余额";
    usingLabel.textAlignment = NSTextAlignmentCenter;
    self.usingLabel = usingLabel;
    usingLabel.textColor = [HXColor colorWithHexString:@"#ffffff"];
    usingLabel.font = [UIFont systemFontOfSize:13];
    [backView addSubview:usingLabel];
    [usingLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(indevertLabel.top);
        //        make.centerX.equalTo(backView.centerX).multipliedBy(5/3);
        make.right.equalTo(backView.right);
        make.width.equalTo(KProjectScreenWidth / 3);
    }];
    
    [backView addSubview:self.usingText];
    [self.usingText makeConstraints:^(MASConstraintMaker *make) {
        if (KProjectScreenWidth > 320) {
            make.top.equalTo(usingLabel.bottom).offset(8);
        }else{
            make.top.equalTo(usingLabel.bottom).offset(4);
            
        }
        make.centerX.equalTo(usingLabel.centerX);
        make.width.equalTo(KProjectScreenWidth / 3);
    }];
    
    
    UIView *midBackView = [[UIView alloc]init];
    midBackView.userInteractionEnabled = YES;
    
    midBackView.backgroundColor = [HXColor colorWithHexString:@"#ffffff"];
    [self addSubview:midBackView];
    [midBackView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(backView.bottom);
        if (KProjectScreenWidth > 320) {
            make.height.equalTo(@50);
        }else{
            make.height.equalTo(@40);
            
        }
        
    }];
    
    UIView *grayView = [[UIView alloc]init];
    grayView.backgroundColor = [HXColor colorWithHexString:@"#f4f5f9"];
    [midBackView addSubview:grayView];
    [grayView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(midBackView.top).offset(7);
        make.bottom.equalTo(midBackView.bottom).offset(-7);
        make.centerX.equalTo(self.centerX);
        make.width.equalTo(@1);
    }];
    
    UIButton *quxianButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [quxianButton addTarget:self action:@selector(quxianAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [quxianButton setTitle:@"取现" forState:UIControlStateNormal];
    quxianButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [quxianButton setTitleColor:[HXColor colorWithHexString:@"#0099e9"] forState:UIControlStateNormal];
    [midBackView addSubview:quxianButton];
    [quxianButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(midBackView.top);
        make.left.equalTo(midBackView.left);
        make.bottom.equalTo(midBackView.bottom);
        make.right.equalTo(grayView.left);
    }];
    UIButton *rechargeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [rechargeButton addTarget:self action:@selector(rechargeAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [rechargeButton setTitle:@"充值" forState:UIControlStateNormal];
    rechargeButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [rechargeButton setTitleColor:[HXColor colorWithHexString:@"#0099e9"] forState:UIControlStateNormal];
    [midBackView addSubview:rechargeButton];
    [rechargeButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(midBackView.top);
        make.left.equalTo(grayView.right);
        make.bottom.equalTo(midBackView.bottom);
        make.right.equalTo(midBackView.right);
    }];
    
    UIView *downBackView = [[UIView alloc]init];
    downBackView.userInteractionEnabled = YES;
    downBackView.backgroundColor = [HXColor colorWithHexString:@"#f4f5f9"];
    self.downBackView = downBackView;
    [self addSubview:downBackView];
    [downBackView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(midBackView.bottom);
        make.height.equalTo(@40);
    }];
    
    UIButton *goTestButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [goTestButton addTarget:self action:@selector(goTestAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [goTestButton setTitle:@"去评估" forState:UIControlStateNormal];
    goTestButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [goTestButton setBackgroundImage:[UIImage imageNamed:@"我的_去评估按钮_14_1702"] forState:UIControlStateNormal];
    [goTestButton setTitleColor:[HXColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [downBackView addSubview:goTestButton];
    [goTestButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(downBackView.right).offset(-15);
        make.centerY.equalTo(downBackView.centerY);
        make.width.equalTo(@90);
    }];
    
    UILabel *testLabel = [[UILabel alloc]init];
    testLabel.text = @"您尚未进行风险承受能力评估";
    self.testLabel = testLabel;
    testLabel.textColor = [HXColor colorWithHexString:@"#333333"];
    if (KProjectScreenWidth < 350) {
        testLabel.font = [UIFont systemFontOfSize:15];
    }else {
        testLabel.font = [UIFont systemFontOfSize:16];
    }
    [downBackView addSubview:testLabel];
    [testLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(downBackView.left).offset(15);
        make.centerY.equalTo(downBackView.centerY);
        make.right.equalTo(goTestButton.left);
    }];
    
    
}

- (void)goTestAction:(UIButton *)sender{
    
    if (self.goTestBlock) {
        self.goTestBlock(sender);
    }
}

/** 资产总额数 */
- (UILabel *)totalMoneyText{
    if (!_totalMoneyText) {
        _totalMoneyText = [[UILabel alloc]init];
        _totalMoneyText.text = @"0.00";
        _totalMoneyText.textColor = [HXColor colorWithHexString:@"#ffffff"];
        if (KProjectScreenWidth > 320) {
            _totalMoneyText.font = [UIFont systemFontOfSize:40];
            
        }else{
            _totalMoneyText.font = [UIFont systemFontOfSize:34];
            
            
        }
    }
    return _totalMoneyText;
}
/** 在途资金数 */
- (UILabel *)onRoadMoneyLabel{
    if (!_onRoadMoneyLabel) {
        _onRoadMoneyLabel = [[UILabel alloc]init];
        _onRoadMoneyLabel.text = @"含0.00元冻结资金";
        _onRoadMoneyLabel.textColor = [HXColor colorWithHexString:@"#ffffff"];
        _onRoadMoneyLabel.font = [UIFont systemFontOfSize:13];
        
    }
    return _onRoadMoneyLabel;
}
/** 投标中资金数 */
-(UILabel *)indevertText{
    if (!_indevertText) {
        _indevertText = [[UILabel alloc]init];
        _indevertText.text = @"0.00";
        _indevertText.textColor = [HXColor colorWithHexString:@"#ffffff"];
        _indevertText.font = [UIFont systemFontOfSize:18];
        _indevertText.numberOfLines = 0;
        _indevertText.textAlignment = NSTextAlignmentCenter;
        
    }
    return _indevertText;
}
/** 预期收益 */
- (UILabel *)expectedText{
    if (!_expectedText) {
        _expectedText = [[UILabel alloc]init];
        _expectedText.text = @"0.00";
        _expectedText.font = [UIFont systemFontOfSize:18];
        _expectedText.textColor = [HXColor colorWithHexString:@"#ffffff"];
        _expectedText.numberOfLines = 0;
        _expectedText.textAlignment = NSTextAlignmentCenter;
        
    }
    return _expectedText;
}
/** 可用余额 */
- (UILabel *)usingText {
    if (!_usingText) {
        _usingText = [[UILabel alloc]init];
        _usingText.font = [UIFont systemFontOfSize:18];
        _usingText.textColor = [HXColor colorWithHexString:@"#ffffff"];
        _usingText.text = @"0.00";
        _usingText.numberOfLines = 0;
        _usingText.textAlignment = NSTextAlignmentCenter;
    }
    return _usingText;
}
/** 取现 按钮事件 */
- (void)quxianAction:(UIButton *)sender {
    if (self.quxianBlock) {
        self.quxianBlock(sender);
    }
}
/** 充值 按钮事件 */
- (void)rechargeAction:(UIButton *)sender {
    if (self.rechargeBlock) {
        self.rechargeBlock(sender);
    }
}
/** 按钮事件 */
- (void)indevertAction:(UIButton *)sender {
    if (self.indevertBlock) {
        self.indevertBlock(sender);
    }
    
}

- (void)eyeBtnClick:(UIButton *)button{
    
    self.isEye = !self.isEye;
    
    [[NSUserDefaults standardUserDefaults] setObject:[CurrentUserInformation sharedCurrentUserInfo].userId forKey:@"IsEyeUser_Id"];
    
    [[NSUserDefaults standardUserDefaults] setBool:self.isEye forKey:@"IsEye"];
    
    if (self.isEye) {
        self.eyeBtn.selected = NO;
        self.totalMoneyText.text = self.eyeModel.zichanzongshu;
        self.onRoadMoneyLabel.text = [NSString stringWithFormat:@"包含%@元冻结资金",self.eyeModel.dongjiezhong];
        self.indevertText.text = self.eyeModel.toubiaozhong;
        self.expectedText.text = self.eyeModel.yuqishouyi;
        self.usingText.text = self.eyeModel.keyong;
        
    }else{
        self.eyeBtn.selected = YES;
        self.totalMoneyText.text = @"******";
        self.onRoadMoneyLabel.text = @"包含****元冻结资金";
        self.indevertText.text = @"****";
        self.expectedText.text = @"****";
        self.usingText.text = @"****";
        
    }
 //   NSLog(@"%s",__func__);
}
- (void)sendDataWithmodel:(FMMineModel *)model IsDone:(NSString *)isDone IsInvalid:(NSString *)isInvalid {
    
    self.eyeModel = model;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"IsEyeUser_Id"] isEqualToString:[NSString stringWithFormat:@"%@", [CurrentUserInformation sharedCurrentUserInfo].userId]]) {
        
        self.isEye = [[NSUserDefaults standardUserDefaults] boolForKey:@"IsEye"];
        
        [[NSUserDefaults standardUserDefaults] setObject:[CurrentUserInformation sharedCurrentUserInfo].userId forKey:@"IsEyeUser_Id"];
        
    }else{
        
        self.isEye = YES;
        
        [[NSUserDefaults standardUserDefaults] setBool:self.isEye forKey:@"IsEye"];
        
        [[NSUserDefaults standardUserDefaults] setObject:[CurrentUserInformation sharedCurrentUserInfo].userId forKey:@"IsEyeUser_Id"];
        
        
    }
    
    
    if (self.isEye) {
        self.totalMoneyText.text = model.zichanzongshu;
        self.onRoadMoneyLabel.text = [NSString stringWithFormat:@"包含%@元冻结资金",model.dongjiezhong];
        self.indevertText.text = model.toubiaozhong;
        self.expectedText.text = model.yuqishouyi;
        self.usingText.text = model.keyong;
        self.eyeBtn.selected = NO;
        
        
    }else{
        self.totalMoneyText.text = @"******";
        self.onRoadMoneyLabel.text = @"包含****元冻结资金";
        self.indevertText.text = @"****";
        self.expectedText.text = @"****";
        self.usingText.text = @"****";
        self.eyeBtn.selected = YES;
        
        
    }
    
 //   self.indevertText.text = @"99999999.99";
  //  self.expectedText.text = @"99999999.99";
  //  self.usingText.text = @"99999999.99";
    
    //    model.dongjiezhong = @"666.66";
    if ([[CurrentUserInformation sharedCurrentUserInfo].fengxianwenjuanwode integerValue] == 1) {  //显示
        
        if ([isDone isEqualToString:@"0"]) { //0未完成, 1已完成
            [self.downBackView setHidden:NO];
            self.testLabel.text = @"您尚未进行风险承受能力评估";
            
        }else{
            
            if ([isInvalid isEqualToString:@"1"]) {
                
                [self.downBackView setHidden:NO];
                self.testLabel.text = @"您的风险承受能力评估已过期";
                
                
            }else{
                
                [self.downBackView setHidden:YES];
                
            }
        }
    }else{
        
        [self.downBackView setHidden:YES];
        
    }
    
    //    model.dongjiezhong = @"0.01";
    if (!([model.dongjiezhong doubleValue] > 0)) {
        
        // 投标中资金
        [self.indevertLabel remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.onRoadMoneyLabel.bottom).offset(10);
            make.centerX.equalTo(self.centerX).dividedBy(3);
        }];
        [self.onRoadMoneyLabel setHidden:YES];
        
    }else{
        
        
        [self.indevertLabel remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.onRoadMoneyLabel.bottom).offset(10);
            make.centerX.equalTo(self.centerX).dividedBy(3);
        }];
        
        [self.onRoadMoneyLabel setHidden:NO];
        
    }
    
}
-(void)sendDataWithIsDone:(NSString *)isDone IsInvalid:(NSString *)isInvalid{
    
    if ([[CurrentUserInformation sharedCurrentUserInfo].fengxianwenjuanwode integerValue] == 1) {  //显示
        
        if ([isDone isEqualToString:@"0"]) { //0未完成, 1已完成
            [self.downBackView setHidden:NO];
            self.testLabel.text = @"您尚未进行风险承受能力评估";
            
        }else{
            
            if ([isInvalid isEqualToString:@"1"]) {
                
                [self.downBackView setHidden:NO];
                self.testLabel.text = @"您的风险承受能力评估已过期";
                
            }else{
                
                [self.downBackView setHidden:YES];
                
            }
        }
    }else{
        
        [self.downBackView setHidden:YES];
        
    }
    
    
}
@end
