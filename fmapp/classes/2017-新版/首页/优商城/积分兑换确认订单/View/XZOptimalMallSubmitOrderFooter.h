//
//  XZOptimalMallSubmitOrderFooter.h
//  fmapp
//
//  Created by admin on 16/12/9.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XZConfirmOrderModel;
@interface XZOptimalMallSubmitOrderFooter : UIView
/** model */
@property (nonatomic, strong) XZConfirmOrderModel *confirmModel;
@property (nonatomic, copy) void(^blockDidClickButton)(UIButton *);
// 用户留言
@property (nonatomic, copy) void(^blockSendUserMsg)(NSString *);
@end
