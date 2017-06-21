//
//  FMRTAddCardToView.h
//  fmapp
//
//  Created by apple on 2017/5/12.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMRTAddCardToView : UIView

+(instancetype)sharedCardView;

@property (nonatomic, copy)void(^addCardBlock)();
@property (nonatomic, copy)void(^closeCardBlock)();


+(void)showWithAddBtn:(void (^)())clickBlcok;

+(void)showWithAddBtn:(void (^)())clickBlcok hidView:(void (^)())closeBlcok;

@end
