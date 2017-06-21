//
//  FMRTAucFootView.h
//  fmapp
//
//  Created by apple on 16/8/7.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMRTAucFootView : UIView

@property (nonatomic, copy) void(^moreBlock)();

@property (nonatomic, copy) NSString *title;

@end
