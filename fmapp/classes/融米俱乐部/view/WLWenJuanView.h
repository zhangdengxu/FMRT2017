//
//  WLWenJuanView.h
//  fmapp
//
//  Created by 秦秦文龙 on 16/9/29.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLWenJuanView : UIView

@property (nonatomic, weak) UIImageView * backgroundView;

@property (nonatomic, copy) void(^blockWenJuanBtn)();

-(void)hiddenSignView;
- (instancetype)init;

@end
