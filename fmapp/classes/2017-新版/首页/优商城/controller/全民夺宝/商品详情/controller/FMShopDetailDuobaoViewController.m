//
//  FMPlaceOrderViewController.m
//  fmapp
//
//  Created by runzhiqiu on 16/4/23.
//  Copyright © 2016年 yk. All rights reserved.
//
#define KdefauleMargion 30

#define KdefaultButtonColorAlpha 0.6
#import "FMShopDetailDuobaoViewController.h"
#import "FMRTWellStoreViewController.h"
//#import "XZConfirmOrderViewController.h"
#import "FMShoppingListViewController.h"
#import "FMPlaceOrderHeaderView.h"

#import "XMSegmentMenuVc.h"
#import "XMShopCommentViewController.h"
#import "FMShopDetailWebView.h"
#import "WLMessageViewController.h"
#import "FMShopSpecModel.h"

#import "LWImageBrowserModel.h"
#import "LWImageBrowser.h"

#import "FMShoppingListModel.h"
#import "FMPriceModel.h"

#import "FMShowShopActivity.h"
#import "FMShopOtherModel.h"

#import "FMGoodShopURL.h"
#import "FMGoodShopURLManage.h"

//#import "FMShoppingListShareView.h"

#import "UMSocialData.h"
#import "UMSocialConfig.h"
#import "UMSocialControllerService.h"
#import "UMSocialSnsPlatformManager.h"
#import "Fm_Tools.h"
#import "FMShoppingListScanView.h"
#import "FMShopOtherModel.h"

#import "FMShowShopPriceActivity.h"

#import "FMShopOtherModel.h"
#import "FMDuobaoShopDetailHeaderView.h"
#import "FMShopJoinInViewController.h"
#import "FMJoinInNotesViewController.h"



//控制器--选择商品
#import "FMDuobaoSelectShopView.h"
#import "FMWebShopDetailDuobaoViewController.h"
#import "FMDuobaoClass.h"

#import "XZConfirmPaymentController.h"
#import "AppDelegate.h"
#import "FMRTAuctionShareModel.h"
#import "WLPublishSuccessViewController.h"
#import "XZActivityModel.h"
#import "XZShareView.h"
#import "ShareViewController.h"

@interface FMShopDetailDuobaoViewController ()<UIScrollViewDelegate,FMWebShopDetailDuobaoViewControllerDelegate,FMShopJoinInViewControllerDelegate,XMSegmentMenuVcDelegate,UMSocialUIDelegate,UIWebViewDelegate,FMJoinInNotesViewControllerDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, weak) UIView * titleContentView;
@property (nonatomic, strong) NSMutableArray * titleDataSource;
@property (nonatomic, strong) NSMutableArray * lookLargeImage;
@property (nonatomic, strong) NSMutableArray * priceShopArray;


@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UIButton * retButton;
@property (nonatomic, strong) UIButton * messageButton;
@property (nonatomic, assign) BOOL isChangeValue;
@property (nonatomic, strong) FMShopDetailDuobaoVideoModel * videoModel;


//确定有用的：
//当前选中控制器
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) FMDuobaoShopDetailHeaderView * placeorderHeader;
@property (nonatomic, strong) XMSegmentMenuVc *segmentMenuVc;

//控制器
@property (nonatomic, weak)  FMJoinInNotesViewController * shopComment;
@property (nonatomic, weak)  FMShopJoinInViewController * shopJoinIn;
@property (nonatomic, weak)  FMWebShopDetailDuobaoViewController * shopDetail;

@property (nonatomic, strong) FMDuobaoClass * selectStyleModel;

@property (nonatomic, assign) NSInteger loadALLData;

@property (nonatomic, assign) BOOL showNavigationBar;
@property (nonatomic, strong)XZShareView *share;

@end

@implementation FMShopDetailDuobaoViewController

-(void)dealloc
{

    self.shopComment.delegate = nil;
    self.shopComment = nil;
    
    self.shopJoinIn.delegate = nil;
    self.shopJoinIn = nil;
    self.shopDetail.delegate = nil;
    self.shopDetail = nil;
    
    self.selectStyleModel = nil;
    self.segmentMenuVc = nil;
    self.placeorderHeader = nil;
    self.scrollView = nil;
    self.titleContentView = nil;
    self.titleDataSource = nil;
    self.lookLargeImage = nil;
    self.priceShopArray = nil;
    self.navigationController.navigationBarHidden = NO;

    
}

-(FMDuobaoClass *)selectStyleModel
{
    if (!_selectStyleModel) {
        _selectStyleModel = [[FMDuobaoClass alloc]init];
        
    }
    return _selectStyleModel;
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
         __weak __typeof(&*self)weakSelf = self;
        
        UIFont * titleFont;
        if (KProjectScreenWidth != 320) {
            titleFont = [UIFont systemFontOfSize:15.0];
        }else
        {
            titleFont = [UIFont systemFontOfSize:15.0];
        }

        CGFloat heighHeaderView;
        
        heighHeaderView = KProjectScreenWidth * 0.9375 + KDefauletCellItemLargeHeigh + KDefauletCellItemLittleHeigh + KDefauletCellItemLargeHeigh + KDefauletCellItemLittleHeigh + 10;
        
        
        _segmentMenuVc = [[XMSegmentMenuVc alloc]initWithFrame:CGRectMake(0, heighHeaderView, self.view.frame.size.width, 45)];
        _segmentMenuVc.typeComeFrom = 3;
        _segmentMenuVc.delegate = self;
        
        [self.scrollView addSubview:_segmentMenuVc];
        
        /* 自定义设置(可不设置为默认值) */
        _segmentMenuVc.backgroundColor = [UIColor whiteColor];
        _segmentMenuVc.titleFont = [UIFont systemFontOfSize:16.0];
        _segmentMenuVc.selectTitleFont = [UIFont systemFontOfSize:16.0];
        _segmentMenuVc.unlSelectedColor = [HXColor colorWithHexString:@"#1e1e1e" ];
        _segmentMenuVc.selectedColor = [HXColor colorWithHexString:@"#ff6633"];
        _segmentMenuVc.MenuVcSlideType = WJSegmentMenuVcSlideTypeSlide;
        _segmentMenuVc.SlideColor = [HXColor colorWithHexString:@"#ffffff"];
        _segmentMenuVc.advanceLoadNextVc = YES;
        
        
        FMJoinInNotesViewController * shopComment = [[FMJoinInNotesViewController alloc]init];
        shopComment.delegate = self;
        shopComment.won_id = self.won_id;
        self.shopComment = shopComment;
        
        
        
        
        FMWebShopDetailDuobaoViewController * shopDetail = [[FMWebShopDetailDuobaoViewController alloc]init];
        shopDetail.videoModel = self.videoModel;
        self.shopDetail = shopDetail;
        shopDetail.delegate = self;
        
        
        
        FMShopJoinInViewController * shopJoinIn = [[FMShopJoinInViewController alloc]init];

        shopJoinIn.delegate = self;
        shopJoinIn.buttonBlock = ^(FMDuobaoClassStyle * buobaoStyle)
        {
            [weakSelf buyButtonOnClick:buobaoStyle];
        };
        self.shopJoinIn = shopJoinIn;

        NSArray * muarray = @[shopJoinIn,shopDetail,shopComment];
        
        /* 导入数据 */
        [_segmentMenuVc addSubVc:muarray subTitles:self.titleDataSource];
        
        self.scrollView.contentSize = CGSizeMake(KProjectScreenWidth, CGRectGetMaxY(_segmentMenuVc.frame) + KProjectScreenHeight - 64 - 45);
        self.currentIndex = 0;
        self.scrollView.delegate = self;
        
    }
    return _segmentMenuVc;
}

-(FMDuobaoShopDetailHeaderView *)placeorderHeader
{
    if (!_placeorderHeader) {
         __weak __typeof(&*self)weakSelf = self;
        _placeorderHeader = [[FMDuobaoShopDetailHeaderView alloc]init];
        
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
        NSArray * title = @[@"参与方式",@"商品详情",@"参与记录"];

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loadALLData = 0;
    self.view.backgroundColor = [UIColor colorWithRed:(230.0/255) green:(234.0/255) blue:(241.0/255) alpha:1];
   
   
    [self createMainScrollView];
    [self createUINavigation];
    [self getHeaderDataSourceFromNetWork];
    [self getActivityDataSourceFromNetWork];
    


}



-(void)viewWillDisappear:(BOOL)animated
{
    if (!self.showNavigationBar) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
    
    [super viewWillDisappear:animated];
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
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
    
    
    UIButton * messageButton = [[UIButton alloc]initWithFrame:CGRectMake(titleContentView.bounds.size.width - 30 - 15, 7, 30, 30)];
    self.messageButton = messageButton;
    messageButton.tag = 502;
    messageButton.center = CGPointMake(messageButton.center.x,  statusView.frame.size.height * 0.5);
    messageButton.layer.cornerRadius = 15.0;
   
    [messageButton setBackgroundImage:[UIImage imageNamed:@"1111分享-白色"] forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(titleContentButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [statusView addSubview:messageButton];

    retButton.backgroundColor = [UIColor colorWithWhite:0 alpha:KdefaultButtonColorAlpha];
    messageButton.backgroundColor = [UIColor colorWithWhite:0 alpha:KdefaultButtonColorAlpha];
    
    [self createFloatView];
    
}


-(void)createFloatView
{
    CGFloat returTopView_width = 35;
    UIButton * returTopView = [[UIButton alloc]initWithFrame:CGRectMake(KProjectScreenWidth - returTopView_width - 5, self.view.frame.size.height - 64 - KdefauleMargion, returTopView_width, returTopView_width)];//电话_03controlScrollViewLocationButtonOnClick
    [returTopView setBackgroundImage:[UIImage imageNamed:@"电话_03"] forState:UIControlStateNormal];
    [returTopView addTarget:self action:@selector(controlCallTelephoneButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returTopView];
    [self.view bringSubviewToFront:returTopView];
    
    
    UIButton * callTelephoneView = [[UIButton alloc]initWithFrame:CGRectMake(KProjectScreenWidth - returTopView_width - 5 , self.view.frame.size.height - 64 - KdefauleMargion - 10 - returTopView_width, returTopView_width, returTopView_width)];
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




- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}


-(void)createMainScrollView
{
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight)];
    [self.view addSubview:scrollView];
    scrollView.backgroundColor = [UIColor colorWithRed:(230.0/255) green:(234.0/255) blue:(241.0/255) alpha:1];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    self.scrollView = scrollView;
    
    scrollView.contentSize = CGSizeMake(KProjectScreenWidth, CGRectGetMaxY(self.placeorderHeader.frame));
    
   
}
- (void)controlScrollViewLocationButtonOnClick:(UIButton *)button
{
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.shopComment.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.shopDetail.webView.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.shopJoinIn.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}



-(void)titleContentButtonOnClick:(UIButton *)button
{

    switch (button.tag - 500) {
        case 0:
        {
            self.scrollView.delegate = nil;
            self.navigationController.navigationBarHidden = NO;

            [self.navigationController popViewControllerAnimated:YES];
            
        }
            break;
        case 1:
        {
            
            FMShoppingListViewController * shopList = [[FMShoppingListViewController alloc]init];
            shopList.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:shopList animated:YES];
            
        }
            break;
        case 2:
        {
            
            [self shareOrderForResult];
            
        }
            break;
        case 50:
        {
            //客服
            
           
            
        }
            break;
        case 51:
        {
            
            
        }
            break;
       
        default:
            break;
    }
}


- (XZShareView *)share{
    if (!_share) {
        _share = [[XZShareView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight)];
        //        _share.modelShare = self.modelActivity;
        __weak __typeof(&*self.share)weakShare = self.share;
        __weak __typeof(&*self)weakSelf = self;
        
        _share.blockShareAction = ^(UIButton *button){
            [weakShare shareAction:button handlerDelegate:weakSelf];
        };
    }
    __weak __typeof(&*self)weakSelf = self;
    
    _share.blockShareSuccess = ^ { // 分享成功的回调
        int timestamp = [[NSDate date] timeIntervalSince1970];
        NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
        NSString *tokenlow=[token lowercaseString];
        // trench：幸运大抽奖渠道。share：分享 invite：邀请
        NSString *url = [NSString stringWithFormat:@"%@/slots/index.html?user_id=%@&token=%@&trench=share",kXZShareCallBackUrl,[CurrentUserInformation sharedCurrentUserInfo].userId,tokenlow];
        ShareViewController *shareVC = [[ShareViewController alloc]initWithTitle:@"幸运大抽奖" AndWithShareUrl:url];
        [weakSelf.navigationController pushViewController:shareVC animated:YES];
    };
    
    return _share;
}

#pragma mark -分享订单
- (void)shareOrderForResult{
    
    
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
    NSDictionary * parameter = @{@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"tel":[CurrentUserInformation sharedCurrentUserInfo].mobile,
                                 @"flag":@"newon_goods"
                                 };
    
    __weak __typeof(self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlHtml =[NSString stringWithFormat:@"%@/public/other/getShareInfo",kXZTestEnvironment];
    

    
    [FMHTTPClient postPath:urlHtml parameters:parameter completion:^(WebAPIResponse *response) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (response.code==WebAPIResponseCodeSuccess) {
            
            NSDictionary *dic = [response.responseObject objectForKey:@"data"];
            XZActivityModel *modelShare  = [[XZActivityModel alloc]init];
            
            
            modelShare.sharetitle =  [dic objectForKey:@"title"];;
            modelShare.sharepic = self.selectStyleModel.goods_img;
            modelShare.shareurl = [NSString stringWithFormat:@"%@?appid=huiyuan&token=%@&shijian=%@&user_id=%@&flag=%@&product_id=%@&id=%@",[dic objectForKey:@"link"],tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId,@"9",self.selectStyleModel.product_id,self.won_id];
            modelShare.sharecontent =  [dic objectForKey:@"content"];
            
            
            weakSelf.share.modelShare = modelShare;
            
            
            [self.view addSubview:[self.share retViewWithSelf]];
                
           
            
        }else{
            ShowAutoHideMBProgressHUD(weakSelf.view,@"请求分享数据失败！");
        }
    }];
    
}


-(void)refreshDataSource;
{
    
}


-(void)buyButtonOnClick:(FMDuobaoClassStyle *)buttonStyle
{
    
    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) { // 已登录
        
    }else { // 未登录
        LoginController *registerController = [[LoginController alloc] init];
        FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
         __weak __typeof(&*self)weakSelf = self;
        registerController.successBlock = ^(){
            [weakSelf refreshDataSource];
        };
        
        [self.navigationController presentViewController:navController animated:YES completion:^{
        }];
        return;
    }
    

    if (buttonStyle.buttonStyle == 1 || buttonStyle.buttonStyle == 2) {
        return;
    }
    
    if (self.selectStyleModel.haveNOStyle) {
        //直接跳转，不需要选样式
        self.selectStyleModel.selectStyleModel = buttonStyle;
        
        [self jumpConfirmShopController:nil withFMDuobaoClassStylewith:buttonStyle];
    }else
    {
        //需要选样式
        self.selectStyleModel.selectStyleModel = buttonStyle;
        
        
        FMDuobaoSelectShopView * shopView = [[FMDuobaoSelectShopView alloc]init];
        
        shopView.product_id = self.product_id;
        shopView.buttonStyle = buttonStyle;
        shopView.isShowCount = NO;
        
        __weak __typeof(&*self)weakSelf = self;
        shopView.successBlock = ^(FMSelectShopModelNew * selectModel,FMDuobaoClassStyle *buttonStylee){
            [weakSelf jumpConfirmShopController:selectModel withFMDuobaoClassStylewith:buttonStyle];
        };
        shopView.closeBlock = ^(FMSelectShopModelNew * selectModel){
            weakSelf.showNavigationBar = NO;
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
    
    
}

-(void)jumpConfirmShopController:(FMSelectShopModelNew * )selectModel withFMDuobaoClassStylewith:(FMDuobaoClassStyle *)buttonStyle
{
    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) { // 已登录
        
    }else { // 未登录
        LoginController *registerController = [[LoginController alloc] init];
        FMNavigationController *navController = [[FMNavigationController alloc] initWithRootViewController:registerController];
        [self.navigationController presentViewController:navController animated:YES completion:^{
        }];
        return;
    }
    
    self.showNavigationBar = NO;
    FMDuobaoClassSelectStyle * selectStyle = [[FMDuobaoClassSelectStyle alloc]init];
    selectStyle.selectModel = self.selectStyleModel.selectStyleModel;
    if (selectModel) {
        selectStyle.won_id = self.won_id;
        selectStyle.style_id = buttonStyle.style_id;
        selectStyle.goods_id = selectModel.gid;
        selectStyle.product_id = selectModel.product_id;
        selectStyle.goods_name = selectModel.title;
        selectStyle.goods_img = selectModel.image;
        selectStyle.selectString = selectModel.currentStyle;
    }else
    {
        selectStyle.won_id = self.won_id;
        selectStyle.style_id = buttonStyle.style_id;
        selectStyle.goods_id = self.selectStyleModel.goods_id;
        selectStyle.product_id = self.selectStyleModel.product_id;
        selectStyle.goods_name = self.selectStyleModel.goods_name;
        selectStyle.goods_img = self.selectStyleModel.goods_img;
        selectStyle.selectString = nil;
    }
   
    
    //NSLog(@"跳转确认订单---终点");
    
    XZConfirmPaymentController * confirmPay = [[XZConfirmPaymentController alloc]init];
    confirmPay.duobaoShop = selectStyle;
    [self.navigationController pushViewController:confirmPay animated:YES];
    
}



- (void)didSelectedAtIndexPath:(NSIndexPath *)indexPath;
{
    
    if (indexPath.row == 0) {
       
        WLMessageViewController *wlVc = [[WLMessageViewController alloc]init];
        wlVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wlVc animated:YES];
    }else
    {
        FMRTWellStoreViewController * rootViewController;
        for (UIViewController * viewController in self.navigationController.viewControllers) {
            if ([viewController isKindOfClass:[FMRTWellStoreViewController class]]) {
                rootViewController = (FMRTWellStoreViewController *)viewController;
            }
        }
        if (rootViewController) {
            self.navigationController.navigationBarHidden = NO;
            [self.navigationController popToViewController:rootViewController animated:NO];
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
   
    
    
    if (backAlpha < 0.15 ) {
        //改变图片
        if (!self.isChangeValue) {
            
            [self.retButton setBackgroundImage:[UIImage imageNamed:@"返回商品详情黑色"] forState:UIControlStateNormal];
            
            [self.messageButton setBackgroundImage:[UIImage imageNamed:@"1111分享-灰色"] forState:UIControlStateNormal];
            
           
            self.isChangeValue = YES;
        }
    }else
    {
        if (self.isChangeValue) {
            [self.retButton setBackgroundImage:[UIImage imageNamed:@"返回商品详情白色"] forState:UIControlStateNormal];
            
            [self.messageButton setBackgroundImage:[UIImage imageNamed:@"1111分享-白色"] forState:UIControlStateNormal];
            
           
             self.isChangeValue = NO;
        }
       
    }
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.scrollView == scrollView) {
        //滑动标准值
        CGFloat currentScrollY = scrollView.contentOffset.y + (KProjectScreenHeight);
        
        CGFloat radioAlpha = scrollView.contentOffset.y / (scrollView.contentSize.height - KProjectScreenHeight - 50);
        
        [self changeColorForStatusView:radioAlpha];
        
       
        //处理滑动问题
        
        if (currentScrollY > (scrollView.contentSize.height  - 5) && currentScrollY < (scrollView.contentSize.height  + 5)) {
                if (self.currentIndex == 0) {
                    if (!self.shopJoinIn.tableView.scrollEnabled) {
                        
                        [self.shopJoinIn.tableView setScrollEnabled:YES];
                        
                        self.isLetSonViewScroll = YES;
                    }
                    

                }else if(self.currentIndex == 1)
                {
                    
                    if (!self.shopDetail.webView.scrollView.scrollEnabled) {
                        
                        [self.shopDetail.webView.scrollView setScrollEnabled:YES];
                        
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
           
            if (self.currentIndex == 0) {
                
                if (self.shopJoinIn.tableView.scrollEnabled) {
                    
                    [self.shopJoinIn.tableView setScrollEnabled:NO];
                    
                    self.isLetSonViewScroll = NO;
                }
            }else if(self.currentIndex == 1)
            {
                if (self.shopDetail.webView.scrollView.scrollEnabled) {
                    
                    [self.shopDetail.webView.scrollView setScrollEnabled:NO];
                    
                    self.isLetSonViewScroll = NO;
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

-(void)getActivityDataSourceFromNetWork
{
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    
    NSDictionary * parameter ;
    
    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) { // 已登录
        
        NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
        NSString *tokenlow=[token lowercaseString];
        parameter = @{@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                      @"appid":@"huiyuan",
                      @"shijian":[NSNumber numberWithInt:timestamp],
                      @"token":tokenlow,
                      @"tel":[CurrentUserInformation sharedCurrentUserInfo].mobile,
                      @"won_id":self.won_id};
    }else{
        NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",@"0",timestamp]);
        NSString *tokenlow=[token lowercaseString];
        parameter = @{@"user_id":@"0",
                      @"appid":@"huiyuan",
                      @"shijian":[NSNumber numberWithInt:timestamp],
                      @"token":tokenlow,
                      @"won_id":self.won_id};
    }
    
    

    
    
    NSString * baseUrl = [NSString stringWithFormat:@"%@/public/newon/show/getWonDetail",kXZTestEnvironment];
    [FMHTTPClient postPath:baseUrl parameters:parameter completion:^(WebAPIResponse *response) {
       
        if (response.code == WebAPIResponseCodeSuccess) {
            
            NSDictionary * data = response.responseObject[@"data"];
            
            [self.selectStyleModel setValuesForKeysWithDictionary:data];
            
            
            if (data[@"ways"] && ![data[@"ways"] isMemberOfClass:[NSNull class]]) {
                NSArray * ways = data[@"ways"];
                NSMutableArray * musArray = [NSMutableArray array];
                for (NSDictionary * dataWays in ways) {
                    FMDuobaoClassStyle * duobaoStyle = [[FMDuobaoClassStyle alloc]init];
                    [duobaoStyle setValuesForKeysWithDictionary:dataWays];
                    
                    duobaoStyle.shop_Status = self.selectStyleModel.state;
                    duobaoStyle.residue = self.selectStyleModel.residue;
                    [duobaoStyle changeModelStatus];
                    [musArray addObject:duobaoStyle];
                }
                
                
                
                
                self.selectStyleModel.duobaoArray = [self compareDuobaoArray:musArray];
            }
            
            
            
            if (self.selectStyleModel.intro) {
                self.placeorderHeader.duobaoModel = self.selectStyleModel;
                
                [self changeShopDetailWithHtml:self.selectStyleModel.intro];
                self.shopJoinIn.dataSource = self.selectStyleModel.duobaoArray;
                [self.shopJoinIn reloadViewWithDataSource];

            }
           
            
        }else
        {
            ShowAutoHideMBProgressHUD(self.view, @"数据出错");
        }
        
    }];

}

-(void)refreshDateSourceWithNet;
{
    int timestamp = [[NSDate date]timeIntervalSince1970];
    
    NSDictionary * parameter ;
    
    if ([CurrentUserInformation sharedCurrentUserInfo].userLoginState) { // 已登录
        
        NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
        NSString *tokenlow=[token lowercaseString];
        parameter = @{@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                      @"appid":@"huiyuan",
                      @"shijian":[NSNumber numberWithInt:timestamp],
                      @"token":tokenlow,
                      @"tel":[CurrentUserInformation sharedCurrentUserInfo].mobile,
                      @"won_id":self.won_id};
    }else{
        NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",@"0",timestamp]);
        NSString *tokenlow=[token lowercaseString];
        parameter = @{@"user_id":@"0",
                      @"appid":@"huiyuan",
                      @"shijian":[NSNumber numberWithInt:timestamp],
                      @"token":tokenlow,
                      @"won_id":self.won_id};
    }
    
    
    
    
    
    NSString * baseUrl = [NSString stringWithFormat:@"%@/public/newon/show/getWonDetail",kXZTestEnvironment];
    [FMHTTPClient postPath:baseUrl parameters:parameter completion:^(WebAPIResponse *response) {
        
        if (response.code == WebAPIResponseCodeSuccess) {
            
            NSDictionary * data = response.responseObject[@"data"];
            
            [self.selectStyleModel setValuesForKeysWithDictionary:data];
            
            
            if (data[@"ways"] && ![data[@"ways"] isMemberOfClass:[NSNull class]]) {
                NSArray * ways = data[@"ways"];
                NSMutableArray * musArray = [NSMutableArray array];
                for (NSDictionary * dataWays in ways) {
                    FMDuobaoClassStyle * duobaoStyle = [[FMDuobaoClassStyle alloc]init];
                    [duobaoStyle setValuesForKeysWithDictionary:dataWays];
                    
                    duobaoStyle.shop_Status = self.selectStyleModel.state;
                    duobaoStyle.residue = self.selectStyleModel.residue;
                    [duobaoStyle changeModelStatus];
                    [musArray addObject:duobaoStyle];
                }
                
                
                
                
                self.selectStyleModel.duobaoArray = [self compareDuobaoArray:musArray];
            }
            
            
            

            self.shopJoinIn.dataSource = self.selectStyleModel.duobaoArray;
            [self.shopJoinIn reloadViewWithDataSource];
            [self.shopComment refreshDataSource];
            
            
        }else
        {
            ShowAutoHideMBProgressHUD(self.view, @"数据出错");
        }
        
    }];
}

- (NSMutableArray *)compareDuobaoArray:(NSMutableArray *)muArray {
    
    NSMutableArray * retMuArray = [NSMutableArray array];
    
    NSArray * sortArray = @[@"1",@"5",@"老友价"];
    
    for (NSString * detail in sortArray) {
        for (FMDuobaoClassStyle * duobaoStyle in muArray) {
            if ([detail isEqualToString:@"1"]) {
                if ([duobaoStyle.type integerValue] == 1) {
                    if ([duobaoStyle.unit_cost integerValue] == 1) {
                        [retMuArray addObject:duobaoStyle];
                    }
                }
            }
            if ([detail isEqualToString:@"5"]) {
                if ([duobaoStyle.type integerValue] == 1) {
                    if ([duobaoStyle.unit_cost integerValue] == 5) {
                        [retMuArray addObject:duobaoStyle];
                    }
                }
            }
            if ([detail isEqualToString:@"老友价"]) {
                if ([duobaoStyle.type integerValue] == 2) {
                    
                    [retMuArray addObject:duobaoStyle];
                    
                }
            }
        }
        
    }
    return retMuArray;
   
}

-(void)getHeaderDataSourceFromNetWork
{

    NSString * detail = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/product/index_client/%@.html",self.product_id];
    
    [MBProgressHUD showHUDAddedTo:self.placeorderHeader animated:YES];
    
    [FMHTTPClient postPath:detail parameters:nil completion:^(WebAPIResponse *response) {
        
        [MBProgressHUD hideAllHUDsForView:self.placeorderHeader animated:YES];
        if (response.code == WebAPIResponseCodeSuccess) {
            
            NSDictionary * data = response.responseObject[@"data"];
            
            [self changeHeaderViewTitleImages:data[@"images"]];
            if(![data[@"video_thumb"] isMemberOfClass:[NSNull class]]){
                
                self.selectStyleModel.video_thumb = [NSString stringWithFormat:@"%@",data[@"video_thumb"]];
            }
            

            
            FMShopDetailDuobaoVideoModel * videoModel = [[FMShopDetailDuobaoVideoModel alloc]init];
            videoModel.videoString = data[@"video"];
            videoModel.videoWidth = data[@"videoW"];
            videoModel.videoHeigh = data[@"videoH"];
            videoModel.video_thumb = data[@"video_thumb"];
            [videoModel resetVideoWidthAndHeigh];
            self.videoModel = videoModel;

            
            self.selectStyleModel.brief = data[@"brief"];
            
            self.selectStyleModel.intro = data[@"intro_ios"];
            
            
            NSDictionary * spec = data[@"spec"];
            
            NSArray *goods = spec[@"goods"];
            if (goods.count == 0) {
                self.selectStyleModel.haveNOStyle = YES;
            }
            
            //http://baobab.wdjcdn.com/14564977406580.mp4
            if (self.selectStyleModel.goods_id) {
             
                self.placeorderHeader.duobaoModel = self.selectStyleModel;

                [self changeShopDetailWithHtml:self.selectStyleModel.intro];
                self.shopJoinIn.dataSource = self.selectStyleModel.duobaoArray;
                [self.shopJoinIn reloadViewWithDataSource];
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
        
        [self.shopComment.tableView setScrollEnabled:self.isLetSonViewScroll];
    }else if(self.currentIndex == 1)
    {
         [self.shopDetail.webView.scrollView setScrollEnabled:self.isLetSonViewScroll];
        
    }else
    {
        [self.shopComment.tableView setScrollEnabled:self.isLetSonViewScroll];
    }
}

-(void)FMJoinInNotesViewController:(FMJoinInNotesViewController *)shopComment withTableView:(UITableView *)tableView withFloatY:(CGFloat)contenty;
{
    [tableView setScrollEnabled:NO];
    CGFloat scroll_Y = self.scrollView.contentOffset.y + contenty * 2.5;
    if (fabs(scroll_Y)  >  CGRectGetMidY(self.segmentMenuVc.frame)) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else
    {
        [self.scrollView setContentOffset:CGPointMake(0, scroll_Y) animated:YES];
    }
}

-(void)FMShopJoinInViewController:(FMShopJoinInViewController *)shopComment withTableView:(UITableView *)tableView withFloatY:(CGFloat)contenty;
{
    [shopComment.tableView setScrollEnabled:NO];
    CGFloat scroll_Y = self.scrollView.contentOffset.y + contenty * 2.5;
    if (fabs(scroll_Y)  >  CGRectGetMidY(self.segmentMenuVc.frame)) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else
    {
        [self.scrollView setContentOffset:CGPointMake(0, scroll_Y) animated:YES];
    }
}

-(void)FMWebShopDetailDuobaoViewController:(FMWebShopDetailDuobaoViewController *)shopDetailWebView withTableView:(UIWebView *)webView withFloatY:(CGFloat)contenty;
{
    [webView.scrollView setScrollEnabled:NO];
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



@end
