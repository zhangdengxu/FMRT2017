//
//  ShareViewController.h
//  fmapp
//
//  Created by apple on 15/3/13.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "FMViewController.h"

@interface ShareViewController : FMViewController

-(id)initWithTitle:(NSString *)title AndWithShareUrl:(NSString *)shareUrl;
- (void)setNavRightButton:(NSString *)title;
@property (nonatomic, copy) NSString *JumpWay;

@property (nonatomic, copy) void(^refreshBlock)();


@end
