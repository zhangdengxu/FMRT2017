//
//  FMShoppingListViewController.m
//  fmapp
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMShoppingListViewController.h"
#import "FMShoppingListBottomView.h"
#import "FMShoppingListCell.h"
#import "FMShoppigListBottomEditView.h"
#import "FMShopingPastTableViewCell.h"
#import "FMShoppingListFootView.h"
#import "FMShoppingListShareView.h"
#import "FMShoppingListScanView.h"
#import "Fm_Tools.h"
#import "FMShoppingListGatherCell.h"
//#import "XZConfirmOrderViewController.h"
#import "UMSocialData.h"
#import "UMSocialConfig.h"
#import "UMSocialControllerService.h"
#import "UMSocialSnsPlatformManager.h"
#import "MJExtension.h"
#import "SignOnDeleteView.h"
#import "FMGatherViewController.h"
#import "FMPlaceOrderViewController.h"
#import "FMStyleModel.h"
//#import "FMShowSelectView.h"
#import "FMButtonStyleModel.h"
#import "FMShopSpecModel.h"
#import "WLMessageViewController.h"
#import "FMGoodsShopSelectShopView.h"
#import "AppDelegate.h"
#import "XZOptimalMallSubmitOrderController.h" // 优商城确认订单
#import "XZIntegralConfirmOrderController.h"//  积分兑换确认订单

@interface FMShoppingListViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>

@property (nonatomic, strong) UITableView                   *tableView;
@property (nonatomic, strong) NSMutableArray                *dataSource, *pastDataSource, *shareImageData;
@property (nonatomic, assign) float                         totalPrice, totalNumber;
@property (nonatomic, strong) FMShoppingListBottomView      *bottomView;
@property (nonatomic, strong) FMShoppigListBottomEditView   *editBottomView;
@property (nonatomic, strong) UIButton                      *allSelectButton;
@property (nonatomic, strong) UILabel                       *allSelectLabel;
@property (nonatomic, strong) UIView                        *emptyView;
@property (nonatomic, assign) NSInteger                     sectionCount, rowCount;
@property (nonatomic, strong) FMShoppingListShareView       *shareView;
@property (nonatomic, assign) BOOL                          isOver, isAddData;
@property (nonatomic, copy)   NSString                      *sess_id;

@end

@implementation FMShoppingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self settingNavTitle:@"购物车"];
    [self setNavItemsWithButton];
    [self createTableView];
    [self bottomViewForShoppingList];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.totalNumber = 0;
    self.totalPrice = 0.0;
    [self.shareImageData removeAllObjects];
    self.allSelectButton.selected = NO;
    [self.bottomView sendeDataWith:[NSString stringWithFormat:@"%.2f",self.totalPrice] withNumber:0];
    [self getDataSourceFromNetWork];
}

- (void)getDataSourceFromNetWork {


    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%@&user_id=%@",KFMShoppingListUrl,[CurrentUserInformation sharedCurrentUserInfo].mobile,tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId];
    FMWeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FMHTTPClient postPath:urlStr parameters:nil completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if (response.responseObject == nil) {
            ShowAutoHideMBProgressHUD(weakSelf.view,@"请求网络数据失败！");
            
        }else{
        
            if (response.code == WebAPIResponseCodeSuccess) {
                
                [weakSelf.dataSource removeAllObjects];
                [weakSelf.pastDataSource removeAllObjects];
                
                NSDictionary * objectDic = response.responseObject[@"data"];
                weakSelf.sess_id = [objectDic objectForKey:@"sess_id"];
                NSArray *array = [objectDic objectForKey:@"active"];
                NSArray *pastData = [objectDic objectForKey:@"expired"];
                if ([array isKindOfClass:[NSNull class]] && [pastData isKindOfClass:[NSNull class]]) {
                    weakSelf.emptyView.hidden = NO;
                }
                if (array.count == 0 && pastData.count == 0) {
                    weakSelf.emptyView.hidden = NO;
                }
                if ([array isKindOfClass:[NSArray class]]) {
                    
                    if (array.count < 10) {
                        weakSelf.isOver = YES;
                    }
                    
                    if (_isAddData) {
                        _isAddData = NO;
                    }else{
                        [weakSelf.dataSource removeAllObjects];
                    }
                    if (array.count) {
                        
                        [weakSelf.dataSource removeAllObjects];
                        for (NSDictionary *dic in array) {
 
                            FMShoppingListModel *model = [FMShoppingListModel mj_objectWithKeyValues:dic];
                         
                            model.selectCount = model.quantity;
                            model.sess_id = weakSelf.sess_id;
                            [weakSelf.dataSource addObject:model];
                            
                            weakSelf.rowCount = weakSelf.dataSource.count + 1;
                            [weakSelf settingNavTitle:[NSString stringWithFormat:@"购物车(%lu)",(unsigned long)weakSelf.dataSource.count]];

                            if (model.spec.count) {
                                NSMutableString *strAll = [NSMutableString string];
                                for (FMStyleModel *styleModel in model.spec) {
                                    
                                    NSString *sameTyle = [NSString stringWithFormat:@"%@:%@  ",styleModel.k,styleModel.v];
                                    [strAll appendString:sameTyle];
                                }
                                model.currentStyle = [NSString stringWithString:strAll];
                            }else{
                            }
                        }
                        
                    }else{
                        
                    }
                }
                if ([pastData isKindOfClass:[NSArray class]]) {
                    if (pastData.count) {
                        
                        [weakSelf.pastDataSource removeAllObjects];
                        for (NSDictionary *dic in pastData) {
                            
                            FMShoppingListModel *model = [FMShoppingListModel mj_objectWithKeyValues:dic];
                            
                            model.selectCount = model.quantity;
                            
                            [weakSelf.pastDataSource addObject:model];
                        }
                    }
                }
                
                if (weakSelf.pastDataSource.count == 0) {
                    weakSelf.tableView.tableFooterView.hidden = YES;
                    if (weakSelf.dataSource.count) {
                        weakSelf.sectionCount = 1;
                    }else{
                        weakSelf.sectionCount = 0;
                        [weakSelf settingNavTitle:@"购物车"];

                    }
                    
                }else if (weakSelf.pastDataSource.count){
                    weakSelf.tableView.tableFooterView.hidden = NO;
                    
                    if (weakSelf.dataSource.count) {
                        weakSelf.sectionCount = 2;
                    }else{
                        weakSelf.sectionCount =1;
                    }
                }

            }else{
                
                if ([response.responseObject objectForKey:@"msg"]) {
                    
                    NSString *msgStr = [response.responseObject objectForKey:@"msg"];
                    
                    ShowAutoHideMBProgressHUD(weakSelf.view, msgStr);
                }else{
                    ShowAutoHideMBProgressHUD(weakSelf.view, @"请求数据失败！");
                }
                
            }
        }
        weakSelf.totalNumber = 0;
        weakSelf.totalPrice = 0.0;
        weakSelf.allSelectButton.selected = NO;
        [weakSelf.bottomView sendeDataWith:[NSString stringWithFormat:@"%.2f",self.totalPrice] withNumber:0];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];

    }];
}

- (void)createTableView {
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = KDefaultOrBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
    }];
    
    __weak typeof (self) weakSelf = self;
    FMShoppingListFootView *footView = [[FMShoppingListFootView alloc]init];
    footView.block = ^(UIButton *sender){
        [weakSelf clearPastGoods];
    };
    self.tableView.tableFooterView = footView;
    self.tableView.tableFooterView.hidden = YES;
    self.emptyView.hidden = YES;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.isOver = NO;
        _isAddData = NO;
        [self getDataSourceFromNetWork];
    }];

}

- (void)clearPastGoods {
    
    SignOnDeleteView *deleteView = [[SignOnDeleteView alloc]init];
    [deleteView showSignViewWithTitle:@"确认清空失效宝贝么？" detail:@"清空后就无法恢复宝贝了"];
    __weak typeof (self)weakSelf = self;
    deleteView.sureBlock = ^(UIButton *sender){

        for (NSInteger index = 0; index < self.pastDataSource.count; index++) {
            FMShoppingListModel *model = self.pastDataSource[index];
            [self deleteShoppingListWithPostNetworkWithModel:model index:nil];
        }
        weakSelf.sectionCount --;
        [weakSelf.pastDataSource removeAllObjects];
        [weakSelf.tableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:(UITableViewRowAnimationAutomatic)];
        self.tableView.tableFooterView.hidden = YES;
        [weakSelf.tableView reloadData];
    };
}

- (void)editButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;

    for (FMShoppingListModel *model in self.dataSource) {
        model.navSelectState = sender.selected;
    }

    [self.tableView reloadData];
    
    if (sender.selected) {
        self.bottomView.hidden = YES;
        self.editBottomView.hidden = NO;
    }else {
        self.bottomView.hidden = NO;
        self.editBottomView.hidden = YES;
        
        for (FMShoppingListModel *model in self.dataSource) {
            [self shoppingListChangeNumberWithModel:model];
        }
    }
}

- (void)rightAction:(UIButton *)sender {
    WLMessageViewController *messageVC = [[WLMessageViewController alloc]init];
    
    [self.navigationController pushViewController:messageVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {

        return self.rowCount;
    }else{
        return self.pastDataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == self.dataSource.count) {

            FMShoppingListGatherCell *cell = [[FMShoppingListGatherCell alloc]init];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

            __weak typeof (self)weakSelf = self;
            cell.block= ^(UIButton *sender){
               [weakSelf gatherGoodsWithClick];
            };
            
            return cell;
        }else {
            static NSString *identifier = @"FMShoppingListViewController";
            FMShoppingListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[FMShoppingListCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
            }
            
            FMShoppingListModel *model = self.dataSource[indexPath.row];
            [cell sendDataToCellWith:model];

            __weak typeof (self)weakSelf = self;
            cell.selectBlcok = ^(UIButton * sender){
                [weakSelf clickSelectButton:indexPath sender:sender];
            };
            cell.deleteBlcok = ^(UIButton * sender){
                [weakSelf clickDeleteButton:sender withIndexPath:indexPath];
            };
            cell.plusBlcok = ^(UIButton * sender){
                [weakSelf clickPlusButton:sender withIndexPath:indexPath];
            };
            cell.minusBlcok = ^(UIButton * sender){
                [weakSelf clickMinusButton:sender withIndexPath:indexPath];
            };

            cell.typeBlcok = ^(UIButton * sender){
                
                if (model.spec.count) {
                     [weakSelf clickTypeButton:sender withIndexPath:indexPath];
                }else{
                    ShowAutoHideMBProgressHUD(self.view, @"没有更多商品参数");
                }
            };
            cell.editBlcok = ^(UIButton *sender) {
                [weakSelf clickEditButton:sender withIndexPath:indexPath];
            };
            cell.photoBlcok = ^(){
                [weakSelf clickPhotoViewwithIndexPath:indexPath];
            };
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

            return cell;
        }
    }
    static NSString *identifier = @"FMShoppingListViewPast";
    FMShopingPastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[FMShopingPastTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    FMShoppingListModel *model = self.pastDataSource[indexPath.row];
    [cell sendDataToCellWith:model];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)clickPhotoViewwithIndexPath:(NSIndexPath *)indexPath{
    FMShoppingListModel *model = self.dataSource[indexPath.row];
    
    
    FMPlaceOrderViewController *detailVC = [[FMPlaceOrderViewController alloc]init];
    detailVC.product_id = model.product_id;
    [self.navigationController pushViewController:detailVC animated:YES];

}

- (void)gatherGoodsWithClick {

    FMGatherViewController *gatherVC = [[FMGatherViewController alloc]init];
    [self.navigationController pushViewController:gatherVC animated:YES];
}

- (void)clickEditButton:(UIButton *)sender withIndexPath:(NSIndexPath *)indexPath  {
    
    FMShoppingListCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    FMShoppingListModel *model = self.dataSource[indexPath.row];
    
    FMShoppingListModel *newModel = [FMShoppingListModel mj_objectWithKeyValues:model.mj_keyValues];
    
    newModel.product_id = model.modify_Product_id;
    newModel.goods_id = model.modify_Goods_id;
    
    if (!sender.selected) {
        [cell sendDataToCellWithModel:newModel];
        [self.tableView reloadData];
        [self shoppingListChangeNumberWithModel:model];
    }
}

- (void)deleteShoppingListWithPostNetworkWithModel:(FMShoppingListModel *)model{
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSString *deleteUrl = [NSString stringWithFormat:@"%@?from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%@&user_id=%@",KFMShoppingListDeleteUrl,[CurrentUserInformation sharedCurrentUserInfo].mobile,tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId];
    
    NSString *goods_ident = [NSString stringWithFormat:@"goods_%ld_%ld",(long)[model.goods_id integerValue],(long)[model.product_id integerValue]];
    
    NSString *modify = [NSString stringWithFormat:@"modify_quantity[goods_%ld_%ld][quantity]",(long)[model.goods_id integerValue],(long)[model.product_id integerValue]];
    
    NSDictionary * parameter = @{
                                 @"min"             :@(1),
                                 @"max"             :@(100),
                                 @"stock"           :@(10),
                                 @"obj_type"        :@"goods",
                                 @"goods_ident"     :goods_ident,
                                 @"goods_id"        :model.goods_id,
                                 modify             :[NSString stringWithFormat:@"%ld", (long)model.selectCount],
                                 @"response_type"   :@"true"
                                 };
    
    [FMHTTPClient postPath:deleteUrl parameters:parameter completion:^(WebAPIResponse *response) {

    }];
}

- (void)addToShoppingListAfterDeleteWith:(FMShoppingListModel *)model {
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSString *addToShoppingListUrl = [NSString stringWithFormat:@"%@?from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%@&user_id=%@&goods[goods_id]=%@&goods[product_id]=%@&goods[num]=%@&mini_cart=%@",KGoodShop_ShopDetail_AddShopList_Url,[CurrentUserInformation sharedCurrentUserInfo].mobile,tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId,model.modify_Goods_id,model.modify_Product_id,[NSNumber numberWithInteger:model.selectCount],@1];
    
    [FMHTTPClient getPath:addToShoppingListUrl parameters:nil completion:^(WebAPIResponse *response) {
        if (response.code == WebAPIResponseCodeSuccess) {
            [self deleteShoppingListWithPostNetworkWithModel:model];
            
            
            
            
        }
    }];
}

- (void)shoppingListChangeNumberWithModel:(FMShoppingListModel *)model {
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString *changeNumberUrl = [NSString stringWithFormat:@"%@?from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%@&user_id=%@",KFMShoppingListUpdateNumberUrl,[CurrentUserInformation sharedCurrentUserInfo].mobile,tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId];
    
    NSString *goods_ident = [NSString stringWithFormat:@"goods_%ld_%ld",(long)[model.goods_id integerValue],(long)[model.product_id integerValue]];
    
    NSString *modify = [NSString stringWithFormat:@"modify_quantity[goods_%ld_%ld][quantity]",(long)[model.goods_id integerValue],(long)[model.product_id integerValue]];
    
        NSDictionary * parameter = @{
                                     @"min"             :@(1),
                                     @"max"             :@(100),
                                     @"stock"           :@(10),
                                     @"obj_type"        :@"goods",
                                     @"goods_ident"     :goods_ident,
                                     @"goods_id"        :model.goods_id,
                                     modify             :[NSString stringWithFormat:@"%ld", (long)model.selectCount],
                                     @"response_type"   :@"true",
                                     
                                     };
    
    [FMHTTPClient postPath:changeNumberUrl parameters:parameter completion:^(WebAPIResponse *response) {
        NSString * status = [NSString stringWithFormat:@"%@",response.responseObject[@"status"]];
        if ([status integerValue] == 0) {
        }
    }];
}

- (void)clickSelectButton:(NSIndexPath *)index sender:(UIButton *)sender{
    
    FMShoppingListModel *model = self.dataSource[index.row];
    NSString *price = model.price.buy_price;
    model.selectState = sender.selected;

    if (model.selectState) {
        self.totalPrice = self.totalPrice +[price floatValue]*model.selectCount;
        self.totalNumber ++;
        
        [self.shareImageData addObject:[NSNumber numberWithInteger:index.row]];

    }else {
        self.totalPrice = self.totalPrice - [price floatValue]*model.selectCount;
        self.allSelectButton.selected = NO;
        self.totalNumber --;
        [self.shareImageData removeObject:[NSNumber numberWithInteger:index.row]];

    }
    if (self.totalNumber == self.dataSource.count) {
        self.allSelectButton.selected = YES;
    }
    [self.bottomView sendeDataWith:[NSString stringWithFormat:@"%.2f",self.totalPrice ] withNumber:self.totalNumber];
    
//    if (self.totalPrice<520 && self.totalPrice != 0 && self.totalNumber !=0) {
//        
//        self.rowCount = self.dataSource.count +1;
//    }else {
//        self.rowCount = self.dataSource.count;
//    }
    
    [self.tableView reloadData];
}

- (void)clickDeleteButton:(UIButton *)sender withIndexPath:(NSIndexPath *)indexPath{
    
    FMShoppingListModel *model = self.dataSource[indexPath.row];
    if (model.selectState) {
        self.totalNumber--;
    }
    
    SignOnDeleteView *deleteView = [[SignOnDeleteView alloc]init];
    [deleteView showSignViewWithTitle:@"确认删除商品么？" detail:@"删除商品后就无法恢复商品了"];
    __weak typeof (self)weakSelf = self;
    deleteView.sureBlock = ^(UIButton *sender){

        [weakSelf deleteShoppingListWithPostNetworkWithModel:model index:indexPath];
        [weakSelf deleteProductPerCellWith:indexPath];
    };
}

- (void)deleteShoppingListWithPostNetworkWithModel:(FMShoppingListModel *)model index:(NSIndexPath *)indexPath{
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSString *deleteUrl = [NSString stringWithFormat:@"%@?from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%@&user_id=%@",KFMShoppingListDeleteUrl,[CurrentUserInformation sharedCurrentUserInfo].mobile,tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId];
    
    NSString *goods_ident = [NSString stringWithFormat:@"goods_%@_%@",model.goods_id,model.product_id];
    
    NSString *modify = [NSString stringWithFormat:@"modify_quantity[goods_%@_%@][quantity]",model.goods_id,model.product_id];
    
    NSDictionary * parameter = @{
                                 @"min"             :@(1),
                                 @"max"             :@(100),
                                 @"stock"           :@(10),
                                 @"obj_type"        :@"goods",
                                 @"goods_ident"     :goods_ident,
                                 @"goods_id"        :model.goods_id,
                                 modify             :[NSString stringWithFormat:@"%ld", (long)model.selectCount],
                                 @"response_type"   :@"true"
                                 };
    
    [FMHTTPClient postPath:deleteUrl parameters:parameter completion:^(WebAPIResponse *response) {

    }];
}

- (void)deleteProductPerCellWith:(NSIndexPath *)indexPath {
    
    self.rowCount--;
    [self.dataSource removeObjectAtIndex:indexPath.row];
    
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]  withRowAnimation:(UITableViewRowAnimationFade)];
    
    [self.tableView reloadData];
    [self caculateTotalPrice];
    
    if (self.dataSource.count == 0&&self.pastDataSource.count ==0) {
        self.emptyView.hidden = NO;
        self.sectionCount = 0;
        [self.tableView reloadData];
    }
    if (self.totalNumber == 0) {
        self.allSelectButton.selected = NO;
    }
    
    [self settingNavTitle:[NSString stringWithFormat:@"购物车(%lu)",(unsigned long)self.dataSource.count]];

}

- (void)clickPlusButton:(UIButton *)sender withIndexPath:(NSIndexPath *)indexPath{

    FMShoppingListModel *model = self.dataSource[indexPath.row];
    model.selectCount ++;
    self.totalPrice = self.totalPrice +[model.price.buy_price floatValue] *model.selectCount;
    [self caculateTotalPrice];
}

- (void)clickMinusButton:(UIButton *)sender withIndexPath:(NSIndexPath *)indexPath{
    
    FMShoppingListModel *model = self.dataSource[indexPath.row];
    if (model.selectCount > 1){
        model.selectCount --;
        self.totalPrice = self.totalPrice - [model.price.buy_price floatValue] *model.selectCount;
    }else{
        ShowAutoHideMBProgressHUD(self.view, @"不能再减少宝贝咯");
    }
    [self caculateTotalPrice];
}

#pragma -mark 选择商品属性界面的回调
-(void)jumpConfirmShopController:(FMSelectShopInfoModel * )selectModel;
{
    FMShoppingListModel *model = self.dataSource[selectModel.shopListIndexPath.row];
    
    model.currentStyle = selectModel.currentStyle;
    
    model.modify_Product_id = selectModel.product_id;
    model.modify_Goods_id = selectModel.gid;
    FMShoppingListCell *cell = [self.tableView cellForRowAtIndexPath:selectModel.shopListIndexPath];
    [cell sendDataToCellWithModel:model];
    
    FMShoppingListModel *newModel = [FMShoppingListModel mj_objectWithKeyValues:model.mj_keyValues];
    
    newModel.product_id = model.modify_Product_id;
    newModel.goods_id = model.modify_Goods_id;
    
    NSMutableArray *arrr = [NSMutableArray array];
    for (FMShopCollectionInfoModel *model in selectModel.locationArray) {
        FMStyleModel *m = [[FMStyleModel alloc]init];
        m.k = model.spec_name;
        m.v = model.contentString;
        [arrr addObject:m];
    }
    newModel.spec = [NSMutableArray arrayWithArray:arrr];
    
    if (![model.product_id isEqualToString:model.modify_Product_id]) {
        [self shoppingListChangeNumberWithModel:model];
        [self addToShoppingListAfterDeleteWith:model];
        [self.dataSource replaceObjectAtIndex:selectModel.shopListIndexPath.row withObject:newModel];
        
        
       
    }

    
}

- (void)clickTypeButton:(UIButton *)sender withIndexPath:(NSIndexPath *)indexPath {
    
    //创建底部button
    FMShoppingListModel *model = self.dataSource[indexPath.row];
    //选择颜色、尺码、数量
    FMButtonStyleModel * buttonOne = [[FMButtonStyleModel alloc]init];
    buttonOne.title = @"确认";
    buttonOne.textFont = 15;
    buttonOne.titleColor = [UIColor whiteColor];
    buttonOne.backGroundColor = [HXColor colorWithHexString:@"#0159d5"];
    
    //构建Model

    
    FMSelectShopInfoModel *fmmodel = [[FMSelectShopInfoModel alloc]init];
    
    fmmodel.product_id = model.product_id;
    fmmodel.image = model.image;
    fmmodel.price = model.price.buy_price;
    fmmodel.currentStyle = model.currentStyle;
    fmmodel.isAllShopInfo = YES;
    fmmodel.shopListIndexPath = indexPath;
    
#pragma -mark 选择商品属性改动！！！
    
    FMGoodsShopSelectShopView * shopView = [[FMGoodsShopSelectShopView alloc]init];
    [shopView createPresentModel:fmmodel];
    shopView.isShowCount = NO;
    shopView.buttonArray = @[buttonOne];
    
    __weak __typeof(&*self)weakSelf = self;
    shopView.successBlock = ^(FMSelectShopInfoModel * selectModel,NSInteger buttonTag){
        [weakSelf jumpConfirmShopController:selectModel];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        if (self.dataSource.count == 0) {
            return 0;
        }else{
            if (indexPath.row == self.dataSource.count) {
                return 30;
            }
            FMShoppingListModel *model = self.dataSource[indexPath.row];
            float favorPrice = [model.price.price floatValue]-[model.price.buy_price floatValue];
            if (favorPrice >0) {
                return 115;
            }else{
                return 105;
            }
        }
    }
    return 105;
}

#pragma  mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)bottomViewForShoppingList {
    
    UIView *whiteView = [[UIView alloc]init];
    [self.view addSubview:whiteView];
    [whiteView makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    UIView *topLine = [[UIView alloc]init];
    topLine.backgroundColor = KDefaultOrBackgroundColor;
    [whiteView addSubview:topLine];
    [topLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteView.left);
        make.right.equalTo(whiteView.right);
        make.top.equalTo(whiteView.top);
        make.height.equalTo(@1);
    }];
    
    [self.view addSubview:self.allSelectButton];
    [self.allSelectButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-15);
        make.width.equalTo(@35);
        make.height.equalTo(@35);
        make.centerY.equalTo(whiteView.mas_centerY);
    }];

    [self.view addSubview:self.allSelectLabel];
    [self.allSelectLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.allSelectButton.mas_right);
        make.centerY.equalTo(self.allSelectButton.mas_centerY);
        
    }];
    
    self.bottomView = [[FMShoppingListBottomView alloc]init];

    [self.view addSubview:self.bottomView];
    [self.bottomView sendeDataWith:[NSString stringWithFormat:@"%.2f",self.totalPrice] withNumber:0];
    [self.bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.view);
        make.height.equalTo(@50);
        make.left.equalTo(self.view.mas_left).offset(KProjectScreenWidth/4);
    }];
   
    __weak typeof (self)weakSelf = self;
    self.bottomView.block = ^(UIButton * sender) {
     [weakSelf clickbottomViewButtonWithSender:sender];
    };
    
    [self.view addSubview:self.editBottomView];
    self.editBottomView.deleteBlock = ^(UIButton *sender){
        [weakSelf clickBottomDeleteButton:sender];
    };
    self.editBottomView.shareBlcok = ^(UIButton *sender){
        [weakSelf clickBottomShareButton:sender];

    };
    self.editBottomView.removeBlock = ^(UIButton *sender){
        [weakSelf clickBottomRemoveButton:sender];

    };
    [self.editBottomView makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.view);
        make.height.equalTo(@50);
        make.left.equalTo(self.view.mas_left).offset(KProjectScreenWidth/4);

    }];
    self.editBottomView.hidden = YES;
}

- (void)clickBottomDeleteButton:(UIButton *)sender {

    if (self.totalNumber == 0) {
        ShowAutoHideMBProgressHUD(self.view, @"您还没有选择要删除的商品");
    }else{
        
        SignOnDeleteView *deleteView = [[SignOnDeleteView alloc]init];
        [deleteView showSignViewWithTitle:@"确认删除商品么？" detail:@"删除商品后就无法恢复商品了"];
        __weak typeof (self)weakSelf = self;
        deleteView.sureBlock = ^(UIButton *sender){
            [weakSelf deleteBottomViewDidClick:sender];
        };
    }
}

- (void)deleteBottomViewDidClick:(UIButton *)sender{
    
    NSMutableArray *arrPath = [NSMutableArray array];
    NSMutableArray *arrData = [NSMutableArray array];
    for (NSNumber *number in self.shareImageData) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[number integerValue] inSection:0];
        [arrPath addObject:indexPath];
        [arrData addObject:self.dataSource[indexPath.row]];
        
        FMShoppingListModel *model = self.dataSource[indexPath.row];
        
        [self deleteShoppingListWithPostNetworkWithModel:model index:indexPath];

    }
    self.rowCount = self.rowCount - self.shareImageData.count;

    [self.shareImageData removeAllObjects];
    self.totalNumber = 0;
    self.allSelectButton.selected = NO;
    [self.dataSource removeObjectsInArray:arrData];
    [self.tableView deleteRowsAtIndexPaths:arrPath  withRowAnimation:(UITableViewRowAnimationFade)];
    
    [self.tableView reloadData];
    [self caculateTotalPrice];
    if (self.dataSource.count == 0 &&self.pastDataSource.count==0) {
        self.emptyView.hidden = NO;
        self.sectionCount = 0;
        [self.tableView reloadData];
    }
    
    [self settingNavTitle:[NSString stringWithFormat:@"购物车(%lu)",(unsigned long)self.dataSource.count]];

}

- (UIView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight)];
        
        UILabel * detalLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, KProjectScreenWidth, 50)];
        detalLabel.textAlignment = NSTextAlignmentCenter;
        detalLabel.textColor = kColorTextColorClay;
        detalLabel.text = @"购物车暂无商品";
        [_emptyView addSubview:detalLabel];
        [self.tableView addSubview:_emptyView];
    }
    return _emptyView;
}

- (void)clickBottomShareButton:(UIButton *)sender {
    
    if (self.totalNumber == 0) {
        ShowAutoHideMBProgressHUD(self.view, @"您还没有选择宝贝哦");
    }else{
        
        NSMutableString *string = [NSMutableString string];
        for (int index =0; index < self.shareImageData.count; index++) {
            NSInteger jnde= [self.shareImageData[index] integerValue];
            FMShoppingListModel *model = self.dataSource[jnde];
            
            [string appendString:[NSString stringWithFormat:@"%@,",model.product_id]];
        }
        NSString *prodidURL = [string substringWithRange:NSMakeRange(0, string.length - 1)];
        //https://www.rongtuojinrong.com/qdy/wap/product/share/14106.html
        NSString *shareURL = [NSString stringWithFormat:@"http://www.qdygo.com/wap/product/share/%@.html",prodidURL];
        
        self.shareView = [[FMShoppingListShareView alloc]init];
        [self.view addSubview:self.shareView];
        __weak typeof (self)weakSelf = self;
        
        NSInteger jnde= [self.shareImageData[0] integerValue];
        FMShoppingListModel *model = self.dataSource[jnde];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.image]];
        
        self.shareView.block = ^(UIButton *sender){
            [weakSelf clickShareButton:sender with:shareURL withTitle:model.name withData:data];
        };
        
        [self.shareView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

- (void)clickShareButton:(UIButton *)sender with:(NSString *)shareURL withTitle:(NSString *)title withData:(NSData *)data{
    
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@?plattype=%@",shareURL,@"weixin"];
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@?plattype=%@",shareURL,@"wxcircle"];
    [UMSocialData defaultData].extConfig.qqData.url = [NSString stringWithFormat:@"%@?plattype=%@",shareURL,@"qq"];
    [UMSocialData defaultData].extConfig.sinaData.urlResource.url = [NSString stringWithFormat:@"%@?plattype=%@",shareURL,@"sina"];
    
    [UMSocialConfig setFinishToastIsHidden:YES  position:UMSocialiToastPositionCenter];
    
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
            self.shareView.hidden = YES;
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
            [UMSocialData defaultData].title = @"融托金融～优商城";
            [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"%@%@",title,shareURL] shareImage:data socialUIDelegate:self];        //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            
            break;
        }
        case 2114:
        {
            //QQ

            [UMSocialData defaultData].extConfig.qqData.title = @"融托金融～优商城";
            [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"%@%@",title,shareURL] shareImage:data socialUIDelegate:self];        //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);

            break;
        }
        case 2115:
        {
            //(@"微信");
            [UMSocialData defaultData].extConfig.wechatSessionData.title = @"融托金融～优商城";
             [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"%@%@",title,shareURL] shareImage:data socialUIDelegate:self];        //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);

            break;
        }
        case 2116:
        {
            //(@"朋友圈");
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"融托金融～优商城";
            [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"%@%@",title,shareURL] shareImage:data socialUIDelegate:self];        //设置分享内容和回调对象

            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);

            break;
        }
        default:
            break;
    }
}

- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
       ShowAutoHideMBProgressHUD(self.view,@"分享成功");
        
    }else{
        ShowAutoHideMBProgressHUD(self.view,@"分享失败");
    }
    
}

- (void)clickShareQRImageWith:(NSString *)shareURL{
    
    self.shareView.hidden = YES;
    
    NSMutableArray *array = [NSMutableArray array];
    for (int index =0; index < self.shareImageData.count; index++) {
        NSInteger jnde= [self.shareImageData[index] integerValue];
        FMShoppingListModel *model = self.dataSource[jnde];
        [array addObject:model.image];
    }
    
    UIImage *QRImage = [Fm_Tools QRcodeWithUrlString:shareURL];
    UIImage *plaxImage = [Fm_Tools addIconToQRCodeImage:QRImage withIcon:[UIImage imageNamed:@"二维码小图片"] withScale:6];
    
    FMShoppingListScanView *scanView = [[FMShoppingListScanView alloc]initWithData:[NSMutableArray arrayWithArray:array]count:self.totalNumber withQRImage:plaxImage];
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

- (void)clickBottomRemoveButton:(UIButton *)sender {
    
    if (self.totalNumber==0) {
        ShowAutoHideMBProgressHUD(self.view, @"请选择要收藏的宝贝");
    }else{
        for (int index =0; index < self.shareImageData.count; index++) {
            NSInteger jnde= [self.shareImageData[index] integerValue];
            FMShoppingListModel *model = self.dataSource[jnde];
            
            int timestamp = [[NSDate date] timeIntervalSince1970];
            NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
            NSString *tokenlow=[token lowercaseString];
            
            NSString *nav = [NSString stringWithFormat:@"%@?gid=%@&from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%@&user_id=%@",KGoodShop_ShopDetail_AddFavirist_Url,model.goods_id,[CurrentUserInformation sharedCurrentUserInfo].mobile,tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId];
            
            [FMHTTPClient postPath:nav parameters:nil completion:^(WebAPIResponse *response) {
                
                NSString * status = [NSString stringWithFormat:@"%@",response.responseObject[@"status"]];
                if ([status integerValue] == 0) {
                    ShowFMSoppingMBProgressHUD(self.view, @"成功加入收藏夹,可以在我的收藏里查看");
                }else{
                    ShowAutoHideMBProgressHUD(self.view, @"未能加入收藏夹");
                }
            }];
        }
    }
}

- (void)caculateTotalPrice {

    self.totalPrice = 0.0;
    [self.shareImageData removeAllObjects];
    for (int i = 0; i < self.dataSource.count; i++) {
        
        FMShoppingListModel *model = [self.dataSource objectAtIndex:i];
        
        if (model.selectState){
            self.totalPrice = self.totalPrice + model.selectCount *[model.price.buy_price floatValue];
            [self.shareImageData addObject:[NSNumber numberWithInteger:i]];
        }
    }
    [self.bottomView sendeDataWith:[NSString stringWithFormat:@"%.2f",self.totalPrice] withNumber:self.totalNumber];
}

- (void)setNavItemsWithButton {
    
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageButton setImage:[UIImage imageNamed:@"优商城_已读消息_36"] forState:UIControlStateNormal];
//    [messageButton setImage:[UIImage imageNamed:@"优商城首页-消息图标1-48x44"] forState:UIControlStateSelected];
    [messageButton addTarget:self action:@selector(rightAction:) forControlEvents: UIControlEventTouchUpInside];
    
    messageButton.frame =CGRectMake(KProjectScreenWidth - 50, 10, 30, 30);
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton setTitle:@"完成" forState:UIControlStateSelected];
    editButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [editButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateNormal)];
    [editButton addTarget:self action:@selector(editButtonAction:) forControlEvents: UIControlEventTouchUpInside];
    editButton.frame =CGRectMake(KProjectScreenWidth - 100, 10, 50, 30);
    
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc]initWithCustomView:editButton];
    UIBarButtonItem *navItem = [[UIBarButtonItem alloc]initWithCustomView:messageButton];
     
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:navItem,titleItem,nil] animated:YES];
}

- (NSMutableArray *)shareImageData {
    if (!_shareImageData) {
        _shareImageData = [NSMutableArray array];
    }
    return _shareImageData;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)pastDataSource {
    if (!_pastDataSource) {
        _pastDataSource = [NSMutableArray array];
    }
    return _pastDataSource;
}

- (FMShoppigListBottomEditView *)editBottomView {
    if (!_editBottomView) {
        _editBottomView = [[FMShoppigListBottomEditView alloc]init];
    }
    return _editBottomView;
}

- (UILabel *)allSelectLabel {
    if (!_allSelectLabel) {
        _allSelectLabel = [[UILabel alloc]init];
        _allSelectLabel.text = @"全选";
        _allSelectLabel.font = [UIFont systemFontOfSize:14];
        _allSelectLabel.textColor = kColorTextColorClay;
    }
    return _allSelectLabel;
}

- (UIButton *)allSelectButton {
    if (!_allSelectButton) {
        _allSelectButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_allSelectButton setImage:[UIImage imageNamed:@"t2-0"] forState:(UIControlStateNormal)];
        [_allSelectButton setImage:[UIImage imageNamed:@"t2"] forState:(UIControlStateSelected)];
        [_allSelectButton addTarget:self action:@selector(allSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allSelectButton;
}

- (void)allSelectAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.totalNumber = self.dataSource.count;
    }else {
        self.totalNumber = 0;
    }
    for (FMShoppingListModel *model in self.dataSource) {
        model.selectState = sender.selected;
    }
    
    [self caculateTotalPrice];
//    if (self.totalPrice<520 && self.totalPrice != 0 && self.totalNumber !=0) {
//        self.rowCount = self.dataSource.count +1;
//    }else {
//        self.rowCount = self.dataSource.count;
//    }
    [self.tableView reloadData];
}

- (void)clickbottomViewButtonWithSender:(UIButton *)sender {
    
    if (self.totalNumber == 0) {
        ShowAutoHideMBProgressHUD(self.view, @"您还没有选择要结算的商品");
    }else{
        
        NSMutableArray *modelArr = [NSMutableArray array];
        for (NSNumber *number in self.shareImageData) {
            NSInteger index = [number integerValue];
            FMShoppingListModel *model = self.dataSource[index];
            [modelArr addObject:model];
        }
        
//        XZConfirmOrderViewController *confirmOrder = [[XZConfirmOrderViewController alloc]init];
//        confirmOrder.shopDataSource = [NSMutableArray arrayWithArray:modelArr];
//        confirmOrder.sess_id = self.sess_id;
//        [self.navigationController pushViewController:confirmOrder animated:YES];
        FMShoppingListModel *shopListModel = [self.dataSource firstObject];
//        NSLog(@"购物车======商品goods_id:%@-----商品的product_id%@-----md5_cart_info:%@",shopListModel.goods_id,shopListModel.product_id,shopListModel.md5_cart_info);
        
        XZOptimalMallSubmitOrderController *submitOrder = [[XZOptimalMallSubmitOrderController alloc]init];
        submitOrder.sess_id = self.sess_id;
        submitOrder.shopDataSource = [NSMutableArray arrayWithArray:modelArr];
        submitOrder.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:submitOrder animated:YES];
    }
}

@end
