//
//  MakeABidWebViewController.h
//  fmapp
//
//  Created by runzhiqiu on 16/3/30.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMViewController.h"

@interface MakeABidWebViewController : FMViewController
-(id)initWithTitle:(NSString *)title AndWithShareUrl:(NSString *)shareUrl;
@property(nonatomic,strong)NSString *isTanchu;
// 设置右侧按钮
- (void)setNavRightButton:(NSString *)title;

/** 优商城跳转 */
@property (nonatomic, assign) BOOL isOptimalMall;

@end
