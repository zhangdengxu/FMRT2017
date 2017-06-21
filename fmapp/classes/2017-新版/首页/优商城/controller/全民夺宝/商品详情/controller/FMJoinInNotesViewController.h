//
//  FMJoinInNotesViewController.h
//  fmapp
//
//  Created by runzhiqiu on 2016/11/1.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMViewController.h"

@class FMJoinInNotesViewController,FMShopDetailDuobaoViewController;
@protocol FMJoinInNotesViewControllerDelegate <NSObject>

@optional

-(void)FMJoinInNotesViewController:(FMJoinInNotesViewController *)shopComment withTableView:(UITableView *)tableView withFloatY:(CGFloat)contenty;

@end

@interface FMJoinInNotesViewController : FMViewController

@property (nonatomic,weak) id <FMJoinInNotesViewControllerDelegate> delegate;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, weak) FMShopDetailDuobaoViewController * fatherController;
@property (nonatomic, assign) BOOL  showNavigationBar;

@property (nonatomic,copy) NSString *won_id;

-(void)refreshDataSource;


@end
