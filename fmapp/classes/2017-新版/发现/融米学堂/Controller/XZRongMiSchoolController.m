//
//  XZRongMiSchoolController.m
//  fmapp
//
//  Created by admin on 17/2/24.
//  Copyright © 2017年 yk. All rights reserved.
//  融米学堂

#import "XZRongMiSchoolController.h"
#import "XZRongMiSchoolCell.h" // cell
#import "XZRongMiSchoolFooter.h" // 融米学堂footer
#import "XZRongMiSchoolHeader.h" // 融米学堂header
#import "XZRongMiSchoolModel.h" //
#import "XZRongMiSchoolProjectModel.h" // 推荐项目
#import "FMPlaceOrderViewController.h" // 商品详情
#import "WLNewProjectDetailViewController.h" // 项目详情
#import "XZShareView.h" // 分享
#import "XZActivityModel.h" // 分享model
// 当前页面数据
#define kRongMiSchoolUrl @"https://www.rongtuojinrong.com/Rongtuoxinsoc/api/newsDetail?"
//// 推荐项目
//#define kRecommandProjectUrl @"https://www.rongtuojinrong.com/rongtuoxinsoc/lend/caparecommpro"

// 点赞数据
#define kXZThumbUpUrl @"https://www.rongtuojinrong.com/Rongtuoxinsoc/api/likenews?"

@interface XZRongMiSchoolController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableRongMiSchool;

@property (nonatomic, strong) XZRongMiSchoolFooter *footer;

@property (nonatomic, strong) XZRongMiSchoolHeader *header;

@property (nonatomic, strong) XZRongMiSchoolModel *modelRongMi;

@property (nonatomic, strong) XZRongMiSchoolProjectModel *projectModel;

@property (nonatomic, strong) NSMutableArray *videoArray;
// 分享界面
@property (nonatomic, strong) XZShareView *share;

@property (nonatomic, strong) UIWindow *window;


@end

static NSString *reuseID = @"RongMiSchoolCell";

@implementation XZRongMiSchoolController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [self settingNavTitle:@"融米学堂"];
    
    self.window = [UIApplication sharedApplication].keyWindow;
    
    self.view.backgroundColor = XZBackGroundColor;
    //
    [self.view addSubview:self.tableRongMiSchool];
    
    // 头部和中间部分数据
    [self getRongMiSchoolDataFromNetwork];
    
    __weak __typeof(&*self)weakSelf = self;
    self.navBackButtonRespondBlock = ^{
        // 停止播放视频
        [weakSelf.header viewWillDisapperPause];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    // 
}

#pragma mark ----- 数据请求
- (void)getRongMiSchoolDataFromNetwork {
    __weak __typeof(&*self)weakSelf = self;
    int timestamp = [[NSDate date] timeIntervalSince1970];
    
    NSString *useId = [CurrentUserInformation sharedCurrentUserInfo].userId ? [CurrentUserInformation sharedCurrentUserInfo].userId : @"0";
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",useId,timestamp]);
    
    NSString *tokenlow=[token lowercaseString];
    NSDictionary *parameter = @{
                                @"user_id":useId,
                                @"appid":@"huiyuan",
                                @"shijian":[NSNumber numberWithInt:timestamp],
                                @"token":tokenlow,
                                @"id":self.articleId
                                };
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [FMHTTPClient postPath:kRongMiSchoolUrl parameters:parameter completion:^(WebAPIResponse *response) {
        
//        NSLog(@"融米学堂详情页接口=========%@",response.responseObject);
        
        // 清空数据
        weakSelf.modelRongMi = [[XZRongMiSchoolModel alloc] init];
        
        if (response.responseObject) {
            if (response.code == WebAPIResponseCodeSuccess) {
                NSDictionary *data = response.responseObject[@"data"];
                if (![data isKindOfClass:[NSNull class]]) {
                    [weakSelf.modelRongMi setValuesForKeysWithDictionary:data];
                    if (weakSelf.modelRongMi.title.length != 0) {
                        weakSelf.modelRongMi.titleHeight = [weakSelf.modelRongMi.title getStringCGSizeWithMaxSize:CGSizeMake(KProjectScreenWidth - 20, MAXFLOAT) WithFont:[UIFont systemFontOfSize:18.0f]].height;
                    }else {
                        weakSelf.modelRongMi.titleHeight = 0.0f;
                    }
                    if (weakSelf.modelRongMi.content.length != 0) {
                        weakSelf.modelRongMi.contentHeight = [weakSelf.modelRongMi.content getStringCGSizeWithMaxSize:CGSizeMake(KProjectScreenWidth - 20, MAXFLOAT) WithFont:[UIFont systemFontOfSize:15.0f]].height;
                    }else {
                        weakSelf.modelRongMi.contentHeight = 0.0f;
                    }
                    
                    if ([weakSelf.modelRongMi.extraDisplay integerValue] == 0) { // 不显示footer
//                        [weakSelf.footer removeFromSuperview];
                    }else if ([weakSelf.modelRongMi.extraDisplay integerValue] == 1) { // 1显示最新标
                        // 请求最新标数据
                        [weakSelf getRecommandProjectData];
                    }else { // 2显示商品
                        // 请求推荐商品数据
                        if (weakSelf.modelRongMi.selectedProduct.length != 0) {
                            [weakSelf getRecommandGoodsData];
                        }
                    }
                }
                else {
                    [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                    ShowAutoHideMBProgressHUD(weakSelf.view, [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]]);
                }
            }
            else {
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                ShowAutoHideMBProgressHUD(weakSelf.view, [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]]);
            }
        }
        else {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            ShowAutoHideMBProgressHUD(weakSelf.view, @"数据加载失败");
        }
        [weakSelf.tableRongMiSchool reloadData];
        weakSelf.header.modelRongMi = weakSelf.modelRongMi;
        [weakSelf.tableRongMiSchool.mj_header endRefreshing];
    }];
}

#pragma mark ----- 请求最新标数据
- (void)getRecommandProjectData {
    __weak __typeof(&*self)weakSelf = self;
    int timestamp = [[NSDate date] timeIntervalSince1970];
    
    NSString *useId = [CurrentUserInformation sharedCurrentUserInfo].userId ? [CurrentUserInformation sharedCurrentUserInfo].userId : @"0";
    NSString *token = EncryptPassword([NSString stringWithFormat:@"AppId=huiyuan&UserId=%@&AppTime=%d",useId,timestamp]);
    NSString *tokenlow = [token lowercaseString];
    NSDictionary *parameter = @{
                                @"UserId":useId,
                                @"AppId":@"huiyuan",
                                @"AppTime":[NSNumber numberWithInt:timestamp],
                                @"Token":tokenlow
                                };
    // kXZUniversalTestUrl(@"CardPackPage")
    [FMHTTPClient postPath:kFMPhpUniversalBaseUrl(@"Rongtuoxinsoc/lend/caparecommproliuer") parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if (response.responseObject) {
//            NSLog(@"请求最新标数据=========%@ ",response.responseObject);
            if (response.code == WebAPIResponseCodeSuccess) {
                NSDictionary *data = response.responseObject[@"data"];
                if ([data isKindOfClass:[NSDictionary class]]) {
                    weakSelf.projectModel = [[XZRongMiSchoolProjectModel alloc] init];
                    [weakSelf.projectModel setValuesForKeysWithDictionary:data];
                    weakSelf.projectModel.extraDisplay = weakSelf.modelRongMi.extraDisplay;
                    
                    weakSelf.tableRongMiSchool.tableFooterView = weakSelf.footer;
                    weakSelf.footer.modelProject = weakSelf.projectModel;
                }
            }
        }
        
    }];
}

#pragma mark ----- 请求最新商品数据
- (void)getRecommandGoodsData {
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *useId = [CurrentUserInformation sharedCurrentUserInfo].userId ? [CurrentUserInformation sharedCurrentUserInfo].userId : @"0";
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",useId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary *parameter = @{
                                  @"user_id":useId,
                                  @"appid":@"huiyuan",
                                  @"shijian":[NSNumber numberWithInt:timestamp],
                                  @"token":tokenlow,
                                  };
    
    NSString *recommandGoodsUrl = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/product/index_client/%@.html",self.modelRongMi.selectedProduct];
    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient postPath:recommandGoodsUrl parameters:parameter completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if (response.responseObject) {
//            NSLog(@"推荐商品信息=========%@ ",response.responseObject);
            if (response.code == WebAPIResponseCodeSuccess) {
                NSDictionary *data = response.responseObject[@"data"];
                if ([data isKindOfClass:[NSDictionary class]]) {
                    weakSelf.projectModel = [[XZRongMiSchoolProjectModel alloc] init];
                    [weakSelf.projectModel setValuesForKeysWithDictionary:data];
                    weakSelf.projectModel.extraDisplay = weakSelf.modelRongMi.extraDisplay;
                    
                    weakSelf.tableRongMiSchool.tableFooterView = weakSelf.footer;
                    weakSelf.footer.modelProject = weakSelf.projectModel;
                }
            }
        }
        
    }];
}

#pragma mark ----- 请求点赞数据
- (void)RequestThumbUpDataFromNetWork:(BOOL)showHUD {
    NSString *urlThumbUp = [NSString stringWithFormat:@"%@id=%@",kXZThumbUpUrl,self.articleId];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient getPath:urlThumbUp parameters:nil completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if (response.responseObject) {
//            NSLog(@"请求点赞数据=========%@ ",response.responseObject);
            if (response.code == WebAPIResponseCodeSuccess) {
                NSNumber *data = response.responseObject[@"data"];
                if (![data isKindOfClass:[NSNull class]]) {
                    weakSelf.modelRongMi.like = data;
                    if (showHUD) {
                        ShowAutoHideMBProgressHUD(weakSelf.view, @"点赞成功！");
                    }
                }else {
                    if (showHUD) {
                        ShowAutoHideMBProgressHUD(weakSelf.view, @"点赞失败！");
                    }
                }
            }else {
                if (showHUD) {
                    ShowAutoHideMBProgressHUD(weakSelf.view, @"点赞失败！");
                }
            }
        }else {
            if (showHUD) {
                ShowAutoHideMBProgressHUD(weakSelf.view, @"点赞失败！");
            }
        }
        [weakSelf.tableRongMiSchool reloadData];
    }];
    
}

#pragma mark ----- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XZRongMiSchoolCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[XZRongMiSchoolCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    
    __weak __typeof(&*self)weakSelf = self;
    cell.modelRongMi = self.modelRongMi;
    cell.blockRongMiSchool = ^(UIButton *button){
        if (button.tag == 200) { // 分享
            XZActivityModel *modelActivity = [[XZActivityModel alloc] init];
            modelActivity.shareurl = weakSelf.modelRongMi.shareUrl;
            modelActivity.sharepic = weakSelf.modelRongMi.videoThumb;
            modelActivity.sharecontent = weakSelf.modelRongMi.zhaiyao;
            modelActivity.sharetitle = weakSelf.modelRongMi.title;
            // 数据请求成功，添加分享界面
            if (modelActivity.sharetitle.length != 0) {
                weakSelf.share.modelShare = modelActivity;
                [weakSelf.view addSubview:[weakSelf.share retViewWithSelf]];
            }
        }else { // 点赞
            [weakSelf RequestThumbUpDataFromNetWork:YES];
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger titleHeight = self.modelRongMi.titleHeight;
    NSInteger contentHeight = self.modelRongMi.contentHeight;
    CGFloat height;
    if (contentHeight) {
       height = 15 + titleHeight + 10 + contentHeight + 10 + 13 + 10 + 32 + 15;
    }else {
       height = 15 + titleHeight + 10 + 13 + 10 + 32 + 15;
    }
    return height;
}

#pragma mark ---- 懒加载
- (UITableView *)tableRongMiSchool {
    if (!_tableRongMiSchool) {
        _tableRongMiSchool = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 64) style:UITableViewStylePlain];
        _tableRongMiSchool.delegate = self;
        _tableRongMiSchool.dataSource  = self;
        _tableRongMiSchool.backgroundColor = XZBackGroundColor;
        _tableRongMiSchool.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableRongMiSchool.showsVerticalScrollIndicator = NO;
        _tableRongMiSchool.tableHeaderView = self.header;
        
        __weak __typeof(&*self)weakSelf = self;
        _tableRongMiSchool.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
            // 头部和中间部分数据
            [weakSelf getRongMiSchoolDataFromNetwork];
        }];
    }
    return _tableRongMiSchool;
}

- (XZRongMiSchoolFooter *)footer {
    if (!_footer) {
        _footer = [[XZRongMiSchoolFooter alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 130)];
        __weak __typeof(&*self)weakSelf = self;
        _footer.blockFooter = ^{
            if ([weakSelf.modelRongMi.extraDisplay integerValue] == 1) { // 1显示最新标
                if (weakSelf.projectModel) {
                    if([weakSelf.projectModel.zhuangtai integerValue] == 8){
                        WLNewProjectDetailViewController *viewController=[[WLNewProjectDetailViewController alloc]initWithUserOperationStyle:3 WithProjectId:weakSelf.projectModel.jie_id];
                        viewController.rongzifangshi = [NSString stringWithFormat:@"%@",weakSelf.projectModel.rongzifangshi];
                        viewController.hidesBottomBarWhenPushed = YES;
                        [weakSelf.navigationController pushViewController:viewController animated:YES];
                        
                    }else if([weakSelf.projectModel.zhuangtai integerValue] == 4 || [weakSelf.projectModel.zhuangtai integerValue] == 6){
                        
                        WLNewProjectDetailViewController *viewController=[[WLNewProjectDetailViewController alloc]initWithUserOperationStyle:3 WithProjectId:weakSelf.projectModel.jie_id];
                        viewController.rongzifangshi = [NSString stringWithFormat:@"%@",weakSelf.projectModel.rongzifangshi];
                        viewController.hidesBottomBarWhenPushed = YES;
                        [weakSelf.navigationController pushViewController:viewController animated:YES];
                        
                    }else{
                        if ([weakSelf.projectModel.kaishicha integerValue] >0) {
                            
                            WLNewProjectDetailViewController *viewController=[[WLNewProjectDetailViewController alloc]initWithUserOperationStyle:1 WithProjectId:weakSelf.projectModel.jie_id];
                            viewController.rongzifangshi = [NSString stringWithFormat:@"%@",weakSelf.projectModel.rongzifangshi];
                            viewController.hidesBottomBarWhenPushed=YES;
                            [weakSelf.navigationController pushViewController:viewController animated:YES];
                            
                        }else{
                            
                            WLNewProjectDetailViewController *viewController=[[WLNewProjectDetailViewController alloc]initWithUserOperationStyle:2 WithProjectId:weakSelf.projectModel.jie_id];
                            viewController.rongzifangshi = [NSString stringWithFormat:@"%@",weakSelf.projectModel.rongzifangshi];
                            viewController.hidesBottomBarWhenPushed=YES;
                            [weakSelf.navigationController pushViewController:viewController animated:YES];
                        }
                    }
                }
                
            }else if ([weakSelf.modelRongMi.extraDisplay integerValue] == 2) { // 2显示商品
                if (weakSelf.projectModel) {
                    FMPlaceOrderViewController *placeOrder = [[FMPlaceOrderViewController alloc] init];
                    placeOrder.product_id = weakSelf.projectModel.product_id;
                    if ([weakSelf.projectModel.type isEqualToString:@"normal"]) { // 正常商品
                        placeOrder.isShopFullScore = 0;
                    }else { // 全积分商品
                        placeOrder.isShopFullScore = 1;
                    }
                    // 大于0,判断不是从优商城跳入的
                    placeOrder.goToGoodShopIndex = 2;
                    [weakSelf.navigationController pushViewController:placeOrder animated:YES];
                }
            }
        };
    }
    return _footer;
}

- (XZRongMiSchoolHeader *)header {
    if (!_header) {
        int heightM = KProjectScreenWidth * 220 / 350.0;
        
        _header = [[XZRongMiSchoolHeader alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, heightM)];
        __weak __typeof(&*self)weakSelf = self;
        
        // 请求到数据之后赋值！！！！！
        _header.modelRongMi = self.modelRongMi;
        
        // 向上旋转，回到tableView的头部
        void(^blockBackToTableHeader)() = ^() {
            [UIView animateWithDuration:0.5 animations:^{
                weakSelf.header.transform = CGAffineTransformMakeRotation(0);
                [weakSelf.header setPlayLayerFrame:NO];
                weakSelf.tableRongMiSchool.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, heightM)];
                weakSelf.header.frame = CGRectMake(0, 0, KProjectScreenWidth, heightM);
                [weakSelf.tableRongMiSchool.tableHeaderView addSubview:weakSelf.header];
            }];
        };
        
        // 向左旋转
        void(^blockBackToDirectionLeft)() = ^() {
            [UIView animateWithDuration:0.5 animations:^{
                weakSelf.header.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
                weakSelf.header.frame = weakSelf.window.frame;
                [weakSelf.header setPlayLayerFrame:YES];
                [weakSelf.window addSubview:weakSelf.header];
            }];
        };
        
        // 点击播放暂停那一栏的按钮调用
        _header.blockFullScreenBtn = ^(UIButton *button){
            weakSelf.modelRongMi.isLandScape = !weakSelf.modelRongMi.isLandScape;
            if (weakSelf.modelRongMi.isLandScape) { // 向左旋转
                blockBackToDirectionLeft();
            }else { // 向上旋转
                blockBackToTableHeader();
            }
        };
        
        // 屏幕旋转
        _header.blockFullScreen = ^(BOOL isClickButton, NSString *direction){
            if ([direction isEqualToString:@"向上"] || [direction isEqualToString:@"向下"]) {
                blockBackToTableHeader();
            }else if ([direction isEqualToString:@"向左"]) {
                blockBackToDirectionLeft();
            }else if ([direction isEqualToString:@"向右"]) {
                blockBackToTableHeader(); // 向上
                [UIView animateWithDuration:0.1 animations:^{
                    weakSelf.header.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
                    weakSelf.header.frame = weakSelf.window.frame;
                    [weakSelf.header setPlayLayerFrame:YES];
                    [weakSelf.window addSubview:weakSelf.header];
                }];
            }
        };
    }
    return _header;
}

- (XZShareView *)share {
    if (!_share) {
        _share = [[XZShareView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight)];
        __weak __typeof(&*self.share)weakShare = self.share;
        __weak __typeof(&*self)weakSelf = self;
        _share.blockShareAction = ^(UIButton *button){
            [weakShare shareAction:button handlerDelegate:weakSelf];
        };
        _share.blockShareSuccess = ^ { // 分享成功的回调
            // 请求点赞数据
            [weakSelf RequestThumbUpDataFromNetWork:NO];
        };
    }
    return _share;
}

- (NSMutableArray *)videoArray {
    if (!_videoArray) {
        _videoArray = [NSMutableArray array];
    }
    return _videoArray;
}

@end
