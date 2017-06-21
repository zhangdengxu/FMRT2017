//
//  FMShoppingListFootView.h
//  fmapp
//
//  Created by apple on 16/4/25.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClearPastBlock)(UIButton *sender);

@interface FMShoppingListFootView : UIView

@property (nonatomic, copy) ClearPastBlock block;

@end
