//
//  LoginController.h
//  fmapp
//
//  Created by 张利广 on 14-5-14.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#import "FMViewController.h"


typedef void(^LoginSecceedBlock)();
@interface LoginController : FMViewController<UITextFieldDelegate>

@property (nonatomic, copy) LoginSecceedBlock successBlock;

@property (nonatomic, copy)void(^homeBack)();

/** 返回到登录界面 */
@property (nonatomic, assign) BOOL isGoBackLogin;
@property (nonatomic, assign) BOOL isComFromFirstPage;
@property (nonatomic, assign) BOOL isComFromLoginOut;


@property (nonatomic, assign) NSInteger goToDuobaoMiaosha;

@end
