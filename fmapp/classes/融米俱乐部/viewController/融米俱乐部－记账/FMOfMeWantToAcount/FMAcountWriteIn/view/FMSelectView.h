//
//  FMSelectView.h
//  fmapp
//
//  Created by apple on 16/6/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMSelectView : UIView

@property (nonatomic, strong) UITextField *nameTextField;

@property (nonatomic, strong) UIButton *timeButton;

@property (nonatomic, copy) void(^selctBlock)();

- (void)sendTypeWithString:(NSString *)type;

@end
