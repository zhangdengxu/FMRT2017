//
//  FMMyCommentAllController.m
//  fmapp
//
//  Created by runzhiqiu on 16/5/3.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMMyCommentAllController.h"
#import "FMCommentAllHeaderView.h"
#import "LWImageBrowser.h"
#import "WLCommentInMyOrderCell.h"
#import "LWDefine.h"
#import "LWAlchemy.h"
#import "FMShopCommentModel.h"
#import "FMCommentLayoutInMyOrder.h"

// 是否追加评价的界面
#import "XZChooseCommentAgainView.h"
#import "XZCommentAgainViewController.h"
#import "FMGoodShopURLManage.h"

#import "XZMyOrderGoodsModel.h"
#import "FMWaitDetailViewCell.h"
#import "XZPublishCommentViewController.h"
@interface FMMyCommentAllController ()<UITableViewDataSource,UITableViewDelegate,WLCommentInMyOrderCellDelegate,FMCommentAllHeaderViewDelegate>

@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) NSMutableArray* dataSource;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL isAddData;


@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSURLSessionDataTask * dataTask;

@property (nonatomic, assign) BOOL isRemoveAllData;
@end

@implementation FMMyCommentAllController

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor colorWithRed:(230.0/255) green:(234.0/255) blue:(241.0/255) alpha:1];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.decelerationRate = 5.0f;
        
        FMCommentAllHeaderView * headerView = [[FMCommentAllHeaderView alloc]init];
        headerView.delegate = self;
        _tableView.tableHeaderView = headerView;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _currentPage = 1;
            _isAddData = NO;
            [self getDataSourceFromNetWork];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            _isAddData = YES;
            [self getDataSourceFromNetWork];
        }];
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentIndex = 3;
    self.currentPage = 1;
    self.isRemoveAllData = NO;
    [self settingNavTitle:@"我的评价"];
    self.view.backgroundColor = [UIColor colorWithRed:(230.0/255) green:(234.0/255) blue:(241.0/255) alpha:1];
    
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isRemoveAllData = NO;
    self.currentPage = 1;
    [self getCommentCountNumber];
    [self getDataSourceFromNetWork];
}
-(void)FMCommentAllHeaderView:(FMCommentAllHeaderView *)headerView didOnClickItem:(NSInteger)index;
{
    if (self.currentIndex == index) {
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.isRemoveAllData = YES;
    self.currentIndex = index;
    _isAddData = NO;
    self.currentPage = 1;
    [self getDataSourceFromNetWork];
}

- (void)getDataSourceFromNetWork {
    
    
    
    if (self.currentIndex == 3) {
        [self getALLCommentFromNetWork];
    }else if(self.currentIndex == 4)
    {
        [self getPicCommentFromNetWork];
    }else if (self.currentIndex == 5)
    {
        [self getWaitCommentFromNetWork];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.dataTask cancel];
    self.isRemoveAllData = NO;
    self.dataTask = nil;
}

-(void)getCommentCountNumber
{
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString * testUrl = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/member-commentNum.html?from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%@&user_id=%@",[CurrentUserInformation sharedCurrentUserInfo].mobile,tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId];
    [FMHTTPClient postPath:testUrl parameters:nil completion:^(WebAPIResponse *response) {
        if (response.code == WebAPIResponseCodeSuccess) {
            
            NSDictionary   * dictData = response.responseObject[@"data"];
            if (![dictData isMemberOfClass:[NSNull class]]) {
                NSString * n1;
                NSString * n2;
                NSString * n3;
                
                if (dictData[@"all"]) {
                    if (![dictData[@"all"] isMemberOfClass:[NSNull class]]) {
                        n1 = [NSString stringWithFormat:@"%@",dictData[@"all"]];
                    }else
                    {
                        n1 = @"0";
                    }
                }
                
                if (dictData[@"pic"]) {
                    if (![dictData[@"pic"] isMemberOfClass:[NSNull class]]) {
                        n2 = [NSString stringWithFormat:@"%@",dictData[@"pic"]];
                    }else
                    {
                        n2 = @"0";
                    }
                }
                
                if (dictData[@"uncomment"]) {
                    if (![dictData[@"uncomment"] isMemberOfClass:[NSNull class]]) {
                        n3 = [NSString stringWithFormat:@"%@",dictData[@"uncomment"]];
                    }else
                    {
                        n3 = @"0";
                    }
                }
                NSArray * array;
                
                if (n1&&n2&&n3) {
                    array = @[n1,n2,n3];
                }else
                {
                    array = @[@"0",@"0",@"0"];
                }
                
                FMCommentAllHeaderView * headerView = (FMCommentAllHeaderView *)self.tableView.tableHeaderView;
                headerView.commentArray = array;
                
            }
            
        }
    }];
    
    
    
}

//获取所有图片
-(void)getALLCommentFromNetWork
{
    
    if (self.dataTask) {
        [self.dataTask cancel];
        self.dataTask = nil;
    }
    
    NSString * baseUrl = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/member-comment-%zi.html",self.currentPage];
    NSString * htmlUrl = [FMGoodShopURLManage getNewNetWorkURLWithBaseURL:baseUrl];
    
    //NSString * testUrl = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/member-comment-1.html?from=rongtuoapp&tel=15966065659&appid=huiyuan&token=f9f828db40436e108678cc37bedd5c79&shijian=1456199802&user_id=191",self.currentPage];
    __weak __typeof(&*self)weakSelf = self;
    self.dataTask = [FMHTTPClient postReturnPath:htmlUrl parameters:nil completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (response.code == WebAPIResponseCodeSuccess) {
            if (self.isRemoveAllData) {
                self.isRemoveAllData = NO;
                [self.dataSource removeAllObjects];
            }
            
            NSArray * dataArray = response.responseObject[@"data"];
            
            if (_isAddData) {
                _isAddData = NO;
            }else
            {
                [self.dataSource removeAllObjects];
            }
            NSMutableArray * dataMuArray = [NSMutableArray array];
            
            if (dataArray != nil) {
                for (NSDictionary * dict in dataArray) {
                    
                    
                    
                    FMShopCommentModel * model = [FMShopCommentModel createFMShopCommentModelWithDictionary:dict];
                    
                    
                    [dataMuArray addObject:model];
                }
                
                //FMShopCommentModel * model = [dataMuArray lastObject];
                //model.secondContent = nil;
                //model.secondImgs = nil;
                //model.shopCommentSecond = nil;
                
            }
            if (dataMuArray.count > 0) {
                _currentPage = _currentPage + 1;
                [self changeModelToDataSource:dataMuArray];
            }
            
            
        }else if (response.code == WebAPIResponseCodeFailed)
        {
            ShowAutoHideMBProgressHUD(weakSelf.view,@"获取失败");
        }else
        {
            ShowAutoHideMBProgressHUD(weakSelf.view,@"获取失败");
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
}
-(void)getPicCommentFromNetWork
{
    if (self.dataTask) {
        [self.dataTask cancel];
        self.dataTask = nil;
    }
    
    NSString * baseUrl = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/member-comment-%zi.html",self.currentPage];
    NSString * htmlUrl = [FMGoodShopURLManage getNewNetWorkURLWithBaseURL:baseUrl];
    NSString * endUrl = [NSString stringWithFormat:@"%@&pic=1",htmlUrl];
    
    //NSString * testUrl = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/member-comment-%zi.html?from=rongtuoapp&tel=15966065659&appid=huiyuan&token=f9f828db40436e108678cc37bedd5c79&shijian=1456199802&user_id=191&pic=1",self.currentPage];
    __weak __typeof(&*self)weakSelf = self;
    self.dataTask = [FMHTTPClient postReturnPath:endUrl parameters:nil completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (response.code == WebAPIResponseCodeSuccess) {
            if (self.isRemoveAllData) {
                self.isRemoveAllData = NO;
                [self.dataSource removeAllObjects];
            }
            NSArray * dataArray = response.responseObject[@"data"];
            
            if (_isAddData) {
                _isAddData = NO;
            }else
            {
                [self.dataSource removeAllObjects];
            }
            NSMutableArray * dataMuArray = [NSMutableArray array];
            
            if (dataArray != nil) {
                for (NSDictionary * dict in dataArray) {
                    
                    FMShopCommentModel * model = [FMShopCommentModel createFMShopCommentModelWithDictionary:dict];
                    
                    [dataMuArray addObject:model];
                }
                
                //FMShopCommentModel * model = [dataMuArray lastObject];
                //model.secondContent = nil;
                //model.secondImgs = nil;
                //model.shopCommentSecond = nil;
                
            }
            if (dataMuArray.count > 0) {
                _currentPage = _currentPage + 1;
                [self changeModelToDataSource:dataMuArray];
            }
            
            
        }else if (response.code == WebAPIResponseCodeFailed)
        {
            ShowAutoHideMBProgressHUD(weakSelf.view,@"获取失败");
        }else
        {
            ShowAutoHideMBProgressHUD(weakSelf.view,@"获取失败");
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
}
-(void)getWaitCommentFromNetWork
{
    
    if (self.dataTask) {
        [self.dataTask cancel];
        self.dataTask = nil;
    }
    
    NSString * baseUrl = @"https://www.rongtuojinrong.com/qdy/wap/member-nodiscuss_productlist_client.html";
    NSString * htmlUrl = [FMGoodShopURLManage getNewNetWorkURLWithBaseURL:baseUrl];
    NSString * endUrl = [NSString stringWithFormat:@"%@&npage=%zi",htmlUrl,self.currentPage];
    
    
    //NSString * testUrl = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/member-nodiscuss_productlist_client.html?npage=%zi&from=rongtuoapp&tel=15966065659&appid=huiyuan&token=f9f828db40436e108678cc37bedd5c79&shijian=1456199802&user_id=191",self.currentPage];
    __weak __typeof(&*self)weakSelf = self;
    self.dataTask = [FMHTTPClient postReturnPath:endUrl parameters:nil completion:^(WebAPIResponse *response) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (response.code == WebAPIResponseCodeSuccess) {
            if (self.isRemoveAllData) {
                self.isRemoveAllData = NO;
                [self.dataSource removeAllObjects];
            }
            NSArray * dataArray = response.responseObject[@"data"];
            
            if (_isAddData) {
                _isAddData = NO;
            }else
            {
                [self.dataSource removeAllObjects];
            }
            
            if (dataArray != nil) {
                for (NSDictionary * dict in dataArray) {
                    XZMyOrderGoodsModel * model = [[XZMyOrderGoodsModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    
                    [self.dataSource addObject:model];
                }
                _currentPage = _currentPage + 1;
                [self.tableView reloadData];
            }
            
        }else if (response.code == WebAPIResponseCodeFailed)
        {
            ShowAutoHideMBProgressHUD(weakSelf.view,@"获取失败");
        }else
        {
            ShowAutoHideMBProgressHUD(weakSelf.view,@"获取失败");
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
}


-(void)changeModelToDataSource:(NSArray *)modelArray
{
    for (NSInteger i = 0; i < modelArray.count; i ++) {
        FMShopCommentModel* statusModel = modelArray[i];
        LWLayout* layout = [self layoutWithStatusModel:statusModel index:i];
        [self.dataSource addObject:layout];
    }
    [self.tableView reloadData];
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row >= self.dataSource.count) {
        return nil;
    }
    
    NSObject * object = self.dataSource[indexPath.row];
    if ([object isMemberOfClass:[XZMyOrderGoodsModel class]]) {
        
        static NSString * tableViewCellDetailRegister = @"FMWaitDetailViewCell";
        
        FMWaitDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellDetailRegister];
        if (!cell) {
            cell = [[FMWaitDetailViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellDetailRegister];
        }
        
        cell.afterSalesBtnTitle = @"评价商品";
        __weak __typeof(&*self)weakSelf = self;
        cell.blockAfterSalesBtn = ^(UIButton * button)
        {
            //收货评价
            [weakSelf goodsCommentWith:weakSelf.dataSource[indexPath.row]];
            
        };
        if ([self.dataSource count]> 0) { // 如果数据不为空的话赋值
            XZMyOrderGoodsModel *goodsModel =  self.dataSource[indexPath.row];
            cell.goodsModel = goodsModel;
        }
        
        return cell;
        
        
    }else
    {
        
        static NSString* cellIdentifier = @"cellIdentifier";
        WLCommentInMyOrderCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[WLCommentInMyOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.indexPath = indexPath;
        cell.blockCommentBtn = ^() {
            FMCommentLayoutInMyOrder * cellLayout = self.dataSource[indexPath.row];
            XZChooseCommentAgainView *commentAgain = [[XZChooseCommentAgainView alloc]initWithFrame:[UIScreen mainScreen].bounds];
            [self.view addSubview:commentAgain];
            // 点击追加评价
            __weak typeof(self)weakSelf = self;
            commentAgain.blockCommentAgainBtn = ^(UIButton *button){
                XZCommentAgainViewController *commentAgain = [[XZCommentAgainViewController alloc]init];
                commentAgain.statusModel = cellLayout.statusModel;
                [weakSelf.navigationController pushViewController:commentAgain animated:YES];
            };
        };
        if (self.dataSource.count >= indexPath.row) {
            FMCommentLayoutInMyOrder* cellLayout = self.dataSource[indexPath.row];
            cell.cellLayout = cellLayout;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject * object = self.dataSource[indexPath.row];
    if ([object isMemberOfClass:[XZMyOrderGoodsModel class]]) {
        
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
        CGFloat width = KProjectScreenWidth - (KProjectScreenWidth * 0.2 + 20 + 10);
        XZMyOrderGoodsModel * good = self.dataSource[indexPath.row];
        CGSize size = [good.name getStringCGSizeWithMaxSize:CGSizeMake(width, MAXFLOAT) WithFont:[UIFont systemFontOfSize:font]];
        CGFloat heigh = size.height + 30 * radio + 20 + 15 + 5;
        CGFloat heigh2 = KProjectScreenWidth * 0.27;
        return  heigh2 > heigh ? heigh2 : heigh;
        
    }else
    {
        if (self.dataSource.count >= indexPath.row) {
            FMCommentLayoutInMyOrder* layout = self.dataSource[indexPath.row];
            return layout.cellHeight;
        }
        return 0;
    }
    
}


/****************************************************************************/
/**
 *  在这里生成LWAsyncDisplayView的模型。
 */
/****************************************************************************/

- (FMCommentLayoutInMyOrder *)layoutWithStatusModel:(FMShopCommentModel *)statusModel index:(NSInteger)index {
    //生成Storage容器
    LWStorageContainer* container = [[LWStorageContainer alloc] init];
    //生成Layout
    FMCommentLayoutInMyOrder* layout = [[FMCommentLayoutInMyOrder alloc] initWithContainer:container
                                                                               statusModel:statusModel
                                                                                     index:index];
    return layout;
}

//点击图片
- (void)tableViewCell:(WLCommentInMyOrderCell *)cell didClickedImageWithCellLayout:(FMCommentLayoutInMyOrder *)layout
              atIndex:(NSInteger)index;
{
    NSMutableArray* tmp = [[NSMutableArray alloc] initWithCapacity:layout.imagePostionArray.count];
    for (NSInteger i = 0; i < layout.imagePostionArray.count; i ++) {
        LWImageBrowserModel* imageModel = [[LWImageBrowserModel alloc] initWithplaceholder:nil
                                                                              thumbnailURL:[NSURL URLWithString:[layout.statusModel.imgs objectAtIndex:i]]
                                                                                     HDURL:[NSURL URLWithString:[layout.statusModel.imgs objectAtIndex:i]]
                                                                        imageViewSuperView:cell.contentView
                                                                       positionAtSuperView:CGRectFromString(layout.imagePostionArray[i])
                                                                                     index:index];
        [tmp addObject:imageModel];
    }
    LWImageBrowser* imageBrowser = [[LWImageBrowser alloc] initWithParentViewController:self
                                                                                  style:LWImageBrowserAnimationStyleScale
                                                                            imageModels:tmp
                                                                           currentIndex:index];
    imageBrowser.view.backgroundColor = [UIColor blackColor];
    [imageBrowser show];
}

- (void)tableViewCell:(WLCommentInMyOrderCell *)cell didClickedSecondImageWithCellLayout:(FMCommentLayoutInMyOrder *)layout
              atIndex:(NSInteger)index;
{
    NSMutableArray* tmp = [[NSMutableArray alloc] initWithCapacity:layout.imagePostionSecondArray.count];
    for (NSInteger i = 0; i < layout.imagePostionSecondArray.count; i ++) {
        LWImageBrowserModel* imageModel = [[LWImageBrowserModel alloc] initWithplaceholder:nil
                                                                              thumbnailURL:[NSURL URLWithString:[layout.statusModel.secondImgs objectAtIndex:i]]
                                                                                     HDURL:[NSURL URLWithString:[layout.statusModel.secondImgs objectAtIndex:i]]
                                                                        imageViewSuperView:cell.contentView
                                                                       positionAtSuperView:CGRectFromString(layout.imagePostionSecondArray[i])
                                                                                     index:index];
        [tmp addObject:imageModel];
    }
    LWImageBrowser* imageBrowser = [[LWImageBrowser alloc] initWithParentViewController:self
                                                                                  style:LWImageBrowserAnimationStyleScale
                                                                            imageModels:tmp
                                                                           currentIndex:index];
    imageBrowser.view.backgroundColor = [UIColor blackColor];
    [imageBrowser show];
}

-(void)goodsCommentWith:(XZMyOrderGoodsModel *)orderModel
{
    XZPublishCommentViewController * commentView = [[XZPublishCommentViewController alloc]init];
    commentView.sendModel = orderModel;
    [self.navigationController pushViewController:commentView animated:YES];
}


@end
