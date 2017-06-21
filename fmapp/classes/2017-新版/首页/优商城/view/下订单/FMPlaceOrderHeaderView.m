//
//  FMPlaceOrderHeaderView.m
//  fmapp
//
//  Created by runzhiqiu on 16/4/24.
//  Copyright © 2016年 yk. All rights reserved.
//
//https://www.rongtuojinrong.com/Public/app/mall/1.png
//https://www.rongtuojinrong.com/Public/app/mall/2.png

#define KHeaderViewTextColor [HXColor colorWithHexString:@"#1e1e1e"]
#define KSDCycleImageViewHeigh 320
#define KMargionItem 8

#import "FMPlaceOrderHeaderView.h"
#import "SDCycleScrollView.h"

#import "FMShopSpecModel.h"


@interface FMPlaceOrderHeaderView ()<SDCycleScrollViewDelegate,UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView * scrollView;

@property (nonatomic, strong) SDCycleScrollView * cycleImage;
@property (nonatomic, strong) UILabel * shopTitle;
@property (nonatomic, strong) UILabel * moneyTitle;
@property (nonatomic, strong) UILabel * oldPrice;
@property (nonatomic, strong) UILabel * activityLabel;
@property (nonatomic, strong) UILabel * scoreLabel;
@property (nonatomic, strong) UILabel * funcSelectTitle;
@property (nonatomic, strong) UILabel * activityTitle;
@property (nonatomic, strong) UIView * functionView;
@property (nonatomic, strong) UIView * activityView;
@property (nonatomic, strong) UIView * titleBackageView;
@property (nonatomic, strong) UIActivityIndicatorView *testActivityIndicator;


@property (nonatomic, strong) UIButton * selectButton;
@property (nonatomic, strong) UIButton * checkShopPriceDetail;
@property (nonatomic, strong) UIImageView * funcSelectImage;
@end


@implementation FMPlaceOrderHeaderView

- (instancetype)init
{
    
    self = [super init];
    if (self){
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithRed:(231.0/255.0) green:(232.0/255.0) blue:(234.0/255.0) alpha:1];
        self.frame = CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 49 - 20);

        
        // 菊花转啊转
        UIActivityIndicatorView *testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        testActivityIndicator.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
        testActivityIndicator.color = [UIColor blackColor];
        [testActivityIndicator setHidesWhenStopped:YES];
        [self addSubview:testActivityIndicator];
        self.testActivityIndicator = testActivityIndicator;
        
        
    }
    return self;
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

-(void)shopTitleSetString:(NSString *)title
{
    CGSize sizeTitle = [title getStringCGSizeWithMaxSize:CGSizeMake(KProjectScreenWidth - 25, MAXFLOAT) WithFont:self.shopTitle.font];
    self.shopTitle.frame = CGRectMake(12, CGRectGetMaxY(self.cycleImage.frame) + KMargionItem, KProjectScreenWidth - 25, sizeTitle.height + KMargionItem );
    self.shopTitle.text = title;
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

-(UILabel *)oldPrice
{
    if (!_oldPrice) {
        _oldPrice = [[UILabel alloc]init];
//        _oldPrice.textColor = [HXColor colorWithHexString:@"#aaa"];
        if (KProjectScreenWidth != 320) {
            _oldPrice.font = [UIFont systemFontOfSize:12.0];
        }else
        {
            _oldPrice.font = [UIFont systemFontOfSize:11.0];
        }
        [self addSubview:_oldPrice];
        //_oldPrice.frame = CGRectMake(12, CGRectGetMaxY(self.moneyTitle.frame) , 120, KDefauletCellItemLittleHeigh);
        _oldPrice.frame = CGRectMake(CGRectGetMaxX(self.moneyTitle.frame) + 15, CGRectGetMaxY(self.moneyTitle.frame) -  KDefauletCellItemLittleHeigh, 120, KDefauletCellItemLittleHeigh);
    }
    return _oldPrice;
}

-(UILabel *)activityLabel
{
    if (!_activityLabel) {
        _activityLabel = [[UILabel alloc]init];
        _activityLabel.textColor = [HXColor colorWithHexString:@"#ff6633"];
        _activityLabel.numberOfLines = 0;
        //        _oldPrice.textColor = [HXColor colorWithHexString:@"#aaa"];
        if (KProjectScreenWidth != 320) {
            _activityLabel.font = [UIFont systemFontOfSize:12.0];
        }else
        {
            _activityLabel.font = [UIFont systemFontOfSize:11.0];
        }
        [self addSubview:_activityLabel];
        _activityLabel.frame = CGRectMake(12, CGRectGetMaxY(self.scoreLabel.frame) + 3 , KProjectScreenWidth - 24, KDefauletCellItemLittleHeigh);
    }
    return _activityLabel;
}

-(UILabel *)scoreLabel
{
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc]init];
        _scoreLabel.backgroundColor = [UIColor whiteColor];
        _scoreLabel.textColor = [HXColor colorWithHexString:@"#ff6633"];
        if (KProjectScreenWidth != 320) {
            _scoreLabel.font = [UIFont systemFontOfSize:12.0];
        }else
        {
            _scoreLabel.font = [UIFont systemFontOfSize:11.0];
        }
        [self addSubview:_scoreLabel];
        //_scoreLabel.frame = CGRectMake(CGRectGetMaxX(self.oldPrice.frame) + 5, CGRectGetMaxY(self.moneyTitle.frame), 120, KDefauletCellItemLittleHeigh);
        _scoreLabel.frame = CGRectMake(12, CGRectGetMaxY(self.moneyTitle.frame) , 120, KDefauletCellItemLittleHeigh);
    }
    return _scoreLabel;
}

-(UIView *)functionView
{
    if (!_functionView) {
        _functionView = [[UIView alloc]init];
        [self addSubview:_functionView];
    }
    return _functionView;
}
-(UIView *)activityView
{
    if (!_activityView) {
        _activityView = [[UIView alloc]init];
        [self addSubview:_activityView];
    }
    return _activityView;
}

-(UIButton *)selectButton
{
    if (!_selectButton) {
        _selectButton = [[UIButton alloc]init];
        [self.functionView addSubview:_selectButton];
    }
    return _selectButton;
}
-(UIButton *)checkShopPriceDetail
{
    if (!_checkShopPriceDetail) {
        _checkShopPriceDetail = [[UIButton alloc]init];
        _checkShopPriceDetail.tag = 590;
        [_checkShopPriceDetail addTarget:self action:@selector(checkShopPriceDetailButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (KProjectScreenWidth != 320) {
            _checkShopPriceDetail.titleLabel.font = [UIFont systemFontOfSize:13.0];
            _checkShopPriceDetail.frame = CGRectMake(KProjectScreenWidth - 120, CGRectGetMaxY(self.shopTitle.frame) , 120, KDefauletCellItemLargeHeigh);
        }else
        {
            _checkShopPriceDetail.titleLabel.font = [UIFont systemFontOfSize:12.0];
            _checkShopPriceDetail.frame = CGRectMake(KProjectScreenWidth - 105, CGRectGetMaxY(self.shopTitle.frame) , 105, KDefauletCellItemLargeHeigh);
        }
        [_checkShopPriceDetail setTitleColor:[HXColor colorWithHexString:@"#1e1e1e"] forState:UIControlStateNormal];
        
        [self addSubview:_checkShopPriceDetail];
        
    }
    return _checkShopPriceDetail;
}
-(UIImageView *)funcSelectImage
{
    if (!_funcSelectImage) {
        _funcSelectImage = [[UIImageView alloc]init];
        [self.functionView addSubview:_funcSelectImage];
    }
    return _funcSelectImage;
}

-(UILabel *)funcSelectTitle
{
    if (!_funcSelectTitle) {
        _funcSelectTitle = [[UILabel alloc]init];
        [self.functionView addSubview:_funcSelectTitle];
    }
    return _funcSelectTitle;
}
-(void)changeCreateUIScrollView
{
    //添加选择颜色、尺码。数量
    if (self.shopDetailModel.brief.length > 0) {
        
        
        NSString * contentSizeString = self.shopDetailModel.brief;
        
        CGRect  rect = [contentSizeString boundingRectWithSize:CGSizeMake(self.activityLabel.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.activityLabel.font} context:nil];
        
        
        self.activityLabel.frame = CGRectMake(self.activityLabel.frame.origin.x, self.activityLabel.frame.origin.y, rect.size.width, rect.size.height );
        
        

        self.functionView.frame = CGRectMake(0,CGRectGetMaxY(self.activityLabel.frame) + KMargionItem + 1,KProjectScreenWidth,KDefauletCellItemLargeHeigh);
    }else
    {
        self.functionView.frame = CGRectMake(0,CGRectGetMaxY(self.scoreLabel.frame) + KMargionItem + 1,KProjectScreenWidth,KDefauletCellItemLargeHeigh);
    }
    
    
    self.functionView.backgroundColor = [UIColor whiteColor];
    
    
    self.selectButton.frame = CGRectMake(0, 0, self.functionView.bounds.size.width, self.functionView.bounds.size.height);
    self.selectButton.tag = 570;
    [self.selectButton addTarget:self action:@selector(headerViewButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
   
    
    self.funcSelectImage.frame = CGRectMake(0,0, 10, 14);
    
    self.funcSelectImage.center = CGPointMake(self.functionView.bounds.size.width - 8 - 6, self.functionView.bounds.size.height * 0.5);
    self.funcSelectImage.image = [UIImage imageNamed:@"确认订单页面（箭头）适合下单页面所有有箭头的地方_07"];
    
    
    self.funcSelectTitle.frame = CGRectMake(12, 0, (self.functionView.bounds.size.width - self.funcSelectImage.bounds.size.width - 20 - 12 - 12), self.functionView.bounds.size.height);
    self.funcSelectTitle.textColor = KHeaderViewTextColor;
    
    if (KProjectScreenWidth != 320) {
        self.funcSelectTitle.font = [UIFont systemFontOfSize:15.0];
    }else
    {
        self.funcSelectTitle.font = [UIFont systemFontOfSize:14.0];
    }
    
    
    
    if (self.shopDetailModel.isLoadActivity) {
        //添加优惠促销
        self.activityView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.functionView.frame)+ 0.5, KProjectScreenWidth,KDefauletCellItemLargeHeigh)];
        self.activityView.backgroundColor = [UIColor whiteColor];
        
        
        UIButton * activityButton = [[UIButton alloc]initWithFrame:self.activityView.bounds];
        activityButton.tag = 571;
        [activityButton addTarget:self action:@selector(headerViewButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.activityView addSubview:activityButton];
        
        UILabel * activityTitle = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, self.activityView.bounds.size.width - 24, self.activityView.bounds.size.height)];
        self.activityTitle = activityTitle;
        activityTitle.textColor = KHeaderViewTextColor;
        [self.activityView addSubview:activityTitle];
        if (KProjectScreenWidth != 320) {
            activityTitle.font = [UIFont systemFontOfSize:15.0];
        }else
        {
            activityTitle.font = [UIFont systemFontOfSize:14.0];
        }
        
        
        self.activityTitle.text = @"优惠活动";
        self.headerViewHeigh = CGRectGetMaxY(self.activityView.frame) + 1;
        

    }else
    {
        self.headerViewHeigh = CGRectGetMaxY(self.functionView.frame)+ 1;
    }
    
    if(self.shopDetailModel.unselectInfo.length > 0)
    {
        self.frame = CGRectMake(0, 0, KProjectScreenWidth, self.headerViewHeigh);
        
    }else
    {
        self.frame = CGRectMake(0, 0, KProjectScreenWidth, self.headerViewHeigh - KDefauletCellItemLargeHeigh);
    }
    

    
    
}
-(UIView *)titleBackageView
{
    if (!_titleBackageView) {
        _titleBackageView = [[UIView alloc]init];
        [self addSubview:_titleBackageView];
    }
    return _titleBackageView;
}
-(void)changeBackGroundWithFirstView:(UIView *)view1 withSecondView:(UIView *)view2
{
    
    self.titleBackageView.frame = CGRectMake(0,0,KProjectScreenWidth,CGRectGetMaxY(view2.frame) + KMargionItem);
    self.titleBackageView.backgroundColor = [UIColor whiteColor];
    
   
    [self sendSubviewToBack:self.titleBackageView];
}

-(void)setShopDetailModel:(FMSelectShopInfoModel *)shopDetailModel
{
    _shopDetailModel = shopDetailModel;
    [self.testActivityIndicator stopAnimating];
    //设置商品名称；
    [self shopTitleSetString:[NSString stringWithFormat:@"%@", shopDetailModel.title]];
    NSString * priceNew = [NSString stringWithFormat:@"%.2f",[shopDetailModel.price floatValue]];
    
    //change 价格部分frame
    
    CGRect priceRect =  [[NSString stringWithFormat:@"￥%@",priceNew] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.moneyTitle.font} context:nil];
    
    self.moneyTitle.frame = CGRectMake(self.moneyTitle.frame.origin.x, self.moneyTitle.frame.origin.y, priceRect.size.width + 5, self.moneyTitle.frame.size.height);
    
    
    self.oldPrice.frame = CGRectMake(CGRectGetMaxX(self.moneyTitle.frame) + 5, CGRectGetMaxY(self.moneyTitle.frame) -  KDefauletCellItemLittleHeigh - 7, 120, KDefauletCellItemLittleHeigh);;
    
    NSString *fulljifen_ex = [NSString stringWithFormat:@"%@", [shopDetailModel.fulljifen_ex isMemberOfClass:[NSNull class]]?@"":shopDetailModel.fulljifen_ex];
    
    
    if (fulljifen_ex.length > 0 && [fulljifen_ex integerValue] != 0) {
        self.moneyTitle.text  = [NSString stringWithFormat:@"￥%@",priceNew];
        
        
        self.scoreLabel.text = [NSString stringWithFormat:@"全积分兑换：%@",fulljifen_ex];
        CGRect scoreRect = self.scoreLabel.frame;
        self.scoreLabel.frame = CGRectMake(12, scoreRect.origin.y, scoreRect.size.width + 180, scoreRect.size.height);

        
    }else
    {
        self.moneyTitle.text  = [NSString stringWithFormat:@"￥%@",priceNew];
        
        if (shopDetailModel.mktPrice) {
            // 给数字划线
            NSString *oldPrice = [NSString stringWithFormat:@"%.2f",[ shopDetailModel.mktPrice floatValue]];
            NSUInteger length = [[NSString stringWithFormat:@"￥%@",oldPrice] length];
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",oldPrice]];
            [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleThick) range:NSMakeRange(0, length - 0)];
            [attri addAttribute:NSStrikethroughColorAttributeName value:[HXColor colorWithHexString:@"#aaa"] range:NSMakeRange(0, length)];
            [attri addAttribute:NSForegroundColorAttributeName value:[HXColor colorWithHexString:@"#aaa"] range:NSMakeRange(0, length)];
            
            
            [self.oldPrice setAttributedText:attri];
            
            
           
            
        }
        self.scoreLabel.text = [NSString stringWithFormat:@"可得%@积分",shopDetailModel.jifen];

    }
    
    
    
    
    [self.checkShopPriceDetail setTitle:@"查看会员价格" forState:UIControlStateNormal];
    if (shopDetailModel.brief.length > 0) {
        self.activityLabel.text =shopDetailModel.brief;
    }
    
      [self changeCreateUIScrollView];
    
    if (shopDetailModel.brief.length > 0){
        [self changeBackGroundWithFirstView:self.shopTitle withSecondView:self.activityLabel];
    }else
    {
         [self changeBackGroundWithFirstView:self.shopTitle withSecondView:self.scoreLabel];
    }
    
    
  
    
    if (shopDetailModel.isAllShopInfo) {
        NSString * currentString = shopDetailModel.currentStyle;
        NSString *strUrl = [currentString stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if (strUrl.length <= 1) {
            self.funcSelectTitle.text = shopDetailModel.unselectInfo;
        }else
        {
            self.funcSelectTitle.text = shopDetailModel.currentStyle;
        }
        
    }else
    {
        if(shopDetailModel.unselectInfo.length > 0)
        {
            self.funcSelectTitle.text = shopDetailModel.unselectInfo;
            
        }else
        {
            self.functionView.hidden = YES;
            self.titleBackageView.frame = CGRectMake(0,0,KProjectScreenWidth,self.titleBackageView.frame.size.height + 1);
        }
    }
    
}

-(void)setShopImageUrl:(NSArray *)shopImageUrl
{
    _shopImageUrl = shopImageUrl;
    
    self.cycleImage.imageURLStringsGroup = shopImageUrl;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;
{
    if (self.itemBlock) {
        self.itemBlock(index);
    }
}
-(void)headerViewButtonOnClick:(UIButton *)button
{
    
    if (self.block) {
        self.block(button);
    }
}
-(void)checkShopPriceDetailButtonOnClick:(UIButton *)button
{
    if (self.block) {
        self.block(button);
    }
}

/**
 
 
 
 
 
 
 */

@end
