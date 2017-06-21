//
//  YYChangeBankCardViewController.h
//  fmapp
//
//  Created by yushibo on 2017/5/15.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMViewController.h"
@class XZMyBankModel;
@interface YYChangeBankCardViewController : FMViewController

@property (nonatomic, strong) XZMyBankModel *modelMyBank;

@end


@interface FMChangeBankCardViewModel : NSObject


@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *personNumberCard;
@property (nonatomic,copy) NSString *phoneNumber;
@property (nonatomic,copy) NSString *bankCardNumber;
@property (nonatomic,copy) NSString *xinBankCardNumber;
/** 银行卡ID */
@property (nonatomic,copy) NSString *bankCardId;
/** 银行编号 */
@property (nonatomic, copy) NSString *BankCode;
/** 银行名称 */
@property (nonatomic, copy) NSString *BankName;
@end

