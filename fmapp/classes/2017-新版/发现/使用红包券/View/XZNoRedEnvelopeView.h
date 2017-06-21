//
//  XZNoRedEnvelopeView.h
//  fmapp
//
//  Created by admin on 17/2/20.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XZRedEnvelopeModel;
@interface XZNoRedEnvelopeView : UIView

/** 红包券还是加息券 */
@property (nonatomic, strong) XZRedEnvelopeModel *modelRedEnv;

@end
