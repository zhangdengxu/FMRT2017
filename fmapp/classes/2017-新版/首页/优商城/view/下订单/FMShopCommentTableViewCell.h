//
//  FMShopCommentTableViewCell.h
//  fmapp
//
//  Created by runzhiqiu on 16/4/26.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWAsyncDisplayView.h"
#import "FMCommentLayout.h"


@class FMShopCommentTableViewCell;

@protocol FMShopCommentTableViewCellDelegate <NSObject>

- (void)tableViewCell:(FMShopCommentTableViewCell *)cell didClickedImageWithCellLayout:(FMCommentLayout *)layout
              atIndex:(NSInteger)index;
- (void)tableViewCell:(FMShopCommentTableViewCell *)cell didClickedSecondImageWithCellLayout:(FMCommentLayout *)layout
              atIndex:(NSInteger)index;


@end


@interface FMShopCommentTableViewCell : UITableViewCell

@property (nonatomic,weak) id <FMShopCommentTableViewCellDelegate> delegate;
@property (nonatomic,strong) FMCommentLayout* cellLayout;
@property (nonatomic,strong) NSIndexPath* indexPath;

@end
