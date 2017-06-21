//
//  FMRTRegisterAppCell.h
//  fmapp
//
//  Created by apple on 2017/5/11.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMRTRegisterAppCell : UITableViewCell

@property (nonatomic, strong) UITextField *leftTextfield;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, copy)void(^getCodeBlcok)();
@property (nonatomic, strong) UIButton *getCodeBtn;

@end
