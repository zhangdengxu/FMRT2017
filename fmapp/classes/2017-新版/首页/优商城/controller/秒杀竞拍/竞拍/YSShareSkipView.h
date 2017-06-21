//
//  YSShareSkipView.h
//  fmapp
//
//  Created by yushibo on 16/8/15.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^blockBtn)(UIButton *);

@interface YSShareSkipView : UIView
@property (nonatomic, strong) NSString *money;
@property (nonatomic, copy) blockBtn blockBtn;


@end
