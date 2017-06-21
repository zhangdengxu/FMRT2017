//
//  FMFavoriteTableViewCell.h
//  fmapp
//
//  Created by apple on 16/4/29.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMFavoriteModel.h"


typedef void(^SelectBlock)(UIButton *sender);

@interface FMFavoriteTableViewCell : UITableViewCell

@property (nonatomic, copy) SelectBlock selectBlock;

- (void)sendeDataWithModel:(FMFavoriteModel *)model;

@end
