//
//  FMLendView.h
//  fmapp
//
//  Created by apple on 16/6/27.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMLendView : UIView

@property (nonatomic, copy) void(^lendOutBlock)(NSString *lendOut);
@property (nonatomic, copy) void(^lendOInBlock)(NSString *lendIn);

@end
