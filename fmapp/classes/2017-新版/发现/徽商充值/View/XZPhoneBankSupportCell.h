//
//  XZPhoneBankSupportCell.h
//  fmapp
//
//  Created by admin on 2017/5/17.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XZPhoneBankSupportModel;
@interface XZPhoneBankSupportCell : UITableViewCell

@property (nonatomic, copy) void(^blockBankButton)(UIButton *);

@property (nonatomic, strong) XZPhoneBankSupportModel *modelBank;
@end
