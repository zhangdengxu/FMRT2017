//
//  YSInterestRateCoupon.h
//  fmapp
//
//  Created by yushibo on 2016/9/24.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSInterestRateCoupon : UIView
/**
 *  加息券
 */
@property(nonatomic, strong)NSString *jiaxiText;

-(instancetype)initWithFrame:(CGRect)frame andWithJiaxiText:(NSString *)jiaxiText;
- (void)createContentView;

@end
