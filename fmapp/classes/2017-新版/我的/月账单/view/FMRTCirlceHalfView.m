//
//  FMRTCirlceHalfView.m
//  fmapp
//
//  Created by apple on 2017/2/17.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRTCirlceHalfView.h"

@interface FMRTCirlceHalfView()
{
    FMRTCircleView *circleView;
    id delegate;
}
@property (nonatomic,assign) CGFloat Radius;
@property (nonatomic,assign) CGFloat PIE_HEIGHT;
@end
@implementation FMRTCirlceHalfView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        if (KProjectScreenWidth==320&&KProjectScreenHeight == 480) {
            self.Radius = 60;
            self.PIE_HEIGHT = frame.size.height;
        }else if (KProjectScreenWidth == 320 && KProjectScreenHeight == 568){
            self.Radius = 60;
            self.PIE_HEIGHT = frame.size.height;
        }else if (KProjectScreenHeight == 667 && KProjectScreenWidth == 375){
            self.Radius = 65;
            self.PIE_HEIGHT = frame.size.height;
        }else if (KProjectScreenHeight == 736 && KProjectScreenWidth == 414){
            self.Radius = 70;
            self.PIE_HEIGHT = frame.size.height;
        }else{
            self.Radius = 70;
            self.PIE_HEIGHT = frame.size.height;
        }
    }
    return self;
}
-(void)loadDataArray:(NSArray *)dataArray withType:(MYHCircleManageViewType)type{
    [circleView removeFromSuperview];
    circleView = nil;
    circleView = [[FMRTCircleView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.PIE_HEIGHT) andWithDataArray:dataArray andWithCircleRadius:self.Radius type:type];
    circleView.backgroundColor = [UIColor clearColor];
    circleView.hasZheXian = self.hasZheXian;
    [self addSubview:circleView];
}

- (void)setHasZheXian:(NSInteger)hasZheXian{
    _hasZheXian = hasZheXian;
}

@end
