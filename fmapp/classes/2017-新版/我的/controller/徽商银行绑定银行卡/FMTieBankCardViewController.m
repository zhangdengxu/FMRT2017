//
//  FMTieBankCardViewController.m
//  fmapp
//
//  Created by runzhiqiu on 2017/5/10.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMTieBankCardViewController.h"
#import "FMRegisterBankView.h"
#import "WLChangePhoneNumberViewController.h"
#import "LLPaySdk.h"
#import "FMTieBankResultView.h"
#import "ShareViewController.h"
#import "FMKeyBoardNumberHeader.h"
#import "FMShowViewProductSuccess.h"

@interface FMTieBankCardViewController ()<UITextFieldDelegate>


@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic, weak) UIButton * buttonSelectStatus;//选定的button
@property (nonatomic, weak) UITextField * nameMiddleLabel;//姓名
@property (nonatomic, weak) UITextField * cardMiddleLabel;//身份证号
@property (nonatomic, weak) UITextField * phoneNumberMiddleLabel;//手机号
@property (nonatomic, weak) UITextField * bankCardMiddleLabel;//银行卡号


@property (nonatomic, assign) NSInteger statusISRegist;//是否已经签订电子账户


@property (nonatomic, strong) NSMutableDictionary *orderDic;
@property (nonatomic, strong) FMTieBankCardViewModel * viewModel;
@property (nonatomic, strong) NSMutableArray * recommendBankList;

@end

@implementation FMTieBankCardViewController

-(NSMutableArray *)recommendBankList
{
    if (!_recommendBankList) {
        _recommendBankList = [NSMutableArray array];
    }
    return _recommendBankList;
}
#pragma -mark 懒加载创建控件

-(FMTieBankCardViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[FMTieBankCardViewModel alloc]init];
    }
    return  _viewModel;
}

-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 64)];
        _scrollView.backgroundColor = [HXColor colorWithHexString:@"#f3f6f8"];
        _scrollView.contentSize = CGSizeMake(KProjectScreenWidth, 700);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_scrollView];
        
    }
    return _scrollView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"绑定银行卡"];
    
    if (![CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
        LoginController *registerController = [[LoginController alloc] init];
        FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
        [self presentViewController:navController animated:YES completion:nil];
        return;
    }
    
    [self createUI];
    
    
    [self setDefaultContent];
    [self getRecommendBankList];
    
    
    // Do any additional setup after loading the view.
}

-(void)setDefaultContent
{
    if ([CurrentUserInformation sharedCurrentUserInfo].shenfenzhenghao && [CurrentUserInformation sharedCurrentUserInfo].shenfenzhenghao.length > 0) {
        self.nameMiddleLabel.text = [CurrentUserInformation sharedCurrentUserInfo].zhenshiname;
        self.cardMiddleLabel.text = [CurrentUserInformation sharedCurrentUserInfo].shenfenzhenghao;
        self.viewModel.name = [CurrentUserInformation sharedCurrentUserInfo].zhenshiname;
        self.viewModel.personNumberCard = [CurrentUserInformation sharedCurrentUserInfo].shenfenzhenghao;
        

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma -mark 创建界面
-(void)createUI
{
    if (self.viewType == 1) {
        __weak __typeof(&*self)weakSelf = self;
        //由注册进入，有跳过按钮
        self.navBackButtonRespondBlock = ^(){
            [weakSelf retButtonConfirm];
        };
        UIButton * rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 45, 30)];
        [rightButton addTarget:self action:@selector(rightButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [rightButton setTitle:@"跳过" forState:UIControlStateNormal];
        [rightButton setTitleColor:[HXColor colorWithHexString:@"#0159d5"] forState:UIControlStateNormal];
        UIBarButtonItem * rightBpttonitem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
        
        self.navigationItem.rightBarButtonItem = rightBpttonitem;
        
    }else
    {
         __weak __typeof(&*self)weakSelf = self;
        self.navBackButtonRespondBlock = ^(){
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
            if (weakSelf.retBlock) {
                weakSelf.retBlock();
            }
        };
    }
    __weak __typeof(&*self)weakSelf = self;

    
    UIView * scrollViewContent = [[UIView alloc]init];
    scrollViewContent.frame = CGRectMake(0, 0, KProjectScreenWidth, 700);
    scrollViewContent.backgroundColor = [HXColor colorWithHexString:@"#f3f6f8"];
    scrollViewContent.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backGroundButtonOnClick:)];
    [scrollViewContent addGestureRecognizer:tapGesture];
    
    [self.scrollView addSubview:scrollViewContent];
    
    UIImageView * headImageView = [[UIImageView alloc]init];
    headImageView.image = [UIImage imageNamed:@"微商_注册:取现_海报1"];
    [scrollViewContent addSubview:headImageView];
    
    [headImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(scrollViewContent);
        make.height.equalTo(headImageView.mas_width).multipliedBy(0.37867);
    }];
    
    CGFloat itemHeigh = 55;
    CGFloat whiteTitleHeigh = 40;
    
    UIView * whiteContentViewTitle = [[UIView alloc]init];
    whiteContentViewTitle.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backGroundButtonOnClick:)];
    [whiteContentViewTitle addGestureRecognizer:tapGesture1];
    
    whiteContentViewTitle.backgroundColor = [UIColor whiteColor];
    [scrollViewContent addSubview:whiteContentViewTitle];
    [whiteContentViewTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(scrollViewContent);
        make.top.equalTo(headImageView.mas_bottom);
        make.height.equalTo(whiteTitleHeigh);
        
    }];
    
    
    UILabel * whiteContentViewTitleLabel = [[UILabel alloc]init];
    whiteContentViewTitleLabel.text = @"请绑定本人的储蓄卡，目前仅支持绑定一张卡";
    whiteContentViewTitleLabel.font = [UIFont systemFontOfSize:13];
    whiteContentViewTitleLabel.textColor = [HXColor colorWithHexString:@"#999999"];
    [whiteContentViewTitle addSubview:whiteContentViewTitleLabel];
    [whiteContentViewTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteContentViewTitle.mas_left).offset(12);
        make.right.equalTo(whiteContentViewTitle.mas_right).offset(12);
        make.top.bottom.equalTo(whiteContentViewTitle);
        
    }];
    
    
    //姓名
    UIView * whiteContentViewName = [[UIView alloc]init];
    whiteContentViewName.backgroundColor = [UIColor whiteColor];
    [scrollViewContent addSubview:whiteContentViewName];
    [whiteContentViewName makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(scrollViewContent);
        make.top.equalTo(whiteContentViewTitle.mas_bottom).offset(0.5);
        make.height.equalTo(itemHeigh);
        
    }];
    
    UIImageView * leftIconImageView1 = [[UIImageView alloc]init];
    leftIconImageView1.image = [UIImage imageNamed:@"微商_注册:取现_姓名"];
    [whiteContentViewName addSubview:leftIconImageView1];
    
    [leftIconImageView1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteContentViewName.mas_left).offset(12);
        make.centerY.equalTo(whiteContentViewName.mas_centerY);
        make.width.equalTo(@27);
        make.height.equalTo(@20);
        
    }];
    
    UITextField * nameMiddleLabel = [[UITextField alloc]init];
    self.nameMiddleLabel = nameMiddleLabel;
    nameMiddleLabel.delegate = self;
    nameMiddleLabel.placeholder = @"请输入持卡人姓名";
    nameMiddleLabel.borderStyle = UITextFieldViewModeNever;
    nameMiddleLabel.keyboardType = UIKeyboardTypeDefault;
    nameMiddleLabel.textColor = [HXColor colorWithHexString:@"#333333"];
    [whiteContentViewName addSubview:nameMiddleLabel];
    
    [nameMiddleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.priorityLow();
        make.left.equalTo(leftIconImageView1.mas_right).offset(12);
        make.centerY.equalTo(whiteContentViewName.mas_centerY);
        make.right.equalTo(whiteContentViewName.mas_right).offset(-12);
    }];
    
    
    //身份证
    UIView * whiteContentViewCard = [[UIView alloc]init];
    whiteContentViewCard.backgroundColor = [UIColor whiteColor];
    [scrollViewContent addSubview:whiteContentViewCard];
    [whiteContentViewCard makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(scrollViewContent);
        make.top.equalTo(whiteContentViewName.mas_bottom).offset(0.5);
        make.height.equalTo(itemHeigh);
        
    }];
    
    UIImageView * leftIconImageView2 = [[UIImageView alloc]init];
    leftIconImageView2.image = [UIImage imageNamed:@"微商_注册:取现_身份证"];
    [whiteContentViewCard addSubview:leftIconImageView2];
    
    [leftIconImageView2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteContentViewCard.mas_left).offset(12);
        make.centerY.equalTo(whiteContentViewCard.mas_centerY);
        make.width.equalTo(@27);
        make.height.equalTo(@20);
        
    }];
    
    UITextField * cardMiddleLabel = [[UITextField alloc]init];
    self.cardMiddleLabel = cardMiddleLabel;
    cardMiddleLabel.placeholder = @"请输入持卡人身份证号";
    cardMiddleLabel.delegate = self;
    cardMiddleLabel.borderStyle = UITextFieldViewModeNever;
    cardMiddleLabel.keyboardType = UIKeyboardTypeASCIICapable;
    cardMiddleLabel.textColor = [HXColor colorWithHexString:@"#333333"];
    [whiteContentViewCard addSubview:cardMiddleLabel];
    [cardMiddleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.priorityLow();
        
        make.left.equalTo(leftIconImageView2.mas_right).offset(12);
        make.centerY.equalTo(whiteContentViewCard.mas_centerY);
        make.right.equalTo(whiteContentViewCard.mas_right).offset(-12);
    }];
    
    
    //手机号
    UIView * whiteContentViewPhoneNumber = [[UIView alloc]init];
    whiteContentViewPhoneNumber.backgroundColor = [UIColor whiteColor];
    [scrollViewContent addSubview:whiteContentViewPhoneNumber];
    [whiteContentViewPhoneNumber makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(scrollViewContent);
        make.top.equalTo(whiteContentViewCard.mas_bottom).offset(0.5);
        make.height.equalTo(itemHeigh);
        
    }];
    
    UIImageView * leftIconImageView3 = [[UIImageView alloc]init];
    leftIconImageView3.image = [UIImage imageNamed:@"微商_注册:取现_手机"];
    [whiteContentViewPhoneNumber addSubview:leftIconImageView3];
    
    [leftIconImageView3 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteContentViewPhoneNumber.mas_left).offset(12);
        make.centerY.equalTo(whiteContentViewPhoneNumber.mas_centerY);
        make.width.equalTo(@27);
        make.height.equalTo(@20);
        
    }];
    
    UITextField * phoneNumberMiddleLabel = [[UITextField alloc]init];
    self.phoneNumberMiddleLabel = phoneNumberMiddleLabel;
    phoneNumberMiddleLabel.placeholder = @"请输入手机号";
    phoneNumberMiddleLabel.delegate = self;
    phoneNumberMiddleLabel.borderStyle = UITextFieldViewModeNever;
    phoneNumberMiddleLabel.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumberMiddleLabel.textColor = [HXColor colorWithHexString:@"#333333"];
    [whiteContentViewPhoneNumber addSubview:phoneNumberMiddleLabel];
    phoneNumberMiddleLabel.inputAccessoryView = [FMKeyBoardNumberHeader initKeyBoardNumberHeaderCreate:^{
        [weakSelf keyBoardDown];
    }];
    if ([CurrentUserInformation sharedCurrentUserInfo].mobile.length > 9) {
        phoneNumberMiddleLabel.text = [self retPhoneNumberWithSecret:[CurrentUserInformation sharedCurrentUserInfo].mobile];
        phoneNumberMiddleLabel.userInteractionEnabled = NO;
        self.viewModel.phoneNumber = [CurrentUserInformation sharedCurrentUserInfo].mobile;

    }
    
    
    [phoneNumberMiddleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.priorityLow();
        
        make.left.equalTo(leftIconImageView3.mas_right).offset(12);
        make.centerY.equalTo(whiteContentViewPhoneNumber.mas_centerY);
        make.right.equalTo(whiteContentViewPhoneNumber.mas_right).offset(-12 - itemHeigh - 10);
    }];
    
    UIButton * buttonChangeCard = [[UIButton alloc]init];
    [buttonChangeCard addTarget:self action:@selector(buttonChangeCardOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonChangeCard setTitle:@"更换" forState:UIControlStateNormal];
    [buttonChangeCard setTitleColor:[HXColor colorWithHexString:@"#0159d5"] forState:UIControlStateNormal];
    buttonChangeCard.titleLabel.font = [UIFont systemFontOfSize:14];
    [whiteContentViewPhoneNumber addSubview:buttonChangeCard];
    [buttonChangeCard makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(whiteContentViewPhoneNumber.mas_centerY);
        make.right.equalTo(whiteContentViewPhoneNumber.mas_right).offset(-12);
        make.width.equalTo(itemHeigh);
    }];
    
    
    
    //银行卡号
    UIView * whiteContentViewBankCard = [[UIView alloc]init];
    whiteContentViewBankCard.backgroundColor = [UIColor whiteColor];
    [scrollViewContent addSubview:whiteContentViewBankCard];
    
    [whiteContentViewBankCard makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(scrollViewContent);
        make.top.equalTo(whiteContentViewPhoneNumber.mas_bottom).offset(0.5);
        make.height.equalTo(itemHeigh);
        
    }];
    
    UIImageView * leftIconImageView4 = [[UIImageView alloc]init];
    leftIconImageView4.image = [UIImage imageNamed:@"微商_注册:取现_姓名"];
    [whiteContentViewBankCard addSubview:leftIconImageView4];
    
    [leftIconImageView4 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteContentViewBankCard.mas_left).offset(12);
        make.centerY.equalTo(whiteContentViewBankCard.mas_centerY);
        make.width.equalTo(@27);
        make.height.equalTo(@20);
        
    }];
    
    UITextField * bankCardMiddleLabel = [[UITextField alloc]init];
    self.bankCardMiddleLabel = bankCardMiddleLabel;
    bankCardMiddleLabel.placeholder = @"请输入持卡人银行卡号";
    bankCardMiddleLabel.delegate = self;
    bankCardMiddleLabel.borderStyle = UITextFieldViewModeNever;
    bankCardMiddleLabel.keyboardType = UIKeyboardTypeNumberPad;
    bankCardMiddleLabel.textColor = [HXColor colorWithHexString:@"#333333"];
    [whiteContentViewBankCard addSubview:bankCardMiddleLabel];
    bankCardMiddleLabel.inputAccessoryView = [FMKeyBoardNumberHeader initKeyBoardNumberHeaderCreate:^{
        [weakSelf keyBoardDown];
    }];
    [bankCardMiddleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.priorityLow();
        
        make.left.equalTo(leftIconImageView4.mas_right).offset(12);
        make.centerY.equalTo(whiteContentViewBankCard.mas_centerY);
        make.right.equalTo(whiteContentViewBankCard.mas_right).offset(-12);
    }];
    
    
    
    UIImageView * leftWaringImageView = [[UIImageView alloc]init];
    leftWaringImageView.image = [UIImage imageNamed:@"微商_注册:取现_叹号"];
    [scrollViewContent addSubview:leftWaringImageView];
    [leftWaringImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollViewContent.mas_left).offset(8);
        make.top.equalTo(whiteContentViewBankCard.mas_bottom).offset(12);
        
        
    }];
    
    UILabel * detailContentlabel =   [[UILabel alloc]init];
    detailContentlabel.text = @"注册手机号和银行卡预留手机号必须一致";
    detailContentlabel.textColor = [HXColor colorWithHexString:@"#cccccc"];
    if (KProjectScreenWidth < 350) {
        detailContentlabel.font = [UIFont systemFontOfSize:12];
        
    }else if (KProjectScreenWidth < 400 )
    {
        detailContentlabel.font = [UIFont systemFontOfSize:13];
        
    }else
    {
        detailContentlabel.font = [UIFont systemFontOfSize:14];
        
    }
    [scrollViewContent addSubview:detailContentlabel];
    [detailContentlabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftWaringImageView.mas_right).offset(1);
        make.centerY.equalTo(leftWaringImageView.mas_centerY);
    }];
    
    
    UIButton * buttonRegisterBank = [[UIButton alloc]init];
    [buttonRegisterBank addTarget:self action:@selector(buttonbuttonRegisterBankOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonRegisterBank setTitle:@"推荐银行 >>" forState:UIControlStateNormal];
    [buttonRegisterBank setTitleColor:[HXColor colorWithHexString:@"#0159d5"] forState:UIControlStateNormal];
    
    if (KProjectScreenWidth < 350) {
        buttonRegisterBank.titleLabel.font = [UIFont systemFontOfSize:12];
        
    }else if (KProjectScreenWidth < 400 )
    {
        buttonRegisterBank.titleLabel.font = [UIFont systemFontOfSize:13];
        
    }else
    {
        buttonRegisterBank.titleLabel.font = [UIFont systemFontOfSize:14];
        
    }
    [scrollViewContent addSubview:buttonRegisterBank];
    [buttonRegisterBank makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftWaringImageView.mas_centerY);
        make.right.equalTo(scrollViewContent.mas_right).offset(-8);
    }];
    
    
    UIButton * buttonSelectStatus = [[UIButton alloc]init];
    self.buttonSelectStatus = buttonSelectStatus;
    [buttonSelectStatus addTarget:self action:@selector(buttonSelectStatusBankOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonSelectStatus setImage:[UIImage imageNamed:@"微商_注册:取现_选择1"] forState:UIControlStateNormal];
    [buttonSelectStatus setImage:[UIImage imageNamed:@"微商_选择"] forState:UIControlStateSelected];
    buttonSelectStatus.selected = YES;
    [scrollViewContent addSubview:buttonSelectStatus];
    CGFloat margion = 52;
    if (KProjectScreenWidth < 350) {
        margion = 32;
    }else if (KProjectScreenWidth < 400)
    {
        margion = 42;
    }
    [buttonSelectStatus makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollViewContent.mas_left).offset(15);
        make.top.equalTo(leftWaringImageView.mas_bottom).offset(margion);
    }];
    
    UILabel * agreeContentlabel =   [[UILabel alloc]init];
    agreeContentlabel.text = @"我已阅读并同意";
    agreeContentlabel.textColor = [HXColor colorWithHexString:@"#000000"];
    if (KProjectScreenWidth < 350) {
        agreeContentlabel.font = [UIFont systemFontOfSize:12];
        
    }else if (KProjectScreenWidth < 400 )
    {
        agreeContentlabel.font = [UIFont systemFontOfSize:13];
        
    }else
    {
        agreeContentlabel.font = [UIFont systemFontOfSize:14];
        
    }
    [scrollViewContent addSubview:agreeContentlabel];
    [agreeContentlabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buttonSelectStatus.mas_right).offset(7);
        make.centerY.equalTo(buttonSelectStatus.mas_centerY);
    }];
    
    UIButton * buttonAgreeContent = [[UIButton alloc]init];
    [buttonAgreeContent addTarget:self action:@selector(buttonAgreeContentOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonAgreeContent setTitle:@"《徽商银行电子交易账户协议》" forState:UIControlStateNormal];
    [buttonAgreeContent setTitleColor:[HXColor colorWithHexString:@"#0159d5"] forState:UIControlStateNormal];
    if (KProjectScreenWidth < 350) {
        buttonAgreeContent.titleLabel.font = [UIFont systemFontOfSize:12];
        
    }else if (KProjectScreenWidth < 400 )
    {
        buttonAgreeContent.titleLabel.font = [UIFont systemFontOfSize:13];
        
    }else
    {
        buttonAgreeContent.titleLabel.font = [UIFont systemFontOfSize:14];
        
    }
    [scrollViewContent addSubview:buttonAgreeContent];
    [buttonAgreeContent makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(buttonSelectStatus.mas_centerY);
        make.left.equalTo(agreeContentlabel.mas_right).offset(2);
    }];
    
    
    
    UIButton * buttonConfirmContent = [[UIButton alloc]init];
    [buttonConfirmContent addTarget:self action:@selector(buttonConfirmContentOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonConfirmContent setTitle:@"确定" forState:UIControlStateNormal];
    [buttonConfirmContent setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonConfirmContent setBackgroundColor:[HXColor colorWithHexString:@"#0f5ed2"]];
    buttonConfirmContent.titleLabel.font = [UIFont systemFontOfSize:18];
    
    [scrollViewContent addSubview:buttonConfirmContent];
    [buttonConfirmContent makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buttonSelectStatus.mas_bottom).offset(10);
        make.left.equalTo(scrollViewContent.mas_left).offset(15);
        make.right.equalTo(scrollViewContent.mas_right).offset(-15);
        make.height.equalTo(@44);
        
    }];
    
}

#pragma -mark 控件响应事件及跳转
//背景图点击，去除键盘
-(void)backGroundButtonOnClick:(UITapGestureRecognizer *)tap
{
    [self retKeyBoardFromView];
}
-(void)keyBoardDown
{
    [self retKeyBoardFromView];

}
//去除键盘
-(void)retKeyBoardFromView
{
    [self.view endEditing:YES];
}
//由注册进入的返回事件
-(void)retButtonConfirm
{
    [self retKeyBoardFromView];
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
//导航栏右边按钮的点击
-(void)rightButtonOnClick:(UIButton *)button
{
    [self retButtonConfirm];
}

//变更手机号
-(void)buttonChangeCardOnClick:(UIButton *)button
{
    [self retKeyBoardFromView];
    
    WLChangePhoneNumberViewController * changePhone = [[WLChangePhoneNumberViewController alloc]init];
    [self.navigationController pushViewController:changePhone animated:YES];
}
//弹出推荐银行
-(void)buttonbuttonRegisterBankOnClick:(UIButton *)button
{
    [self retKeyBoardFromView];
    [FMRegisterBankView getRegisterBankViewWithDataSource:self.recommendBankList];
    
}
//账户协议的选定状态
-(void)buttonSelectStatusBankOnClick:(UIButton *)button
{
    [self retKeyBoardFromView];
    button.selected = !button.selected;
}

//徽商银行电子交易账户协议
-(void)buttonAgreeContentOnClick:(UIButton *)button
{
    [self retKeyBoardFromView];
    
    if ([CurrentUserInformation sharedCurrentUserInfo].statusNetWork == 1) {
        ShareViewController *shareVc = [[ShareViewController alloc] initWithTitle:@"徽商银行电子交易账户协议" AndWithShareUrl:[NSString stringWithFormat:@"%@",kFMPhpUniversalBaseUrl(@"rongtuoxinsoc/helpzhongxin/jiaoyizhanghuxiey")]];
        [self.navigationController pushViewController:shareVc animated:YES];
    }else
    {
        ShareViewController *shareVc = [[ShareViewController alloc] initWithTitle:@"徽商银行电子交易账户协议" AndWithShareUrl:[NSString stringWithFormat:@"%@",kXZWebViewUrl(@"/esb/EleTransProtocal.html")]];
        [self.navigationController pushViewController:shareVc animated:YES];
    }

}
//确定按钮
-(void)buttonConfirmContentOnClick:(UIButton *)button
{
    [self retKeyBoardFromView];
    if(!self.buttonSelectStatus.selected)
    {
        //选择徽商银行电子账户协议
        [self showAlterNSstring:@"请阅读并同意徽商银行电子账户协议！"];
        return;
    }
    
    if([self JudgeViewModelISReally])
    {
        [self judgeBankAccountInfomation];

    }
    
}
//确定按钮前的判断用户填写状态
-(BOOL)JudgeViewModelISReally
{
    if (!(self.viewModel.personNumberCard.length == 15 ||self.viewModel.personNumberCard.length == 18)) {
        
        //不是身份证号
        [self showAlterNSstring:@"身份证格式不正确！"];
        return NO;
    }
    
    if (self.viewModel.phoneNumber.length != 11) {
        //不是手机号
        [self showAlterNSstring:@"手机号格式不正确！"];
        return NO;
    }
    if (self.viewModel.name.length == 0) {
        [self showAlterNSstring:@"请填写持卡人姓名！"];
        return NO;
    }
    if (self.viewModel.bankCardNumber.length == 0) {
        [self showAlterNSstring:@"请填写持卡人银行卡号！"];
        return NO;
    }
    
    return YES;
}


#pragma -mark 代理（UITextField）
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == self.nameMiddleLabel) {
        //姓名
        self.viewModel.name = textField.text;
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField;
{
   if (textField == self.cardMiddleLabel)
    {
        self.viewModel.personNumberCard = textField.text;
    }
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
    
    if (textField == self.nameMiddleLabel) {
        //姓名
    }else if (textField == self.cardMiddleLabel)
    {
        
        self.viewModel.personNumberCard = contentString;
        
        
    }else if (textField == self.phoneNumberMiddleLabel)
    {
        //手机号
        self.viewModel.phoneNumber = contentString;
    }else if (textField == self.bankCardMiddleLabel)
    {
        //银行卡号
        self.viewModel.bankCardNumber = contentString;
    }else
    {
        
    }
    
    return YES;
}
#pragma -mark 工具函数
//将手机号改为中间四位的加密形式
-(NSString *)retPhoneNumberWithSecret:(NSString *)secretString
{
    
    if (secretString.length == 11) {
        NSString *string1,*string2;
        string1 = [secretString substringToIndex:3];//截取掉下标7之后的字符串
        string2 = [secretString substringFromIndex:7];
        return [NSString stringWithFormat:@"%@****%@",string1,string2];
    }
    return @"";
}
//弹出提示框
-(void)showAlterNSstring:(NSString *)contentString
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:contentString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
//字典转json字符串
- (NSString*)jsonStringOfObj:(NSDictionary*)dic{
    NSError *err = nil;
    NSData *stringData = [NSJSONSerialization dataWithJSONObject:dic
                                                         options:0
                                                           error:&err];
    NSString *str = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
    return str;
}

-(NSDictionary *)dictionaryWithNSString:(NSString *)jsonString
{
    NSData *JSONData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


#pragma -mark   走支付流程，有关支付相关


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
        //交易成功
        
        if (self.statusISRegist == 0) {
            //未开立电子账户  -- 需要创单绑卡
            [self createRegistAcctNo];
        }else
        {
            //已开立电子账户  -- 需要绑卡绑定电子账户
            [self bangRegistAcctNo];
        }
        
    }else
    {
        [self showAlterNSstring:showMsg];
    }
    
}

#pragma -mark  -- 获取推荐银行接口
-(void)getRecommendBankList
{
    NSString * url = kXZUniversalTestUrl(@"LLBankOfCommend");
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"AppId":@"huiyuan",
                                 @"AppTime":[NSNumber numberWithInt:timestamp],
                                 @"Token":tokenlow,
                                 @"FlagChnl":@1,
                                 @"CmdId":@"LLBankOfCommend"
                                 };
    
    /**FlagChnl 标记位 iOS端必须传1   !!!  **/
    [FMHTTPClient postPath:url parameters:parameter completion:^(WebAPIResponse *response) {
        
        if (response.code == WebAPIResponseCodeSuccess) {
            NSDictionary * dict = response.responseObject[@"data"];
            if (![dict isMemberOfClass:[NSNull class]]) {
                NSArray * cardList = dict[@"CardsList"];
                if (![cardList isMemberOfClass:[NSNull class]]) {
                    for (NSDictionary * dictDate in cardList) {
                        RegisterBankViewModel * viewModelList = [[RegisterBankViewModel alloc]init];
                        [viewModelList setValuesForKeysWithDictionary:dictDate];
                        [self.recommendBankList addObject:viewModelList];
                    }
                }
            }
        }
    }];
    
    
}
#pragma mark  -  判断用户是否开立电子账号
-(void)judgeBankAccountInfomation
{
    NSString * url = kXZUniversalTestUrl(@"LLQueryIsRegist");
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"AppId":@"huiyuan",
                                 @"AppTime":[NSNumber numberWithInt:timestamp],
                                 @"Token":tokenlow,
                                 @"FlagChnl":@1,
                                 @"CmdId":@"LLQueryIsRegist"
                                 };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    /**FlagChnl 标记位 iOS端必须传1   !!!  **/
    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient postPath:url parameters:parameter completion:^(WebAPIResponse *response) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (response.code == WebAPIResponseCodeSuccess) {
            NSDictionary * dict = response.responseObject[@"data"];
            if (![dict isMemberOfClass:[NSNull class]]) {
                NSString * isRegist = dict[@"IsRegist"];
                
                if (![isRegist isMemberOfClass:[NSNull class]]) {
                    if ([isRegist isEqualToString:@"0"]) {
                        //未开立  --走创单绑卡
                        weakSelf.statusISRegist = 0;
                    }else
                    {
                        //已开立  --直接走绑卡
                        weakSelf.statusISRegist = 1;
                    }
                    
                    [weakSelf payWithNetWork];
                }
                
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
                    ShowAutoHideMBProgressHUD(self.view, @"绑卡失败，请稍后重试！");
                }
            }else
            {
                ShowAutoHideMBProgressHUD(self.view, @"网络不好，请稍后重试！");
                
            }
        }
    }];
    
    
}


#pragma mark - 签约支付
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
                                 @"CardNo":self.viewModel.bankCardNumber,
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
//绑卡接口  //已开立电子账户  -- 需要绑卡绑定电子账户

-(void)bangRegistAcctNo
{
    NSString * url = kXZUniversalTestUrl(@"SignCard");
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"AppId":@"huiyuan",
                                 @"AppTime":[NSNumber numberWithInt:timestamp],
                                 @"Token":tokenlow,
                                 @"SigCard":self.viewModel.bankCardNumber,
                                 @"Mobile":self.viewModel.phoneNumber,
                                 @"CmdId":@"SignCard",
                                 @"FlagChnl":@1,
                                 };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:url parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        if (response.code == WebAPIResponseCodeSuccess) {
             [CurrentUserInformation sharedCurrentUserInfo].weishangbang = @"1";
           //开通电子账单结果
            [self resultViewWithSuccess];
        }else
        {
            if ([response.responseObject[@"status"] isMemberOfClass:[NSNull class]]) {
                ShowAutoHideMBProgressHUD(self.view, @"服务器出错请稍后重试！");
                
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
        }
        
        
        
    }];
    
}

//电子账户开立接口
-(void)createRegistAcctNo
{
    NSString * url = kXZUniversalTestUrl(@"RegistAcctNo");
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"AppId":@"huiyuan",
                                 @"AppTime":[NSNumber numberWithInt:timestamp],
                                 @"Token":tokenlow,
                                 @"IdNo":self.viewModel.personNumberCard,
                                 @"SurName":self.viewModel.name,
                                 @"BindCardNo":self.viewModel.bankCardNumber,
                                 @"Mobile":self.viewModel.phoneNumber,
                                 @"CmdId":@"RegistAcctNo",
                                 @"FlagChnl":@1,
                                 };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:url parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        if (response.code == WebAPIResponseCodeSuccess) {
            //开通电子账单结果
            [CurrentUserInformation sharedCurrentUserInfo].weishangbang = @"1";

            [self resultViewWithSuccess];
            
        }else
        {
            if ([response.responseObject[@"status"] isMemberOfClass:[NSNull class]]) {
                ShowAutoHideMBProgressHUD(self.view, @"服务器出错请稍后重试！");
                
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
        }
        
        
        
    }];
}


-(void)resultViewWithSuccess
{
    [[CurrentUserInformation sharedCurrentUserInfo] checkUserInfoWithNetWork];
    __weak __typeof(&*self)weakSelf = self;
    
    if (self.statusISRegist == 0) {
        //未开立电子账户  -- 需要创单绑卡
        [FMTieBankResultView showFMTieBankResultViewWithStatus:@"开户成功" Success:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }else
    {
        //已开立电子账户  -- 需要绑卡绑定电子账户
        [FMTieBankResultView showFMTieBankResultViewWithStatus:@"绑卡成功" Success:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
    
   
    
}

@end




@implementation FMTieBankCardViewModel


@end


