//
//  FMShopingPastTableViewCell.h
//  fmapp
//
//  Created by apple on 16/4/24.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMShoppingListModel.h"

@interface FMShopingPastTableViewCell : UITableViewCell

- (void)sendDataToCellWith:(FMShoppingListModel *)model;

@end
