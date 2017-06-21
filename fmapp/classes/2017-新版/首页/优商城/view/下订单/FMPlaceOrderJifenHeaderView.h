//
//  FMPlaceOrderHeaderView.h
//  fmapp
//
//  Created by runzhiqiu on 16/4/24.
//  Copyright © 2016年 yk. All rights reserved.
//

#define KDefauletCellItemLargeHeigh 40
#define KDefauletCellItemMiddleHeigh 30
#define KDefauletCellItemLittleHeigh 18
#import <UIKit/UIKit.h>
@class FMSelectShopInfoModel;
typedef enum {
    FMPlaceOrderHeaderViewTpyeDetail=0,//商品详情
    FMPlaceOrderHeaderViewTpyeComment,//商品评价
} FMPlaceOrderHeaderViewType;

typedef void(^contractBlock)(UIButton * button);
typedef void(^sdCycleItemOnClickBlock)(NSInteger  index);
@interface FMPlaceOrderJifenHeaderView : UIView

@property (nonatomic, copy)contractBlock block;
@property (nonatomic, copy) sdCycleItemOnClickBlock itemBlock;
@property (nonatomic, assign) CGFloat headerViewHeigh;

@property (nonatomic, strong) NSArray * shopImageUrl;
@property (nonatomic, strong) FMSelectShopInfoModel * shopDetailModel;

@end
