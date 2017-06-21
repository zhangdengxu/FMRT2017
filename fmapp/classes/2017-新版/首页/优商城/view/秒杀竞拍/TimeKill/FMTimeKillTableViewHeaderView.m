//
//  FMTimeKillTableViewHeaderView.m
//  fmapp
//
//  Created by runzhiqiu on 16/8/5.
//  Copyright © 2016年 yk. All rights reserved.
//
#define KdefaultHeaderViewHeigh 200
#import "FMTimeKillTableViewHeaderView.h"
#import "SDCycleScrollView.h"
@interface FMTimeKillTableViewHeaderView ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView * backageGroundImage;
@property (nonatomic, strong) UIImageView * trumpetView;
@property (nonatomic, strong) SDCycleScrollView   * newsCycleScrollView;

@property (nonatomic, assign) CGFloat viewRadio;
@property (nonatomic, strong) UIView  * lineView;

@end

@implementation FMTimeKillTableViewHeaderView


-(CGFloat)viewRadio
{
    if (KProjectScreenWidth == 320) {
        return 320 / 375.0;
        
    }else if (KProjectScreenWidth == 375)
    {
        return 1;
    }else
    {
        return 414 / 375.0;
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, KProjectScreenWidth, KdefaultHeaderViewHeigh * self.viewRadio + 0.5) ;
        self.backgroundColor = [UIColor whiteColor];
        //[UIColor colorWithRed:(222/255.0) green:(230/255.0) blue:(235 / 255.0) alpha:1]
        
        [self createImageHeaderAndScrollView];
        
    }
    return self;
}
-(UIView *)lineView
{
    if (!_lineView) {
        CGFloat allHeigh = KdefaultHeaderViewHeigh * self.viewRadio;
        _lineView = [[UIView alloc]init];
        _lineView.frame = CGRectMake(0, allHeigh - 0.5, KProjectScreenWidth, 0.5);
        _lineView.backgroundColor = [UIColor colorWithRed:(222/255.0) green:(230/255.0) blue:(235 / 255.0) alpha:1];
        [self addSubview:_lineView];
    }
    return _lineView;
}
-(UIImageView *)trumpetView
{
    if (!_trumpetView) {
        CGFloat allHeigh = KdefaultHeaderViewHeigh * self.viewRadio;

        _trumpetView = [[UIImageView alloc]init];
        _trumpetView.frame = CGRectMake(20, allHeigh - 30 + 7, 16, 16);
        [_trumpetView setImage:[UIImage imageNamed:@"消息通知-喇叭_05"]];
        [self addSubview:_trumpetView];
    }
    return _trumpetView;
}
-(SDCycleScrollView *)newsCycleScrollView
{
    if (!_newsCycleScrollView) {
        CGFloat allHeigh = KdefaultHeaderViewHeigh * self.viewRadio;
        CGFloat labelW = KProjectScreenWidth-55;
        CGFloat labelH = 30;
        CGFloat labelX = 35;
        
        _newsCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(labelX,allHeigh - 30, labelW, labelH) delegate:nil placeholderImage:nil];
        _newsCycleScrollView.scrollDirection = UICollectionViewScrollDirectionVertical;
        _newsCycleScrollView.onlyDisplayText = YES;
        _newsCycleScrollView.backgroundColor = [UIColor whiteColor];
        _newsCycleScrollView.titleLabelBackgroundColor = [UIColor whiteColor];
        _newsCycleScrollView.titleLabelTextColor = KContentTextColor;
        _newsCycleScrollView.titleLabelTextFont = [UIFont systemFontOfSize:12];
        _newsCycleScrollView.autoScrollTimeInterval = 4.0;
        [self addSubview:_newsCycleScrollView];
        

    }
    return _newsCycleScrollView;
}

-(void)changeTableViewHeaderData:(NSArray *)banner Withscrolling_message:(NSArray *)message;
{
    self.newsCycleScrollView.titlesGroup =message;
    self.backageGroundImage.imageURLStringsGroup = banner;
}


-(SDCycleScrollView *)backageGroundImage
{
    if (!_backageGroundImage) {
        
        CGFloat allHeigh = KdefaultHeaderViewHeigh * self.viewRadio;

        
        _backageGroundImage = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KProjectScreenWidth, allHeigh - 30) delegate:self placeholderImage:[UIImage imageNamed:@"shop_loading_wait_04375"]];
        _backageGroundImage.autoScrollTimeInterval = 5.0;
        _backageGroundImage.hidesForSinglePage = YES;
        [self addSubview:_backageGroundImage];
        
        
        
    }
    return _backageGroundImage;
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;
{
    if (self.headButtonOnClick) {
        self.headButtonOnClick(index);
    }
}


- (void)createImageHeaderAndScrollView {
    
    [self backageGroundImage];
    [self newsCycleScrollView];
    [self trumpetView];
    [self lineView];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
