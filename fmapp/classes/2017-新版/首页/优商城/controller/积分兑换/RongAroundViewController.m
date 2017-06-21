//
//  RongAroundViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/4/19.
//  Copyright © 2016年 yk. All rights reserved.
//

#define KDefaultTextColor [UIColor colorWithRed:(170.0/255) green:(170.0/255) blue:(170.0/255) alpha:1]
#import "RongAroundViewController.h"
#import "WLRongModel.h"
#import "WLAroundTableViewCell.h"
#import "CurrentUserInformation.h"
#import "MJRefresh.h"
#import "HTTPClient.h"
#import "FMPlaceOrderViewController.h"

#import "FMAroundCollectionReusableView.h"
#import "FMMessageAlterView.h"
#import "WLMessageViewController.h"
#import "FMRTWellStoreViewController.h"
@interface RongAroundViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,FMMessageAlterViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray * stringDataSource;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) BOOL isAddData;
@property (nonatomic, copy)   NSString *navUrl;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) UICollectionView * collectionView;

@end

@implementation RongAroundViewController
static NSString * rongAroundViewCellRegister = @"rongAroundViewCellRegister";
static NSString * rongAroundElementKindSectionHeader = @"rongAroundElementKindSectionHeader";

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(NSMutableArray *)stringDataSource
{
    if (!_stringDataSource) {
        _stringDataSource = [NSMutableArray array];
    }
    return _stringDataSource;
}


-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        CGFloat width = (KProjectScreenWidth - 2) / 2;
        CGFloat height = width * 0.8 + 70;
        
        UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc]init];
        
        collectionLayout.minimumLineSpacing = 2;
        collectionLayout.minimumInteritemSpacing = 2;
        
        collectionLayout.itemSize = CGSizeMake(width, height);
        collectionLayout.sectionInset = UIEdgeInsetsMake(1, 0, 2, 0);
        [collectionLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView.backgroundColor = [UIColor colorWithRed:(223.0/255.0) green:(235.0/255.0) blue:(243.0/255.0) alpha:1];
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:collectionLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth ;
        _collectionView.alwaysBounceVertical = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[WLAroundTableViewCell class] forCellWithReuseIdentifier:rongAroundViewCellRegister];
        [_collectionView registerClass:[FMAroundCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:rongAroundElementKindSectionHeader];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.view addSubview:_collectionView];
        
        
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.currentPage  = 1;
            self.isAddData = NO;
            [self getDataSourceFromNetWork];
        }];
        _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            self.currentPage ++;
            self.isAddData = YES;
            [self getDataSourceFromNetWork];
        }];
        
    }
    return _collectionView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:(223.0/255.0) green:(235.0/255.0) blue:(243.0/255.0) alpha:1];
    [self settingNavTitle:@"积分兑换"];
    _currentPage = 1;
    [self getDataSourceFromNetWork];
    //[self setNavItemsWithButton];
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


-(void)getDataSourceFromNetWork{
    
    self.navUrl = @"https://www.rongtuojinrong.com/qdy/wap/gallery-jifen_ex_client.html";
    NSString * urlNet = [NSString stringWithFormat:@"%@?p=%d",self.navUrl,self.currentPage];
    __weak __typeof(&*self)weakSelf = self;
    [FMHTTPClient getPath:urlNet parameters:nil completion:^(WebAPIResponse *response) {
        
            NSString * status = [NSString stringWithFormat:@"%@",response.responseObject[@"data"]];
            
            if ([status integerValue] == 0) {
                
                
                NSDictionary * oldArray = response.responseObject[@"data"];
                NSArray *array = [oldArray objectForKey:@"products"];
                NSArray * sliderArray = [oldArray objectForKey:@"slides"];
                
                if (![array isMemberOfClass:[NSNull class]]) {
                    if (self.isAddData) {
                        self.isAddData = NO;
                    }else
                    {
                        [self.dataSource removeAllObjects];
                    }
                    
                    for (NSDictionary * product in array) {
                        
                        
                        
                        WLRongModel * rongModel = [[WLRongModel alloc]init];
                        [rongModel setValuesForKeysWithDictionary:product];
                        [self.dataSource addObject:rongModel];
                    }
                    
                    
                }
                
                if (![sliderArray isMemberOfClass:[NSNull class]]) {
                    for (NSString * sliderString in sliderArray) {
                        [self.stringDataSource addObject:sliderString];
                    }
                }
                
                [self.collectionView reloadData];
            }else if([status integerValue] == 2){
                
                ShowAutoHideMBProgressHUD(weakSelf.view,@"加载完毕");
                [weakSelf.collectionView reloadData];
            }else{
                
                ShowAutoHideMBProgressHUD(weakSelf.view,NETERROR_LOADERR_TIP);
                [weakSelf.collectionView reloadData];
            }
            [weakSelf.collectionView.mj_header endRefreshing];
            [weakSelf.collectionView.mj_footer endRefreshing];
    }];

}


#pragma mark - UICollectionViewDelegate



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return self.dataSource.count;
}
- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    WLAroundTableViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:rongAroundViewCellRegister forIndexPath:indexPath];
    cell.detailModel = self.dataSource[indexPath.item];
    
    
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        FMAroundCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:rongAroundElementKindSectionHeader forIndexPath:indexPath];
        
        headerView.slidesArray = self.stringDataSource;
        
        reusableview = headerView;
        
    }
    return reusableview;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={KProjectScreenWidth,KProjectScreenWidth/ 375.0 * 160};
    
    return size;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    WLRongModel * model = self.dataSource[indexPath.item];
    FMPlaceOrderViewController * placeOrder = [[FMPlaceOrderViewController alloc]init];
    placeOrder.product_id = model.product_id;
    placeOrder.isShopFullScore = 1;
    [self.navigationController pushViewController:placeOrder animated:YES];
}






@end
