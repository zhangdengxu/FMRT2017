//
//  FMRTAuctionViewController.m
//  fmapp
//
//  Created by apple on 16/8/5.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTAuctionViewController.h"
#import "FMRTAuctionHeaderView.h"
#import "FMRTRemSecView.h"
#import "FMRTRemarkTableViewCell.h"
#import "FMRTAucModel.h"
#import "FMRTAucFootView.h"
#import "FMRTAucDataModel.h"
#import "FMRTAuctionRecordViewController.h"
#import "FMRTAucTool.h"
#import "Fm_Tools.h"
#import "WLPublishSuccessViewController.h"
#import "XZActivityModel.h"
#import "WLJPJLViewController.h"
#import "XZPersonalCenterViewController.h"
#import "XZAuctionNoticeViewController.h"
#import "XZSecondKillViewController.h"
#import "YSEvaluationRulesViewController.h"
#import "YSBiddingRulesViewController.h"
#import "WLEvaluateViewController.h"
#import "FMTimeKillShopDetailController.h"
#import "FMButtonStyleModel.h"
//#import "FMTimeKillShowSelectView.h"
#import "FMShopSpecModel.h"
#import "XZConfirmOrderKillViewController.h"


#import "FMTimeKillSelectView.h"
#import "AppDelegate.h"
#import "XZShoppingOrderAddressModel.h"
@interface FMRTAuctionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FMRTAucDataModel *dataModel;
@property (nonatomic, strong) FMRTAuctionHeaderView *topView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSURLSessionDataTask *successTask;
@property (nonatomic, strong) NSURLSessionDataTask *failureTask;
@property (nonatomic, weak)   FMRTAucFootView *footView;
//@property (nonatomic, strong) FMTimeKillShowSelectView * showSelect;

@end
static NSString *FMRTRemarkTableViewCellID = @"FMRTRemarkTableViewCellID";
static NSString *FMRTRemarkTableViewHeaderID = @"FMRTRemarkTableViewHeaderID";


@implementation FMRTAuctionViewController

- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(requestForAuctionPricePerFM) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingNavTitle:@"竞拍夺宝"];
    self.dataModel = [FMRTAucDataModel new];
    [self createTableView];
    [self setRightButtonItem];
    self.dataModel.currentPage = 1;

    [self getDataSourceFromNetWorkForAuction];

    __weak typeof (self)weakSelf = self;
    self.navBackButtonRespondBlock = ^(){
        [weakSelf.timer invalidate];
        weakSelf.timer = nil;
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}

- (void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)setRightButtonItem{
    
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightItemButton setFrame:CGRectMake(0, 0, 30, 29)];
    [rightItemButton setBackgroundImage:[UIImage imageNamed:@"新版_分享_36"] forState:UIControlStateNormal];
    [rightItemButton addTarget:self action:@selector(rightButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIButton *memberCenterBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [memberCenterBtn setBackgroundImage:[UIImage imageNamed:@"个人中心_03_03"] forState:(UIControlStateNormal)];
    [memberCenterBtn addTarget:self action:@selector(memberCenterAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:memberCenterBtn];
    [memberCenterBtn makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.width.equalTo(@50);
        make.height.equalTo(@53);
    }];
}

- (void)memberCenterAction{
    XZPersonalCenterViewController *centerVC = [[XZPersonalCenterViewController alloc]init];
    centerVC.flag = @"auction";
    [self.navigationController pushViewController:centerVC animated:YES];
}

#pragma mark - 竞拍网络请求
- (void)getDataSourceFromNetWorkForAuction{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof (self)weakSelf = self;

    [FMRTAucTool getAuctionDataWithSuccess:^(NSMutableArray *aucDataSource, NSMutableArray *topPhotoArr) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        [weakSelf.dataModel.remDataSource removeAllObjects];
        weakSelf.dataModel.aucDataSource = aucDataSource;
        weakSelf.dataModel.topPhotoArr = topPhotoArr;
        [weakSelf heardViewForTV];

        weakSelf.topView.model = self.dataModel;
        [weakSelf ifRequestForAuctionP];
        [weakSelf dataForComments];

    } failure:^(id object) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];

        ShowAutoHideMBProgressHUD(weakSelf.view,object);
    }];
}

#pragma mark - 竞拍价格请求
- (void)ifRequestForAuctionP{
    
    if (self.dataModel.aucDataSource.count > 1) {
        
        NSString *beginTime = [[self.dataModel.aucDataSource firstObject] begin_time];
        NSString *endTime = [[self.dataModel.aucDataSource firstObject] end_time];

        NSString *beginHour = [Fm_Tools getTotalTimeWithSecondsFromString:beginTime];
        NSString *endHour = [Fm_Tools getTotalTimeWithSecondsFromString:endTime];

        NSComparisonResult result =  [[NSDate date] compare:[Fm_Tools dateFromDateString:beginHour]];
        NSComparisonResult backResult =  [[NSDate date] compare:[Fm_Tools dateFromDateString:endHour]];
        if (result == NSOrderedDescending && backResult == NSOrderedAscending){
//            self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(requestForAuctionPricePerFM) userInfo:nil repeats:YES];
            [self.timer fire];
        }
    }
}

#pragma mark - 5s／次
- (void)requestForAuctionPricePerFM{
    
    [self.successTask cancel];
    [self.failureTask cancel];
    self.successTask = nil;
    self.failureTask = nil;
    __weak typeof (self)weakSelf = self;

   [FMRTAucTool getAucCurrentPriceWithArr:self.dataModel.aucDataSource successTask:^(NSURLSessionDataTask *successTask) {
        weakSelf.successTask = successTask;
    } failureTask:^(NSURLSessionDataTask *failureTask) {
        weakSelf.failureTask = failureTask;
    } success:^(NSMutableArray *aucDataSource) {
        
        weakSelf.dataModel.aucDataSource = [NSMutableArray arrayWithArray:aucDataSource];
        [weakSelf.topView sendDataWithModel:weakSelf.dataModel];
        
        NSInteger typeCount = 0;
        for (int i = 0; i < aucDataSource.count - 1; i++) {
            FMRTAucFirstModel *model = aucDataSource[i];
            typeCount += [model.activity_state intValue];
        }
//        if (typeCount >= (aucDataSource.count - 1) * 3) {
//            
//            [self.timer invalidate];
//            self.timer = nil;
//        }
    } failure:^(id object) {
        ShowAutoHideMBProgressHUD(weakSelf.view,object);
    }];
}

#pragma mark - 评论请求
- (void)dataForComments{
    __weak typeof (self)weakSelf = self;

    [FMRTAucTool getRecommntDataWithPage:self.dataModel.currentPage success:^(NSMutableArray *remData) {
        
        [weakSelf.dataModel.remDataSource addObjectsFromArray:remData];
        [weakSelf.tableView reloadData];
        if (remData.count == 0 ||[remData isKindOfClass:[NSNull class]]) {
            weakSelf.footView.title = @"没有更多评论数据";
        }else{
            weakSelf.footView.title = @"加载更多";
        }

    } failure:^(id object) {
        ShowAutoHideMBProgressHUD(weakSelf.view, object);
    }];
}

- (void)heardViewForTV{
    
    NSInteger rowCount = (self.dataModel.aucDataSource.count + 1)/2;
    __weak typeof (self) weakSelf = self;
    self.topView = [[FMRTAuctionHeaderView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenWidth * 290 /640 +((KProjectScreenWidth - 40)/2 + 150) * rowCount +80)];
    
    if (!self.topView.RBlock) {
        self.topView.RBlock = ^(NSString *auctionId){
            [weakSelf clickRecordForProductWith:auctionId];
        };
    }
    if (!self.topView.PBlock) {
        self.topView.PBlock = ^(UIButton *sender,NSInteger type, NSString *auctionId, NSString *productId,NSInteger count){
            [weakSelf cilickLeftProductButton:sender buttonType:type auctionId:auctionId productId:productId count:count];
        };
    }
    if (!self.topView.ABlock) {
        self.topView.ABlock = ^(){
            [weakSelf cilickActivityForRule];
        };
    }
    if (!self.topView.startBlock) {
        self.topView.startBlock = ^(){
            [weakSelf startRequsetForFiveSecond];
        };
    }
    if (!self.topView.endBlock) {
        self.topView.endBlock  = ^(){
            [weakSelf endRequsetForFiveSecond];
        };
    }
    if (!self.topView.topImageBlock) {
        self.topView.topImageBlock = ^(){
            [weakSelf clickTopImage];
        };
    }
    if (!self.topView.productDetailBlock) {
        self.topView.productDetailBlock = ^(NSString *goods_id, NSString *auctionId,NSString *state,NSString *price){
            [weakSelf productDetailWithId:goods_id auctionId:auctionId state:state price:price];
        };
    }
    self.tableView.tableHeaderView = self.topView;
}

#pragma mark - 竞拍开始－开始5s请求网络
- (void)startRequsetForFiveSecond{
//     self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(requestForAuctionPricePerFM) userInfo:nil repeats:YES];
    
    __weak typeof (self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [weakSelf.timer fire];
    });
}

#pragma mark -  竞拍结束－5s请求网络终止
- (void)endRequsetForFiveSecond{
    [self.successTask cancel];
    [self.failureTask cancel];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)createTableView{
    
    _tableView = ({
        UITableView *tableview= [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth , KProjectScreenHeight - 64) style:(UITableViewStyleGrouped)];
        tableview.backgroundColor = KDefaultOrBackgroundColor;
        tableview.delegate=self;
        tableview.dataSource=self;
        tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        tableview;
    });
    [self.view addSubview:_tableView];
    [self heardViewForTV];

//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        
//        self.dataModel.currentPage = 1;
//        [self getDataSourceFromNetWorkForAuction];
//    }];
    __weak typeof (self) weakSelf = self;

    FMRTAucFootView *footView = [[FMRTAucFootView alloc]init];
    self.footView = footView;
    if (!footView.moreBlock) {
        footView.moreBlock = ^(){
            weakSelf.dataModel.currentPage ++;
            [weakSelf dataForComments];
        };
    }

    self.tableView.tableFooterView = footView;
}

#pragma  mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataModel.remDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row >= self.dataModel.remDataSource.count) return 0;

    FMRTAucModel *model = self.dataModel.remDataSource[indexPath.row];
    return  [FMRTRemarkTableViewCell hightForCellWith:model];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   return  KProjectScreenWidth * 3/16 + 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FMRTRemarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FMRTRemarkTableViewCellID];
    if (cell == nil) {
        cell = [[FMRTRemarkTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:FMRTRemarkTableViewCellID];
    }
    
    cell.model = self.dataModel.remDataSource[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    FMRTRemSecView *remSecView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:FMRTRemarkTableViewHeaderID];
    if (!remSecView) {
        remSecView = [[FMRTRemSecView alloc]initWithReuseIdentifier:FMRTRemarkTableViewHeaderID];
    }
    __weak typeof (self) weakSelf = self;
    if (!remSecView.remBlcok) {
        remSecView.remBlcok = ^(){
            [weakSelf remDistaceDisplay];
        };
    }
    if (!remSecView.gormBlcok) {
        remSecView.gormBlcok = ^(){
            [weakSelf gotoRemarkDisplay];
        };
    }

    return remSecView;
}

- (void)cilickLeftProductButton:(UIButton *)sender buttonType:(NSInteger)type auctionId:(NSString *)auctionId productId:(NSString *)productId count:(NSInteger)endCount{
    
    switch (type) {
        case 1:
        {
            ShowAutoHideMBProgressHUD(self.view, @"活动尚未开始，敬请关注！");

            break;
        }
        case 2:
        {
//            ShowAutoHideMBProgressHUD(self.view, @"我要竞拍！！！");

            if (endCount == 1) {
                XZSecondKillViewController *killVC = [[XZSecondKillViewController alloc]init];
                killVC.flag = @"auction";
                killVC.activity_id = auctionId;
                [self.navigationController pushViewController:killVC animated:YES];
            }else if (endCount == 2){
                [self startAuctionWithAuctionId:auctionId productId:productId];

            }
            
            break;
        }
        case 3:
        {
            XZSecondKillViewController *killVC = [[XZSecondKillViewController alloc]init];
            killVC.flag = @"auction";
            killVC.activity_id = auctionId;
            [self.navigationController pushViewController:killVC animated:YES];
            break;
        }
        default:
            break;
    }
}



-(void)FMShowSelectViewDidSelecrButton:(FMSelectShopInfoModel *)selectModel
{
    
   
    if (![selectModel.address isMemberOfClass:[NSNull class]]){
        if (selectModel.address.length > 0) {
            
            XZShoppingOrderAddressModel *addressModel = [[XZShoppingOrderAddressModel alloc]init];
            
            addressModel.addr = selectModel.address;
            
            addressModel.mobile = selectModel.phone;
            
            addressModel.name = selectModel.recipients;
            addressModel.addr_id = selectModel.address_id;
            
            selectModel.addressModel = addressModel;
        }
    
        
    }
    
    XZConfirmOrderKillViewController *confirmOrder = [[XZConfirmOrderKillViewController alloc] init];
    confirmOrder.shopDetailModel = selectModel;
    [self.navigationController pushViewController:confirmOrder animated:YES];
    

}


- (void)startAuctionWithAuctionId:(NSString *)auctionId productId:(NSString *)productId{
    FMTimeKillSelectView * shopView = [[FMTimeKillSelectView alloc]init];
    //添加button
    shopView.isShowCount = NO;
    
    shopView.selectStyle = FMTimeKillShowSelectViewJingPai;
    
    FMSelectShopInfoModel * shopDetailModel = [[FMSelectShopInfoModel alloc]init];
    shopDetailModel.product_id = productId;
    shopDetailModel.auction_id = auctionId;

    
    [shopView createPresentModel:shopDetailModel];
    
    
    __weak __typeof(&*self)weakSelf = self;
    shopView.successBlock = ^(FMSelectShopInfoModel * selectModel){
        [weakSelf FMShowSelectViewDidSelecrButton:selectModel];
    };
    
    shopView.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.15];
    self.definesPresentationContext = YES;
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



#pragma mark - 竞拍记录
- (void)clickRecordForProductWith:(NSString *)auctioId{

    WLJPJLViewController *wlVC = [[WLJPJLViewController alloc]init];
    wlVC.auction_id = auctioId;
    [self.navigationController pushViewController:wlVC animated:YES];
}

- (void)cilickActivityForRule{
    
    YSBiddingRulesViewController *biddingVC = [[YSBiddingRulesViewController alloc]init];
    [self.navigationController pushViewController:biddingVC animated:YES];
    
}

- (void)remDistaceDisplay{

    YSEvaluationRulesViewController *evalueVC = [[YSEvaluationRulesViewController alloc]init];
    [self.navigationController pushViewController:evalueVC animated:YES];
}

- (void)gotoRemarkDisplay{

    WLEvaluateViewController *wlVC = [[WLEvaluateViewController alloc]init];
    [self.navigationController pushViewController:wlVC animated:YES];
}

- (void)rightButton{
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"tel":[CurrentUserInformation sharedCurrentUserInfo].mobile,
                                 @"flag":@"auction"};
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    NSString *testurl =[NSString stringWithFormat:@"%@/public/other/getShareInfo",kXZTestEnvironment];
    
    //@"https://www.rongtuojinrong.com/java/public/other/getShareInfo"
    [FMHTTPClient postPath:testurl parameters:parameter completion:^(WebAPIResponse *response) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        if (response.code==WebAPIResponseCodeSuccess) {
            
            NSDictionary * objectDic = [response.responseObject objectForKey:@"data"];
            
            FMRTAuctionShareModel *model = [[FMRTAuctionShareModel alloc]init];
            [model setValuesForKeysWithDictionary:objectDic];
            
            WLPublishSuccessViewController *shareVC = [WLPublishSuccessViewController new];
            shareVC.tag = @"kill";
            XZActivityModel *m = [XZActivityModel new];
            m.sharetitle = model.title;
            m.sharepic = model.img;
            m.shareurl = [NSString stringWithFormat:@"%@?appid=huiyuan&token=%@&shijian=%@&user_id=%@&flag=%@",model.link,tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId,@"2"];
            m.sharecontent = model.content;
            shareVC.modelActivity = m;
            [self.navigationController pushViewController:shareVC animated:YES];
            
        }else{
            ShowAutoHideMBProgressHUD(self.view, @"数据请求失败");
        }
    }];
}

- (void)clickTopImage{

    XZAuctionNoticeViewController *noticeVC =[[XZAuctionNoticeViewController alloc]init];
    noticeVC.flag = @"auction";
    [self.navigationController pushViewController:noticeVC animated:YES];
}

- (void)productDetailWithId:(NSString *)goods_id auctionId:(NSString *)auctionId state:(NSString *)activityState price:(NSString *)price{

    FMTimeKillShopDetailController * shopdetail = [[FMTimeKillShopDetailController alloc]init];
    shopdetail.hidesBottomBarWhenPushed = YES;
    shopdetail.shopDetailStyle = FMTimeKillShopDetailControllerJingPai;
        NSString * htmlUrl = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/product/index_client/%@.html",goods_id];
    shopdetail.activity_state = activityState;
    shopdetail.detailURL = htmlUrl;
    shopdetail.actionFlag = auctionId;
    shopdetail.killPrice = price;
    shopdetail.product_id = goods_id;
    [self.navigationController pushViewController:shopdetail animated:YES];
}



@end
