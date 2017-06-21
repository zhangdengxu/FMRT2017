//
//  FMShoppingListCell.h
//  fmapp
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMShoppingListModel.h"

typedef void(^selectButBlock) (UIButton *sender);
typedef void(^deleteButBlock) (UIButton *sender);
typedef void(^minusButBlock)  (UIButton *sender);
typedef void(^plusButBlock)   (UIButton *sender);
typedef void(^typeButBlock)   (UIButton *sender);
typedef void(^numberButBlock) (UIButton *sender);
typedef void(^editButBlock)   (UIButton *sender);
typedef void(^photoBlock)();


@interface FMShoppingListCell : UITableViewCell

@property (nonatomic, copy) selectButBlock selectBlcok;
@property (nonatomic, copy) deleteButBlock deleteBlcok;
@property (nonatomic, copy) minusButBlock  minusBlcok;
@property (nonatomic, copy) plusButBlock   plusBlcok;
@property (nonatomic, copy) typeButBlock   typeBlcok;
@property (nonatomic, copy) numberButBlock   numberBlcok;
@property (nonatomic, copy) editButBlock   editBlcok;
@property (nonatomic, copy) photoBlock photoBlcok;

- (void)sendDataToCellWith:(FMShoppingListModel *)model;

- (void)sendDataToCellWithModel:(FMShoppingListModel *)model;

@end
