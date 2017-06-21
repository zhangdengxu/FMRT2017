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

#import "FMDuobaoShopDetailHeaderView.h"
#import "FMDuobaoClass.h"

@interface FMDuobaoShopDetailHeaderView ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView * cycleImage;
@property (nonatomic, strong) UILabel * shopTitle;
@property (nonatomic, strong) UILabel * detailTitle;
@property (nonatomic, strong) UIView  * contentButtonView;
@property (nonatomic, strong) UILabel * personNumber;
@property (nonatomic, strong) UILabel * shopNumber;


@property (nonatomic, strong) UIActivityIndicatorView *testActivityIndicator;

@end

@implementation FMDuobaoShopDetailHeaderView

- (instancetype)init
{
    
    self = [super init];
    if (self){
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, -20, KProjectScreenWidth, KProjectScreenWidth * 0.9375 + KDefauletCellItemLargeHeigh + KDefauletCellItemLargeHeigh + KDefauletCellItemLargeHeigh);
        
        
        // 菊花转啊转
        UIActivityIndicatorView *testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        testActivityIndicator.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
        testActivityIndicator.color = [UIColor blackColor];
        [testActivityIndicator setHidesWhenStopped:YES];
        [self addSubview:testActivityIndicator];
        self.testActivityIndicator = testActivityIndicator;
        
        [self contentButtonView];

    }
    return self;
}


-(void)setShopImageUrl:(NSArray *)shopImageUrl
{
    _shopImageUrl = shopImageUrl;
    
    self.cycleImage.imageURLStringsGroup = shopImageUrl;
}
-(void)setDuobaoModel:(FMDuobaoClass *)duobaoModel
{
    _duobaoModel = duobaoModel;
    
    [self.testActivityIndicator stopAnimating];
    self.shopTitle.text = duobaoModel.goods_name;
    self.detailTitle.text = duobaoModel.brief;
    
    self.personNumber.text = [NSString stringWithFormat:@"%@人",duobaoModel.sum_person];
    
    self.shopNumber.text = [NSString stringWithFormat:@"%@件",duobaoModel.sum_online];

}



-(SDCycleScrollView *)cycleImage
{
    if (!_cycleImage) {
        _cycleImage = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenWidth * 0.9375 + 20) delegate:self placeholderImage:[UIImage imageNamed:@"美读时光headerBack_02"]];
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
        _shopTitle.frame = CGRectMake(15, CGRectGetMaxY(self.cycleImage.frame) + 5, KProjectScreenWidth - 30, KDefauletCellItemLargeHeigh - 10);
        _shopTitle.textColor = [HXColor colorWithHexString:@"#333333"];
        _shopTitle.numberOfLines = 1;
        if (KProjectScreenWidth != 320) {
            _shopTitle.font = [UIFont systemFontOfSize:21.0];
        }else
        {
            _shopTitle.font = [UIFont systemFontOfSize:22.0];
        }
        _shopTitle.backgroundColor = [UIColor whiteColor];
        [self addSubview:_shopTitle];
    }
    return _shopTitle;
}

-(UILabel *)personNumber
{
    if (!_personNumber) {
        _personNumber = [[UILabel alloc]init];
        _personNumber.textColor = [HXColor colorWithHexString:@"#999999"];
        _personNumber.textAlignment = NSTextAlignmentCenter;
        _personNumber.font = [UIFont systemFontOfSize:16];
        _personNumber.text = @"0人";
        
    }
    return _personNumber;
}

-(UILabel *)shopNumber
{
    if (!_shopNumber) {
        _shopNumber = [[UILabel alloc]init];
        _shopNumber.textColor = [HXColor colorWithHexString:@"#999999"];
        _shopNumber.textAlignment = NSTextAlignmentCenter;
        _shopNumber.font = [UIFont systemFontOfSize:16];
        _shopNumber.text = @"0件";
        
    }
    return _shopNumber;
}

-(UIView *)contentButtonView
{
    if (!_contentButtonView) {
        _contentButtonView = [[UIView alloc]init];
        _contentButtonView.backgroundColor = [UIColor whiteColor];
        _contentButtonView.frame = CGRectMake(0, CGRectGetMaxY(self.detailTitle.frame), KProjectScreenWidth, KDefauletCellItemLargeHeigh);
    
        
        UIImageView * iconImage1 = [[UIImageView alloc]init];
        iconImage1.image = [UIImage imageNamed:@"1014人数"];
        [_contentButtonView addSubview:iconImage1];
        [iconImage1 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentButtonView.mas_left).offset(12);
            make.centerY.equalTo(_contentButtonView.mas_centerY);
        }];
        
        [_contentButtonView addSubview:self.personNumber];
        [self.personNumber makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImage1.mas_right).offset(10);
            make.centerY.equalTo(_contentButtonView.mas_centerY);

        }];
        
        UIButton * button1 = [[UIButton alloc]init];
        [button1 addTarget:self action:@selector(personAndShopButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        button1.backgroundColor = [UIColor clearColor];
        button1.tag = 101;
        [_contentButtonView addSubview:button1];
        [button1 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentButtonView.mas_left).offset(30);
            make.centerY.equalTo(_contentButtonView.mas_centerY);
            make.right.equalTo(self.personNumber.mas_right);
        }];
        
        
        UIImageView * iconImage2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1014库存"]];
        [_contentButtonView addSubview:iconImage2];
        [iconImage2 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.personNumber.mas_right).offset(50);
            make.centerY.equalTo(_contentButtonView.mas_centerY);
        }];
        
        [_contentButtonView addSubview:self.shopNumber];
        [self.shopNumber makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImage2.mas_right).offset(10);
            make.centerY.equalTo(_contentButtonView.mas_centerY);
            
        }];

        
        
       
        
        UIButton * button2 = [[UIButton alloc]init];
        [button2 addTarget:self action:@selector(personAndShopButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        button2.backgroundColor = [UIColor clearColor];
        button2.tag = 102;
        [_contentButtonView addSubview:button2];
        [button2 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(button1.mas_right).offset(50);
            make.centerY.equalTo(_contentButtonView.mas_centerY);
            make.right.equalTo(self.shopNumber.mas_right);
        }];

        
        [self addSubview:_contentButtonView];
    }
    return _contentButtonView;
}

-(void)personAndShopButtonOnClick:(UIButton *)button
{
    if (self.block) {
        self.block(button);
    }
}
//ff6633
-(UILabel *)detailTitle
{
    if (!_detailTitle) {
        _detailTitle  = [[UILabel alloc]init];
        _detailTitle.textColor = [HXColor colorWithHexString:@"#666666"];
        _detailTitle.numberOfLines = 2;
        if (KProjectScreenWidth != 320) {
            _detailTitle.font = [UIFont systemFontOfSize:15.0];
        }else
        {
            _detailTitle.font = [UIFont systemFontOfSize:14.0];
        }
        _detailTitle.frame = CGRectMake(12, CGRectGetMaxY(self.shopTitle.frame) , (KProjectScreenWidth - 40) , KDefauletCellItemLargeHeigh + 10);
        [self addSubview:_detailTitle];
    }
    return _detailTitle;
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
