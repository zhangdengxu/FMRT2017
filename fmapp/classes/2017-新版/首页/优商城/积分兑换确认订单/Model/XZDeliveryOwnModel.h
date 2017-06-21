//
//  XZDeliveryOwnModel.h
//  fmapp
//
//  Created by admin on 16/12/22.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZDeliveryOwnModel : NSObject

/** 地区id */
@property (nonatomic, copy) NSString *area_id;
/** 地址 */
@property (nonatomic, copy) NSString *address;
/** 联系方式 */
@property (nonatomic, copy) NSString *contact;
/** 自提或者包邮 */
@property (nonatomic, copy) NSString *deliveryWay;


@end
