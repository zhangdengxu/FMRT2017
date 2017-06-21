//
//  FMSelectShopCollectionView.h
//  fmapp
//
//  Created by runzhiqiu on 16/4/28.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMSpecProductModel,FMSelectShopInfoModel;


typedef void(^sendInfoShopModelBlock)(NSArray * locationArray);
typedef void(^sendSelectCountBlock)(NSInteger  selecCount);

typedef enum {
    FMSelectShopCollectionViewTypeNOTShowCount = 0,//不显示数量
    FMSelectShopCollectionViewTypeShowCount,//显示数量
} FMSelectShopCollectionViewType;

@interface FMSelectDuobaoShopCollectionView : UIView


@property (nonatomic,copy) sendInfoShopModelBlock  shopSpecPro;
@property (nonatomic,copy) sendSelectCountBlock  selectCountBlock;


@property (nonatomic, assign) NSInteger currentStore;
@property (nonatomic, assign) NSInteger selectStore;


@property (nonatomic, assign) FMSelectShopCollectionViewType showCountType;
//初始化collectionView
- (void)setcollectionViewDataSource:(NSArray *)dataSource  WithSelectModel:(NSArray *)locationArray;




-(void)changeModelDataSource:(NSArray *)dataSource;



@end
