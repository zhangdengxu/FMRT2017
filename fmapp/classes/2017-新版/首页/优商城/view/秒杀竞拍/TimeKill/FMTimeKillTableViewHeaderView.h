//
//  FMTimeKillTableViewHeaderView.h
//  fmapp
//
//  Created by runzhiqiu on 16/8/5.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^backGroundButtonBlock)(NSInteger index);

@interface FMTimeKillTableViewHeaderView : UIView

@property (nonatomic,copy) backGroundButtonBlock  headButtonOnClick;

-(void)changeTableViewHeaderData:(NSArray *)banner Withscrolling_message:(NSArray *)message;


@end
