//
//  FMCalenderHeaderView.h
//  fmapp
//
//  Created by runzhiqiu on 2017/2/27.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^calenderHeaderViewButtonOnClickBlock)(NSInteger index);


@interface FMCalenderHeaderView : UIView

@property (nonatomic,copy) calenderHeaderViewButtonOnClickBlock buttonBlock;
@property (nonatomic,copy) NSString *currentString;

@end
