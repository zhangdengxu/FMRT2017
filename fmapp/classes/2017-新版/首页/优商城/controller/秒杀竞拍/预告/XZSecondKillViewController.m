//
//  XZSecondKillViewController.m
//  XZProject
//
//  Created by admin on 16/8/10.
//  Copyright © 2016年 admin. All rights reserved.
//  限时秒杀

#import "XZSecondKillViewController.h"
#import "XZWeakTimer.h"
#import "XZSecondKillModel.h"
#import "WLPublishSuccessViewController.h" // 分享界面
#import "XZActivityModel.h" // 分享
#import "YSStaticShareSkipView.h"
#import "WLDJQTABViewController.h"
#import "XZConfirmOrderKillViewController.h"// 确认订单
#import "MZTimerLabel.h"

#define kXZSecondKillRedEnVelope @"https://www.rongtuojinrong.com/java/public/ticket/getTicket"
@interface XZSecondKillViewController ()<MZTimerLabelDelegate>{
    dispatch_source_t _timer;
}
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UILabel *labelPhone;
@property (nonatomic, strong) NSTimer *timerXZ;
@property (nonatomic, assign) NSInteger index;
/** 倒计时的时间 */
@property (nonatomic, strong) UILabel *labelTime;
@property (nonatomic, strong) NSDateComponents *nowCmps;
@property (nonatomic, strong) NSString *next_start;
/** 本期幸运用户 */
@property (nonatomic, strong) UILabel *labelLuckyUser;
/** 秒杀或者竞拍提示 */
@property (nonatomic, strong) NSString *PromptStr;
/** 分享领取折价券 */
@property (nonatomic, strong) UIButton *btnReceiveTicket;
@property (nonatomic, strong) MZTimerLabel *redStopwatch;
@end

@implementation XZSecondKillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //
    if ([self.flag isEqualToString:@"auction"]) {
        [self settingNavTitle:@"竞拍夺宝"];
    }else {
        [self settingNavTitle:@"限时秒杀"];
    }
    
    // 搭建界面
    [self buildInterface];
    self.index = 0;
    
    // 从网络上获取数据
    [self getDataFromNetWork];
}

// 从网络上获取数据
- (void)getDataFromNetWork {
    int timestamp = [[NSDate date] timeIntervalSince1970];
//    NSDictionary *parameter;
    
    NSString *useId = [CurrentUserInformation sharedCurrentUserInfo].userId ? [CurrentUserInformation sharedCurrentUserInfo].userId : @"0";
    
//    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) {// 用户已登录
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",useId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary *parameter = @{
                              @"user_id":useId,
                              @"appid":@"huiyuan",
                              @"shijian":[NSNumber numberWithInt:timestamp],
                              @"token":tokenlow,
                              @"tel":[CurrentUserInformation sharedCurrentUserInfo].mobile,
                              @"activity_id":self.activity_id,
                              @"flag":self.flag
                              }; // 27 32
//    }else {// 用户未登录
//        NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",@"0",timestamp]);
//        NSString *tokenlow=[token lowercaseString];
//        parameter = @{
//                      @"user_id":@"0",
//                      @"appid":@"huiyuan",
//                      @"shijian":[NSNumber numberWithInt:timestamp],
//                      @"token":tokenlow,
//                      @"activity_id":self.activity_id,
//                      @"flag":self.flag
//                      }; // 27 32
//    }
    
    __weak __typeof(&*self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *navUrl =[NSString stringWithFormat:@"%@/public/show/getWinnerList",kXZTestEnvironment];
    
    //@"https://www.rongtuojinrong.com/java/public/show/getWinnerList"
    
    [FMHTTPClient postPath:navUrl parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (response.code == WebAPIResponseCodeSuccess) {
            if (![response.responseObject isKindOfClass:[NSNull class]]) {
                NSDictionary *dicData = response.responseObject[@"data"];
                NSArray *listArray = dicData[@"list"];
                self.next_start = dicData[@"next_start"];
                if (listArray.count != 0) {
                    for (NSDictionary *dic in listArray) {
                        XZSecondKillModel *modelSecondKill = [[XZSecondKillModel alloc] init];
                        [modelSecondKill setValuesForKeysWithDictionary:dic];
                        [self.dataSource addObject:modelSecondKill];
                    }
                    [self createPhoneLabel];
                }
                else {
                    self.labelTime.text = [NSString stringWithFormat:@"活动已结束"];
                }
            }else{
                ShowAutoHideMBProgressHUD(weakSelf.view,@"加载数据失败");
            }
        }
    }];

}

// 请求分享的数据
- (void)getShareDataFromNetWork {
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{
                                 @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"tel":[CurrentUserInformation sharedCurrentUserInfo].mobile,
                                 @"flag":self.flag
                                 };
    __weak __typeof(&*self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *navUrl =[NSString stringWithFormat:@"%@/public/other/getShareInfo",kXZTestEnvironment];
    //@"https://www.rongtuojinrong.com/java/public/other/getShareInfo"
    
    [FMHTTPClient postPath:navUrl parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (response.code == WebAPIResponseCodeSuccess) {
            if (response.responseObject != nil) {
                NSDictionary *dicData = response.responseObject[@"data"];
                if (![dicData isKindOfClass:[NSNull class]]) {
                    XZActivityModel *model = [[XZActivityModel alloc] init];
                    model.sharetitle = dicData[@"title"];
                    model.sharepic = dicData[@"img"];
                    if ([self.flag isEqualToString:@"auction"]) { // 竞拍
                        model.shareurl = [NSString stringWithFormat:@"%@?appid=huiyuan&token=%@&shijian=%@&user_id=%@&flag=%@",dicData[@"link"],tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId,@"2"];
                    }else {// 秒杀
                        model.shareurl = [NSString stringWithFormat:@"%@?appid=huiyuan&token=%@&shijian=%@&user_id=%@&flag=%@",dicData[@"link"],tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId,@"1"];
                    }
                    model.sharecontent = dicData[@"content"];
                    // 请求成功
                    WLPublishSuccessViewController *publishSuccess = [[WLPublishSuccessViewController alloc] init];
                    publishSuccess.tag = self.flag;
                    publishSuccess.navTitle = @"分享";
                    publishSuccess.modelActivity = model;
                    [self.navigationController pushViewController:publishSuccess animated:YES];
                }else{
                    ShowAutoHideMBProgressHUD(weakSelf.view,@"请求分享数据失败");
                }
            }else{
                ShowAutoHideMBProgressHUD(weakSelf.view,@"请求分享数据失败");
            }
        }
    }];
}

#pragma mark - MZTimerLabelDelegate
- (NSString*)timerLabel:(MZTimerLabel *)timerLabel customTextToDisplayAtTime:(NSTimeInterval)time{
    
    if([timerLabel isEqual:_redStopwatch]){
        int second = (int)time  % 60;
        int minute = ((int)time / 60) % 60;
        int hours = time / 3600;
        return [NSString stringWithFormat:@"%@\n%02d:%02d:%02d",self.PromptStr,hours,minute,second];
    }
    else
        return nil;
}


// 倒计时
- (void)countDown:(NSString *)time {
    [self.redStopwatch setCountDownTime:[time longLongValue]];
    [self.redStopwatch startWithEndingBlock:^(NSTimeInterval countTime) {
        self.labelTime.text = [NSString stringWithFormat:@"活动已结束"];
    }];
}

// 搭建界面
- (void)buildInterface {
    UIScrollView *bottomScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 64)];
    bottomScroll.contentSize = CGSizeMake(KProjectScreenWidth, KProjectScreenHeight + 70);
    bottomScroll.backgroundColor = [UIColor whiteColor];
    //        _bottomScroll.delegate = self;
//    bottomScroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:bottomScroll];
    if (KProjectScreenHeight > 480) {
        bottomScroll.scrollEnabled = NO;
    }
    /** 气球 */
    UIImageView *imgPhoto = [[UIImageView alloc] init];
    [bottomScroll addSubview:imgPhoto];
    [imgPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomScroll);
        make.left.equalTo(bottomScroll);
        make.width.equalTo(KProjectScreenWidth);
        make.height.equalTo(KProjectScreenWidth * 832 / 640); // self.view.mas_centerY).offset((150/320.0 * KProjectScreenWidth)
    }];
    imgPhoto.image = [UIImage imageNamed:@"气球背景_02"];
    
    /** 天下武功，唯快不破 */
    UIImageView *imgIcon = [[UIImageView alloc] init];
    [imgPhoto addSubview:imgIcon];
    [imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgPhoto.mas_top).offset(60 / 320.0 * KProjectScreenWidth);
        make.centerX.equalTo(imgPhoto.mas_centerX);
        make.width.equalTo(457 * 0.5); // 457 * 0.5   @((57.5 / 320.0 * KProjectScreenWidth) / (115 / 457.0))
        make.height.equalTo(115 * 0.5); //115 * 0.5 @(57.5 / 320.0 * KProjectScreenWidth)
    }];
    imgIcon.image = [UIImage imageNamed:@"天下武功_03"];
    
    /** 本期幸运用户 */
    UILabel *labelLuckyUser = [[UILabel alloc] init];
    [imgPhoto addSubview:labelLuckyUser];
    [labelLuckyUser mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imgPhoto.mas_centerX);
        make.top.equalTo(imgIcon.mas_bottom).offset(3);
    }];
    self.labelLuckyUser = labelLuckyUser;
    labelLuckyUser.text = @"本期幸运用户";
    if (KProjectScreenHeight < 500) {
        labelLuckyUser.font = [UIFont systemFontOfSize:13];
    }else {
        labelLuckyUser.font = [UIFont systemFontOfSize:17];
    }
    labelLuckyUser.textColor = [UIColor darkGrayColor];
    
    /** 倒计时 */
    UIImageView *imgCountDown = [[UIImageView alloc] init];
    [imgPhoto addSubview:imgCountDown];
    [imgCountDown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imgPhoto.mas_centerX);
        make.centerY.equalTo(imgPhoto.mas_centerY).offset(50/320.0 * KProjectScreenWidth + 10);
        make.width.equalTo(@((70/320.0 * KProjectScreenWidth) / 165 * 323)); // 160  + 30)
        make.height.equalTo(@(60/320.0 * KProjectScreenWidth));
    }];
    imgCountDown.image = [UIImage imageNamed:@"白色背景_04"];
    
    /** 倒计时的时间 */
    UILabel *labelTime = [[UILabel alloc] init];
    [imgCountDown addSubview:labelTime];
    [labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imgCountDown.mas_centerX);
        make.centerY.equalTo(imgCountDown.mas_centerY);
    }];
    self.labelTime = labelTime;
    labelTime.numberOfLines = 2;
    labelTime.textColor = [UIColor redColor];
//    labelTime.font = [UIFont boldSystemFontOfSize:20];
    labelTime.font = [UIFont boldSystemFontOfSize:20.0f];
    labelTime.textAlignment = NSTextAlignmentCenter;
    self.labelTime.text = [NSString stringWithFormat:@"距下次竞拍\n00:00:00"];
    
    /** 分享领取折价券 */
    UIButton *btnReceiveTicket = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btnReceiveTicket];
    [btnReceiveTicket  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgPhoto.mas_bottom).offset(35); // self.view.mas_bottom).offset(-(50/480.0 *KProjectScreenHeight)
        make.centerX.equalTo(imgPhoto.mas_centerX);
        make.width.equalTo(@(KProjectScreenWidth * 0.7));
        make.height.equalTo(@40);
    }];
    self.btnReceiveTicket = btnReceiveTicket;
    [btnReceiveTicket setTitle:@"分享领取折价券" forState:UIControlStateNormal];
    [btnReceiveTicket setBackgroundColor:[UIColor redColor]];
    btnReceiveTicket.layer.masksToBounds = YES;
    btnReceiveTicket.layer.cornerRadius = 20;
    [btnReceiveTicket.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [btnReceiveTicket addTarget:self action:@selector(didClickReceiveTicketButton) forControlEvents:UIControlEventTouchUpInside];
//    self.btnReceiveTicket.userInteractionEnabled = NO;
}

// 点击分享领取折价券
- (void)didClickReceiveTicketButton {
    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) {// 已登录
        // 请求分享的数据
        [self getShareDataFromNetWork];
    }else { // 未登录
        LoginController *registerController = [[LoginController alloc] init];
        FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
        [self.navigationController presentViewController:navController animated:YES completion:^{
        }];
    }
}

// 创建幸运用户的label
- (void)createPhoneLabel {
    // 循环创建label
    void(^blockCreateLabel)() = ^() {
        for (int i = 0; i < (self.dataSource.count > 5 ? 5 : self.dataSource.count); i++) {
            XZSecondKillModel *modelSecondKill = self.dataSource[i];
            //
            UILabel *labelPhone = [self createLabelTopView:self.labelLuckyUser text:[NSString stringWithFormat:@"%@",modelSecondKill.phone] offSet:(i * 20)];
            self.labelPhone = labelPhone;
        }
    };
    blockCreateLabel();
    if ([self.next_start doubleValue] > 0) {
        if ([self.flag isEqualToString:@"kill"]) {
            self.PromptStr = @"距下次秒杀";
        }else {
            self.PromptStr = @"距下次竞拍";
        }
        // 倒计时
        [self countDown:self.next_start];
    }else {
        self.labelTime.text = [NSString stringWithFormat:@"活动已结束"];
    }
}

// 创建显示手机号的label
- (UILabel *)createLabelTopView:(UIView *)topView text:(NSString *)text offSet:(CGFloat)offSet{
    UILabel *labelPhone = [[UILabel alloc] init];
    [self.view addSubview:labelPhone];
    [labelPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(topView.mas_bottom).offset(offSet);
    }];
    labelPhone.text = text;
    labelPhone.textColor = [UIColor whiteColor];
    labelPhone.numberOfLines = 2;
    if (KProjectScreenWidth < 350) {
        labelPhone.font = [UIFont systemFontOfSize:13];
    }else {
        labelPhone.font = [UIFont systemFontOfSize:15];
    }
    return labelPhone;
}

#pragma mark ---- 懒加载
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (MZTimerLabel *)redStopwatch{
    if (!_redStopwatch) {
        _redStopwatch = [[MZTimerLabel alloc]initWithLabel:self.labelTime andTimerType:(MZTimerLabelTypeTimer)];
        _redStopwatch.timeLabel.font = [UIFont boldSystemFontOfSize:20.0f];
        _redStopwatch.timeLabel.textColor = [UIColor redColor];
        _redStopwatch.delegate = self;
    }
    return _redStopwatch;
}

@end
