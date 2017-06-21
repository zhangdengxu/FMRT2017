//
//  FMAcountAddSubViewController.m
//  fmapp
//
//  Created by apple on 16/6/22.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMAcountAddSubViewController.h"

@interface FMAcountAddSubViewController ()

@property (nonatomic, strong)UITextField *textField;

@end

@implementation FMAcountAddSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.titleType) {
        
         [self settingNavTitle:self.titleType];
    }

    [self createMainView];
    
}

- (void)requestSaveDatatoNet {
    
    __weak __typeof(self)weakSelf = self;
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"typeTotalName":@(self.ID),
                                 @"typeDetailName":self.textField.text,
                                 @"typeName":@(self.type)};
    
    NSString *url = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/rongtuoxinsoc/jizhangbill/addzilei"];
    
    [FMHTTPClient postPath:url parameters:parameter completion:^(WebAPIResponse *response) {
        
        if (response.responseObject == nil) {
            ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
        }
        if (response.responseObject!=nil) {
            
            NSString * status = [NSString stringWithFormat:@"%@",response.responseObject[@"status"]];
            if ([status integerValue] == 0) {
                
                if ([response.responseObject objectForKey:@"data"]) {
                    
                    NSDictionary *dic = [response.responseObject objectForKey:@"data"];
                    
                    if ([[dic objectForKey:@"statusNumber"] integerValue]== 0) {
                        ShowAutoHideMBProgressHUD(self.navigationController.view, @"保存成功");
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        ShowAutoHideMBProgressHUD(self.navigationController.view, @"保存失败");
                    }
                }else{
                    ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
                }
            }else{
                ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
            }
        }
        
    }];
}

- (void)createMainView{
    
    _textField = ({
        UITextField *textField = [[UITextField alloc]init];
        textField.placeholder = @"新增子类名";
        textField.font = [UIFont systemFontOfSize:14];
        textField;
    });
    [self.view addSubview:_textField];
    [_textField makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.view.mas_top).offset(30);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@40);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [HXColor colorWithHexString:@"#0159d5"];
    [self.view addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.textField.mas_bottom);
        make.left.equalTo(self.textField.mas_left);
        make.right.equalTo(self.textField.mas_right);
        make.height.equalTo(@1);
    }];
    
    UIButton *saveButton =[UIButton buttonWithType:(UIButtonTypeCustom)];
    saveButton.backgroundColor = [HXColor colorWithHexString:@"#003d90"];
    saveButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    saveButton.layer.masksToBounds = YES;
    saveButton.layer.cornerRadius = 3;
    [saveButton addTarget:self action:@selector(saveAction) forControlEvents:(UIControlEventTouchUpInside)];
    [saveButton setTitle:@"保存" forState:(UIControlStateNormal)];
    [self.view addSubview:saveButton];
    [saveButton makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(lineView.mas_bottom).offset(30);
        make.height.equalTo(@50);
    }];
    
}

- (void)saveAction{
    
    if (IsStringEmptyOrNull(self.textField.text)) {
        ShowAutoHideMBProgressHUD(self.view, @"新增类别不能为空");
        return;
    }
    [self requestSaveDatatoNet];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
