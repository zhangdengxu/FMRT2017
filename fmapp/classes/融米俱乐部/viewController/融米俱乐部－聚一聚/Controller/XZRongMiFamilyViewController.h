//
//  XZRongMiFamilyViewController.h
//  fmapp
//
//  Created by admin on 16/6/28.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMViewController.h"

@interface XZRongMiFamilyViewController : FMViewController
/**
 *  pid
 */
@property (nonatomic, strong) NSString *pid;

/** 标题  */
@property (nonatomic, strong) NSString *party_theme;

/** 1不能修改，0可以修改 */
@property (nonatomic, strong) NSString *state;

@end
