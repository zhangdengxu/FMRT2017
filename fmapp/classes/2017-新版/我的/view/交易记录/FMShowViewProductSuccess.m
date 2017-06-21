//
//  FMShowViewProductSuccess.m
//  fmapp
//
//  Created by runzhiqiu on 2017/6/11.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMShowViewProductSuccess.h"

@interface FMShowViewProductSuccess ()

@property (nonatomic,copy) showViewShowButtonOnClickBlock block;
@property (nonatomic, strong) UIView * backGroundButton;

@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, strong) UILabel * productDetail;
@property (nonatomic, strong) UIImageView * bottonImage;
@property (nonatomic, strong) UIButton  * buttonOnClick;
@property (nonatomic, strong) UIButton  * closeButton;


@end

@implementation FMShowViewProductSuccess

-(void)backGroundButtonOnClick:(UITapGestureRecognizer *)tap
{
    [self removeFromSuperview];
}

-(UIView *)backGroundButton
{
    if (!_backGroundButton) {
        _backGroundButton = [[UIView alloc]init];
        _backGroundButton.userInteractionEnabled = YES;
        
        _backGroundButton.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backGroundButtonOnClick:)];
        [_backGroundButton addGestureRecognizer:tapGesture];
        
        
    }
    return _backGroundButton;
}
-(UILabel *)productDetail
{
    if (!_productDetail) {
        _productDetail = [[UILabel alloc]init];
        _productDetail.textAlignment = NSTextAlignmentCenter;
        _productDetail.textColor = [UIColor whiteColor];
        _productDetail.font = [UIFont systemFontOfSize:18];
    }
    return _productDetail;
}
-(UIImageView *)bottonImage
{
    if (!_bottonImage) {
        _bottonImage = [[UIImageView alloc]init];
        _bottonImage.image = [UIImage imageNamed:@"徽商_项目_投标成功"];
        
    }
    return _bottonImage;
}
-(UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
    }
    return _iconImageView;
}

-(UIButton *)buttonOnClick
{
    if (!_buttonOnClick) {
        _buttonOnClick = [[UIButton alloc]init];
        [_buttonOnClick addTarget:self action:@selector(bottomButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
        [_buttonOnClick setTitle:@"点开看看" forState:UIControlStateNormal];
        [_buttonOnClick setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    return _buttonOnClick;
}

-(UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [[UIButton alloc]init];
        [_closeButton addTarget:self action:@selector(closeButtonbuttonOnClick) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setImage:[UIImage imageNamed:@"微商_弹窗_关闭"] forState:UIControlStateNormal];
        
        
        
    }
    return _closeButton;
}
-(void)closeButtonbuttonOnClick
{
    [self removeFromSuperview];
}

-(void)bottomButtonOnClick
{
    [self removeFromSuperview];
    if (self.block) {
        self.block(self.productModel.productId);
    }
}

- (instancetype)initWithSuccess:(FMShowViewProductSuccessModel *)productModel WithBlock:(showViewShowButtonOnClickBlock)block;
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight);
        
        UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:self];
        self.productModel = productModel;
        self.block = block;
        
        [self addSubview:self.backGroundButton];
        [self.backGroundButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self);
        }];
        
        [self addSubview:self.productDetail];
        [self.productDetail makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY).offset(80);
            make.centerX.equalTo(self.mas_centerX);

        
        }];
        
        [self addSubview:self.iconImageView];
        [self.iconImageView makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.productDetail.mas_top).offset(-28);
            make.centerX.equalTo(self.mas_centerX);
            make.height.mas_lessThanOrEqualTo(KProjectScreenHeight * 0.4);
            make.width.mas_lessThanOrEqualTo(KProjectScreenWidth * 0.75);
        }];
       
        [self addSubview:self.closeButton];
        [self.closeButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(10);
            make.bottom.equalTo(self.iconImageView.mas_top).offset(-20);
            
        }];
        
        [self addSubview:self.bottonImage];
        [self.bottonImage makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.productDetail.mas_bottom).offset(20);
            
        }];
        
        [self addSubview:self.buttonOnClick];
        [self.buttonOnClick makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.productDetail.mas_bottom).offset(20);
            make.left.right.equalTo(self);
            
        }];
        
        
        if(self.productModel.imageUrl.length > 0)
        {
            [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.productModel.imageUrl] placeholderImage:[UIImage imageNamed:@"shop_loading_wait_04375da"]];
        }
        if (self.productModel.productDetail.length > 0) {
            self.productDetail.text = [NSString stringWithFormat:@"%@",self.productModel.productDetail];
        }

    }
    return self;
}


+(instancetype)showFMMessageViewShow:(FMShowViewProductSuccessModel *)productModel WithBolok:(showViewShowButtonOnClickBlock)block;
{
    FMShowViewProductSuccess * success = [[FMShowViewProductSuccess alloc]initWithSuccess:productModel WithBlock:block];
    
    
    return success;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation FMShowViewProductSuccessModel


@end

