//
//  FMRTRemSecView.h
//  fmapp
//
//  Created by apple on 16/8/6.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMRTRemSecView : UITableViewHeaderFooterView

@property (nonatomic, copy) void(^remBlcok)();
@property (nonatomic, copy) void(^gormBlcok)();

@end
