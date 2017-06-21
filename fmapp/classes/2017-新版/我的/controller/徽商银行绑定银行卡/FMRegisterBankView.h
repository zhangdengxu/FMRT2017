//
//  FMRegisterBankView.h
//  fmapp
//
//  Created by runzhiqiu on 2017/5/11.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMRegisterBankView : UIView


+(instancetype)getRegisterBankViewWithDataSource:(NSArray *)dataSource;


@end


@interface RegisterBankViewModel : NSObject
@property (nonatomic,copy) NSString *cardNO;
@property (nonatomic,copy) NSString *bankName;
@property (nonatomic,copy) NSString *cashAmt;


@end
