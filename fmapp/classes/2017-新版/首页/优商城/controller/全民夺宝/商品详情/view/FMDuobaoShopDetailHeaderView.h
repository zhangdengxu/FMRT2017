//
//  FMTimeKillShopDetailHeaderView.h
//  fmapp
//
//  Created by runzhiqiu on 16/8/10.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
#define KDefauletCellItemLargeHeigh 40

@class FMDuobaoClass;
typedef void(^sdCycleItemOnClickBlock)(NSInteger  index);
typedef void(^contractBlock)(UIButton * button);

@interface FMDuobaoShopDetailHeaderView : UIView

@property (nonatomic, copy) sdCycleItemOnClickBlock itemBlock;
@property (nonatomic, strong) NSArray * shopImageUrl;
@property (nonatomic, strong) FMDuobaoClass * duobaoModel;
@property (nonatomic, copy)contractBlock block;

@end
