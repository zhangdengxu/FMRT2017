//
//  FMAcountMainHeaderView.h
//  fmapp
//
//  Created by apple on 16/6/22.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMAcountMainModel.h"

@interface FMAcountMainHeaderView : UIView

@property (nonatomic, copy) void(^writeBlcok)();

- (void)sendDataWithModel:(FMAcountMainModel *)model;

@end
