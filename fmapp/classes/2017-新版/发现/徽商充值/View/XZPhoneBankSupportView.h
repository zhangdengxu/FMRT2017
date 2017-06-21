//
//  XZPhoneBankSupportView.h
//  fmapp
//
//  Created by admin on 2017/5/17.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZPhoneBankSupportView : UIView

@property (nonatomic, copy) void(^blockClosed)();

@property (nonatomic, strong) NSMutableArray *arrBank;
@end
