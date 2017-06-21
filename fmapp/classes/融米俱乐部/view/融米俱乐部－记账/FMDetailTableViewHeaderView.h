//
//  FMDetailTableViewHeaderView.h
//  fmapp
//
//  Created by runzhiqiu on 16/6/27.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    FMDetailTableViewHeaderViewButtonTypeDataTime,
    FMDetailTableViewHeaderViewButtonTypeDataTimeLeft,
    FMDetailTableViewHeaderViewButtonTypeDataTimeRight,
    FMDetailTableViewHeaderViewButtonTypeLeftBottom,
    FMDetailTableViewHeaderViewButtonTypeRightBottom
    
} FMDetailTableViewHeaderViewButtonType;

@class FMKeepAccountDetailHeaderModel;
typedef void(^FMDetailTableViewHeaderViewButtonOnClick)(FMDetailTableViewHeaderViewButtonType type);

@interface FMDetailTableViewHeaderView : UIView

@property (nonatomic,copy) FMDetailTableViewHeaderViewButtonOnClick buttonBlock;

@property (nonatomic, strong) FMKeepAccountDetailHeaderModel * headerModel;


@end
