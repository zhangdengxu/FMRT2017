//
//  SelectDressViewController.h
//  fmapp
//
//  Created by 秦秦文龙 on 16/4/24.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMViewController.h"
@class XZShoppingOrderAddressModel;

typedef void(^blockAdressBtn)(XZShoppingOrderAddressModel *model);
@interface SelectDressViewController : FMViewController

@property (nonatomic, copy) blockAdressBtn  blockAgainBtn;
@property (nonatomic,assign)BOOL isSelectDress;
@property (nonatomic,copy)NSString *naviTitleName;
// 省市区id
@property (nonatomic, copy) NSString *addr_id_address;
-(void)getDataFromNetWork;

@end
