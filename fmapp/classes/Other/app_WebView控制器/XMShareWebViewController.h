//
//  XMShareWebViewController.h
//  fmapp
//
//  Created by runzhiqiu on 16/3/10.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMViewController.h"

@class FMBeautifulModel;

@interface XMShareWebViewController : FMViewController
@property (nonatomic, strong) UIImageView * umImage;
@property (nonatomic, strong) FMBeautifulModel * dataSource;
@property (nonatomic, assign) NSInteger laiyaun;

-(instancetype)initWithTitle:(NSString *)title AndWithShareUrl:(NSString *)shareUrl WithShareUrlWithNoUserInfo:(NSString *)shareUrlWithNoUserInfo withContent:(NSString *)content;

@end
