//
//  XZChooseTicketController.h
//  fmapp
//
//  Created by admin on 17/1/3.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMViewController.h"

@class XZChooseTicketModel;
@interface XZChooseTicketController : FMViewController
@property (nonatomic, copy) void(^blockChooseTicket)(XZChooseTicketModel *);
@property (nonatomic, strong) NSString *cpns_code;

@property (nonatomic, strong) NSString *sess_id;
@end
