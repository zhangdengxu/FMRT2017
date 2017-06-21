//
//  FMShopStandardController.h
//  fmapp
//
//  Created by runzhiqiu on 2016/12/10.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMViewController.h"



@class FMShopStandardController,FMPlaceOrderViewController;
@protocol FMShopStandardControllerDelegate <NSObject>

@optional

-(void)FMShopStandardController:(FMShopStandardController *)shopComment withTableView:(UITableView *)tableView withFloatY:(CGFloat)contenty;


@end
@interface FMShopStandardController : UIViewController


@property (nonatomic, weak) id <FMShopStandardControllerDelegate> delegate;
@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic, weak) FMPlaceOrderViewController * fatherController;
@property (nonatomic, strong) NSMutableArray * dataSource;

-(void)disTroyVideo;

@end
