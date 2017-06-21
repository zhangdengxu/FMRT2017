//
//  FMCanaelOrderShowView.h
//  fmapp
//
//  Created by runzhiqiu on 16/5/21.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

// 点击确定按钮
typedef void(^blockSureBtn)(UIButton * button);
@interface FMCanaelOrderShowView : UIView

@property (nonatomic, copy) blockSureBtn blockSureBtn;

- (instancetype)initWithCancelDataArr:(NSArray *)cannelArray;

-(void)showSelfView;

@end
