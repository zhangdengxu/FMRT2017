//
//  FMBankAddressHeaderView.h
//  fmapp
//
//  Created by runzhiqiu on 16/6/13.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMBankAddressModel;
typedef void(^blockBankAddressBtn)(FMBankAddressModel *);
@interface FMBankAddressHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) FMBankAddressModel * bankModel;
@property (nonatomic,copy) blockBankAddressBtn bankAddressBlock;
@end
