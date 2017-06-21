//
//  AddbabyPlanTableViewCell.h
//  fmapp
//
//  Created by runzhiqiu on 16/1/5.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddbabyPlanTableViewCell;
@class BabyPlanOneScheduled;
@protocol AddbabyPlanTableViewCellDelegate <NSObject>

-(void)AddbabyPlanTableViewCell:(AddbabyPlanTableViewCell *)addPlanTableViewCell ContractButtonOnClick:(BabyPlanOneScheduled *)scheduled;

@end


@interface AddbabyPlanTableViewCell : UITableViewCell

@property (nonatomic, strong) BabyPlanOneScheduled * scheduled;
@property (nonatomic, weak) id <AddbabyPlanTableViewCellDelegate> delegate;

@end
