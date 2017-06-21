//
//  FMTieBankResultView.h
//  fmapp
//
//  Created by runzhiqiu on 2017/6/1.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^tieBankResultViewButtonOnClickBlock)();


@interface FMTieBankResultView : UIView


+(instancetype)showFMTieBankResultViewWithStatus:(NSString *)status Success:(tieBankResultViewButtonOnClickBlock)block;


@end
