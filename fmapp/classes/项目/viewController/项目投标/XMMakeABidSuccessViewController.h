//
//  XMMakeABidSuccessViewController.h
//  fmapp
//
//  Created by runzhiqiu on 16/3/30.
//  Copyright © 2016年 yk. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "FMViewController.h"

@interface XMMakeABidSuccessViewController : FMViewController



-(void)showSuccessWith:(NSString *)money profit:(NSString *)profitMoney Time:(NSString *)time;
-(void)showFailWith:(NSString *)because;

@end
