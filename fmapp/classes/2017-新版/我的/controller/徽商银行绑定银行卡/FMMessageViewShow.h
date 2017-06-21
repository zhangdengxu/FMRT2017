//
//  FMMessageViewShow.h
//  fmapp
//
//  Created by runzhiqiu on 2017/6/3.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^messageViewShowButtonOnClickBlock)();


@interface FMMessageViewShow : UIView


+(instancetype)showFMMessageViewShow:(NSMutableAttributedString *)muString WithBolok:(messageViewShowButtonOnClickBlock)block;

@end
