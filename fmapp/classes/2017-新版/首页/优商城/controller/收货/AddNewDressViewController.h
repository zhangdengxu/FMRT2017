//
//  AddNewDressViewController.h
//  fmapp
//
//  Created by 秦秦文龙 on 16/4/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMViewController.h"
@interface AddNewDressViewController : FMViewController

@property (nonatomic,assign) BOOL isNewDress;
@property (nonatomic,assign) BOOL isMoren;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *userPhoneNumber;
@property (nonatomic,strong)NSString *dress;
@property (nonatomic,strong)NSString *addr;
@property (nonatomic,strong)NSString *def_addr;
@property (nonatomic,strong)NSString *member_id;
@property (nonatomic,strong)NSString *addr_id;
@property (nonatomic,strong)NSString *zip;//邮编
@property (nonatomic,copy)void(^saveBlock)();
@end
