//
//  FirstLeadViewController.h
//  fmapp
//
//  Created by runzhiqiu on 16/1/7.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FirstLeadViewController;

@protocol FirstLeadViewControllerDelegate <NSObject>

@optional
-(void)FirstLeadViewControllerTurnToMainView:(FirstLeadViewController *)viewController;

@end

@interface FirstLeadViewController : UIViewController

@property (nonatomic, weak) id <FirstLeadViewControllerDelegate> delegate;

@end
