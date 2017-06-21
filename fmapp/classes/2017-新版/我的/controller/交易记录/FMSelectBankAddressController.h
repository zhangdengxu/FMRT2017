//
//  FMSelectBankAddressController.h
//  fmapp
//
//  Created by runzhiqiu on 16/6/13.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMViewController.h"
@class FMBankAddressModelEnd;

typedef void(^blockBankAddressItemOnClick)(FMBankAddressModelEnd *);

@interface FMSelectBankAddressController : FMViewController

@property (nonatomic,copy) blockBankAddressItemOnClick bankAddress;

@end
