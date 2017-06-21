//
//  FMTimeKillShopDetailController.m
//  fmapp
//
//  Created by runzhiqiu on 16/8/10.
//  Copyright © 2016年 yk. All rights reserved.
//
#define KdefaultButtonColorAlpha 0.6

#define KdefauleMargion 30

#define KDefaultVideoMargion 8


#import "FMTimeKillShopDetailController.h"
#import "FMTimeKillShopDetailHeaderView.h"
#import "FMShopOtherModel.h"
#import <MediaPlayer/MediaPlayer.h>
#import "LWImageBrowserModel.h"
#import "LWImageBrowser.h"
#import "FMShopSpecModel.h"

#import "LRLAVPlayerView.h"
#import "FMButtonStyleModel.h"
//#import "FMTimeKillShowSelectView.h"
#import "XZConfirmOrderKillViewController.h" // 确认订单
#import "XZShoppingOrderAddressModel.h"

#import "FMRTAuctionShareModel.h"
#import "WLPublishSuccessViewController.h"
#import "XZActivityModel.h"

#import "FMTimeKillSelectView.h"
#import "AppDelegate.h"
@interface FMTimeKillShopDetailController ()<LRLAVPlayDelegate>

@property (nonatomic, strong) FMShopDetailKillVideoModel * videoModel;

@property (nonatomic, strong) UIView * contentView;
//用来播放视频的view
@property (nonatomic, strong) LRLAVPlayerView * avplayerView;

@property (nonatomic, strong) UIWebView * webView;

@property (nonatomic, strong) UIButton * bottomButton;
@property (nonatomic, strong) NSMutableArray * lookLargeImage;
@property (nonatomic, strong) FMTimeKillShopDetailHeaderView * placeorderHeader;
@property (nonatomic, strong) FMSelectShopInfoModel * shopDetailModel;


@property (nonatomic, weak) UIView * titleContentView;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UIButton * retButton;
@property (nonatomic, assign) BOOL isChangeValue;
//@property (nonatomic, strong) FMTimeKillShowSelectView * showSelect;


@property (nonatomic, strong) UIView *lanjiazai;
@property (nonatomic, strong) UIView * statusView;



@property (nonatomic, assign) BOOL showNavigationBar;
@end

@implementation FMTimeKillShopDetailController


-(FMSelectShopInfoModel *)shopDetailModel
{
    if (!_shopDetailModel) {
        _shopDetailModel = [[FMSelectShopInfoModel alloc]init];
    }
    return _shopDetailModel;
}

-(NSMutableArray *)lookLargeImage
{
    if (!_lookLargeImage) {
        _lookLargeImage = [NSMutableArray array];
    }
    return _lookLargeImage;
}
-(UIButton *)bottomButton
{
    if (!_bottomButton) {
        _bottomButton = [[UIButton alloc]init];
        _bottomButton.frame = CGRectMake(0, self.view.frame.size.height - 49, KProjectScreenWidth, 49);
        if ([self.activity_state integerValue]== 2) {
            [_bottomButton setBackgroundColor:[HXColor colorWithHexString:@"#003d90"]];
        }else
        {
            [_bottomButton setBackgroundColor:[HXColor colorWithHexString:@"#aaaaaa"]];
        }
        
        [_bottomButton addTarget:self action:@selector(checkGetTimeKillButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (KProjectScreenWidth != 320) {
            _bottomButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
           
        }else
        {
            _bottomButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
           
        }
        [_bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.view addSubview:_bottomButton];
        
    }
    return _bottomButton;
}

-(FMTimeKillShopDetailHeaderView *)placeorderHeader
{
    if (!_placeorderHeader) {
        __weak __typeof(&*self)weakSelf = self;
         CGFloat headerHeigh = KProjectScreenWidth * 0.9375 + 40 + KDefauletCellItemLargeHeigh + KDefauletCellItemLargeHeigh;
        _placeorderHeader = [[FMTimeKillShopDetailHeaderView alloc]init];
        _placeorderHeader.frame = CGRectMake(0,-headerHeigh, KProjectScreenWidth, headerHeigh);
        _placeorderHeader.itemBlock = ^(NSInteger index){
            [weakSelf imageSDCycleItemOnClick:index];
        };
        
        [self.webView.scrollView addSubview:_placeorderHeader];

    }
    return _placeorderHeader;
}


#pragma mark - 创建用于播放的View
-(UIView *)contentView
{
    if (!_contentView) {
        
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, -[self.videoModel.videoHeigh floatValue], KProjectScreenWidth, [self.videoModel.videoHeigh floatValue])];
        _contentView.backgroundColor = [UIColor whiteColor];
        
    }
    return _contentView;
}

-(void)createAVPlayerView{
    //固定的实例化方法
    self.avplayerView = [LRLAVPlayerView avplayerViewWithVideoUrlStr:self.videoModel.videoString andInitialHeight:[self.videoModel.videoHeigh floatValue] WithWidth:[self.videoModel.videoWidth floatValue] andSuperView: self.contentView withDefaultVideoUrl:self.videoModel.video_thumb];
    
    self.avplayerView.delegate = self;
    [self.contentView addSubview:self.avplayerView];
    __weak __typeof(&*self)weakSelf = self;
    
    
    
    NSString * version = [[UIDevice currentDevice] systemVersion];

    
    if ([version floatValue] >= 10 ) {
        
        
        
        //我的播放器依赖 Masonry 第三方库
        [self.avplayerView setPositionWithPortraitBlock:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView);
            make.left.equalTo(weakSelf.contentView);
            make.right.equalTo(weakSelf.contentView);
            //添加竖屏时的限制, 这条也是固定的, 因为: _videoHeight 是float* 类型, 我可以通过它, 动态改视频播放器的高度;
            make.height.equalTo(@(*(weakSelf.avplayerView->_videoHeight)));
        } andLandscapeBlock:^(MASConstraintMaker *make) {
            
            
            make.width.equalTo(@(SCREEN_HEIGHT));
            make.height.equalTo(@(SCREEN_WIDTH));
            make.left.equalTo(Window.mas_left).offset(-(SCREEN_HEIGHT - SCREEN_WIDTH) * 0.5);
            make.top.equalTo(Window.mas_top).offset((SCREEN_HEIGHT - SCREEN_WIDTH) * 0.5);
            
            
        }];
        
        
        
    }else if([version floatValue] >= 7 && [version floatValue] < 8){
        
        
        //我的播放器依赖 Masonry 第三方库
        [self.avplayerView setPositionWithPortraitBlock:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView);
            make.left.equalTo(weakSelf.contentView);
            make.right.equalTo(weakSelf.contentView);
            //添加竖屏时的限制, 这条也是固定的, 因为: _videoHeight 是float* 类型, 我可以通过它, 动态改视频播放器的高度;
            make.height.equalTo(@(*(weakSelf.avplayerView->_videoHeight)));
        } andLandscapeBlock:^(MASConstraintMaker *make) {
            
            
            make.width.equalTo(@(SCREEN_HEIGHT));
            make.height.equalTo(@(SCREEN_WIDTH));
            make.left.equalTo(Window.mas_left);
            make.top.equalTo(Window.mas_top);
            
            
        }];
        
        
    }else
    {
        
        //我的播放器依赖 Masonry 第三方库
        [self.avplayerView setPositionWithPortraitBlock:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView);
            make.left.equalTo(weakSelf.contentView);
            make.right.equalTo(weakSelf.contentView);
            //添加竖屏时的限制, 这条也是固定的, 因为: _videoHeight 是float* 类型, 我可以通过它, 动态改视频播放器的高度;
            make.height.equalTo(@(*(weakSelf.avplayerView->_videoHeight)));
        } andLandscapeBlock:^(MASConstraintMaker *make) {
            make.width.equalTo(@(SCREEN_HEIGHT));
            make.height.equalTo(@(SCREEN_WIDTH));
            make.center.equalTo(Window);
        }];
    }    
    
    
    [self.avplayerView playOrPause];
    
    
}
//开始时调用的方法
-(void)play;
{
    
}
//暂停时调用的方法
-(void)pause;
{
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.showNavigationBar = NO;
     [self.navigationController setNavigationBarHidden:YES animated:animated];
    CGFloat headerHeigh = KProjectScreenWidth * 0.9375 + 40 + KDefauletCellItemLargeHeigh + KDefauletCellItemLargeHeigh;
    [self.webView.scrollView setContentOffset:CGPointMake(0,  -[self.videoModel.videoHeigh floatValue] - KDefaultVideoMargion - headerHeigh)];
    
    if (self.shopDetailModel) {
        if (self.shopDetailModel.currentStyle.length > 0) {
            self.shopDetailModel.locationArray = nil;
        }
    }
}

-(void)dealloc
{
    [self.avplayerView destoryAVPlayer];
    [self.avplayerView removeFromSuperview];
    self.avplayerView = nil;
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (self.avplayerView.isPlaying) {
        [self.avplayerView playOrPause];
    }
    
    if (!self.showNavigationBar) {
          [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
    
    
   
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    
    self.view.backgroundColor = [UIColor colorWithRed:(230.0/255) green:(234.0/255) blue:(241.0/255) alpha:1];
    
    [self createUINavigation];

    if(self.product_id)
    {
         [self getCurrentStatusWithNetWork];
    }else
    {
          [self createUIAndGetDataSource];
    }
    
   
    
    
        // Do any additional setup after loading the view.
}

-(void)getCurrentStatusWithNetWork
{
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSDictionary * paras;
    
    
    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) { // 已登录
        NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
        NSString * flagWithView;
        if (self.shopDetailStyle == FMTimeKillShowSelectViewJingPai) {
            flagWithView = @"auction";
        }else
        {
            flagWithView = @"kill";
        }
        
        
       paras = @{@"appid":@"huiyuan",
            @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
            @"shijian":[NSNumber numberWithInt:timestamp],
            @"token":[token lowercaseString],
            @"tel":[CurrentUserInformation sharedCurrentUserInfo].mobile,
            @"flag":flagWithView,
            @"id":self.actionFlag};


    }else { // 未登录
        NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",@"0",timestamp]);
        NSString * flagWithView;
        if (self.shopDetailStyle == FMTimeKillShowSelectViewJingPai) {
            flagWithView = @"auction";
        }else
        {
            flagWithView = @"kill";
        }
        
        
        paras = @{@"appid":@"huiyuan",
                  @"user_id":@"0",
                  @"shijian":[NSNumber numberWithInt:timestamp],
                  @"token":[token lowercaseString],
                  @"flag":flagWithView,
                  @"id":self.actionFlag};

    }

    
    
    NSString * baseUrl = [NSString stringWithFormat:@"%@/%@",kXZTestEnvironment,@"public/show/getActivityInfo"];
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:baseUrl parameters:paras completion:^(WebAPIResponse *response) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (response.code == WebAPIResponseCodeSuccess) {
            
            if (response.responseObject[@"data"]) {
                NSDictionary * data = response.responseObject[@"data"];
                
                if (data[@"price"]) {
                    self.killPrice = data[@"price"];
                }
                if (data[@"state"]) {
                    self.activity_state = data[@"state"];
                }
                
                [self createUIAndGetDataSource];
                
                
                
            }else
            {
                ShowAutoHideMBProgressHUD(self.view, @"暂无数据");
                 [self.view bringSubviewToFront:self.titleContentView];
                 [self.view bringSubviewToFront:self.statusView];
            }
            
        }else
        {
            ShowAutoHideMBProgressHUD(self.view, @"请求失败");
            [self.view bringSubviewToFront:self.titleContentView];
            [self.view bringSubviewToFront:self.statusView];

        }
    }];
}

-(void)createUIAndGetDataSource
{
    
    UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 49)];
    webView.backgroundColor = [UIColor colorWithRed:(230.0/255) green:(234.0/255) blue:(241.0/255) alpha:1];
    webView.scrollView.backgroundColor = [UIColor colorWithRed:(230.0/255) green:(234.0/255) blue:(241.0/255) alpha:1];
    
    [webView.scrollView addSubview:[self contentShowTitleView]];
    
    
    CGFloat headerHeigh = KProjectScreenWidth * 0.9375 + 40 + KDefauletCellItemLargeHeigh + KDefauletCellItemLargeHeigh;
    webView.scrollView.contentInset = UIEdgeInsetsMake(headerHeigh, 0, 0, 0);
    
    webView.scrollView.contentOffset = CGPointMake(0, -headerHeigh);
    

    
    self.webView = webView;
    webView.scalesPageToFit = YES;
    [self.view addSubview: webView];
    
    
   
    
    
    [self getDataSourceFromNetWork];
    
    if(self.shopDetailStyle == FMTimeKillShopDetailControllerJingPai)
    {
        
        [self.bottomButton setTitle:@"我要竞拍" forState:UIControlStateNormal];
        
        
    }else
    {
        [self.bottomButton setTitle:@"我要秒杀" forState:UIControlStateNormal];
        
    }
    if ([self.activity_state integerValue]!= 2) {
        
        if ([self.activity_state integerValue]== 1) {
            [self.bottomButton setTitle:@"尚未开始" forState:UIControlStateNormal];
        }else if ([self.activity_state integerValue]== 3)
        {
            [self.bottomButton setTitle:@"已结束" forState:UIControlStateNormal];
        }
    }
    
    
    
    [self.view bringSubviewToFront:self.titleContentView];
    [self.view bringSubviewToFront:self.statusView];
    
    
    [self createFloatView];
}
-(void)createFloatView
{
    CGFloat returTopView_width = 35;
    UIButton * returTopView = [[UIButton alloc]initWithFrame:CGRectMake(KProjectScreenWidth - returTopView_width - 5, self.view.frame.size.height - 64 - returTopView_width - KdefauleMargion, returTopView_width, returTopView_width)];//电话_03controlScrollViewLocationButtonOnClick
    [returTopView setBackgroundImage:[UIImage imageNamed:@"电话_03"] forState:UIControlStateNormal];
    [returTopView addTarget:self action:@selector(controlCallTelephoneButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returTopView];
    [self.view bringSubviewToFront:returTopView];
    
    
    UIButton * callTelephoneView = [[UIButton alloc]initWithFrame:CGRectMake(KProjectScreenWidth - returTopView_width - 5 , self.view.frame.size.height - 64 - returTopView_width - KdefauleMargion - 10 - returTopView_width, returTopView_width, returTopView_width)];
    [callTelephoneView setBackgroundImage:[UIImage imageNamed:@"返回顶部"] forState:UIControlStateNormal];
    [callTelephoneView addTarget:self action:@selector(controlScrollViewLocationButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:callTelephoneView];
    [self.view bringSubviewToFront:callTelephoneView];
}

-(void)controlCallTelephoneButtonOnClick:(UIButton *)button
{
    UIWebView *webView = [[UIWebView alloc]init];
    NSURL *url = [NSURL URLWithString:@"tel://4008788686"];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webView];

}

-(void)controlScrollViewLocationButtonOnClick:(UIButton *)button
{
    CGFloat headerHeigh = KProjectScreenWidth * 0.9375 + 40 + KDefauletCellItemLargeHeigh + KDefauletCellItemLargeHeigh;
    [self.webView.scrollView setContentOffset:CGPointMake(0,  -[self.videoModel.videoHeigh floatValue] - KDefaultVideoMargion - headerHeigh)];
}


-(void)createUINavigation
{
    
    UIView * titleContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 64)];
    self.titleContentView = titleContentView;
    titleContentView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    [self.view addSubview:titleContentView];
    [self.view bringSubviewToFront:titleContentView];
    
    
    UIView * statusView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, KProjectScreenWidth, 44)];
    statusView.backgroundColor = [UIColor clearColor];
    self.statusView = statusView;
    [self.view addSubview:statusView];
    [self.view bringSubviewToFront:statusView];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 43.5, KProjectScreenWidth, 0.5)];
    self.lineView = lineView;
    lineView.backgroundColor = [UIColor colorWithRed:(229/255.0) green:(233/255.0) blue:(242/255.0) alpha:0];
    [statusView addSubview:lineView];
    
    
    UIButton * retButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 7, 30, 30)];
    self.retButton = retButton;
    retButton.layer.cornerRadius = 15;
    retButton.layer.masksToBounds = YES;
    retButton.backgroundColor = [UIColor colorWithRed:(30/255.0) green:(30/255.0) blue:(30/255.0) alpha:0.5];
    retButton.tag = 500;
    retButton.center = CGPointMake(retButton.center.x, statusView.frame.size.height * 0.5);
    retButton.layer.cornerRadius = 15.0;
    
    [retButton setBackgroundImage:[UIImage imageNamed:@"返回商品详情白色"] forState:UIControlStateNormal];
    [retButton addTarget:self action:@selector(titleContentButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [statusView addSubview:retButton];
    
    
    
    UIButton * shopingCartButton = [[UIButton alloc]initWithFrame:CGRectMake(KProjectScreenWidth - 30 - 15,7, 30, 30)];
    shopingCartButton.tag = 501;
    shopingCartButton.center = CGPointMake(shopingCartButton.center.x,  statusView.frame.size.height * 0.5);
    shopingCartButton.layer.cornerRadius = 15.0;
    
    [shopingCartButton setBackgroundImage:[UIImage imageNamed:@"1018分享"] forState:UIControlStateNormal];
    [shopingCartButton addTarget:self action:@selector(titleContentButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [statusView addSubview:shopingCartButton];
    
    
    
}

-(void)titleContentButtonOnClick:(UIButton *)button
{
    if (button.tag == 500) {
        [self.navigationController popViewControllerAnimated:YES];
        self.navigationController.navigationBarHidden = NO;

    }else if (button.tag == 501)
    {
        
        //分享
        [self rightButton];
    }else
    {
        
    }
    
}


    
#pragma mark - 分享
- (void)rightButton{
    
    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) { // 已登录
        
    }else { // 未登录
        LoginController *registerController = [[LoginController alloc] init];
        FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
        [self.navigationController presentViewController:navController animated:YES completion:^{
        }];
        return;
    }
    

    
    
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter;
    if (self.shopDetailStyle == FMTimeKillShopDetailControllerJingPai) {
        parameter = @{@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                      @"appid":@"huiyuan",
                      @"shijian":[NSNumber numberWithInt:timestamp],
                      @"token":tokenlow,
                      @"tel":[CurrentUserInformation sharedCurrentUserInfo].mobile,
                      @"flag":@"auction_goods"};
    }else
    {
        parameter = @{@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                     @"appid":@"huiyuan",
                                     @"shijian":[NSNumber numberWithInt:timestamp],
                                     @"token":tokenlow,
                                     @"tel":[CurrentUserInformation sharedCurrentUserInfo].mobile,
                                     @"flag":@"kill_goods"};
    }

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof (self)weakSelf = self;
    
    NSString *testurl =[NSString stringWithFormat:@"%@/public/other/getShareInfo",kXZTestEnvironment];
    
    //@"https://www.rongtuojinrong.com/java/public/other/getShareInfo"
    [FMHTTPClient postPath:testurl parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        NSString * status = [NSString stringWithFormat:@"%@",response.responseObject[@"status"]];
        if ([status integerValue] == 0) {
            
            NSDictionary * objectDic = [response.responseObject objectForKey:@"data"];
            
            FMRTAuctionShareModel *model = [[FMRTAuctionShareModel alloc]init];
            [model setValuesForKeysWithDictionary:objectDic];
            
            WLPublishSuccessViewController *shareVC = [WLPublishSuccessViewController new];
            shareVC.tag = @"kill";
            XZActivityModel *m = [XZActivityModel new];
            m.sharetitle = model.title;
            m.sharepic = self.shopDetailModel.image;
            NSString * flagInView;
             if (self.shopDetailStyle == FMTimeKillShopDetailControllerJingPai)
             {
                 flagInView = @"2";
             }else
             {
                 flagInView = @"1";
             }
            m.shareurl = [NSString stringWithFormat:@"%@?appid=huiyuan&token=%@&shijian=%@&user_id=%@&flag=%@&product_id=%@&id=%@",model.link,tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId,flagInView,self.product_id,self.actionFlag];

            m.sharecontent = self.shopDetailModel.title;
            shareVC.modelActivity = m;
            [weakSelf.navigationController pushViewController:shareVC animated:YES];
            
        }else{
            ShowAutoHideMBProgressHUD(weakSelf.view, @"数据请求错误");
        }
    }];
}



-(void)changeHeaderViewTitleImages:(NSArray *)images
{
    for (NSInteger i = 0; i < images.count; i++) {
        NSString * imageUrl = images[i];
        
        LWImageBrowserModel * model = [[LWImageBrowserModel alloc]initWithplaceholder:[UIImage imageNamed:@"美读时光headerBack_02"] thumbnailURL:[NSURL URLWithString:imageUrl] HDURL:[NSURL URLWithString:imageUrl] imageViewSuperView:self.view positionAtSuperView:CGRectMake(KProjectScreenWidth * 0.5, KProjectScreenHeight * 0.5, 0, 0) index:i];
        [self.lookLargeImage addObject:model];
    }
    
    self.placeorderHeader.shopImageUrl = images;
}


-(void)getDataSourceFromNetWork
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:self.detailURL parameters:nil completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if (response.code == WebAPIResponseCodeSuccess) {
            NSDictionary * data = response.responseObject[@"data"];
            [self changeHeaderViewTitleImages:data[@"images"]];
            NSArray * imageArrayWithShopDetail = data[@"images"];
            if(![data[@"video_thumb"] isMemberOfClass:[NSNull class]]){
                
                self.shopDetailModel.video_thumb = [NSString stringWithFormat:@"%@",data[@"video_thumb"]];
            }
            self.shopDetailModel.unselectInfo = @"请选择商品样式";
            
            self.shopDetailModel.video_thumb = 
            self.shopDetailModel.product_id = data[@"product_id"];
            self.shopDetailModel.gid = data[@"gid"];
            
            self.shopDetailModel.price = self.killPrice;
            self.shopDetailModel.sale_price = self.killPrice;
            
            if (imageArrayWithShopDetail.count) {
                self.shopDetailModel.image = imageArrayWithShopDetail[0];
            }
            NSDictionary * specDict = data[@"spec"];
            
            NSArray * goods = specDict[@"goods"];
            
            NSDictionary * specification = specDict[@"specification"];
            NSArray * spec_name = specification[@"spec_name"];
            
            NSMutableArray * locationSpec = [NSMutableArray array];
            if (goods.count > 0) {
                if (spec_name.count > 0) {
                        for (NSInteger i=0; i < spec_name.count; i++) {
                            
                            for (NSDictionary * dictSpec in goods[i]) {
                                FMShopCollectionInfoModel * model = [[ FMShopCollectionInfoModel alloc]init];
                                model.spec_name = spec_name[i];
                                model.contentString = dictSpec[@"spec_value"];
                                
                                
                                [locationSpec addObject:model];
                            }
                        }
                    }
                }
            
            if (spec_name.count == 0) {
                self.shopDetailModel.isAllShopInfo = YES;
            }
            
            self.shopDetailModel.locationSpec = locationSpec;
            
            
        
            
            FMShopDetailKillVideoModel * videoModel = [[FMShopDetailKillVideoModel alloc]init];
            videoModel.videoString = data[@"video"];
            videoModel.videoWidth = data[@"videoW"];
            videoModel.videoHeigh = data[@"videoH"];
            videoModel.video_thumb = self.shopDetailModel.video_thumb;

            [videoModel resetVideoWidthAndHeigh];
            self.videoModel = videoModel;

            
            if (self.videoModel.videoString.length > 0) {
                [self lanjiazai];
            }
            
            
            self.shopDetailModel.title = data[@"title"];
            self.placeorderHeader.shopDetailModel = self.shopDetailModel;
                
            [self changeShopDetailWithHtml:data[@"intro_ios"]];
        }
        
    }];

}

-(UIView *)lanjiazai
{
    if (!_lanjiazai) {
        _lanjiazai = [[UIView alloc]init];
        [self changeWebViewHeigh];
    }
    return _lanjiazai;
}
-(void)changeWebViewHeigh
{
    if (self.videoModel.videoString.length > 0) {
        UIEdgeInsets  edge =  self.webView.scrollView.contentInset;
        
        self.webView.scrollView.contentInset = UIEdgeInsetsMake(edge.top + [self.videoModel.videoHeigh floatValue] + KDefaultVideoMargion, 0, 0, 0);
        self.webView.scrollView.contentOffset = CGPointMake(0, -(edge.top + [self.videoModel.videoHeigh floatValue] + KDefaultVideoMargion));
        
        self.placeorderHeader.frame = CGRectMake(0,-(edge.top + [self.videoModel.videoHeigh floatValue] + KDefaultVideoMargion), KProjectScreenWidth, edge.top);
        [self.webView.scrollView addSubview:self.contentView];
        [self createAVPlayerView];
    }

}

-(void)changeVideoWithView
{
    
    if(self.videoModel.videoString.length > 2)
    {
        //创建头部视图
        CGFloat headerHeigh = KProjectScreenWidth * 0.9375 + 40 + KDefauletCellItemLargeHeigh + KDefauletCellItemLargeHeigh;
        
        self.webView.scrollView.contentInset = UIEdgeInsetsMake([self.videoModel.videoHeigh floatValue] + KDefaultVideoMargion + headerHeigh, 0, 0, 0);
        self.webView.scrollView.contentOffset = CGPointMake(0, -([self.videoModel.videoHeigh floatValue] + KDefaultVideoMargion + headerHeigh));
        
        [self.webView.scrollView addSubview:self.contentView];
        
        self.placeorderHeader.frame = CGRectMake(0, - [self.videoModel.videoHeigh floatValue] - KDefaultVideoMargion - headerHeigh, KProjectScreenWidth, headerHeigh);
        
        [self createAVPlayerView];

    }
}


-(void)changeShopDetailWithHtml:(NSString *)html
{
    NSString * htmlLoad = [NSString stringWithFormat:@"%@",html];
    [self.webView loadHTMLString:htmlLoad baseURL:nil];
}

-(void)createBottomViewWithTitle
{
    
}

//
//
//-(void)changeColorForStatusView:(CGFloat)radioAlpha
//{
//    if (radioAlpha > 1) {
//        radioAlpha = 1;
//    }
//    self.titleContentView.backgroundColor  = [UIColor colorWithWhite:1 alpha:radioAlpha];
//    self.lineView.backgroundColor = [UIColor colorWithRed:(229/255.0) green:(233/255.0) blue:(242/255.0) alpha:radioAlpha];
//    CGFloat backAlpha = (1 - radioAlpha) * KdefaultButtonColorAlpha;
//    
//    self.retButton.backgroundColor = [UIColor colorWithWhite:0 alpha:backAlpha];
//    
//    
//    if (backAlpha < 0.15 ) {
//        //改变图片
//        if (!self.isChangeValue) {
//            
//            [self.retButton setBackgroundImage:[UIImage imageNamed:@"返回商品详情黑色"] forState:UIControlStateNormal];
//            
//
//            self.isChangeValue = YES;
//        }
//    }else
//    {
//        if (self.isChangeValue) {
//            [self.retButton setBackgroundImage:[UIImage imageNamed:@"返回商品详情白色"] forState:UIControlStateNormal];
//            
//
//            self.isChangeValue = NO;
//        }
//        
//    }
//    
//}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//      CGFloat headerHeigh = KProjectScreenWidth * 0.9375 + 40 + KDefauletCellItemLargeHeigh + KDefauletCellItemLargeHeigh;
//    
//        //滑动标准值
//    
//    CGFloat radioAlpha = (headerHeigh + self.audioViewHeight + scrollView.contentOffset.y) / (scrollView.contentSize.height - KProjectScreenHeight - 50);
//        
//    [self changeColorForStatusView:radioAlpha];
//    
//}

//[self.webView loadHTMLString:_html baseURL:nil];



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)imageSDCycleItemOnClick:(NSInteger)index
{
    self.showNavigationBar = YES;
    LWImageBrowser* imageBrowser = [[LWImageBrowser alloc] initWithParentViewController:self
                                                                                  style:LWImageBrowserAnimationStyleScale
                                                                            imageModels:self.lookLargeImage
                                                                           currentIndex:index];
    imageBrowser.view.backgroundColor = [UIColor blackColor];
    [imageBrowser show];
}


-(UIView *)contentShowTitleView
{
    UIView * contentShow = [[UIView alloc]initWithFrame:CGRectMake(0, -([self.videoModel.videoHeigh floatValue] + KDefaultVideoMargion + 50), KProjectScreenWidth, 50)];
    contentShow.backgroundColor = [UIColor clearColor];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = @"返回上部";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor grayColor];
    [contentShow addSubview:titleLabel];
    titleLabel.center = CGPointMake(KProjectScreenWidth * 0.5, 25);
    return contentShow;
}


#pragma mark - 关闭设备自动旋转, 然后手动监测设备旋转方向来旋转avplayerView
-(BOOL)shouldAutorotate{
    return NO;
}


-(void)checkGetTimeKillButtonOnClick:(UIButton *)button
{
    //选择商品样式
    if ([button.currentTitle isEqualToString:@"尚未开始"]) {
       
        ShowAutoHideMBProgressHUD(self.view, @"活动尚未开始");

    }else if([button.currentTitle isEqualToString:@"已结束"])
    {
        ShowAutoHideMBProgressHUD(self.view, @"活动已结束");

    }else
    {
         [self openSelectModelView];
    }
        
    
}

-(void)openSelectModelView
{
    
    [self showSelectModelView];
    

}



-(void)showSelectModelView;
{
    
    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) { // 已登录
        
    }else { // 未登录
        LoginController *registerController = [[LoginController alloc] init];
        FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
        [self.navigationController presentViewController:navController animated:YES completion:^{
        }];
        return;
    }
    

    
    
    FMTimeKillSelectView * shopView = [[FMTimeKillSelectView alloc]init];
    
    //添加button
    shopView.isShowCount = NO;
    
    if (self.shopDetailStyle == FMTimeKillShopDetailControllerJingPai) {
       
        shopView.selectStyle = FMTimeKillShowSelectViewJingPai;
        self.shopDetailModel.auction_id = self.actionFlag;
        
        
    }else if (self.shopDetailStyle == FMTimeKillShopDetailControllerStyleMiaoSha)
    {
        shopView.selectStyle = FMTimeKillShowSelectViewStyleMiaoSha;
        self.shopDetailModel.kill_id = self.actionFlag;
        self.shopDetailModel.price = self.killPrice;
        self.shopDetailModel.sale_price = self.killPrice;
    }
   
    [shopView createPresentModel:self.shopDetailModel];
    
    
    __weak __typeof(&*self)weakSelf = self;
    shopView.successBlock = ^(FMSelectShopInfoModel * selectModel){
        weakSelf.showNavigationBar = NO;
        [weakSelf FMShowSelectViewDidSelecrButton:selectModel];
    };
    
    shopView.closeBlock = ^(FMSelectShopInfoModel * selectModel){
        weakSelf.showNavigationBar = NO;
    };
    
    
    
    shopView.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.15];
    self.definesPresentationContext = YES;
    self.showNavigationBar = YES;
    //源Controller中跳转方法实现
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        shopView.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        [weakSelf.navigationController presentViewController:shopView animated:NO completion:^{
        }];
        
    } else {
        
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        appdelegate.window.rootViewController.modalPresentationStyle=UIModalPresentationCurrentContext;
        [appdelegate.window.rootViewController presentViewController:shopView animated:YES completion:^{
            shopView.view.backgroundColor=[UIColor clearColor];
            appdelegate.window.rootViewController.modalPresentationStyle=UIModalPresentationFullScreen;
        }];
    }
    
}

-(void)FMShowSelectViewDidSelecrButton:(FMSelectShopInfoModel *)selectModel
{

    self.shopDetailModel = selectModel;
    if (self.shopDetailStyle == FMTimeKillShowSelectViewStyleMiaoSha) {
        self.shopDetailModel.price = self.killPrice;
    }else
    {
        if (![self.shopDetailModel.address isMemberOfClass:[NSNull class]]) {
            if (self.shopDetailModel.address.length > 0) {
                
                XZShoppingOrderAddressModel *addressModel = [[XZShoppingOrderAddressModel alloc]init];
                
                addressModel.addr = self.shopDetailModel.address;
                
                addressModel.mobile = self.shopDetailModel.phone;
                
                addressModel.name = self.shopDetailModel.recipients;
                addressModel.addr_id = self.shopDetailModel.address_id;
                selectModel.addressModel = addressModel;
            }
        }
        
    }
    
    
    XZConfirmOrderKillViewController *confirmOrder = [[XZConfirmOrderKillViewController alloc] init];
    confirmOrder.shopDetailModel = self.shopDetailModel;
    [self.navigationController pushViewController:confirmOrder animated:YES];
        
    
}


@end


@implementation FMShopDetailKillVideoModel


-(void)resetVideoWidthAndHeigh;
{
     if (self.videoString.length > 2) {
        float radio = [self.videoWidth floatValue] / [self.videoHeigh floatValue];
        if (radio >= 1) {
            self.videoWidth = [NSString stringWithFormat:@"%f",KProjectScreenWidth];
            self.videoHeigh = [NSString stringWithFormat:@"%f",KProjectScreenWidth / radio];
        }else
        {
            self.videoHeigh = [NSString stringWithFormat:@"%f",KProjectScreenWidth];
            self.videoWidth = [NSString stringWithFormat:@"%f",KProjectScreenWidth * radio];
        }
     }else
     {
         self.videoWidth = @"0";
         self.videoHeigh = @"0";
     }
}




@end
