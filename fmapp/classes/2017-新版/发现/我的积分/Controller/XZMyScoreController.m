//
//  XZMyScoreController.m
//  fmapp
//
//  Created by admin on 17/2/21.
//  Copyright © 2017年 yk. All rights reserved.
//  我的积分

#import "XZMyScoreController.h"
#import "XZMyScoreCell.h"
#import "XZMyScoreHeaderView.h"
#import "FMRTWellStoreViewController.h" // 优商城
#import "ShareViewController.h" // 攻略
#import "XZMyScoreGoodsModel.h" // model
#import "XMConvertNotesViewController.h" // 兑换记录
#import "FMScoreTradeNoteNewController.h" // 积分明细
#import "FMPlaceOrderViewController.h" // 商品详情

// 热门商品数据
#define kXZHotGoodsUrl @"https://www.rongtuojinrong.com/qdy/wap/gallery-hotproducts_client.html?"

static NSString *reuseID = @"XZMyScoreCell";
static NSString *headerReuseID = @"XZMyScoreHeaderView";
static NSString *footerReuseID = @"XZMyScoreFootererView";
// 我的积分攻略
//#define kXZStrategyUrl @"https://www.rongtuojinrong.com/rongtuoxinsoc/helpzhongxin/jifengongl"

//#define kXZMyScoreHotGoodsUrl @"https://www.rongtuojinrong.com/qdy/wap/gallery-jifen_ex_client.html"

@interface XZMyScoreController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
///** 当前页数 */
//@property (nonatomic, assign) int currentPage;
/** model数组 */
@property (nonatomic, strong) NSMutableArray *arrGoodsData;
// 用户积分
@property (nonatomic, strong) NSString *userJifen;
@end

@implementation XZMyScoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self settingNavTitle:@"我的积分"];
//    self.currentPage = 1;
    //
    [self.view addSubview:self.collectionView];
    
    //
    UIButton *btnAboutUs = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAboutUs.frame = CGRectMake(0, 0, 40, 44);
    [btnAboutUs setTitle:@"攻略" forState:UIControlStateNormal];
    [btnAboutUs.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [btnAboutUs setTitleColor:[HXColor colorWithHexString:@"#0059D5"] forState:UIControlStateNormal];
    btnAboutUs.titleLabel.textAlignment = NSTextAlignmentRight;
    [btnAboutUs addTarget:self action:@selector(didClickUseinstructions) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnAboutUs];
    
    // 获取“热门商品”数据
    [self getMyScoreDataFromNetwork];
    // 请求用户积分数据
    [self getUserCoinsDataFromNetwork];
}

#pragma mark ---- 攻略
- (void)didClickUseinstructions {
    // kXZStrategyUrl  kXZUniversalTestUrl(@"GetMyPointsRaiders")
    ShareViewController *shareVc = [[ShareViewController alloc]initWithTitle:@"攻略" AndWithShareUrl:kFMPhpUniversalBaseUrl(@"Rongtuoxinsoc/helpzhongxin/jifengongl")];
    shareVc.JumpWay = @"MyRecommand";
    [self.navigationController pushViewController:shareVc animated:YES];
}

#pragma mark ----- 热门商品数据请求
- (void)getMyScoreDataFromNetwork {
    __weak __typeof(&*self)weakSelf = self;
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@appid=huiyuan&token=%@&shijian=%@&user_id=%@&from=rongtuoapp&tel=%@",kXZHotGoodsUrl,tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId,[CurrentUserInformation sharedCurrentUserInfo].mobile];
    
    [FMHTTPClient getPath:urlStr parameters:nil completion:^(WebAPIResponse *response) {
//        NSLog(@"数据 ============= %@",response.responseObject);
        if (response.responseObject) {
//            if (self.currentPage == 1) {
                [weakSelf.arrGoodsData removeAllObjects];
//            }
            if (response.code == WebAPIResponseCodeSuccess) {
                NSArray *data = response.responseObject[@"data"];
                if (![data isKindOfClass:[NSNull class]]) {
                    if (data.count > 0) {
                        for (NSDictionary *dict in data) {
                            XZMyScoreGoodsModel *modelMyScore = [[XZMyScoreGoodsModel alloc] init];
                            [modelMyScore setValuesForKeysWithDictionary:dict];
                            [weakSelf.arrGoodsData addObject:modelMyScore];
                        }
                    }
                }
                else {
                    ShowAutoHideMBProgressHUD(weakSelf.view, [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]]);
                }
            }
            else {
                ShowAutoHideMBProgressHUD(weakSelf.view, [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]]);
            }
        }
        else {
            ShowAutoHideMBProgressHUD(weakSelf.view, @"获取数据失败");
        }
        [weakSelf.collectionView reloadData];
        [weakSelf.collectionView.mj_header endRefreshing];
//        [weakSelf.collectionView.mj_footer endRefreshing];
    }];
}

#pragma mark ----- 请求用户积分数据
- (void)getUserCoinsDataFromNetwork {
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSString *urlStr = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/jifenchaxun?appid=huiyuan&token=%@&shijian=%@&user_id=%@",tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId];
    __weak typeof (self)weakSelf = self;
    [FMHTTPClient postPath:urlStr parameters:nil completion:^(WebAPIResponse *response) {
        
//        NSLog(@"用户积分数据 ======= %@",response.responseObject);
        if (response.responseObject) {
            if (response.code == WebAPIResponseCodeSuccess) {
                weakSelf.userJifen = response.responseObject[@"jifen"];
            }
        }
        [weakSelf.collectionView reloadData];
    }];
}

#pragma mark ----- UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrGoodsData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XZMyScoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];

    if (self.arrGoodsData.count > 0) {
        cell.modelMyScore = self.arrGoodsData[indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FMPlaceOrderViewController *placeOrder = [[FMPlaceOrderViewController alloc] init];
    XZMyScoreGoodsModel *modelGoods = self.arrGoodsData[indexPath.row];
    placeOrder.product_id = modelGoods.product_id;
    if ([modelGoods.type isEqualToString:@"normal"]) { // 正常商品
        placeOrder.isShopFullScore = 0;
    }else { // 全积分商品
        placeOrder.isShopFullScore = 1;
    }
    placeOrder.goToGoodShopIndex = 2;
    [self.navigationController pushViewController:placeOrder animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout
//设置section的头标题
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reuseableView = nil;
    // 如果是section的头
    if (kind == UICollectionElementKindSectionHeader) {
        XZMyScoreHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReuseID forIndexPath:indexPath];
        headerView.userJifen = self.userJifen;
        
        // 点击"热门商品"跳转"优商城"
        __weak typeof (self)weakSelf = self;
        headerView.blockDidClickButton = ^(UIButton *button){
            if (button.tag == 520) { // 积分明细
                FMScoreTradeNoteNewController *scoreTrade = [[FMScoreTradeNoteNewController alloc] init];
                [weakSelf.navigationController pushViewController:scoreTrade animated:YES];
            }else if (button.tag == 521){ // 兑换记录
                XMConvertNotesViewController *convertNotes = [[XMConvertNotesViewController alloc] init];
                [weakSelf.navigationController pushViewController:convertNotes animated:YES];
            }else {// 热门商品
                FMRTWellStoreViewController *wellStore = [[FMRTWellStoreViewController alloc]init];
                [weakSelf.navigationController pushViewController:wellStore animated:YES];
            }
        };
        reuseableView = headerView;
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerReuseID forIndexPath:indexPath];
        reuseableView = footerView;
    }
    return reuseableView;
}

#pragma mark ---- 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat width = (KProjectScreenWidth - 10.1) / 2.0;
        flowLayout.itemSize = CGSizeMake(width, width + (50 / 320.0 * KProjectScreenWidth));
        flowLayout.minimumInteritemSpacing = 0.0001;
        flowLayout.minimumLineSpacing = 0.0001;
        flowLayout.headerReferenceSize = CGSizeMake(KProjectScreenWidth, 155);
        flowLayout.footerReferenceSize = CGSizeMake(KProjectScreenWidth, 20);
        //
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, 0, KProjectScreenWidth - 10, KProjectScreenHeight - 64) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[XZMyScoreCell class] forCellWithReuseIdentifier:reuseID];
        // 注册UICollectionReusableView的headerView
        [_collectionView registerClass:[XZMyScoreHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReuseID];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerReuseID];
        
        // 下拉刷新
        __weak __typeof(&*self)weakSelf = self;
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf.collectionView.mj_header endRefreshing];
        }];

    }
    return _collectionView;
}

- (NSMutableArray *)arrGoodsData {
    if (!_arrGoodsData) {
        _arrGoodsData = [NSMutableArray array];
    }
    return _arrGoodsData;
}

@end
