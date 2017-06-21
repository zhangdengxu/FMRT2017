//
//  WLCommentInMyOrderCell.h
//  fmapp
//
//  Created by runzhiqiu on 16/5/4.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LWAsyncDisplayView.h"
#import "FMCommentLayoutInMyOrder.h"


@class WLCommentInMyOrderCell;
typedef void(^blockCommentBtn)();
@protocol WLCommentInMyOrderCellDelegate <NSObject>

- (void)tableViewCell:(WLCommentInMyOrderCell *)cell didClickedImageWithCellLayout:(FMCommentLayoutInMyOrder *)layout
              atIndex:(NSInteger)index;

- (void)tableViewCell:(WLCommentInMyOrderCell *)cell didClickedSecondImageWithCellLayout:(FMCommentLayoutInMyOrder *)layout atIndex:(NSInteger)index;


@end


@interface WLCommentInMyOrderCell : UITableViewCell

@property (nonatomic,weak) id <WLCommentInMyOrderCellDelegate> delegate;
@property (nonatomic,strong) FMCommentLayoutInMyOrder* cellLayout;
@property (nonatomic,strong) NSIndexPath * indexPath;

@property (nonatomic, copy) blockCommentBtn blockCommentBtn;
@end
