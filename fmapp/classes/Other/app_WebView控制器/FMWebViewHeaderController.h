//
//  FMWebViewHeaderController.h
//  fmapp
//
//  Created by runzhiqiu on 16/9/9.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMViewController.h"
@class FMIndexHeaderModel;
@interface FMWebViewHeaderController : FMViewController


@property (nonatomic, assign) NSInteger statusInt;

-(id)initWithTitle:(NSString *)title AndWithShareUrl:(NSString *)shareUrl WithModel:(FMIndexHeaderModel *)headerModel;

@end
