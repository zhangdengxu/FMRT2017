//
//  XZShoppingOrderAddressModel.h
//  fmapp
//
//  Created by apple on 16/5/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZShoppingOrderAddressModel : NSObject

/**
 addr = "Dough slashedsdfjlsdfjlsd";
 "addr_id" = 1958;
 area = "mainland:\U53f0\U6e7e/\U5f70\U5316\U53bf/:3266";
 day = "\U4efb\U610f\U65e5\U671f";
 "def_addr" = 0;
 firstname = "<null>";
 lastname = "<null>";
 "member_id" = 2325;
 mobile = 18764083738;
 name = Qinwenlong;
 tel = "";
 time = "\U4efb\U610f\U65f6\U95f4\U6bb5";
 zip = "";
 */

@property (nonatomic, copy) NSString *addr;//(具体详细地址)
@property (nonatomic, copy) NSString *area;//文字地址（省市区详细地址）
@property (nonatomic, copy) NSString *day;
@property (nonatomic, copy) NSString *addr_id;//省市区id
@property (nonatomic, copy) NSString *area_id;//省市区id

/**
 *  1-默认； 0-非默认地址
 */
@property (nonatomic, assign) NSInteger def_addr;
@property (nonatomic, copy) NSString *member_id;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *zip;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *firstname;
@property (nonatomic, copy) NSString *lastname;



//后来添加

//@property (nonatomic, assign) NSInteger is_fastbuy;
//@property (nonatomic,copy) NSString *sess_id;
@property (nonatomic, copy) NSString *product_ids;
@property (nonatomic, copy) NSString *goodsnum;

// 确认订单地址回调
//@property (nonatomic, assign) BOOL isConfirmOrder;

@end
