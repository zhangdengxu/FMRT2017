//
//  WLAllBodyShopHeaderView.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/10/14.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "WLAllBodyShopHeaderView.h"
#define KdefaultHeaderViewHeigh 200
#import "SDCycleScrollView.h"
@interface WLAllBodyShopHeaderView ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView * backageGroundImage;
@property (nonatomic, strong) UIImageView * trumpetView;
@property (nonatomic, strong) SDCycleScrollView   * newsCycleScrollView;

@property (nonatomic, assign) CGFloat viewRadio;
@property (nonatomic, strong) UIView  * lineView;

@end

@implementation WLAllBodyShopHeaderView

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
        [self createMoreNewsButton];
    }
    return self;
}

/**
 *创建消息 更多按钮
 */
-(void)createMoreNewsButton{

    UILabel *moreLabel = [[UILabel alloc]init];
    [moreLabel setText:@"更多"];
    [moreLabel setTextColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.6]];
    [moreLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [self addSubview:moreLabel];
    [moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-25);
        make.top.equalTo(self.mas_bottom).offset(-30);
        make.height.equalTo(30);
    }];
    UIImageView *arrowImagV = [[UIImageView alloc]init];
    [arrowImagV setImage:[UIImage imageNamed:@"箭头_103"]];
    [self addSubview:arrowImagV];
    [arrowImagV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moreLabel.mas_right).offset(3);
        make.top.equalTo(moreLabel.mas_top).offset(10.5);
        make.width.equalTo(5);
        make.height.equalTo(9);
    }];
    UIButton *chooseMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseMoreButton addTarget:self action:@selector(chosseAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:chooseMoreButton];
    [chooseMoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moreLabel.mas_left);
        make.top.equalTo(moreLabel.mas_top);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(30);
    }];

}
/**
 * 更多
 */
-(void)chosseAction:(UIButton *)seder{

    if (self.moreBlock) {
        self.moreBlock();
    }
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
        _trumpetView.frame = CGRectMake(20, allHeigh - 30 + 9, 12, 12);
        [_trumpetView setImage:[UIImage imageNamed:@"公告-1"]];
        [self addSubview:_trumpetView];
    }
    return _trumpetView;
}
-(SDCycleScrollView *)newsCycleScrollView
{
    if (!_newsCycleScrollView) {
        CGFloat allHeigh = KdefaultHeaderViewHeigh * self.viewRadio;
        CGFloat labelW = KProjectScreenWidth-105;
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
/**
 * 赋值方法
 */
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


@end
