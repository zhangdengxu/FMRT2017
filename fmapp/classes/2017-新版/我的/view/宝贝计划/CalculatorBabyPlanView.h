//
//  CalculatorBabyPlanView.h
//  fmapp
//
//  Created by runzhiqiu on 16/1/12.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalculatorBabyPlanView;
@protocol CalculatorBabyPlanViewDelegate <NSObject>

@optional

-(void)calculatorBabyPlanView:(CalculatorBabyPlanView *)calculate showAlterView:(NSString *)contentString;
@end

@interface CalculatorBabyPlanView : UIView

//@property (nonatomic, weak) id <CalculatorBabyPlanViewDelegate> delegate;


-(void)showCalculateBabyPlayView;
- (IBAction)closeThisView:(id)sender;
@end
