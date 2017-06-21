//
//  XZSuccessFailureView.h
//  fmapp
//
//  Created by admin on 16/10/27.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XZSuccessFailureModel;
@interface XZSuccessFailureView : UIView
@property (nonatomic, copy) void(^blockLookUp)(UIButton *);
/** 提示语 */
//@property (nonatomic, strong) NSString *textProfmpt;
/** 成功/失败 */
@property (nonatomic, assign) BOOL isSuccessful;
/** model */
@property (nonatomic, strong) XZSuccessFailureModel *modelSF;
@end
