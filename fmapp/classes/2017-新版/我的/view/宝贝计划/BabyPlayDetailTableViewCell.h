//
//  BabyPlayDetailTableViewCell.h
//  fmapp
//
//  Created by runzhiqiu on 16/1/4.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BabyPlanDetailModel,BabyPlayDetailTableViewCell;
typedef void(^babyPlayDetailTableViewCellButtonBlock)(BabyPlayDetailTableViewCell * cell);

@interface BabyPlayDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) BabyPlanDetailModel * plandetail;

@property (nonatomic,copy) babyPlayDetailTableViewCellButtonBlock buttonBlock;

@property (nonatomic, copy) void(^xiugaiBlcok)();

-(void)changeBabyPlanDetailStatus;


@end
