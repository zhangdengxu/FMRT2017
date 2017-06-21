//
//  FMDuobaoShopCellHeaderView.h
//  fmapp
//
//  Created by runzhiqiu on 16/10/14.
//  Copyright © 2016年 yk. All rights reserved.
//
#define KFirstViewHeigh 80
#define KSecondViewHeigh 60
#define KThirdViewHeigh 80
#define KFourViewHeigh 40
#define KDefaultMargion 0.5
#import <UIKit/UIKit.h>

@class FMDuobaoClassStyle;
typedef void(^blockButtonOnClick)(FMDuobaoClassStyle * buobaoStyle);
typedef void(^blockButtonSpreadOnClick)(FMDuobaoClassStyle * buobaoStyle);



@interface FMDuobaoShopCellHeaderView : UITableViewHeaderFooterView

@property (nonatomic,copy) blockButtonOnClick buttonBlock;
@property (nonatomic,copy) blockButtonSpreadOnClick buttonSpread;
@property (nonatomic, strong) FMDuobaoClassStyle * duobaoStyle;

@end
