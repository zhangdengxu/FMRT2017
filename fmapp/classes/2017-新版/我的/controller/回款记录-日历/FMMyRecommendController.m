//
//  FMMyRecommendController.m
//  fmapp
//
//  Created by runzhiqiu on 2017/2/21.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMMyRecommendController.h"
#import "XZRecommandQRCodeController.h"
#import "XZActivityModel.h"
#import "FMMyRecommentCalendarViewController.h"  //我的推荐界面
#import "YYPermissionSettingController.h"  //推荐权限设置
#import "XZTotalReceivedCommissionController.h" // 好友贡献佣金/累计已收佣金
#import "XZMonthTotalCommissionController.h" // 本月累计佣金
#import "WLKeHuViewController.h"//推荐客户
#import "WLFriendsForgiveViewController.h"//好友贡献资产

@interface FMMyRecommendController ()

@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) UILabel * middleMAXDetail;
@property (nonatomic, strong) UILabel * leftNumberDetail;
@property (nonatomic, strong) UILabel * rightNumberDetail;


@property (nonatomic, strong) UILabel * recommendAllPrice;
@property (nonatomic, strong) UILabel * recommendAllPerson;
@property (nonatomic, strong) UILabel * friendALLMoney;
@property (nonatomic, strong) UILabel * friendAllget;
@property (nonatomic, strong) FMMyRecommendModel * recommendModel;

@end

@implementation FMMyRecommendController
-(UILabel *)recommendAllPrice
{
    if (!_recommendAllPrice) {
        _recommendAllPrice = [[UILabel alloc]init];
    }
    return _recommendAllPrice;
}
-(UILabel *)recommendAllPerson
{
    if (!_recommendAllPerson) {
        _recommendAllPerson = [[UILabel alloc]init];
    }
    return _recommendAllPerson;
}
-(UILabel *)friendALLMoney
{
    if (!_friendALLMoney) {
        _friendALLMoney = [[UILabel alloc]init];
    }
    return _friendALLMoney;
}
-(UILabel *)friendAllget
{
    if (!_friendAllget) {
        _friendAllget = [[UILabel alloc]init];
    }
    return _friendAllget;
}
-(UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc]init];
    }
    return _headerView;
}

-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        [_scrollView setBackgroundColor: [UIColor colorWithRed:230/255.0f green:235/255.f blue:240/255.0f alpha:1]];
        _scrollView.showsVerticalScrollIndicator = NO;
        
        
        [self.view addSubview:_scrollView];
        
    }
    return _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self settingNavTitle:@"我的推荐"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self getHtml];
    
}

-(void)createUIScrollViewHeaderView
{
    //创建头部
    [self.scrollView addSubview:self.headerView];
    if (KProjectScreenHeight < 570) {
        self.scrollView.contentSize = CGSizeMake(KProjectScreenWidth, 600);
    }
    [self.headerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left);
        make.top.equalTo(self.scrollView.mas_top);
        make.width.equalTo(self.view.mas_width);
        //make.height.equalTo(self.headerView.mas_width).multipliedBy(0.45);
        make.height.equalTo(@170);
    }];
    self.headerView.backgroundColor = [UIColor redColor];
    
    //创建背景
    UIImageView * imageViewHeaderBG = [[UIImageView alloc]init];
    imageViewHeaderBG.image = [UIImage imageNamed:@"我的推荐_首页-top背景_1702"];
    [self.headerView addSubview:imageViewHeaderBG];
    [imageViewHeaderBG makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.mas_left);
        make.top.equalTo(self.headerView.mas_top);
        make.right.equalTo(self.headerView.mas_right);
        make.bottom.equalTo(self.headerView.mas_bottom);

    }];
    

    //创建今日佣金结算（元）
    UILabel * middleDetail = [[UILabel alloc]init];
    middleDetail.textAlignment = NSTextAlignmentCenter;
    middleDetail.textColor = [UIColor whiteColor];
    middleDetail.text = @"今日佣金结算（元）";
    middleDetail.font = [UIFont systemFontOfSize:18];
    [self.headerView addSubview:middleDetail];
    
    [middleDetail makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.mas_left);
        make.top.equalTo(self.headerView.mas_top).offset(15);
        make.right.equalTo(self.headerView.mas_right);
    }];
    
    //创建中间大数字
    UILabel * middleMAXDetail = [[UILabel alloc]init];
    middleMAXDetail.textAlignment = NSTextAlignmentCenter;
    middleMAXDetail.textColor = [UIColor whiteColor];
    middleMAXDetail.text = @"0";
    middleMAXDetail.font = [UIFont systemFontOfSize:40];
    [self.headerView addSubview:middleMAXDetail];
    self.middleMAXDetail = middleMAXDetail;
    [middleMAXDetail makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.mas_left);
        make.top.equalTo(middleDetail.mas_bottom).offset(15);
        make.right.equalTo(self.headerView.mas_right);
    }];

    UIButton * rightTopCalenderButton = [[UIButton alloc]init];
    [rightTopCalenderButton setBackgroundImage:[UIImage imageNamed:@"我的推荐_推荐首页-日历icon_1702"] forState:UIControlStateNormal];
    [rightTopCalenderButton setBackgroundColor:[UIColor clearColor]];
    [rightTopCalenderButton addTarget:self action:@selector(rightTopCalenderButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:rightTopCalenderButton];
    [rightTopCalenderButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headerView.mas_right).offset(-10);
        make.top.equalTo(middleDetail.mas_top);
    }];

    
    
    UIView * lineWhiteView = [[UIView alloc]init];
    lineWhiteView.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:lineWhiteView];
    [lineWhiteView makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(middleMAXDetail.mas_bottom).offset(15);
        make.bottom.equalTo(self.headerView.mas_bottom).offset(-8);
        make.width.equalTo(@0.5);
        make.centerX.equalTo(self.headerView.mas_centerX);
    }];
    
    
    //创建左下角数字
    UILabel * leftNumberDetail = [[UILabel alloc]init];
    leftNumberDetail.textAlignment = NSTextAlignmentCenter;
    leftNumberDetail.textColor = [UIColor whiteColor];
    leftNumberDetail.text = @"0";
    leftNumberDetail.font = [UIFont systemFontOfSize:20];
    [self.headerView addSubview:leftNumberDetail];
    self.leftNumberDetail = leftNumberDetail;
    [leftNumberDetail makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.mas_left);
        make.top.equalTo(lineWhiteView.mas_top);
        make.right.equalTo(lineWhiteView.mas_left).offset(-5);
    }];
    
    //创建左下角文字说明
    UILabel * leftNumberDetailText = [[UILabel alloc]init];
    leftNumberDetailText.textAlignment = NSTextAlignmentCenter;
    leftNumberDetailText.textColor = [UIColor whiteColor];
    leftNumberDetailText.text = @"本月累计佣金";
    leftNumberDetailText.font = [UIFont systemFontOfSize:15];
    [self.headerView addSubview:leftNumberDetailText];
    [leftNumberDetailText makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftNumberDetail.mas_bottom).offset(8);
        make.centerX.equalTo(leftNumberDetail.mas_centerX);
    }];
    
    
    //创建左下角向右箭头
    UIImageView * rightImageView1 = [[UIImageView alloc]init];
    rightImageView1.image = [UIImage imageNamed:@"我的推荐_白色向右--icon_1702"];
    [self.headerView addSubview:rightImageView1];
    [rightImageView1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftNumberDetailText.mas_right).offset(3);
        make.centerY.equalTo(leftNumberDetailText.mas_centerY);
        
    }];
    
    //添加左下角区域的点击事件
    UIButton * rightImageViewButton1 = [[UIButton alloc]init];
    [rightImageViewButton1 setBackgroundColor:[UIColor clearColor]];
    rightImageViewButton1.tag = 1001;
    [rightImageViewButton1 addTarget:self action:@selector(rightImageViewButtonButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:rightImageViewButton1];
    [rightImageViewButton1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftNumberDetail.mas_left);
        make.top.equalTo(leftNumberDetail.mas_top);
        make.right.equalTo(leftNumberDetail.mas_right);
        make.bottom.equalTo(leftNumberDetailText.mas_bottom);
    }];
    

    
    
    //创建右下角的文字
    UILabel * rightNumberDetail = [[UILabel alloc]init];
    rightNumberDetail.textAlignment = NSTextAlignmentCenter;
    rightNumberDetail.textColor = [UIColor whiteColor];
    rightNumberDetail.text = @"100452.00";
    rightNumberDetail.font = [UIFont systemFontOfSize:20];
    [self.headerView addSubview:rightNumberDetail];
    self.rightNumberDetail = rightNumberDetail;
    [rightNumberDetail makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineWhiteView.mas_right);
        make.top.equalTo(lineWhiteView.mas_top);
        make.right.equalTo(self.headerView.mas_right).offset(-5);
    }];
    
    
    //创建右下角文字说明
    UILabel * rightNumberDetailText = [[UILabel alloc]init];
    rightNumberDetailText.textAlignment = NSTextAlignmentCenter;
    rightNumberDetailText.textColor = [UIColor whiteColor];
    rightNumberDetailText.text = @"累计已收佣金";
    rightNumberDetailText.font = [UIFont systemFontOfSize:15];
    [self.headerView addSubview:rightNumberDetailText];
    [rightNumberDetailText makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rightNumberDetail.mas_bottom).offset(8);
        make.centerX.equalTo(rightNumberDetail.mas_centerX);
    }];
    
    
    //创建左下角向右箭头
    UIImageView * rightImageView2 = [[UIImageView alloc]init];
    rightImageView2.image = [UIImage imageNamed:@"我的推荐_白色向右--icon_1702"];
    [self.headerView addSubview:rightImageView2];
    [rightImageView2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rightNumberDetailText.mas_right).offset(3);
        make.centerY.equalTo(rightNumberDetailText.mas_centerY);
        
    }];
    
    //添加左下角区域的点击事件
    UIButton * rightImageViewButton2 = [[UIButton alloc]init];
    [rightImageViewButton2 setBackgroundColor:[UIColor clearColor]];
    rightImageViewButton2.tag = 1002;
    [rightImageViewButton2 addTarget:self action:@selector(rightImageViewButtonButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:rightImageViewButton2];
    [rightImageViewButton2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rightNumberDetail.mas_left);
        make.top.equalTo(rightNumberDetail.mas_top);
        make.right.equalTo(rightNumberDetail.mas_right);
        make.bottom.equalTo(rightNumberDetailText.mas_bottom);
    }];
    
}

-(void)createMiddleButtonFirst
{
    CGFloat middleHeigh = 100;
    CGFloat bottomHeigh = 60;
    if (KProjectScreenWidth == 320) {
        middleHeigh = 70;
        bottomHeigh = 45;
    }else
    {
        middleHeigh = 100;
        bottomHeigh = 60;

    }
    UIView * currentView;
    //级别为2是 这俩参数没传
    if ([self.recommendModel.jibie integerValue] == 2) {
        UIView * firstView = [self retWhiteViewWithTitle:@"推荐资产" WithNumber:@"345.67万元" WithNumberView:self.recommendAllPrice Withtag:1003 withShowRightIcon:NO];
        UIView * secondView = [self retWhiteViewWithTitle:@"推荐客户" WithNumber:@"345.67万元" WithNumberView:self.recommendAllPerson Withtag:1004 withShowRightIcon:YES];
        
        [self.scrollView addSubview:firstView];
        [self.scrollView addSubview:secondView];
        
        
        [firstView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView.mas_left);
            make.top.equalTo(self.headerView.mas_bottom).offset(5);
            make.width.equalTo(self.scrollView.mas_width).multipliedBy(0.5);
            make.height.equalTo(middleHeigh);
        }];
        [secondView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(firstView.mas_right).offset(0.5);
            make.top.equalTo(self.headerView.mas_bottom).offset(5);
            make.width.equalTo(self.scrollView.mas_width).multipliedBy(0.5);
            make.height.equalTo(middleHeigh);
        }];
        currentView = firstView;

    }else
    {
        UIView * firstView = [self retWhiteViewWithTitle:@"推荐资产" WithNumber:@"345.67万元" WithNumberView:self.recommendAllPrice Withtag:1003 withShowRightIcon:NO];
        UIView * secondView = [self retWhiteViewWithTitle:@"推荐客户" WithNumber:@"345.67万元" WithNumberView:self.recommendAllPerson Withtag:1004 withShowRightIcon:YES];
        UIView * thirdView = [self retWhiteViewWithTitle:@"好友贡献资产" WithNumber:@"345.67万元" WithNumberView:self.friendALLMoney Withtag:1005 withShowRightIcon:YES];
        UIView * fourView = [self retWhiteViewWithTitle:@"好友贡献佣金" WithNumber:@"345.67万元" WithNumberView:self.friendAllget Withtag:1006 withShowRightIcon:YES];
        
        [self.scrollView addSubview:firstView];
        [self.scrollView addSubview:secondView];
        [self.scrollView addSubview:thirdView];
        [self.scrollView addSubview:fourView];
        
        
        
        
        [firstView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView.mas_left);
            make.top.equalTo(self.headerView.mas_bottom).offset(5);
            make.width.equalTo(self.scrollView.mas_width).multipliedBy(0.5);
            make.height.equalTo(middleHeigh);
        }];
        [secondView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(firstView.mas_right).offset(0.5);
            make.top.equalTo(self.headerView.mas_bottom).offset(5);
            make.width.equalTo(self.scrollView.mas_width).multipliedBy(0.5);
            make.height.equalTo(middleHeigh);
        }];
        [thirdView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView.mas_left);
            make.top.equalTo(firstView.mas_bottom).offset(0.5);
            make.width.equalTo(self.scrollView.mas_width).multipliedBy(0.5);
            make.height.equalTo(middleHeigh);
        }];
        [fourView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(thirdView.mas_right).offset(0.5);
            make.top.equalTo(secondView.mas_bottom).offset(0.5);
            make.width.equalTo(self.scrollView.mas_width).multipliedBy(0.5);
            make.height.equalTo(middleHeigh);
        }];
        
        currentView = thirdView;
    }
    if ([self.recommendModel.jibie integerValue] == 2) {
       
        //我的二维码
        UIView * secondViewRectangle = [self retWhiteRectangleViewWithTitle:@"我的二维码" Withtag:1008 withShowRightIcon:@"我的推荐_二维码icon_1702"];
        
        [self.scrollView addSubview:secondViewRectangle];
        
       
        [secondViewRectangle makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView.mas_left);
            make.top.equalTo(currentView.mas_bottom).offset(5);
            make.width.equalTo(self.scrollView.mas_width);
            make.height.equalTo(bottomHeigh);
        }];

    }else
    {
        //设置推荐权限
        UIView * firstViewRectangle = [self retWhiteRectangleViewWithTitle:@"设置推荐权限" Withtag:1007 withShowRightIcon:@"我的推荐_首页-设置icon_1702"];
        //我的二维码
        UIView * secondViewRectangle = [self retWhiteRectangleViewWithTitle:@"我的二维码" Withtag:1008 withShowRightIcon:@"我的推荐_二维码icon_1702"];
        
        [self.scrollView addSubview:firstViewRectangle];
        [self.scrollView addSubview:secondViewRectangle];
        
        [firstViewRectangle makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView.mas_left);
            make.top.equalTo(currentView.mas_bottom).offset(5);
            make.width.equalTo(self.scrollView.mas_width);
            make.height.equalTo(bottomHeigh);
        }];
        [secondViewRectangle makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView.mas_left);
            make.top.equalTo(firstViewRectangle.mas_bottom).offset(0.5);
            make.width.equalTo(self.scrollView.mas_width);
            make.height.equalTo(bottomHeigh);
        }];

    }
    
}

-(UIView *)retWhiteViewWithTitle:(NSString *)title WithNumber:(NSString *)numberString WithNumberView:(UILabel *)numberView Withtag:(NSInteger)tag withShowRightIcon:(BOOL)isShowRight
{
    UIView * whiteBackGround = [[UIView alloc]init];
    whiteBackGround.backgroundColor = [UIColor whiteColor];
    
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = title;
    if (KProjectScreenWidth > 350) {
        titleLabel.font = [UIFont systemFontOfSize:18];

    }else
    {
        titleLabel.font = [UIFont systemFontOfSize:14];

    }
    [whiteBackGround addSubview:titleLabel];
    CGFloat juli = 20;
    if (KProjectScreenWidth == 320) {
        juli = 15;
    }
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteBackGround.mas_left).offset(15);
        make.top.equalTo(whiteBackGround.mas_top).offset(juli);
        make.right.equalTo(whiteBackGround.mas_right).offset(-15);
    }];
    
    
    //创建右下角文字说明
    numberView.textAlignment = NSTextAlignmentLeft;
    numberView.textColor = [UIColor lightGrayColor];
    numberView.text = numberString;
    if (KProjectScreenWidth > 350) {
        numberView.font = [UIFont systemFontOfSize:16];
        
    }else
    {
        numberView.font = [UIFont systemFontOfSize:13];
        
    }
    [whiteBackGround addSubview:numberView];
    numberView = numberView;
    [numberView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(juli - 5);
        make.left.equalTo(titleLabel.mas_left);
        //make.centerX.equalTo(titleLabel.mas_centerX);
    }];
    
    if (isShowRight) {
        //创建左下角向右箭头
        UIImageView * rightImageView2 = [[UIImageView alloc]init];
        rightImageView2.image = [UIImage imageNamed:@"我的推荐_向右小箭头_1702"];
        [whiteBackGround addSubview:rightImageView2];
        [rightImageView2 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(numberView.mas_right).offset(20);
            make.centerY.equalTo(numberView.mas_centerY);
            
        }];
    }
    
    //添加左下角区域的点击事件
    UIButton * rightImageViewButton2 = [[UIButton alloc]init];
    [rightImageViewButton2 setBackgroundColor:[UIColor clearColor]];
    rightImageViewButton2.tag = tag;
    [rightImageViewButton2 addTarget:self action:@selector(rightImageViewButtonButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [whiteBackGround addSubview:rightImageViewButton2];
    [rightImageViewButton2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteBackGround.mas_left);
        make.top.equalTo(whiteBackGround.mas_top);
        make.right.equalTo(whiteBackGround.mas_right);
        make.bottom.equalTo(whiteBackGround.mas_bottom);
    }];
    
    return whiteBackGround;
    
}

-(UIView *)retWhiteRectangleViewWithTitle:(NSString *)title Withtag:(NSInteger)tag withShowRightIcon:(NSString *)imageString
{
    UIView * whiteBackGround = [[UIView alloc]init];
    whiteBackGround.backgroundColor = [UIColor whiteColor];
    
    //创建左下角向右箭头
    UIImageView * rightImageView2 = [[UIImageView alloc]init];
    rightImageView2.image = [UIImage imageNamed:imageString];
    [whiteBackGround addSubview:rightImageView2];
    [rightImageView2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteBackGround.mas_left).offset(15);
        make.centerY.equalTo(whiteBackGround.mas_centerY);
    }];
    
    
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = title;
    if (KProjectScreenWidth > 350) {
        titleLabel.font = [UIFont systemFontOfSize:17];

    }else
    {
        titleLabel.font = [UIFont systemFontOfSize:14];

    }
    
    [whiteBackGround addSubview:titleLabel];
    
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rightImageView2.mas_left).offset(20);
        make.centerY.equalTo(whiteBackGround.mas_centerY);
    }];
    
    //创建左下角向右箭头
    UIImageView * rightImageButton = [[UIImageView alloc]init];
    rightImageButton.image = [UIImage imageNamed:@"我的推荐_向右小箭头_1702"];
    [whiteBackGround addSubview:rightImageButton];
    [rightImageButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(whiteBackGround.mas_right).offset(-10);
        make.centerY.equalTo(whiteBackGround.mas_centerY);
    }];
    
    
    //添加左下角区域的点击事件
    UIButton * rightImageViewButton2 = [[UIButton alloc]init];
    [rightImageViewButton2 setBackgroundColor:[UIColor clearColor]];
    rightImageViewButton2.tag = tag;
    [rightImageViewButton2 addTarget:self action:@selector(rightImageViewButtonButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [whiteBackGround addSubview:rightImageViewButton2];
    [rightImageViewButton2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteBackGround.mas_left);
        make.top.equalTo(whiteBackGround.mas_top);
        make.right.equalTo(whiteBackGround.mas_right);
        make.bottom.equalTo(whiteBackGround.mas_bottom);
    }];
    
    return whiteBackGround;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)getHtml
{
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"AppId":@"huiyuan",
                                 @"AppTime":[NSNumber numberWithInt:timestamp],
                                 @"Token":tokenlow
                                 
                                 };

    NSString * stringHtml = kFMPhpUniversalBaseUrl(@"Rongtuoxinsoc/Usercenter/myrecommpersliuer");
    //@"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/myrecommpers";
    
    //NSString * stringHtml = kXZUniversalTestUrl(@"GetMyRecommend");
    
    [FMHTTPClient postPath:stringHtml parameters:parameter completion:^(WebAPIResponse *response) {
        
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (response.code == WebAPIResponseCodeSuccess) {
            
            NSDictionary * dict = response.responseObject[@"data"];
            
            if (!([dict isMemberOfClass:[NSArray class]]||[dict isMemberOfClass:[NSNull class]])) {
               
                FMMyRecommendModel * recommendModel = [[FMMyRecommendModel alloc]init];
                [recommendModel setValuesForKeysWithDictionary:dict];
                self.recommendModel = recommendModel;
                
                
                [recommendModel setUpDefaultValue];
                [self createUIScrollViewHeaderView];
                
                
                [self createMiddleButtonFirst];
                
                [self setUpDateALL];
                
            }else
            {
                ShowAutoHideMBProgressHUD(self.view, @"参数错误，请稍后重试！");
                
            }
            
            
        }else
        {
            NSString * status =  response.responseObject[@"status"];
            if (![status isMemberOfClass:[NSNull class]]) {
                NSInteger staNum = [status integerValue];
                if (staNum == 1) {
                    ShowAutoHideMBProgressHUD(self.view, response.responseObject[@"msg"]);
                    
                }else
                {
                    ShowAutoHideMBProgressHUD(self.view, @"网络不好，请稍后重试！");
                }
            }else
            {
                ShowAutoHideMBProgressHUD(self.view, @"网络不好，请稍后重试！");
                
            }
        }

        
        
        
        
    }];
}
-(void)setUpDateALL
{
    self.middleMAXDetail.text = [NSString stringWithFormat:@"%@",self.recommendModel.jinriyjjiner];
    self.leftNumberDetail.text = [NSString stringWithFormat:@"%@",self.recommendModel.benyyjjiner];
    self.rightNumberDetail.text = [NSString stringWithFormat:@"%@",self.recommendModel.leijiyjjiner];
    
    
    if ([self.recommendModel.jibie integerValue] == 2) {
        self.recommendAllPrice.text = [NSString stringWithFormat:@"%@万元",self.recommendModel.myzichanjiner];
        self.recommendAllPerson.text = [NSString stringWithFormat:@"%@名",self.recommendModel.myreuserjiner];
        
        
    }else
    {
        self.recommendAllPrice.text = [NSString stringWithFormat:@"%@万元",self.recommendModel.myzichanjiner];
        self.recommendAllPerson.text = [NSString stringWithFormat:@"%@名",self.recommendModel.myreuserjiner];
        self.friendALLMoney.text = [NSString stringWithFormat:@"%@万元",self.recommendModel.haoygongxian];
        self.friendAllget.text = [NSString stringWithFormat:@"%@元",self.recommendModel.hygxyongjin];

    }
    
}



-(void)rightTopCalenderButtonOnClick:(UIButton *)button
{
    
    FMMyRecommentCalendarViewController * comment = [[FMMyRecommentCalendarViewController alloc]init];
    comment.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:comment animated:YES];
    
    
}

-(void)rightImageViewButtonButtonOnClick:(UIButton *)button
{
    if (button.tag == 1001) {
//        //左下角本月累计佣金
//        NSLog(@"左下角本月累计佣金");
        // 本月累计佣金
        XZMonthTotalCommissionController *monthTotalCommission = [[XZMonthTotalCommissionController alloc] init];
        monthTotalCommission.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:monthTotalCommission animated:YES];
    }else if(button.tag == 1002)
    {
//        //右下角累计已收佣金
//        NSLog(@"右下角累计已收佣金");
        //
        XZTotalReceivedCommissionController *totalReceivedCommission = [[XZTotalReceivedCommissionController alloc] init];
        totalReceivedCommission.titleStr = @"累计已收佣金";
        totalReceivedCommission.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:totalReceivedCommission animated:YES];
    }else if(button.tag == 1003)
    {
        //推荐资产
//        NSLog(@"推荐资产金");
        
    }else if(button.tag == 1004)
    {
        //推荐客户
//        NSLog(@"推荐客户");
        WLKeHuViewController *vc = [[WLKeHuViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if(button.tag == 1005)
    {
        //好友贡献资产
//        NSLog(@"好友贡献资产");
        WLFriendsForgiveViewController *vc = [[WLFriendsForgiveViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (button.tag == 1006)
    {
        // 好友贡献佣金、累计已收佣金
        XZTotalReceivedCommissionController *totalReceivedCommission = [[XZTotalReceivedCommissionController alloc] init];
        totalReceivedCommission.titleStr = @"好友贡献佣金";
        totalReceivedCommission.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:totalReceivedCommission animated:YES];
//        NSLog(@"好友贡献佣金");

    }else if (button.tag == 1007)
    {
        //设置推荐权限
//        NSLog(@"设置推荐权限");
        YYPermissionSettingController *perS = [[YYPermissionSettingController alloc]init];
        [self.navigationController pushViewController:perS animated:YES];

    }else if(button.tag == 1008)
    {
        //我的二维码
        [self myErweima];
        

    }else
    {
        
    }
    
}


-(void)myErweima
{
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"UserId":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"AppId":@"huiyuan",
                                 @"AppTime":[NSNumber numberWithInt:timestamp],
                                 @"Token":tokenlow
                                 
                                 };
    NSString * stringHtml = kFMPhpUniversalBaseUrl(@"Rongtuoxinsoc/Usercenter/mytwododeliuer");
    //@"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/mytwodode";
    //NSString * stringHtml = kXZUniversalTestUrl(@"MyCode");
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [FMHTTPClient postPath:stringHtml parameters:parameter completion:^(WebAPIResponse *response) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (response.code == WebAPIResponseCodeSuccess) {
            
            
            NSDictionary * dict = response.responseObject[@"data"];
            
            if (!([dict isMemberOfClass:[NSArray class]]||[dict isMemberOfClass:[NSNull class]])) {
                
                
                XZActivityModel *modelActivity = [[XZActivityModel alloc] init];
                modelActivity.sharetitle = [NSString stringWithFormat:@"%@",dict[@"sharetitle"]];
                modelActivity.sharecontent = [NSString stringWithFormat:@"%@",dict[@"sharecontent"]];
                modelActivity.sharepic = [NSString stringWithFormat:@"%@",dict[@"sharepic"]];
                modelActivity.shareurl = [NSString stringWithFormat:@"%@",dict[@"shareurl"]];
                modelActivity.linkUrl = [NSString stringWithFormat:@"%@",dict[@"shareurl"]];
                
                
                
                
                
                XZRecommandQRCodeController *recommended = [[XZRecommandQRCodeController alloc] init];
                recommended.navTitle = [NSString stringWithFormat:@"%@",dict[@"title"]];
                recommended.modelActivity = modelActivity;
                [self.navigationController pushViewController:recommended animated:YES];
            }else
            {
                ShowAutoHideMBProgressHUD(self.view, @"参数错误，请稍后重试！");
                
            }
            
            
        }else
        {
            ShowAutoHideMBProgressHUD(self.view, @"网络不好，请稍后重试！");
        }
    }];
    
     
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

@implementation FMMyRecommendModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

-(void)setUpDefaultValue;
{

    if ([self.jinriyjjiner isMemberOfClass:[NSNull class]]) {
        self.jinriyjjiner = @"0";
    }
    if ([self.leijiyjjiner isMemberOfClass:[NSNull class]]) {
        self.leijiyjjiner = @"0";
    }
    if ([self.benyyjjiner isMemberOfClass:[NSNull class]]) {
        self.benyyjjiner = @"0";
    }
    if ([self.myzichanjiner isMemberOfClass:[NSNull class]]) {
        self.myzichanjiner = @"0";
    }
    if ([self.myzichanjinerwanyi isMemberOfClass:[NSNull class]]) {
        self.myzichanjinerwanyi = @"0";
    }
    if ([self.myreuserjiner isMemberOfClass:[NSNull class]]) {
        self.myreuserjiner = @"0";
    }
    if ([self.haoygongxianwanyi isMemberOfClass:[NSNull class]]) {
        self.haoygongxianwanyi = @"0";
    }
    if ([self.haoygongxian isMemberOfClass:[NSNull class]]) {
        self.haoygongxian = @"0";
    }
    if ([self.hygxyongjin isMemberOfClass:[NSNull class]]) {
        self.hygxyongjin = @"0";
    }
}


@end
