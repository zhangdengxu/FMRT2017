//
//  FMTimeKillShopDetailHeaderView.m
//  fmapp
//
//  Created by runzhiqiu on 16/8/10.
//  Copyright © 2016年 yk. All rights reserved.
//

#define KHeaderViewTextColor [HXColor colorWithHexString:@"#1e1e1e"]
#define KSDCycleImageViewHeigh 320
#define KMargionItem 8

#import "SDCycleScrollView.h"


#import "FMShopSpecModel.h"
#import "FMTimeKillShopDetailHeaderView.h"

@interface FMTimeKillShopDetailHeaderView ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView * cycleImage;
@property (nonatomic, strong) UILabel * shopTitle;
@property (nonatomic, strong) UILabel * moneyTitle;
@property (nonatomic, strong) UILabel * shangpinxiangqingLabel;
@property (nonatomic, strong) UIButton  * shopDetailButton;

@property (nonatomic, strong) UIView * lineView1;
@property (nonatomic, strong) UIView * lineView2;


@property (nonatomic, strong) UIActivityIndicatorView *testActivityIndicator;

@end

@implementation FMTimeKillShopDetailHeaderView

- (instancetype)init
{
    
    self = [super init];
    if (self){
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenWidth * 0.9375 + 40 + KDefauletCellItemLargeHeigh + KDefauletCellItemLargeHeigh);
        
        
        // 菊花转啊转
        UIActivityIndicatorView *testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        testActivityIndicator.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
        testActivityIndicator.color = [UIColor blackColor];
        [testActivityIndicator setHidesWhenStopped:YES];
        [self addSubview:testActivityIndicator];
        self.testActivityIndicator = testActivityIndicator;
        
        [self shangpinxiangqingLabel];
        [self lineView1];
        [self lineView2];
    }
    return self;
}


-(void)setShopImageUrl:(NSArray *)shopImageUrl
{
    _shopImageUrl = shopImageUrl;
    
    self.cycleImage.imageURLStringsGroup = shopImageUrl;
}

-(void)setShopDetailModel:(FMSelectShopInfoModel *)shopDetailModel
{
    _shopDetailModel = shopDetailModel;
    [self.testActivityIndicator stopAnimating];
    self.shopTitle.text = shopDetailModel.title;
    //设置商品名称；
    NSString * priceNew = [NSString stringWithFormat:@"%.2f",[shopDetailModel.price floatValue]];
    self.moneyTitle.text  = [NSString stringWithFormat:@"￥%@",priceNew];
    
}



-(SDCycleScrollView *)cycleImage
{
    if (!_cycleImage) {
        _cycleImage = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenWidth * 0.9375) delegate:self placeholderImage:[UIImage imageNamed:@"美读时光headerBack_02"]];
        _cycleImage.autoScrollTimeInterval = 5.0;
        _cycleImage.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        [self addSubview:_cycleImage];
    }
    return _cycleImage;
}


-(UILabel *)shopTitle
{
    if (!_shopTitle) {
        _shopTitle = [[UILabel alloc]init];
        _shopTitle.frame = CGRectMake(15, CGRectGetMaxY(self.cycleImage.frame) + 5, KProjectScreenWidth - 30, 35);
        _shopTitle.textColor = KHeaderViewTextColor;
        _shopTitle.numberOfLines = 2;
        if (KProjectScreenWidth != 320) {
            _shopTitle.font = [UIFont systemFontOfSize:15.0];
        }else
        {
            _shopTitle.font = [UIFont systemFontOfSize:15.0];
        }
        _shopTitle.backgroundColor = [UIColor whiteColor];
        [self addSubview:_shopTitle];
        
    }
    return _shopTitle;
}
-(UIView *)lineView1
{
    if (!_lineView1) {
        _lineView1 = [[UIView alloc]init];
        _lineView1.frame = CGRectMake(0, CGRectGetMinY(self.shangpinxiangqingLabel.frame)-0.5, KProjectScreenWidth, 0.5);
        _lineView1.backgroundColor = [UIColor colorWithRed:(231.0/255.0) green:(232.0/255.0) blue:(234.0/255.0) alpha:1];
        [self addSubview:_lineView1];
    }
    return _lineView1;
}
-(UIView *)lineView2
{
    if (!_lineView2) {
        _lineView2 = [[UIView alloc]init];
        _lineView2.frame = CGRectMake(0, CGRectGetMaxY(self.shangpinxiangqingLabel.frame)-0.5, KProjectScreenWidth, 0.5);
        _lineView2.backgroundColor = [UIColor colorWithRed:(231.0/255.0) green:(232.0/255.0) blue:(234.0/255.0) alpha:1];
        [self addSubview:_lineView2];
    }
    return _lineView2;
}

-(UILabel *)shangpinxiangqingLabel
{
    if (!_shangpinxiangqingLabel) {
        _shangpinxiangqingLabel = [[UILabel alloc]init];
        _shangpinxiangqingLabel.frame = CGRectMake(0, CGRectGetMaxY(self.moneyTitle.frame), KProjectScreenWidth, KDefauletCellItemLargeHeigh);
        _shangpinxiangqingLabel.textColor = [HXColor colorWithHexString:@"#003d90"];
        if (KProjectScreenWidth != 320) {
            _shangpinxiangqingLabel.font = [UIFont systemFontOfSize:20.0];
        }else
        {
            _shangpinxiangqingLabel.font = [UIFont systemFontOfSize:18.0];
        }
        _shangpinxiangqingLabel.textAlignment = NSTextAlignmentCenter;
        _shangpinxiangqingLabel.text = @"商品详情";
        _shangpinxiangqingLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:_shangpinxiangqingLabel];
        
    }
    return _shangpinxiangqingLabel;
}



-(UILabel *)moneyTitle
{
    if (!_moneyTitle) {
        _moneyTitle  = [[UILabel alloc]init];
        _moneyTitle.textColor = [HXColor colorWithHexString:@"#ff6633"];
        if (KProjectScreenWidth != 320) {
            _moneyTitle.font = [UIFont systemFontOfSize:22.0];
        }else
        {
            _moneyTitle.font = [UIFont systemFontOfSize:21.0];
        }
        _moneyTitle.frame = CGRectMake(12, CGRectGetMaxY(self.shopTitle.frame) , (KProjectScreenWidth - 25 - 150) , KDefauletCellItemLargeHeigh);
        [self addSubview:_moneyTitle];
    }
    return _moneyTitle;
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;
{
    if (self.itemBlock) {
        self.itemBlock(index);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
