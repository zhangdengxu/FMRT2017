//
//  XMShopCommentViewController.h
//  fmapp
//
//  Created by runzhiqiu on 16/4/26.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMViewController.h"

@class XMShopCommentViewController,FMPlaceOrderViewController;
@protocol XMShopCommentViewControllerDelegate <NSObject>

@optional

-(void)XMShopCommentViewController:(XMShopCommentViewController *)shopComment withTableView:(UITableView *)tableView withFloatY:(CGFloat)contenty;
@end


@interface XMShopCommentViewController : UIViewController
@property (nonatomic,copy) NSString *goods_id;

@property (nonatomic, weak) id <XMShopCommentViewControllerDelegate> delegate;
@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic, weak) FMPlaceOrderViewController * fatherController;

-(void)disTroyVideo;


@end
