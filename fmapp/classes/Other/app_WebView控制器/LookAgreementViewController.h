//
//  LookAgreementViewController.h
//  fmapp
//
//  Created by runzhiqiu on 15/12/30.
//  Copyright © 2015年 yk. All rights reserved.
//

#import "FMViewController.h"

@interface LookAgreementViewController : FMViewController

@property (nonatomic,copy) NSString *shareURL;
@property (nonatomic,copy) NSString *navTitle;

/** 返回到登录界面 */
@property (nonatomic, assign) BOOL isGoBackLogin;
@end
