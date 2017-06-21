//
//  YYUsedBidModel.h
//  fmapp
//
//  Created by yushibo on 2017/3/12.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYUsedBidModel : NSObject
/**  标题 */
@property (nonatomic, copy) NSString *title;
/**  利率 */
@property (nonatomic, copy) NSString *lilv;
/**  开始时间 */
@property (nonatomic, copy) NSString *start_time;
/**  期限 */
@property (nonatomic, copy) NSString *qixian;
/**  金额 */
@property (nonatomic, copy) NSString *jiner;
/**  项目标id */
@property (nonatomic, copy) NSString *jie_id;
/**  融资方式 */
@property (nonatomic, copy) NSString *rongzifangshi;
/**  项目标状态 */
@property (nonatomic, copy) NSString *zhuangtai;
/**  项目标开始 */
@property (nonatomic, copy) NSString *kaishicha;
/**  加息 */
@property (nonatomic, copy) NSString *jiaxi;

@end
