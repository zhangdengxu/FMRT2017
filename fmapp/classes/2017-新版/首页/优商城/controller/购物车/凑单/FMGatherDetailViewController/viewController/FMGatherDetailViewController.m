//
//  FMGatherDetailViewController.m
//  fmapp
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMGatherDetailViewController.h"
#import "FMGatherCollectionViewCell.h"
#import "FMGatherModel.h"
#import "FMButtonStyleModel.h"
#import "FMShopSpecModel.h"
#import "MJExtension.h"
#import "FMPlaceOrderViewController.h"

@interface FMGatherDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)NSMutableArray   *dataSource;
@property (nonatomic, strong)UICollectionView *collectionView;

@end

@implementation FMGatherDetailViewController
static NSString *identifier = @"FMGatherDetailViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = KDefaultOrBackgroundColor;
    [self settingNavTitle:@"凑单"];
    [self setUpCollectionView];
    [self.collectionView.mj_header beginRefreshing];
}

- (void)requestDataToCollectionView {
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?tab_name=%@from=rongtuoapp&tel=%@&appid=huiyuan&token=%@&shijian=%@&user_id=%@",KFMGatherUrl,self.tab_filter,[CurrentUserInformation sharedCurrentUserInfo].mobile,tokenlow,[NSNumber numberWithInt:timestamp],[CurrentUserInformation sharedCurrentUserInfo].userId];

    [FMHTTPClient postPath:urlStr parameters:nil completion:^(WebAPIResponse *response) {
       
        NSDictionary *dicData = [NSDictionary dictionaryWithDictionary:response.responseObject];
        if (response.code == WebAPIResponseCodeSuccess) {
            self.dataSource = (NSMutableArray *)[FMGatherModel mj_objectArrayWithKeyValuesArray:dicData[@"data"]];
            
            [self.collectionView reloadData];
        }else{
            ShowAutoHideMBProgressHUD(self.view, @"请求数据失败");
        }
        [self.collectionView.mj_header endRefreshing];
    }];
}

- (void)setUpCollectionView {
    
    UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc]init];
    [collectionLayout setScrollDirection:UICollectionViewScrollDirectionVertical];

    collectionLayout.itemSize = CGSizeMake((KProjectScreenWidth - 30)/2, (KProjectScreenWidth - 30)/2 + 100);
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,KProjectScreenWidth , KProjectScreenHeight - 110) collectionViewLayout:collectionLayout];

    collectionView.backgroundColor = [UIColor clearColor];

    collectionView.alwaysBounceVertical = YES;
    [collectionView registerClass:[FMGatherCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    self.collectionView = collectionView;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    collectionView.showsVerticalScrollIndicator = YES;
    collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

        [self requestDataToCollectionView];
    }];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FMGatherCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    __weak typeof (self)weakSelf = self;
    cell.MoveToShoppingListBlock = ^(UIButton *sender){
        [weakSelf moveShopProductToShoppingList:sender];
    };
    return cell;
}

- (void)moveShopProductToShoppingList:(UIButton *)sender {
//   ShowAutoHideMBProgressHUD(self.view, @"添加到购物车，方法暂时没有写，没有！！！");
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    FMGatherModel *model = self.dataSource[indexPath.row];
//    return [FMGatherCollectionViewCell heightForItemWith:model];
//}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return  UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FMGatherModel *model = self.dataSource[indexPath.row];
    FMPlaceOrderViewController *orderVC = [[FMPlaceOrderViewController alloc]init];
    orderVC.product_id = model.product_id;
    
    [self.navigationController pushViewController:orderVC animated:YES];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
