//
//  WLNewProjectDetailViewController.m
//  fmapp
//
//  Created by 秦文龙 on 17/2/13.
//  Copyright © 2017年 yk. All rights reserved.
//
#define KdefauleMargion 30

#import "WLNewProjectDetailViewController.h"
#import "MoreProjectController.h"
#import "HTTPClient+Interaction.h"
#import "ProjectModel.h"
#import "WLNewWebViewController.h"
#import "UMFeedback.h"
#import "UMSocial.h"
//#import "XMMakeABidSuccessViewController.h"
#import "MakeABidWebViewController.h"
#import "AXRatingView.h"
#import "FMPlaceOrderViewController.h"
#import "FMShareModel.h"
#import "FMRTMainListModel.h"
#import "WLNewEvaluateViewController.h"
#import "WLNewBesureViewController.h"
#import "XZRiskQuestionnaireViewController.h"
#import "WLZhuCeViewController.h"
#import "FMRTAddCardToView.h"
#import "FMTieBankCardViewController.h"
#import "FMRTChangeTradeKeyViewController.h"

#define SHAREImageViewTag  2000

#define SHAREButtonTag  1000
#define KCircleOuterRadius          100.0f
#define KCircleBorderWidth          12.0f
#define KCircleInsideRadius         (100.0f - KCircleBorderWidth*2)

#define KCircleOuterImageColor      [UIColor colorWithRed:226.0f/255.0f green:226.0f/255.0f blue:226.0f/255.0f alpha:1.0f]
#define KCornerRadiusBorderColor    [UIColor colorWithRed:20.0f/255.0f green:153.0f/255.0f blue:240.0f/255.0f alpha:1.0f]

@interface WLNewProjectDetailViewController ()
<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate,UIAlertViewDelegate>{
    
    NSMutableDictionary *dic;//创建一个字典进行判断收缩还是展开
    UIView *infoView;
}

@property(nonatomic,assign)int  projectStyle;
@property(nonatomic,copy)NSString *projectId;
@property(nonatomic,copy)NSString *xianyou;
@property(nonatomic,copy)NSString *fengxiandengji;
@property(nonatomic,copy)NSString *dizenge;
@property(nonatomic,strong)ProjectModel *model;
@property(nonatomic,weak)UIButton *bottomBtn;
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIView *midView;
@property(nonatomic,strong)UILabel *firstLabel;//显示飘窗的label

@property(nonatomic,strong)UIImageView *shareImage;
@property(nonatomic,strong)FMShareModel *shareModel;
@property(nonatomic,strong)UIView * gifImageView;//飘窗
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIImageView *trangleImag;

@property(nonatomic,strong)NSArray *titleArr;
@property(nonatomic,strong)NSArray *contentArr;

@property(nonatomic,assign)BOOL isOpen;
@property(nonatomic,assign)BOOL isStart;
@property(nonatomic,assign)BOOL isNum;
@property(nonatomic,strong) AXRatingView *halfStepRatingView;//小星星
@property(nonatomic,strong) FMShowWaitView *showWait;

@end

@implementation WLNewProjectDetailViewController
/**
 *初始化ProjectOperationStyle
 */
- (id)initWithUserOperationStyle:(int)m_OperationStyle WithProjectId:(NSString *)projectId
{
    self=[super init];
    if (self) {
        self.projectStyle=m_OperationStyle;
        self.projectId=projectId;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];
    [self getProjectDetailData];
    [self isShiming];

}

-(void)isShiming{//判断是否实名 如果没有 则重新请求数据

    if (([CurrentUserInformation sharedCurrentUserInfo].userLoginState)) {
        if ([[CurrentUserInformation sharedCurrentUserInfo].huishangshiming integerValue] == 1) {
            [[CurrentUserInformation sharedCurrentUserInfo] checkUserInfoWithNetWork];
            return;
        }
    }
}

- (FMShowWaitView *)showWait{
    if (!_showWait) {
        _showWait = [[FMShowWaitView alloc] init];
        _showWait.waitType = FMShowWaitViewTpyeFitALL;
    }
    return _showWait;
}

- (ProjectModel *)model{
    if (!_model) {
        _model = [[ProjectModel alloc] init];
    }
    return _model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isOpen = NO;
    self.isStart = NO;
    if (self.NoCreateRightBtn) {
        [self settingNavTitle:@"注资专标"];
    }else {
        [self settingNavTitle:@"项目信息"];
    }
    dic = [NSMutableDictionary dictionary];
    [self.view setBackgroundColor:KDefaultOrBackgroundColor];
    [self.view addSubview:self.tableView];
    self.tableView.hidden = YES;
    [self theHeaderView];
    [self createFooderView];

}

-(void)theHeaderView{

    UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bottomBtn setBackgroundColor:[HXColor colorWithHexString:@"#0159d5"]];
    [bottomButton setTitle:@"立即投资" forState:UIControlStateNormal];
    bottomButton.titleLabel.font=[UIFont boldSystemFontOfSize:16.0f];
    [bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomButton setFrame:CGRectMake(0, KProjectScreenHeight-55-64, KProjectScreenWidth, 55)];
    [self.view addSubview:bottomButton];
    bottomButton.tag = 852;
    self.bottomBtn = bottomButton;
}

-(void)createBottomBtn{
    
    if (self.projectStyle==3) {
        [self.bottomBtn setBackgroundColor:[UIColor colorWithRed:169/255.0f green:170/255.0f blue:171/255.0f alpha:1]];
    }
    if (self.projectStyle==2) {
        [self.bottomBtn setTitle:@"立即投资" forState:UIControlStateNormal];
        //这里只判断是否登录 未登录灰色不可点击
        if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
//            if (self.fengxiandengji.length>0) {
//                //这里只判断风险评估是否符合
//                //不符合 立即投资灰色不可点击
//                [self.bottomBtn setBackgroundColor:[UIColor colorWithRed:169/255.0f green:170/255.0f blue:171/255.0f alpha:1]];
//            }else{
            
            if ([self.model.fengxianwenjuan intValue]){
                if (self.fengxiandengji.length>0) {
                                    //这里只判断风险评估是否符合
                                    //不符合 立即投资灰色不可点击
                     [self.bottomBtn setBackgroundColor:[UIColor colorWithRed:169/255.0f green:170/255.0f blue:171/255.0f alpha:1]];
                    self.bottomBtn.userInteractionEnabled = NO;
                
                }else{
                    //不符合 蓝色可点击
                    [self.bottomBtn setBackgroundColor:[HXColor colorWithHexString:@"#0159d5"]];
                    [self.bottomBtn addTarget:self action:@selector(bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
                    self.bottomBtn.userInteractionEnabled = YES;
                }
                
            }else{
                //不符合 蓝色可点击
                [self.bottomBtn setBackgroundColor:[HXColor colorWithHexString:@"#0159d5"]];
                [self.bottomBtn addTarget:self action:@selector(bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
                self.bottomBtn.userInteractionEnabled = YES;
            }
        }else{
        
            [self.bottomBtn setBackgroundColor:[UIColor colorWithRed:169/255.0f green:170/255.0f blue:171/255.0f alpha:1]];
        }
    }
    if (self.projectStyle==1) {
        [self.bottomBtn setBackgroundColor:[HXColor colorWithHexString:@"#0159d5"]];
        [self dealBottomBtn];
    }
}


- (void)dealBottomBtn
{
    if (self.projectStyle==1) {
        
        NSDate *startDate=[self convertDateFromString:self.model.start_time];
        NSTimeInterval cha=[startDate timeIntervalSinceNow];
        [self intervalSinceNow:cha];
        
    }
}

//返回设定时间与当前时间的差
- (void )intervalSinceNow: (NSInteger) theDate

{
    if (theDate<0) {
        
        [self DetailDateWithDays:@"0" AndWithHours:@"0" AndWithMinutes:@"0" AndWithSeconds:@"0"];
    }
    else
    {
        NSTimeInterval  cha=theDate;
        
        NSString *days=@"";
        NSString *house=@"";
        NSString *mins=@"";
        NSString *sens=@"";
        //秒
        sens = [NSString stringWithFormat:@"%d",(int)cha%60];
        
        if(cha>60)
        {
            //分
            mins = [NSString stringWithFormat:@"%d", (int)cha/60%60];
            
        }
        if (cha>3600)
        {
            //时
            house = [NSString stringWithFormat:@"%d", (int)cha/3600%24];
        }
        if (cha>86400) {
            //天
            days = [NSString stringWithFormat:@"%d", (int)cha/86400];
        }
        
        //底部button显示剩余时间，到时间后创建视图
        [self DetailDateWithDays:days AndWithHours:house AndWithMinutes:mins AndWithSeconds:sens];
    }
}
-(void)DetailDateWithDays:(NSString *)dayStr AndWithHours:(NSString *)hourStr AndWithMinutes:(NSString *)minuteStr AndWithSeconds:(NSString *)secondStr
{
    __block int timedays=dayStr?[dayStr intValue]:0; //倒计时天数
    __block int timehours=hourStr?[hourStr intValue]:0; //倒计时小时
    __block int timeminutes=minuteStr?[minuteStr intValue]:0; //倒计时分钟
    __block int timeseconds=[secondStr intValue]; //倒计时秒数
    
    //    timedays=0;
    //    timehours=0;
    //    timeminutes=5;
    //    timeseconds=5;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeminutes==5&&timeseconds==0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //设置提醒
                //                if ([self.ShakeBtn.titleLabel.text isEqualToString:@"取消提醒"]) {
                //                    ShowImportErrorAlertView(@"摇奖时间到了");
                //
                //                }
                
            });
        }
        if(timedays<=0&&timeseconds<=0&&timeminutes<=0&&timehours<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                if (self.isStart == NO) {
                    self.isStart = YES;
                    self.projectStyle = 2;
                    
                    [self getProjectDetailData];
                    
                }

            });
        }else{
            if (timeseconds<0) {
                
                if (timeminutes==0) {
                    if (timehours==0) {
                        timehours=23;
                        timedays--;
                    }else
                    {
                        timehours--;
                        
                    }
                    timeminutes=59;
                }
                else
                {
                    timeminutes--;
                }
                timeseconds=59;
                
            }
            
            int seconds = timeseconds % 60;
//            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSString *chaStr=[NSString stringWithFormat:@"投标倒计时 %d天%d时%d分%d秒",timedays,timehours,timeminutes,seconds];
                [self.bottomBtn setTitle:chaStr forState:UIControlStateNormal];
//                NSString *timeStr = [NSString stringWithFormat:@"%@",self.model.start_time];
//                if (timeStr.length>=16) {
//                    NSString *timeSring = [timeStr substringWithRange:NSMakeRange(5, 11)];
//                    timeSring = [timeSring stringByReplacingOccurrencesOfString:@"-" withString:@"."];
//                    [self.bottomBtn setTitle:[NSString stringWithFormat:@"即将开始:%@开投",timeSring] forState:UIControlStateNormal];
//                }
            });
            timeseconds--;
        }
    });
    dispatch_resume(_timer);
}

-(NSDate*) convertDateFromString:(NSString*)uiDate
{
    Log(@"%@",uiDate);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}


/**
 *创建右侧按钮
 */
-(void)creatRightButton{
    
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightItemButton setBackgroundImage:[UIImage imageNamed:@"RightItem.png"]
                               forState:UIControlStateNormal];
    [rightItemButton setFrame:CGRectMake(0, 0, 30, 29)];
    [rightItemButton setBackgroundImage:[UIImage imageNamed:@"新版_分享_36"] forState:UIControlStateNormal];
    [rightItemButton addTarget:self action:@selector(rightNavBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight)];
    infoView.hidden = YES;
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFromSubViews)];
    [infoView addGestureRecognizer:singleTap];
}

-(void)rightNavBtnClick{
    
    if (infoView.hidden == YES) {
        [self setInfoViewFrame];
        infoView.hidden = NO;
    }else{
        
        [self removeFromSubViews];
    }
}

- (void)setInfoViewFrame{
    [UIView animateWithDuration:0.5 animations:^{
        infoView.backgroundColor = [UIColor blackColor];
        infoView.alpha = 0.6;
        [self.view addSubview:infoView];
        [self creatSubButton];
    }];
}

//创建分享button
-(void)creatSubButton{
    
    for (int i = 0; i < 4; i++) {
        CGFloat length = 70;
        if (self.view.frame.size.width<330) {
            length = 50;
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.alpha = 1.0;
        [button setFrame:CGRectMake((KProjectScreenWidth-length)/2, 100+(length+20)*i, length, length)];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"未标题-1_%d.png",i]] forState:UIControlStateNormal];
        button.tag = SHAREButtonTag + i;
        [button addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

/**
 *获取分享所需的数据
 */
-(void)getShareDataSourceFromNetWork
{
    NSString * shareUrlHtml = kDefaultShareUrlBase;
    NSDictionary * parames = @{@"jie_id":self.projectId,
                               @"leixing":@1,
                               @"rongzifangshi":self.rongzifangshi
                               };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [FMHTTPClient postPath:shareUrlHtml parameters:parames completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (response.code == WebAPIResponseCodeSuccess) {
            NSDictionary * data = response.responseObject[@"data"];
            self.shareModel = [FMShareModel initWithShareModelDictionary:data];
            if (self.shareModel.picurl.length > 0) {
                
                __weak __typeof(&*self)weakSelf = self;
                [self.shareImage sd_setImageWithURL:[NSURL URLWithString:self.shareModel.picurl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    [weakSelf shareDataSourceWithShareUrl:self.shareModel withImage:image];
                }];
            }else
            {
                
                [self shareDataSourceWithShareUrl:self.shareModel withImage:[UIImage imageNamed:@"小图2.png"]];
            }
            
        }else if(response.code == WebAPIResponseCodeFailed)
        {
            NSString * msg = response.responseObject[@"msg"];
            if ([msg isMemberOfClass:[NSNull class]]) {
                ShowAutoHideMBProgressHUD(self.view, @"数据出错，请重试");
            }else
            {
                ShowAutoHideMBProgressHUD(self.view, msg);
            }
            
        }else
        {
            ShowAutoHideMBProgressHUD(self.view, @"请求失败");
        }
        
    }];
}

-(void)shareDataSourceWithShareUrl:(FMShareModel *)shareModel withImage:(UIImage *)image
{
    
    [UMSocialConfig setFinishToastIsHidden:YES  position:UMSocialiToastPositionCenter];
    UIImage * imageShow = image;
    NSString * shareTitle = shareModel.title;
    NSString * shareText =  shareModel.content;
    
    // 微信好友
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString retStringWithPlatform:shareModel.url withPlatform:@"weixin"];
    // 朋友圈
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString retStringWithPlatform:shareModel.url withPlatform:@"wxcircle"];
    // QQ
    [UMSocialData defaultData].extConfig.qqData.url = [NSString retStringWithPlatform:shareModel.url withPlatform:@"qq"];
    // 新浪微博
    [UMSocialData defaultData].extConfig.sinaData.urlResource.url = [NSString retStringWithPlatform:shareModel.url withPlatform:@"sina"];
    // QQ空间
    [UMSocialData defaultData].extConfig.qzoneData.url = [NSString retStringWithPlatform:shareModel.url withPlatform:@"qzone"];
    
    
    if (self.shareImage.tag == SHAREImageViewTag) {
        
        //    新浪微博
        NSString * sharetrlText = [NSString stringWithFormat:@"%@%@",shareText,shareModel.url];
        [[UMSocialControllerService defaultControllerService] setShareText:sharetrlText shareImage:imageShow socialUIDelegate:self];        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        
        [self removeFromSubViews];
    }else if (self.shareImage.tag == SHAREImageViewTag+1){
        //   朋友圈
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareTitle;
        [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:imageShow socialUIDelegate:self];        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        [self removeFromSubViews];
    }else if (self.shareImage.tag == SHAREImageViewTag+2){
        
        //   微信好友
        [UMSocialData defaultData].extConfig.wechatSessionData.title =  shareTitle;
        [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:imageShow socialUIDelegate:self];        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        [self removeFromSubViews];
        
    }else{
        //   QQ
        [UMSocialData defaultData].extConfig.qqData.title =  shareTitle;
        [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:imageShow socialUIDelegate:self];        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        [self removeFromSubViews];

    }
    
}

-(void)removeFromSubViews{
    
    infoView.hidden = YES;
    for (UIView *button in self.view.subviews) {
        if ([button isKindOfClass:[UIButton class]]&&button.tag!=852) {
            [button removeFromSuperview];
        }
    }
}

-(void)shareAction:(UIButton *)button{
    UIImageView * imageview = [[UIImageView alloc]init];
    self.shareImage = imageview;
    imageview.tag = button.tag + 1000;
    [self getShareDataSourceFromNetWork];
    
}

//实现回调方法（可选）：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        [self babyPlanAddScore];
    }
}

-(void)babyPlanAddScore
{
    
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token;
    
    if ([CurrentUserInformation sharedCurrentUserInfo].userId) {
        token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    }else
    {
        token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",@"0",timestamp]);
    }
    
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter;
    if ([CurrentUserInformation sharedCurrentUserInfo].userId) {
        parameter = @{@"appid":@"huiyuan",@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,@"shijian":[NSNumber numberWithInt:timestamp],@"token":tokenlow,@"jifenshu":[NSNumber numberWithInt:1],@"leixing":@"13"};
    }else
    {
        parameter = @{@"appid":@"huiyuan",@"user_id":@"0",@"shijian":[NSNumber numberWithInt:timestamp],@"token":tokenlow,@"jifenshu":[NSNumber numberWithInt:1],@"leixing":@"13"};
    }
    __weak __typeof(&*self)weakSelf = self;
    
    [FMHTTPClient postPath:babyPlanAddScoreURL parameters:parameter completion:^(WebAPIResponse *response) {
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (response.code==WebAPIResponseCodeSuccess) {
                if (response.responseObject[@"msg"]) {
                    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
                        NSString * showMsg = [NSString stringWithFormat:@"分享成功，%@",response.responseObject[@"msg"]];
                        ShowAutoHideMBProgressHUD(weakSelf.view,showMsg);
                    }else{
                    
                        ShowAutoHideMBProgressHUD(weakSelf.view,@"分享成功");
                    }
                }else
                {
                    ShowAutoHideMBProgressHUD(weakSelf.view,@"分享成功");
                }
            }
            else
            {
                ShowAutoHideMBProgressHUD(weakSelf.view,@"分享成功");
            }
        });
    }];
    
}

/**
 *请求数据
 */
- (void)chaxunActivityNum
{
    NSString *userId =[CurrentUserInformation sharedCurrentUserInfo].userLoginState?[CurrentUserInformation sharedCurrentUserInfo].userId:@"0";
    __weak __typeof(&*self)weakSelf = self;
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSDictionary * parameter = [[NSDictionary alloc]init];
    NSString *url = kFMPhpUniversalBaseUrl(@"rongtuoxinsoc/Lend/infoshowliuer");
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];

    if (![CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
        parameter = @{
                      @"UserId":@"0",
                      @"AppId":@"huiyuan",
                      @"AppTime":[NSNumber numberWithInt:timestamp],
                      @"Token":tokenlow,
                      @"jie_id":weakSelf.projectId,
                      };
    }else{
        parameter = @{
                      @"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                      @"AppId":@"huiyuan",
                      @"AppTime":[NSNumber numberWithInt:timestamp],
                      @"Token":tokenlow,
                      @"jie_id":weakSelf.projectId,
                      };
        
    }
    [FMHTTPClient postPath:url parameters:parameter completion:^(WebAPIResponse *response) {
        
        if (response.code == WebAPIResponseCodeSuccess) {
            NSDictionary *dic1=response.responseObject[@"data"];
            NSString *str = [dic1 objectForKey:@"zhuangtai"];
            weakSelf.dizenge = [dic1 objectForKey:@"dizenge"];
            if (!weakSelf.NoCreateRightBtn) {
                // 不是注资专标跳入
                if ([str isEqualToString:@"10"]) {
                    [weakSelf creatRightButton];
                }
            }else {
                if (![str isEqualToString:@"10"]) {
                    weakSelf.navigationItem.rightBarButtonItem = nil;
                }
            }
            NSString *str1 = [NSString stringWithFormat:@"%@",[dic1 objectForKey:@"xianyou"]];
            if ([str1 isEqualToString:@"1"]) {
                weakSelf.xianyou = @"1";
            }else{
                weakSelf.xianyou = @"0";
            }
            if ([[dic1 objectForKey:@"fengxianwenjuan"] intValue]) {
                [weakSelf userEvalue];
            }else{
                weakSelf.fengxiandengji = @"";
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            }
            weakSelf.model=[ProjectModel modelForProjectDetailWithUnserializedJSONDic:dic1];
            [weakSelf createHeaderView];
            [weakSelf reloadTabelViewData];
            [weakSelf createBottomBtn];
            weakSelf.tableView.hidden = NO;

        }else{
            weakSelf.fengxiandengji = @"";
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [weakSelf.showWait showLoadDataFail:weakSelf.view];
            weakSelf.showWait.loadBtn = ^(){
                
                [weakSelf getProjectDetailData];
                
            };
        }
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
}

-(void)getProjectDetailData{

    NSString *userId =[CurrentUserInformation sharedCurrentUserInfo].userLoginState?[CurrentUserInformation sharedCurrentUserInfo].userId:@"0";
    __weak __typeof(&*self)weakSelf = self;
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSDictionary * parameter = [[NSDictionary alloc]init];
    NSString *url = kXZUniversalTestUrl(@"GetInterestCouponNum");
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    if (![CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
        parameter = @{
                      @"UserId":@"0",
                      @"AppId":@"huiyuan",
                      @"AppTime":[NSNumber numberWithInt:timestamp],
                      @"Token":tokenlow,
                      @"ProjId":self.projectId,
                      };
    }else{
        parameter = @{
                      @"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                      @"AppId":@"huiyuan",
                      @"AppTime":[NSNumber numberWithInt:timestamp],
                      @"Token":tokenlow,
                      @"ProjId":self.projectId,
                      };
        
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:url parameters:parameter completion:^(WebAPIResponse *response) {
        
        if (response.code == WebAPIResponseCodeSuccess) {
            NSDictionary *dic1=response.responseObject[@"data"];
            NSString *Num = [dic1 objectForKey:@"Num"];
            if ([Num floatValue]<=0) {
                weakSelf.isNum = YES;
                
            }else{
            
                weakSelf.isNum = NO;
            }
        }else{
            weakSelf.isNum = NO;
        }
        [weakSelf chaxunActivityNum];
    }];

}

- (void)userEvalue
{
    NSString *userId =[CurrentUserInformation sharedCurrentUserInfo].userLoginState?[CurrentUserInformation sharedCurrentUserInfo].userId:@"0";
    __weak __typeof(&*self)weakSelf = self;
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = [[NSDictionary alloc]init];
//    NSString *url = kXZUniversalTestUrl(@"IsMatchGrade");
    NSString *url = kFMPhpUniversalBaseUrl(@"rongtuoxinsoc/Usercenter/panduantoubiaofouliuer");
    if (![CurrentUserInformation sharedCurrentUserInfo].userLoginState){
    
        parameter = @{
                      @"UserId":@"0",
                      @"appid":@"huiyuan",
                      @"shijian":[NSNumber numberWithInt:timestamp],
                      @"token":tokenlow,
                      @"jie_id":weakSelf.projectId
                      };
    }else{
    
        parameter = @{
                      @"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                      @"appid":@"huiyuan",
                      @"shijian":[NSNumber numberWithInt:timestamp],
                      @"token":tokenlow,
                      @"jie_id":weakSelf.projectId
                      };
    }
    
    
    [FMHTTPClient postPath:url parameters:parameter completion:^(WebAPIResponse *response) {
        //@"您的风险承受能力暂不符合条件"
        //@"请先完成风险承受能力评估"
        NSDictionary * allDictionary = (NSDictionary *)response.responseObject;
        NSNumber * status = allDictionary[@"status"];
        if ([status integerValue] == 1) {
        
            weakSelf.fengxiandengji = @"请先完成风险承受能力评估";
        }else if ([status integerValue] == 2){
        
            weakSelf.fengxiandengji = @"您的风险承受能力暂不符合条件";
        }else{
          
            weakSelf.fengxiandengji = @"";
        }
        if (![CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
            weakSelf.fengxiandengji = @"请先完成风险承受能力评估";
        }
        [weakSelf createBottomBtn];
        [weakSelf.tableView reloadData];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
    }];
    
}


-(void)reloadTabelViewData{

    /**
     *tableView显示数据
     */
    NSArray *titleArr=nil;
    NSArray *contentArr=nil;
    if ([self.model.fengxianwenjuan intValue]) {
        if (IsStringEmptyOrNull(self.model.baoxianjigou)) {
            if ([self.rongzifangshi integerValue] == 4||[self.rongzifangshi integerValue] == 5) {
                
                if (self.isNum&&self.firstLabel && [self.model.lilvyou floatValue]>0){
                    titleArr=[NSArray arrayWithObjects:@"项目等级",@"投资人条件",@"项目名称",@"回购承诺",@"还款方式",@"起息日期",@"到期日期",@"理财有风险 投资需谨慎",self.model.jiaxiyuanyin, nil];
                    
                }else{
                    titleArr=[NSArray arrayWithObjects:@"项目等级",@"投资人条件",@"项目名称",@"回购承诺",@"还款方式",@"起息日期",@"到期日期",@"理财有风险 投资需谨慎", nil];
                }
                
            }else
            {
                if (self.isNum&&self.firstLabel && [self.model.lilvyou floatValue]>0){
                    titleArr=[NSArray arrayWithObjects:@"项目等级",@"投资人条件",@"项目名称",@"担保机构",@"还款方式",@"起息日期",@"到期日期",@"理财有风险 投资需谨慎",self.model.jiaxiyuanyin, nil];
                }else{
                    titleArr=[NSArray arrayWithObjects:@"项目等级",@"投资人条件",@"项目名称",@"担保机构",@"还款方式",@"起息日期",@"到期日期",@"理财有风险 投资需谨慎", nil];
                }
                
            }
            contentArr=[NSArray arrayWithObjects:@"",self.model.touzidengijmingcheng,[NSString stringWithFormat:@"%@",self.model.title],[NSString stringWithFormat:@"%@",self.model.danbaocompany],[NSString stringWithFormat:@"%@",self.model.huankuanfangshi],[NSString stringWithFormat:@"%@",self.model.end_time],[NSString stringWithFormat:@"%@",self.model.jiexi_time],@"",@"去加息", nil];
            
        }
        else
        {
            if ([self.rongzifangshi integerValue] == 4||[self.rongzifangshi integerValue] == 5) {
                if (self.isNum&&self.firstLabel && [self.model.lilvyou floatValue]>0){
                    titleArr=[NSArray arrayWithObjects:@"项目等级",@"投资人条件",@"项目名称",@"回购承诺",@"保险公司",@"还款方式",@"起息日期",@"到期日期",@"理财有风险 投资需谨慎",self.model.jiaxiyuanyin, nil];
                }else{
                    titleArr=[NSArray arrayWithObjects:@"项目等级",@"投资人条件",@"项目名称",@"回购承诺",@"保险公司",@"还款方式",@"起息日期",@"到期日期", nil];
                }
                
            }else
            {
                if (self.isNum&&self.firstLabel && [self.model.lilvyou floatValue]>0){
                    titleArr=[NSArray arrayWithObjects:@"项目名称",@"担保机构",@"保险公司",@"还款方式",@"起息日期",@"到期日期",@"理财有风险 投资需谨慎",self.model.jiaxiyuanyin, nil];
                }else{
                    titleArr=[NSArray arrayWithObjects:@"项目名称",@"担保机构",@"保险公司",@"还款方式",@"起息日期",@"到期日期",@"理财有风险 投资需谨慎", nil];
                }
            }
            
            contentArr=[NSArray arrayWithObjects:@"",self.model.touzidengijmingcheng,[NSString stringWithFormat:@"%@",self.model.title],[NSString stringWithFormat:@"%@",self.model.danbaocompany],[NSString stringWithFormat:@"%@",self.model.baoxianjigou],[NSString stringWithFormat:@"%@",self.model.huankuanfangshi],[NSString stringWithFormat:@"%@",self.model.end_time],[NSString stringWithFormat:@"%@",self.model.jiexi_time],@"",@"去加息", nil];
        }
        self.titleArr = titleArr;
        self.contentArr = contentArr;
        [self.tableView reloadData];

    }else{
    
        if (IsStringEmptyOrNull(self.model.baoxianjigou)) {
            if ([self.rongzifangshi integerValue] == 4||[self.rongzifangshi integerValue] == 5) {
                
                if (self.isNum&&self.firstLabel && [self.model.lilvyou floatValue]>0){
                    titleArr=[NSArray arrayWithObjects:@"项目名称",@"回购承诺",@"还款方式",@"起息日期",@"到期日期",@"理财有风险 投资需谨慎",self.model.jiaxiyuanyin, nil];
                    
                }else{
                    titleArr=[NSArray arrayWithObjects:@"项目名称",@"回购承诺",@"还款方式",@"起息日期",@"到期日期",@"理财有风险 投资需谨慎", nil];
                }
                
            }else
            {
                if (self.isNum&&self.firstLabel && [self.model.lilvyou floatValue]>0){
                    titleArr=[NSArray arrayWithObjects:@"项目名称",@"担保机构",@"还款方式",@"起息日期",@"到期日期",@"理财有风险 投资需谨慎",self.model.jiaxiyuanyin, nil];
                }else{
                    titleArr=[NSArray arrayWithObjects:@"项目名称",@"担保机构",@"还款方式",@"起息日期",@"到期日期",@"理财有风险 投资需谨慎", nil];
                }
                
            }
            contentArr=[NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",self.model.title],[NSString stringWithFormat:@"%@",self.model.danbaocompany],[NSString stringWithFormat:@"%@",self.model.huankuanfangshi],[NSString stringWithFormat:@"%@",self.model.end_time],[NSString stringWithFormat:@"%@",self.model.jiexi_time],@"",@"去加息", nil];
            
        }
        else
        {
            if ([self.rongzifangshi integerValue] == 4||[self.rongzifangshi integerValue] == 5) {
                if (self.isNum&&self.firstLabel && [self.model.lilvyou floatValue]>0){
                    titleArr=[NSArray arrayWithObjects:@"项目名称",@"回购承诺",@"保险公司",@"还款方式",@"起息日期",@"到期日期",@"理财有风险 投资需谨慎",self.model.jiaxiyuanyin, nil];
                }else{
                    titleArr=[NSArray arrayWithObjects:@"项目名称",@"回购承诺",@"保险公司",@"还款方式",@"起息日期",@"到期日期", nil];
                }
                
            }else
            {
                if (self.isNum&&self.firstLabel && [self.model.lilvyou floatValue]>0){
                    titleArr=[NSArray arrayWithObjects:@"项目名称",@"担保机构",@"保险公司",@"还款方式",@"起息日期",@"到期日期",@"理财有风险 投资需谨慎",self.model.jiaxiyuanyin, nil];
                }else{
                    titleArr=[NSArray arrayWithObjects:@"项目名称",@"担保机构",@"保险公司",@"还款方式",@"起息日期",@"到期日期",@"理财有风险 投资需谨慎", nil];
                }
            }
            
            contentArr=[NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",self.model.title],[NSString stringWithFormat:@"%@",self.model.danbaocompany],[NSString stringWithFormat:@"%@",self.model.baoxianjigou],[NSString stringWithFormat:@"%@",self.model.huankuanfangshi],[NSString stringWithFormat:@"%@",self.model.end_time],[NSString stringWithFormat:@"%@",self.model.jiexi_time],@"",@"去加息", nil];
        }
        self.titleArr = titleArr;
        self.contentArr = contentArr;
        [self.tableView reloadData];

    }
    
}

/**
 *判断用“天”还是“个月”
 */
-(NSString *)judgeCurrentType
{
    NSString * qixian = self.model.qixian == nil ? @"1" : self.model.qixian;
    NSString * retTianshu ;
    if ([qixian floatValue] < 1) {
        retTianshu = [NSString stringWithFormat:@"%d天",self.model.tianshu];
    }else {
        retTianshu = [NSString stringWithFormat:@"%@个月",self.model.qixian];
    }
    return retTianshu;
}

-(NSString *)judgeCurrentTypeAndDate
{
    NSString * qixian = self.model.qixian == nil ? @"1" : self.model.qixian;
    NSString * retTianshu ;
    if ([qixian floatValue] < 1) {
        retTianshu = [NSString stringWithFormat:@"%d",self.model.tianshu];
    }else {
        retTianshu = [NSString stringWithFormat:@"%@",self.model.qixian];
    }
    return retTianshu;
}

-(CABasicAnimation *) AlphaLight:(float)time
{
    
    CABasicAnimation *animation =[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    return animation;
}

/**
 *创建gif飘窗
 */
-(UIView *)gifImageView
{
    if (!_gifImageView) {
        _gifImageView  = [[UIView alloc]init];
        
        UIImageView * backGroundView = [[UIImageView alloc]init];
        backGroundView.image = [UIImage imageNamed:@"项目详情加息_01_04"];
        
        [_gifImageView addSubview:backGroundView];
        
        UILabel * contentLabel = [[UILabel alloc]init];
        contentLabel.text = [NSString stringWithFormat:@"获取%@%%加息",self.model.lilvyou];
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.font = [UIFont systemFontOfSize:10];
        contentLabel.textColor = [UIColor whiteColor];
        [_gifImageView addSubview:contentLabel];
        
        UIButton * clickbutton = [[UIButton alloc]init];
        [clickbutton addTarget:self action:@selector(clickButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_gifImageView addSubview:clickbutton];
        
        [contentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_gifImageView);
            make.height.equalTo(@16);
            make.width.equalTo(@70);
        }];
        [backGroundView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentLabel.mas_left).offset(-2);
            make.top.equalTo(contentLabel.mas_top).offset(0);
            make.bottom.equalTo(contentLabel.mas_bottom).offset(6);
            make.right.equalTo(contentLabel.mas_right).offset(2);
        }];
        
        [clickbutton makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(backGroundView);
        }];
        [_gifImageView makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(backGroundView);
        }];
        [_gifImageView.layer addAnimation:[self AlphaLight:0.5] forKey:nil];
    }
    
    return _gifImageView;
}

/**
 *去加息
 */
-(void)clickButtonOnClick:(UIButton *)button
{
    if (![CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
        LoginController *registerController = [[LoginController alloc] init];
        FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
        [self presentViewController:navController animated:YES completion:nil];
        return;
    }
//    NSLog(@"点击了");
    FMPlaceOrderViewController * placeOrder = [[FMPlaceOrderViewController alloc]init];
    placeOrder.goToGoodShopIndex = 2;
    placeOrder.product_id = self.model.product_id;
    placeOrder.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:placeOrder animated:YES];
}

/**
 *创建tableView头视图
 */
-(void)createHeaderView{

    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 185)];
    [topView setBackgroundColor:[HXColor colorWithHexString:@"#0159d5"]];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 175, KProjectScreenWidth, 10)];
    [lineView setBackgroundColor:KDefaultOrBackgroundColor];
    [topView addSubview:lineView];
    
    NSString *lilvyou = [NSString stringWithFormat:@"%@",self.model.lilvyou];
    NSString *lilvXianshi = [lilvyou floatValue]>0?[NSString stringWithFormat:@"%@+%@",self.model.lilv,lilvyou]:self.model.lilv;
//    if ([self.model.xianyou isEqualToString:@"0"]) {
//        lilvXianshi = [NSString stringWithFormat:@"%@",self.model.lilv];
//    }
    if (self.projectStyle==3) {
        //已结束
        UILabel *moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, KProjectScreenWidth, 15)];
        moneyLabel.textAlignment=NSTextAlignmentCenter;
        moneyLabel.backgroundColor=[UIColor clearColor];
        moneyLabel.text=[NSString stringWithFormat:@"满标时间：%@",self.model.manbiaoshijian];
        moneyLabel.font=[UIFont systemFontOfSize:12.0f];
        moneyLabel.textColor=[UIColor whiteColor];
        [topView addSubview:moneyLabel];
        
        UILabel *moneyContentLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 50, KProjectScreenWidth, 30)];
        moneyContentLabel.textAlignment=NSTextAlignmentCenter;
        moneyContentLabel.backgroundColor=[UIColor clearColor];
        moneyContentLabel.text=[NSString stringWithFormat:@"%@人次已投资",self.model.touzirenshu];
        moneyContentLabel.font=[UIFont systemFontOfSize:22.0f];
        moneyContentLabel.textColor=[UIColor whiteColor];
        [topView addSubview:moneyContentLabel];
        
        UILabel *peopleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 85, KProjectScreenWidth, 15)];
        peopleLabel.textAlignment=NSTextAlignmentCenter;
        peopleLabel.backgroundColor=[UIColor clearColor];
        peopleLabel.text=[NSString stringWithFormat:@"预计获取收益（元）：%.2f",[self.model.yuqizongsy floatValue]];
        peopleLabel.font=[UIFont systemFontOfSize:14.0f];
        peopleLabel.textColor=[UIColor whiteColor];
        [topView addSubview:peopleLabel];
        
        NSArray *contentArr=[[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"%@%%",lilvXianshi],[NSString stringWithFormat:@"%@万",[self translateIntoLiangeWant:self.model.jiner]],[self judgeCurrentType],nil];
        NSArray *cArr=[NSArray arrayWithObjects:lilvXianshi,[self translateIntoLiangeWant:self.model.jiner],[self judgeCurrentTypeAndDate], nil];
        for(int i=0;i<3;i++)
        {
            CGFloat width=(CGFloat)KProjectScreenWidth/3;
            UILabel *contentlabel=[[UILabel alloc]initWithFrame:CGRectMake(width*i, 115, width, 20)];
            contentlabel.textColor=[UIColor whiteColor];
            if (i==0) {
                if (self.model.lilvyou) {
                    contentlabel.text = self.model.lilvyou;
                }
                self.firstLabel = nil;
            }
            contentlabel.font=[UIFont boldSystemFontOfSize:12];
            contentlabel.textAlignment=NSTextAlignmentCenter;
            [topView addSubview:contentlabel];
            
            NSString *content=contentArr[i];
            NSRange range=[content rangeOfString:cArr[i]];
            NSMutableAttributedString *attriContent=[[NSMutableAttributedString alloc]initWithString:content];
            [attriContent addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25.0f] range:range];
            contentlabel.attributedText=attriContent;
            
        }
//        UIImageView *finishImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
//        finishImageView.center = CGPointMake((KProjectScreenWidth-110)/2 + 55, 80 + 45);
//        if(self.model.projectStyle==4||self.model.projectStyle==6)
//        {
//            finishImageView.image=[UIImage imageNamed:@"pgjt_complete_icon.png"];
//            
//        }
//        else
//        {
//            finishImageView.image=[UIImage imageNamed:@"pgjt_jiesuan_icon.png"];
//            
//        }
//        [topView addSubview:finishImageView];
//        finishImageView.transform =  CGAffineTransformMakeRotation(-540 * M_PI/180);
//        [UIView animateWithDuration:1.0 animations:^{
//            finishImageView.frame = CGRectMake((KProjectScreenWidth-110)/2, 80 ,110, 110);
//            finishImageView.transform =  CGAffineTransformMakeRotation(0 * M_PI/180);
//        }];
//        NSArray *imageArr=[NSArray arrayWithObjects:@"date.png",@"project.png",@"project.png", nil];
        NSArray *titleContentArr;
        titleContentArr=[NSArray arrayWithObjects:@"预期年化收益",@"融资金额",@"融资期限", nil];
        
        CGFloat bottomWidth=KProjectScreenWidth/3.0f;
        for(int i=0;i<3;i++)
        {
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(bottomWidth*i, 145, bottomWidth, 15)];
            label.text=titleContentArr[i];
            label.textColor= [HXColor colorWithHexString:@"#ccccff"];
            label.backgroundColor=[UIColor clearColor];
            label.font=[UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            [topView addSubview:label];

        }
    }
    else if (self.projectStyle==1) {
        //未开始
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 60, KProjectScreenWidth, 30)];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.text=[NSString stringWithFormat:@"%@",self.model.start_time];
        titleLabel.font=[UIFont systemFontOfSize:25.0f];
        titleLabel.textColor=[UIColor whiteColor];
        [topView addSubview:titleLabel];
        
        UILabel *dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 18, KProjectScreenWidth, 20)];
        dateLabel.textAlignment=NSTextAlignmentCenter;
        dateLabel.backgroundColor=[UIColor clearColor];
        dateLabel.text=@"开放投资时间";
        dateLabel.font=[UIFont systemFontOfSize:16.0f];
        dateLabel.textColor=[HXColor colorWithHexString:@"#ccccff"];
        [topView addSubview:dateLabel];
        
        NSArray *titleArr=[[NSArray alloc]initWithObjects:@"预期年化收益",@"融资金额",@"融资期限", nil];
        NSArray *cArr=[NSArray arrayWithObjects:lilvXianshi,[self translateIntoLiangeWant:self.model.jiner],[self judgeCurrentTypeAndDate], nil];

        NSArray *contentArr=[[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"%@%%",lilvXianshi],[NSString stringWithFormat:@"%@万",[self translateIntoLiangeWant:self.model.jiner]],[self judgeCurrentType],nil];
        
        for(int i=0;i<3;i++)
        {
            
            CGFloat width=(CGFloat)KProjectScreenWidth/3;
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(width*i, 145, width, 15)];
            label.text=titleArr[i];
            label.textColor=[HXColor colorWithHexString:@"#ccccff"];
            label.textAlignment=NSTextAlignmentCenter;
            label.backgroundColor=[UIColor clearColor];
            label.font=[UIFont systemFontOfSize:12];
            [topView addSubview:label];
            
            UILabel *contentlabel=[[UILabel alloc]initWithFrame:CGRectMake(width*i, 115, width, 20)];
            contentlabel.textColor = [UIColor whiteColor];
            contentlabel.font=[UIFont boldSystemFontOfSize:12];
            contentlabel.textAlignment=NSTextAlignmentCenter;
            contentlabel.backgroundColor=[UIColor clearColor];
            [topView addSubview:contentlabel];
            
            NSString *content=contentArr[i];
            NSRange range=[content rangeOfString:cArr[i]];
            NSMutableAttributedString *attriContent=[[NSMutableAttributedString alloc]initWithString:content];
            [attriContent addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25.0f] range:range];
            contentlabel.attributedText=attriContent;

            if (i==0) {
                self.firstLabel = contentlabel;
            }
        }
    }
    else if (self.projectStyle==2) {
        //投资中
        NSArray *titleArr=[[NSArray alloc]initWithObjects:@"预期年化收益",@"融资金额",@"融资期限", nil];
        NSArray *contentArr=[[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"%@%%",lilvXianshi],[NSString stringWithFormat:@"%@万",[self translateIntoLiangeWant:self.model.jiner]],[self judgeCurrentType],nil];
        NSArray *cArr=[NSArray arrayWithObjects:lilvXianshi,[self translateIntoLiangeWant:self.model.jiner],[self judgeCurrentTypeAndDate], nil];

        UILabel *shengyuMoneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, KProjectScreenWidth, 40)];
        shengyuMoneyLabel.textAlignment=NSTextAlignmentCenter;
        shengyuMoneyLabel.backgroundColor=[UIColor clearColor];
        shengyuMoneyLabel.text=[NSString stringWithFormat:@"%@",self.model.shengyu];
        shengyuMoneyLabel.font=[UIFont systemFontOfSize:40.0f];
        shengyuMoneyLabel.textColor=[UIColor whiteColor];
        [topView addSubview:shengyuMoneyLabel];
        
        UILabel *moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 60, KProjectScreenWidth, 30)];
        moneyLabel.textAlignment=NSTextAlignmentCenter;
        moneyLabel.backgroundColor=[UIColor clearColor];
        moneyLabel.text=[NSString stringWithFormat:@"可投金额(元)"];
        moneyLabel.font=[UIFont systemFontOfSize:13.0f];
        moneyLabel.textColor=[HXColor colorWithHexString:@"#ccccff"];
        [topView addSubview:moneyLabel];
        
        for(int i=0;i<3;i++)
        {
            CGFloat width=(CGFloat)KProjectScreenWidth/3;
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(width*i, 145, width, 15)];
            label.text=titleArr[i];
            label.textColor=[HXColor colorWithHexString:@"#ccccff"];
            label.textAlignment=NSTextAlignmentCenter;
            label.backgroundColor=[UIColor clearColor];
            label.font=[UIFont systemFontOfSize:13];
            [topView addSubview:label];
            
            UILabel *contentlabel=[[UILabel alloc]initWithFrame:CGRectMake(width*i, 115, width, 20)];
            contentlabel.textColor=[UIColor whiteColor];
            contentlabel.text = contentArr[i];
            contentlabel.font=[UIFont boldSystemFontOfSize:12];
            contentlabel.textAlignment=NSTextAlignmentCenter;
            contentlabel.backgroundColor=[UIColor clearColor];
            [topView addSubview:contentlabel];
            
            NSString *content=contentArr[i];
            NSRange range=[content rangeOfString:cArr[i]];
            NSMutableAttributedString *attriContent=[[NSMutableAttributedString alloc]initWithString:content];
            [attriContent addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25.0f] range:range];
            contentlabel.attributedText=attriContent;

            if (i==0) {
                self.firstLabel = contentlabel;
            }
        }
    }
    
    self.tableView.tableHeaderView = topView;
    if (self.firstLabel) {
//        if ([self.xianyou isEqualToString:@"1"]) {
        if (self.isNum && [self.model.lilvyou floatValue]>0) {

            [topView addSubview:self.gifImageView];
            [self.gifImageView makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerX.equalTo(self.firstLabel.centerX).offset(45);
                make.bottom.equalTo(self.firstLabel.mas_top).offset(0);
            }];
        }
    }
}

/**
 *查看详情--tableView尾视图
 */
-(void)createFooderView{

    UIView *fooderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 200)];
    [fooderView setBackgroundColor:KDefaultOrBackgroundColor];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:createImageWithColor([UIColor whiteColor]) forState:UIControlStateNormal];
    [button setTitle:@"查看详情" forState:UIControlStateNormal];
    [button setTitleColor:KSubTitleContentTextColor forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:14.0f];
    [button setFrame:CGRectMake(20, 40, KProjectScreenWidth-40, 43)];
    [button addTarget:self action:@selector(moreDetailBtnClick) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font=[UIFont boldSystemFontOfSize:16.0f];
    [button.layer setCornerRadius:5.0f];
    [button.layer setBorderWidth:0.5f];
    [button.layer setBorderColor:KSepLineColorSetup.CGColor];
    [fooderView addSubview:button];

    self.tableView.tableFooterView = fooderView;
}

/**
 *融资金额保留适当小数位
 */
-(NSString *)translateIntoLiangeWant:(NSString *)jiner{

    if ([jiner intValue]%10000 == 0) {
        return [NSString stringWithFormat:@"%d",[jiner intValue]/10000];
    }else if ([jiner intValue]%1000 != 0){
        return [NSString stringWithFormat:@"%.2f",[jiner floatValue]/10000];
    }else{
        return [NSString stringWithFormat:@"%.1f",[jiner floatValue]/10000];
    }
}

//懒加载
- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight-55)style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setBackgroundColor:KDefaultOrBackgroundColor];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

            [self getProjectDetailData];

        }];
    }
    return _tableView;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView{
    
    if ([self.model.fengxianwenjuan intValue]) {
        if (IsStringEmptyOrNull(self.model.baoxianjigou)) {
            if ([self.rongzifangshi integerValue] == 4||[self.rongzifangshi integerValue] == 5) {
                
//                if ([self.xianyou isEqualToString:@"1"]&&self.firstLabel){
                if (self.isNum && self.firstLabel && [self.model.lilvyou floatValue]>0){
                    return 9;
                }else{
                    return 8;
                }
            }else
            {
//                if ([self.xianyou isEqualToString:@"1"]&&self.firstLabel){
                if (self.isNum && self.firstLabel && [self.model.lilvyou floatValue]>0){
                    return 9;
                }else{
                    return 8;
                }
            }
        }
        else
        {
            if ([self.rongzifangshi integerValue] == 4||[self.rongzifangshi integerValue] == 5) {
                if (self.isNum&&self.firstLabel && [self.model.lilvyou floatValue]>0){
                    return 9;
                }else{
                    return 8;
                }
            }else
            {
                if (self.isNum&&self.firstLabel && [self.model.lilvyou floatValue]>0){
                    return 9;
                }else{
                    return 8;
                }
            }
        }

    }else{
    
        if (IsStringEmptyOrNull(self.model.baoxianjigou)) {
            if ([self.rongzifangshi integerValue] == 4||[self.rongzifangshi integerValue] == 5) {
                
                if (self.isNum&&self.firstLabel && [self.model.lilvyou floatValue]>0){
                    return 7;
                }else{
                    return 6;
                }
            }else
            {
                if (self.isNum&&self.firstLabel && [self.model.lilvyou floatValue]>0){
                    return 7;
                }else{
                    return 6;
                }
            }
        }
        else
        {
            if ([self.rongzifangshi integerValue] == 4||[self.rongzifangshi integerValue] == 5) {
                if (self.isNum&&self.firstLabel && [self.model.lilvyou floatValue]>0){
                    return 7;
                }else{
                    return 6;
                }
            }else
            {
                if (self.isNum&&self.firstLabel && [self.model.lilvyou floatValue]>0){
                    return 7;
                }else{
                    return 6;
                }
            }
        }

    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
//    return 50;
    CGFloat height;
    height = [self heitForLabel:self.contentArr[section]]>50?[self heitForLabel:self.contentArr[section]]:50;
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *fengxianwenjuan = self.model.fengxianwenjuan?self.model.fengxianwenjuan:0;
    UIView *view = [UIView new];
    view.tag = section;
    if ([fengxianwenjuan intValue]) {
        if (section < 1||section >= 7) {
            //创建一个手势进行点击，这里可以换成button
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(action_tap:)];
            [view addGestureRecognizer:tap];
        }
    }else{
        
        if (section >= 5) {
            //创建一个手势进行点击，这里可以换成button
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(action_tap:)];
            [view addGestureRecognizer:tap];
        }
    }
    
    
    /**
     *tableView左侧标题
     */
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KProjectScreenWidth, 50)];
    [titleLabel setTextColor:[HXColor colorWithHexString:@"#333"]];
    [titleLabel setFont:[UIFont systemFontOfSize:16]];
    [view addSubview:titleLabel];
    /**
     *tableView右侧标题
     */
    CGFloat height;
    height = [self heitForLabel:self.contentArr[section]]>50?[self heitForLabel:self.contentArr[section]]:50;
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(KProjectScreenWidth/3, 0, KProjectScreenWidth*2/3-10, height)];
    contentLabel.numberOfLines = 0;
    [contentLabel setTextColor:[HXColor colorWithHexString:@"#999"]];
    [contentLabel setTextAlignment:NSTextAlignmentRight];
    [contentLabel setFont:[UIFont systemFontOfSize:16]];
    [view addSubview:contentLabel];
    
    if ([fengxianwenjuan intValue]) {
        if (section == 0){
            /**
             *会转动的小三角
             */
            UIImageView *btnImage = [[UIImageView alloc]initWithFrame:CGRectMake(85, 21, 12, 6)];
            if (self.isOpen == NO) {
                [btnImage setImage:[UIImage imageNamed:@"项目详情_三角向下箭头_1702"]];
            }else{
                [btnImage setImage:[UIImage imageNamed:@"项目详情_三角向上箭头_1702"]];
            }
            [view addSubview:btnImage];
            self.trangleImag = btnImage;
            /**
             *表示等级的小星星
             */
            AXRatingView *halfStepRatingView = [[AXRatingView alloc] initWithFrame:CGRectMake(KProjectScreenWidth-95, 18, 90, 10)];
            [view addSubview:halfStepRatingView];
            [halfStepRatingView sizeToFit];
            _halfStepRatingView = halfStepRatingView;
            [halfStepRatingView setStepInterval:1];
            halfStepRatingView.markImage = [UIImage imageNamed:@"项目详情_等级黄五星_1702"];
            halfStepRatingView.value = [self.model.xingji intValue];
            halfStepRatingView.markFont = [UIFont systemFontOfSize:18.0f];
            halfStepRatingView.minimumValue = 1.00;
            
        }

    }
    int numberOfSetion = [fengxianwenjuan intValue]?0:2;
        if (section == 7-numberOfSetion) {
        UIImageView *arrowImg = [[UIImageView alloc]initWithFrame:CGRectMake(KProjectScreenWidth-30, 19, 7.5, 12)];
        [arrowImg setImage:[UIImage imageNamed:@"项目详情_向右小箭头_1702"]];
        [view addSubview:arrowImg];

    }
    if (section == 8-numberOfSetion) {
//        UIImageView *goImage = [[UIImageView alloc]init];
//        [goImage setFrame:CGRectMake(KProjectScreenWidth-49, 16, 35, 18)];
//        [goImage setImage:[UIImage imageNamed:@"新版-项目详情加息"]];
//        [view addSubview:goImage];
        
        [titleLabel setTextColor:[UIColor colorWithRed:252/255.0f green:103/255.0f blue:61/255.0f alpha:1]];
        [contentLabel setTextColor:[UIColor colorWithRed:252/255.0f green:103/255.0f blue:61/255.0f alpha:1]];
    }
    [titleLabel setText:self.titleArr[section]];
    [contentLabel setText:self.contentArr[section]];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, -1, KProjectScreenWidth, 1)];
    [lineView setBackgroundColor:[HXColor colorWithHexString:@"#e5e9f2"]];
    [view addSubview:lineView];
    [view setBackgroundColor:[UIColor whiteColor]];
    return view;
    
}


- (void)action_tap:(UIGestureRecognizer *)tap{
    
    NSString *str = [NSString stringWithFormat:@"%d",(int)tap.view.tag];
    int numberOfSetion = [self.model.fengxianwenjuan intValue]?0:2;
    if ((int)tap.view.tag == 7-numberOfSetion) {
        /**
         *风险提示web页
         */
        NSString *userId = [CurrentUserInformation sharedCurrentUserInfo].userLoginState?[CurrentUserInformation sharedCurrentUserInfo].userId:@"0";
        int timestamp = [[NSDate date] timeIntervalSince1970];
        NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",userId,timestamp]);
        NSString *tokenlow=[token lowercaseString];

//        NSString *url=[NSString stringWithFormat:@"%@&user_id=%@&appid=huiyuan&shijian=%@&token=%@&jie_id=%@",kXZUniversalTestUrl(@"GetRiskWarning"),userId,[NSNumber numberWithInt:timestamp],tokenlow,self.projectId];
         NSString *url=[NSString stringWithFormat:@"%@user_id=%@&appid=huiyuan&shijian=%@&token=%@&jie_id=%@",kFMPhpUniversalBaseUrl(@"rongtuoxinsoc/helpzhongxin/fxfengxiants?"),userId,[NSNumber numberWithInt:timestamp],tokenlow,self.projectId];
        
        WLNewWebViewController *viewController=[[WLNewWebViewController alloc]initWithTitle:@"" AndWithShareUrl:url];
        viewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:viewController animated:YES];

    }else if ((int)tap.view.tag == 8-numberOfSetion){
        /**
         *去加息
         */
        if (![CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
            LoginController *registerController = [[LoginController alloc] init];
            FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
            [self presentViewController:navController animated:YES completion:nil];
            return;
        }
        FMPlaceOrderViewController * placeOrder = [[FMPlaceOrderViewController alloc]init];
        placeOrder.goToGoodShopIndex = 2;
        placeOrder.product_id = self.model.product_id;
        placeOrder.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:placeOrder animated:YES];

    }else{
    
        if ([dic[str] integerValue] == 0) {//如果是0，就把1赋给字典,打开cell
            
            [dic setObject:@"1" forKey:str];
            
        }else{//反之关闭cell
            
            [dic setObject:@"0" forKey:str];
            
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:[str integerValue]]withRowAnimation:UITableViewRowAnimationFade];//有动画的刷新
    }

}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSString *string = [NSString stringWithFormat:@"%ld",(long)section];
    NSString *fengxianwenjuan = self.model.fengxianwenjuan?self.model.fengxianwenjuan:0;
    if ([fengxianwenjuan intValue]) {
        if (section == 1) {
            if (![CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
                if (self.projectStyle == 3) {
                    return 0;
                }else{
                    return 1;
                }
            }else{
                if (self.projectStyle == 3) {
                    return 0;
                }else if (self.fengxiandengji.length>0) {
                    
                    return 1;
                    
                }else{
                    
                    return 0;
                }
            }
        }
        if ([dic[string] integerValue] == 1 ) {  //打开cell返回数组的count
            if (section == 0) {
                /**
                 *cell展开
                 */
                [self.trangleImag setImage:[UIImage imageNamed:@"项目详情_三角向上箭头_1702"]];
                self.isOpen = YES;
            }
            return 1;
            
        }else{
            if (section == 0){
                /**
                 *cell闭合
                 */
                [self.trangleImag setImage:[UIImage imageNamed:@"项目详情_三角向下箭头_1702"]];
                self.isOpen = NO;
            }
            
            return 0;
        }
    }else{
    
        return 0;
    }

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KProjectScreenWidth, 50)];
            [titleLabel setText:@"星级越高，违约概率越小（内部评级，仅供参考）"];
            [titleLabel setFont:[UIFont systemFontOfSize:13]];
            [cell.contentView addSubview:titleLabel];

        }
       
        return cell;
    }else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell2"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KProjectScreenWidth, 50)];
            if (self.fengxiandengji.length>0) {
                [titleLabel setText:self.fengxiandengji];
            }else{
            
                [titleLabel setText:@"请先完成风险承受能力评估"];
            }
            
            [titleLabel setFont:[UIFont systemFontOfSize:14]];
            [cell.contentView setBackgroundColor:[HXColor colorWithHexString:@"#e5e9f2"]];
            [cell.contentView addSubview:titleLabel];
            
            UIImageView *btnImage = [[UIImageView alloc]initWithFrame:CGRectMake(KProjectScreenWidth-90, 12.5, 80, 25)];
            [btnImage setImage:[UIImage imageNamed:@"项目详情_去评估按钮_1702"]];
            [cell.contentView addSubview:btnImage];
            UILabel *btnLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 25)];
            [btnLabel setText:@"去评估"];
            [btnLabel setTextAlignment:NSTextAlignmentCenter];
            [btnLabel setFont:[UIFont systemFontOfSize:15]];
            [btnLabel setTextColor:[UIColor whiteColor]];
            [btnImage addSubview:btnLabel];
            
            UIButton *pingGuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [pingGuBtn setFrame:CGRectMake(KProjectScreenWidth-90, 12.5, 80, 25)];
            [pingGuBtn addTarget:self action:@selector(pingGuAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:pingGuBtn];
            
        }
        return cell;

    }
 
}
/**
 *去评估
 */
-(void)pingGuAction{
    if (![CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
        LoginController *registerController = [[LoginController alloc] init];
        FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
        [self presentViewController:navController animated:YES completion:nil];
        return;
    }
    
    if (!([[CurrentUserInformation sharedCurrentUserInfo].huishangshiming integerValue]==1)) {
        [self notYetToOpenHuiFuTianXia];
        return;
        
    }
    if ([self.fengxiandengji isEqualToString:@"请先完成风险承受能力评估"]) {
        
        
        XZRiskQuestionnaireViewController *vc = [[XZRiskQuestionnaireViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        WLNewEvaluateViewController *vc = [[WLNewEvaluateViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }

}

/**
 *查看详情
 */
- (void)moreDetailBtnClick
{
    //加判断是否登录
    if (![CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
        LoginController *registerController = [[LoginController alloc] init];
        FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
        [self presentViewController:navController animated:YES completion:nil];
        return;
    }
    //加判断是否通过风险等级评估
//    if ([self.model.fengxianwenjuan intValue]) {
//        if (self.fengxiandengji.length>0) {
//            ShowAutoHideMBProgressHUD(self.view, @"请先完成风险承受能力评估");
//            return;
//        }
//    }
    
    
    //加判断是否实名认证
    if (!([[CurrentUserInformation sharedCurrentUserInfo].huishangshiming integerValue]==1)) {
        [self notYetToOpenHuiFuTianXia];
        return;

    }
    MoreProjectController *viewController=[[MoreProjectController alloc]initWithProjectModel:self.model];
    viewController.projectStyle=self.projectStyle;
    viewController.projectId = self.projectId;
    viewController.fengxiandengji = self.fengxiandengji;
    viewController.dizenge = self.dizenge;
    [self.navigationController pushViewController:viewController animated:YES];
        
}

-(void)notYetToOpenHuiFuTianXia
{
    /*
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您尚未开通汇付" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即开通", nil];
    alert.tag = 1000;
    [alert show];
     */
    
    __weak __typeof(&*self)weakSelf = self;
    [FMRTAddCardToView showWithAddBtn:^{
        FMTieBankCardViewController *tieBank = [[FMTieBankCardViewController alloc]init];
        tieBank.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:tieBank animated:YES];
        
        //!!!!!---!!!!
    }];
    
}
/*
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *url=[NSString stringWithFormat:@"%@?user_id=%@",realNameAuthenKaihuURL,[CurrentUserInformation sharedCurrentUserInfo].userId];
        WLZhuCeViewController *viewController=[[WLZhuCeViewController alloc]init];
        viewController.shareURL = url;
        viewController.navTitle = @"开通汇付";
        viewController.comeForm = 5;
        viewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:viewController animated:YES];
        
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
 */


/**
 *立即投资
 */
-(void)bottomBtnClick{

    if (!([[CurrentUserInformation sharedCurrentUserInfo].weishangbang integerValue]==1)) {
        [self notYetToOpenHuiFuTianXia];
        return;
    }
    
    
    if (!([[CurrentUserInformation sharedCurrentUserInfo].jiaoyimshezhi integerValue]==1)) {
        [self notYetToSetJiaoyiSecret];

        return;
    }

    
    WLNewBesureViewController *vc = [[WLNewBesureViewController alloc]init];
    vc.fengxiandengji = self.fengxiandengji;
    vc.projectId = self.projectId;
    vc.dizenge = self.dizenge;
    vc.lilvyou = self.model.lilvyou;
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)notYetToSetJiaoyiSecret
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"为了保障资金安全，请设置交易密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
    [alert show];
    
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        FMRTChangeTradeKeyViewController *tradeKeyVC = [[FMRTChangeTradeKeyViewController alloc]init];
        tradeKeyVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:tradeKeyVC animated:YES];
    }
}

/**
 *计算label高度
 */
-(CGFloat)heitForLabel:(NSString *)content{
    
    CGFloat chengweiW = KProjectScreenWidth*2/3-10;
    CGSize chengweiMaxSize = CGSizeMake(chengweiW, MAXFLOAT);
    NSDictionary *chengweiAttrs = @{NSFontAttributeName : [UIFont systemFontOfSize:16]};
    CGFloat chengweiH = [content boundingRectWithSize:chengweiMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:chengweiAttrs context:nil].size.height;
    return chengweiH;
}

@end
