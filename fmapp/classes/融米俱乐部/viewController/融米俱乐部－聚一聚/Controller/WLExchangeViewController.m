//
//  WLExchangeViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/7/13.
//  Copyright © 2016年 yk. All rights reserved.
//
#import <MessageUI/MessageUI.h>
#import "WLExchangeViewController.h"

@interface WLExchangeViewController ()<MFMessageComposeViewControllerDelegate>

@property(nonatomic,strong)UITextField *nameTxt;
@property(nonatomic,strong)UITextField *mobileTxt;

@end

@implementation WLExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self settingNavTitle:self.name];
    [self.view setBackgroundColor:KDefaultOrBackgroundColor];
    [self createContentView];
}

-(void)createContentView{

    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 10, KProjectScreenWidth, 100)];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view2];
    
    for (int i = 0; i<2; i++) {
        
        UILabel *label1 = [[UILabel alloc]init];
        
        [label1 setTextColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.6]];
        [label1 setFont:[UIFont boldSystemFontOfSize:15]];
        
        UITextField *zhuTiText = [[UITextField alloc]init];
        zhuTiText.borderStyle = UITextBorderStyleNone;
        zhuTiText.enabled = NO;
        if (i==0) {
            [label1 setText:@"姓名"];
            [label1 setFrame:CGRectMake(15, 0, 100, 50)];
            
            [zhuTiText setFrame:CGRectMake(80, 0, self.view.frame.size.width-110, 50)];
            [zhuTiText setText:self.name];
            
            self.nameTxt = zhuTiText;
        }else{
            [label1 setText:@"手机"];
            [label1 setFrame:CGRectMake(15, 50, 100, 50)];
            [zhuTiText setFrame:CGRectMake(80, 50, self.view.frame.size.width-110, 50)];
            [zhuTiText setText:self.phoneNumber];
            [zhuTiText setKeyboardType:UIKeyboardTypeNumberPad];
            self.mobileTxt = zhuTiText;
        }
        [view2 addSubview:label1];
        [view2 addSubview:zhuTiText];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 49+50*i, KProjectScreenWidth, 1)];
        [lineView setBackgroundColor:KDefaultOrBackgroundColor];
        [view2 addSubview:lineView];
    }
 
    NSArray *nameArr = [NSArray arrayWithObjects:@"打电话",@"发短信",@"拒绝报名", nil];
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, 110, KProjectScreenWidth, 50)];
    [view3 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view3];
    
    for (int i = 0; i<3; i++) {
        
        UIView *bjView = [[UIView alloc]initWithFrame:CGRectMake(KProjectScreenWidth/3*i, 0, KProjectScreenWidth/3, 50)];
        [bjView setBackgroundColor:[UIColor whiteColor]];
        [view3 addSubview:bjView];
        
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake((KProjectScreenWidth/3-90)/2, 13, 30, 24)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((KProjectScreenWidth/3-90)/2+30, 13, 50, 24)];
        [label setFont:[UIFont systemFontOfSize:14]];
        [label setText:nameArr[i]];
        if (i==0) {
            [imgV setImage:[UIImage imageNamed:@"28.png"]];
            [imgV setFrame:CGRectMake((KProjectScreenWidth/3-90)/2, 15, 24, 20)];
        }
        if (i==1) {
            [imgV setImage:[UIImage imageNamed:@"16.png"]];
            [imgV setFrame:CGRectMake((KProjectScreenWidth/3-90)/2, 15, 27, 20)];
        }
        if (i==2) {
             [imgV setImage:[UIImage imageNamed:@"party_issue_manger_stop.png"]];
             [imgV setFrame:CGRectMake((KProjectScreenWidth/3-90)/2, 13, 24, 24)];
            [label setFrame:CGRectMake((KProjectScreenWidth/3-90)/2+30, 13, 60, 24)];
            [label setTextColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]];
        }
        [bjView addSubview:imgV];
        [bjView addSubview:label];
        
        if (i<2) {
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(KProjectScreenWidth/3-1, 16, 1, 18)];
            [lineView setBackgroundColor:KDefaultOrBackgroundColor];
            [bjView addSubview:lineView];
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, 0, KProjectScreenWidth/3, 50)];
        [button setTag:1000+i];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [bjView addSubview:button];
    }
    

}


-(void)buttonAction:(UIButton *)button{

    if (button.tag==1000) {
//       电话
        NSString *number = self.phoneNumber;
        NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",number];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
        
    }
    if (button.tag==1000+1) {
//       短信
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",self.phoneNumber]]];//发短信
//        if( [MFMessageComposeViewController canSendText] ){
//            
//            MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc]init]; 
//            
//            controller.recipients = [NSArray arrayWithObject:self.phoneNumber];
//            controller.body = @"测试发短信";
//            controller.messageComposeDelegate = self;
//            
//            [self presentViewController:controller animated:YES completion:nil];
//            [[[[controller viewControllers] lastObject] navigationItem] setTitle:@""];//修改短信界面标题
//        }else{
//            
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"设备没有短信功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//
//        }
        
    }
    if (button.tag==1000+2) {
//     拒绝报名
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"真的要拒绝此用户参加本次活动吗？" message:@"拒绝后此人将从报名列表中消失" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1000;
        [alert show];
 
        
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
          
            [self devoteJoin];
        }
    }

}

//拒绝报名
-(void)devoteJoin{

    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    __weak __typeof(&*self)weakSelf = self;
    
    
    NSString *url = @"https://www.rongtuojinrong.com/rongtuoxinsoc/Juyijuparty/refuseuserjoin";
    NSDictionary * parameter = @{
                                 @"appid":@"huiyuan",
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"shijian":[NSString stringWithFormat:@"%d",timestamp],
                                 @"token":tokenlow,
                                 @"pid":self.pid,
                                 @"phone":self.phoneNumber
                                };
    [FMHTTPClient postPath:url parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (response.code == WebAPIResponseCodeSuccess)
        {
            
          ShowAutoHideMBProgressHUD(weakSelf.view,@"拒绝报名成功");
            
        }else
        {
            ShowAutoHideMBProgressHUD(weakSelf.view,response.responseObject[@"msg"]);
            
        }
        
       
        
    }];

}



#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    [controller dismissViewControllerAnimated:NO completion:nil];//关键的一句   不能为YES
    
    switch ( result ) {
            
        case MessageComposeResultCancelled:
            
            [self alertWithTitle:@"提示信息" msg:@"发送取消"];
            break;
        case MessageComposeResultFailed:// send failed
            [self alertWithTitle:@"提示信息" msg:@"发送成功"];
            break;
        case MessageComposeResultSent:
            [self alertWithTitle:@"提示信息" msg:@"发送失败"];
            break;
        default:
            break;
    }
}


- (void) alertWithTitle:(NSString *)title msg:(NSString *)msg {
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"确定", nil];
    
    [alert show];  
    
}


@end
