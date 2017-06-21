//
//  FMAcountMainTableViewCell.h
//  fmapp
//
//  Created by apple on 16/6/22.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMAcountMainModel.h"

@interface FMAcountMainTableViewCell : UITableViewCell

- (void)sendDataWithModel:(FMAcountDetailModel *)model;

@end
