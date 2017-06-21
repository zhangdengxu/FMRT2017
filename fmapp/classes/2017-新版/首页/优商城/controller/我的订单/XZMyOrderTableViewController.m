//
//  XZMyOrderTableViewController.m
//  XZFenLeiJieMian
//
//  Created by admin on 16/5/3.
//  Copyright © 2016年 yuyang. All rights reserved.
//

#import "XZMyOrderTableViewController.h"
#import "XZTradeSuccessGoodsCell.h"
//#import "XZMyOrderTableView.h"
#import "XZTradeSuccessViewController.h"
#import "XZPublishCommentViewController.h"
#import "XZCommentAgainViewController.h"
#import "WLRequestViewController.h"
#import "WLFollowingViewController.h"
#import "XZGoodsCollectionCell.h"
#import "XZCollectionHeaderView.h"

#import "FMGoodShopHeaderModel.h"
#import "FMPlaceOrderViewController.h"
#import "XZCancelOrderCell.h"
// 请求数据
#import "XZMyOrderGoodsModel.h"
#import "XZMyOrderModel.h"
#import "FMGoodShopURL.h"
#import "FMCanaelOrderShowView.h"

#import "FMOrderTableViewFooter.h"
#import "FMOrderTableViewHeader.h"
#import "FMTradeDetailViewCell.h"

#import "FMGoodShopURLManage.h"

// 提示框
#import "SignOnDeleteView.h"
// 我的评价
#import "FMMyCommentAllController.h"

// 付款
#import "XZChoosePictureWayView.h"
#import "XZPayOrder.h"
#import "FMShowPayStatus.h"
#import "FMRTWellStoreViewController.h"
#import "FMRTWellStoreSaledDealViewController.h"
#import "FMRTWellStoreViewController.h"

@interface XZMyOrderTableViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,XZPayOrderDelegate,FMShowPayStatusDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, assign) BOOL isOver;
@property (nonatomic, assign) int currentPage;

@property (nonatomic, assign) BOOL isAddData;

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) NSMutableArray * dataSourceCollection;
@property (nonatomic, strong) NSArray *cancelDataArr;
// 当前点击的buttonzz
//@property (nonatomic, strong) UIButton *currentBtn;
@property (nonatomic, strong) UIView *cover;
@property (nonatomic, strong) NSString *urlStatus;
// 支付方式
@property (nonatomic, strong) XZPayOrder * payOrderStyle;
// 提示框
@property (nonatomic,strong) UIActionSheet * myActionSheet;
@property (nonatomic,strong) XZMyOrderModel *OrderModel;



@property (nonatomic, assign) BOOL isShowPayView;
@end

static NSString *headerReuseID = @"collection_header";
static NSString * tableViewHeaderRegisterID = @"FMOrderTableViewHeader";
static NSString * tableViewFooterRegisterID = @"FMOrderTableViewFooter";
static NSString * tableViewCellDetailRegister = @"FMTradeDetailViewCell";
static NSString * tableViewCellTradeRegister = @"XZTradeSuccessGoodsCell";
@implementation XZMyOrderTableViewController
-(XZPayOrder *)payOrderStyle
{
    if (!_payOrderStyle) {
        _payOrderStyle = [[XZPayOrder alloc]init];
        _payOrderStyle.delegate = self;
    }
    return _payOrderStyle;
}
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(NSMutableArray *)dataSourceCollection
{
    if (!_dataSourceCollection) {
        _dataSourceCollection = [NSMutableArray array];
    }
    return _dataSourceCollection;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        self.collection.hidden = YES;
        self.currentPage = 1;
        if (self.type == XZMyOrderTableViewTypeWaitComment) {
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, self.view.bounds.size.height - 50) style:UITableViewStyleGrouped];
            [self changeViewFrame];

            
            
        }else
        {
             _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
           
        }
        [_tableView registerClass:[FMTradeDetailViewCell class] forCellReuseIdentifier:tableViewCellDetailRegister];
         [_tableView registerClass:[XZTradeSuccessGoodsCell  class] forCellReuseIdentifier:tableViewCellTradeRegister];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        __weak __typeof(&*self)weakSelf = self;

        // 刷新
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.isOver = NO;
            weakSelf.currentPage = 1;
            _isAddData = NO;
            // 从网络上请求数据
            [self getUrlWithType];
        }];
        _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            weakSelf.currentPage = weakSelf.currentPage+1;
            _isAddData = YES;
            // 请求全部的数据
            [self getUrlWithType];
            
        }];
       
    }
    return _tableView;
}

// 修改子视图的frame
- (void)changeViewFrame {
    UIButton *lookDetail = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    lookDetail.frame = CGRectMake(0,self.view.bounds.size.height - 55, KProjectScreenWidth, 50);
    [lookDetail setTitle:@"我的评价 >" forState:UIControlStateNormal];
    lookDetail.backgroundColor = [UIColor whiteColor];
    [lookDetail setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.view addSubview:lookDetail];
    [lookDetail addTarget:self action:@selector(lookDetailBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

// 点击查看评价
- (void)lookDetailBtnAction:(UIButton *)button {
    FMMyCommentAllController *commentAll = [[FMMyCommentAllController alloc]init];
    [self.navigationController pushViewController:commentAll animated:YES];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cancelDataArr = @[@"我不想买了",@"信息填写失误，重新拍",@"卖家缺货",@"同城交易",@"其他原因"];
    _currentPage = 1;
    // 请求全部的数据
    [self getUrlWithType];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isShowPayView =  YES;
    [self getRefreshUrlWithType];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.isShowPayView = NO;
}
// 请求全部的数据
- (void)getAllDataFromNetWork {
   
//    https://www.rongtuojinrong.com/qdy/wap/member-orders_client.html?pay_status=&npage=1&from=rongtuoapp&tel=15966065659&appid=huiyuan&token=f9f828db40436e108678cc37bedd5c79&shijian=1456199802&user_id=191
    __weak __typeof(&*self)weakSelf = self;
    
    [FMHTTPClient getPath:self.urlStatus parameters:nil completion:^(WebAPIResponse *response) {
        if (response.code == WebAPIResponseCodeSuccess) {
            NSArray * oldArray = response.responseObject[@"data"];
                if (![oldArray isMemberOfClass:[NSNull class]]) {
                    if (oldArray.count < 10) {
                        weakSelf.isOver = YES;
                    }
                    if (_isAddData) {
                        _isAddData = NO;
                    }else
                    {
                        [weakSelf.dataSource removeAllObjects];
                    }
                    if (oldArray.count != 0) {
                        for (NSDictionary *dict in oldArray) {
                            XZMyOrderModel *modelM = [[XZMyOrderModel alloc]init];
                            [modelM setValuesForKeysWithDictionary:dict];
                            NSArray *goodsArr = dict[@"goods_items"];
                            NSMutableArray *goodsArrCopy = [[NSMutableArray alloc]init];
                            [self changeOederModelorderStatusFMStatus:modelM];
                            for (NSDictionary *dic in goodsArr) {
                                XZMyOrderGoodsModel *goods = [[XZMyOrderGoodsModel alloc]init];
                                [goods setValuesForKeysWithDictionary:dic];
                                [goodsArrCopy addObject:goods];
                                goods.order_id = dict[@"order_id"];
                                goods.aftersales_status = dict[@"aftersales_status"];
                                goods.orderStatusFM = modelM.orderStatusFM;
                                
                            }
                            
                            modelM.goods_items = goodsArrCopy;
                            if (dict[@"shipping"]) {
                                NSDictionary * infoShip = dict[@"shipping"];
                                if (infoShip[@"shipping_name2"]) {
                                    modelM.shipping_name2 = [NSString stringWithFormat:@"%@",infoShip[@"shipping_name2"]];;
                                }
                            }
                            
                            
                            if (dict[@"logi_no"]) {
                                modelM.logi_no = [NSString stringWithFormat:@"%@", dict[@"logi_no"]];
                            }
                           
                            [self.dataSource addObject:modelM];
                            
                        }
                        [weakSelf.tableView reloadData];
                    }else {
                        if (self.dataSource.count == 0) {
                            // 如果数据为空，创建CollectionView
                            [self createNoOrderCollectionView];

                        }
                    }
                }
            }else { // 请求不成功
             ShowAutoHideMBProgressHUD(weakSelf.view,@"网络太慢，请稍后重试");
            }
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

-(BOOL)judgeDoubleArraySame:(NSArray *)fatherArray WithSonArray:(NSArray *)sonArray
{
    if (sonArray.count == 0) {
        return NO;
    }
    if(fatherArray.count < sonArray.count)
    {
        return NO;
    }
    NSInteger countBool = 0;
    for (NSInteger index = 0; index < sonArray.count; index ++) {
        XZMyOrderModel *modelM = sonArray[index];
        XZMyOrderModel *modelM2 = fatherArray[index];
        if (![modelM.order_id isEqualToString:modelM2.order_id]) {
            countBool ++;
        }
        
    }
    if (countBool != 0) {
        return NO;
    }else
    {
        return YES;
    }
}
//// 消失圈
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//}
- (void)changeOederModelorderStatusFMStatus:(XZMyOrderModel *)model
{
    if (self.type == XZMyOrderTableViewTypeALL) {
        [model setOederStatusWithOrderInfo];
    }else
    {
        switch (self.type) {
           
            case XZMyOrderTableViewTypeWaitPay:
            {
                model.orderStatusFM = 61;
            }
                break;
            case XZMyOrderTableViewTypeWaitSend:
            {
                model.orderStatusFM = 51;
            }
                break;
            case XZMyOrderTableViewTypeWaitRecive:
            {
                model.orderStatusFM = 41;
            }
                break;
            case XZMyOrderTableViewTypeWaitComment:
            {
                
                model.orderStatusFM = 31;
            }
                break;
            case XZMyOrderTableViewTypeAfterSale:
            {
                [model setOederStatusWithOrderInfo];
                if (model.orderStatusFM == 11 || model.orderStatusFM == 12) {
                    
                }else
                {
                    model.orderStatusFM = 11;
                }
                
            }
                break;
            default:
                break;
        }

    }
    
}

// 取消订单界面
- (void)createCancelOrderView:(XZMyOrderModel *)model {
    FMCanaelOrderShowView * showView = [[FMCanaelOrderShowView alloc]initWithCancelDataArr:self.cancelDataArr];
    [showView showSelfView];
    __weak __typeof(&*self)weakSelf = self;
    showView.blockSureBtn = ^(UIButton *button) {
       [weakSelf deleteOrderModelFromDataSource:model withUrl:KMyOrder_OrderList_cancelOrder_Url withProfmpt:@"取消订单成功"];
    };
}

// 设置请求的数据的类型
- (void)setType:(XZMyOrderTableViewType)type
{
    _type = type;
}
-(void)getRefreshUrlWithType
{
    NSString * urlRefresh;
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSString * mebile = [CurrentUserInformation sharedCurrentUserInfo].mobile;
    
    switch (self.type) {
        case XZMyOrderTableViewTypeALL:
        {
            
            NSString * currentStatus = @"all";
            NSString *navUrl = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/member-orders_client.html?pay_status=%@&npage=%@&from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%@&user_id=%@",currentStatus,[NSString stringWithFormat:@"%d",1],mebile,tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId];
            urlRefresh = navUrl;
        }
            break;
        case XZMyOrderTableViewTypeWaitPay:
        {
            NSString * currentStatus = @"nopayed";
            NSString *navUrl = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/member-orders_client.html?pay_status=%@&npage=%@&from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%@&user_id=%@",currentStatus,[NSString stringWithFormat:@"%d",1],mebile,tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId];
            urlRefresh = navUrl;
        }
            break;
        case XZMyOrderTableViewTypeWaitSend:
        {
            NSString * currentStatus = @"unship";
            NSString *navUrl = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/member-orders_client.html?pay_status=%@&npage=%@&from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%@&user_id=%@",currentStatus,[NSString stringWithFormat:@"%d",1],mebile,tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId];
            urlRefresh = navUrl;
        }
            break;
        case XZMyOrderTableViewTypeWaitRecive:
        {
            NSString * currentStatus = @"shiped";
            NSString *navUrl = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/member-orders_client.html?pay_status=%@&npage=%@&from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%@&user_id=%@",currentStatus,[NSString stringWithFormat:@"%d",1],mebile,tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId];
            urlRefresh = navUrl;
        }
            break;
        case XZMyOrderTableViewTypeWaitComment:
        {
            
            NSString *navUrl = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/member-nodiscuss_client.html?npage=%@&from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%@&user_id=%@",[NSString stringWithFormat:@"%d",1],mebile,tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId];
            urlRefresh = navUrl;
        }
            break;
        case XZMyOrderTableViewTypeAfterSale:
        {
            NSString *currentStatus = @"refund";
            NSString *navUrl = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/member-orders_client.html?pay_status=%@&npage=%@&from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%@&user_id=%@",currentStatus,[NSString stringWithFormat:@"%d",1],mebile,tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId];
            urlRefresh = navUrl;
        }
            break;
        default:
            break;
    }
    if (urlRefresh) {
        [self getRefreshAllDataFromNetWork:urlRefresh];

    }
}
-(void)getRefreshAllDataFromNetWork:(NSString *)urlRefresh
{
    __weak __typeof(&*self)weakSelf = self;
    
    [FMHTTPClient getPath:urlRefresh parameters:nil completion:^(WebAPIResponse *response) {
        if (response.code == WebAPIResponseCodeSuccess) {
            NSArray * oldArray = response.responseObject[@"data"];
            NSMutableArray * linshiDataSource = [NSMutableArray array];
            if (![oldArray isMemberOfClass:[NSNull class]]) {

                if (oldArray.count != 0) {
                    for (NSDictionary *dict in oldArray) {
                        XZMyOrderModel *modelM = [[XZMyOrderModel alloc]init];
                        [modelM setValuesForKeysWithDictionary:dict];
                        NSArray *goodsArr = dict[@"goods_items"];
                        NSMutableArray *goodsArrCopy = [[NSMutableArray alloc]init];
                        [self changeOederModelorderStatusFMStatus:modelM];
                        for (NSDictionary *dic in goodsArr) {
                            XZMyOrderGoodsModel *goods = [[XZMyOrderGoodsModel alloc]init];
                            [goods setValuesForKeysWithDictionary:dic];
                            [goodsArrCopy addObject:goods];
                            goods.order_id = dict[@"order_id"];
                            goods.aftersales_status = dict[@"aftersales_status"];
                            goods.orderStatusFM = modelM.orderStatusFM;
                            
                        }
                        
                        modelM.goods_items = goodsArrCopy;
                        if (dict[@"shipping"]) {
                            NSDictionary * infoShip = dict[@"shipping"];
                            if (infoShip[@"shipping_name2"]) {
                                modelM.shipping_name2 = [NSString stringWithFormat:@"%@",infoShip[@"shipping_name2"]];;
                            }
                        }
                        
                        
                        if (dict[@"logi_no"]) {
                            modelM.logi_no = [NSString stringWithFormat:@"%@", dict[@"logi_no"]];
                        }
                        
                        [linshiDataSource addObject:modelM];
                        
                    }
                    
                    if (![self judgeDoubleArraySame:self.dataSource WithSonArray:linshiDataSource]) {
                        
                        [self.dataSource removeAllObjects];
                        self.currentPage = 1;
                        if (oldArray.count < 10) {
                            weakSelf.isOver = YES;
                        }
                        
                        if (_isAddData) {
                            _isAddData = NO;
                        }
                        
                        [self.tableView reloadData];
                    }
                    
                    
                    
                }else
                {
                    if (self.dataSource.count == 0) {
                        // 如果数据为空，创建CollectionView
                        [self createNoOrderCollectionView];
                        
                    }
                }
            }
            
       
            
        }else { // 请求不成功
            ShowAutoHideMBProgressHUD(weakSelf.view,@"网络太慢，请稍后重试");
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];

}
-(void)getUrlWithType
{
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSString * mebile = [CurrentUserInformation sharedCurrentUserInfo].mobile;
    
    switch (self.type) {
        case XZMyOrderTableViewTypeALL:
        {
            
            NSString * currentStatus = @"all";
            NSString *navUrl = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/member-orders_client.html?pay_status=%@&npage=%@&from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%@&user_id=%@",currentStatus,[NSString stringWithFormat:@"%d",self.currentPage],mebile,tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId];
            self.urlStatus = navUrl;
        }
            break;
        case XZMyOrderTableViewTypeWaitPay:
        {
            NSString * currentStatus = @"nopayed";
            NSString *navUrl = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/member-orders_client.html?pay_status=%@&npage=%@&from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%@&user_id=%@",currentStatus,[NSString stringWithFormat:@"%d",self.currentPage],mebile,tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId];
            self.urlStatus = navUrl;
        }
            break;
        case XZMyOrderTableViewTypeWaitSend:
        {
            NSString * currentStatus = @"unship";
            NSString *navUrl = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/member-orders_client.html?pay_status=%@&npage=%@&from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%@&user_id=%@",currentStatus,[NSString stringWithFormat:@"%d",self.currentPage],mebile,tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId];
            self.urlStatus = navUrl;
        }
            break;
        case XZMyOrderTableViewTypeWaitRecive:
        {
            NSString * currentStatus = @"shiped";
            NSString *navUrl = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/member-orders_client.html?pay_status=%@&npage=%@&from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%@&user_id=%@",currentStatus,[NSString stringWithFormat:@"%d",self.currentPage],mebile,tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId];
            self.urlStatus = navUrl;
        }
            break;
        case XZMyOrderTableViewTypeWaitComment:
        {
            
            NSString *navUrl = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/member-nodiscuss_client.html?npage=%@&from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%@&user_id=%@",[NSString stringWithFormat:@"%d",self.currentPage],mebile,tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId];
            self.urlStatus = navUrl;
        }
            break;
        case XZMyOrderTableViewTypeAfterSale:
        {
            NSString *currentStatus = @"refund";
            NSString *navUrl = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/member-orders_client.html?pay_status=%@&npage=%@&from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%@&user_id=%@",currentStatus,[NSString stringWithFormat:@"%d",self.currentPage],mebile,tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId];
            self.urlStatus = navUrl;
        }
            break;
        default:
            break;
    }
    [self getAllDataFromNetWork];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.dataSource.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

        XZMyOrderModel *myOrderM = self.dataSource[section];
        return [myOrderM.goods_items count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak __typeof(&*self)weakSelf = self;

    XZMyOrderModel *model= self.dataSource[indexPath.section];
    if (self.type == XZMyOrderTableViewTypeWaitComment) {
        
        
        FMTradeDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellDetailRegister forIndexPath:indexPath];
        if (!cell) {
            cell = [[FMTradeDetailViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellDetailRegister];
        }

        cell.afterSalesBtnTitle = @"商品评价";
        cell.blockAfterSalesBtn = ^(UIButton * button)
        {
            //收货评价
            [weakSelf goodsCommentWith:model.goods_items[indexPath.row]];
            
        };
        if ([model.goods_items count]> 0) { // 如果数据不为空的话赋值
            cell.isShowComment = YES;
            XZMyOrderGoodsModel *goodsModel = model.goods_items[indexPath.row];
            cell.goodsModel = goodsModel;
        }

        return cell;

     
    }else{
        XZTradeSuccessGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellTradeRegister forIndexPath:indexPath];
        if (!cell) {
            cell = [[XZTradeSuccessGoodsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellTradeRegister];
        }
        cell.blockAfterSalesBtn = ^(UIButton * button)
        {
            //收货评价
            [weakSelf goodsCommentWith:model.goods_items[indexPath.row]];
            
        };
        if ([model.goods_items count]> 0) { // 如果数据不为空的话赋值
        XZMyOrderGoodsModel *goodsModel = model.goods_items[indexPath.row];
            cell.goodsModel = goodsModel;
        }
        return cell;
    }
    
    
}
-(void)goodsCommentWith:(XZMyOrderGoodsModel *)orderModel
{
    XZPublishCommentViewController * commentView = [[XZPublishCommentViewController alloc]init];
    commentView.sendModel = orderModel;
    [self.navigationController pushViewController:commentView animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     XZMyOrderModel *model= self.dataSource[indexPath.section];
     if (self.type == XZMyOrderTableViewTypeWaitComment) {
         NSInteger font = 13;
         if (KProjectScreenWidth == 320) {
             font = 13;
         }else if (KProjectScreenWidth == 375)
         {
             font = 14;
         }else
         {
             font = 15;
         }
         CGFloat radio = KProjectScreenWidth / 414;
         CGFloat width = KProjectScreenWidth - (KProjectScreenWidth * 0.2 + 20 + 70 + 10);
         XZMyOrderGoodsModel * good = model.goods_items[indexPath.row];
         CGSize size = [good.name getStringCGSizeWithMaxSize:CGSizeMake(width, MAXFLOAT) WithFont:[UIFont systemFontOfSize:font]];
         CGFloat aLLHeight = KProjectScreenWidth * 0.2 + 12;
         
         
         CGFloat rightHeight = (size.height + 18 + 15) > (25 * 3)?(size.height + 18 + 15):(25 * 3);
         CGFloat realHeigh ;
         
         if ((![good.order_type isMemberOfClass:[NSNull class]]&&[good.order_type integerValue] != 0)) {
             realHeigh = aLLHeight > rightHeight? aLLHeight: rightHeight;
             realHeigh = realHeigh + 10;
         }else
         {
             rightHeight = rightHeight + 30 * radio + 15;
             realHeigh = aLLHeight > rightHeight? aLLHeight: rightHeight;
         }
         return realHeigh;
         
         
      
     }
     else{
         NSInteger font = 13;
         if (KProjectScreenWidth == 320) {
             font = 13;
         }else if (KProjectScreenWidth == 375)
         {
             font = 14;
         }else
         {
             font = 15;
         }
         CGFloat radio = KProjectScreenWidth / 414;
         CGFloat width = KProjectScreenWidth - (KProjectScreenWidth * 0.2 + 20 + 70 + 10);
         XZMyOrderGoodsModel * good = model.goods_items[indexPath.row];
         CGSize size = [good.name getStringCGSizeWithMaxSize:CGSizeMake(width, MAXFLOAT) WithFont:[UIFont systemFontOfSize:font]];
         CGFloat aLLHeight = KProjectScreenWidth * 0.2 + 12;
         
         
         CGFloat rightHeight = (size.height + 18 + 15) > (25 * 3)?(size.height + 18 + 15):(25 * 3);
         CGFloat realHeigh ;
         
         if (good.orderStatusFM != 31) {
             realHeigh = aLLHeight > rightHeight? aLLHeight: rightHeight;
             realHeigh = realHeigh + 10;
         }else
         {
             rightHeight = rightHeight + 30 * radio + 15;
             realHeigh = aLLHeight > rightHeight? aLLHeight: rightHeight;
         }
         return realHeigh;
         
     }
       
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    FMOrderTableViewHeader * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:tableViewHeaderRegisterID];
    if (!header) {
        header = [[FMOrderTableViewHeader alloc]initWithReuseIdentifier:tableViewHeaderRegisterID];
    }
    XZMyOrderModel *orderModel = self.dataSource[section];
    header.orderModel = orderModel;
    return header;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   
    return 40;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    FMOrderTableViewFooter * footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:tableViewFooterRegisterID];
    if (!footer) {
        footer = [[FMOrderTableViewFooter alloc]initWithReuseIdentifier:tableViewFooterRegisterID];
        
    }
    XZMyOrderModel *orderModel = self.dataSource[section];
     __weak __typeof(&*self)weakSelf = self;
    footer.blockOrderBtn = ^(UIButton *button,XZMyOrderModel *orderModel) {
        [weakSelf changeButtonOnClick:button withModel:orderModel];
    };
    
    if (self.type == XZMyOrderTableViewTypeWaitComment ||(self.type == XZMyOrderTableViewTypeAfterSale && orderModel.orderStatusFM !=12)|| (self.type == XZMyOrderTableViewTypeALL && orderModel.orderStatusFM < 40 &&orderModel.orderStatusFM != 1 &&orderModel.orderStatusFM !=12)) {
        footer.isCommentFooter = 1;
    }else{
        footer.isCommentFooter = 0;
        
    }

    footer.orderModel = orderModel;

    
    
    return footer;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    XZMyOrderModel *orderModel = self.dataSource[section];

    
     if (self.type == XZMyOrderTableViewTypeWaitComment ||(self.type == XZMyOrderTableViewTypeAfterSale && orderModel.orderStatusFM !=12)|| (self.type == XZMyOrderTableViewTypeALL && orderModel.orderStatusFM < 40 &&orderModel.orderStatusFM != 1 &&orderModel.orderStatusFM !=12))  {
        
        return 34;
    }else{
        return 80;

    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XZMyOrderModel * orderModel = self.dataSource[indexPath.section];
    
    if (self.type == XZMyOrderTableViewTypeWaitComment ||self.type == XZMyOrderTableViewTypeAfterSale ||self.type == XZMyOrderTableViewTypeALL||self.type == XZMyOrderTableViewTypeWaitSend||self.type == XZMyOrderTableViewTypeWaitRecive) {
        XZMyOrderGoodsModel *goods = orderModel.goods_items[indexPath.row];
        if ([goods.aftersales integerValue] == 1) {
            FMRTWellStoreSaledDealViewController * changeSuccess = [[FMRTWellStoreSaledDealViewController alloc]init];
            changeSuccess.orderID = [NSString stringWithFormat:@"%@", goods.aftersale_id];
            changeSuccess.model = goods;
            [self.navigationController pushViewController:changeSuccess animated:YES];
            
            return;
        }
    }
    
    
 
    
    XZTradeSuccessViewController *tradeSuccess = [[XZTradeSuccessViewController alloc]init];
    __weak __typeof(&*self)weakSelf = self;
    tradeSuccess.blockInfo = ^(NSInteger status){
        [weakSelf confirmGoodArriveAddress];
    };
    if (self.type == XZMyOrderTableViewTypeWaitComment) {
        
        tradeSuccess.isShowComment = YES;
        
    }
    tradeSuccess.orderModel = self.dataSource[indexPath.section];
        [self.navigationController pushViewController:tradeSuccess animated:YES];
}



-(void)changeButtonOnClick:(UIButton *)button withModel:(XZMyOrderModel *)model
{
    
    self.OrderModel = model;
    if ([button.currentTitle isEqualToString:@"提醒发货"]) {
        [self RemindDeliveryFromDataSource:model withUrl:KMyOrder_OrderList_RemindDelivery_Url withProfmpt:@"提醒发货成功"];
    }else if ([button.currentTitle isEqualToString:@"取消订单"])
    {
         [self createCancelOrderView:model];
    }else if ([button.currentTitle isEqualToString:@"延长收货"])
    {
        WLRequestViewController *request = [[WLRequestViewController alloc]init];
        [self.navigationController pushViewController:request animated:YES];
    }else if ([button.currentTitle isEqualToString:@"确认收货"])
    {
        SignOnDeleteView *signOn = [[SignOnDeleteView alloc]init];
        [signOn showSignViewWithTitle:@"确认收货？" detail:@"确认收货之后请及时评价"];
        // 点击确定按钮
        signOn.sureBlock = ^(UIButton *button) {
            [self deleteOrderModelFromDataSource:model withUrl:KMyOrder_OrderList_ConfirmOrder_Url withProfmpt:@"确认收货成功"];
        };
    }else if ([button.currentTitle isEqualToString:@"收货评价"])
    {
        
    }else if ([button.currentTitle isEqualToString:@"订单跟踪"])
    {
        WLFollowingViewController *requestVC = [[WLFollowingViewController alloc]init];
        requestVC.nu = model.logi_no;// nu
        requestVC.com = model.shipping_name2;// com
        requestVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:requestVC animated:YES];
 
    }else if ([button.currentTitle isEqualToString:@"付款"])
    {
        
        [self openMenu];

    }else if ([button.currentTitle isEqualToString:@"申请售后"])
    {
        
        
        
    }else if ([button.currentTitle isEqualToString:@"删除订单"])
    {
        SignOnDeleteView *signOn = [[SignOnDeleteView alloc]init];
        [signOn showSignViewWithTitle:@"确认删除订单？" detail:@"删除之后无法恢复!"];
        // 点击确定按钮
        signOn.sureBlock = ^(UIButton *button) {
             [self deleteOrderModelFromDataSource:model withUrl:KMyOrder_OrderList_deleteOrder_Url withProfmpt:@"删除成功"];
        };
    }
}
/**
 *  有关选择支付方式的操作
 */

-(void)openMenu{
    
    //在这里呼出下方菜单按钮项
    _myActionSheet = [[UIActionSheet alloc]
                      
                      initWithTitle:nil
                      
                      delegate:self
                      
                      cancelButtonTitle:@"取消"
                      
                      destructiveButtonTitle:nil
                      
                      otherButtonTitles: @"支付宝付款", @"微信付款",nil];
    
    [_myActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //呼出的菜单按钮点击后的响应
    
    if (buttonIndex == _myActionSheet.cancelButtonIndex)
    {
        //        NSLog(@"取消");
    }
    
    switch (buttonIndex)
    {
        case 0:  // 支付宝付款
            [self payForOrderWithAliPayAndModel:self.OrderModel];
            break;
        case 1:  // 微信付款
            [self payForOrderWithWXPayAndModel:self.OrderModel];
            break;
    }
    
}

// 支付
- (void)payForOrderWithAliPayAndModel:(XZMyOrderModel *)model {
    // 支付宝支付
    CGFloat price = [model.total_amount floatValue];
    XZMyOrderGoodsModel * good = [model.goods_items firstObject];
    
//    NSString *url = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/paycenter-alipayCheck.html?oid=%@",model.order_id];
//    [self.payOrderStyle AliPayShopID:model.order_id withTitle:good.name Detail:good.name Price:model.total_amount Url:url Returl:url];

    NSString *url = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/paycenter-alipayCheck.html?oid=%@",model.order_id];
    [self.payOrderStyle AliPayShopID:model.order_id withTitle:good.name Detail:good.name Price:[NSString stringWithFormat:@"%.2f",price] Url:url Returl:url];

}
// 支付
- (void)payForOrderWithWXPayAndModel:(XZMyOrderModel *)model  {
    XZMyOrderGoodsModel * good = [model.goods_items firstObject];
    // 微信支付
    CGFloat price = [model.total_amount floatValue];
    NSString *wUrl = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/paycenter-wxpayCheck.html?oid=%@",model.order_id];
    [self.payOrderStyle WXPayShopID:model.order_id withTitle:good.name Detail:good.name Price:[NSString stringWithFormat:@"%.2f",price] Url:wUrl Returl:wUrl];
}
#pragma mark ---- collectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceCollection.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XZGoodsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"goodCollection" forIndexPath:indexPath];
    cell.shopModel = self.dataSourceCollection[indexPath.item];
    return  cell;
}
- (void)createNoOrderCollectionView {
    self.currentPage = 1;
    self.tableView.hidden = YES;
    /** collection */
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat width = (KProjectScreenWidth - 5.0)/ 2.0;
    CGFloat height = width + 80;
    flowLayout.itemSize = CGSizeMake(width, height);
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 5;
    // 设置section的头标题大小
    if (self.collection) {
        return;
    }
    flowLayout.headerReferenceSize = CGSizeMake(KProjectScreenWidth, 270);
    if (self.type == XZMyOrderTableViewTypeWaitComment) { // 待评论
        self.collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 159) collectionViewLayout:flowLayout];
    }else {
        self.collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 109) collectionViewLayout:flowLayout];
    }
    self.collection.backgroundColor = XZColor(230, 235, 240);
    [self.view addSubview:self.collection];
    
    // 注册cell
    [self.collection registerClass:[XZGoodsCollectionCell class] forCellWithReuseIdentifier:@"goodCollection"];
    
    // 注册UICollectionReusableView的headerView
    [self.collection registerClass:[XZCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReuseID];
    self.collection.showsVerticalScrollIndicator = NO;
    self.collection.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        self.currentPage = self.currentPage + 1;
        self.isAddData = YES;
        // 请求collectionView的数据
        [self getDataSourceFromNetWorkWithCollection];
    }];
    self.collection.dataSource = self;
    self.collection.delegate = self;
    // 请求数据
    [self getDataSourceFromNetWorkWithCollection];
}

-(void)getDataSourceFromNetWorkWithCollection
{
    //    FMGoodShopModel
    NSString * html = [NSString stringWithFormat:@"%@?cateid=0&p=%zi",KGoodShop_Index_ShopList_Url,self.currentPage];
    [FMHTTPClient postPath:html parameters:nil completion:^(WebAPIResponse *response) {
        if (response.code == WebAPIResponseCodeSuccess) {
            NSArray * products =response.responseObject[@"data"];
            if (!self.isAddData) {
                [self.dataSourceCollection removeAllObjects];
            }
            for (NSDictionary * dict in products) {
                FMGoodShopModel * model = [[FMGoodShopModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataSourceCollection addObject:model];
            }
        }
        [self.collection reloadData];
        [self.collection.mj_footer endRefreshing];
    }];

}

#pragma mark - UICollectionViewDelegateFlowLayout
// 设置section的头标题
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reuseableView = nil;
    // 如果是section的头
    if (kind == UICollectionElementKindSectionHeader) {
        XZCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReuseID forIndexPath:indexPath];
        reuseableView = headerView;
    }
    return reuseableView;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FMPlaceOrderViewController * placeOrder = [[FMPlaceOrderViewController alloc]init];

    FMGoodShopModel * model = self.dataSourceCollection[indexPath.item];
    
    if ([model.fulljifen_ex integerValue] == 0) {
        placeOrder.isShopFullScore = 0;
    }else
    {
        placeOrder.isShopFullScore = 1;

    }
    placeOrder.product_id = model.product_id;
    [self.navigationController pushViewController:placeOrder animated:YES];
}


/**
 *  删除订单\取消订单    我是在哪里看到你的，你有男朋友吗，我就想要一个你这样的女朋友，可惜是在网上，
 */
-(void)deleteOrderModelFromDataSource:(XZMyOrderModel *)model withUrl:(NSString *)url withProfmpt:(NSString *)profmpt
{
 //https://www.rongtuojinrong.com/qdy/wap/member-delorder_client.html?orderid=&from=rongtuoapp&tel=15966065659&appid=huiyuan&token=f9f828db40436e108678cc37bedd5c79&shijian=1456199802&user_id=191
    //KMyOrder_OrderList_deleteOrder_Url
    __weak __typeof(&*self)weakSelf = self;
    NSString * deleteString = [NSString stringWithFormat:@"%@&orderid=%@",[FMGoodShopURLManage getNewNetWorkURLWithBaseURL:url],model.order_id];
    [FMHTTPClient getPath:deleteString parameters:nil completion:^(WebAPIResponse *response) {
        
        if (response.code == WebAPIResponseCodeSuccess) {
            
            ShowAutoHideMBProgressHUD(weakSelf.view,profmpt);
            [weakSelf.dataSource removeObject:model];
            [weakSelf.tableView reloadData];
            
            if ([profmpt isEqualToString:@"确认收货成功"]) {
                [self confirmGoodArriveAddress];
            }
            
        }else
        {
            ShowAutoHideMBProgressHUD(weakSelf.view, @"请求失败");
        }
        
    }];
}


/**
 *  提醒发货订单
 */
- (void)RemindDeliveryFromDataSource:(XZMyOrderModel *)model withUrl:(NSString *)url withProfmpt:(NSString *)profmpt
{
    //https://www.rongtuojinrong.com/qdy/wap/member-delorder_client.html?orderid=&from=rongtuoapp&tel=15966065659&appid=huiyuan&token=f9f828db40436e108678cc37bedd5c79&shijian=1456199802&user_id=191
    //KMyOrder_OrderList_deleteOrder_Url
    __weak __typeof(&*self)weakSelf = self;
    NSString * deleteString = [NSString stringWithFormat:@"%@&orderid=%@",[FMGoodShopURLManage getNewNetWorkURLWithBaseURL:url],model.order_id];
    [FMHTTPClient getPath:deleteString parameters:nil completion:^(WebAPIResponse *response) {
        
        if (response.code == WebAPIResponseCodeSuccess) {
            
            ShowAutoHideMBProgressHUD(weakSelf.view,profmpt);
            
        }else
        {
            ShowAutoHideMBProgressHUD(weakSelf.view, @"请求失败");
        }
        
    }];
}

-(void)XZPayOrderResult:(NSInteger)rest;
{
    if (self.isShowPayView) {
        if (rest == 1) {
            //成功
            FMShowPayStatus *showPay = [[FMShowPayStatus alloc]init];
            showPay.delegate = self;
            [showPay showSuccessWithView:self.view];
        }else
        {
            FMShowPayStatus *showPay = [[FMShowPayStatus alloc]init];
            showPay.delegate = self;
            [showPay showFaileWithView:self.view];
        }
    }
   
}
-(void)FMShowPayStatusPayResult:(NSInteger)index;
{
    if (index == 1) {
        //查看订单
        
    }else
    {
        //返回首页
        FMRTWellStoreViewController * rootViewController;
        for (UIViewController * viewController in self.navigationController.viewControllers) {
            if ([viewController isKindOfClass:[FMRTWellStoreViewController class]]) {
                rootViewController = (FMRTWellStoreViewController *)viewController;
            }
        }
        if (rootViewController) {
            self.navigationController.navigationBarHidden = NO;
            [self.navigationController popToViewController:rootViewController animated:NO];
        }else { // 跳转优商城
            FMRTWellStoreViewController *goodShop = [[FMRTWellStoreViewController
                                                      alloc] init];
            goodShop.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:goodShop animated:YES];
        }
    }
}


-(void)confirmGoodArriveAddress
{
    if ([self.delegate respondsToSelector:@selector(XZMyOrderTableViewController:didselectTitle:)]) {
        [self.delegate XZMyOrderTableViewController:self didselectTitle:(3 + 1)];
    }
}

-(void)refreshView;
{
    self.tableView.contentOffset = CGPointMake(0, 0);
    self.tableView.mj_header.refreshingBlock();
}

@end
