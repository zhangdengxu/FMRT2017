//
//  FMBankAddressModel.h
//  fmapp
//
//  Created by runzhiqiu on 16/6/13.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMBankAddressModel : NSObject

@property (nonatomic,copy) NSString *region_id;
@property (nonatomic,copy) NSString *region_name;
@property (nonatomic, strong) NSArray * subs;


@property (nonatomic, assign) BOOL isShowDetail;
@property (nonatomic, assign) NSInteger section;
@end



@interface FMBankAddressModelContent : NSObject

@property (nonatomic,copy) NSString *region_id;
@property (nonatomic,copy) NSString *region_name;

@end

@interface FMBankAddressModelEnd : NSObject

@property (nonatomic,copy) NSString *region_id;
@property (nonatomic,copy) NSString *region_name;

@end

