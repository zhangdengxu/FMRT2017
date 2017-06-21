//
//  BabyPlandetailView.h
//  fmapp
//
//  Created by runzhiqiu on 16/1/4.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BabyPlanModel;

@class BabyPlandetailView;

@protocol BabyPlandetailViewDelegate <NSObject>

@optional
-(void)BabyPlandetailView:(BabyPlandetailView *) babyPlanView WithJieid:(BabyPlanModel *)planModel;
-(void)BabyPlandetailView:(BabyPlandetailView *) babyPlanView WithAddBabyPlan:(BabyPlanModel *)planModel;

@end

@interface BabyPlandetailView : UIView

@property (nonatomic, strong) BabyPlanModel * babyPlan;
@property (nonatomic, weak) id <BabyPlandetailViewDelegate> delegate;

@end
