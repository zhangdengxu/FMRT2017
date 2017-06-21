//
//  WLNewBesureViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 17/5/11.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "WLNewBesureViewController.h"
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"
#import "WPHotspotLabel.h"
#import "WLNewWebViewController.h"
#import "MakeABidWebViewController.h"
#import "XZBankRechargeController.h"
#import "XZUseRedEnvelopeController.h"
#import "XZRedEnvelopeModel.h"
#import "WLZhuCeViewController.h"
#import "FMKeyBoardNumberHeader.h"
@interface WLNewBesureViewController ()<UIScrollViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,strong)UILabel *shengYu;//当前剩余额度
@property(nonatomic,strong)UILabel *keyong;//账户可用额度

@property(nonatomic,strong)UITextField *jine;//投资金额
@property(nonatomic,strong)UILabel *shijijine;//账户可用额度

@property(nonatomic,strong)UILabel *hongbao;//红包券使用情况
@property(nonatomic,strong)UILabel *jiaxi;//加息券使用情况

@property(nonatomic,strong)UILabel *redHongbao;//红包券红色标识视图
@property(nonatomic,strong)UILabel *redJiaxi;//加息券红色标识视图

@property(nonatomic,strong)UIButton *hongBaoBtn;//红包
@property(nonatomic,strong)UIButton *jiaXiBtn;//加息
@property (nonatomic,strong)NSTimer *timer;//创建定时器
@property(nonatomic,strong)UIButton *selectBtn;//阅读选中按钮
@property(nonatomic,strong)UIButton *bottomBtn;//底部中按钮
@property(nonatomic,strong)UIView *bottomView;//底部视图
@property(nonatomic,strong)XZRedEnvelopeModel *hongBaoModel;//block返回红包模型
@property(nonatomic,strong)XZRedEnvelopeModel *JiaXimodel;//block返回加息券模型
@property(nonatomic,strong)NSString *RedPacket;//用户所选红包券标识
@property(nonatomic,strong)NSString *InterestCoupon;//用户所选加息券标识
@property(nonatomic,strong)NSString *yiShuRu;//上次输入的投资金额
@property(nonatomic,strong)NSString *keyongzheng;//不带逗号的可用额度
@property(nonatomic,strong)NSString *qixian;//投标期限
@property(nonatomic,strong)NSArray *hongbaoArr;//红包数组
@property(nonatomic,strong)NSArray *jiaxiArr;//加息券数组
@property(nonatomic,strong)NSDictionary *dicHongbao;//最优红包券推荐
@property(nonatomic,strong)NSDictionary *dicJiaxi;//最优加息券推荐
@property(nonatomic,assign)BOOL isFirst;
@end

@implementation WLNewBesureViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.isFirst) {
        [self.jine becomeFirstResponder];
        self.isFirst = YES;
    }
    [self createTimer];
    [self getDataFromeNetYuERfrash];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.jine resignFirstResponder];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"确认投资"];
    self.yiShuRu = @"";
    [self createContentView];
    [self createBottomBtn];
    
    [self getDataFromeNet];
    [self getDataFromeNetHongbao];
}

-(void)createTimer{
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(getDataFromeNet) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}
-(void)createContentView{
    
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [mainScrollView setBackgroundColor: KDefaultOrBackgroundColor];
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.delegate = self;
    mainScrollView.contentSize = CGSizeMake(self.view.bounds.size.width,self.view.bounds.size.height +20.0f);
    mainScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self getDataFromeNetYuERfrash];
    }];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollViewOnClick)];
    [mainScrollView addGestureRecognizer:tapGesture];
    [self.view addSubview:mainScrollView];
    self.mainScrollView = mainScrollView;
    /**
     *头部视图
     */
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 150)];
    [topView setBackgroundColor:[UIColor whiteColor]];
    [mainScrollView addSubview:topView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 1)];
    [lineView setBackgroundColor:[HXColor colorWithHexString:@"#e5e9f2"]];
    [topView addSubview:lineView];
    
    NSArray *titleArr = [NSArray arrayWithObjects:@"当前剩余额度（元）",@"账户可用额度（元）", nil];
    for (int i = 0; i<2; i++) {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50*i, KProjectScreenWidth-100, 50)];
        [leftLabel setText:titleArr[i]];
        leftLabel.textColor = [HXColor colorWithHexString:@"#333"];
        leftLabel.font = [UIFont systemFontOfSize:16];
        [topView addSubview:leftLabel];
        
        UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50*i, KProjectScreenWidth-10, 50)];
        rightLabel.textColor = [HXColor colorWithHexString:@"#333"];
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.font = [UIFont boldSystemFontOfSize:16];
        [topView addSubview:rightLabel];
        if (i == 0) {
            self.shengYu = rightLabel;
        }else{
            self.keyong = rightLabel;
        }
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, i*50+49, KProjectScreenWidth, 1)];
        [lineView setBackgroundColor:[HXColor colorWithHexString:@"#e5e9f2"]];
        [topView addSubview:lineView];
    }
    
    UIImageView *btnImage = [[UIImageView alloc]initWithFrame:CGRectMake(KProjectScreenWidth-100, 112.5, 80, 25)];
    [btnImage setImage:[UIImage imageNamed:@"项目详情_立即充值按钮外框_1702"]];
    [topView addSubview:btnImage];
    
    UILabel *btnLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 25)];
    [btnLabel setText:@"立即充值"];
    [btnLabel setTextAlignment:NSTextAlignmentCenter];
    [btnLabel setTextColor:[HXColor colorWithHexString:@"#0159d5"]];
    [btnLabel setFont:[UIFont systemFontOfSize:14]];
    [btnImage addSubview:btnLabel];
    
    UIButton *investBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [investBtn setFrame:CGRectMake(KProjectScreenWidth-100, 100, 100, 50)];
    [investBtn addTarget:self action:@selector(investAction:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:investBtn];
    
    /**
     *中部视图
     */
    UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(0, 155, KProjectScreenWidth, 100)];
    [middleView setBackgroundColor:[UIColor whiteColor]];
    [mainScrollView addSubview:middleView];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 49, KProjectScreenWidth, 1)];
    [lineView1 setBackgroundColor:[HXColor colorWithHexString:@"#e5e9f2"]];
    [middleView addSubview:lineView1];
    NSArray *titleArr1 = [NSArray arrayWithObjects:@"投资金额",@"实际付款金额", nil];
    for (int i = 0; i<2; i++) {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50*i, KProjectScreenWidth-100, 50)];
        [leftLabel setText:titleArr1[i]];
        leftLabel.textColor = [HXColor colorWithHexString:@"#333"];
        leftLabel.font = [UIFont systemFontOfSize:16];
        [middleView addSubview:leftLabel];
        
        if (i == 0) {
            UITextField *jineText = [[UITextField alloc]init];
            jineText.borderStyle = UITextBorderStyleNone;
            jineText.keyboardType = UIKeyboardTypeNumberPad;
            [middleView addSubview:jineText];
            self.jine = jineText;
            
            __weak __typeof(&*self)weakSelf = self;
            self.jine.inputAccessoryView = [FMKeyBoardNumberHeader initKeyBoardNumberHeaderCreate:^{
                [weakSelf keyBoardDown];
            }];
            
            self.jine.tag = 100;
            self.jine.delegate = self;
            [self.jine setFrame:CGRectMake(100, 50*i, KProjectScreenWidth-125, 50)];
            self.jine.textColor = [HXColor colorWithHexString:@"#333"];
            self.jine.font = [UIFont systemFontOfSize:16];
            
        }else{
            UILabel *rightLabel = [[UILabel alloc]init];
            rightLabel.textColor = [HXColor colorWithHexString:@"#333"];
            rightLabel.font = [UIFont boldSystemFontOfSize:16];
            [middleView addSubview:rightLabel];
            self.shijijine = rightLabel;
            [self.shijijine setFrame:CGRectMake(150, 50*i, KProjectScreenWidth-160, 50)];
            
        }
        
    }
    /**
     *底部视图
     */
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 260, KProjectScreenWidth, 100)];
    [bottomView setBackgroundColor:[UIColor whiteColor]];
    [mainScrollView addSubview:bottomView];
    self.bottomView = bottomView;
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 49, KProjectScreenWidth, 1)];
    [lineView2 setBackgroundColor:[HXColor colorWithHexString:@"#e5e9f2"]];
    [bottomView addSubview:lineView2];
    NSArray *titleArr2 = [NSArray arrayWithObjects:@"红包券",@"加息券", nil];
    for (int i = 0; i<2; i++) {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50*i, KProjectScreenWidth-100, 50)];
        [leftLabel setText:titleArr2[i]];
        leftLabel.textColor = [HXColor colorWithHexString:@"#333"];
        leftLabel.font = [UIFont systemFontOfSize:16];
        [bottomView addSubview:leftLabel];
        
        UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50*i, KProjectScreenWidth-40, 50)];
        rightLabel.textColor = [HXColor colorWithHexString:@"#333"];
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.font = [UIFont systemFontOfSize:16];
        [bottomView addSubview:rightLabel];
        
        if (i == 0) {
            self.hongbao = rightLabel;
            [self.hongbao setText:@"无可用"];
            
        }else{
            self.jiaxi = rightLabel;
            [self.jiaxi setText:@"无可用"];
        }
        
        UIImageView *arrowImg = [[UIImageView alloc]initWithFrame:CGRectMake(KProjectScreenWidth-30, 19+i*50, 7.5, 12)];
        [arrowImg setImage:[UIImage imageNamed:@"项目详情_向右小箭头_1702"]];
        [bottomView addSubview:arrowImg];
        
        UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [bottomBtn setFrame:CGRectMake(0, i*50, KProjectScreenWidth, 50)];
        [bottomBtn addTarget:self action:@selector(HongbaoAndJiaxiAction:) forControlEvents:UIControlEventTouchUpInside];
        [bottomBtn setTag:1000+i];
        [bottomView addSubview:bottomBtn];
        
    }
    
    /**
     *底部我已阅读并知悉。。。
     */
    UIButton *slectCtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [slectCtn setFrame:CGRectMake(5, 370, 16, 16)];
    [slectCtn setImage:[UIImage imageNamed:@"项目详情_阅读知悉--未勾选按钮_1702"] forState:UIControlStateNormal];
    [slectCtn setImage:[UIImage imageNamed:@"项目详情_阅读知悉--勾选按钮_1702"] forState:UIControlStateSelected];
    [slectCtn addTarget:self action:@selector(bottomSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [slectCtn setSelected:NO];
    [mainScrollView addSubview:slectCtn];
    self.selectBtn = slectCtn;
    [self.selectBtn setSelected:YES];
    
    /**不同颜色 点击事件**/
    NSString *userId = [CurrentUserInformation sharedCurrentUserInfo].userLoginState?[CurrentUserInformation sharedCurrentUserInfo].userId:@"0";
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSDictionary* style3 = @{@"body":[UIFont fontWithName:@"HelveticaNeue" size:12.0],
                             @"blue":[WPAttributedStyleAction styledActionWithAction:^{
                                 /**
                                  *跳转《网络借贷风险提示》
                                  */
                                 
//                                 NSString *url=[NSString stringWithFormat:@"%@&user_id=%@&appid=huiyuan&shijian=%@&token=%@&jie_id=%@",kXZUniversalTestUrl(@"GetRiskWarning"),userId,[NSNumber numberWithInt:timestamp],tokenlow,self.projectId];
                                  NSString *url=[NSString stringWithFormat:@"%@user_id=%@&appid=huiyuan&shijian=%@&token=%@&jie_id=%@",kFMPhpUniversalBaseUrl(@"rongtuoxinsoc/helpzhongxin/fxfengxiants?"),userId,[NSNumber numberWithInt:timestamp],tokenlow,self.projectId];
                                 WLNewWebViewController *viewController=[[WLNewWebViewController alloc]initWithTitle:@"" AndWithShareUrl:url];
                                 viewController.hidesBottomBarWhenPushed=YES;
                                 [self.navigationController pushViewController:viewController animated:YES];
                                 
                             }],
                             @"orange":[WPAttributedStyleAction styledActionWithAction:^{
                                 /**
                                  *跳转《网络借贷平台禁止性行为》
                                  */
//                                 NSString *url=[NSString stringWithFormat:@"%@&user_id=%@&appid=huiyuan&shijian=%@&token=%@&jie_id=%@",kXZUniversalTestUrl(@"GetProhibitBehavior"),userId,[NSNumber numberWithInt:timestamp],tokenlow,self.projectId];
                                 NSString *url=[NSString stringWithFormat:@"%@user_id=%@&appid=huiyuan&shijian=%@&token=%@&jie_id=%@",kFMPhpUniversalBaseUrl(@"rongtuoxinsoc/helpzhongxin/jizhixingwei?"),userId,[NSNumber numberWithInt:timestamp],tokenlow,self.projectId];
                                 WLNewWebViewController *viewController=[[WLNewWebViewController alloc]initWithTitle:@"" AndWithShareUrl:url];
                                 viewController.hidesBottomBarWhenPushed=YES;
                                 [self.navigationController pushViewController:viewController animated:YES];
                                 
                             }],
                             @"link": [HXColor colorWithHexString:@"#0099e9"]
                             };
    
    WPHotspotLabel *labelFour = [[WPHotspotLabel alloc]initWithFrame:CGRectMake(26, 358, KProjectScreenWidth-40, 50)];
    labelFour.numberOfLines = 0;
    labelFour.attributedText = [@"我已阅读并知悉 <blue>《网络借贷风险提示》</blue> 和 <orange>《网络借贷平台禁止性行为》</orange> " attributedStringWithStyleBook:style3];
    [mainScrollView addSubview:labelFour];
    
}

-(void)keyBoardDown{
    
    [self.jine resignFirstResponder];
    
}

/**
 *创建立即投资按钮
 */
-(void)createBottomBtn{
    
    UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (![CurrentUserInformation sharedCurrentUserInfo].userLoginState) {
        //灰色
        [bottomButton setBackgroundColor:[UIColor colorWithRed:169/255.0f green:170/255.0f blue:171/255.0f alpha:1]];
    }else if ([self.model.fengxianwenjuan intValue]) {
        if(self.fengxiandengji.length>0){
            
            [bottomButton setBackgroundColor:[UIColor colorWithRed:169/255.0f green:170/255.0f blue:171/255.0f alpha:1]];
        }else{
            [bottomButton setBackgroundColor:[UIColor colorWithRed:1/255.0f green:89/255.0f blue:213/255.0f alpha:.9]];
            [bottomButton addTarget:self action:@selector(getDataFromeNetLogic) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    else{
        
        [bottomButton setBackgroundColor:[UIColor colorWithRed:1/255.0f green:89/255.0f blue:213/255.0f alpha:.9]];
        [bottomButton addTarget:self action:@selector(getDataFromeNetLogic) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [bottomButton setTitle:@"立即投资" forState:UIControlStateNormal];
    bottomButton.titleLabel.font=[UIFont boldSystemFontOfSize:16.0f];
    [bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomButton setFrame:CGRectMake(0, KProjectScreenHeight-55-64, KProjectScreenWidth, 55)];
    [self.view addSubview:bottomButton];
    
    self.bottomBtn = bottomButton;
    
}

/**
 *创建红色“可用”视图
 */
-(void)createBottomRedView:(NSInteger)nuberOfTikets AndType:(NSString *)type{
    
    CGFloat height = [type isEqualToString:@"GetInterestCoupon"]?66:16;
    UILabel *keYongLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, height, 50, 18)];
    [keYongLabel setText:[NSString stringWithFormat:@"%ld张可用",(long)nuberOfTikets]];
    [keYongLabel setBackgroundColor:[UIColor colorWithRed:252/255.0f green:84/255.0f blue:90/255.0f alpha:1]];
    [keYongLabel setTextAlignment:NSTextAlignmentCenter];
    [keYongLabel setTextColor:[UIColor whiteColor]];
    [keYongLabel setFont:[UIFont systemFontOfSize:11]];
    
    if ([type isEqualToString:@"GetInterestCoupon"]) {
        self.redJiaxi = keYongLabel;
        [self.bottomView addSubview:self.redJiaxi];
    }else{
        
        self.redHongbao = keYongLabel;
        [self.bottomView addSubview:self.redHongbao];
    }
    
}

/**
 *数据请求--剩余额度（头部）
 */
-(void)getDataFromeNet{
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{
                                 @"jie_id":self.projectId,
                                 @"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"AppId":@"huiyuan",
                                 @"AppTime":[NSNumber numberWithInt:timestamp],
                                 @"Token":tokenlow,
                                 };
    
    __weak __typeof(&*self)weakSelf = self;
//    kXZUniversalTestUrl(@"GetProjectSchedule")
    [FMHTTPClient postPath:kFMPhpUniversalBaseUrl(@"rongtuoxinsoc/lend/xingmjindu")parameters:parameter completion:^(WebAPIResponse *response) {
        
        NSString * status = [NSString stringWithFormat:@"%@",response.responseObject[@"status"]];
        
        if ([status integerValue] == 0) {
            NSDictionary *dic = response.responseObject[@"data"];
            self.qixian = [dic objectForKey:@"qixian"];
            float SYedu = [[dic objectForKey:@"shengyu"] floatValue];
            if (SYedu < 1) {
                [self.bottomBtn setBackgroundColor:[UIColor colorWithRed:169/255.0f green:170/255.0f blue:171/255.0f alpha:1]];
                [self.bottomBtn setUserInteractionEnabled:NO];
            }
            //ketouqianshu
            [weakSelf.shengYu setText:[NSString stringWithFormat:@"%.2f",SYedu]];
            
        }else
        {
            ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
            
        }
        
    }];
    
}

/**
 *数据请求--可用余额（也是头部）
 */
-(void)getDataFromeNetYuERfrash{
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString *navUrl = @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/mybalannum";
    NSDictionary * parameter = @{@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,@"appid":@"huiyuan",@"shijian":[NSNumber numberWithInt:timestamp],@"token":tokenlow};
    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient postPath:navUrl parameters:parameter completion:^(WebAPIResponse *response) {
        NSString * status = [NSString stringWithFormat:@"%@",response.responseObject[@"status"]];
        if ([status integerValue] == 0) {
            //成功
            NSDictionary *dic = response.responseObject[@"data"];
            [weakSelf.keyong setText:[dic objectForKey:@"keyong"]];
            weakSelf.keyongzheng = [dic objectForKey:@"keyongzheng"];
            
        }else if([status integerValue] == 2)
        {
            //开通汇付
            ShowAutoHideMBProgressHUD(weakSelf.view,@"请先开通汇付");
        }else
        {
            ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
            
        }
        [self.mainScrollView.mj_header endRefreshing];
    }];
}


/**
 *数据请求--查询用户红包列表
 */
-(void)getDataFromeNetHongbao{
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString *navUrl = kXZUniversalTestUrl(@"GetRedPacket");
    NSDictionary * parameter = @{@"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"Status":@"4",
                                 @"AppTime":[NSNumber numberWithInt:timestamp],
                                 @"Token":tokenlow,
                                 @"ProjId":self.projectId};
    __weak __typeof(&*self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:navUrl parameters:parameter completion:^(WebAPIResponse *response) {
        NSString * status = [NSString stringWithFormat:@"%@",response.responseObject[@"status"]];
        if ([status integerValue] == 0) {
            NSDictionary *dic = response.responseObject[@"data"];
            NSArray *arry = [dic objectForKey:@"Detail"];
            self.hongbaoArr = arry;
            NSString *Num = [dic objectForKey:@"Num"];
            [weakSelf.redHongbao removeFromSuperview];
            if ([Num intValue]) {
                //添加数组遍历 如果红包不可用 则去除
                [weakSelf createBottomRedView:arry.count AndType:@"GetRedPacket"];
                [weakSelf.hongbao setText:@"未使用"];
                [weakSelf.hongbao setTextColor:[HXColor colorWithHexString:@"#333"]];
                
                //如果有默认最优红包券则显示
//                for (NSDictionary *dict in arry) {
//                    if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"Id"]] isEqualToString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"Id"]]]) {
//                        
//                        self.dicHongbao = dict;
//                    }
//                }
                
            }else{
                [weakSelf.hongbao setText:@"无可用"];
                weakSelf.hongbao.textColor = [HXColor colorWithHexString:@"#333"];
            }
        }else
        {
            ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
        }
        [self getDataFromeNetJiaxi];
    }];
}

/**
 *数据请求--查询用户加息劵列表
 */
-(void)getDataFromeNetJiaxi{
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString *navUrl = kXZUniversalTestUrl(@"GetInterestCoupon");
    NSDictionary * parameter = @{@"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"Status":@"4",
                                 @"AppTime":[NSNumber numberWithInt:timestamp],
                                 @"Token":tokenlow,
                                 @"ProjId":self.projectId
                                 };
    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient postPath:navUrl parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSString * status = [NSString stringWithFormat:@"%@",response.responseObject[@"status"]];
        if ([status integerValue] == 0) {
            [weakSelf.redJiaxi removeFromSuperview];
            NSDictionary *dic = response.responseObject[@"data"];
            NSArray *arry = [dic objectForKey:@"Detail"];
            self.jiaxiArr = arry;
            NSString *Num = [dic objectForKey:@"Num"];
            if ([Num intValue]) {
                [weakSelf createBottomRedView:[Num intValue] AndType:@"GetInterestCoupon"];
                [weakSelf.jiaxi setText:@"未使用"];
                [weakSelf.jiaxi setTextColor:[HXColor colorWithHexString:@"#333"]];
                
                //如果有默认最优加息券则显示
//                for (NSDictionary *dict in arry) {
//                    if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"Id"]] isEqualToString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"Id"]]]) {
//                        self.dicJiaxi = dict;
//                    }
//                }
                
            }else{
                [weakSelf.jiaxi setText:@"无可用"];
                [weakSelf.jiaxi setTextColor:[HXColor colorWithHexString:@"#333"]];
            }
        }else
        {
            ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
        }
        [self HongbaoAndJiaxi:0];
    }];
}

/**
 *数据请求--购买 跳汇付页面逻辑
 TransAmt  投标金额 00
 RedPacket  红包券标识
 InterestCoupon  加息券标识
 */
-(void)getDataFromeNetLogic{
    
    //    if (!([CurrentUserInformation sharedCurrentUserInfo].shiming==1)) {
    //        [self notYetToOpenHuiFuTianXia];
    //        return;
    //
    //    }
    
    [self getDataFromNetWork];
    
}


//处理--根据默认最优红包和抵价券处理二者显示 1表示输入框文字变动后进入 0表示请求数据后直接处理
-(void)HongbaoAndJiaxi:(int)isFromText{
    
    if (self.dicHongbao && !self.dicJiaxi) {
        //只有红包没有加息
//        if (isFromText == 0) {//请求数据后进入 给投资金额和实际付款金额赋初值
//            [self.jine setText:[NSString stringWithFormat:@"%.0f",[[self.dicHongbao objectForKey:@"ProjAmtMin"] floatValue]]];
//            [self.shijijine setText:[NSString stringWithFormat:@"%.2f",[self.jine.text floatValue]-[[self.dicHongbao objectForKey:@"Amt"] floatValue]]];
//            [self recreateHongbaoAndJiaxi];
//            
//        }
        //model
        XZRedEnvelopeModel *model = [[XZRedEnvelopeModel alloc]init];
        model.Id = [self.dicHongbao objectForKey:@"Id"];
        model.ProjAmtMax = [self.dicHongbao objectForKey:@"ProjAmtMax"];
        model.ProjAmtMin = [self.dicHongbao objectForKey:@"ProjAmtMin"];
        model.ProjDurationMax = [self.dicHongbao objectForKey:@"ProjDurationMax"];
        model.ProjDurationMin = [self.dicHongbao objectForKey:@"ProjDurationMin"];
        model.Amt = [self.dicHongbao objectForKey:@"Amt"];
        self.hongBaoModel = model;
        //布局
        self.hongbao.textColor = [HXColor colorWithHexString:@"#ff5254"];
        [self.hongbao setText:[NSString stringWithFormat:@"-%.2f",[[self.dicHongbao objectForKey:@"Amt"] floatValue]]];
        self.RedPacket = [NSString stringWithFormat:@"%@",[self.dicHongbao objectForKey:@"Id"]];
    }else if (!self.dicHongbao && self.dicJiaxi){
        //只有加息没有红包
//        if (isFromText == 0){
//            
//            [self.jine setText:[NSString stringWithFormat:@"%.0f",[[self.dicJiaxi objectForKey:@"ProjAmtMin"] floatValue]]];
//            [self.shijijine setText:[NSString stringWithFormat:@"%.2f",[self.jine.text floatValue]]];
//            [self recreateHongbaoAndJiaxi];
//            
//        }
        //model
        XZRedEnvelopeModel *model = [[XZRedEnvelopeModel alloc]init];
        model.Id = [self.dicJiaxi objectForKey:@"Id"];
        model.ProjAmtMax = [self.dicJiaxi objectForKey:@"ProjAmtMax"];
        model.ProjAmtMin = [self.dicJiaxi objectForKey:@"ProjAmtMin"];
        model.ProjDurationMax = [self.dicJiaxi objectForKey:@"ProjDurationMax"];
        model.ProjDurationMin = [self.dicJiaxi objectForKey:@"ProjDurationMin"];
        model.Amt = [self.dicJiaxi objectForKey:@"Amt"];
        self.JiaXimodel = model;
        //布局
        self.jiaxi.textColor = [HXColor colorWithHexString:@"#ff5254"];
        [self.jiaxi setText:[NSString stringWithFormat:@"+%.1f%%",[[self.dicJiaxi objectForKey:@"Rate"] floatValue]*100]];
        if ([self.lilvyou floatValue]>0) {
            if ([[self.dicJiaxi objectForKey:@"Rate"] floatValue]*100>[self.lilvyou floatValue]) {
                [self.jiaxi setText:[NSString stringWithFormat:@"+%.1f%%",[self.lilvyou floatValue]]];
            }
        }
        self.InterestCoupon = [NSString stringWithFormat:@"%@",[self.dicJiaxi objectForKey:@"Id"]];
        
    }else if (self.dicHongbao && self.dicJiaxi){
        //两个都有
        if ([self.model.lilvyou floatValue]>0) {
            //加息优先
//            if (isFromText == 0){
//                [self.jine setText:[NSString stringWithFormat:@"%.0f",[[self.dicJiaxi objectForKey:@"ProjAmtMin"] floatValue]]];
//                [self.shijijine setText:[NSString stringWithFormat:@"%.2f",[self.jine.text floatValue]]];
//                [self recreateHongbaoAndJiaxi];
//            }
            self.jiaxi.textColor = [HXColor colorWithHexString:@"#ff5254"];
            [self.jiaxi setText:[NSString stringWithFormat:@"+%.1f%%",[[self.dicJiaxi objectForKey:@"Rate"] floatValue]*100]];
            if ([[self.dicJiaxi objectForKey:@"Rate"] floatValue]*100>[self.lilvyou floatValue]) {
                [self.jiaxi setText:[NSString stringWithFormat:@"+%.1f%%",[self.lilvyou floatValue]]];
            }
            
            self.InterestCoupon = [NSString stringWithFormat:@"%@",[self.dicJiaxi objectForKey:@"Id"]];
            //model
            XZRedEnvelopeModel *model = [[XZRedEnvelopeModel alloc]init];
            model.Id = [self.dicJiaxi objectForKey:@"Id"];
            model.ProjAmtMax = [self.dicJiaxi objectForKey:@"ProjAmtMax"];
            model.ProjAmtMin = [self.dicJiaxi objectForKey:@"ProjAmtMin"];
            model.ProjDurationMax = [self.dicJiaxi objectForKey:@"ProjDurationMax"];
            model.ProjDurationMin = [self.dicJiaxi objectForKey:@"ProjDurationMin"];
            model.Amt = [self.dicJiaxi objectForKey:@"Amt"];
            self.JiaXimodel = model;
            
            
        }else{
            //红包优先
//            if (isFromText == 0){
//                [self.jine setText:[NSString stringWithFormat:@"%.0f",[[self.dicHongbao objectForKey:@"ProjAmtMin"] floatValue]]];
//                [self.shijijine setText:[NSString stringWithFormat:@"%.2f",[self.jine.text floatValue]-[[self.dicHongbao objectForKey:@"Amt"] floatValue]]];
//                [self recreateHongbaoAndJiaxi];
//            }
            
            self.hongbao.textColor = [HXColor colorWithHexString:@"#ff5254"];
            [self.hongbao setText:[NSString stringWithFormat:@"-%.2f",[[self.dicHongbao objectForKey:@"Amt"] floatValue]]];
            self.RedPacket = [NSString stringWithFormat:@"%@",[self.dicHongbao objectForKey:@"Id"]];
            
            //model
            XZRedEnvelopeModel *model = [[XZRedEnvelopeModel alloc]init];
            model.Id = [self.dicHongbao objectForKey:@"Id"];
            model.ProjAmtMax = [self.dicHongbao objectForKey:@"ProjAmtMax"];
            model.ProjAmtMin = [self.dicHongbao objectForKey:@"ProjAmtMin"];
            model.ProjDurationMax = [self.dicHongbao objectForKey:@"ProjDurationMax"];
            model.ProjDurationMin = [self.dicHongbao objectForKey:@"ProjDurationMin"];
            model.Amt = [self.dicHongbao objectForKey:@"Amt"];
            self.hongBaoModel = model;
            
        }
    }
    self.yiShuRu = self.jine.text;
    
    
}

/* 判断是否注册汇付 */
-(void)getDataFromNetWork
{
    //添加判断 当前余额 可用余额 投资金额
    
    if (!([self.jine.text floatValue]>0)) {
        ShowAutoHideMBProgressHUD(self.view,@"请输入投资金额");
        return;
    }
    if ([self.shengYu.text intValue]<=[self.dizenge intValue]) {
        ShowAutoHideMBProgressHUD(self.view,@"当前剩余额度不足");
        return;
    }
    
    if ([self.shijijine.text floatValue]>[self.keyongzheng floatValue]) {
        ShowAutoHideMBProgressHUD(self.view,@"输入金额超过账户可用余额");
        return;
    }
    if ([self.shijijine.text floatValue]>[self.shengYu.text floatValue]) {
        ShowAutoHideMBProgressHUD(self.view,@"输入金额超过当前剩余额度");
        return;
    }
    if (self.jine.text.length>0 && [self.jine.text intValue]%[self.dizenge intValue]==0){
        
    }else{
        ShowAutoHideMBProgressHUD(self.view,[NSString stringWithFormat:@"投资金额必须是%.2f的整数倍",[self.dizenge floatValue]]);
        return;
    }
    if ([self.jine.text floatValue]-[self.jine.text intValue]!=0) {
        ShowAutoHideMBProgressHUD(self.view,[NSString stringWithFormat:@"投资金额必须是%.2f的整数倍",[self.dizenge floatValue]]);
        return;
    }
    if (!self.selectBtn.selected) {
        ShowAutoHideMBProgressHUD(self.view,@"请先阅读并勾选");
        return;
    }
    CGFloat jine = [self.jine.text floatValue];
    NSString *navUrl;
//    if ([CurrentUserInformation sharedCurrentUserInfo].statusNetWork == 0) {
//        /**
//         *跳Java接口
//         */
        navUrl = [NSString stringWithFormat:@"%@&UserId=%@&ProjId=%@&TransAmt=%@&RedPacket=%@&InterestCoupon=%@",kXZUniversalTestUrl(@"LLBidApply"),[CurrentUserInformation sharedCurrentUserInfo].userId,self.projectId,[NSString stringWithFormat:@"%.2f",jine],self.RedPacket?self.RedPacket:@"",self.InterestCoupon?self.InterestCoupon:@""];
//    }else{
//        /**
//         *跳PHP接口
//         */
//        
//    }
    MakeABidWebViewController *viewController=[[MakeABidWebViewController alloc]initWithTitle:@"投标" AndWithShareUrl:navUrl];
    
    [self.navigationController pushViewController:viewController animated:YES];
    
}

/**
 *开通汇付提示框
 */
/*
-(void)notYetToOpenHuiFuTianXia
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您尚未开通汇付" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即开通", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *url=[NSString stringWithFormat:@"%@?user_id=%@",realNameAuthenKaihuURL,[CurrentUserInformation sharedCurrentUserInfo].userId];
        WLZhuCeViewController *viewController=[[WLZhuCeViewController alloc]init];
        viewController.shareURL = url;
        viewController.navTitle = @"开通汇付";
        viewController.comeForm = 1;
        viewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:viewController animated:YES];
        
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
 */

/**
 *限制只能输入数字
 */
- (BOOL)validateNumberByRegExp:(NSString *)string {
    BOOL isValid = YES;
    NSUInteger len = string.length;
    if (len > 0) {
        NSString *numberRegex = @"^[0-9.]*$";
        NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
        isValid = [numberPredicate evaluateWithObject:string];
    }
    return isValid;
}

/**
 *立即充值
 */
-(void)investAction:(UIButton *)button{
    
    XZBankRechargeController *vc = [[XZBankRechargeController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *我已阅读。。。郎闲的 勾选按钮
 */
-(void)bottomSelectAction:(UIButton *)button{
    
    button.selected=!button.selected;
    if (!button.selected) {
        [self.bottomBtn setBackgroundColor:[UIColor colorWithRed:169/255.0f green:170/255.0f blue:171/255.0f alpha:1]];
        self.bottomBtn.userInteractionEnabled = NO;
    }else{
        
        [self.bottomBtn setBackgroundColor:[UIColor colorWithRed:1/255.0f green:89/255.0f blue:213/255.0f alpha:.9]];
        self.bottomBtn.userInteractionEnabled = YES;
    }
}

/**
 *选择红包或加息券
 */
-(void)HongbaoAndJiaxiAction:(UIButton *)button{
    
    if (button.tag == 1000) {
        XZUseRedEnvelopeController *vc = [[XZUseRedEnvelopeController alloc]init];
        vc.isRedEnvelopeView = YES;
        vc.modelSelected = self.hongBaoModel;
        vc.useBidAmt = self.jine.text;
        vc.lilvyou = self.lilvyou;
        vc.ProjId = self.projectId;
        vc.blockSendModel = ^(XZRedEnvelopeModel *model){
            if (!model.Id) { // 没选择
                [self gandiaoHongbao];
                self.hongBaoModel = [[XZRedEnvelopeModel alloc]init];
                self.dicHongbao = nil;
                self.dicJiaxi = nil;
                [self.shijijine setText:[NSString stringWithFormat:@"%.2f",[self.jine.text floatValue]]];
            }else { // 赋值
                self.hongBaoModel = model;
                float jine = [self.jine.text floatValue]-[model.Amt floatValue];
                [self.shijijine setText:[NSString stringWithFormat:@"%.2f",jine]];
                self.hongbao.textColor = [HXColor colorWithHexString:@"#ff5254"];
                [self.hongbao setText:[NSString stringWithFormat:@"-%.2f",[model.Amt floatValue]]];
                self.RedPacket = [NSString stringWithFormat:@"%@",model.Id];
                if (!self.jine.text.length) {//如果未输入金额直接选择红包
                    [self.jine setText:[NSString stringWithFormat:@"%.0f",[model.ProjAmtMin floatValue]]];
                    [self.shijijine setText:[NSString stringWithFormat:@"%.2f",[model.ProjAmtMin floatValue]-[model.Amt floatValue]]];
                    self.yiShuRu = self.jine.text;
                    /**
                     *这里要根据输入框金额检索一遍可用红包加息券
                     */
                    [self recreateHongbaoAndJiaxi];
                }
                
                //同时把加息方面的东西干掉
                self.JiaXimodel = [[XZRedEnvelopeModel alloc]init];
                [self gandiaoJiaxi];
            }
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (button.tag == 1001) {
        XZUseRedEnvelopeController *vc = [[XZUseRedEnvelopeController alloc]init];
        vc.isRedEnvelopeView = NO;
        vc.modelSelected = self.JiaXimodel;
        vc.useBidAmt = self.jine.text;
        vc.lilvyou = self.lilvyou;
        vc.ProjId = self.projectId;
        vc.blockSendModel = ^(XZRedEnvelopeModel *model){
            if (!model.Id) { // 没选择
                self.JiaXimodel = [[XZRedEnvelopeModel alloc]init];
                self.dicHongbao = nil;
                self.dicJiaxi = nil;
                [self gandiaoJiaxi];
            }else { // 赋值
                
                self.JiaXimodel = model;
                [self.jiaxi setText:[NSString stringWithFormat:@"+%.1f%%",[model.Rate floatValue]]];
                self.jiaxi.textColor = [HXColor colorWithHexString:@"#ff5254"];
                self.InterestCoupon = [NSString stringWithFormat:@"%@",model.Id];
                
                if (!self.jine.text.length) {//如果未输入金额直接选择加息券
                    [self.jine setText:[NSString stringWithFormat:@"%.0f",[model.ProjAmtMin floatValue]]];
                    self.yiShuRu = self.jine.text;
                    /**
                     *这里要根据输入框金额检索一遍可用红包加息券
                     */
                    [self recreateHongbaoAndJiaxi];
                }
                
                //同时把红包方面的东西干掉 包括干掉布局 model 重新计算实际付款金额
                [self gandiaoHongbao];
                self.hongBaoModel = [[XZRedEnvelopeModel alloc]init];
                [self.shijijine setText:[NSString stringWithFormat:@"%.2f",[self.jine.text floatValue]]];
                
            }
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/**
 *未输入投资金额时选择红包券或抵价券-->金额变化后重建红包券和加息券  选择完券之后 给了默认投资金额 可用红包数也跟着改变
 */
-(void)recreateHongbaoAndJiaxi{
    
    if (self.hongbaoArr.count) {
        
        int i = 0;
        for (NSDictionary *dic in self.hongbaoArr) {
            if ([[dic objectForKey:@"ProjAmtMax"] floatValue] == 0) {
                if ([[dic objectForKey:@"ProjAmtMin"] floatValue] <= [self.jine.text floatValue]) {
                    i ++;
                }
            }else if ([[dic objectForKey:@"ProjAmtMin"] floatValue] <= [self.jine.text floatValue]&&[[dic objectForKey:@"ProjAmtMax"] floatValue] >= [self.jine.text floatValue]) {
                i ++;
            }
        }
        if (i>0) {
            //可用红包数大于0
            [self.redHongbao removeFromSuperview];
            if ([self.redHongbao.text isEqualToString:@"无可用"]) {
                [self.hongbao setText:@"未使用"];
            }
            [self createBottomRedView:i AndType:@"GetRedPacket"];
        }else{
            [self.redHongbao removeFromSuperview];
            [self.hongbao setText:@"无可用"];
        }
    }
    
    
    if (self.jiaxiArr.count) {
        int i = 0;
        for (NSDictionary *dic in self.jiaxiArr) {
            
            if ([[dic objectForKey:@"ProjDurationMax"] intValue] == 0) {
                if ([[dic objectForKey:@"ProjDurationMin"] intValue]<=[self.qixian intValue]) {
                    if ([[dic objectForKey:@"ProjAmtMax"] floatValue] == 0) {
                        if ([[dic objectForKey:@"ProjAmtMin"] floatValue] <= [self.jine.text floatValue]) {
                            i ++;
                        }
                        
                    }else if ([[dic objectForKey:@"ProjAmtMin"] floatValue] <= [self.jine.text floatValue]&&[[dic objectForKey:@"ProjAmtMax"] floatValue] >= [self.jine.text floatValue]) {
                        i ++;
                    }
                }
                
            }else{
                if ([[dic objectForKey:@"ProjDurationMax"] intValue]>=[self.qixian intValue]&&[[dic objectForKey:@"ProjDurationMin"] intValue]<=[self.qixian intValue]) {
                    
                    if ([[dic objectForKey:@"ProjAmtMax"] floatValue] == 0) {
                        if ([[dic objectForKey:@"ProjAmtMin"] floatValue] <= [self.jine.text floatValue]) {
                            i ++;
                        }
                        
                    }else if ([[dic objectForKey:@"ProjAmtMin"] floatValue] <= [self.jine.text floatValue]&&[[dic objectForKey:@"ProjAmtMax"] floatValue] >= [self.jine.text floatValue]) {
                        i ++;
                    }
                }
            }
        }
        if (i>0) {
            //可用加息券数大于0
            [self.redJiaxi removeFromSuperview];
            if ([self.redJiaxi.text isEqualToString:@"无可用"]) {
                [self.redJiaxi setText:@"未使用"];
            }
            [self createBottomRedView:i AndType:@"GetInterestCoupon"];
            
        }else{
            [self.redJiaxi removeFromSuperview];
            [self.redJiaxi setText:@"无可用"];
        }
        
    }
    
}

-(void)scrollViewOnClick{
    
    [self.jine resignFirstResponder];
}

#pragma mark ---- UITextViewDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location>10) {
        return NO;
    }
    return [self validateNumberByRegExp:string];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    //textfeld输入文字有变化时处理
    if (![textField.text isEqualToString:self.yiShuRu]) {
        self.yiShuRu = textField.text;
        
//        //如果已选择红包 金额改变后红包依然可用 则保留
//        if (self.hongBaoModel.Id) {
//            
//            if ([self.hongBaoModel.ProjAmtMax  floatValue] == 0) {
//                if ([self.hongBaoModel.ProjAmtMin floatValue] <= [textField.text floatValue]) {
//                    
//                    [self.shijijine setText:[NSString stringWithFormat:@"%.2f",[self.jine.text floatValue]-[self.hongBaoModel.Amt floatValue]]];
//                    [self reCreateRedHongbaoAndRedJiaxi];
//                    return;
//                }
//            }else if ([self.hongBaoModel.ProjAmtMin  floatValue]
//                      <= [textField.text floatValue]&&[self.hongBaoModel.ProjAmtMax  floatValue] >= [textField.text floatValue]) {
//                
//                [self.shijijine setText:[NSString stringWithFormat:@"%.2f",[self.jine.text floatValue]-[self.hongBaoModel.Amt floatValue]]];
//                [self reCreateRedHongbaoAndRedJiaxi];
//                return;
//            }
//        }
//        
//        //如果已选择加息券 金额改变后加息券依然可用 则保留
//        if (self.JiaXimodel.Id) {
//            
//            if ([self.JiaXimodel.ProjDurationMax intValue] == 0) {
//                if ([self.JiaXimodel.ProjDurationMin intValue]<=[self.qixian intValue]) {
//                    if ([self.JiaXimodel.ProjAmtMax floatValue] == 0) {
//                        if ([self.JiaXimodel.ProjAmtMin floatValue] <= [textField.text floatValue]) {
//                            [self.shijijine setText:[NSString stringWithFormat:@"%.2f",[self.jine.text floatValue]]];
//                            [self reCreateRedHongbaoAndRedJiaxi];
//                            
//                            return;
//                        }
//                        
//                    }else if ([self.JiaXimodel.ProjAmtMin floatValue] <= [textField.text floatValue]&&[self.JiaXimodel.ProjAmtMax floatValue] >= [textField.text floatValue]) {
//                        [self.shijijine setText:[NSString stringWithFormat:@"%.2f",[self.jine.text floatValue]]];
//                        [self reCreateRedHongbaoAndRedJiaxi];
//                        return;
//                    }
//                }
//                
//            }else{
//                if ([self.JiaXimodel.ProjDurationMax intValue]>=[self.qixian intValue]&&[self.JiaXimodel.ProjDurationMin intValue]<=[self.qixian intValue]) {
//                    if ([self.JiaXimodel.ProjAmtMax floatValue] == 0) {
//                        if ([self.JiaXimodel.ProjAmtMin floatValue] <= [textField.text floatValue]) {
//                            [self.shijijine setText:[NSString stringWithFormat:@"%.2f",[self.jine.text floatValue]]];
//                            [self reCreateRedHongbaoAndRedJiaxi];
//                            return;
//                        }
//                        
//                    }else if ([self.JiaXimodel.ProjAmtMin floatValue] <= [textField.text floatValue]&&[self.JiaXimodel.ProjAmtMax floatValue] >= [textField.text floatValue]) {
//                        [self.shijijine setText:[NSString stringWithFormat:@"%.2f",[self.jine.text floatValue]]];
//                        [self reCreateRedHongbaoAndRedJiaxi];
//                        return;
//                        
//                    }
//                }
//            }
//        }
        
        //没有已经选择或默认的红包加息券时 先干掉再说
        [self.hongbao setTextColor:[HXColor colorWithHexString:@"#333"]];
        [self.jiaxi setTextColor:[HXColor colorWithHexString:@"#333"]];
        self.InterestCoupon = @"";
        self.RedPacket = @"";
        self.dicHongbao = nil;
        self.dicJiaxi = nil;
        self.hongBaoModel = [[XZRedEnvelopeModel alloc]init];
        self.JiaXimodel = [[XZRedEnvelopeModel alloc]init];
        [self.redHongbao removeFromSuperview];
        [self.redJiaxi removeFromSuperview];
        self.shijijine.text = [NSString stringWithFormat:@"%.2f",[textField.text floatValue]];
        
        if (self.jine.text.length == 0) {//输入框为空时恢复到初始状态
            if (self.hongbaoArr.count) {
                [self.hongbao setText:@"未使用"];
                
                [self createBottomRedView:self.hongbaoArr.count AndType:@"GetRedPacket"];
            }else{
                [self.hongbao setText:@"无可用"];
            }
            if (self.jiaxiArr.count) {
                [self.jiaxi setText:@"未使用"];
                [self createBottomRedView:self.jiaxiArr.count AndType:@"GetInterestCoupon"];
            }else{
                [self.jiaxi setText:@"无可用"];
            }
//            [self HongbaoAndJiaxi:1];
            
            return;
        }
        //根据金额改变可用红包和加息券数量显示 -->这里要手动选出一个最合适的红包加息券
        if (self.hongbaoArr.count) {
            
            int i = 0;
            NSMutableArray *hongbaoMuArr = [NSMutableArray array];
            for (NSDictionary *dic in self.hongbaoArr) {
                if ([[dic objectForKey:@"ProjAmtMax"] floatValue] == 0) {
                    if ([[dic objectForKey:@"ProjAmtMin"] floatValue] <= [textField.text floatValue]) {
                        i ++;
                        [hongbaoMuArr addObject:dic];
                    }
                }else if ([[dic objectForKey:@"ProjAmtMin"] floatValue] <= [textField.text floatValue]&&[[dic objectForKey:@"ProjAmtMax"] floatValue] >= [textField.text floatValue]) {
                    i ++;
                    [hongbaoMuArr addObject:dic];
                }
            }
            
            if (i>0) {
                //可用红包数大于0
                [self.redHongbao removeFromSuperview];
                [self.hongbao setText:@"未使用"];
                [self createBottomRedView:i AndType:@"GetRedPacket"];
            }else{
                [self.hongbao setText:@"无可用"];
                [self.redJiaxi removeFromSuperview];
            }
            
            //在这选
            if (![hongbaoMuArr isKindOfClass:[NSNull class]]) {
                if (hongbaoMuArr.count) {
                    if (hongbaoMuArr.count == 1) {
                        self.dicHongbao = hongbaoMuArr [0];
                    }else{
                        self.dicHongbao = hongbaoMuArr [0];
                        for (i = 0; i<hongbaoMuArr.count; i++) {
                            
                            if ([[self.dicHongbao objectForKey:@"Amt"] floatValue]<[[hongbaoMuArr [i] objectForKey:@"Amt"] floatValue]) {
                                self.dicHongbao = hongbaoMuArr [i];
                            }
                        }
                    }
                }
            }
        }
        
        
        if (self.jiaxiArr.count) {
            int i = 0;
            NSMutableArray *jiaxiMuArr = [NSMutableArray array];
            for (NSDictionary *dic in self.jiaxiArr) {
                
                if ([[dic objectForKey:@"ProjDurationMax"] intValue] == 0) {
                    if ([[dic objectForKey:@"ProjDurationMin"] intValue]<=[self.qixian intValue]) {
                        if ([[dic objectForKey:@"ProjAmtMax"] floatValue] == 0) {
                            if ([[dic objectForKey:@"ProjAmtMin"] floatValue] <= [textField.text floatValue]) {
                                i ++;
                                [jiaxiMuArr addObject:dic];
                            }
                            
                        }else if ([[dic objectForKey:@"ProjAmtMin"] floatValue] <= [textField.text floatValue]&&[[dic objectForKey:@"ProjAmtMax"] floatValue] >= [textField.text floatValue]) {
                            i ++;
                            [jiaxiMuArr addObject:dic];
                        }
                    }
                    
                }else{
                    if ([[dic objectForKey:@"ProjDurationMax"] intValue]>=[self.qixian intValue]&&[[dic objectForKey:@"ProjDurationMin"] intValue]<=[self.qixian intValue]) {
                        
                        if ([[dic objectForKey:@"ProjAmtMax"] floatValue] == 0) {
                            if ([[dic objectForKey:@"ProjAmtMin"] floatValue] <= [textField.text floatValue]) {
                                i ++;
                                [jiaxiMuArr addObject:dic];
                            }
                            
                        }else if ([[dic objectForKey:@"ProjAmtMin"] floatValue] <= [textField.text floatValue]&&[[dic objectForKey:@"ProjAmtMax"] floatValue] >= [textField.text floatValue]) {
                            i ++;
                            [jiaxiMuArr addObject:dic];
                        }
                    }
                }
            }
            if (i>0) {
                //可用加息券数大于0
                [self.redJiaxi removeFromSuperview];
                [self.jiaxi setText:@"未使用"];
                [self createBottomRedView:i AndType:@"GetInterestCoupon"];
                
            }else{
                [self.jiaxi setText:@"无可用"];
                [self.redJiaxi removeFromSuperview];
            }
            
            //在这选
            if (![jiaxiMuArr isKindOfClass:[NSNull class]]) {
                if (jiaxiMuArr.count) {
                    if (jiaxiMuArr.count == 1) {
                        self.dicJiaxi = jiaxiMuArr [0];
                    }else{
                        self.dicJiaxi = jiaxiMuArr [0];
                        for (i = 0; i<jiaxiMuArr.count; i++) {
                            
                            if ([[self.dicJiaxi objectForKey:@"Rate"] floatValue]<[[jiaxiMuArr [i] objectForKey:@"Rate"] floatValue]) {
                                self.dicJiaxi = jiaxiMuArr [i];
                            }
                        }
                    }
                }
            }
        }
        
        /**
         *投资金额改变后 如果推荐最优券还可使用 那么重建
         */
        if (self.dicHongbao && !self.dicJiaxi) {
//            if ([[self.dicHongbao objectForKey:@"ProjAmtMax"] floatValue] == 0) {
//                if ([[self.dicHongbao objectForKey:@"ProjAmtMin"] floatValue] <= [textField.text floatValue]) {
//                    //重建默认红包
                    [self reCreateHongbao];
                    
                    
//                }
//            }else if ([[self.dicHongbao objectForKey:@"ProjAmtMin"] floatValue]
//                      <= [textField.text floatValue]&&[[self.dicHongbao objectForKey:@"ProjAmtMax"] floatValue] >= [textField.text floatValue]) {
//                //重建默认红包
//                [self reCreateHongbao];
//            }
            
        }else if (!self.dicHongbao && self.dicJiaxi){
            
             [self reCreateJiaxi];
//            if ([[self.dicJiaxi objectForKey:@"ProjDurationMax"] intValue] == 0) {
//                if ([[self.dicJiaxi objectForKey:@"ProjDurationMin"] intValue]<=[self.qixian intValue]) {
//                    if ([[self.dicJiaxi objectForKey:@"ProjAmtMax"] floatValue] == 0) {
//                        if ([[self.dicJiaxi objectForKey:@"ProjAmtMin"] floatValue] <= [textField.text floatValue]) {
//                            //重建默认加息券
//                            [self reCreateJiaxi];
//                        }
//                        
//                    }else if ([[self.dicJiaxi objectForKey:@"ProjAmtMin"] floatValue] <= [textField.text floatValue]&&[[self.dicJiaxi objectForKey:@"ProjAmtMax"] floatValue] >= [textField.text floatValue]) {
//                        //重建默认加息券
//                        [self reCreateJiaxi];
//                    }
//                }
//                
//            }else{
//                if ([[self.dicJiaxi objectForKey:@"ProjDurationMax"] intValue]>=[self.qixian intValue]&&[[self.dicJiaxi objectForKey:@"ProjDurationMin"] intValue]<=[self.qixian intValue]) {
//                    if ([[self.dicJiaxi objectForKey:@"ProjAmtMax"] floatValue] == 0) {
//                        if ([[self.dicJiaxi objectForKey:@"ProjAmtMin"] floatValue] <= [textField.text floatValue]) {
//                            //重建默认加息券
//                            [self reCreateJiaxi];
//                        }
//                        
//                    }else if ([[self.dicJiaxi objectForKey:@"ProjAmtMin"] floatValue] <= [textField.text floatValue]&&[[self.dicJiaxi objectForKey:@"ProjAmtMax"] floatValue] >= [textField.text floatValue]) {
//                        //重建默认加息券
//                        [self reCreateJiaxi];
//                        
//                    }
//                }
//            }
            
        }else if (self.dicHongbao && self.dicJiaxi){
            if ([self.model.lilvyou floatValue]>0) {
                //加息
                
                [self reCreateJiaxi];
                
                
//                if ([[self.dicJiaxi objectForKey:@"ProjDurationMax"] intValue] == 0) {
//                    if ([[self.dicJiaxi objectForKey:@"ProjDurationMin"] intValue]<=[self.qixian intValue]) {
//                        if ([[self.dicJiaxi objectForKey:@"ProjAmtMax"] floatValue] == 0) {
//                            if ([[self.dicJiaxi objectForKey:@"ProjAmtMin"] floatValue] <= [textField.text floatValue]) {
//                                //重建默认加息券
//                                [self reCreateJiaxi];
//                            }
//                            
//                        }else if ([[self.dicJiaxi objectForKey:@"ProjAmtMin"] floatValue] <= [textField.text floatValue]&&[[self.dicJiaxi objectForKey:@"ProjAmtMax"] floatValue] >= [textField.text floatValue]) {
//                            //重建默认加息券
//                            [self reCreateJiaxi];
//                        }
//                    }
//                    
//                }else{
//                    if ([[self.dicJiaxi objectForKey:@"ProjDurationMax"] intValue]>=[self.qixian intValue]&&[[self.dicJiaxi objectForKey:@"ProjDurationMin"] intValue]<=[self.qixian intValue]) {
//                        if ([[self.dicJiaxi objectForKey:@"ProjAmtMax"] floatValue] == 0) {
//                            if ([[self.dicJiaxi objectForKey:@"ProjAmtMin"] floatValue] <= [textField.text floatValue]) {
//                                //重建默认加息券
//                                [self reCreateJiaxi];
//                            }
//                            
//                        }else if ([[self.dicJiaxi objectForKey:@"ProjAmtMin"] floatValue] <= [textField.text floatValue]&&[[self.dicJiaxi objectForKey:@"ProjAmtMax"] floatValue] >= [textField.text floatValue]) {
//                            //重建默认加息券
//                            [self reCreateJiaxi];
//                            
//                        }
//                    }
//                }
                
            }else{
                //红包
                
                [self reCreateHongbao];
                
                
//                if ([[self.dicHongbao objectForKey:@"ProjAmtMax"] floatValue] == 0) {
//                    if ([[self.dicHongbao objectForKey:@"ProjAmtMin"] floatValue] <= [textField.text floatValue]) {
//                        //重建默认红包
//                        [self reCreateHongbao];
//                        
//                    }
//                }else if ([[self.dicHongbao objectForKey:@"ProjAmtMin"] floatValue]
//                          <= [textField.text floatValue]&&[[self.dicHongbao objectForKey:@"ProjAmtMax"] floatValue] >= [textField.text floatValue]) {
//                    //重建默认红包
//                    [self reCreateHongbao];
//                }
            }
        }
    }
}

//根据金额变化只重建红色可用标志
-(void)reCreateRedHongbaoAndRedJiaxi{
    
    if (self.jine.text.length == 0) {
        [self.redHongbao removeFromSuperview];
        
        
        if (self.hongbaoArr.count) {
            if ([self.hongbao.text isEqualToString:@"无可用"]) {
                [self.hongbao setText:@"未使用"];
            }
            [self createBottomRedView:self.hongbaoArr.count AndType:@"GetRedPacket"];
            
        }else{
            
            if ([self.hongbao.text isEqualToString:@"未使用"]) {
                [self.hongbao setText:@"无可用"];
            }
        }
        
        
        [self.redJiaxi removeFromSuperview];
        if (self.jiaxiArr.count) {
            if ([self.jiaxi.text isEqualToString:@"无可用"]){
                
                [self.jiaxi setText:@"未使用"];
            }
            
            [self createBottomRedView:self.jiaxiArr.count AndType:@"GetInterestCoupon"];
        }else{
            
            if ([self.jiaxi.text isEqualToString:@"未使用"]) {
                [self.jiaxi setText:@"无可用"];
            }
        }
        return;
    }
    if (self.hongbaoArr.count) {
        
        int i = 0;
        for (NSDictionary *dic in self.hongbaoArr) {
            if ([[dic objectForKey:@"ProjAmtMax"] floatValue] == 0) {
                if ([[dic objectForKey:@"ProjAmtMin"] floatValue] <= [self.jine.text floatValue]) {
                    i ++;
                }
            }else if ([[dic objectForKey:@"ProjAmtMin"] floatValue] <= [self.jine.text floatValue]&&[[dic objectForKey:@"ProjAmtMax"] floatValue] >= [self.jine.text floatValue]) {
                i ++;
            }
        }
        if (i>0) {
            //可用红包数大于0
            [self.redHongbao removeFromSuperview];
            if ([self.hongbao.text isEqualToString:@"无可用"]) {
                [self.hongbao setText:@"未使用"];
            }
            [self createBottomRedView:i AndType:@"GetRedPacket"];
        }else{
            
            [self.redHongbao removeFromSuperview];
            [self.hongbao setText:@"无可用"];
        }
    }
    
    
    if (self.jiaxiArr.count) {
        int i = 0;
        for (NSDictionary *dic in self.jiaxiArr) {
            
            if ([[dic objectForKey:@"ProjDurationMax"] intValue] == 0) {
                if ([[dic objectForKey:@"ProjDurationMin"] intValue]<=[self.qixian intValue]) {
                    if ([[dic objectForKey:@"ProjAmtMax"] floatValue] == 0) {
                        if ([[dic objectForKey:@"ProjAmtMin"] floatValue] <= [self.jine.text floatValue]) {
                            i ++;
                        }
                        
                    }else if ([[dic objectForKey:@"ProjAmtMin"] floatValue] <= [self.jine.text floatValue]&&[[dic objectForKey:@"ProjAmtMax"] floatValue] >= [self.jine.text floatValue]) {
                        i ++;
                    }
                }
                
            }else{
                if ([[dic objectForKey:@"ProjDurationMax"] intValue]>=[self.qixian intValue]&&[[dic objectForKey:@"ProjDurationMin"] intValue]<=[self.qixian intValue]) {
                    
                    if ([[dic objectForKey:@"ProjAmtMax"] floatValue] == 0) {
                        if ([[dic objectForKey:@"ProjAmtMin"] floatValue] <= [self.jine.text floatValue]) {
                            i ++;
                        }
                        
                    }else if ([[dic objectForKey:@"ProjAmtMin"] floatValue] <= [self.jine.text floatValue]&&[[dic objectForKey:@"ProjAmtMax"] floatValue] >= [self.jine.text floatValue]) {
                        i ++;
                    }
                }
            }
        }
        if (i>0) {
            //可用加息券数大于0
            [self.redJiaxi removeFromSuperview];
            if ([self.redJiaxi.text isEqualToString:@"无可用"]) {
                [self.redJiaxi setText:@"未使用"];
            }
            [self createBottomRedView:i AndType:@"GetInterestCoupon"];
            
        }else{
            
            [self.redJiaxi removeFromSuperview];
            [self.redJiaxi setText:@"无可用"];
        }
    }
}

-(void)reCreateHongbao{
    
    [self.shijijine setText:[NSString stringWithFormat:@"%.2f",[self.jine.text floatValue]-[[self.dicHongbao objectForKey:@"Amt"] floatValue]]];
    self.hongbao.textColor = [HXColor colorWithHexString:@"#ff5254"];
    [self.hongbao setText:[NSString stringWithFormat:@"-%.2f",[[self.dicHongbao objectForKey:@"Amt"] floatValue]]];
    self.RedPacket = [NSString stringWithFormat:@"%@",[self.dicHongbao objectForKey:@"Id"]];
    
    XZRedEnvelopeModel *model = [[XZRedEnvelopeModel alloc]init];
    model.Id = [self.dicHongbao objectForKey:@"Id"];
    model.ProjAmtMax = [self.dicHongbao objectForKey:@"ProjAmtMax"];
    model.ProjAmtMin = [self.dicHongbao objectForKey:@"ProjAmtMin"];
    model.ProjDurationMax = [self.dicHongbao objectForKey:@"ProjDurationMax"];
    model.ProjDurationMin = [self.dicHongbao objectForKey:@"ProjDurationMin"];
    model.Amt = [self.dicHongbao objectForKey:@"Amt"];
    self.hongBaoModel = model;
    
}

-(void)reCreateJiaxi{
    
    [self.shijijine setText:[NSString stringWithFormat:@"%.2f",[self.jine.text floatValue]]];
    self.jiaxi.textColor = [HXColor colorWithHexString:@"#ff5254"];
    [self.jiaxi setText:[NSString stringWithFormat:@"+%.1f%%",[[self.dicJiaxi objectForKey:@"Rate"] floatValue]*100]];
    if ([self.lilvyou floatValue]>0) {
        if ([[self.dicJiaxi objectForKey:@"Rate"] floatValue]*100>[self.lilvyou floatValue]) {
            [self.jiaxi setText:[NSString stringWithFormat:@"+%.1f%%",[self.lilvyou floatValue]]];
        }
    }
    
    XZRedEnvelopeModel *model = [[XZRedEnvelopeModel alloc]init];
    model.Id = [self.dicJiaxi objectForKey:@"Id"];
    model.ProjAmtMax = [self.dicJiaxi objectForKey:@"ProjAmtMax"];
    model.ProjAmtMin = [self.dicJiaxi objectForKey:@"ProjAmtMin"];
    model.ProjDurationMax = [self.dicJiaxi objectForKey:@"ProjDurationMax"];
    model.ProjDurationMin = [self.dicJiaxi objectForKey:@"ProjDurationMin"];
    model.Amt = [self.dicJiaxi objectForKey:@"Amt"];
    self.JiaXimodel = model;
    
    self.InterestCoupon = [NSString stringWithFormat:@"%@",[self.dicJiaxi objectForKey:@"Id"]];
}

//干掉红包
-(void)gandiaoHongbao{
    
    [self.hongbao setTextColor:[HXColor colorWithHexString:@"#333"]];
    self.RedPacket = @"";
    [self.redHongbao removeFromSuperview];
    self.shijijine.text = [NSString stringWithFormat:@"%.2f",[self.jine.text floatValue]];
    if (self.jine.text.length == 0) {//输入框为空时恢复到初始状态
        if (self.hongbaoArr.count) {
            [self.hongbao setText:@"未使用"];
            
            [self createBottomRedView:self.hongbaoArr.count AndType:@"GetRedPacket"];
        }else{
            [self.hongbao setText:@"无可用"];
        }
        return;
    }
    if (self.hongbaoArr.count) {
        
        int i = 0;
        for (NSDictionary *dic in self.hongbaoArr) {
            if ([[dic objectForKey:@"ProjAmtMax"] floatValue] == 0) {
                if ([[dic objectForKey:@"ProjAmtMin"] floatValue] <= [self.jine.text floatValue]) {
                    i ++;
                }
            }else if ([[dic objectForKey:@"ProjAmtMin"] floatValue] <= [self.jine.text floatValue]&&[[dic objectForKey:@"ProjAmtMax"] floatValue] >= [self.jine.text floatValue]) {
                i ++;
            }
        }
        if (i>0) {
            //可用红包数大于0
            [self.redHongbao removeFromSuperview];
            [self.hongbao setText:@"未使用"];
            [self createBottomRedView:i AndType:@"GetRedPacket"];
        }else{
            [self.hongbao setText:@"无可用"];
        }
    }
}

-(void)gandiaoJiaxi{
    
    [self.jiaxi setTextColor:[HXColor colorWithHexString:@"#333"]];
    self.InterestCoupon = @"";
    [self.redJiaxi removeFromSuperview];
    if (self.jine.text.length == 0) {//输入框为空时恢复到初始状态
        if (self.jiaxiArr.count) {
            [self.jiaxi setText:@"未使用"];
            [self createBottomRedView:self.jiaxiArr.count AndType:@"GetInterestCoupon"];
        }else{
            [self.jiaxi setText:@"无可用"];
        }
        
        return;
    }
    if (self.jiaxiArr.count) {
        int i = 0;
        for (NSDictionary *dic in self.jiaxiArr) {
            
            if ([[dic objectForKey:@"ProjDurationMax"] intValue] == 0) {
                if ([[dic objectForKey:@"ProjDurationMin"] intValue]<=[self.qixian intValue]) {
                    if ([[dic objectForKey:@"ProjAmtMax"] floatValue] == 0) {
                        if ([[dic objectForKey:@"ProjAmtMin"] floatValue] <= [self.jine.text floatValue]) {
                            i ++;
                        }
                        
                    }else if ([[dic objectForKey:@"ProjAmtMin"] floatValue] <= [self.jine.text floatValue]&&[[dic objectForKey:@"ProjAmtMax"] floatValue] >= [self.jine.text floatValue]) {
                        i ++;
                    }
                }
            }else{
                if ([[dic objectForKey:@"ProjDurationMax"] intValue]>=[self.qixian intValue]&&[[dic objectForKey:@"ProjDurationMin"] intValue]<=[self.qixian intValue]) {
                    
                    if ([[dic objectForKey:@"ProjAmtMax"] floatValue] == 0) {
                        if ([[dic objectForKey:@"ProjAmtMin"] floatValue] <= [self.jine.text floatValue]) {
                            i ++;
                        }
                        
                    }else if ([[dic objectForKey:@"ProjAmtMin"] floatValue] <= [self.jine.text floatValue]&&[[dic objectForKey:@"ProjAmtMax"] floatValue] >= [self.jine.text floatValue]) {
                        i ++;
                    }
                }
            }
        }
        if (i>0) {
            //可用加息券数大于0
            [self.redJiaxi removeFromSuperview];
            [self.jiaxi setText:@"未使用"];
            [self createBottomRedView:i AndType:@"GetInterestCoupon"];
            
        }else{
            [self.jiaxi setText:@"无可用"];
        }
    }
}


#pragma mark ---- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.jine resignFirstResponder];
}

@end
