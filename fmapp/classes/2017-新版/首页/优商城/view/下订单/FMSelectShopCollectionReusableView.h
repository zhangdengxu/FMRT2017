//
//  FMSelectShopCollectionReusableView.h
//  fmapp
//
//  Created by runzhiqiu on 16/4/28.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ selectShopCountSuccessBlock)(NSInteger shopCount);

@interface FMSelectShopCollectionReusableView : UICollectionReusableView

@property (nonatomic, strong) UILabel * titleShopLabel;


@property (nonatomic, assign) BOOL isShowAddView;

@property (nonatomic, assign) NSInteger maxCount;

@property (nonatomic,copy) selectShopCountSuccessBlock selectShopCount;

@property (nonatomic,copy) NSString * currentCount;
@end
