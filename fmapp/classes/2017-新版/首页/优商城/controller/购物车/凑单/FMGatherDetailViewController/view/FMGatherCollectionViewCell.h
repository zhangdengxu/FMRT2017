//
//  FMGatherCollectionViewCell.h
//  fmapp
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMGatherModel.h"

@interface FMGatherCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) FMGatherModel *model;
@property (nonatomic, copy) void(^MoveToShoppingListBlock)(UIButton *sender);

+ (CGSize)heightForItemWith:(FMGatherModel *)model;

@end
