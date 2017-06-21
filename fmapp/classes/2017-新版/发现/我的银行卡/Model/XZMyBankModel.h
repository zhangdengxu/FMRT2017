//
//  XZMyBankModel.h
//  fmapp
//
//  Created by admin on 2017/6/2.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZMyBankModel : NSObject
/** 银行卡ID */
@property (nonatomic, assign) int Id;
/** 银行卡号 */
@property (nonatomic, copy) NSString *No;
/** 银行编号 */
@property (nonatomic, copy) NSString *BankCode;
/** 银行名称 */
@property (nonatomic, copy) NSString *BankName;
/** 银行Logo的URL地址 */
@property (nonatomic, copy) NSString *BankLogo;

@end
