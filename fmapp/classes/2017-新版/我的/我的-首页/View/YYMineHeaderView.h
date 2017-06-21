//
//  YYMineHeaderView.h
//  fmapp
//
//  Created by yushibo on 2017/2/20.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMMineModel.h"
@interface YYMineHeaderView : UICollectionReusableView
/**  取现按钮 */
@property (nonatomic, copy) void(^quxianBlock)(UIButton *sender);
/**  充值按钮 */
@property (nonatomic, copy) void(^rechargeBlock)  (UIButton *sender);
/**  资产总额问号按钮 */
@property (nonatomic, copy) void(^indevertBlock)(UIButton *sender);

@property (nonatomic, copy) void(^goTestBlock)(UIButton *sender);

- (void)sendDataWithmodel:(FMMineModel *)model IsDone:(NSString *)isDone IsInvalid:(NSString *)isInvalid;

- (void)sendDataWithIsDone:(NSString *)isDone IsInvalid:(NSString *)isInvalid;

@end
