//
//  FMShopJoinInViewController.h
//  fmapp
//
//  Created by runzhiqiu on 16/10/14.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMViewController.h"

@class FMShopJoinInViewController,FMShopDetailDuobaoViewController,FMDuobaoClassStyle;

typedef void(^blockButtonOnClick)(FMDuobaoClassStyle * buobaoStyle);

@protocol FMShopJoinInViewControllerDelegate <NSObject>

@optional

-(void)FMShopJoinInViewController:(FMShopJoinInViewController *)shopComment withTableView:(UITableView *)tableView withFloatY:(CGFloat)contenty;
@end

@interface FMShopJoinInViewController : FMViewController
@property (nonatomic, weak) id <FMShopJoinInViewControllerDelegate> delegate;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, weak) FMShopDetailDuobaoViewController * fatherController;

@property (nonatomic, strong) NSArray * dataSource;
@property (nonatomic,copy) blockButtonOnClick buttonBlock;

-(void)reloadViewWithDataSource;
@end
