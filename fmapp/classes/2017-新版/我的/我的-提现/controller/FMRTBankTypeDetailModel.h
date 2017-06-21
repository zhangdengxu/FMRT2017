//
//  FMRTBankTypeDetailModel.h
//  fmapp
//
//  Created by apple on 2017/6/2.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMRTBankTypeDetailModel : NSObject

/*
 prcptcd : 102451012524,
	brabank_name : 中国工商银行股份有限公司济南段店支行
 */

@property (nonatomic, copy)NSString *prcptcd;
@property (nonatomic, copy)NSString *brabank_name;

@end
