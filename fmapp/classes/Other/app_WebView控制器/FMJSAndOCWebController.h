//
//  FMJSAndOCWebController.h
//  fmapp
//
//  Created by runzhiqiu on 16/9/27.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMViewController.h"

@interface FMJSAndOCWebController : FMViewController
-(instancetype)initWithTitle:(NSString *)title AndWithShareUrl:(NSString *)shareUrl;

@property (nonatomic, assign) NSInteger isShowRightButton;


@end
