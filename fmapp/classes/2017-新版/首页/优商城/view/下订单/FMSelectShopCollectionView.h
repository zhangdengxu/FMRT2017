//
//  FMSelectShopCollectionView.h
//  fmapp
//
//  Created by runzhiqiu on 16/4/28.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMSpecProductModel,FMSelectShopInfoModel;


typedef void(^sendInfoShopModelBlock)(FMSelectShopInfoModel * specPro);
typedef enum {
    FMSelectShopCollectionViewTypeNOTShowCount = 0,//不显示数量
    FMSelectShopCollectionViewTypeShowCount,//显示数量
} FMSelectShopCollectionViewType;


@interface FMSelectShopCollectionView : UIView

@property (nonatomic,copy) sendInfoShopModelBlock  shopSpecPro;
@property (nonatomic, assign) NSInteger currentStore;
@property (nonatomic, assign) FMSelectShopCollectionViewType showCountType;
@property (nonatomic,copy) NSString *defau_Product_id;
- (void)setcollectionViewDataSource:(NSArray *)dataSource WithModelDataSource:(NSArray *)modelDataSource WithSelectModel:(FMSelectShopInfoModel *)selectModel;
-(void)changeModelDataSource:(NSArray *)modelDataSource;
-(void)reloadCollectionView;
@end
