//
//  YYMyBillModel.h
//  fmapp
//
//  Created by yushibo on 2017/3/7.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface Records : NSObject

/**  交易记录标识 */
@property (nonatomic, copy) NSString *Id;
/**  交易记录渠道（类型），范围参考：“交易渠道” */
@property (nonatomic, copy) NSString *Trench;
/**  资金交易的类型，范围参考：“交易类型” */
@property (nonatomic, copy) NSString *Type;
/**  资金交易的时间，格式：时间戳（精确到秒） */
@property (nonatomic, copy) NSString *Time;
/**  交易金额，保留2位小数 */
@property (nonatomic, assign) double Money;
/**  交易名称文本，前端可直接展示 */
@property (nonatomic, copy) NSString *Name;
/**  交易说明文本，前端可直接展示 */
@property (nonatomic, copy) NSString *Desc;
/**  投资项目编号，交易类型为回款时返回 */
@property (nonatomic, copy) NSString *ProjId;
/**  投资项目回款类型，交易类型为回款时返回，回款类型，分为本息回款和利息回款，范围参考：“项目回款类型” */
@property (nonatomic, copy) NSString *BackType;
/**  投资项目名称，交易类型为回款时返回 */
@property (nonatomic, assign) NSString *ProjName;

@end


@interface YYMyBillModel : NSObject <MJKeyValue>

/**  当前日期（年月），用于控制当月账单按钮，格式yyyy-MM */
//@property (nonatomic, copy) NSString *CurDate;
/**  月份数据 */
//@property (nonatomic, assign) BOOL isOpen;

@property (nonatomic, copy) NSArray *Records;
@property (nonatomic, copy) NSString *Month;

@end
