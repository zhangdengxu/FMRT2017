//
//  YYChangeBankCardViewController.m
//  fmapp
//
//  Created by yushibo on 2017/5/15.
//  Copyright © 2017年 yk. All rights reserved.
//  更换银行卡

#import "YYChangeBankCardViewController.h"
#import "FMKeyBoardNumberHeader.h"
#import "YYWarmPromptView.h"  //温馨提示
#import "WLChangePhoneNumberViewController.h" //更换手机号
#import "WLRechargeController.h"  //支持银行
#import "LLPaySdk.h"
#import "NSString+Extension.h"
#import "XZMyBankModel.h"
#import "FMTieBankResultView.h"
#import "ShareViewController.h"
#import "XZBankRechargeModel.h"

@interface YYChangeBankCardViewController ()<UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITextField *xinCardNumText;
@property (nonatomic, strong) UIImageView *selecteView;
@property (nonatomic, assign) BOOL tag;


@property (nonatomic, weak) UILabel *useNameLabel;
@property (nonatomic, weak) UILabel *usePhoneLabel;
@property (nonatomic, weak) UILabel *ordNumLabel;
@property (nonatomic, strong) FMChangeBankCardViewModel * viewModel;
//@property (nonatomic, strong) XZBankRechargeUserModel *modelBankUser;

@end

@implementation YYChangeBankCardViewController

//-(XZBankRechargeUserModel *)modelBankUser
//{
//    if (!_modelBankUser) {
//        _modelBankUser = [[XZBankRechargeUserModel alloc]init];
//    }
//    return _modelBankUser;
//}
-(FMChangeBankCardViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[FMChangeBankCardViewModel alloc]init];
        
    }
    return _viewModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"更换银行卡"];
    self.view.backgroundColor = [HXColor colorWithHexString:@"#f4f5f9"];
    [self createContentView];
    
    [self createData];
    
//    [self getRechargeViewData];
    
}


-(void)setModelMyBank:(XZMyBankModel *)modelMyBank
{
    _modelMyBank = modelMyBank;
    
}

-(void)createData
{
    
    self.viewModel.personNumberCard = [CurrentUserInformation sharedCurrentUserInfo].shenfenzhenghao,
    self.viewModel.BankCode = self.modelMyBank.BankCode;//银行卡号
    self.viewModel.BankName = self.modelMyBank.BankName;//银行卡名
    self.viewModel.bankCardId = [NSString stringWithFormat:@"%zi",self.modelMyBank.Id];//银行卡id
    
    self.useNameLabel.text = [CurrentUserInformation sharedCurrentUserInfo].zhenshiname;
    self.viewModel.name = [CurrentUserInformation sharedCurrentUserInfo].zhenshiname;
    self.usePhoneLabel.text =  [CurrentUserInformation sharedCurrentUserInfo].mobile;
    self.viewModel.phoneNumber =  [CurrentUserInformation sharedCurrentUserInfo].mobile;
    self.ordNumLabel.text = [NSString retNSStringWithSecret:self.modelMyBank.No withBegin:4 withEnding:4 WithStarCount:4];
    self.viewModel.bankCardNumber = self.modelMyBank.No;
}
- (void)createContentView{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight -64)];
    scrollView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
//    scrollView.delegate = self;
    // 设置内容大小
    if (KProjectScreenWidth > 320) {
        scrollView.contentSize = CGSizeMake(0, KProjectScreenHeight - 64);

    }else{
        scrollView.contentSize = CGSizeMake(0, KProjectScreenHeight +100);

    }
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.scrollEnabled = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.userInteractionEnabled = YES;
    
    
    UIView * contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight +100)];
    
    contentView.backgroundColor = [HXColor colorWithHexString:@"#f4f5f9"];
    [scrollView addSubview:contentView];
    
    [self.view addSubview:scrollView];
    
    
/**
 *  第一部分
 */
    
    CGFloat itemHeigh;
    CGFloat hangMargion;
    CGFloat widthWithLabel;
    if (KProjectScreenWidth < 350) {
        itemHeigh = 40;
        hangMargion = 7;
        widthWithLabel = 60;
    }else if (KProjectScreenWidth < 400)
    {
        itemHeigh = 50;
        hangMargion = 7;
        widthWithLabel = 70;
    }else
    {
        itemHeigh = 60;
        hangMargion = 9;
        widthWithLabel = 75;
    }
    
    UIView *backViewhang1 = [[UIView alloc]init];
    backViewhang1.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:backViewhang1];
    [backViewhang1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(contentView.mas_top).offset(10);
        make.height.equalTo(itemHeigh);
    }];
    
    
    /**  真实姓名 */
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.backgroundColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = [UIColor colorWithHexString:@"#333"];
    if (KProjectScreenWidth < 350) {
        nameLabel.font = [UIFont systemFontOfSize:15];
    }else if (KProjectScreenWidth < 400)
    {
        nameLabel.font = [UIFont systemFontOfSize:16];
    }else
    {
        nameLabel.font = [UIFont systemFontOfSize:17];
    }
    
    nameLabel.text = @"真实姓名";
    [backViewhang1 addSubview:nameLabel];
    [nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backViewhang1.mas_left).offset(5);
        make.centerY.equalTo(backViewhang1.mas_centerY);
        make.height.equalTo(itemHeigh);
        make.width.mas_equalTo(widthWithLabel);
    }];
    
    UILabel *useNameLabel = [[UILabel alloc]init];
    self.useNameLabel = useNameLabel;
    useNameLabel.textAlignment = NSTextAlignmentLeft;
    useNameLabel.backgroundColor = [UIColor whiteColor];
    useNameLabel.textColor = [UIColor colorWithHexString:@"#333"];
    if (KProjectScreenWidth < 350) {
        useNameLabel.font = [UIFont systemFontOfSize:14];
    }else if (KProjectScreenWidth < 400)
    {
        useNameLabel.font = [UIFont systemFontOfSize:15];
    }else
    {
        useNameLabel.font = [UIFont systemFontOfSize:16];
    }

    
    [backViewhang1 addSubview:useNameLabel];
    [useNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_right).offset(hangMargion - 1);
        make.right.equalTo(backViewhang1.mas_right);
        make.centerY.equalTo(backViewhang1.mas_centerY);
        make.height.equalTo(itemHeigh);
        
        
    }];
    
    
    
    UIView *backViewhang2 = [[UIView alloc]init];
    backViewhang2.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:backViewhang2];
    [backViewhang2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(backViewhang1.mas_bottom).offset(1);
        make.height.equalTo(itemHeigh);
    }];
    
    /**  手机号 */
    UILabel *phoneLabel = [[UILabel alloc]init];
    phoneLabel.backgroundColor = [UIColor whiteColor];
    phoneLabel.textAlignment = NSTextAlignmentLeft;
    phoneLabel.textColor = [UIColor colorWithHexString:@"#333"];
    if (KProjectScreenWidth < 350) {
        phoneLabel.font = [UIFont systemFontOfSize:15];
    }else if (KProjectScreenWidth < 400)
    {
        phoneLabel.font = [UIFont systemFontOfSize:16];
    }else
    {
        phoneLabel.font = [UIFont systemFontOfSize:17];
    }

    phoneLabel.text = @"手机号";
    [backViewhang2 addSubview:phoneLabel];
    [phoneLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backViewhang2.mas_left).offset(5);
        make.centerY.equalTo(backViewhang2.mas_centerY);
        make.width.mas_equalTo(widthWithLabel);
        make.height.equalTo(itemHeigh);
    }];
   
    
    UIImageView *rightRow = [[UIImageView alloc]init];
    rightRow.image = [UIImage imageNamed:@"微商_注册:取现_右箭头"];
    rightRow.contentMode = UIViewContentModeScaleAspectFit;
    [backViewhang2 addSubview:rightRow];
    [rightRow makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backViewhang2.mas_right).offset(-10);
        make.centerY.equalTo(backViewhang2.mas_centerY);
        make.width.equalTo(@15);
    }];

    UILabel *xiuGaiLabel = [[UILabel alloc]init];
    xiuGaiLabel.textColor = [UIColor colorWithHexString:@"#0159d5"];
    xiuGaiLabel.font = [UIFont systemFontOfSize:17];
    if (KProjectScreenWidth < 350) {
        xiuGaiLabel.font = [UIFont systemFontOfSize:13];
    }else if (KProjectScreenWidth < 400)
    {
        xiuGaiLabel.font = [UIFont systemFontOfSize:14];
    }else
    {
        xiuGaiLabel.font = [UIFont systemFontOfSize:15];
    }
    xiuGaiLabel.text = @"修改";
    [backViewhang2 addSubview:xiuGaiLabel];
    [xiuGaiLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightRow.mas_left);
        make.centerY.equalTo(backViewhang2.mas_centerY);
    }];
    
   
    
    /**  修改按钮点击事件 */
    UIButton *xiuGaiBtn = [[UIButton alloc]init];
    [xiuGaiBtn addTarget:self action:@selector(xiuGaiBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [backViewhang2 addSubview:xiuGaiBtn];
    [xiuGaiBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(backViewhang2);
        make.left.equalTo(xiuGaiLabel.mas_left);
        make.right.equalTo(rightRow.mas_right);
    }];


    UILabel *usePhoneLabel = [[UILabel alloc]init];
    self.usePhoneLabel = usePhoneLabel;
    usePhoneLabel.textAlignment = NSTextAlignmentLeft;
    usePhoneLabel.backgroundColor = [UIColor whiteColor];
    usePhoneLabel.textColor = [UIColor colorWithHexString:@"#333"];
    if (KProjectScreenWidth < 350) {
        usePhoneLabel.font = [UIFont systemFontOfSize:14];
    }else if (KProjectScreenWidth < 400)
    {
        usePhoneLabel.font = [UIFont systemFontOfSize:15];
    }else
    {
        usePhoneLabel.font = [UIFont systemFontOfSize:16];
    }

    [backViewhang2 addSubview:usePhoneLabel];
    [usePhoneLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneLabel.mas_right).offset(hangMargion - 1);
        make.right.equalTo(xiuGaiBtn.mas_left).offset(-8);
        make.centerY.equalTo(phoneLabel.mas_centerY);
        make.height.equalTo(itemHeigh);
    }];
    

    UILabel *beizhu1 = [[UILabel alloc]init];
    beizhu1.textColor = [UIColor colorWithHexString:@"#999"];
    if (KProjectScreenWidth < 350) {
        beizhu1.font = [UIFont systemFontOfSize:11];
    }else if (KProjectScreenWidth < 400)
    {
        beizhu1.font = [UIFont systemFontOfSize:12];
    }else
    {
        beizhu1.font = [UIFont systemFontOfSize:13];
    }
    beizhu1.text = @"您的手机号需与该银行预留手机号保持一致";
    [contentView addSubview:beizhu1];
    [beizhu1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView.mas_centerX);
        make.top.equalTo(backViewhang2.mas_bottom).offset(@6);
    }];

/**
 * 第二部分
 */
    
    UIView *backViewhang3 = [[UIView alloc]init];
    backViewhang3.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:backViewhang3];
    [backViewhang3 makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(beizhu1.mas_bottom).offset(15);
        make.height.equalTo(itemHeigh);
    }];

    
    /**  原借记卡 */
    UILabel *ordCardLabel = [[UILabel alloc]init];
    ordCardLabel.backgroundColor = [UIColor whiteColor];
    ordCardLabel.textAlignment = NSTextAlignmentLeft;
    ordCardLabel.textColor = [UIColor colorWithHexString:@"#333"];
    if (KProjectScreenWidth < 350) {
        ordCardLabel.font = [UIFont systemFontOfSize:15];
    }else if (KProjectScreenWidth < 400)
    {
        ordCardLabel.font = [UIFont systemFontOfSize:16];
    }else
    {
        ordCardLabel.font = [UIFont systemFontOfSize:17];
    }
    ordCardLabel.text = @"原借记卡";
    [backViewhang3 addSubview:ordCardLabel];
    [ordCardLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backViewhang3.mas_left).offset(5);
        make.centerY.equalTo(backViewhang3.mas_centerY);
        make.height.equalTo(itemHeigh);
        make.width.mas_equalTo(widthWithLabel);
    }];
    
    UILabel *ordNumLabel = [[UILabel alloc]init];
    ordNumLabel.textAlignment = NSTextAlignmentLeft;
    ordNumLabel.backgroundColor = [UIColor whiteColor];
    ordNumLabel.textColor = [UIColor colorWithHexString:@"#333"];
    if (KProjectScreenWidth < 350) {
        ordNumLabel.font = [UIFont systemFontOfSize:14];
    }else if (KProjectScreenWidth < 400)
    {
        ordNumLabel.font = [UIFont systemFontOfSize:15];
    }else
    {
        ordNumLabel.font = [UIFont systemFontOfSize:16];
    }
    self.ordNumLabel = ordNumLabel;
    [backViewhang3 addSubview:ordNumLabel];
    [ordNumLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ordCardLabel.mas_right).offset(hangMargion);
        make.right.equalTo(backViewhang3.mas_right);
        make.centerY.equalTo(backViewhang3.mas_centerY);
    }];
    
    /**  银行卡备注 */
    
    UILabel *beizhu2 = [[UILabel alloc]init];
    beizhu2.textColor = [UIColor colorWithHexString:@"#999"];
    if (KProjectScreenWidth < 350) {
        beizhu2.font = [UIFont systemFontOfSize:11];
    }else if (KProjectScreenWidth < 400)
    {
        beizhu2.font = [UIFont systemFontOfSize:12];
    }else
    {
        beizhu2.font = [UIFont systemFontOfSize:13];
    }
    beizhu2.text = @"当您的资产总额为零时,即可自行更换银行卡";
    [contentView addSubview:beizhu2];
    [beizhu2 makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView.mas_centerX);
        make.top.equalTo(backViewhang3.mas_bottom).offset(@6);
    }];

/**
 * 第三部分
 */
    
    UIView *backViewhang4 = [[UIView alloc]init];
    backViewhang4.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:backViewhang4];
    [backViewhang4 makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(beizhu2.mas_bottom).offset(15);
        make.height.equalTo(itemHeigh);
    }];

    
    /**  新借记卡 */
    UILabel *newCardLabel = [[UILabel alloc]init];
    newCardLabel.backgroundColor = [UIColor whiteColor];
    newCardLabel.textAlignment = NSTextAlignmentLeft;
    newCardLabel.textColor = [UIColor colorWithHexString:@"#333"];
    if (KProjectScreenWidth < 350) {
        newCardLabel.font = [UIFont systemFontOfSize:15];
    }else if (KProjectScreenWidth < 400)
    {
        newCardLabel.font = [UIFont systemFontOfSize:16];
    }else
    {
        newCardLabel.font = [UIFont systemFontOfSize:17];
    }

    newCardLabel.text = @"借记卡";
    [backViewhang4 addSubview:newCardLabel];
    [newCardLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backViewhang4.mas_left).offset(5);
        make.centerY.equalTo(backViewhang4.mas_centerY);
        make.height.equalTo(itemHeigh);

        make.width.mas_equalTo(widthWithLabel);
    }];
    
   
    
    UIImageView *rightRow2 = [[UIImageView alloc]init];
    rightRow2.image = [UIImage imageNamed:@"微商_注册:取现_右箭头"];
    rightRow2.contentMode = UIViewContentModeScaleAspectFit;
    [backViewhang4 addSubview:rightRow2];
    [rightRow2 makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backViewhang4.mas_right).offset(-10);
        make.centerY.equalTo(backViewhang4.mas_centerY);
        make.width.equalTo(@15);
    }];
    
    UILabel *bankLabel = [[UILabel alloc]init];
    bankLabel.textColor = [UIColor colorWithHexString:@"#0159d5"];
    if (KProjectScreenWidth < 350) {
        bankLabel.font = [UIFont systemFontOfSize:13];
    }else if (KProjectScreenWidth < 400)
    {
        bankLabel.font = [UIFont systemFontOfSize:14];
    }else
    {
        bankLabel.font = [UIFont systemFontOfSize:15];
    }

    bankLabel.text = @"支持银行";
    [backViewhang4 addSubview:bankLabel];
    [bankLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightRow2.mas_left);
        make.centerY.equalTo(backViewhang4.mas_centerY);
    }];
    
    UITextField *newNumText = [[UITextField alloc]init];
    newNumText.textColor = [HXColor colorWithHexString:@"#999"];
    [newNumText setBackgroundColor:[UIColor whiteColor]];
    [newNumText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [newNumText setReturnKeyType:UIReturnKeyNext];
    [newNumText setClearButtonMode:UITextFieldViewModeNever];
    if (KProjectScreenWidth < 350) {
        newNumText.font = [UIFont systemFontOfSize:14];
    }else if (KProjectScreenWidth < 400)
    {
        newNumText.font = [UIFont systemFontOfSize:15];
    }else
    {
        newNumText.font = [UIFont systemFontOfSize:16];
    }
    newNumText.delegate = self;
    [newNumText setBorderStyle:UITextBorderStyleNone];
    [newNumText setPlaceholder:@"借记卡卡号(必填)"];
    [newNumText setKeyboardType:UIKeyboardTypeNumberPad];
    //    [TXText setDelegate:self];
    __weak __typeof(&*self)weakSelf = self;
    newNumText.inputAccessoryView = [FMKeyBoardNumberHeader initKeyBoardNumberHeaderCreate:^{
        [weakSelf keyBoardDown];
    }];
    self.xinCardNumText=newNumText;
    
    [backViewhang4 addSubview:newNumText];
    [newNumText makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(newCardLabel.mas_right).offset(hangMargion);
        make.right.equalTo(bankLabel.mas_left).offset(-3);
        make.top.equalTo(newCardLabel.mas_top);
        make.height.equalTo(newCardLabel.mas_height);
    }];
    
    
    /**  支持银行点击事件 */
    UIButton *bankBtn = [[UIButton alloc]init];
    [bankBtn addTarget:self action:@selector(bankCanBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [backViewhang4 addSubview:bankBtn];
    [bankBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightRow2.mas_right);
        make.top.bottom.equalTo(backViewhang4);
        make.left.equalTo(bankLabel.mas_left);
        
    }];
    
    UILabel *beizhu3 = [[UILabel alloc]init];
    beizhu3.textColor = [UIColor colorWithHexString:@"#FF6633"];
    if (KProjectScreenWidth < 350) {
        beizhu3.font = [UIFont systemFontOfSize:11];
    }else if (KProjectScreenWidth < 400)
    {
        beizhu3.font = [UIFont systemFontOfSize:12];
    }else
    {
        beizhu3.font = [UIFont systemFontOfSize:13];
    }
    beizhu3.numberOfLines = 0;
    
    beizhu3.text = [NSString stringWithFormat:@"暂不支持各农商行、各银行信用卡、公务卡。该银行卡开户名必须是%@，否则无法绑定无法提现!",[CurrentUserInformation sharedCurrentUserInfo].zhenshiname] ;
    
    [contentView addSubview:beizhu3];
    [beizhu3 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(10);
        make.right.equalTo(contentView.mas_right).offset(-10);

        make.top.equalTo(backViewhang4.mas_bottom).offset(@6);
    }];

/**    
 * 第四部分
 */
    /**  更换按钮 */
    UIButton *beChangeBtn = [[UIButton alloc]init];
    beChangeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    beChangeBtn.backgroundColor = [HXColor colorWithHexString:@"#0159d5"];
    beChangeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [beChangeBtn setTitle:@"更换" forState:UIControlStateNormal];
    [beChangeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [beChangeBtn addTarget:self action:@selector(beChangeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    beChangeBtn.layer.masksToBounds = YES;
    beChangeBtn.layer.cornerRadius = 1.0f;
    [contentView addSubview:beChangeBtn];
    [beChangeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(15);
        make.right.equalTo(contentView.mas_right).offset(-15);
        make.height.equalTo(@40);
        if (KProjectScreenWidth > 375) {
            make.bottom.equalTo(beizhu3.mas_bottom).offset(230);

        }else if(KProjectScreenWidth > 320) {
            make.bottom.equalTo(beizhu3.mas_bottom).offset(180);

        }else{
            make.bottom.equalTo(beizhu3.mas_bottom).offset(160);
        }
    }];
    
    UIImageView *selectView = [[UIImageView alloc]init];
    [selectView setImage:[UIImage imageNamed:@"微商_注册:取现_选择1"]];
    [contentView addSubview:selectView];
    self.selecteView = selectView;
    [selectView makeConstraints:^(MASConstraintMaker *make) {
        if (KProjectScreenWidth > 320) {
            make.left.equalTo(beChangeBtn.mas_left);

        }else{
            make.left.equalTo(beChangeBtn.mas_left).offset(-3);

        }
        make.bottom.equalTo(beChangeBtn.mas_top).offset(-15);
    }];
    
    UILabel *yueduL = [[UILabel alloc]init];
    yueduL.textColor = [UIColor colorWithHexString:@"#333"];
    if (KProjectScreenWidth > 320) {
        yueduL.font = [UIFont systemFontOfSize:12];
        
    }else{
        yueduL.font = [UIFont systemFontOfSize:11];
        
    }

    yueduL.text = @"我已阅读并同意";
    [contentView addSubview:yueduL];
    [yueduL makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectView.mas_right).offset(2);
//        make.right.equalTo(contentView.mas_right).offset(-10);
        
        make.centerY.equalTo(selectView.mas_centerY);
    }];

    /**  协议规则按钮 */
    UIButton *ruleBtn = [[UIButton alloc]init];
    
    if (KProjectScreenWidth > 320) {
        ruleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];

    }else{
        ruleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:11];

    }
    [ruleBtn setTitle:@"《徽商银行网络交易资金账户服务三方协议》" forState:UIControlStateNormal];
    [ruleBtn setTitleColor:[HXColor colorWithHexString:@"#0159D5"] forState:UIControlStateNormal];
    [ruleBtn addTarget:self action:@selector(ruleBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:ruleBtn];
    [ruleBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yueduL.mas_right);
        make.centerY.equalTo(yueduL.mas_centerY);
        
    }];
    /**  选择已阅读 覆盖 按钮 */
    UIButton *readBtn = [[UIButton alloc]init];
    [readBtn addTarget:self action:@selector(readBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:readBtn];
    [readBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@30);
        make.center.equalTo(selectView);
        
    }];
    
    [self readBtnAction:readBtn];

    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    //身份证号
    NSString * contentString;
    if (string.length == 0 ) {
        if (textField.text.length > 0) {
            contentString = [textField.text substringToIndex:textField.text.length - 1];
        }else
        {
            contentString = nil;
        }
    }else{
        contentString = [NSString stringWithFormat:@"%@%@",textField.text,string];
    }
    
    if (textField == self.xinCardNumText) {
        //姓名
        self.viewModel.xinBankCardNumber = contentString;
    }else
    {
        
    }
    
    return YES;
}

/** 选择已阅读 覆盖 按钮 */
- (void)readBtnAction:(UIButton *)button{
    self.tag = !self.tag;
    if (self.tag) {
        [self.selecteView setImage:[UIImage imageNamed:@"微商_选择"]];
    }else{
        [self.selecteView setImage:[UIImage imageNamed:@"微商_注册:取现_选择1"]];
        
    }
    NSLog(@"%s",__func__);
}

/** 徽商银行网络交易资金账户服务三方协议 */
- (void)ruleBtnAction{
    
//    NSLog(@"%s",__func__);
    
    if ([CurrentUserInformation sharedCurrentUserInfo].statusNetWork == 1) {
        ShareViewController *shareVc = [[ShareViewController alloc] initWithTitle:@"徽商银行网络交易资金账户服务三方协议" AndWithShareUrl:[NSString stringWithFormat:@"%@",kFMPhpUniversalBaseUrl(@"rongtuoxinsoc/helpzhongxin/huishangsanfangxieyi")]];
        [self.navigationController pushViewController:shareVc animated:YES];
    }else
    {
        ShareViewController *shareVc = [[ShareViewController alloc] initWithTitle:@"徽商银行网络交易资金账户服务三方协议" AndWithShareUrl:[NSString stringWithFormat:@"%@",kXZWebViewUrl(@"/esb/NetTransProtocol.html")]];
        [self.navigationController pushViewController:shareVc animated:YES];
    }
    
    
}

/** 更换按钮 */
- (void)beChangeBtnAction{
    //判断账户月
    
    if (!self.tag) {
        //选择徽商银行电子账户协议
        [self showAlterNSstring:@"请阅读《徽商银行网络交易资金账户服务三方协议》！"];
        return;

    }
    
    
    if (self.viewModel.xinBankCardNumber.length == 0) {
        [self showAlterNSstring:@"请填写借记卡卡号！"];
        return;
    }
    
    [self breaksAndbandingCard];
   
   
}


//
//#pragma mark ---- 获取账户资产数据
//- (void)getRechargeViewData {
//    
//    __weak __typeof(&*self)weakSelf = self;
//    int timestamp = [[NSDate date] timeIntervalSince1970];
//    
//    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
//    NSString *tokenlow = [token lowercaseString];
//    NSDictionary *parameter = @{
//                                @"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
//                                @"AppId":@"huiyuan",
//                                @"AppTime":[NSNumber numberWithInt:timestamp],
//                                @"Token":tokenlow,
//                                @"FlagChnl":@1
//                                };
//
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    // kXZRechargeUrl
//    [FMHTTPClient postPath:kXZUniversalTestUrl(@"LLQueryEBankAcct") parameters:parameter completion:^(WebAPIResponse *response) {
//        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
//        if (response.responseObject) {
//            //            [weakSelf.arrRechargeBank removeAllObjects];
//            if (response.code == WebAPIResponseCodeSuccess) {
//                NSDictionary *data = response.responseObject[@"data"];
//                if ([data isKindOfClass:[NSDictionary class]]) {
//                    XZBankRechargeUserModel *modelBankUser = [[XZBankRechargeUserModel alloc] init];
//                    [modelBankUser setValuesForKeysWithDictionary:data];
//                    self.modelBankUser = modelBankUser;
//                }else {
//                    ShowAutoHideMBProgressHUD(weakSelf.view, response.responseObject[@"msg"]);
//                }
//            }else {
//                ShowAutoHideMBProgressHUD(weakSelf.view, response.responseObject[@"msg"]);
//            }
//        }else {
//            ShowAutoHideMBProgressHUD(weakSelf.view, @"数据加载失败");
//        }
//    }];
//    
//}
#pragma -mark 解卡链接网络请求
-(void)breaksAndbandingCard
{
    
    NSString * url = kXZUniversalTestUrl(@"SignCardCancel");
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"AppId":@"huiyuan",
                                 @"AppTime":[NSNumber numberWithInt:timestamp],
                                 @"Token":tokenlow,
                                 @"SigCard":self.viewModel.bankCardNumber,
                                 @"NewSigCard":self.viewModel.xinBankCardNumber,
                                 @"FlagChnl":@1,
                                 @"CmdId":@"SignCardCancel"
                                 };
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:url parameters:parameter completion:^(WebAPIResponse *response) {
        
          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (response.code == WebAPIResponseCodeSuccess) {
            
            [CurrentUserInformation sharedCurrentUserInfo].weishangbang = @"0";
            [self payWithNetWork];
            
        }
        else
        {
          
            NSString * status =  response.responseObject[@"status"];
            if (![status isMemberOfClass:[NSNull class]]) {
                NSInteger staNum = [status integerValue];
                if (staNum == 1) {
                    NSString * msg = response.responseObject[@"msg"];
                    if (![msg isMemberOfClass:[NSNull class]]) {
                        
                        if ([msg isEqualToString:@"银行卡已解绑成功!"]) {
                            [CurrentUserInformation sharedCurrentUserInfo].weishangbang = @"0";
                            [self payWithNetWork];
                        }else
                        {
                            ShowAutoHideMBProgressHUD(self.view, response.responseObject[@"msg"]);
                        }
                        
                    }else
                    {
                        ShowAutoHideMBProgressHUD(self.view, @"网络不好，请稍后重试！");

                    }
                   
                    
                }else
                {
                    ShowAutoHideMBProgressHUD(self.view, @"网络不好，请稍后重试！");
                }
            }else
            {
                ShowAutoHideMBProgressHUD(self.view, @"网络不好，请稍后重试！");
                
            }
        }
    }];
    

}

#pragma mark - 签约绑卡
-(void)payWithNetWork
{
    
    NSString * url = kXZUniversalTestUrl(@"Signcreatebill");
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"AppId":@"huiyuan",
                                 @"AppTime":[NSNumber numberWithInt:timestamp],
                                 @"Token":tokenlow,
                                 @"IdNo":self.viewModel.personNumberCard,
                                 @"AcctName":self.viewModel.name,
                                 @"CardNo":self.viewModel.xinBankCardNumber,
                                 @"BindMob":self.viewModel.phoneNumber,
                                 @"FlagChnl":@1,
                                 @"CmdId":@"Signcreatebill"
                                 
                                 };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    /**FlagChnl 标记位 iOS端必须传1   !!!  **/
    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient postPath:url parameters:parameter completion:^(WebAPIResponse *response) {
          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (response.code == WebAPIResponseCodeSuccess) {
            NSDictionary * dict = response.responseObject[@"data"];
            if (![dict isMemberOfClass:[NSNull class]]) {
                
                NSMutableDictionary * dictMu = [NSMutableDictionary dictionary];
                dictMu[@"token"] = dict[@"token"]?:@"";
                dictMu[@"user_id"] = [CurrentUserInformation sharedCurrentUserInfo].userId?:@"";
                dictMu[@"oid_partner"] = dict[@"oid_partner"]?:@"";
                dictMu[@"no_order"] = dict[@"no_order"]?:@"";
                
                [weakSelf payAllDataSourceWithLLPay:dictMu];
                
            }else
            {
                ShowAutoHideMBProgressHUD(self.view, response.responseObject[@"msg"]);
            }
        }else
        {
            
            NSString * status =  response.responseObject[@"status"];
            if (![status isMemberOfClass:[NSNull class]]) {
                NSInteger staNum = [status integerValue];
                if (staNum == 1) {
                    ShowAutoHideMBProgressHUD(self.view, response.responseObject[@"msg"]);
                    
                }else
                {
                    ShowAutoHideMBProgressHUD(self.view, @"网络不好，请稍后重试！");
                }
            }else
            {
                ShowAutoHideMBProgressHUD(self.view, @"网络不好，请稍后重试！");
                
            }
        }
    }];
    
    
    
}


-(void)payAllDataSourceWithLLPay:(NSDictionary *)paymentInfohehe
{
    NSMutableDictionary *paymentInfo = [[NSMutableDictionary alloc]initWithDictionary:paymentInfohehe];
     __weak __typeof(&*self)weakSelf = self;
    //调用SDK签约绑卡
    [[LLPaySdk sharedSdk] signApply:[paymentInfo copy] inVC:self completion:^(LLPayResult result, NSDictionary *dic) {
        [weakSelf paymentEnd:result withResultDic:dic];
    }];
}


- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic{
    NSString *msg = @"异常";
    switch (resultCode) {
        case kLLPayResultSuccess: {
            msg = @"成功";
        } break;
        case kLLPayResultFail: {
            msg = @"失败";
        } break;
        case kLLPayResultCancel: {
            msg = @"取消";
        } break;
        case kLLPayResultInitError: {
            msg = @"sdk初始化异常";
        } break;
        case kLLPayResultInitParamError: {
            msg = dic[@"ret_msg"];
        } break;
        default:
            break;
    }
    NSString *showMsg = dic[@"ret_msg"];
    
    NSString *ret_code = dic[@"ret_code"];
    if ([ret_code isEqualToString:@"0000"]) {
        //解绑卡成功
        [self createRegistAcctNo];
    }else
    {
        [self showAlterNSstring:showMsg];
    }
    
}
-(void)createRegistAcctNo
{
    
    NSString * url = kXZUniversalTestUrl(@"SignCard");
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"AppId":@"huiyuan",
                                 @"AppTime":[NSNumber numberWithInt:timestamp],
                                 @"Token":tokenlow,
                                 @"SigCard":self.viewModel.xinBankCardNumber,
                                 @"Mobile":self.viewModel.phoneNumber,
                                 @"CmdId":@"SignCard",
                                 @"FlagChnl":@1
                                 };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:url parameters:parameter completion:^(WebAPIResponse *response) {
          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (response.code == WebAPIResponseCodeSuccess) {
            NSDictionary * dict = response.responseObject[@"data"];
            if (![dict isMemberOfClass:[NSNull class]]) {
                
                [CurrentUserInformation sharedCurrentUserInfo].weishangbang = @"1";

                //绑定电子账单结果
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"银行卡换卡成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alert.tag = 1919;
                [alert show];
                
            }else
            {
                ShowAutoHideMBProgressHUD(self.view, response.responseObject[@"msg"]);
            }
        }else
        {
            NSString * status =  response.responseObject[@"status"];
            if (![status isMemberOfClass:[NSNull class]]) {
                NSInteger staNum = [status integerValue];
                if (staNum == 1) {
                    ShowAutoHideMBProgressHUD(self.view, response.responseObject[@"msg"]);
                }else
                {
                    ShowAutoHideMBProgressHUD(self.view, @"网络不好，请稍后重试！");
                }
            }else
            {
                ShowAutoHideMBProgressHUD(self.view, @"网络不好，请稍后重试！");
            }
        }
        
        
        
    }];

}
//弹出提示框
-(void)showAlterNSstring:(NSString *)contentString
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:contentString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0);
{
    if(alertView.tag == 1919){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/** 修改手机号 */
- (void)xiuGaiBtnAction{
    
    WLChangePhoneNumberViewController *changePhone = [[WLChangePhoneNumberViewController alloc]init];
    changePhone.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:changePhone animated:YES];

}
/** 支持银行 */
- (void)bankCanBtnAction{
    
    WLRechargeController *rechargeVc = [[WLRechargeController alloc]init];
    rechargeVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:rechargeVc animated:YES];

}

-(void)keyBoardDown{
    [self.xinCardNumText resignFirstResponder];
}

@end

@implementation FMChangeBankCardViewModel


@end
