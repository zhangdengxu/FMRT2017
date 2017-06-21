//
//  FMRTPayOrderViewController.m
//  fmapp
//
//  Created by apple on 2017/5/3.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRTPayOrderViewController.h"
///商户号
static NSString *kLLOidPartner = @"201306031000001013";

static NSString *signType   = @"RSA";   //签名方式
static NSString *money_order = @"0.01";
static NSString *userId     = @"alksfj"; //user_id,必传
//四要素
static NSString *cardNumber = @"6212261202029657468";  //卡号
static NSString *acctName   = @"林运芳";  //姓名
static NSString *idNumber   = @"330327199210216090";  //身份证号
static NSString *bindMob    = @"18768102901";  //手机号



@interface FMRTPayOrderViewController ()

@property (nonatomic, strong) NSMutableDictionary *orderDic;

@end

@implementation FMRTPayOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)llorder {
    NSString *timeStamp = [self timeStamp];
    self.orderDic = [NSMutableDictionary dictionary];
    self.orderDic[@"api_version"] = @"1.0";
    self.orderDic[@"sign_type"] = signType;
    self.orderDic[@"busi_partner"] = @"101001";
    self.orderDic[@"dt_order"] = timeStamp;
    self.orderDic[@"no_order"] = [NSString stringWithFormat:@"LL%@", timeStamp];
    self.orderDic[@"name_goods"] = @"商品名称";
    self.orderDic[@"info_order"] = timeStamp;
    self.orderDic[@"time_stamp"] = timeStamp;
    self.orderDic[@"valid_order"] = @"10080";
    self.orderDic[@"notify_url"] = @"http://test.yintong.com.cn:80/apidemo/API_DEMO/notifyUrl.htm";
    self.orderDic[@"risk_item"] = [self jsonStringOfObj:@{@"user_info_dt_register" : @"20131030122130"}];
    self.orderDic[@"flag_pay_product"] = @"1";//认证支付传1
    self.orderDic[@"flag_chnl"] = @"1";
    self.orderDic[@"bind_mob"] = bindMob;
    self.orderDic[@"oid_partner"] = kLLOidPartner;
    self.orderDic[@"acct_name"] = acctName;
    self.orderDic[@"card_no"] = cardNumber;
    self.orderDic[@"id_no"] = idNumber;
    self.orderDic[@"id_type"] = @"0";
    self.orderDic[@"user_id"] = userId;
}

#pragma mark - 模拟创单
- (void)paymentTokenWithDic: (NSDictionary *)paramDic isSign: (BOOL)sign {
    __block NSString *token = @"";
    __block NSDictionary *jsonObject = nil;
    
    NSString *path = [self pathForCreateBill:sign];
    NSLog(@"请求创单地址%@",path);
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSString *param = [self jsonStringOfObj:paramDic];
    NSLog(@"👉请求参数%@",paramDic);
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    request.timeoutInterval = 60;
    
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    //请求模拟创单
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (error) {
            NSLog(@"请求失败%@",error.description);
            return;
        }
        jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSString *resultTitle = [NSString stringWithFormat:@"模拟%@创单结果",sign?@"签约":@"支付"];
        NSLog(@"\n\n********** 👇👇👇%@👇👇👇 **********\n\n",resultTitle);
        NSLog(@"%@",jsonObject);
        token = [jsonObject valueForKey:@"token"];
        if (token) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self payWithToken:token isSign:sign];
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *msg = jsonObject[@"ret_msg"];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"创单失败提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            });
        }
    }];
    [task resume];
}

- (NSString *)pathForCreateBill: (BOOL)isSign {
    NSString *serverUrl = @"https://fourelementapi.lianlianpay.com";
    NSString *path = [NSString stringWithFormat:@"%@/mock/%@createbill",serverUrl,isSign?@"sign":@"pay"];
    return path;
}

#pragma mark - 签约支付
- (void)payWithToken: (NSString *)token isSign: (BOOL)sign {
    NSMutableDictionary *paymentInfo = [NSMutableDictionary dictionary];
    paymentInfo[@"token"] = token;
    paymentInfo[@"user_id"] = userId?:nil;
    paymentInfo[@"oid_partner"] = kLLOidPartner?:nil;
    paymentInfo[@"no_order"] = self.orderDic[@"no_order"]?:nil;
    
    if (sign) {
        [[LLPaySdk sharedSdk] signApply:[paymentInfo copy] inVC:self completion:^(LLPayResult result, NSDictionary *dic) {
            [self paymentEnd:result withResultDic:dic isSign:sign];
        }];
    }else {
        paymentInfo[@"money_order"] = self.orderDic[@"money_order"];
        [[LLPaySdk sharedSdk] payApply:[paymentInfo copy]
                                  inVC:self
                            completion:^(LLPayResult result, NSDictionary *dic) {
                                [self paymentEnd:result withResultDic:dic isSign:sign];
                            }];
    }
}

- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic isSign: (BOOL)sign {
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
    NSString *showMsg = [msg stringByAppendingString:[self jsonStringOfObj:dic]];
    NSString *title = [NSString stringWithFormat:@"%@结果",sign?@"签约":@"支付"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:showMsg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确认"
                                              style:UIAlertActionStyleDefault
                                            handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - common methods
- (NSString*)jsonStringOfObj:(NSDictionary*)dic{
    NSError *err = nil;
    
    NSData *stringData = [NSJSONSerialization dataWithJSONObject:dic
                                                         options:0
                                                           error:&err];
    
    NSString *str = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
    
    return str;
}

- (NSString *)timeStamp {
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyyMMddHHmmss"];
    NSString *simOrder = [dateFormater stringFromDate:[NSDate date]];
    return simOrder;
}

- (void)createUI {
    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    detailBtn.frame = CGRectMake(0, 0, 20, 20);
    [detailBtn addTarget:self action:@selector(showSDKInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rigntBBI = [[UIBarButtonItem alloc] initWithCustomView:detailBtn];
    self.navigationItem.rightBarButtonItem = rigntBBI;
    
    self.title = @"LianLianPay";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn.frame = CGRectMake(20, 100, self.view.frame.size.width - 40, 60);
    signBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [signBtn setTitle:@"Sign" forState:UIControlStateNormal];
    [signBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signBtn setBackgroundColor:[UIColor colorWithRed:2/255.0 green:138/255.0 blue:215/255.0 alpha:1]];
    [signBtn addTarget:self action:@selector(llsign) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signBtn];
    
    
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payBtn.frame = CGRectMake(20, 200, self.view.frame.size.width - 40, 60);
    payBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [payBtn setTitle:@"Pay" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payBtn setBackgroundColor:[UIColor colorWithRed:2/255.0 green:138/255.0 blue:215/255.0 alpha:1]];
    [payBtn addTarget:self action:@selector(llpay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payBtn];
    
    
}

- (void)llsign {
    [self llorder];
    [self paymentTokenWithDic:[self.orderDic copy] isSign:YES];
}

- (void)llpay {
    [self llorder];
    self.orderDic[@"money_order"] = money_order;
    [self paymentTokenWithDic:[self.orderDic copy] isSign:NO];
}

- (void)showSDKInfo {
    NSDictionary *sdkInfoDic = @{@"BuildVersion":kLLPaySDKBuildVersion,
                                 @"SDKVersion":kLLPaySDKVersion,};
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"SDK版本" message:[NSString stringWithFormat:@"%@",sdkInfoDic] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
