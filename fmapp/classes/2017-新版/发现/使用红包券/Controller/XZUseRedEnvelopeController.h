//
//  XZUseRedEnvelopeController.h
//  fmapp
//
//  Created by admin on 17/2/18.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMViewController.h"

@class XZRedEnvelopeModel;
@interface XZUseRedEnvelopeController : FMViewController

/** 是红包券 */
@property (nonatomic, assign) BOOL isRedEnvelopeView;

/** 用户投标金额 */
@property (nonatomic, strong) NSString *useBidAmt;

/** 直投项目编号（预留） */
@property (nonatomic, strong) NSString *ProjId;

// 往立即投资传值
@property (nonatomic, copy) void(^blockSendModel)(XZRedEnvelopeModel *);

/** 上一次选中的model */
@property (nonatomic, strong) XZRedEnvelopeModel *modelSelected;

/** 最高加息数:最高加息 */
@property (nonatomic, strong) NSString *lilvyou;

///** 是否显示加息:xianyou 1显示  0不显示 */
//@property (nonatomic, copy) NSNumber *xianyou;

@end
