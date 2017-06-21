//
//  FMRTAllTakeNewBuyViewController.m
//  fmapp
//
//  Created by apple on 2016/10/26.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTAllTakeNewBuyViewController.h"

#import "XZPayOrder.h"
#import "OpenUDID.h"
#import "RegexKitLite.h"
#import <UIKit/UIKit.h>

@interface FMRTAllTakeNewBuyViewController ()<XZPayOrderDelegate>

@property (nonatomic, strong) UITextField *moneyTextField;
@property (nonatomic, weak)   UIView *halfView, *whiteView;
@property (nonatomic, weak)   UIImageView *rightIcone,*wxIcone,*tbIcone;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) XZPayOrder *payOrderStyle;
@property (nonatomic, weak)   UIButton *fiveBtn,*tenBtn,*twBtn,*thityBtn;

@end

@implementation FMRTAllTakeNewBuyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"购买夺宝币"];
    self.view.backgroundColor = [UIColor clearColor];
    
    self.type = 1;
    [self createContentView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification  object:nil];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange) name:UITextFieldTextDidChangeNotification object:_moneyTextField];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)createContentView{
    
    UIView *halfView = [[UIView alloc]init];
    self.halfView = halfView;
    halfView.backgroundColor = [HXColor colorWithHexString:@"#000000"alpha:0.6];
    [self.view addSubview:halfView];
    [halfView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(-64);
        make.height.equalTo(KProjectScreenHeight- 380 +64);
    }];
    
    halfView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeAction)];
    
    [halfView addGestureRecognizer:tapGesture];
    
    UIView *whiteView = [[UIView alloc]init];
    self.whiteView = whiteView;
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    [whiteView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(380);
    }];
    
    UIImageView *moneyPhoto = [[UIImageView alloc]init];
    moneyPhoto.image = [UIImage imageNamed:@"snatch_jinbi"];
    [whiteView addSubview:moneyPhoto];
    [moneyPhoto makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteView.mas_left).offset(20);
        make.top.equalTo(whiteView.mas_top).offset(13);
    }];
    
    UILabel *moneyLabel = [[UILabel alloc]init];
    moneyLabel.text = @"夺宝币充值";
    moneyLabel.font = [UIFont systemFontOfSize:16];
    moneyLabel.textColor = [HXColor colorWithHexString:@"#666666"];
    [whiteView addSubview:moneyLabel];
    [moneyLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moneyPhoto.mas_right).offset(10);
        make.centerY.equalTo(moneyPhoto.mas_centerY);
    }];
    
    UIButton *closeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [closeButton setImage:[UIImage imageNamed:@"全新关闭"] forState:(UIControlStateNormal)];
    [closeButton addTarget:self action:@selector(closeAction) forControlEvents:(UIControlEventTouchUpInside)];
    closeButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //    closeButton.backgroundColor = [UIColor redColor];
    [whiteView addSubview:closeButton];
    [closeButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(moneyPhoto.mas_centerY);
        make.right.equalTo(whiteView.mas_right);
        make.width.equalTo(@50);
        make.height.equalTo(@30);
    }];
    
    UIView *slineView = [[UIView alloc]init];
    slineView.backgroundColor = [HXColor colorWithHexString:@"#e5e9f2"];
    [whiteView addSubview:slineView];
    [slineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyPhoto.mas_bottom).offset(5);
        make.left.equalTo(whiteView.mas_left).offset(15);
        make.right.equalTo(whiteView.mas_right).offset(-15);
        make.height.equalTo(@1);
    }];
    
    UILabel *typeLabel = [[UILabel alloc]init];
    typeLabel.text = @"选择支付方式";
    typeLabel.font = [UIFont systemFontOfSize:14];
    typeLabel.textColor = [HXColor colorWithHexString:@"#666666"];
    [whiteView addSubview:typeLabel];
    [typeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(slineView.mas_left);
        make.top.equalTo(slineView.mas_bottom).offset(15);
    }];
    
    UIView *tlineView = [[UIView alloc]init];
    tlineView.backgroundColor = [HXColor colorWithHexString:@"#e5e9f2"];
    [whiteView addSubview:tlineView];
    [tlineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(typeLabel.mas_bottom).offset(10);
        make.left.equalTo(slineView.mas_left);
        make.right.equalTo(slineView.mas_right);
        make.height.equalTo(@1);
    }];
    
    
    UIImageView *wxIcone = [[UIImageView alloc]init];
    wxIcone.image = [UIImage imageNamed:@"goubaiduobaobiweixin"];
    wxIcone.contentMode = UIViewContentModeScaleAspectFit;
    self.wxIcone = wxIcone;
    [whiteView addSubview:wxIcone];
    [wxIcone makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(slineView.mas_left);
        make.top.equalTo(tlineView.mas_bottom).offset(5);
    }];
    
    UILabel *wxLabel = [[UILabel alloc]init];
    wxLabel.text = @"微信支付";
    wxLabel.font = [UIFont systemFontOfSize:14];
    wxLabel.textColor = [HXColor colorWithHexString:@"#666666"];
    [whiteView addSubview:wxLabel];
    [wxLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wxIcone.mas_right).offset(10);
        make.centerY.equalTo(wxIcone.mas_centerY);
    }];
    
    UIView *centerlineView = [[UIView alloc]init];
    centerlineView.backgroundColor = [HXColor colorWithHexString:@"#e5e9f2"];
    [whiteView addSubview:centerlineView];
    [centerlineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wxIcone.mas_bottom).offset(5);
        make.left.equalTo(slineView.mas_left);
        make.right.equalTo(slineView.mas_right);
        make.height.equalTo(@1);
    }];
    
    UIImageView *tbIcone = [[UIImageView alloc]init];
    tbIcone.image = [UIImage imageNamed:@"alipay_icon"];
    tbIcone.contentMode = UIViewContentModeScaleAspectFit;
    self.tbIcone = tbIcone;
    [whiteView addSubview:tbIcone];
    [tbIcone makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(slineView.mas_left);
        make.top.equalTo(centerlineView.mas_bottom).offset(5);
    }];
    
    UILabel *tbLabel = [[UILabel alloc]init];
    tbLabel.text = @"支付宝支付";
    tbLabel.font = [UIFont systemFontOfSize:14];
    tbLabel.textColor = [HXColor colorWithHexString:@"#666666"];
    [whiteView addSubview:tbLabel];
    [tbLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tbIcone.mas_right).offset(10);
        make.centerY.equalTo(tbIcone.mas_centerY);
    }];
    
    UIView *buyGrayView = [[UIView alloc]init];
    buyGrayView.backgroundColor = [HXColor colorWithHexString:@"#e5e9f2"];
    [whiteView addSubview:buyGrayView];
    [buyGrayView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(slineView.mas_left);
        make.right.equalTo(slineView.mas_right);
        make.top.equalTo(tbIcone.mas_bottom).offset(5);
        make.height.equalTo(@130);
    }];
    
    
    UILabel *countLabel = [[UILabel alloc]init];
    countLabel.text = @"购币数量";
    countLabel.font = [UIFont systemFontOfSize:13];
    countLabel.textColor = [HXColor colorWithHexString:@"#333333"];
    [buyGrayView addSubview:countLabel];
    [countLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(buyGrayView.mas_centerX);
        make.top.equalTo(buyGrayView.mas_top).offset(15);
    }];
    
    [buyGrayView addSubview:self.moneyTextField];
    //    self.moneyTextField.text = @"0";
    [self.moneyTextField makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(buyGrayView.mas_centerX);
        make.top.equalTo(countLabel.mas_bottom).offset(5);
        make.width.equalTo(@100);
        make.height.equalTo(@25);
    }];
    
    UIButton *deleteButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [deleteButton setImage:[UIImage imageNamed:@"全新减号"] forState:(UIControlStateNormal)];
    [deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:(UIControlEventTouchUpInside)];
    [buyGrayView addSubview:deleteButton];
    [deleteButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.moneyTextField.mas_centerY);
        make.right.equalTo(self.moneyTextField.mas_left).offset(-15);
        make.width.height.equalTo(@30);
    }];
    
    UIButton *addButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [addButton setImage:[UIImage imageNamed:@"全新加号"] forState:(UIControlStateNormal)];
    [addButton addTarget:self action:@selector(addAction) forControlEvents:(UIControlEventTouchUpInside)];
    [buyGrayView addSubview:addButton];
    [addButton makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@30);
        make.centerY.equalTo(self.moneyTextField.mas_centerY);
        make.left.equalTo(self.moneyTextField.mas_right).offset(15);
    }];
    
    UILabel *textLabel = [[UILabel alloc]init];
    textLabel.text = @"点击下方按钮，快速选择购币数量";
    textLabel.font = [UIFont systemFontOfSize:12];
    textLabel.textColor = [HXColor colorWithHexString:@"#666666"];
    [buyGrayView addSubview:textLabel];
    [textLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(buyGrayView.mas_centerX);
        make.top.equalTo(self.moneyTextField.mas_bottom).offset(10);
    }];
    
    
    UIButton *tenButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.tenBtn = tenButton;
    [tenButton setTitleColor:[HXColor colorWithHexString:@"#999999"] forState:(UIControlStateNormal)];
    [tenButton setTitleColor:[HXColor colorWithHexString:@"#ff6633"] forState:(UIControlStateHighlighted)];
    [tenButton setTitle:@"10" forState:(UIControlStateNormal)];
    tenButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [tenButton setBackgroundImage:[UIImage imageNamed:@"全新未选中"] forState:(UIControlStateNormal)];
    [tenButton setBackgroundImage:[UIImage imageNamed:@"全新选择"] forState:(UIControlStateHighlighted)];
    [tenButton addTarget:self action:@selector(changeAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [buyGrayView addSubview:tenButton];
    [tenButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(textLabel.mas_bottom).offset(5);
        make.right.equalTo(buyGrayView.mas_centerX).offset(-2.5);
        make.width.equalTo(@50);
        make.height.equalTo(@25);
    }];
    
    UIButton *twtyButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.twBtn = twtyButton;
    [twtyButton setTitleColor:[HXColor colorWithHexString:@"#999999"] forState:(UIControlStateNormal)];
    [twtyButton setTitleColor:[HXColor colorWithHexString:@"#ff6633"] forState:(UIControlStateHighlighted)];
    [twtyButton setTitle:@"20" forState:(UIControlStateNormal)];
    twtyButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [twtyButton setBackgroundImage:[UIImage imageNamed:@"全新未选中"] forState:(UIControlStateNormal)];
    [twtyButton setBackgroundImage:[UIImage imageNamed:@"全新选择"] forState:(UIControlStateHighlighted)];
    [twtyButton addTarget:self action:@selector(changeAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [buyGrayView addSubview:twtyButton];
    [twtyButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(tenButton.mas_centerY);
        make.left.equalTo(buyGrayView.mas_centerX).offset(2.5);
        make.width.equalTo(@50);
        make.height.equalTo(@25);
    }];
    
    UIButton *fiveButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [fiveButton setTitleColor:[HXColor colorWithHexString:@"#999999"] forState:(UIControlStateNormal)];
    [fiveButton setTitleColor:[HXColor colorWithHexString:@"#ff6633"] forState:(UIControlStateHighlighted)];
    self.fiveBtn = fiveButton;
    [fiveButton setTitle:@"5" forState:(UIControlStateNormal)];
    fiveButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [fiveButton setBackgroundImage:[UIImage imageNamed:@"全新未选中"] forState:(UIControlStateNormal)];
    [fiveButton setBackgroundImage:[UIImage imageNamed:@"全新选择"] forState:(UIControlStateHighlighted)];
    [fiveButton addTarget:self action:@selector(changeAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [buyGrayView addSubview:fiveButton];
    [fiveButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(tenButton.mas_centerY);
        make.right.equalTo(tenButton.mas_left).offset(-5);
        make.width.equalTo(@50);
        make.height.equalTo(@25);
    }];
    
    UIButton *thirtyButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [thirtyButton setTitleColor:[HXColor colorWithHexString:@"#999999"] forState:(UIControlStateNormal)];
    [thirtyButton setTitleColor:[HXColor colorWithHexString:@"#ff6633"] forState:(UIControlStateHighlighted)];
    self.thityBtn = thirtyButton;
    [thirtyButton setTitle:@"30" forState:(UIControlStateNormal)];
    thirtyButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [thirtyButton setBackgroundImage:[UIImage imageNamed:@"全新未选中"] forState:(UIControlStateNormal)];
    [thirtyButton setBackgroundImage:[UIImage imageNamed:@"全新选择"] forState:(UIControlStateHighlighted)];
    [thirtyButton addTarget:self action:@selector(changeAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [buyGrayView addSubview:thirtyButton];
    [thirtyButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(tenButton.mas_centerY);
        make.left.equalTo(twtyButton.mas_right).offset(5);
        make.width.equalTo(@50);
        make.height.equalTo(@25);
    }];
    
    UIButton *enterButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [enterButton setTitle:@"立即充值" forState:(UIControlStateNormal)];
    enterButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [enterButton setBackgroundImage:[UIImage imageNamed:@"全新立即充值"] forState:(UIControlStateNormal)];
    [enterButton addTarget:self action:@selector(enterAction) forControlEvents:(UIControlEventTouchUpInside)];
    [whiteView addSubview:enterButton];
    [enterButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(whiteView.mas_bottom).offset(-20);
        make.left.equalTo(fiveButton.mas_left);
        make.right.equalTo(thirtyButton.mas_right);
        make.height.equalTo(@35);
    }];
    
    UIButton *wxBuyButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [wxBuyButton addTarget:self action:@selector(wxBuyAction) forControlEvents:(UIControlEventTouchUpInside)];
    [whiteView addSubview:wxBuyButton];
    [wxBuyButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(wxIcone.mas_top);
        make.left.equalTo(slineView.mas_left);
        make.right.equalTo(slineView.mas_right);
        make.bottom.equalTo(wxIcone.mas_bottom);
    }];
    
    UIButton *tbBuyButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [tbBuyButton addTarget:self action:@selector(tbBuyAction) forControlEvents:(UIControlEventTouchUpInside)];
    [whiteView addSubview:tbBuyButton];
    [tbBuyButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(tbIcone.mas_top);
        make.left.equalTo(slineView.mas_left);
        make.right.equalTo(slineView.mas_right);
        make.bottom.equalTo(tbIcone.mas_bottom);
    }];
    
    UIImageView *rightIcone = [[UIImageView alloc]init];
    rightIcone.image = [UIImage imageNamed:@"全新对号"];
    self.rightIcone = rightIcone;
    [whiteView addSubview:rightIcone];
    [rightIcone makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wxIcone.mas_centerY);
        make.right.equalTo(slineView.mas_right).offset(-3);
    }];
    
}


- (void)deleteAction{
    
    if ([self.moneyTextField.text longLongValue] >= 1) {
        self.moneyTextField.text =[NSString stringWithFormat:@"%lld",[self.moneyTextField.text longLongValue]-1];
    }else{
        
    }
    [self textFieldChange];
}

- (void)addAction{
    self.moneyTextField.text =[NSString stringWithFormat:@"%lld",[self.moneyTextField.text longLongValue]+1];
    [self textFieldChange];
}

- (void)changeAction:(UIButton *)sender{
    self.moneyTextField.text = sender.titleLabel.text;
    [self textFieldChange];
}

- (void)enterAction{
    
    if (![self.moneyTextField.text isMatchedByRegex:@"^[1-9]\\d*$"]) {
        ShowAutoHideMBProgressHUD(self.view, @"输入购币数量不合法");
        return;
    }
    [self.moneyTextField resignFirstResponder];

    [self payForOrder];
}

- (void)wxBuyAction{
    
    self.type = 1;
    [self.rightIcone remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.wxIcone.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-18);
    }];
}

- (void)tbBuyAction{
    
    self.type = 2;
    [self.rightIcone remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tbIcone.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-18);
    }];
}

- (UITextField *)moneyTextField{
    if (!_moneyTextField) {
        _moneyTextField = [[UITextField alloc]init];
        _moneyTextField.textColor = [UIColor colorWithHexString:@"#333333"];
        _moneyTextField.font = [UIFont systemFontOfSize:15];
        _moneyTextField.layer.borderWidth = 1;
        _moneyTextField.backgroundColor = [UIColor whiteColor];
        _moneyTextField.keyboardType = UIKeyboardTypeNumberPad;
        _moneyTextField.layer.borderColor = [HXColor colorWithHexString:@"#666666"].CGColor;
        _moneyTextField.textAlignment = NSTextAlignmentCenter;
        _moneyTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"0" attributes:@{NSForegroundColorAttributeName: [HXColor colorWithHexString:@"#333333"]}];
    }
    return _moneyTextField;
}

- (void)closeAction{
    
    if (self.dismissBlock) {
        self.dismissBlock();
    }
    [self.halfView removeFromSuperview];
    //    [self dismissViewControllerAnimated:YES completion:^{
    //
    //    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.moneyTextField resignFirstResponder];
}

- (void)requestDealCodeWithType:(NSString *)type success:(void (^)(NSString *object))success{
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"coin_num":self.moneyTextField.text,
                                 @"pay_type":type
                                 };
    
    __weak __typeof(self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *testurl = [NSString stringWithFormat:@"%@/public/newon/coin/buyWonCoin",kXZTestEnvironment];

    [FMHTTPClient postPath:testurl parameters:parameter completion:^(WebAPIResponse *response) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (response.code==WebAPIResponseCodeSuccess) {
            
            NSDictionary *dataDic = [response.responseObject objectForKey:@"data"];
            NSString *str = [dataDic objectForKey:@"deal_code"];
            if (success) {
                success(str);
            }
            
        }else{
            ShowAutoHideMBProgressHUD(weakSelf.view,@"商户订单请求失败！");
        }
    }];
}


// 支付
- (void)payForOrder {
    
    __weak __typeof(self)weakSelf = self;
    CGFloat price = [self.moneyTextField.text floatValue];
    // 支付宝支付
    if (self.type == 2) {
        
        [self requestDealCodeWithType:@"alipay" success:^(NSString *object) {
            // 支付宝支付
            
            NSString *testurl = [NSString stringWithFormat:@"%@/public/newon/pay/buyWonCoinNoticeFromAlipay",kXZTestEnvironment];
            [weakSelf.payOrderStyle AliPayShopID:object withTitle:@"夺宝币购买" Detail:@"夺宝币购买详情" Price:[NSString stringWithFormat:@"%.2f",price] Url:testurl Returl:testurl type:11];
        }];
        
    }else {
        // 微信支付
        
        [self requestDealCodeWithType:@"wxpay" success:^(NSString *object) {
            NSString *wUrl = [NSString stringWithFormat:@"%@/public/newon/pay/buyWonCoinNoticeFromWxpay",kXZTestEnvironment];
            [weakSelf.payOrderStyle WXPayShopID:object withTitle:@"夺宝币购买" Detail:@"夺宝币购买详情" Price:[NSString stringWithFormat:@"%.2f",price] Url:wUrl Returl:wUrl type:11];
        }];
    }
}

- (XZPayOrder *)payOrderStyle{
    if (!_payOrderStyle) {
        _payOrderStyle = [[XZPayOrder alloc]init];
        _payOrderStyle.delegate = self;
    }
    return _payOrderStyle;
}

-(void)XZPayOrderResultWithStatus:(NSString *)resultStatus{
    
    if (self.type == 1) {
        //微信支付
        if ([resultStatus isEqualToString:@"1"]) {
            ShowAutoHideMBProgressHUD(self.view, @"购买成功");
        }else{
            ShowAutoHideMBProgressHUD(self.view, @"购买失败");
        }
    }else{
        //支付宝支付
        if ([resultStatus isEqualToString:@"9000"]) {
            ShowAutoHideMBProgressHUD(self.view, @"购买成功");
            
        }else{
            ShowAutoHideMBProgressHUD(self.view, @"购买失败");
        }
    }
}



- (void)keyboardWillShow:(NSNotification *)aNotification{
    
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;

    [self.whiteView updateConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view.bottom).offset(-height + 20);
    }];
}

- (void)keyboardWillHide:(NSNotification *)aNotification{
    
    [self.whiteView updateConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view.bottom);
    }];
}

- (void)textFieldChange{
    
    if ([self.moneyTextField.text integerValue] == 5) {
        [self.fiveBtn setTitleColor:[HXColor colorWithHexString:@"#ff6633"] forState:(UIControlStateNormal)];
        [self.fiveBtn setBackgroundImage:[UIImage imageNamed:@"全新选择"] forState:(UIControlStateNormal)];
    }else{
        [self.fiveBtn setTitleColor:[HXColor colorWithHexString:@"#999999"] forState:(UIControlStateNormal)];
        [self.fiveBtn setBackgroundImage:[UIImage imageNamed:@"全新未选中"] forState:(UIControlStateNormal)];
    }
    if ([self.moneyTextField.text integerValue] == 10){
        [self.tenBtn setTitleColor:[HXColor colorWithHexString:@"#ff6633"] forState:(UIControlStateNormal)];
        [self.tenBtn setBackgroundImage:[UIImage imageNamed:@"全新选择"] forState:(UIControlStateNormal)];
    }else{
        [self.tenBtn setTitleColor:[HXColor colorWithHexString:@"#999999"] forState:(UIControlStateNormal)];
        [self.tenBtn setBackgroundImage:[UIImage imageNamed:@"全新未选中"] forState:(UIControlStateNormal)];

    }
    if ([self.moneyTextField.text integerValue] == 20){
        [self.twBtn setTitleColor:[HXColor colorWithHexString:@"#ff6633"] forState:(UIControlStateNormal)];
        [self.twBtn setBackgroundImage:[UIImage imageNamed:@"全新选择"] forState:(UIControlStateNormal)];
    }else{
        [self.twBtn setTitleColor:[HXColor colorWithHexString:@"#999999"] forState:(UIControlStateNormal)];
        [self.twBtn setBackgroundImage:[UIImage imageNamed:@"全新未选中"] forState:(UIControlStateNormal)];
        
    }
    if ([self.moneyTextField.text integerValue] == 30){
        [self.thityBtn setTitleColor:[HXColor colorWithHexString:@"#ff6633"] forState:(UIControlStateNormal)];
        [self.thityBtn setBackgroundImage:[UIImage imageNamed:@"全新选择"] forState:(UIControlStateNormal)];
    }else{
        [self.thityBtn setTitleColor:[HXColor colorWithHexString:@"#999999"] forState:(UIControlStateNormal)];
        [self.thityBtn setBackgroundImage:[UIImage imageNamed:@"全新未选中"] forState:(UIControlStateNormal)];
        
    }
}


@end
