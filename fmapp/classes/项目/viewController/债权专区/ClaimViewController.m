//
//  ClaimViewController.m
//  fmapp
//
//  Created by apple on 15/3/26.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "ClaimViewController.h"
#import "HTTPClient+Interaction.h"
#import "ProjectModel.h"
#import "MoreProjectController.h"
#import "ShareViewController.h"

@interface ClaimViewController ()
@property (nonatomic,copy) NSString                *projectId;
@property (nonatomic,weak) UIScrollView            *scrollMainView;
@property (nonatomic,strong)ProjectModel           *model;
//@property (nonatomic,strong)AFHTTPRequestOperation      *requestOperation;

@property (nonatomic,weak)UILabel                  *guoqiLabel;
@end

@implementation ClaimViewController

- (void)loadView{
    self.view = [[UIView alloc] initWithFrame:HUIApplicationFrame()];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = KDefaultOrNightScrollViewColor;
}

- (id)initWithProjectId:(NSString *)projectId
{
    self=[super init];
    if (self) {
        self.projectId=projectId;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self settingNavTitle:@"债权详情"];
    [self getProjectDetailData];


}

- (void)guoqiTime
{
//    NSDate *date=[NSDate date];
//    NSTimeInterval now=[date timeIntervalSince1970];
//    int cha=self.model.guoqi_time-now;
//    Log(@"%d-%d=%d",self.model.guoqi_time,now,cha);
//    cha=4000;
    [self intervalSinceNow:self.model.guoqi_time];
    
}
//返回设定时间与当前时间的差
//- (NSString *)intervalSinceNow: (NSString *) theDate
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
                self.guoqiLabel.text=[NSString stringWithFormat:@"%d天%d时%d分%d秒",timedays,timehours,timeminutes,timeseconds];
            });
        }else{
            //            int minutes = timeout / 60;
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
            //NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
            self.guoqiLabel.text=[NSString stringWithFormat:@"%d天%d时%d分%d秒",timedays,timehours,timeminutes,seconds];
                
            });
            timeseconds--;
        }
    });
    dispatch_resume(_timer);
}

- (void)createMainView
{
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [mainScrollView setBackgroundColor: [UIColor clearColor]];
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.contentSize = CGSizeMake(self.view.bounds.size.width,self.view.bounds.size.height +280.0f);
    self.scrollMainView=mainScrollView;
    [self.view addSubview:mainScrollView];
    
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 232)];
    topView.backgroundColor=[UIColor whiteColor];
    [self.scrollMainView addSubview:topView];
    
        UILabel *moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 25, KProjectScreenWidth, 15)];
        moneyLabel.textAlignment=NSTextAlignmentCenter;
        moneyLabel.backgroundColor=[UIColor clearColor];
        moneyLabel.text=@"可认购份额(元)";
        moneyLabel.font=[UIFont systemFontOfSize:14.0f];
        moneyLabel.textColor=KContentTextColor;
        [topView addSubview:moneyLabel];
        
        UILabel *moneyContentLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 45, KProjectScreenWidth, 30)];
        moneyContentLabel.textAlignment=NSTextAlignmentCenter;
        moneyContentLabel.backgroundColor=[UIColor clearColor];
        moneyContentLabel.text=[NSString stringWithFormat:@"%@",self.model.kegoujine];
        moneyContentLabel.font=[UIFont boldSystemFontOfSize:22.0f];
        moneyContentLabel.textColor=KContentTextColor;
        [topView addSubview:moneyContentLabel];
        
        UILabel *peopleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 82, KProjectScreenWidth, 15)];
        peopleLabel.textAlignment=NSTextAlignmentCenter;
        peopleLabel.backgroundColor=[UIColor clearColor];
        peopleLabel.text=@"过期时间";
        peopleLabel.font=[UIFont systemFontOfSize:14.0f];
        peopleLabel.textColor=KContentTextColor;
        [topView addSubview:peopleLabel];
        
        UILabel *peopleContentLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 102, KProjectScreenWidth, 30)];
        peopleContentLabel.textAlignment=NSTextAlignmentCenter;
        peopleContentLabel.backgroundColor=[UIColor clearColor];
//        peopleContentLabel.text=[NSString stringWithFormat:@"%@",@"62"];
        peopleContentLabel.font=[UIFont boldSystemFontOfSize:22.0f];
        peopleContentLabel.textColor=[UIColor colorWithRed:0.93 green:0.29 blue:0.17 alpha:1];
        self.guoqiLabel=peopleContentLabel;
        [topView addSubview:peopleContentLabel];
        
        NSArray *titleArr=[[NSArray alloc]initWithObjects:@"认购后收益",@"剩余期限", nil];
        NSArray *contentArr=[[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"%@%%",self.model.lilv],[NSString stringWithFormat:@"%@天",self.model.qixian],nil];
//        NSLog(@"%@",contentArr);
        NSArray *cArr=[NSArray arrayWithObjects:self.model.lilv,self.model.qixian, nil];
        for(int i=0;i<2;i++)
        {
            CGFloat width=(CGFloat)KProjectScreenWidth/2;
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(width*i, 138, width, 15)];
            label.text=titleArr[i];
            label.textColor=KContentTextColor;
            label.textAlignment=NSTextAlignmentCenter;
            label.backgroundColor=[UIColor clearColor];
            label.font=[UIFont systemFontOfSize:14];
            [topView addSubview:label];
            
            UILabel *contentlabel=[[UILabel alloc]initWithFrame:CGRectMake(width*i, 165, width, 20)];
            contentlabel.textColor=KContentTextColor;
            if (i==0) {
                contentlabel.textColor=[UIColor colorWithRed:0.93 green:0.29 blue:0.17 alpha:1];
            }
            contentlabel.font=[UIFont boldSystemFontOfSize:12];
            contentlabel.textAlignment=NSTextAlignmentCenter;
            contentlabel.backgroundColor=[UIColor clearColor];
            [topView addSubview:contentlabel];
            
            NSString *content=contentArr[i];
            NSRange range=[content rangeOfString:cArr[i]];
            NSMutableAttributedString *attriContent=[[NSMutableAttributedString alloc]initWithString:content];
            [attriContent addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:25.0f] range:range];
            contentlabel.attributedText=attriContent;
            
        }
        
    
        NSArray *imageArr=[NSArray arrayWithObjects:@"project.png",@"project.png", nil];
        NSArray *titleContentArr=[NSArray arrayWithObjects:@"灵活转让",@"本息保障", nil];
        
        CGFloat bottomWidth=(KProjectScreenWidth-160)/2.0f;
        for(int i=0;i<2;i++)
        {
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(80+bottomWidth*i+15, 205, bottomWidth-15, 15)];
            label.text=titleContentArr[i];
            label.textColor=KContentTextColor;
            label.backgroundColor=[UIColor clearColor];
            label.font=[UIFont systemFontOfSize:12];
            [topView addSubview:label];
            
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(80+bottomWidth*i, 207, 12, 12)];
            imageView.image=[UIImage imageNamed:imageArr[i]];
            [topView addSubview:imageView];
            
        }

    [self createMidView];
}
- (void)createMidView
{
    NSArray *titleArr;
    if ([self.projectId floatValue]>= 1025) {
         titleArr=[NSArray arrayWithObjects:@"转让项目",@"项目类型",@"回购承诺",@"还款方式",@"转让份额",@"原债权人",@"原年化收益",@"还款日期",@"下次付息日期", nil];
    }else
    {
        titleArr=[NSArray arrayWithObjects:@"转让项目",@"项目类型",@"担保机构",@"还款方式",@"转让份额",@"原债权人",@"原年化收益",@"还款日期",@"下次付息日期", nil];
    }
       NSArray *contentArr=[NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",self.model.title],[NSString stringWithFormat:@"%@",self.model.rongzifangshi],[NSString stringWithFormat:@"%@",self.model.danbaocompany],[NSString stringWithFormat:@"%@",self.model.huankuanfangshi],[NSString stringWithFormat:@"%@",self.model.projectMoney],[NSString stringWithFormat:@"%@",self.model.yuanzhaiid],[NSString stringWithFormat:@"%@",self.model.lilv],[NSString stringWithFormat:@"%@",self.model.huankuanrq],[NSString stringWithFormat:@"%@",self.model.xiacriqi], nil];
    
    UIView *midView=[[UIView alloc]initWithFrame:CGRectMake(0, 222+15, KProjectScreenWidth, 47*8)];
    midView.frame=CGRectMake(0, 232+15, KProjectScreenWidth, 47*11);
    midView.backgroundColor=[UIColor whiteColor];
    [self.scrollMainView addSubview:midView];
    
    for(int i=0;i<9;i++)
    {
        
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 47*i+8.5f, 120, 60)];
        titleLable.font = [UIFont systemFontOfSize:16.0f];
        [titleLable setTextColor:KSubTitleContentTextColor];
        [titleLable setTextAlignment:NSTextAlignmentLeft];
        [titleLable setBackgroundColor:[UIColor clearColor]];
        titleLable.text=titleArr[i];
        
        [midView addSubview:titleLable];
        
        NSString *content=contentArr[i];
        
        UILabel *contentLable = [[UILabel alloc] init];
        contentLable.font = [UIFont systemFontOfSize:17.0f];
        CGSize size=[content sizeWithFont:contentLable.font];
        contentLable.frame=CGRectMake(KProjectScreenWidth-10-size.width, 47*i+8.5f, size.width, 30);
        [contentLable setTextColor:KContentTextColor];
        [contentLable setBackgroundColor:[UIColor clearColor]];
        contentLable.text=contentArr[i];
        [midView addSubview:contentLable];
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 47*(i+1)-0.5f, KProjectScreenWidth, 0.5f)];
        lineView.backgroundColor=KSepLineColorSetup;
        [midView addSubview:lineView];
    }
    
    //    if (self.projectStyle==ProjectInprogressOperationStyle) {
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:createImageWithColor([UIColor whiteColor]) forState:UIControlStateNormal];
    [button setTitle:@"查看详情" forState:UIControlStateNormal];
    [button setTitleColor:KSubTitleContentTextColor forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:14.0f];
    [button setFrame:CGRectMake(20, 47*9+7, KProjectScreenWidth-40, 43)];
    [button addTarget:self action:@selector(moreDetailBtnClick) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font=[UIFont boldSystemFontOfSize:16.0f];
    [button.layer setCornerRadius:5.0f];
    [button.layer setBorderWidth:0.5f];
    [button.layer setBorderColor:KSepLineColorSetup.CGColor];
    [midView addSubview:button];
    //    }
    
    
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, KProjectScreenHeight-47-64, KProjectScreenWidth, 47)];
    bottomView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:0.93 green:0.31 blue:0.18 alpha:1])
                            forState:UIControlStateNormal];
    [bottomButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:0.93 green:0.31 blue:0.18 alpha:1])
                            forState:UIControlStateHighlighted];
    [bottomButton setTitle:@"立即认购"
                  forState:UIControlStateNormal];
    bottomButton.titleLabel.font=[UIFont boldSystemFontOfSize:16.0f];
    [bottomButton setTitleColor:[UIColor whiteColor]
                       forState:UIControlStateNormal];
    [bottomButton setFrame:CGRectMake(20.0f, 2, KProjectScreenWidth-40, 43.0f)];
    [bottomButton.layer setBorderWidth:0.5f];
    [bottomButton.layer setCornerRadius:5.0f];
    [bottomButton.layer setMasksToBounds:YES];
    [bottomButton setBackgroundColor:KDefaultOrNightBackGroundColor];
    [bottomButton.layer setBorderColor:[KDefaultOrNightSepratorColor CGColor]];
    [bottomButton addTarget:self action:@selector(bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:bottomButton];
    
    [self guoqiTime];
    
}
- (void)moreDetailBtnClick
{
    MoreProjectController *viewController=[[MoreProjectController alloc]initWithProjectModel:self.model];
    viewController.projectStyle=2;
    [self.navigationController pushViewController:viewController animated:YES];

}
- (void)bottomBtnClick
{
    ShareViewController *viewController=[[ShareViewController alloc]initWithTitle:@"立即投资" AndWithShareUrl:[NSString stringWithFormat:@"%@%@?jie_id=%@&user_id=%@",kBaseAPIURL,@"Lend/toubiaozq",self.projectId,[CurrentUserInformation sharedCurrentUserInfo].userId]];
    [self.navigationController pushViewController:viewController animated:YES];

}

- (void)getProjectDetailData
{
    [FMHTTPClient getClaimId:self.projectId completion:^(WebAPIResponse *response) {
        
        Log(@"%@",response.responseObject);
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (response.code==WebAPIResponseCodeSuccess) {
                
                NSDictionary *dic=(NSDictionary *)ObjForKeyInUnserializedJSONDic(response.responseObject, kDataKeyData);
                self.model=[ProjectModel modelForClaimDetailWithUnserializedJSONDic:dic];
                
                [self createMainView];

            }
            else
            {
                ShowAutoHideMBProgressHUD(HUIKeyWindow,NETERROR_LOADERR_TIP);
            }
            
        });
    }];
}


@end
