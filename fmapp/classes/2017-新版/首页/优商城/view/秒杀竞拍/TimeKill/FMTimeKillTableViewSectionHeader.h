//
//  FMTimeKillTableViewSectionHeader.h
//  fmapp
//
//  Created by runzhiqiu on 16/8/8.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^timeKillTableViewHeaderButtonBlock)(NSInteger index);

@interface FMTimeKillTableViewSectionHeader : UITableViewHeaderFooterView


@property (nonatomic, strong) NSArray * titleArray;

@property (nonatomic,copy) timeKillTableViewHeaderButtonBlock buttonBlock;

-(void)contTitleArray;

@end
