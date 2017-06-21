//
//  YYCouponCell.h
//  fmapp
//
//  Created by yushibo on 2016/12/15.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYCardPackageModel.h"

@interface YYCouponCell : UITableViewCell
- (void)sendDataWithmodel:(YYCardPackageModel *)model withBtnTag:(NSString *)tag;

@end
