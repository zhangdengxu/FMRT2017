//
//  FMLinshiCellButton.h
//  fmapp
//
//  Created by runzhiqiu on 16/9/2.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    FMLinshiCellButtonTypeActivity,//秒杀中
    FMLinshiCellButtonTypeDownTime,//据开始
    FMLinshiCellButtonTypeEnd//已结束
    
} FMLinshiCellButtonType;

@interface FMLinshiCellButton : UIButton

@property (nonatomic, assign) FMLinshiCellButtonType cellType;

@property (nonatomic,copy) NSString *contentString;
@property (nonatomic,copy) NSString *timeString;

-(void)setUpData;

@end
