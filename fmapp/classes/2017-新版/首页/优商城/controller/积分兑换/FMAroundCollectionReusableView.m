//
//  FMAroundCollectionReusableView.m
//  fmapp
//
//  Created by runzhiqiu on 2016/12/16.
//  Copyright © 2016年 yk. All rights reserved.
//
#define KFloatRadio (KProjectScreenWidth/ 375.0)

#import "FMAroundCollectionReusableView.h"


#import "SDCycleScrollView.h"

@interface FMAroundCollectionReusableView ()<SDCycleScrollViewDelegate>


@property (nonatomic, strong) SDCycleScrollView *imgTop;

@end



@implementation FMAroundCollectionReusableView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpOptimalMallView];
    }
    return self;
}




// 设置子视图
- (void)setUpOptimalMallView {
    __weak __typeof(&*self)weakSelf = self;
    self.imgTop = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 160 * KFloatRadio) delegate:self placeholderImage:[UIImage imageNamed:@"shop_loading_wait_04375"]];
    self.imgTop.autoScrollTimeInterval = 5.0;
    self.imgTop.hidesForSinglePage = YES;
    [self addSubview:self.imgTop];
    
    [self.imgTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.top.equalTo(weakSelf.mas_top);
        make.right.equalTo(weakSelf.mas_right);
        make.height.equalTo(160 * KFloatRadio);
    }];
    
        
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;
{
    
    if (self.cycleIndex) {
        self.cycleIndex(index);
    }
}


-(void)setSlidesArray:(NSArray *)slidesArray
{
    _slidesArray = slidesArray;
    
    
    if (_slidesArray) {
        self.imgTop.imageURLStringsGroup = _slidesArray;
    }
}




@end
