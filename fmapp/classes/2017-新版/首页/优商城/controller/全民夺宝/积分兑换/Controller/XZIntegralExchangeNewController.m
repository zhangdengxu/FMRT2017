//
//  XZIntegralExchangeNewController.m
//  fmapp
//
//  Created by admin on 16/10/26.
//  Copyright © 2016年 yk. All rights reserved.
//  积分兑换

#import "XZIntegralExchangeNewController.h"
#import "XZSuccessFailureView.h" // 积分兑换成功/失败
#import "XZSuccessFailureModel.h"
#import "XZGetCoinsNewController.h" // 获取夺宝币
#import "YYRechargeRecordViewController.h" // 充值记录
#import "FMKeyBoardNumberHeader.h" // 键盘上方视图

#define NUMBERS @"0123456789\n"

// 积分兑换
#define kXZIntegralExchangeUrl [NSString stringWithFormat:@"%@/public/newon/coin/exchangeWonCoin",kXZTestEnvironment]
//@"http://114.55.115.60:18080/public/newon/coin/exchangeWonCoin"
// 用户拥有积分
#define kXZIndianaCurrencyUrl [NSString stringWithFormat:@"%@/public/newon/coin/getUserWonAccount",kXZTestEnvironment]
//@"http://114.55.115.60:18080/public/newon/coin/getUserWonAccount"

@interface XZIntegralExchangeNewController ()<UITextFieldDelegate,UIScrollViewDelegate>
@property (nonatomic, assign) NSInteger count;
/** 可兑换积分 */
@property (nonatomic, strong) UILabel *labelChangedInt;
/** 拥有积分 */
@property (nonatomic, strong) UILabel *labelIntegral;
/** 点击输入积分 */
@property (nonatomic, strong) UITextField *textInput;
/** 白色视图 */
@property (nonatomic, strong) UIView *viewWhite;
/** 用户输入的积分 */
@property (nonatomic, assign) NSInteger countNum;
/** 请求到的剩余积分 */
@property (nonatomic, strong) NSString *totalScore;
///** 兑换积分成功或者失败的页面 */
//@property (nonatomic, strong) XZSuccessFailureView *viewFailureSuc;

@end

@implementation XZIntegralExchangeNewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.view.backgroundColor = XZColor(229, 233, 242);
    self.totalScore = @"0";
    self.count = 0;
    self.countNum = 0;
    //
    [self settingNavTitle:@"积分兑换"];
    [self createIntegralExchangeSubView];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // 请求剩余积分
    [self getIntegralFromNetwork:NO];

}

// 请求剩余积分 isNeed是否需要请求“确认兑换的数据”
- (void)getIntegralFromNetwork:(BOOL)isNeed {
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow
                                 };
    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient postPath:kXZIndianaCurrencyUrl parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        NSLog(@"response.responseObject===========%@",response.responseObject);
        if (response.code == WebAPIResponseCodeSuccess) {
            if (![response.responseObject isKindOfClass:[NSNull class]]) {
                // 数据请求成功 score
                NSDictionary *dataDict = response.responseObject[@"data"];
                self.totalScore = [NSString stringWithFormat:@"%@",dataDict[@"score"]];
                self.labelIntegral.text = [NSString stringWithFormat:@"拥有积分：%@",self.totalScore];
                if (isNeed) { // 是点击兑换时候请求的剩余积分
                    // 请求确认兑换的数据 /** 注：上传self.count * 100 */
                    [self putIntegralToNetwork];
                }
            }else{
                ShowAutoHideMBProgressHUD(weakSelf.view,@"加载数据失败");
            }
        }
    }];
    
}

#pragma mark --- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.textInput resignFirstResponder];
}

#pragma mark --- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *character;
    character = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:character] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if (!basicTest) {
        return NO;
    }else{
        NSInteger length = textField.text.length;
        if ((length >= 9) && (string.length != 0)) {
            return NO;
        }else {
            NSString *contentString;
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
            self.countNum = [contentString integerValue];
            self.count = self.countNum / 100;
            self.labelChangedInt.text = [NSString stringWithFormat:@"%ld",(long)self.count];
            return YES;
        }
    }
}
#pragma mark ---- 点击确认兑换按钮
- (void)didClickSureExchangde:(UIButton *)button {
    if ([self.totalScore floatValue] < self.countNum ) {
//        ShowAutoHideMBProgressHUD(self.view,@"您当前积分不足，无法兑换!");
        XZSuccessFailureView *viewFailure = [[XZSuccessFailureView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight)];
        [self.view addSubview:viewFailure];
        XZSuccessFailureModel *modelSF = [[XZSuccessFailureModel alloc] init];
        modelSF.currentInter = [NSString stringWithFormat:@"%@",self.totalScore];
        modelSF.isSuccess = NO;
        modelSF.coinNumber = @"";
        viewFailure.modelSF = modelSF;
        viewFailure.blockLookUp = ^(UIButton  *button){
            // 130 点此查看 140 确定 150 继续兑换 160 其他方式获得
            if (button.tag == 160) { // 其他方式获得
                if (self.isCoinExchange) { // 从获取夺宝币跳入当前页面
                    [self.navigationController popViewControllerAnimated:YES];
                }else {
                    XZGetCoinsNewController *getCoins = [[XZGetCoinsNewController alloc] init];
                    [self.navigationController pushViewController:getCoins animated:YES];
                }
            }
        };
        [self.textInput resignFirstResponder];
        return;
    }
    if (self.countNum < 100) {
        ShowAutoHideMBProgressHUD(self.view,@"积分不能少于100，请重新输入!");
        return;
    }else  if (self.countNum % 100 > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入100的整数倍!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }else {
        [self.textInput resignFirstResponder];
        // 先请求剩余积分，成功之后请求
        [self getIntegralFromNetwork:YES];
    }
}

// 点击“确认兑换”请求数据：请求成功，自己计算修改“拥有积分”
- (void)putIntegralToNetwork {
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"trench":@"score",
                                 @"jetton":[NSString stringWithFormat:@"%ld",(long)(self.count * 100)]
                                 };
    __weak __typeof(&*self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:kXZIntegralExchangeUrl parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"response.responseObject ======= %@",response.responseObject);
        if (response.code == WebAPIResponseCodeSuccess) {
            if (![response.responseObject isKindOfClass:[NSNull class]]) {
                NSString *status = [NSString stringWithFormat:@"%@",response.responseObject[@"status"]];
                if ([status isEqualToString:@"0"]) { // 数据请求成功
                    NSDictionary *dict = response.responseObject[@"data"];
                    NSString *coin = dict[@"coin"]; // 兑换夺宝币数量
                    weakSelf.totalScore = [NSString stringWithFormat:@"%zd",[self.totalScore integerValue] - (self.count * 100)];
                    weakSelf.labelIntegral.text = [NSString stringWithFormat:@"拥有积分：%@",self.totalScore];
                    // 请求成功的页面
                    XZSuccessFailureView *viewSuccess = [[XZSuccessFailureView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight)];
                    [weakSelf.view addSubview:viewSuccess];
                
                    XZSuccessFailureModel *modelSF = [[XZSuccessFailureModel alloc] init];
                    modelSF.currentInter = self.totalScore;
                    modelSF.isSuccess = YES;
                    modelSF.coinNumber = [NSString stringWithFormat:@"%@",coin];
                    viewSuccess.modelSF = modelSF;
                   
                    viewSuccess.blockLookUp = ^(UIButton  *button){
                        // 130 点此查看 140 确定
                        if (button.tag == 130) { // 130 点此查看
                            // 跳到充值记录界面
                            YYRechargeRecordViewController *record = [[YYRechargeRecordViewController alloc] init];
                            [weakSelf.navigationController pushViewController:record animated:YES];
                        }else if (button.tag == 140)  { // 140 确定
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        }
                    };
                }
            }
        }
        else{ // 请求失败
            XZSuccessFailureView *viewFailure = [[XZSuccessFailureView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight)];
            [weakSelf.view addSubview:viewFailure];
            XZSuccessFailureModel *modelSF = [[XZSuccessFailureModel alloc] init];
            modelSF.currentInter = [NSString stringWithFormat:@"%@",self.totalScore];
            modelSF.isSuccess = NO;
            modelSF.coinNumber = @"";
            viewFailure.modelSF = modelSF;
            viewFailure.blockLookUp = ^(UIButton  *button){
                // 150 继续兑换 160 其他方式获得
                if (button.tag == 160) { // 其他方式获得
                    if (weakSelf.isCoinExchange) { // 从获取夺宝币跳入当前页面
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }else {
                        XZGetCoinsNewController *getCoins = [[XZGetCoinsNewController alloc] init];
                        [weakSelf.navigationController pushViewController:getCoins animated:YES];
                    }
                }
            };
        }
    }];
}

- (void)createIntegralExchangeSubView {
    // scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 64)];
    [self.view addSubview:scrollView];
    //    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.backgroundColor = XZColor(229, 233, 242);
    scrollView.contentSize = CGSizeMake(KProjectScreenWidth, KProjectScreenHeight + 100);
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    
    /** 白色视图 */
    UIView *viewWhite = [[UIView alloc] initWithFrame:CGRectMake(0, 10, KProjectScreenWidth, 300)];
    [scrollView addSubview:viewWhite];
    viewWhite.backgroundColor = [UIColor whiteColor];
    self.viewWhite = viewWhite;
    
    // 积分图片
    UIImageView *imgIntegral = [[UIImageView alloc] init];
    [viewWhite addSubview:imgIntegral];
    imgIntegral.image = [UIImage imageNamed:@"全新积分"];
    [imgIntegral mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewWhite).offset(10);
        make.top.equalTo(viewWhite).offset(10);
        make.size.equalTo(@30);
    }];
    
    /** 拥有积分 */
    UILabel *labelIntegral = [[UILabel alloc] init];
    [viewWhite addSubview:labelIntegral];
    [labelIntegral mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgIntegral.mas_right).offset(10);
        make.centerY.equalTo(imgIntegral);
    }];
    self.labelIntegral = labelIntegral;
    labelIntegral.textColor = XZColor(255, 102, 51);
    labelIntegral.font = [UIFont systemFontOfSize:15];
    self.labelIntegral.text = [NSString stringWithFormat:@"拥有积分：0"];
    /** 点击输入积分 */
    UITextField *textInput = [[UITextField alloc] init];
    [viewWhite addSubview:textInput];
    [textInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewWhite.mas_centerX);
        make.top.equalTo(labelIntegral.mas_bottom).offset(20);
        make.width.equalTo(@200);
        make.height.equalTo(@50);
    }];
    self.textInput = textInput;
    textInput.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    textInput.layer.borderWidth = 0.5f;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = XZColor(153, 153, 153);
    textInput.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"点击输入积分" attributes:attrs];
    //    textInput.placeholder = @"点击输入积分";
    textInput.delegate = self;
    textInput.textAlignment = NSTextAlignmentCenter;
    textInput.keyboardType = UIKeyboardTypeNumberPad;
    __weak __typeof(&*self)weakSelf = self;
    textInput.inputAccessoryView = [FMKeyBoardNumberHeader initKeyBoardNumberHeaderCreate:^{
        [weakSelf keyBoardDown];
    }];
    
    /** 箭头图片 */
    UIImageView *imgArrow = [[UIImageView alloc] init];
    [viewWhite addSubview:imgArrow];
    [imgArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewWhite.mas_centerX);
        make.top.equalTo(textInput.mas_bottom).offset(3);
        make.width.equalTo(@20);
        make.height.equalTo(@30);
    }];
    imgArrow.image = [UIImage imageNamed:@"箭头_积分兑换"];
    
    /** 可兑换积分 */
    UILabel *labelChangedInt = [[UILabel alloc] init];
    [viewWhite addSubview:labelChangedInt];
    [labelChangedInt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewWhite.mas_centerX);
        make.top.equalTo(imgArrow.mas_bottom).offset(3);
        make.width.equalTo(textInput.mas_width);
        make.height.equalTo(textInput.mas_height);
    }];
    self.labelChangedInt = labelChangedInt;
    labelChangedInt.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    labelChangedInt.layer.borderWidth = 0.5f;
    labelChangedInt.text = @"0";
    labelChangedInt.textColor = XZColor(255, 102, 51);
    labelChangedInt.textAlignment = NSTextAlignmentCenter;
    labelChangedInt.font = [UIFont systemFontOfSize:17];
    
    /** 兑换按钮 */
    UIButton *btnExchange = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewWhite addSubview:btnExchange];
    [btnExchange mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewWhite.mas_centerX);
        make.top.equalTo(labelChangedInt.mas_bottom).offset(20);
        make.width.equalTo(textInput.mas_width);
        make.height.equalTo(@40);
    }];
    [btnExchange setTitle:@"确认兑换" forState:UIControlStateNormal];
    [btnExchange setBackgroundColor:XZColor(1, 89, 213)];
    [btnExchange addTarget:self action:@selector(didClickSureExchangde:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)keyBoardDown {
    [self.view endEditing:YES]; // 回收键盘
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

//    if (self.isCoinExchange) { // 从积分兑换跳入，返回积分兑换
//        __weak __typeof(&*self)weakSelf = self;
//        self.navBackButtonRespondBlock = ^{
//            for (UIViewController *vc in weakSelf.navigationController.childViewControllers) {
//                if ([vc isKindOfClass:[XZGetCoinsNewController class]]) {
//                    [weakSelf.navigationController popToViewController:vc animated:YES];
//                }
//            }
//        };
//    }
@end
