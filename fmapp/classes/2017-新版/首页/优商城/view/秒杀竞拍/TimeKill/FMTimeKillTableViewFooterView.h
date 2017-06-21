//
//  FMTimeKillTableViewFooterView.h
//  fmapp
//
//  Created by runzhiqiu on 16/8/10.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^sectionSectionHeaderButtonBlock)(NSInteger index);

@interface FMTimeKillTableViewFooterView : UIView

@property (nonatomic,copy) sectionSectionHeaderButtonBlock buttonBlock;
-(void)changeBottomTitle;

@end
