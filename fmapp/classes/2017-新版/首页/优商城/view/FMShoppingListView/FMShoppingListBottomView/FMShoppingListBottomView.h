//
//  FMShoppingListBottomView.h
//  fmapp
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^buttonBlcok)(UIButton *sender);

@interface FMShoppingListBottomView : UIView

@property (nonatomic, copy) buttonBlcok block;
@property (nonatomic, copy) NSString    *totalPrice;

@property (nonatomic, strong) UILabel *totalMoneyLabel;
@property (nonatomic, strong) UILabel *freightMoneyLabel;
//@property (nonatomic, strong) UIButton *allSelectButton;


- (void)sendeDataWith:(NSString *)str withNumber:(CGFloat)number;

@end
