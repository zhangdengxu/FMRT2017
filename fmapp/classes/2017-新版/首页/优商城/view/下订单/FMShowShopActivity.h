//
//  FMShowShopActivity.h
//  fmapp
//
//  Created by runzhiqiu on 16/5/12.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMShowShopActivity : UIView

@property (nonatomic, strong) NSArray * dataSource;

-(void)showActivity;

-(void)changeActivityViewTitle:(NSString *)title andCloseTitle:(NSString *)closeTitle;

@end
