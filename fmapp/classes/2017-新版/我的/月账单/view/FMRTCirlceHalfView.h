//
//  FMRTCirlceHalfView.h
//  fmapp
//
//  Created by apple on 2017/2/17.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMRTCircleView.h"

@interface FMRTCirlceHalfView : UIView

-(instancetype)initWithFrame:(CGRect)frame;
-(void)loadDataArray:(NSArray *)dataArray withType:(MYHCircleManageViewType)type;

@property (nonatomic, assign)NSInteger hasZheXian;

@end
