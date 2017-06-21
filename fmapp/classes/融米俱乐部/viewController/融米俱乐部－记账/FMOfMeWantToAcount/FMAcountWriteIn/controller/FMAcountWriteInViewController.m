//
//  FMAcountWriteInViewController.m
//  fmapp
//
//  Created by apple on 16/6/22.
//  Copyright © 2016年 yk. All rights reserved.
//


#define KExpenseTag 2121
#define KIncomeTag 2122
#define KLendTag 2123
#define KSaveTag 2124
#define KSaveAndWriteTag 2125
#define KTimeTag 2126

#import "FMAcountWriteInViewController.h"
#import "FMSelectView.h"
#import "FMOfMeWantToAcountViewController.h"
#import "FMIncomeTypeViewController.h"
#import "FMLendView.h"
#import "NSDate+CategoryPre.h"
#import "FMDateSelectePickerView.h"
#import "FMKeyBoardNumberHeader.h"
#import "FMWWWModel.h"


@interface FMAcountWriteInViewController ()<FMDateSelectePickerViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UIView *changeBlueLine;
@property (nonatomic, strong) UITextField *moneyTextField, *noteTextField;
@property (nonatomic, strong) FMSelectView *selctView;
@property (nonatomic, assign) NSInteger buttonType;
@property (nonatomic, strong) UIButton *dateButton;
@property (nonatomic, strong) FMDateSelectePickerView *dateView;

@end

@implementation FMAcountWriteInViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self settingNavTitle:@"记一笔"];
    self.view.backgroundColor = [UIColor whiteColor];

//    [self setNavItemsWithButton];
    
    [self createChangeView];
    [self.view addSubview:self.dateView];
    self.buttonType = 1;
    
    if (self.jumpType == 2) {
        
        [self changeViewForType:[self.acountWriteModel.state integerValue]];
        self.moneyTextField.text = self.acountWriteModel.money;
        [self.selctView sendTypeWithString:self.acountWriteModel.type];
        [self.dateButton setTitle:self.acountWriteModel.time forState:(UIControlStateNormal)];
        self.noteTextField.text = self.acountWriteModel.bz;
        self.selctView.nameTextField.text = self.acountWriteModel.personName;
    }

}


- (void)createChangeView{
    
    UIButton *expenseButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    expenseButton.tag = KExpenseTag;
    [expenseButton addTarget:self action:@selector(changeAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [expenseButton setTitleColor:KContentTextColor forState:UIControlStateNormal];
    [expenseButton setTitle:@"支出" forState:(UIControlStateNormal)];
    [self.view addSubview:expenseButton];
    [expenseButton makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.height.equalTo(@40);
        make.width.equalTo(KProjectScreenWidth/3);
    }];
    
    UIButton *incomeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    incomeButton.tag = KIncomeTag;
    [incomeButton addTarget:self action:@selector(changeAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [incomeButton setTitle:@"收入" forState:(UIControlStateNormal)];
    [incomeButton setTitleColor:KContentTextColor forState:UIControlStateNormal];

    [self.view addSubview:incomeButton];
    [incomeButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(expenseButton.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.height.equalTo(@40);
        make.width.equalTo(KProjectScreenWidth/3);
    }];
    
    UIButton *lendButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    lendButton.tag = KLendTag;
    [lendButton addTarget:self action:@selector(changeAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [lendButton setTitle:@"借贷" forState:(UIControlStateNormal)];
    [lendButton setTitleColor:KContentTextColor forState:UIControlStateNormal];

    [self.view addSubview:lendButton];
    [lendButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(incomeButton.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.height.equalTo(@40);
        make.width.equalTo(KProjectScreenWidth/3);
    }];
    
    UIView *grayView =[[UIView alloc]init];
    grayView.backgroundColor = [HXColor colorWithHexString:@"#e5e9f2"];
    [self.view addSubview:grayView];
    [grayView makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(lendButton.mas_bottom);
        make.height.equalTo(@1);
    }];
    
    [self.view addSubview:self.changeBlueLine];
    [self.changeBlueLine makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(lendButton.mas_bottom).offset(-1);
        make.height.equalTo(@2);
        make.width.equalTo(KProjectScreenWidth/3);
    }];
    
    UIButton *saveButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    saveButton.tag = KSaveAndWriteTag;
    saveButton.backgroundColor = [HXColor colorWithHexString:@"#003d90"];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if(self.jumpType == 2){
    
        [saveButton addTarget:self action:@selector(deleteAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [saveButton setTitle:@"删除" forState:(UIControlStateNormal)];

    }else{
        
        [saveButton addTarget:self action:@selector(changeAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [saveButton setTitle:@"保存再记" forState:(UIControlStateNormal)];
        
    }
    
    [self.view addSubview:saveButton];
    [saveButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(20);
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
        make.height.equalTo(@40);
        make.width.equalTo(KProjectScreenWidth/3 + 15);
    }];

    UIButton *saveAndWriteButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    saveAndWriteButton.tag = KSaveTag;
    saveAndWriteButton.backgroundColor = [HXColor colorWithHexString:@"#003d90"];
    [saveAndWriteButton addTarget:self action:@selector(changeAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [saveAndWriteButton setTitle:@"保存" forState:(UIControlStateNormal)];
    saveAndWriteButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [saveAndWriteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.view addSubview:saveAndWriteButton];
    [saveAndWriteButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
        make.height.equalTo(@40);
        make.width.equalTo(KProjectScreenWidth/3 + 15);
    }];
    
    UIView *lineView =[[UIView alloc]init];
    lineView.backgroundColor = [HXColor colorWithHexString:@"#e5e9f2"];
    [self.view addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(grayView.mas_bottom).offset(50);
        make.height.equalTo(@1);
    }];
    
    UIView *lineBottomView =[[UIView alloc]init];
    lineBottomView.backgroundColor = [HXColor colorWithHexString:@"#e5e9f2"];
    [self.view addSubview:lineBottomView];
    [lineBottomView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(lineView.mas_bottom).offset(40);
        make.height.equalTo(@1);
    }];
    
    UIButton *timeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    timeButton.tag = KTimeTag;
    timeButton.backgroundColor = kColorTextColorClay;
    [timeButton addTarget:self action:@selector(changeAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [timeButton setTitle:[NSDate stringOfCurrentTime] forState:(UIControlStateNormal)];
    self.dateButton = timeButton;
    [timeButton setImage:[UIImage imageNamed:@"记账－时间"] forState:(UIControlStateNormal)];
    timeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [timeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [timeButton setContentEdgeInsets:UIEdgeInsetsMake(3, 8, 3, 5)];
    [timeButton setImageEdgeInsets:UIEdgeInsetsMake(3, -3, 3, 3)];

    [self.view addSubview:timeButton];
    [timeButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(lineBottomView.mas_bottom).offset(10);
        make.height.equalTo(@25);
    }];
    
    self.moneyTextField = [[UITextField alloc]init];
    self.moneyTextField.font = [UIFont boldSystemFontOfSize:18];
    self.moneyTextField.placeholder = @"0.00";
    self.moneyTextField.delegate = self;
    self.moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
     __weak __typeof(&*self)weakSelf = self;
    self.moneyTextField.inputAccessoryView = [FMKeyBoardNumberHeader initKeyBoardNumberHeaderCreate:^{
        [weakSelf keyBoardDown];
    }];
    self.moneyTextField.textColor = [HXColor colorWithHexString:@"ff6633"];
    [self.view addSubview:self.moneyTextField];
    [self.moneyTextField makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(lineView.mas_top).offset(-10);
    }];
    
    self.noteTextField = [[UITextField alloc]init];
    self.noteTextField.font = [UIFont boldSystemFontOfSize:13];
    self.noteTextField.placeholder = @"备注...";
    self.noteTextField.delegate = self;
    [self.view addSubview:self.noteTextField];
    [self.noteTextField makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(15);
        make.bottom.equalTo(timeButton.mas_bottom).offset(-5);
        make.width.equalTo(KProjectScreenWidth / 2);
    }];
    
    UIView *noteLineView = [[UIView alloc]init];
    noteLineView.backgroundColor = [HXColor colorWithHexString:@"#e5e9f2"];
    [self.view addSubview:noteLineView];
    [noteLineView makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view.mas_left).offset(15);
        make.bottom.equalTo(timeButton.mas_bottom);
        make.width.equalTo(KProjectScreenWidth / 2 - 20);
        make.height.equalTo(@1);
    }];
    
    FMSelectView *selctView = [[FMSelectView alloc]init];
    self.selctView = selctView;
    selctView.nameTextField.hidden = YES;
    selctView.nameTextField.delegate = self;
    selctView.selctBlock = ^(){
        [weakSelf selelcTypeForWrite];
    };
    [self.view addSubview:selctView];
    [selctView makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(lineView.mas_bottom);
        make.bottom.equalTo(lineBottomView.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
}
-(void)keyBoardDown
{
    [self.view endEditing:YES];
}

- (void)deleteAction:(UIButton *)sender{

    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=jizhang&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString * html = @"https://www.rongtuojinrong.com/rongtuoxinsoc/jizhangbill/deljilu";
    NSDictionary * paras = @{@"appid":@"jizhang",
                             @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                             @"shijian":[NSNumber numberWithInteger:timestamp],
                             @"token":tokenlow,
                             @"pid":self.acountWriteModel.pid};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [FMHTTPClient postPath:html parameters:paras completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if (response.code == WebAPIResponseCodeSuccess) {
            ShowAutoHideMBProgressHUD(self.navigationController.view, @"删除成功");
            [self.navigationController popViewControllerAnimated:YES];

        }else if (response.code == WebAPIResponseCodeFailed){
            ShowAutoHideMBProgressHUD(self.view, response.responseObject[@"msg"]);
        }else{
            ShowAutoHideMBProgressHUD(self.view, @"删除失败");
        }
    }];

}

- (void)selelcTypeForWrite{
    
    __weak typeof (self)weakSelf = self;

    if (self.buttonType == 1) {
        
        FMOfMeWantToAcountViewController *wantVC = [[FMOfMeWantToAcountViewController alloc]init];
        wantVC.typeBlock = ^(NSString *type){
            [weakSelf.selctView sendTypeWithString:type];
        };
        [self.navigationController pushViewController:wantVC animated:YES];
        
    }else if(self.buttonType == 2) {
        
        FMIncomeTypeViewController *incomeVC = [[FMIncomeTypeViewController alloc]init];
        incomeVC.typeSelectBlock = ^(NSString *type){
            [weakSelf.selctView sendTypeWithString:type];
        };
        [self.navigationController pushViewController:incomeVC animated:YES];
        
    }else{
        
        __weak typeof (self)weakSelf = self;
        FMLendView *lendView = [[FMLendView alloc]init];
        lendView.lendOutBlock = ^(NSString *title){
            [weakSelf.selctView sendTypeWithString:title];
            weakSelf.buttonType = 4;

        };
        lendView.lendOInBlock = ^(NSString *title){
            [weakSelf.selctView sendTypeWithString:title];
            weakSelf.buttonType = 3;
        };
        
        [self.view addSubview:lendView];
    }
}

- (UIView *)changeBlueLine{
    if (!_changeBlueLine) {
        _changeBlueLine = [[UIView alloc]init];
        _changeBlueLine.backgroundColor = [HXColor colorWithHexString:@"#003d90"];
    }
    return _changeBlueLine;
}

- (void)changeViewForType:(NSInteger)type{
    
    if (type == 1) {
        
        self.buttonType = 1;

        //            self.moneyTextField.text = nil;
        //            self.noteTextField.text = nil;
        self.moneyTextField.textColor = [HXColor colorWithHexString:@"ff6633"];
        self.selctView.nameTextField.hidden = YES;
        [self.selctView sendTypeWithString:@"早餐"];
        [self.changeBlueLine remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.top.equalTo(self.view.mas_top).offset(40);
            make.height.equalTo(@2);
            make.width.equalTo(KProjectScreenWidth/3);
        }];
    }else if (type == 2){
        
        self.buttonType = 2;
        //            self.moneyTextField.text = nil;
        //            self.noteTextField.text = nil;
        self.moneyTextField.textColor = XZColor(63, 204, 78);
        self.selctView.nameTextField.hidden = YES;
        [self.selctView sendTypeWithString:@"工资薪水"];
        [self.changeBlueLine remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.view.mas_top).offset(40);
            make.height.equalTo(@2);
            make.width.equalTo(KProjectScreenWidth/3);
        }];

    }else if (type == 3){
        
        self.buttonType = 3;
        //            self.moneyTextField.text = nil;
        //            self.noteTextField.text = nil;
        self.moneyTextField.textColor = [UIColor blackColor];

        self.selctView.nameTextField.hidden = NO;
        [self.selctView sendTypeWithString:@"借入"];
        [self.changeBlueLine remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(self.view.mas_top).offset(40);
            make.height.equalTo(@2);
            make.width.equalTo(KProjectScreenWidth/3);
            
        }];

    }else if (type == 4){
        
        self.buttonType = 4;
        //            self.moneyTextField.text = nil;
        //            self.noteTextField.text = nil;
        self.selctView.nameTextField.hidden = NO;
        self.moneyTextField.textColor = [UIColor blackColor];

        [self.selctView sendTypeWithString:@"借出"];
        [self.changeBlueLine remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(self.view.mas_top).offset(40);
            make.height.equalTo(@2);
            make.width.equalTo(KProjectScreenWidth/3);
            
        }];
    }

    if (self.jumpType == 2) {
        if ([self.acountWriteModel.state integerValue] == self.buttonType) {
            [self.selctView sendTypeWithString:self.acountWriteModel.type];
        }
    }
}

- (void)changeAction:(UIButton *)sender{
    
    switch (sender.tag) {
            
        case KExpenseTag:{

            [self changeViewForType:1];
            break;
        }
        case KIncomeTag:{

            [self changeViewForType:2];
            break;
        }
        case KLendTag:{

            [self changeViewForType:3];
            
            break;
        }
        case KSaveAndWriteTag:{

            if (IsStringEmptyOrNull(self.moneyTextField.text)) {
                ShowAutoHideMBProgressHUD(self.view, @"记账金额不能为空！");
                return;
            }
            
            if (self.buttonType == 3 || self.buttonType == 4) {
                
                if (IsStringEmptyOrNull(self.selctView.nameTextField.text)) {
                    ShowAutoHideMBProgressHUD(self.view, @"借贷人不能为空！");
                    return;
                }
            }
            
            [self requestSaveDatatoNetWithSuccess:^{
                
                ShowAutoHideMBProgressHUD(self.navigationController.view, @"保存成功");
            } failure:^{
                ShowAutoHideMBProgressHUD(self.navigationController.view, @"保存失败");
            }];
            
            break;
        }
        case KSaveTag:{
            
            if (IsStringEmptyOrNull(self.moneyTextField.text)) {
                ShowAutoHideMBProgressHUD(self.view, @"记账金额不能为空！");
                return;
            }
            
            if (self.buttonType == 3 || self.buttonType == 4) {
                
                if (IsStringEmptyOrNull(self.selctView.nameTextField.text)) {
                    ShowAutoHideMBProgressHUD(self.view, @"借贷人不能为空！");
                    return;
                }
            }
            
            [self requestSaveDatatoNetWithSuccess:^{
                
                ShowAutoHideMBProgressHUD(self.navigationController.view, @"保存成功");
                [self.navigationController popViewControllerAnimated:YES];
                
            } failure:^{
                ShowAutoHideMBProgressHUD(self.navigationController.view, @"保存失败");
            }];
            break;
        }
        case KTimeTag:{
            
            self.dateView.curDate = [NSDate date];
            [self.dateView showInView:self.view];
            
            break;
        }
        default:
            break;
    }
}

- (void)requestSaveDatatoNetWithSuccess:(void (^)())success failure:(void (^)())failure {
    
    __weak __typeof(self)weakSelf = self;
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"money":self.moneyTextField.text,
                                 @"usingDetailTpye":self.selctView.timeButton.titleLabel.text,
                                 @"detailAbout":self.noteTextField.text,
                                 @"date":self.dateButton.titleLabel.text,
                                 @"acountType":[NSString stringWithFormat:@"%zi",self.buttonType],
                                 @"personName":self.selctView.nameTextField.text,
                                 @"pid": self.acountWriteModel.pid ? self.acountWriteModel.pid : @""};
    
    NSString *url = self.jumpType == 2 ?[NSString stringWithFormat:@"https://www.rongtuojinrong.com/rongtuoxinsoc/jizhangbill/eidtepayapp"] :[NSString stringWithFormat:@"https://www.rongtuojinrong.com/rongtuoxinsoc/jizhangbill/addpayapp"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [FMHTTPClient postPath:url parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if (response.responseObject == nil) {
            ShowAutoHideMBProgressHUD(weakSelf.view,@"网络请求失败");
        }
        if (response.responseObject!=nil) {
            
            NSString * status = [NSString stringWithFormat:@"%@",response.responseObject[@"status"]];
            if ([status integerValue] == 0) {
                
                if ([response.responseObject objectForKey:@"data"]) {
                    
                    NSDictionary *dic = [response.responseObject objectForKey:@"data"];
                    
                    if ([[dic objectForKey:@"statusNumber"] integerValue]== 0) {
                        
                        if (success) {
                            success();
                        }
                    }else{
                        
                        if (failure) {
                            failure();
                        }
                    }
                }else{
                   ShowAutoHideMBProgressHUD(weakSelf.view,@"网络请求失败");
                }
            }else{
               ShowAutoHideMBProgressHUD(weakSelf.view,@"网络请求失败");
            }
         }
    }];
}

-(void)didFinishPickView:(NSString *)date{

    if (date == nil) {
        [self.dateButton setTitle:[NSDate stringOfCurrentTime] forState:(UIControlStateNormal)];
    }else{
        [self.dateButton setTitle:date forState:(UIControlStateNormal)];
    }
}

- (FMDateSelectePickerView *)dateView{
    
    if (!_dateView) {
        
        _dateView =[[FMDateSelectePickerView alloc]initWithFrame:CGRectMake(0,KProjectScreenHeight-200,KProjectScreenWidth, 200)];
        _dateView.delegate = self;
        _dateView.curDate=[NSDate date];
    }
    return _dateView;
}

- (void)setNavItemsWithButton{
    
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    messageButton.frame =CGRectMake(0, 0, 30, 30);
    [messageButton setImage:[UIImage imageNamed:@"对账记一笔－对号_03"] forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(moreItemAction) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *navItem = [[UIBarButtonItem alloc]initWithCustomView:messageButton];
    [self.navigationItem setRightBarButtonItems:@[navItem] animated:YES];
}

- (void)moreItemAction{
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
