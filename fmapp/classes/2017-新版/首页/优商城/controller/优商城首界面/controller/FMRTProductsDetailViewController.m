//
//  FMRTProductsDetailViewController.m
//  fmapp
//
//  Created by apple on 2016/12/2.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTProductsDetailViewController.h"
#import "FMRTWellStoreProductCollectionViewCell.h"
#import "FMRTWellStoreProductModel.h"
#import "MJRefresh.h"
#import "FMRTWellStoreProductFooterView.h"
#import "FMPlaceOrderViewController.h"

@interface FMRTProductsDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, copy)   NSString *cateid;

@end

static NSString *FMRTWellStoreProductCollectionViewCellID = @"FMRTWellStoreProductCollectionViewCellID";
static NSString *FMRTWellStoreProductFooterViewID = @"FMRTWellStoreProductFooterViewID";


@implementation FMRTProductsDetailViewController
extern NSString *const ZJParentTableViewDidLeaveFromTopNotification;

- (void)zj_viewDidLoadForIndex:(NSInteger)index{
    
    [self getDataSourceFromNetWork];
}

- (void)zj_viewWillAppearForIndex:(NSInteger)index{

    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewIsScrolling:)]) {
        [self.delegate scrollViewIsScrolling:self.collectionView];
    }
}

-(void)getDataSourceFromNetWork{
    
    NSString * html = [NSString stringWithFormat:@"%@?cateid=%@&p=%zi",KGoodShop_Index_ShopList_Url,self.cateID,self.currentPage];
    FMWeakSelf;
    [FMHTTPClient postPath:html parameters:nil completion:^(WebAPIResponse *response) {

        if (response.responseObject) {
            
            if (response.code == WebAPIResponseCodeSuccess) {
                NSDictionary *dic = response.responseObject;
                NSArray *dataArr = [FMRTWellCollectionModel collectionArrWithDic:dic];
                if (dataArr.count) {

                    [weakSelf.dataSource addObjectsFromArray:dataArr];
                    if (dataArr.count<10) {
                        [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [weakSelf.collectionView.mj_footer endRefreshing];
                    }
                }else{
                    
                    [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
                }
            }else{

                if ([response.responseObject objectForKey:@"msg"]) {
                    
                    NSString *msgStr = [response.responseObject objectForKey:@"msg"];
                    
                    ShowAutoHideMBProgressHUD(weakSelf.view, msgStr);
                }else{
                    ShowAutoHideMBProgressHUD(weakSelf.view, @"请求数据失败！");
                }
                
                [weakSelf.collectionView.mj_footer endRefreshing];

            }
        }else{
            ShowAutoHideMBProgressHUD(weakSelf.navigationController.view, @"请求网络数据失败");
            [weakSelf.collectionView.mj_footer endRefreshing];

        }
        [weakSelf.collectionView reloadData];
    }];
}

//- (void)getCateidFromPresentVC:(NSNotification *)notification{

//    if (![self.cateid isEqualToString:notification.object]) {
//        self.cateid = notification.object;
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCateidFromPresentVC:) name:@"chuanzhiID" object:nil];

    
    self.automaticallyAdjustsScrollViewInsets = NO;
    /// 利用通知可以同时修改所有的子控制器的scrollView的contentOffset为CGPointZero
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leaveFromTop) name:ZJParentTableViewDidLeaveFromTopNotification object:nil];
    
    
    self.currentPage = 1;
//    self.view.backgroundColor = [UIColor cyanColor];
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    layout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0);
    layout.itemSize = CGSizeMake(KProjectScreenWidth/2-0.5, KProjectScreenWidth/2-0.5 + 80);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 44 - 64) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    FMWeakSelf;

    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage += 1;
        [weakSelf getDataSourceFromNetWork];
    }];
    [footer setTitle:@"点击或上拉查看更多商品" forState:(MJRefreshStateIdle)];
    self.collectionView.mj_footer = footer;
    [self.collectionView registerClass:[FMRTWellStoreProductCollectionViewCell class] forCellWithReuseIdentifier:FMRTWellStoreProductCollectionViewCellID];
    [self.collectionView registerClass:[FMRTWellStoreProductFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FMRTWellStoreProductFooterViewID];
    
    self.collectionView.backgroundColor = [HXColor colorWithHexString:@"#e4ebf1"];
    [self.view addSubview:self.collectionView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    self.collectionView.mj_footer.hidden =(self.dataSource.count==0);
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FMRTWellStoreProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FMRTWellStoreProductCollectionViewCellID forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}


/*
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    FMRTWellStoreProductFooterView *headReusableView;
    if (kind == UICollectionElementKindSectionFooter) {
        headReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:FMRTWellStoreProductFooterViewID forIndexPath:indexPath];
    }
    FMWeakSelf;
    __strong typeof (headReusableView)stongView = headReusableView;
    headReusableView.block = ^(){

    };
    return headReusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(KProjectScreenWidth, 50);
}
*/
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.selectBlock) {
        self.selectBlock();
    }
    

    FMPlaceOrderViewController * placeOrder = [[FMPlaceOrderViewController alloc]init];
    FMRTWellCollectionModel *model = self.dataSource[indexPath.row];
    if ([model.fulljifen_ex integerValue] >0) {
        placeOrder.isShopFullScore = 1;
    }else{
        placeOrder.isShopFullScore = 0;
    }
    placeOrder.product_id = model.product_id;
    [self.navigationController pushViewController:placeOrder animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


//- (void)leaveFromTop {
//    _collectionView.contentOffset = CGPointZero;
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewIsScrolling:)]) {
        [self.delegate scrollViewIsScrolling:scrollView];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
