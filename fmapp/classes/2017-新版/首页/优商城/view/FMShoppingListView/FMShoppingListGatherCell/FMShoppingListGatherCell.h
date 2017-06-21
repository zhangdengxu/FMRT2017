//
//  FMShoppingListGatherCell.h
//  fmapp
//
//  Created by apple on 16/4/26.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonBlock)(UIButton *sender);

@interface FMShoppingListGatherCell : UITableViewCell

@property (nonatomic, copy) ButtonBlock block;

@end
