//
//  RecommendCell.h
//  fmapp
//
//  Created by apple on 15/7/3.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectCell.h"

@protocol CellBtnClickDelegate <NSObject>

- (void)CellBtnClickDelegate:(ProjectModel *)model;

@end

@interface RecommendCell : UITableViewCell

@property (nonatomic,weak)UIButton       *finishButton;
@property (nonatomic,weak)id<CellBtnClickDelegate>  delegate;

- (void) displayQuestion:(ProjectModel* )model;

@end
