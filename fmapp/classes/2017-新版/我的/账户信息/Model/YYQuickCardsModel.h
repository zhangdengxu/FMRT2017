//
//  YYQuickCardsModel.h
//  fmapp
//
//  Created by yushibo on 2017/3/14.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYQuickCardsModel : NSObject

/**  
 * 银行卡ID 
 */
@property (nonatomic, assign) int Id;
/**  
 * 银行卡号，只显示后四位 
 */
@property (nonatomic, copy) NSString *No;
/**  
 * 银行编号 
 */
@property (nonatomic, copy) NSString *BankCode;
/**  
 * 银行名称
 */
@property (nonatomic, copy) NSString *BankName;
/**  
 * 银行Logo的URL地址 
 */
@property (nonatomic, copy) NSString *BankLogo;
/**
 * 是否是默认银行卡  0：否（不是默认） 1：是（是默认）
 */
@property (nonatomic, assign) int Default;
/**
 * 取现还是充值标记
 */
@property (nonatomic, copy) NSString *bankTag;
@end
