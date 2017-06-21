//
//  FMRTRegisterAppFootView.h
//  fmapp
//
//  Created by apple on 2017/5/11.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMRTRegisterAppFootView : UIView

@property (nonatomic, copy)void(^protocolBlcok)();
@property (nonatomic, copy)void(^sureBlcok)();
@property (nonatomic, copy)void(^labelBlcok)(NSInteger sender);

@property (nonatomic, assign)NSInteger sureType;

@end
