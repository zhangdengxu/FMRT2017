//
//  XZTradeSuccessViewController.m
//  XZFenLeiJieMian
//
//  Created by rongtuo on 16/4/27.
//  Copyright © 2016年 yuyang. All rights reserved.
//

#import "XZTradeSuccessViewController.h"
#import "XZTradeSuccessGoodsCell.h"
#import "YSCustomerSerViewController.h"
#import "WLFollowingViewController.h"
#import "WLRequestViewController.h"
#import "XZMyOrderModel.h"
#import "XMTradeTableviewHeader.h"
#import "FMTradeDetailViewCell.h"
#import "FMTradeTableViewFooter.h"
#import "FMGoodShopURL.h"
#import "FMGoodShopURLManage.h"
#import "XZMyOrderGoodsModel.h"

// 提示框
#import "SignOnDeleteView.h"
#import "FMCanaelOrderShowView.h"
#import "XZChoosePictureWayView.h"
#import "XZPayOrder.h"

#import "FMShowPayStatus.h"
#import "FMRTWellStoreViewController.h"
#import "FMPlaceOrderViewController.h"


#import "FMMessageAlterView.h"
#import "WLMessageViewController.h"
#import "FMRTWellStoreViewController.h"
@interface XZTradeSuccessViewController ()<UITableViewDataSource,UITableViewDelegate,XZPayOrderDelegate,FMShowPayStatusDelegate,UIActionSheetDelegate,FMMessageAlterViewDelegate>
@property (nonatomic, strong) UITableView * tableView;


@property (nonatomic, strong) XMTradeTableviewHeader * tableViewHeader;
@property (nonatomic, strong) FMTradeTableViewFooter * tableViewFooter;


// 支付方式
@property (nonatomic, strong) XZPayOrder * payOrderStyle;
// 提示框
@property (nonatomic,strong) UIActionSheet * myActionSheet;
@end

@implementation XZTradeSuccessViewController
-(XZPayOrder *)payOrderStyle
{
    if (!_payOrderStyle) {
        _payOrderStyle = [[XZPayOrder alloc]init];
        _payOrderStyle.delegate = self;
    }
    return _payOrderStyle;
}
-(XMTradeTableviewHeader *)tableViewHeader
{
    if (!_tableViewHeader) {
        
        _tableViewHeader = [[XMTradeTableviewHeader alloc]initWithorderModel:self.orderModel.headerModel];
         __weak __typeof(&*self)weakSelf = self;
        _tableViewHeader.blockBtn = ^(){
            WLFollowingViewController *requestVC = [[WLFollowingViewController alloc]init];
            requestVC.nu = weakSelf.orderModel.logi_no;
            requestVC.com = weakSelf.orderModel.shipping_name2;
            requestVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:requestVC animated:YES];
        };
    }
    return _tableViewHeader;
}
-(FMTradeTableViewFooter *)tableViewFooter
{
    if (!_tableViewFooter) {
        _tableViewFooter = [[FMTradeTableViewFooter alloc]initWithorderModel:self.orderModel.footerModel];
         __weak __typeof(&*self)weakSelf = self;
        _tableViewFooter.blockCopyBtn = ^(UIButton * button)
        {
            UIPasteboard *paste = [UIPasteboard generalPasteboard];
            NSString *string = weakSelf.orderModel.footerModel.order_id;// cell的订单号
            [paste setString:string];
            if (paste == nil) {
                /*
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil  message:@"订单号复制失败，请重新复制" preferredStyle:UIAlertControllerStyleAlert];
                [weakSelf presentViewController:alert animated:YES completion:nil];
                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                }];
                [alert addAction:sure];
                */
                ShowAutoHideMBProgressHUD(weakSelf.view, @"订单号复制失败，请重新复制");

            }else
            {
                /*
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil  message:@"订单号复制成功" preferredStyle:UIAlertControllerStyleAlert];
                [weakSelf presentViewController:alert animated:YES completion:nil];
                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //[weakSelf dismissViewControllerAnimated:YES completion:nil];
                }];
                [alert addAction:sure];
                Log(@"%@",paste.string);
                 */
                ShowAutoHideMBProgressHUD(weakSelf.view, @"订单号复制成功");
            }
        };
    }
    return _tableViewFooter;
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 49) style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionFooterHeight = 8;
        _tableView.sectionHeaderHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.tableFooterView = self.tableViewFooter;
        // 刷新
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

            // 从网络上请求数据
            [self getdataSourceFromNetWork];
        }];

        
    }
    return _tableView;
}


- (void)setNavItemsWithButton {
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    messageButton.frame =CGRectMake(0, 0, 30, 30);
    [messageButton setImage:[UIImage imageNamed:@"优商城售后_未读消息_36"] forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(moreItemAction:) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *navItem = [[UIBarButtonItem alloc]initWithCustomView:messageButton];
    [self.navigationItem setRightBarButtonItems:@[navItem] animated:YES];
}

- (void)moreItemAction:(UIButton *)sender {
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


- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"订单详情"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [self setNavItemsWithButton];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getdataSourceFromNetWork];
}

-(void)setOrderModel:(XZMyOrderModel *)orderModel
{
    
    _orderModel = orderModel;
}

-(void)getdataSourceFromNetWork
{
    //https://www.rongtuojinrong.com/qdy/wap/member-orderdetail_client.html?orderid=160521163637310&from=rongtuoapp&tel=15966065659&appid=huiyuan&token=f9f828db40436e108678cc37bedd5c79&shijian=1456199802&user_id=191
    NSString * urlData = [NSString stringWithFormat:@"%@&orderid=%@", [FMGoodShopURLManage getNewNetWorkURLWithBaseURL:KMyOrder_OrderList_OrderDetail_Url],self.orderModel.order_id];
    
    [FMHTTPClient getPath:urlData parameters:nil completion:^(WebAPIResponse *response) {
        if (response.code == WebAPIResponseCodeSuccess) {
            NSDictionary * data = response.responseObject[@"data"];
            // 头视图
            FMOrderDetailLocationModel * detailLocation = [[FMOrderDetailLocationModel alloc]init];
            [detailLocation createDataSourceWithDictionary:data[@"consignee"]];
            detailLocation.orderStatusFM = self.orderModel.orderStatusFM;
            // 尾视图
            NSDictionary *shipping = data[@"shipping"];
            FMOrderDetailGoodsModel *detailGoods = [[FMOrderDetailGoodsModel alloc]init];
            [detailGoods setValuesForKeysWithDictionary:data];
            detailGoods.cost_shipping = shipping[@"cost_shipping"];
            detailGoods.send_time = data[@"send_time"];
            detailGoods.order_type = data[@"order_type"];
            // 商品
            NSArray * goods_items = data[@"goods_items"];
            NSMutableArray * goodsItemArray = [NSMutableArray array];
            for (NSDictionary * dictionary in goods_items) {
                XZMyOrderGoodsModel * goodModel = [[XZMyOrderGoodsModel alloc]init];
                [goodModel setValuesForKeysWithDictionary:dictionary];
                goodModel.orderStatusFM = self.orderModel.orderStatusFM;
                
                goodModel.used_jifen = detailGoods.used_jifen;
                goodModel.order_type = data[@"order_type"];
                [goodsItemArray addObject:goodModel];
            }
            
            self.orderModel.goods_items = goodsItemArray;
            
            if (data[@"shipping"]) {
                NSDictionary * infoShip = data[@"shipping"];
                if (infoShip[@"shipping_name2"]) {
                    self.orderModel.shipping_name2 = [NSString stringWithFormat:@"%@",infoShip[@"shipping_name2"]];
                    Log(@"====>%@",infoShip[@"shipping_name2"]);
                }
            }
            
            if (data[@"logi_no"]) {
                self.orderModel.logi_no = [NSString stringWithFormat:@"%@", data[@"logi_no"]];
            }
            
            self.orderModel.headerModel = detailLocation;
            self.orderModel.footerModel = detailGoods;
            
            [self.tableView reloadData];
            
            [self continuewithBottomView];
            
            [self getAddressInfoFromNetWork];
        }else
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.tableView.mj_header endRefreshing];
        }
        
    }];
}
-(void)getAddressInfoFromNetWork
{
  
    if (!(self.orderModel.shipping_name2.length > 0 && self.orderModel.logi_no.length > 0)) {
        
        self.tableView.tableHeaderView = self.tableViewHeader;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.tableView.mj_header endRefreshing];

        return;
    }
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSString *string = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/member-msg_detail_client.html?from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%d&user_id=%@",[CurrentUserInformation sharedCurrentUserInfo].mobile,tokenlow,timestamp,[CurrentUserInformation sharedCurrentUserInfo].userId];
    
    NSDictionary *parameter = @{@"com":self.orderModel.shipping_name2,@"nu":self.orderModel.logi_no};
    [FMHTTPClient postPath:string parameters:parameter completion:^(WebAPIResponse *response) {

        if (response.code==WebAPIResponseCodeSuccess){
            
            NSDictionary  *dicWai = response.responseObject[@"data"];
            NSArray * dic = dicWai[@"data"];
            if (![dic isMemberOfClass:[NSNull class]]) {
                
                NSMutableArray * muArray = [NSMutableArray array];
                
                for (NSDictionary * diction in dic) {
                    FMOrderAddress * orderAddress = [[FMOrderAddress alloc]init];
                    [orderAddress setValuesForKeysWithDictionary:diction];
                    [muArray addObject:orderAddress];
                    
                }
                if (muArray.count > 0) {
                     self.orderModel.headerModel.orderAddresss = muArray[0];
                    self.tableView.tableHeaderView = self.tableViewHeader;
                }else
                {
                    self.tableView.tableHeaderView = self.tableViewHeader;
                }
            }else
            {
                self.tableView.tableHeaderView = self.tableViewHeader;
            }
        }else
        {
            self.tableView.tableHeaderView = self.tableViewHeader;

        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.tableView.mj_header endRefreshing];


    }];

}

// 创建底部ButtomView
- (void)continuewithBottomView {
    
    if ((self.orderModel.orderStatusFM == 21) || (self.orderModel.orderStatusFM == 31)) { // 交易成功
        [self createAdditionalEvaluationViewWithArray:@[@"订单跟踪"]];
        //[self createAdditionalEvaluationViewWithArray:@[@"删除订单",@"订单跟踪"]];
    }else if (self.orderModel.orderStatusFM == 61) // 等待买家付款
    {
        [self createAdditionalEvaluationViewWithArray:@[@"付款",@"取消订单"]];
    }else if ((self.orderModel.orderStatusFM == 1) || (self.orderModel.orderStatusFM == 12)) // 交易关闭
    {
        [self createAdditionalEvaluationViewWithArray:@[@"删除订单"]];
    }else if (self.orderModel.orderStatusFM == 51) // 买家已付款，但还未发货
    {
        [self createAdditionalEvaluationViewWithArray:@[@"提醒发货"]]; // ,@"订单跟踪"
    }else if (self.orderModel.orderStatusFM == 41)// 卖家发货但用户还未收到货
    {
        [self createAdditionalEvaluationViewWithArray:@[@"确认收货",@"订单跟踪"]];

    }else if (self.orderModel.orderStatusFM == 11) { // 售后申请中
        [self createAdditionalEvaluationViewWithArray:@[@"删除订单"]];
        
    }

    
   
}
#pragma mark ----- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
   
    return [self.orderModel.goods_items count];


}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    XZMyOrderGoodsModel * good = self.orderModel.goods_items[indexPath.row];;
    CGSize size = [good.name getStringCGSizeWithMaxSize:CGSizeMake(width, MAXFLOAT) WithFont:[UIFont systemFontOfSize:font]];
    CGFloat aLLHeight = KProjectScreenWidth * 0.2 + 12;
    
    
    CGFloat rightHeight = (size.height + 18 + 15) > (25 * 3)?(size.height + 18 + 15):(25 * 3);
    CGFloat realHeigh ;
    if (self.isShowComment) {
        
        if (([good.aftersales integerValue] != 0)||(![good.order_type isMemberOfClass:[NSNull class]]&&[good.order_type integerValue] != 0)) {
            realHeigh = aLLHeight > rightHeight? aLLHeight: rightHeight;
            realHeigh = realHeigh + 10;
        }else
        {
            rightHeight = rightHeight + 30 * radio + 15;
            realHeigh = aLLHeight > rightHeight? aLLHeight: rightHeight;
        }

    }else{
        

        if (good.orderStatusFM == 1) {
            //隐藏
            realHeigh = aLLHeight > rightHeight? aLLHeight: rightHeight;

            realHeigh = realHeigh + 10;
        }else if([good.aftersales integerValue] == 1){
            
            //已经申请售后
            //隐藏
            realHeigh = aLLHeight > rightHeight? aLLHeight: rightHeight;
            
            realHeigh = realHeigh + 10;
            
        }else if (good.orderStatusFM < 22) {
            if ([good.aftersales integerValue] != 0) {
                //隐藏
                realHeigh = aLLHeight > rightHeight? aLLHeight: rightHeight;

                realHeigh = realHeigh + 10;
            }else
            {
                //不隐藏
                rightHeight = rightHeight + 30 * radio + 15;
                realHeigh = aLLHeight > rightHeight? aLLHeight: rightHeight;            }
        }else if((good.orderStatusFM == 41 ||good.orderStatusFM == 51)&&!(![good.order_type isMemberOfClass:[NSNull class]]&&[good.order_type integerValue] != 0)){
            //待收货，待发货不隐藏按钮，退款
            //不隐藏
            rightHeight = rightHeight + 30 * radio + 15;
            realHeigh = aLLHeight > rightHeight? aLLHeight: rightHeight;
        }else
        {
            //隐藏
            realHeigh = aLLHeight > rightHeight? aLLHeight: rightHeight;
            
            realHeigh = realHeigh + 10;
        }
        
        
    }
    return realHeigh;
    
  
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FMTradeDetailViewCell *cell = [FMTradeDetailViewCell cellTradeSuccessGoodsWithTableView:tableView];
    
    if ([self.orderModel.goods_items count]> 0) { // 如果数据不为空的话赋值
        XZMyOrderGoodsModel *goodsModel = self.orderModel.goods_items[indexPath.row];
        
        cell.isOrderDetail = 1;

        if (self.isShowComment) {
            cell.isShowComment = YES;
            cell.afterSalesBtnTitle = @"申请售后";
        }else if([goodsModel.aftersales integerValue] == 1){
            
            cell.isShowComment = NO;
            
        }else if((goodsModel.orderStatusFM == 41 ||goodsModel.orderStatusFM == 51)&&!(![goodsModel.order_type isMemberOfClass:[NSNull class]]&&[goodsModel.order_type integerValue] != 0))
        {
            //goodsModel.order_type =0 普通商品，1为积分兑换
            cell.isShowComment = NO;
            cell.afterSalesBtnTitle = @"退款";
        }else
        {
            cell.afterSalesBtnTitle = @"申请售后";
        }
        
        
        
        cell.goodsModel = goodsModel;
    }
    __weak __typeof(&*self)weakSelf = self;
    __weak typeof(cell)weakCell = cell;
    cell.blockAfterSalesBtn =^(UIButton *button) {
        
        WLRequestViewController *YSvc = [[WLRequestViewController alloc]init];
        YSvc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:YSvc animated:YES];
        YSvc.model = weakCell.goodsModel;
     };

    return cell;

    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XZMyOrderGoodsModel * goodModel = self.orderModel.goods_items[indexPath.row];
    if ([goodModel.order_type integerValue ] > 0) {
        //积分商品
        FMPlaceOrderViewController * placeOrder = [[FMPlaceOrderViewController alloc]init];
        placeOrder.isShopFullScore = 1;
        placeOrder.product_id = goodModel.product_id;
        [self.navigationController pushViewController:placeOrder animated:YES];
    }else
    {

        //非积分商品
        FMPlaceOrderViewController * placeOrder = [[FMPlaceOrderViewController alloc]init];
        placeOrder.isShopFullScore = 0;
        placeOrder.product_id = goodModel.product_id;
        
        [self.navigationController pushViewController:placeOrder animated:YES];
    
       
    }
}

// 下方追加评价、订单跟踪、删除订单
- (void)createAdditionalEvaluationViewWithArray:(NSArray *)titleArray
{
    // 整体的view
    UIView *payView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 49, KProjectScreenWidth, 50)];
    [self.view addSubview:payView];
    [self.view bringSubviewToFront:payView];
    payView.backgroundColor = [UIColor whiteColor];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [payView addSubview:lineView];
    
    CGFloat width = 80;
    CGFloat heigh = 30;
    CGFloat margion = 10;
    for (NSInteger i = 0; i < titleArray.count; i++) {
        /** 追加评价按钮 */
        UIButton *btnAddEvaluation = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat origin_x = KProjectScreenWidth - (i + 1) * (width + margion);
        btnAddEvaluation.frame = CGRectMake(origin_x, 10, width, heigh);
        btnAddEvaluation.titleLabel.font = [UIFont systemFontOfSize:13];
        [payView addSubview:btnAddEvaluation];
        if ( i == 0 ) {
            btnAddEvaluation.backgroundColor = XZColor(6, 41, 125);
        }else
        {
            btnAddEvaluation.backgroundColor = [UIColor whiteColor];
            [btnAddEvaluation setTitleColor:XZColor(48, 48, 48) forState:UIControlStateNormal];
            btnAddEvaluation.layer.borderColor = [XZColor(235, 235, 242) CGColor];
            btnAddEvaluation.layer.borderWidth = 1.0f;
        }
        [btnAddEvaluation setTitle:titleArray[i] forState:UIControlStateNormal];
        
        [btnAddEvaluation addTarget:self action:@selector(btnAddEvaluation:) forControlEvents:UIControlEventTouchUpInside];

    }
}

-(void)btnAddEvaluation:(UIButton *)button
{
    if ([button.currentTitle isEqualToString:@"提醒发货"]) {
        [self RemindDeliveryFromDataSource:self.orderModel withUrl:KMyOrder_OrderList_RemindDelivery_Url withProfmpt:@"提醒发货成功"];
    }else if ([button.currentTitle isEqualToString:@"取消订单"])
    {
        [self createCancelOrderView:self.orderModel];
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
            [self deleteOrderModelFromDataSource:self.orderModel withUrl:KMyOrder_OrderList_ConfirmOrder_Url withProfmpt:@"确认收货成功"];
        };
    }else if ([button.currentTitle isEqualToString:@"收货评价"])
    {
        
    }else if ([button.currentTitle isEqualToString:@"付款"])
    {
        [self payOrderFunction];
    }else if ([button.currentTitle isEqualToString:@"订单跟踪"])
    {

        WLFollowingViewController *requestVC = [[WLFollowingViewController alloc]init];
        requestVC.nu = self.orderModel.logi_no;
        requestVC.com = self.orderModel.shipping_name2;
        requestVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:requestVC animated:YES];
    }
    else if ([button.currentTitle isEqualToString:@"申请售后"])
    {
        
    }else if ([button.currentTitle isEqualToString:@"删除订单"])
    {
        SignOnDeleteView *signOn = [[SignOnDeleteView alloc]init];
        [signOn showSignViewWithTitle:@"确认删除订单？" detail:@"删除之后无法恢复!"];
        // 点击确定按钮
        signOn.sureBlock = ^(UIButton *button) {
            [self deleteOrderModelFromDataSource:self.orderModel withUrl:KMyOrder_OrderList_deleteOrder_Url withProfmpt:@"删除成功"];
        };
    }else if([button.currentTitle isEqualToString:@"退款"])
    {
        //退款
        
    }

}
/**
 *  有关选择支付方式的操作
 */

-(void)payOrderFunction {
    
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
            [self payForOrderWithAliPayAndModel:self.orderModel];
            break;
        case 1:  // 微信付款
            [self payForOrderWithWXPayAndModel:self.orderModel];
            break;
    }
    
}

//-(void)payOrderFunction
//{
//    XZChoosePictureWayView *choosePicture = [[XZChoosePictureWayView alloc]initWithFrame:CGRectMake(0, -45, KProjectScreenWidth, KProjectScreenHeight)];
//    [self.view addSubview:choosePicture];
//    [choosePicture setWayViewWithFirstButtonTitle:@"支付宝付款" secondButtonTitle:@"微信付款" withLabelPrompt:@"请选择支付方式"];
//    __weak typeof(choosePicture)weakCP = choosePicture;
//    choosePicture.blockChoosePictureBtn = ^(UIButton * button) {
//        if (button.tag == 301) { // 支付宝付款
//            [weakCP removeFromSuperview];
//            [self payForOrderWithAliPayAndModel:self.orderModel];
//            
//        }else if (button.tag == 302) { // 微信付款
//            [weakCP removeFromSuperview];
//            [self payForOrderWithWXPayAndModel:self.orderModel];
//            
//        }else {
//            [weakCP removeFromSuperview];
//        }
//    };

//}
/**
 *  删除订单\取消订单
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
            
            if ([profmpt isEqualToString:@"确认收货成功"]) {
                [self confirmGoodArriveAddress];
            }else
            {
                [self.navigationController popViewControllerAnimated:YES];
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

// 取消订单界面
- (void)createCancelOrderView:(XZMyOrderModel *)model {
    FMCanaelOrderShowView * showView = [[FMCanaelOrderShowView alloc]initWithCancelDataArr: @[@"我不想买了",@"信息填写失误，重新拍",@"卖家缺货",@"同城交易",@"其他原因"]];
    [showView showSelfView];
    __weak __typeof(&*self)weakSelf = self;
    showView.blockSureBtn = ^(UIButton *button) {
        [weakSelf deleteOrderModelFromDataSource:model withUrl:KMyOrder_OrderList_cancelOrder_Url withProfmpt:@"取消订单成功"];
    };
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
// 微信支付
- (void)payForOrderWithWXPayAndModel:(XZMyOrderModel *)model  {
    XZMyOrderGoodsModel * good = [model.goods_items firstObject];
    // 微信支付
    CGFloat price = [model.total_amount floatValue];
    NSString *wUrl = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/paycenter-wxpayCheck.html?oid=%@",model.order_id];
    [self.payOrderStyle WXPayShopID:model.order_id withTitle:good.name Detail:good.name Price:[NSString stringWithFormat:@"%.2f",price] Url:wUrl Returl:wUrl];
}
-(void)XZPayOrderResult:(NSInteger)rest;
{
    if (rest == 1) {
        //成功
        FMShowPayStatus * showPay = [[FMShowPayStatus alloc]init];
        showPay.delegate = self;
        [showPay showSuccessWithView:self.view];
    }else
    {
        FMShowPayStatus * showPay = [[FMShowPayStatus alloc]init];
        showPay.delegate = self;
        [showPay showFaileWithView:self.view];
    }
}
-(void)FMShowPayStatusPayResult:(NSInteger)index;
{
    if (index == 1) {
        //查看订单
        [self.navigationController popViewControllerAnimated:YES];
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
        }
    }
}
-(void)confirmGoodArriveAddress
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];

        if (self.blockInfo) {
            self.blockInfo(1);
        }
    });
}

@end
