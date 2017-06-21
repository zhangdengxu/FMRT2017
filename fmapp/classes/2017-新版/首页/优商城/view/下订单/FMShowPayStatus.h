//
//  FMShowPayStatus.h
//  fmapp
//
//  Created by runzhiqiu on 16/6/1.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMShowPayStatus;
@protocol FMShowPayStatusDelegate <NSObject>

@optional

-(void)FMShowPayStatusPayResult:(NSInteger)index;

@end

@interface FMShowPayStatus : UIView

@property (nonatomic, weak) id <FMShowPayStatusDelegate> delegate;

-(void)showSuccessWithView:(UIView *)view;
-(void)showFaileWithView:(UIView *)view;

@end
