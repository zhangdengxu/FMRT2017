//
//  FMTieBankCardViewController.h
//  fmapp
//
//  Created by runzhiqiu on 2017/5/10.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMViewController.h"

typedef void(^tieBankRetControllerButtonOnClickBlock)();



@interface FMTieBankCardViewController : FMViewController

/**
 0,代表正常返回
 1,代表由注册进入，需要做特殊处理（返回我的）；
 */
@property (nonatomic, assign) NSInteger viewType;
@property (nonatomic,copy) tieBankRetControllerButtonOnClickBlock retBlock;


@end


@interface FMTieBankCardViewModel : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *personNumberCard;
@property (nonatomic,copy) NSString *phoneNumber;
@property (nonatomic,copy) NSString *bankCardNumber;


@end


@interface FMCreateOrderModel : NSObject

@property (nonatomic,copy) NSString *ret_code;
@property (nonatomic,copy) NSString *ret_msg;
@property (nonatomic,copy) NSString *sign_type;
@property (nonatomic,copy) NSString *sign;

@end

