//
//  XZRedEnvelopeHeader.h
//  fmapp
//
//  Created by admin on 17/2/18.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XZRedEnvelopeModel;
@interface XZRedEnvelopeHeader : UIView

@property (nonatomic, copy) void(^blockRedEnvelope)(UIButton *);

@property (nonatomic, strong) XZRedEnvelopeModel *modelRedEnv;

// 用户没点击的时候不显示数量
- (void)setTitleWithModel:(XZRedEnvelopeModel *)modelRedTitle;
///** 设置数量 */
//- (void)setButtonUseCount:(NSInteger)useCount  notUseCount:(NSInteger)notUseCount isRedEnvelope:(BOOL)isRedEnvelope;
@end
