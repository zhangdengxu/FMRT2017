//
//  WLRechageBankModel.h
//  fmapp
//
//  Created by 秦秦文龙 on 17/6/2.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLRechageBankModel : NSObject

/** 银行名 */
@property (nonatomic, copy) NSString *BankName;
/** 每笔限额：5万 */
@property (nonatomic, copy) NSString *CashAmt;
/** 每天限额：5万 */
@property (nonatomic, copy) NSString *CashAmtDay;
/** 银行名缩写*/
@property (nonatomic, copy) NSString *OpenBankId;
/** 银行logo地址 */
@property (nonatomic, copy) NSString *logo;


@end
