//
//  FMRTWellStoreSaledFooterView.h
//  fmapp
//
//  Created by apple on 2016/12/12.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

//售后处理状态 1 未操作 2 审核中(用户提交申请之后状态即为2) 3 接受申请（同意） 4 退款/退货完成 5 拒绝 6 已收货 7 已质检 8 补差价 9 已拒绝退款 10 用户已撤销

typedef enum : NSUInteger {
    SaleStatusIn = 2,
    SaleStatusAgree = 3,
    SaleStatusFinish = 4,
    SaleStatusDefy = 5,
    SaleStatusAlreadyDeny = 9,
    SaleStatusCancel = 10,
} SaleStatusType;


@interface FMRTWellStoreSaledFooterView : UIView

@property (nonatomic, copy) void(^changeBlock)();
@property (nonatomic, copy) void(^cancelBlock)();
@property (nonatomic, copy) void(^telBlock)();
@property (nonatomic, copy) void(^afterSaleBlock)();
@property (nonatomic, copy) void(^tuihuoBlock)();

@property (nonatomic, assign)SaleStatusType saleType;

@end
