//
//  ChangeNameView.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/1/28.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "ChangeNameView.h"
#import "MPAlertView.h"

@interface ChangeNameView()<UITextFieldDelegate>

@property (nonatomic, weak) UIView * backgroundView;
@property (nonatomic,strong)UITextField *nameTextField;
@property (nonatomic,strong)NSDictionary *dataList;
@end
@implementation ChangeNameView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setFrame:CGRectMake(0, 0, 350, 200)];
        
    }
    return self;
}

-(void)showSignView{
    CGRect rect = self.frame;
    
    if (KProjectScreenWidth == 320) {
        rect.size.width = rect.size.width * (320.0/375.0);
    }else if(KProjectScreenWidth > 375 )
    {
        rect.size.width = rect.size.width * (414 / 375);
    }
    
    self.frame = rect;
    self.center = CGPointMake(KProjectScreenWidth * 0.5, KProjectScreenHeight * 0.4);
    self.backgroundColor = [UIColor whiteColor];
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    UIView * backgroundView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.4;
    self.backgroundView = backgroundView;
    [window addSubview:backgroundView];
    
    self.backgroundView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo:)];
    
    [self.backgroundView addGestureRecognizer:tapGesture];
    [window bringSubviewToFront:backgroundView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 11.5, 200, 15)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"修改昵称";
    titleLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.9];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self addSubview:titleLabel];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(self.frame.size.width-32, 12, 20, 20)]; [cancelBtn setBackgroundImage:[UIImage imageNamed:@"签到关闭icon_03.png"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    

    [self.layer setCornerRadius:6.0f];
    [self.layer setMasksToBounds:YES];
    [self setAlpha:1.0f ];
    [self setUserInteractionEnabled:YES];
    [window addSubview:self];
    [window bringSubviewToFront:self];
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo:)];
    
    [self addGestureRecognizer:tapGesture1];

    
    UITextField *nameText = [[UITextField alloc]initWithFrame:CGRectMake(10, 50, self.frame.size.width-20, 30)];
    /* UITextBorderStyleLine,
     UITextBorderStyleBezel,
     UITextBorderStyleRoundedRect*/
    nameText.borderStyle = UITextBorderStyleRoundedRect;
    nameText.placeholder = @"输入昵称";
    nameText.delegate = self;
    [self addSubview:nameText];
    self.nameTextField = nameText;
    
    for (int i = 0; i<2; i++) {
        
        UILabel *middleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 90+20*i, self.frame.size.width-40, 20)];
        middleLabel.backgroundColor = [UIColor clearColor];
        if (i == 0) {
         middleLabel.text = @"3-20个字符，可由中英文、数字、“_”、“－”组成";
        }
        if (i == 1) {
         middleLabel.text = @"请将自动生成的用户名换为您的个性昵称吧！";
        }
        middleLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.8];
        middleLabel.font = [UIFont boldSystemFontOfSize:12];
        [self addSubview:middleLabel];

    }
    
    UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    [bottomBtn setFrame:CGRectMake(10, 140, self.frame.size.width-20, 40)];
    bottomBtn.backgroundColor = [UIColor colorWithRed:14/255.0f green:93/255.0f blue:210/255.0f alpha:1];
    [bottomBtn setTitle:@"保存" forState:UIControlStateNormal];
    bottomBtn.tag = 1001;

    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    [bottomBtn addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtn.layer setCornerRadius:3.0f];
    [bottomBtn.layer setMasksToBounds:YES];
    [bottomBtn setAlpha:1.0f ];
    [bottomBtn setUserInteractionEnabled:YES];

    [self addSubview:bottomBtn];

    
}

-(void)Actiondo:(id)sender{
    
    [self.nameTextField resignFirstResponder];
    
}

-(void)changeAction:(UIButton *)button{
    [self endEditing:YES];
    if (self.nameTextField.text.length == 0) {
        
//        MPAlertView *alertView = [[MPAlertView alloc]init];
//        [alertView showAlertView:@"请输入昵称"];
        ShowAutoHideMBProgressHUD(self, @"请输入昵称");
    }else{
        
        if (self.nameTextField.text.length<3) {
//            MPAlertView *alertView = [[MPAlertView alloc]init];
//            [alertView showAlertView:@"请输入长度超过3个字符的昵称"];
            ShowAutoHideMBProgressHUD(self, @"请输入长度超过3个字符的昵称");
        }else if (self.nameTextField.text.length>20) {
//            MPAlertView *alertView = [[MPAlertView alloc]init];
//            [alertView showAlertView:@"昵称长度不超过20个字符"];
            ShowAutoHideMBProgressHUD(self, @"昵称长度不超过20个字符");
        }else{
            int timestamp = [[NSDate date]timeIntervalSince1970];
            NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
            NSString *tokenlow=[token lowercaseString];
            
//            NSString *string = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/nickname?appid=huiyuan&user_id=%@&shijian=%d&token=%@&nickname=%@",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow,self.nameTextField.text];
//            Log(@"url:%@",string);
            
            __weak __typeof(&*self)weakSelf = self;
            NSDictionary *parameter = @{
                                        @"appid":@"huiyuan",
                                        @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                        @"shijian":[NSNumber numberWithInt:timestamp],
                                        @"token":tokenlow,
                                        @"nickname":self.nameTextField.text
                                        };
            [MBProgressHUD showHUDAddedTo:self animated:YES];
            [FMHTTPClient postPath:@"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/nickname" parameters:parameter completion:^(WebAPIResponse *response) {
                if (response.code == WebAPIResponseCodeFailed){
                    if ([self.delegate respondsToSelector:@selector(ChangeNameViewDidChange:WithContentString:)]) {
                        [_delegate ChangeNameViewDidChange:self WithContentString:self.nameTextField.text];
                    }
                    [self hiddenSignView];
                    
                }else{
                    ShowAutoHideMBProgressHUD(weakSelf,@"昵称修改失败");
                }
                
            }];
        }
    }
}

-(void)hiddenSignView{
    [self endEditing:YES];
    [self.backgroundView removeFromSuperview];
    [self removeFromSuperview];
}

-(void)cancelAction:(UIButton *)btn{
    [self endEditing:YES];
    [self.backgroundView removeFromSuperview];
    [self removeFromSuperview];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {


   
}

@end
