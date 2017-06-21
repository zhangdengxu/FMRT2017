//
//  XZChooseTicketFooter.h
//  fmapp
//
//  Created by admin on 17/1/3.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XZChooseTicketModel;
@interface XZChooseTicketFooter : UIView
@property (nonatomic, strong) XZChooseTicketModel *modelChoose;
@property (nonatomic, copy) void(^blockUsedAndOverdue)();
@end
