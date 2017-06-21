//
//  FMShowShopPriceActivity.h
//  fmapp
//
//  Created by runzhiqiu on 16/7/18.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMShowShopPriceActivity : UIView
@property (nonatomic, strong) NSArray * dataSource;

-(void)showActivity;

-(void)changeActivityViewTitle:(NSString *)title andCloseTitle:(NSString *)closeTitle;
@end
