//
//  FMBankCardAndNumberTableViewCell.h
//  fmapp
//
//  Created by runzhiqiu on 2017/5/15.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMBankCardAndNumberModel;

@interface FMBankCardAndNumberTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic,copy) FMBankCardAndNumberModel * cardModel;


@end


@interface FMBankCardAndNumberModel : NSObject

@property (nonatomic,copy) NSString *leftTitleString;
@property (nonatomic,copy) NSString *rightTitleString;


@end
