//
//  FMShoppingListShareView.h
//  fmapp
//
//  Created by apple on 16/4/25.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ButtonBlock)(UIButton *sender);

@interface FMShoppingListShareView : UIView

@property (nonatomic, copy)ButtonBlock block;

@end
