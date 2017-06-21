//
//  FMFavoriteBottomView.h
//  fmapp
//
//  Created by apple on 16/5/6.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMFavoriteBottomView : UIView

@property (nonatomic, strong)UIButton *allSelectButton;

@property (nonatomic,copy)void(^allSelectBlcok)(UIButton *sender);
@property (nonatomic,copy)void(^shareBlcok)(UIButton *sender);
@property (nonatomic,copy)void(^deleteBlcok)(UIButton *sender);

@end
