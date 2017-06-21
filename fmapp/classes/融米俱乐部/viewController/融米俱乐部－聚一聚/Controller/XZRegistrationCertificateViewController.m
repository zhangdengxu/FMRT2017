//
//  XZRegistrationCertificateViewController.m
//  fmapp
//
//  Created by admin on 16/6/29.
//  Copyright © 2016年 yk. All rights reserved.
// 报名凭证

#import "XZRegistrationCertificateViewController.h"
#import "XZRegisterationCertificateView.h"
// 数据请求
#import "XZRegistrationCertificateModel.h"

/** 报名凭证 */
#define kRegisterCertificateURL @"https://www.rongtuojinrong.com/rongtuoxinsoc/Juyijuparty/usersignvoucher"

@interface XZRegistrationCertificateViewController ()
@property (nonatomic, strong) XZRegisterationCertificateView *certificate;
@end

@implementation XZRegistrationCertificateViewController

- (XZRegisterationCertificateView *)certificate {
    if (!_certificate) {
        _certificate = [[XZRegisterationCertificateView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, (KProjectScreenWidth * (15 / 32.0)) + 160)];
    }
    return _certificate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XZColor(230, 235, 240);
    [self settingNavTitle:@"报名凭证"];
    [self.view addSubview:self.certificate];
    [self requestRegistrationCertificateData];
}

#pragma mark ----- 请求数据
- (void)requestRegistrationCertificateData {
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSDictionary * parameter = @{
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"pid":[NSString stringWithFormat:@"%@",self.pid],
                                 @"phone":[NSString stringWithFormat:@"%@",self.phone]
                                 };
    
    __weak __typeof(&*self)weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [FMHTTPClient postPath:kRegisterCertificateURL parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (response.code == WebAPIResponseCodeSuccess) {
            if (![response.responseObject[@"data"] isKindOfClass:[NSNull class]]) {
                NSDictionary *dataDict = response.responseObject[@"data"];
                XZRegistrationCertificateModel *modelCertificate = [[XZRegistrationCertificateModel alloc]init];
                [modelCertificate setValuesForKeysWithDictionary:dataDict];
                self.certificate.modelCertificate = modelCertificate;
            }else {
                ShowAutoHideMBProgressHUD(weakSelf.view,@"请重新加载");
            }
        }else{
             ShowAutoHideMBProgressHUD(weakSelf.view,@"请重新加载");
        }
    }];
    
}

@end
