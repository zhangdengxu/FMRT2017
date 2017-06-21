//
//  WLNewWebViewController.h
//  fmapp
//
//  Created by 秦秦文龙 on 17/3/13.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMViewController.h"

@interface WLNewWebViewController : FMViewController

-(id)initWithTitle:(NSString *)title AndWithShareUrl:(NSString *)shareUrl;
@property (nonatomic, strong) NSString *JumpWay;


@end
