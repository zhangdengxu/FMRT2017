//
//  FMPlaceOrderViewController.m
//  fmapp
//
//  Created by runzhiqiu on 16/4/23.
//  Copyright © 2016年 yk. All rights reserved.
//
#define KdefaultButtonColorAlpha 0.6
#import "FMPlaceOrderViewController.h"
#import "FMRTWellStoreViewController.h"
//#import "XZConfirmOrderViewController.h"
#import "FMShoppingListViewController.h"
#import "FMMessageAlterView.h"
#import "FMPlaceOrderTabbar.h"
#import "FMPlaceOrderHeaderView.h"

#import "XMSegmentMenuVc.h"
#import "XMShopCommentViewController.h"
#import "FMShopDetailWebView.h"
#import "WLMessageViewController.h"
#import "FMShopSpecModel.h"
#import "FMButtonStyleModel.h"
#import "LWImageBrowserModel.h"
#import "LWImageBrowser.h"

#import "FMShoppingListModel.h"
#import "FMPriceModel.h"

#import "FMShowShopActivity.h"
#import "FMShopOtherModel.h"

#import "FMGoodShopURL.h"
#import "FMGoodShopURLManage.h"

#import "FMShoppingListShareView.h"

#import "UMSocialData.h"
#import "UMSocialConfig.h"
#import "UMSocialControllerService.h"
#import "UMSocialSnsPlatformManager.h"
#import "Fm_Tools.h"
#import "FMShoppingListScanView.h"
#import "FMShopOtherModel.h"

#import "FMShowShopPriceActivity.h"

#import "FMGoodsShopSelectShopView.h"
#import "AppDelegate.h"
#import "FMShopStandardController.h"
#import "XZOptimalMallSubmitOrderController.h" // 优商城确认订单
#import "XZIntegralConfirmOrderController.h" // 积分兑换确认订单
#import "FMRTWellStoreViewController.h"


@interface FMPlaceOrderViewController ()<UIScrollViewDelegate,FMMessageAlterViewDelegate,FMShopDetailWebViewDelegate,XMShopCommentViewControllerDelegate,XMSegmentMenuVcDelegate,UMSocialUIDelegate,UIWebViewDelegate,FMShopStandardControllerDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, weak) UIView * titleContentView;
@property (nonatomic, strong) NSMutableArray * titleDataSource;
@property (nonatomic, strong) NSMutableArray * lookLargeImage;
@property (nonatomic, strong) NSMutableArray * priceShopArray;
@property (nonatomic, strong) FMPlaceOrderHeaderView * placeorderHeader;
@property (nonatomic, strong) XMSegmentMenuVc *segmentMenuVc;
@property (nonatomic, weak) FMPlaceOrderTabbar * tabbar;

//控制器
@property (nonatomic, weak)  XMShopCommentViewController * shopComment;
@property (nonatomic, weak)  FMShopDetailWebView * shopDetail;
@property (nonatomic, weak)  FMShopStandardController * shopStandard;


//选定商品
@property (nonatomic, strong) FMSelectShopInfoModel * shopDetailModel;

//当前选中控制器

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) FMShoppingListShareView *shareView;


@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UIButton * retButton;
@property (nonatomic, strong) UIButton * shopingCartButton;
@property (nonatomic, strong) UIButton * messageButton;


@property (nonatomic, assign) BOOL isChangeValue;
//@property (nonatomic,copy) NSString *video;
@property (nonatomic, strong) FMShopDetailVideoModel * videoModel;

@property (nonatomic, assign) BOOL showNavigationBar;


@property (nonatomic, strong) NSMutableArray * dataSourceWithMiddle;
@end

@implementation FMPlaceOrderViewController


-(void)dealloc
{
    
    _segmentMenuVc = nil;
}

-(NSMutableArray *)dataSourceWithMiddle
{
    if (!_dataSourceWithMiddle) {
        _dataSourceWithMiddle = [NSMutableArray array];
    }
    return _dataSourceWithMiddle;
}

-(NSMutableArray *)priceShopArray
{
    if (!_priceShopArray) {
        _priceShopArray = [NSMutableArray array];
    }
    return _priceShopArray;
}
-(XMSegmentMenuVc *)segmentMenuVc
{
    if (!_segmentMenuVc) {
        
        
        UIFont * titleFont;
        if (KProjectScreenWidth != 320) {
            titleFont = [UIFont systemFontOfSize:15.0];
        }else
        {
            titleFont = [UIFont systemFontOfSize:15.0];
        }
        
        CGSize sizeTitle = [self.shopDetailModel.title getStringCGSizeWithMaxSize:CGSizeMake(KProjectScreenWidth - 25, MAXFLOAT) WithFont:titleFont];
        CGFloat heighHeaderView;
        if (self.shopDetailModel.isLoadActivity) {
            heighHeaderView = KProjectScreenWidth * 0.9375 + 8 + sizeTitle.height + 8 + KDefauletCellItemLargeHeigh + 5 + KDefauletCellItemLittleHeigh + 5 + KDefauletCellItemLargeHeigh + 8 + KDefauletCellItemLargeHeigh  ;
            
        }else
        {
            heighHeaderView = KProjectScreenWidth * 0.9375 + 8 + sizeTitle.height + 8 + KDefauletCellItemLargeHeigh + 5 + KDefauletCellItemLittleHeigh + 5 + KDefauletCellItemLargeHeigh;
            
        }
        if (self.shopDetailModel.brief.length > 0) {
            
            CGFloat fontSize = 12;
            if (KProjectScreenWidth != 320) {
                fontSize = 12.0;
            }else
            {
                fontSize = 11.0;
            }
            CGRect  rect = [self.shopDetailModel.brief boundingRectWithSize:CGSizeMake(KProjectScreenWidth - 24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
            
            heighHeaderView += rect.size.height + 3;
        }
        
        if(self.shopDetailModel.unselectInfo.length > 0)
        {
            
            
        }else
        {
            heighHeaderView = heighHeaderView - KDefauletCellItemLargeHeigh;
        }
        

        _segmentMenuVc = [[XMSegmentMenuVc alloc]initWithFrame:CGRectMake(0, heighHeaderView, self.view.frame.size.width, 45)];
        _segmentMenuVc.delegate = self;
        
        [self.scrollView addSubview:_segmentMenuVc];
        
        /* 自定义设置(可不设置为默认值) */
        _segmentMenuVc.backgroundColor = [UIColor whiteColor];
        _segmentMenuVc.titleFont = [UIFont systemFontOfSize:16.0];
        _segmentMenuVc.selectTitleFont = [UIFont systemFontOfSize:16.0];
        _segmentMenuVc.unlSelectedColor = [HXColor colorWithHexString:@"#1e1e1e" ];
        _segmentMenuVc.selectedColor = [HXColor colorWithHexString:@"#003d90"];
        _segmentMenuVc.MenuVcSlideType = WJSegmentMenuVcSlideTypeSlide;
        _segmentMenuVc.SlideColor = [HXColor colorWithHexString:@"#003d90"];
        _segmentMenuVc.advanceLoadNextVc = YES;
        
        
        NSArray * muarray;
        
        XMShopCommentViewController * shopComment = [[XMShopCommentViewController alloc]init];
        shopComment.goods_id = self.shopDetailModel.gid;
        shopComment.delegate = self;
        self.shopComment = shopComment;
        FMShopDetailWebView * shopDetail = [[FMShopDetailWebView alloc]init];
        if (self.videoModel) {
            shopDetail.videoModel = self.videoModel;
        }
        self.shopDetail = shopDetail;
        shopDetail.delegate = self;
        
        if (self.dataSourceWithMiddle.count > 0) {
            
            FMShopStandardController * shopStandard = [[FMShopStandardController alloc]init];
            shopStandard.dataSource = self.dataSourceWithMiddle;
            shopStandard.delegate = self;
            self.shopStandard = shopStandard;
            muarray = @[shopDetail,shopStandard,shopComment];
            
            
        }else
        {
            muarray = @[shopDetail,shopComment];
        }
        
        
        /* 导入数据 */
        [_segmentMenuVc addSubVc:muarray subTitles:self.titleDataSource];
        
        self.scrollView.contentSize = CGSizeMake(KProjectScreenWidth, CGRectGetMaxY(_segmentMenuVc.frame) + KProjectScreenHeight - 49 - 64 - 45);
        self.currentIndex = 0;
        self.scrollView.delegate = self;
        
    }
    return _segmentMenuVc;
}

-(FMPlaceOrderHeaderView *)placeorderHeader
{
    if (!_placeorderHeader) {
        __weak __typeof(&*self)weakSelf = self;
        _placeorderHeader = [[FMPlaceOrderHeaderView alloc]init];
        
        _placeorderHeader.block = ^(UIButton * button){
            [weakSelf titleContentButtonOnClick:button];
        };
        _placeorderHeader.itemBlock = ^(NSInteger index){
            [weakSelf imageSDCycleItemOnClick:index];
        };
        
        [self.scrollView addSubview:_placeorderHeader];
    }
    return _placeorderHeader;
}

-(FMSelectShopInfoModel *)shopDetailModel
{
    
    if (!_shopDetailModel) {
        _shopDetailModel = [[FMSelectShopInfoModel alloc]init];
        _shopDetailModel.selectCount = 1;
        _shopDetailModel.isAllShopInfo = NO;
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

-(NSMutableArray *)titleDataSource
{
    if (!_titleDataSource) {
        
        NSArray * title;
        if (self.dataSourceWithMiddle.count > 0) {
            title = @[@"商品详情",@"产品参数",@"用户评价"];
        }else
        {
            title = @[@"商品详情",@"用户评价"];
        }
        
        _titleDataSource = [NSMutableArray arrayWithArray:title];
    }
    return _titleDataSource;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.showNavigationBar = NO;
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
}
- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:(230.0/255) green:(234.0/255) blue:(241.0/255) alpha:1];
    
    
    [self createUITabBar];
    [self createMainScrollView];
    [self createUINavigation];
    [self getDataSourceFromNetWork];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    //[self delloALLDate];
    
    if (!self.showNavigationBar) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
     
    
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)viewDidDisappear:(BOOL)animated
{
    if (!self.showNavigationBar) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
    

    [super viewDidDisappear:animated];

}

-(void)createUINavigation
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UIView * titleContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 64)];
    self.titleContentView = titleContentView;
    titleContentView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    [self.view addSubview:titleContentView];
    [self.view bringSubviewToFront:titleContentView];
    
    
    UIView * statusView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, KProjectScreenWidth, 44)];
    statusView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:statusView];
    [self.view bringSubviewToFront:statusView];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 43.5, KProjectScreenWidth, 0.5)];
    self.lineView = lineView;
    lineView.backgroundColor = [UIColor colorWithRed:(229/255.0) green:(233/255.0) blue:(242/255.0) alpha:0];
    [statusView addSubview:lineView];
    
    
    UIButton * retButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 7, 30, 30)];
    self.retButton = retButton;
    retButton.tag = 500;
    retButton.center = CGPointMake(retButton.center.x, statusView.frame.size.height * 0.5);
    retButton.layer.cornerRadius = 15.0;
    
    [retButton setBackgroundImage:[UIImage imageNamed:@"返回商品详情白色"] forState:UIControlStateNormal];
    [retButton addTarget:self action:@selector(titleContentButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [statusView addSubview:retButton];
    
    UIButton * shopingCartButton = [[UIButton alloc]initWithFrame:CGRectMake(titleContentView.bounds.size.width - 30 - 30 - 15 - 15, 7, 30, 30)];
    self.shopingCartButton = shopingCartButton;
    shopingCartButton.tag = 501;
    shopingCartButton.center = CGPointMake(shopingCartButton.center.x,  statusView.frame.size.height * 0.5);
    shopingCartButton.layer.cornerRadius = 15.0;
    
    [shopingCartButton setBackgroundImage:[UIImage imageNamed:@"购物车商品详情白色"] forState:UIControlStateNormal];
    [shopingCartButton addTarget:self action:@selector(titleContentButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [statusView addSubview:shopingCartButton];
    
    
    UIButton * messageButton = [[UIButton alloc]initWithFrame:CGRectMake(titleContentView.bounds.size.width - 30 - 15, 7, 30, 30)];
    self.messageButton = messageButton;
    messageButton.tag = 502;
    messageButton.center = CGPointMake(messageButton.center.x,  statusView.frame.size.height * 0.5);
    messageButton.layer.cornerRadius = 15.0;
    
    [messageButton setBackgroundImage:[UIImage imageNamed:@"消息商品详情白色"] forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(titleContentButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [statusView addSubview:messageButton];
    
    retButton.backgroundColor = [UIColor colorWithWhite:0 alpha:KdefaultButtonColorAlpha];
    messageButton.backgroundColor = [UIColor colorWithWhite:0 alpha:KdefaultButtonColorAlpha];
    shopingCartButton.backgroundColor = [UIColor colorWithWhite:0 alpha:KdefaultButtonColorAlpha];
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}


-(void)createMainScrollView
{
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 49)];
    [self.view addSubview:scrollView];
    scrollView.backgroundColor = [UIColor colorWithRed:(230.0/255) green:(234.0/255) blue:(241.0/255) alpha:1];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    self.scrollView = scrollView;
    
    //    [self.view sendSubviewToBack:scrollView];
    scrollView.contentSize = CGSizeMake(KProjectScreenWidth, CGRectGetMaxY(self.placeorderHeader.frame));
    
    CGFloat returTopView_width = 35;
    UIButton * returTopView = [[UIButton alloc]initWithFrame:CGRectMake(KProjectScreenWidth - returTopView_width - 5, self.view.frame.size.height -135, returTopView_width, returTopView_width)];
    [returTopView setBackgroundImage:[UIImage imageNamed:@"返回顶部"] forState:UIControlStateNormal];
    [returTopView addTarget:self action:@selector(controlScrollViewLocationButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returTopView];
    [self.view bringSubviewToFront:returTopView];
    
    
    UIButton *telBtn = [[UIButton alloc]initWithFrame:CGRectMake(KProjectScreenWidth - returTopView_width - 5, self.view.frame.size.height -135 + returTopView_width + 8, returTopView_width, returTopView_width)];
    [telBtn setImage:[UIImage imageNamed:@"优商城首页_电话_36"] forState:(UIControlStateNormal)];
    [telBtn addTarget:self action:@selector(telBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:telBtn];
    [self.view bringSubviewToFront:telBtn];


    
}

#pragma mark - 电话联系
- (void)telBtnAction{
    UIWebView *webView = [[UIWebView alloc]init];
    NSURL *url = [NSURL URLWithString:@"400-878-8686"];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webView];
}
- (void)controlScrollViewLocationButtonOnClick:(UIButton *)button
{
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.shopComment.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.shopDetail.webView.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(void)createUITabBar
{
    __weak __typeof(&*self)weakSelf = self;
    FMPlaceOrderTabbar * tabbar = [[FMPlaceOrderTabbar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49)];
    self.tabbar = tabbar;
    tabbar.block = ^(UIButton * button)
    {
        [weakSelf titleContentButtonOnClick:button];
    };
    [self.view addSubview:tabbar];
}

- (void)clickShareButton:(UIButton *)sender WithUrl:(NSString *)shareURL{
    
    // 微信好友
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString retStringWithPlatform:shareURL withPlatform:@"weixin"];
    // 朋友圈
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString retStringWithPlatform:shareURL withPlatform:@"wxcircle"];
    // QQ
    [UMSocialData defaultData].extConfig.qqData.url = [NSString retStringWithPlatform:shareURL withPlatform:@"qq"];
    // 新浪微博
    [UMSocialData defaultData].extConfig.sinaData.urlResource.url = [NSString retStringWithPlatform:shareURL withPlatform:@"sina"];
    // QQ空间
    [UMSocialData defaultData].extConfig.qzoneData.url = [NSString retStringWithPlatform:shareURL withPlatform:@"qzone"];
    
    [UMSocialConfig setFinishToastIsHidden:YES  position:UMSocialiToastPositionCenter];
    
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[self.placeorderHeader.shopImageUrl  firstObject]]];
    
    switch (sender.tag) {
        case 2110:
        {
            //x
            self.shareView.hidden = YES;
            break;
        }
        case 2111:
        {
            //复制链接
            UIPasteboard *board = [UIPasteboard generalPasteboard];
            board.string = shareURL;
            ShowAutoHideMBProgressHUD(self.view, @"已将连接复制到粘贴板");
            break;
        }
        case 2112:
        {
            //二维码
            self.shareView.hidden = YES;
            [self clickShareQRImageWith:shareURL];
            break;
        }
        case 2113:
        {
            
            //微博
            [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"%@%@",self.shopDetailModel.title,shareURL] shareImage:data socialUIDelegate:self];        //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            
            break;
        }
        case 2114:
        {
            //QQ
            
            [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"%@%@",self.shopDetailModel.title,shareURL] shareImage:data socialUIDelegate:self];        //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            
            break;
        }
        case 2115:
        {
            
            [UMSocialData defaultData].extConfig.wechatSessionData.title = self.shopDetailModel.title;
            [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"%@%@",self.shopDetailModel.title,shareURL] shareImage:data socialUIDelegate:self];        //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            
            break;
        }
        case 2116:
        {
            
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.shopDetailModel.title;
            [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"%@%@",self.shopDetailModel.title,shareURL] shareImage:data socialUIDelegate:self];        //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            
            break;
        }
        default:
            break;
    }
}

- (void)clickShareQRImageWith:(NSString *)shareURL{
    
    //www.qdygo.com/jili/index.php/home/login/shareallpro?chanpinji="1420,14259,12369"
    
    self.shareView.hidden = YES;
    
    UIImage *QRImage = [Fm_Tools QRcodeWithUrlString:shareURL];
    UIImage *plaxImage = [Fm_Tools addIconToQRCodeImage:QRImage withIcon:[UIImage imageNamed:@"二维码小图片"] withScale:6];
    
    FMShoppingListScanView *scanView = [[FMShoppingListScanView alloc]initWithData:[NSMutableArray arrayWithObject:[self.placeorderHeader.shopImageUrl firstObject]]count:1 withQRImage:plaxImage];
    __weak typeof (self)weakSelf = self;
    scanView.block = ^(NSError *error){
        if(error != NULL){
            ShowAutoHideMBProgressHUD(weakSelf.view, @"二维码图片保存失败");
        }else{
            ShowAutoHideMBProgressHUD(weakSelf.view, @"二维码图片已保存至相册");
        }
    };
    [self.view addSubview:scanView];
    [scanView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        ShowAutoHideMBProgressHUD(self.view,@"分享成功");

    }
}
-(void)delloALLDate;
{
    self.scrollView.delegate = nil;
    _shopDetail.delegate = nil;
    _shopComment.delegate = nil;
    _shopStandard.delegate = nil;
    _segmentMenuVc.delegate = nil;
    
    
    [_shopDetail disTroyVideo];
    [_shopComment disTroyVideo];
    [_shopStandard disTroyVideo];
    
    [_shopDetail removeFromParentViewController];
    [_shopStandard removeFromParentViewController];
    [_shopComment removeFromParentViewController];
    
    [_segmentMenuVc disTroyALLDate];
    
    
    _shopComment = nil;
    _shopStandard = nil;
    _shopDetail = nil;
    
    
    _segmentMenuVc = nil;

}


-(void)titleContentButtonOnClick:(UIButton *)button
{
    __weak __typeof(&*self)weakSelf = self;
    switch (button.tag - 500) {
        case 0:
        {
            [self delloALLDate];
        
            
            [self.navigationController popViewControllerAnimated:YES];
            
            
            
            
        }
            break;
        case 1:
        {
            
            
            if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) { // 已登录
                
            
                
                
            }else { // 未登录
                LoginController *registerController = [[LoginController alloc] init];
                FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
                [self.navigationController presentViewController:navController animated:YES completion:^{
                }];
                return;
            }
            

            
            FMShoppingListViewController * shopList = [[FMShoppingListViewController alloc]init];
            shopList.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:shopList animated:YES];
            
        }
            break;
        case 2:
        {
            
            FMMessageModel *one = [[FMMessageModel alloc] initWithTitle:@"消息" imageName:@"优商城消息-消息04" isShowRed:NO];
            FMMessageModel *two = [[FMMessageModel alloc] initWithTitle:@"首页" imageName:@"优商城消息-消息03"  isShowRed:NO];
            NSArray * dataArr = @[one, two];
            
            __block  FMMessageAlterView * messageAlter = [[FMMessageAlterView alloc] initWithDataArray:dataArr origin:CGPointMake(KProjectScreenWidth - 15, 64) width:100 height:40 direction:kFMMessageAlterViewDirectionRight];
            messageAlter.delegate = self;
            messageAlter.dismissOperation = ^(){
                //设置成nil，以防内存泄露
                messageAlter = nil;
            };
            [messageAlter pop];
            
        }
            break;
        case 50:
        {
            //客服
            
            
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
                
                UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
                NSURL *url = [NSURL URLWithString:@"mqq://im/chat?chat_type=wpa&uin=2718534215&version=1&src_type=web"];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                webView.delegate = self;
                [webView loadRequest:request];
                [self.view addSubview:webView];
                
            }else{
                
                UIAlertView * alter = [[UIAlertView alloc]initWithTitle:@"打开客服提醒" message:@"您尚未安装QQ，请安装QQ后重试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alter show];
                return;
            }
            
            
            
        }
            break;
        case 51:
        {
            
            //分享
            
            
            if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) { // 已登录
               
            }else { // 未登录
                LoginController *registerController = [[LoginController alloc] init];
                FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
                [self.navigationController presentViewController:navController animated:YES completion:^{
                }];
                return;
            }
            
            
            NSString *shareURL ;
            
            if (self.shopDetailModel.fulljifen_ex && ![self.shopDetailModel.fulljifen_ex isMemberOfClass:[NSNull class]]&&[self.shopDetailModel.fulljifen_ex integerValue]!=0) {
                 shareURL = [NSString stringWithFormat:@"http://www.qdygo.com/wap/product/share/%@.html?flag=11",self.shopDetailModel.product_id];
            }else
            {
                 shareURL = [NSString stringWithFormat:@"http://www.qdygo.com/wap/product/share/%@.html?flag=4",self.shopDetailModel.product_id];
            }
            
           
            
            self.shareView = [[FMShoppingListShareView alloc]init];
            [self.view addSubview:self.shareView];
            __weak typeof (self)weakSelf = self;
            self.shareView.block = ^(UIButton *sender){
                [weakSelf clickShareButton:sender WithUrl:shareURL];
            };
            [self.shareView makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
            
        }
            break;
        case 52:
        {
            
            if (self.shopDetailModel.fulljifen_ex && ![self.shopDetailModel.fulljifen_ex isMemberOfClass:[NSNull class]]&&[self.shopDetailModel.fulljifen_ex integerValue]!=0) {
                
                ShowAutoHideMBProgressHUD(self.view, @"积分商品无法加入收藏");
                return;
            }
            
            if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) { // 已登录
                
            }else { // 未登录
                LoginController *registerController = [[LoginController alloc] init];
                FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
                [self.navigationController presentViewController:navController animated:YES completion:^{
                }];
                return;
            }
           

            //收藏
            button.selected = !button.selected;
            //选中后的操作
            
            if (button.selected) {
                //加入收藏
                NSString * baseUrl = [FMGoodShopURLManage getNewNetWorkURLWithBaseURL:KGoodShop_ShopDetail_AddFavirist_Url];
                
                NSDictionary * parames = @{@"gid":self.shopDetailModel.gid};
                
                
                [FMHTTPClient postPath:baseUrl parameters:parames completion:^(WebAPIResponse *response) {
                    if (response.code == WebAPIResponseCodeSuccess) {
                        ShowAutoHideMBProgressHUD(weakSelf.view,response.responseObject[@"msg"]);
                        
                    }
                    
                }];
                
            }else
            {
                
                if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) { // 已登录
                    
                }else { // 未登录
                    LoginController *registerController = [[LoginController alloc] init];
                    FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
                    [self.navigationController presentViewController:navController animated:YES completion:^{
                    }];
                    return;
                }
                

                //取消加入收藏
                
                NSString * baseUrl = [FMGoodShopURLManage getNewNetWorkURLWithBaseURL:KGoodShop_ShopDetail_DelFavirist_Url];
                NSString * urlString = [NSString stringWithFormat:@"%@&gid=%@",baseUrl,self.shopDetailModel.gid];
                
                [FMHTTPClient getPath:urlString parameters:nil completion:^(WebAPIResponse *response) {
                    if (response.code == WebAPIResponseCodeSuccess) {
                        ShowAutoHideMBProgressHUD(weakSelf.view,response.responseObject[@"data"]);
                        
                    }
                    
                    
                    
                }];
                
            }
            
        }
            break;
        case 53:
        {
            
            if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) { // 已登录
                
                UIButton * buyCar = (UIButton *)[self.tabbar viewWithTag:553];
                if (![self firstColor:buyCar.backgroundColor secondColor:[HXColor colorWithHexString:@"#0159d5"]]) {
                    //不能点击
                    ShowAutoHideMBProgressHUD(self.view, @"积分商品无法加入购物车");
                    return;
                }
                
                
            }else { // 未登录
                LoginController *registerController = [[LoginController alloc] init];
                FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
                [self.navigationController presentViewController:navController animated:YES completion:^{
                }];
                return;
            }
            

            //加入购物车  tag1000代表加入购物车
            
            [self addCarButtonOnClickWithTag:1000];
            
            
        }
            break;
        case 54:
        {
            
            if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) { // 已登录
                
            }else { // 未登录
                LoginController *registerController = [[LoginController alloc] init];
                FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
                [self.navigationController presentViewController:navController animated:YES completion:^{
                }];
                return;
            }
            

            // 立即购买 tag1001代表立即购买
            [self addCarButtonOnClickWithTag:1001];
            
            
        }
            break;
        case 70:
        {
            if (self.shopDetailModel.product_id) {
                [self selectShopStyleView:1001];
            }
        }
            break;
        case 71:
        {
            //优惠促销
            FMShopOtherModel * model1 = [[FMShopOtherModel alloc]init];
            model1.imageTitle = @"免邮";
            model1.contentString = @"购买商品满200元时即可享受免邮";
            
            FMShopOtherModel * model2 = [[FMShopOtherModel alloc]init];
            model2.imageTitle = @"限免";
            model2.contentString = @"购买一件享受优惠";
            
            FMShopOtherModel * model3 = [[FMShopOtherModel alloc]init];
            model3.imageTitle = @"买二赠一";
            model3.contentString = @"购买两件件享受优惠";
            
            
            FMShowShopActivity * activity = [[FMShowShopActivity alloc]init];
            [activity changeActivityViewTitle:@"优惠促销" andCloseTitle:@"关闭"];
            activity.dataSource = @[model1,model2,model3];
            [activity showActivity];
            
            
        }
            break;
        case 72:
        {
            //商品详情
            
            
        }
            break;
        case 73:
        {
            //用户评价
            
            
            
        }
            break;
        case 90:
        {
            //查看更多价格
            //            NSLog(@"查看更多价格");
            if (self.priceShopArray.count > 0) {
                FMShowShopPriceActivity * priceActivity = [[FMShowShopPriceActivity alloc]init];
                priceActivity.dataSource = self.priceShopArray;
                [priceActivity showActivity];
            }
            
        }
            break;
        default:
            break;
    }
}


-(void)addCarButtonOnClickWithTag:(NSInteger )tag
{
    if (tag == 1001) {
        //如果是立即购买的情况下
        if (self.shopDetailModel.isAllShopInfo) {
            [self shouldbuyShopInfoFunction];
            return;
        }
    }
   
    [self selectShopStyleView:tag];
    
}
-(void)selectShopStyleView:(NSInteger)tag;
{
    FMButtonStyleModel * buttonThree = [[FMButtonStyleModel alloc]init];
    buttonThree.title = @"确定";
    buttonThree.textFont = 15;
    buttonThree.titleColor = [UIColor whiteColor];
    buttonThree.backGroundColor = [HXColor colorWithHexString:@"#003d90"];
    buttonThree.tag = tag;
    
    FMGoodsShopSelectShopView * shopView = [[FMGoodsShopSelectShopView alloc]init];
    
    shopView.product_id = self.product_id;
    shopView.isShowCount = YES;
    
    
    shopView.buttonArray = @[buttonThree];
    
    shopView.isShopFullScore = self.isShopFullScore;
    
    
    if (self.shopDetailModel.locationArray && (self.shopDetailModel.locationArray.count > 0)) {
        shopView.lastLocationArray = self.shopDetailModel.locationArray;
    }
    
    shopView.lastSelectCount = self.shopDetailModel.selectCount;
    
    __weak __typeof(&*self)weakSelf = self;
    shopView.successNewBlock = ^(FMSelectShopModelNew * selectModel,NSInteger buttonTag){
        [weakSelf jumpConfirmShopController:selectModel withInteger:buttonTag];
    };
    shopView.closeBlock = ^(FMSelectShopModelNew * selectModel){
        
        [weakSelf closeSelectView:selectModel];
    };
    
    shopView.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.15];
    self.definesPresentationContext = YES;
    //源Controller中跳转方法实现
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
        self.showNavigationBar = YES;
        
        
        shopView.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        [weakSelf.navigationController presentViewController:shopView animated:NO completion:^{
        }];
        
        
    } else {
        
        self.showNavigationBar = YES;
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        appdelegate.window.rootViewController.modalPresentationStyle=UIModalPresentationCurrentContext;
        [appdelegate.window.rootViewController presentViewController:shopView animated:YES completion:^{
            shopView.view.backgroundColor=[UIColor clearColor];
            appdelegate.window.rootViewController.modalPresentationStyle=UIModalPresentationFullScreen;
        }];
    }

}


//选择样式后的回掉。
-(void)jumpConfirmShopController:(FMSelectShopModelNew *)selectModel withInteger:(NSInteger)tag
{
    
    __block NSInteger blockTag = tag;
    self.showNavigationBar = NO;
    [self changeSelfShopDetailModelWith:selectModel];
    
    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) { // 已登录
        [self fromWithSelectShopStyleView:tag];
        
    }else { // 未登录
        
        LoginController *registerController = [[LoginController alloc] init];
        __weak __typeof(&*self)weakSelf = self;

        registerController.successBlock = ^(){
            
            [weakSelf fromWithSelectShopStyleView:blockTag];
            
        };
        FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
        [self.navigationController presentViewController:navController animated:YES completion:^{
            
        }];
        return;
    }
    
 
}

-(void)fromWithSelectShopStyleView:(NSInteger)tag
{
    if (self.shopDetailModel.isAllShopInfo) {
        if (tag == 1001) {
            [self shouldbuyShopInfoFunction];
            
        }else if(tag == 1000)
        {
            [self addshopListFunctionWithShowSuccess:YES];
        }
    }
}

-(void)closeSelectView:(FMSelectShopModelNew *)selectModels
{
    self.showNavigationBar = NO;
    [self changeSelfShopDetailModelWith:selectModels];
}
-(void)changeSelfShopDetailModelWith:(FMSelectShopModelNew *)selectModel
{
    if (selectModel) {
        self.shopDetailModel.product_id = selectModel.product_id;
        self.shopDetailModel.image = selectModel.image;
        //        self.shopDetailModel.price = selectModel.price;
        self.shopDetailModel.locationArray = selectModel.locationArray;
        self.shopDetailModel.currentStyle = selectModel.currentStyle;
        self.shopDetailModel.store = selectModel.store;
        self.shopDetailModel.selectCount = selectModel.selectCount;
        self.shopDetailModel.isAllShopInfo = selectModel.isAllShopInfo;
        self.shopDetailModel.unselectInfo = selectModel.unselectInfo;
        
        self.placeorderHeader.shopDetailModel = self.shopDetailModel;

    }
    
}



//加入购物车
-(void)addshopListFunctionWithShowSuccess:(BOOL)isShow
{
    if (!(self.shopDetailModel.store || [self.shopDetailModel.store isMemberOfClass:[NSNull class]])) {
        ShowAutoHideMBProgressHUD(self.view,@"未获取到库存，请重试");
        return;
    }
    if (!([self.shopDetailModel.store integerValue] > 0 )) {
        ShowAutoHideMBProgressHUD(self.view,@"该商品没有库存");
        return;
    }
    //isShow是否显示msg／／msg代表直接加入购物车，而不是通过先加购物车再购买。
    if (isShow) {
        if (!self.shopDetailModel.isAllShopInfo) {
            [self addCarButtonOnClickWithTag:1000];
            
            return;
        }
    }
    //积分兑换的直接去换；
    if (self.shopDetailModel.fulljifen_ex && ![self.shopDetailModel.fulljifen_ex isMemberOfClass:[NSNull class]]&& [self.shopDetailModel.fulljifen_ex integerValue]!=0) {
        [self buyshopInfoAfterAddShupList];
        return;
    }
    
    
    __weak __typeof(&*self)weakSelf = self;
    //购物车
    NSString * baseUrl = [FMGoodShopURLManage getNewNetWorkURLWithBaseURL:KGoodShop_ShopDetail_AddShopList_Url];
    NSString * currentUrl;
    if (isShow) {
        currentUrl = [NSString stringWithFormat:@"%@&goods[goods_id]=%@&goods[product_id]=%@&goods[num]=%@&mini_cart=%@",baseUrl,self.shopDetailModel.gid,self.shopDetailModel.product_id,[NSNumber numberWithInteger:self.shopDetailModel.selectCount],@1];
    }else{
        currentUrl = [NSString stringWithFormat:@"%@&goods[goods_id]=%@&goods[product_id]=%@&goods[num]=%@&mini_cart=%@&btype=is_fastbuy",baseUrl,self.shopDetailModel.gid,self.shopDetailModel.product_id,[NSNumber numberWithInteger:self.shopDetailModel.selectCount],@1];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient getPath:currentUrl parameters:nil completion:^(WebAPIResponse *response) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (response.code == WebAPIResponseCodeSuccess) {
            
            NSDictionary * dict = response.responseObject[@"data"];
            self.shopDetailModel.md5_cart_info = dict[@"md5_cart_info"];
            self.shopDetailModel.sess_id = dict[@"sess_id"];
            if (isShow) {
                ShowAutoHideMBProgressHUD(weakSelf.view,response.responseObject[@"msg"]);
            }else
            {
                [self buyshopInfoAfterAddShupList];
            }
            
            
        }else if(response.code == WebAPIResponseCodeFailed){
            
           
                ShowAutoHideMBProgressHUD(weakSelf.view,response.responseObject[@"msg"]);
            
            
            
        }else
        {
            
                ShowAutoHideMBProgressHUD(weakSelf.view,@"网络错误");
            
            
            
        }
        
    }];
    
}
-(void)buyshopInfoAfterAddShupList
{
    if (self.isShopFullScore == 0) {
        if (!self.shopDetailModel.sess_id) {
            UIWindow * window = [UIApplication sharedApplication].keyWindow;
            ShowAutoHideMBProgressHUD(window, @"参数错误，请重试");
            return;
        }
    }
   
    
    FMShoppingListModel * shopModel = [[FMShoppingListModel alloc]init];
    shopModel.sess_id = self.shopDetailModel.sess_id;
    shopModel.md5_cart_info = self.shopDetailModel.md5_cart_info;
    shopModel.image = self.shopDetailModel.image;
    shopModel.name = self.shopDetailModel.title;
    shopModel.product_id = self.shopDetailModel.product_id;
    shopModel.goods_id = self.shopDetailModel.gid;
    shopModel.oldPrice = self.shopDetailModel.mktPrice;
    shopModel.currentStyle = self.shopDetailModel.currentStyle;
    shopModel.selectCount = self.shopDetailModel.selectCount;
    shopModel.fulljifen_ex = self.shopDetailModel.fulljifen_ex;
    FMPriceModel * priceModel = [[FMPriceModel alloc]init];
    priceModel.price = self.shopDetailModel.price;
    shopModel.price = priceModel;
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:@[shopModel]];
    
//    XZConfirmOrderViewController * confirm = [[XZConfirmOrderViewController alloc]init];
//    confirm.shopDataSource = array;
//    confirm.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:confirm animated:YES];
    //  积分兑换
    if (shopModel.fulljifen_ex && ![shopModel.fulljifen_ex isKindOfClass:[NSNull class]] && [self.shopDetailModel.fulljifen_ex integerValue]!=0) {
        // 积分兑换的确认订单
        XZIntegralConfirmOrderController *integralConfirm = [[XZIntegralConfirmOrderController alloc] init];
        integralConfirm.shopDataSource = array;
        integralConfirm.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:integralConfirm animated:YES];
    }else {
        // 优商城的确认订单
        XZOptimalMallSubmitOrderController *submitOrder = [[XZOptimalMallSubmitOrderController alloc]init];
        submitOrder.shopDataSource = array;
        submitOrder.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:submitOrder animated:YES];
    }
}
//立即购买
-(void)shouldbuyShopInfoFunction
{
    if (!self.shopDetailModel.isAllShopInfo) {
        if (self.shopDetailModel.product_id) {
            [self addCarButtonOnClickWithTag:1001];
        }else
        {
            ShowAutoHideMBProgressHUD(self.view, @"参数错误，请稍后重试");
        }
    }else{
        [self addshopListFunctionWithShowSuccess:NO];
    }
    
}


- (void)didSelectedAtIndexPath:(NSIndexPath *)indexPath;
{
    
    if (indexPath.row == 0) {
        if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) { // 已登录
            
        }else { // 未登录
            LoginController *registerController = [[LoginController alloc] init];
            FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
            [self.navigationController presentViewController:navController animated:YES completion:^{
            }];
            return;
        }
        WLMessageViewController *wlVc = [[WLMessageViewController alloc]init];
        wlVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wlVc animated:YES];
    }else
    {
        self.showNavigationBar = YES;
        FMRTWellStoreViewController * rootViewController;
        for (UIViewController * viewController in self.navigationController.viewControllers) {
            if ([viewController isKindOfClass:[FMRTWellStoreViewController class]]) {
                rootViewController = (FMRTWellStoreViewController *)viewController;
            }
        }
        if (rootViewController) {
            self.navigationController.navigationBarHidden = NO;
            [self.navigationController popToViewController:rootViewController animated:NO];
        }else
        {
            if (self.goToGoodShopIndex > 0) {
                FMRTWellStoreViewController * goodShop = [[FMRTWellStoreViewController
                                                           alloc]init];
                goodShop.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:goodShop animated:YES];
            }else
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        
    }
}

-(void)changeColorForStatusView:(CGFloat)radioAlpha
{
    if (radioAlpha > 1) {
        radioAlpha = 1;
    }
    self.titleContentView.backgroundColor  = [UIColor colorWithWhite:1 alpha:radioAlpha];
    self.lineView.backgroundColor = [UIColor colorWithRed:(229/255.0) green:(233/255.0) blue:(242/255.0) alpha:radioAlpha];
    CGFloat backAlpha = (1 - radioAlpha) * KdefaultButtonColorAlpha;
    
    self.retButton.backgroundColor = [UIColor colorWithWhite:0 alpha:backAlpha];
    self.messageButton.backgroundColor = [UIColor colorWithWhite:0 alpha:backAlpha];
    self.shopingCartButton.backgroundColor = [UIColor colorWithWhite:0 alpha:backAlpha];
    
    
    if (backAlpha < 0.15 ) {
        //改变图片
        if (!self.isChangeValue) {
            
            [self.retButton setBackgroundImage:[UIImage imageNamed:@"返回商品详情黑色"] forState:UIControlStateNormal];
            
            [self.messageButton setBackgroundImage:[UIImage imageNamed:@"消息商品详情黑色"] forState:UIControlStateNormal];
            
            [self.shopingCartButton setBackgroundImage:[UIImage imageNamed:@"购物车商品详情黑色"] forState:UIControlStateNormal];
            self.isChangeValue = YES;
        }
    }else
    {
        if (self.isChangeValue) {
            [self.retButton setBackgroundImage:[UIImage imageNamed:@"返回商品详情白色"] forState:UIControlStateNormal];
            
            [self.messageButton setBackgroundImage:[UIImage imageNamed:@"消息商品详情白色"] forState:UIControlStateNormal];
            
            [self.shopingCartButton setBackgroundImage:[UIImage imageNamed:@"购物车商品详情白色"] forState:UIControlStateNormal];
            self.isChangeValue = NO;
        }
        
    }
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.scrollView == scrollView) {
        //滑动标准值
        CGFloat currentScrollY = scrollView.contentOffset.y + (KProjectScreenHeight - 49);
        
        CGFloat radioAlpha = scrollView.contentOffset.y / (scrollView.contentSize.height - KProjectScreenHeight - 50);
        
        [self changeColorForStatusView:radioAlpha];
        
        
        //处理滑动问题
        
        if (currentScrollY > (scrollView.contentSize.height  - 5) && currentScrollY < (scrollView.contentSize.height  + 5)) {
            if (self.currentIndex == 0) {
                if (!self.shopDetail.webView.scrollView.scrollEnabled) {
                    
                    [self.shopDetail.webView.scrollView setScrollEnabled:YES];
                    
                    self.isLetSonViewScroll = YES;
                }
                
            }else if(self.currentIndex == 1)
            {
                if (self.dataSourceWithMiddle.count > 0) {
                    if (!self.shopStandard.tableView.scrollEnabled) {
                        
                        [self.shopStandard.tableView setScrollEnabled:YES];
                        
                        self.isLetSonViewScroll = YES;
                    }
                }else
                {
                    if (!self.shopComment.tableView.scrollEnabled) {
                        
                        [self.shopComment.tableView setScrollEnabled:YES];
                        
                        self.isLetSonViewScroll = YES;
                    }
                }
                
                
                
            }else
            {
                if (!self.shopComment.tableView.scrollEnabled) {
                    
                    [self.shopComment.tableView setScrollEnabled:YES];
                    
                    self.isLetSonViewScroll = YES;
                }
                
            }
            
        }else
        {
            
            if (self.currentIndex == 0) {
                if (self.shopDetail.webView.scrollView.scrollEnabled) {
                    
                    [self.shopDetail.webView.scrollView setScrollEnabled:NO];
                    
                    self.isLetSonViewScroll = NO;
                }
                
            }else if(self.currentIndex == 1)
            {
                if (self.dataSourceWithMiddle.count > 0) {
                    if (self.shopStandard.tableView.scrollEnabled) {
                        
                        [self.shopStandard.tableView setScrollEnabled:NO];
                        
                        self.isLetSonViewScroll = NO;
                    }
                }else
                {
                    if (self.shopComment.tableView.scrollEnabled) {
                        
                        [self.shopComment.tableView setScrollEnabled:NO];
                        
                        self.isLetSonViewScroll = NO;
                    }
                }
                
            }else
            {
                if (self.shopComment.tableView.scrollEnabled) {
                    
                    [self.shopComment.tableView setScrollEnabled:NO];
                    
                    self.isLetSonViewScroll = NO;
                }
            }
            
        }
        
    }
}


-(void)getDataSourceFromNetWork
{
    
    NSString * detailURL =  [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/product/index_client/%@.html",self.product_id];
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter ;
   
    
    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) { // 已登录
         parameter = @{@"appid":@"huiyuan",@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,@"shijian":[NSNumber numberWithInt:timestamp],@"token":tokenlow};
    }
    
    [FMHTTPClient postPath:detailURL parameters:parameter completion:^(WebAPIResponse *response) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (response.code == WebAPIResponseCodeSuccess) {
            NSDictionary * data = response.responseObject[@"data"];
            
            
            
            NSArray * standardDict = data[@"props"];
            NSString * jifenStatus = data[@"type"];
            
            if (![jifenStatus isMemberOfClass:[NSNull class]]) {
                if (jifenStatus.length > 0) {
                    if ([jifenStatus isEqualToString:@"normal"]) {
                        self.isShopFullScore = 0;
                    }else
                    {
                        self.isShopFullScore = 1;
                    }
                }
            }
            
            if (![standardDict isMemberOfClass:[NSNull class]]) {
                if (standardDict.count > 0) {
                    
                    [self.dataSourceWithMiddle removeAllObjects];
                    
                    for (NSDictionary * dictStandard in standardDict) {
                        FMShopStandardModel * shopStandard = [[FMShopStandardModel alloc]init];
                        [shopStandard setValuesForKeysWithDictionary:dictStandard];
                        
                        [self.dataSourceWithMiddle addObject:shopStandard];
                    }
                    
                }
            }
            
            if(![data[@"video_thumb"] isMemberOfClass:[NSNull class]]){
            
                self.shopDetailModel.video_thumb = [NSString stringWithFormat:@"%@",data[@"video_thumb"]];
            }
            
            
            [self changeHeaderViewTitleImages:data[@"images"]];
            
            NSDictionary * product_price = data[@"product_price"];
            
            self.shopDetailModel.store = data[@"store"];
            self.shopDetailModel.fulljifen_ex = data[@"fulljifen_ex"];
            
            if (self.isShopFullScore == 0) {
                self.shopDetailModel.fulljifen_ex = @"0";

            }
            
            
            NSArray * imageArrayWithShopDetail = data[@"images"];
            self.shopDetailModel.product_id = data[@"product_id"];
            self.shopDetailModel.gid = data[@"gid"];
            self.shopDetailModel.price = product_price[@"price"];
            self.shopDetailModel.mktPrice = product_price[@"mktprice"];
            //self.shopDetailModel.unselectInfo = @"请选择商品样式";
            self.shopDetailModel.jifen = data[@"jifen"];
            self.shopDetailModel.brief = data[@"brief"];
            
            
            
            NSDictionary * spec = data[@"spec"];
            NSDictionary * specification = spec[@"specification"];
            NSArray * spec_name = specification[@"spec_name"];
            NSMutableString * stringMu = [[NSMutableString alloc]init];
            [stringMu appendString:@"请选择"];
            for (NSString * baseString in spec_name) {
                [stringMu appendString:[NSString stringWithFormat:@"%@ ",baseString]];
            }
            if (stringMu.length > 3) {
                self.shopDetailModel.unselectInfo = stringMu;
            }
            

            
            
            //获取商品价格列表
            if (product_price[@"mlv_price"]) {
                NSArray * priceArray = product_price[@"mlv_price"];
                if (![priceArray isMemberOfClass:[NSNull class]]) {
                    [self.priceShopArray removeAllObjects];
                    for (NSDictionary * priceDict in priceArray) {
                        NSString * priceString = [NSString stringWithFormat:@"%@ : ¥%@",priceDict[@"name"],priceDict[@"price"]];
                        [self.priceShopArray addObject:priceString];
                    }
                    
                    
                }
            }
            //判断收藏
            NSNumber * favNum = data[@"fav"];
            self.shopDetailModel.fav = [favNum integerValue];
            FMShopDetailVideoModel * videoModel = [[FMShopDetailVideoModel alloc]init];
            videoModel.videoString = data[@"video"];
            videoModel.videoWidth = data[@"videoW"];
            videoModel.videoHeigh = data[@"videoH"];
            videoModel.video_thumb = self.shopDetailModel.video_thumb;
            [videoModel resetVideoWidthAndHeigh];

            self.videoModel = videoModel;//data[@"video"];
            //判断是否有活动
            NSArray * youhui = data[@"youhui"];
            if (youhui.count == 0) {
                //无活动
                self.shopDetailModel.isLoadActivity = NO;
            }else
            {
                //有活动
            }
            if (imageArrayWithShopDetail.count) {
                self.shopDetailModel.image = imageArrayWithShopDetail[0];
            }
            self.shopDetailModel.title = data[@"title"];
            self.placeorderHeader.shopDetailModel = self.shopDetailModel;
            
            [self changeShopDetailWithHtml:data[@"intro_ios"]];
            if (self.shopDetailModel.fav == 1) {
                [self.tabbar collectButtonOnClick];
            }
            
            
            if (self.shopDetailModel.fulljifen_ex && ![self.shopDetailModel.fulljifen_ex isMemberOfClass:[NSNull class]]&&[self.shopDetailModel.fulljifen_ex integerValue] != 0) {
                 UIButton * buyCar = (UIButton *)[self.tabbar viewWithTag:553];
                buyCar.backgroundColor = [UIColor lightGrayColor];
                [buyCar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

                
                
                
                UIButton * buyNew = (UIButton *)[self.tabbar viewWithTag:554];
                [buyNew setTitle:@"立即兑换" forState:UIControlStateNormal];
            }
        }
        
    }];
}



-(void)changeShopDetailWithHtml:(NSString *)html
{
    if (self.segmentMenuVc) {
        self.shopDetail.html = html;
    }
    
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
//
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


-(void)XMSegmentMenuVcDidSelectItem:(XMSegmentMenuVc *)segmentMenu withIndex:(NSInteger)index
{
    
    self.currentIndex = index;
    if (self.currentIndex == 0) {
        
        [self.shopDetail.webView.scrollView setScrollEnabled:self.isLetSonViewScroll];
    }else if(self.currentIndex == 1)
    {
        if (self.dataSourceWithMiddle.count > 0) {
            [self.shopStandard.tableView setScrollEnabled:self.isLetSonViewScroll];
        }else
        {
            [self.shopComment.tableView setScrollEnabled:self.isLetSonViewScroll];
        }
        
    }else
    {
        [self.shopComment.tableView setScrollEnabled:self.isLetSonViewScroll];
    }
}

-(void)XMShopCommentViewController:(XMShopCommentViewController *)shopComment withTableView:(UITableView *)tableView withFloatY:(CGFloat)contenty;
{
    [tableView setScrollEnabled:NO];
    self.isLetSonViewScroll = NO;
    CGFloat scroll_Y = self.scrollView.contentOffset.y + contenty * 2.5;
    if (fabs(scroll_Y)  >  CGRectGetMidY(self.segmentMenuVc.frame)) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else
    {
        [self.scrollView setContentOffset:CGPointMake(0, scroll_Y) animated:YES];
    }
    
}
-(void)FMShopStandardController:(FMShopStandardController *)shopComment withTableView:(UITableView *)tableView withFloatY:(CGFloat)contenty;
{
    [tableView setScrollEnabled:NO];
    self.isLetSonViewScroll = NO;
    
    CGFloat scroll_Y = self.scrollView.contentOffset.y + contenty * 2.5;
    if (fabs(scroll_Y)  >  CGRectGetMidY(self.segmentMenuVc.frame)) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else
    {
        [self.scrollView setContentOffset:CGPointMake(0, scroll_Y) animated:YES];
    }
}
-(void)FMShopDetailWebView:(FMShopDetailWebView *)shopDetailWebView withTableView:(UIWebView *)webView withFloatY:(CGFloat)contenty;
{
    [webView.scrollView setScrollEnabled:NO];
    self.isLetSonViewScroll = NO;
    
    CGFloat scroll_Y = self.scrollView.contentOffset.y + contenty * 2.5;
    if (fabs(scroll_Y)  >  CGRectGetMidY(self.segmentMenuVc.frame)) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else
    {
        [self.scrollView setContentOffset:CGPointMake(0, scroll_Y) animated:YES];
    }
}

- (BOOL)shouldAutorotate
{
    
    return NO; //必须返回no, 才能强制手动旋转
    
}

-(BOOL)firstColor:(UIColor*)firstColor secondColor:(UIColor*)secondColor
{
    if (CGColorEqualToColor(firstColor.CGColor, secondColor.CGColor))
    {
        //NSLog(@"颜色相同");
        return YES;
    }
    else
    {
        //NSLog(@"颜色不同");
        return NO;
    }
}

@end
