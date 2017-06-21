//
//  FMRTBabyAddJIARUJINEViewController.m
//  fmapp
//
//  Created by apple on 16/9/19.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTBabyAddJIARUJINEViewController.h"
#import "FMKeyBoardNumberHeader.h"


@interface FMRTBabyAddJIARUJINEViewController ()

@property (nonatomic, strong) UITextField *textField;

@end

@implementation FMRTBabyAddJIARUJINEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"加入金额"];
    self.view.backgroundColor = KDefaultOrBackgroundColor;
    [self createContentView];
}
-(void)keyBoardDown
{
    [self.view endEditing:YES];
}

- (void)createContentView{
    
    UIView *whiteView = [[UIView alloc]init];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    [whiteView makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.view.mas_top).offset(10);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@160);
    }];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"每期定投金额:";
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textColor = XZColor(33, 76, 150);
    [whiteView addSubview:nameLabel];
    [nameLabel makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.view.mas_centerX).offset(-30);
        make.top.equalTo(whiteView.mas_top).offset(45);
    }];
    
    UITextField *textField = [[UITextField alloc]init];
    textField.font = [UIFont systemFontOfSize:13];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.layer.borderWidth = 1;
    textField.layer.borderColor = KBorderColorSetup.CGColor;
    self.textField = textField;
     __weak __typeof(&*self)weakSelf = self;
    textField.inputAccessoryView = [FMKeyBoardNumberHeader initKeyBoardNumberHeaderCreate:^{
        [weakSelf keyBoardDown];
    }];
    [whiteView addSubview:textField];
    [textField makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(nameLabel.mas_centerY);
        make.left.equalTo(nameLabel.mas_right).offset(5);
        make.width.equalTo(@160);
        make.height.equalTo(@30);
    }];
    
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.text = self.model.tishineirong;
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = [UIColor redColor];
    contentLabel.font = [UIFont systemFontOfSize:12];
    [whiteView addSubview:contentLabel];
    [contentLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(textField.mas_left);
        make.right.equalTo(textField.mas_right).offset(20);
        make.top.equalTo(textField.mas_bottom).offset(10);
    }];
    
    
    UIButton *saveButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [saveButton addTarget:self action:@selector(saveAction) forControlEvents:(UIControlEventTouchUpInside)];
    [saveButton setTitle:@"保存" forState:(UIControlStateNormal)];
    saveButton.backgroundColor = [HXColor colorWithHexString:@"#0159d5"];
    saveButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    saveButton.titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:saveButton];
    [saveButton makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(whiteView.mas_bottom).offset(40);
        make.width.equalTo(KProjectScreenWidth - 100);
        make.height.equalTo(@40);
    }];
}

- (void)saveAction{
    
    if ([self.textField.text floatValue] < [self.model.Jiner floatValue] || [self.textField.text floatValue]>20000) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"您修改的金额不符合宝贝计划要求，\n请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (([self.textField.text longLongValue] % 100) != 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"投标金额必须是100的整数倍，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    [self requestForSaveData];
}

- (void)requestForSaveData{
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"jiner":self.textField.text,
                                 @"autot_id":self.model.autot_id,
                                 @"jie_id":self.model.jie_id};
    
    __weak __typeof(self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:@"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/bbjhupact" parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];

         if (response.code==WebAPIResponseCodeSuccess) {
             ShowAutoHideMBProgressHUD(weakSelf.view,@"保存成功！");
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [weakSelf.navigationController popViewControllerAnimated:YES];
                 if (weakSelf.popBlock) {
                     weakSelf.popBlock();
                 }
             });
         }else{
             ShowAutoHideMBProgressHUD(weakSelf.view,@"保存失败！");
         }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
