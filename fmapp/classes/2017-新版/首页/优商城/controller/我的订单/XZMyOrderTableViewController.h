//
//  XZMyOrderTableViewController.h
//  XZFenLeiJieMian
//
//  Created by admin on 16/5/3.
//  Copyright © 2016年 yuyang. All rights reserved.
//

#import "FMViewController.h"
typedef enum : NSUInteger {
    XZMyOrderTableViewTypeALL,
    XZMyOrderTableViewTypeWaitPay,//
    XZMyOrderTableViewTypeWaitSend,
    XZMyOrderTableViewTypeWaitRecive,
    XZMyOrderTableViewTypeWaitComment,
    XZMyOrderTableViewTypeAfterSale
} XZMyOrderTableViewType;

@class XZMyOrderTableView,XZMyOrderTableViewController;

@protocol XZMyOrderTableViewControllerDelegate <NSObject>

@optional

-(void)XZMyOrderTableViewController:(XZMyOrderTableViewController *)viewController didselectTitle:(NSInteger)index;

@end



@interface XZMyOrderTableViewController : FMViewController
@property (nonatomic,assign)XZMyOrderTableViewType type;
@property (nonatomic, weak) id <XZMyOrderTableViewControllerDelegate> delegate;

-(void)refreshView;

@end
