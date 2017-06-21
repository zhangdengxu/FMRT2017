//
//  YSSpikeParticipationRecordModel.h
//  fmapp
//
//  Created by yushibo on 16/8/11.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSSpikeParticipationRecordModel : NSObject
/**  商品名称 */
@property (nonatomic, strong) NSString *goods_name;
/**  商品图片（缩略图）URL地址 */
@property (nonatomic, strong) NSString *goods_img_url;
/**  成交时间 */
@property (nonatomic, strong) NSString *trans_time;
/**  交易金额 */
@property (nonatomic, strong) NSString *trans_price;
/**  商品原价 */
@property (nonatomic, strong) NSString *goods_price;
/**  物流单号 */
@property (nonatomic, strong) NSString *tracking_num;
/**  物流公司 */
@property (nonatomic, strong) NSString *express_company;

-(instancetype)initWithDict:(NSDictionary *)dict;
@end
