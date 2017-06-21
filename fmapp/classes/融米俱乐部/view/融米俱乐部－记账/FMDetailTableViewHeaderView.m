//
//  FMDetailTableViewHeaderView.m
//  fmapp
//
//  Created by runzhiqiu on 16/6/27.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMDetailTableViewHeaderView.h"
#import "FMKeepAccount.h"




@interface FMDetailTableViewHeaderView()
@property (nonatomic, strong) UIView * dataBackGround;
@property (nonatomic, strong) UIButton * timeDateButton;
@property (nonatomic, strong) UIButton * timeDateButtonleft;
@property (nonatomic, strong) UIButton * timeDateButtonright;

@property (nonatomic, strong) UIButton * leftBottomTitle;
@property (nonatomic, strong) UIButton * leftBottomMoney;
@property (nonatomic, strong) UIButton * rightBottomTitle;
@property (nonatomic, strong) UIButton * rightBottomMoney;

@end

@implementation FMDetailTableViewHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        [self addMassory];
    }
    return self;
}

-(void)addMassory
{
    CGFloat heighWithHeader = self.frame.size.height * 0.666 - 0.5;
    [self.dataBackGround makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(heighWithHeader);
    }];
    
    [self.timeDateButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.dataBackGround.mas_centerX);
        make.centerY.equalTo(self.dataBackGround.mas_centerY);
//        make.width.equalTo(KProjectScreenWidth * 0.5);
        make.height.equalTo(heighWithHeader * 0.5);
    }];
    
    [self.timeDateButtonleft makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.timeDateButton.mas_left).offset(-15);
        make.centerY.equalTo(self.timeDateButton.mas_centerY);
        make.width.equalTo(@24);
        make.height.equalTo(@40);
    }];
    
    [self.timeDateButtonright makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeDateButton.mas_right).offset(15);
        make.centerY.equalTo(self.timeDateButton.mas_centerY);
        make.width.equalTo(@24);
        make.height.equalTo(@40);
    }];
    
    [self.leftBottomTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.dataBackGround.mas_bottom).offset(0.5);
        make.width.equalTo(KProjectScreenWidth * 0.25);
        make.bottom.equalTo(self.mas_bottom).offset(-0.5);
    
    }];
    
    [self.leftBottomMoney makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftBottomTitle.mas_right);
        make.top.equalTo(self.leftBottomTitle.mas_top);
        make.width.equalTo(KProjectScreenWidth * 0.25 - 0.5);
        make.bottom.equalTo(self.leftBottomTitle.mas_bottom);
    }];
    
    [self.rightBottomTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftBottomMoney.mas_right).offset(0.5);
        make.top.equalTo(self.leftBottomTitle.mas_top);
        make.width.equalTo(KProjectScreenWidth * 0.25);
        make.bottom.equalTo(self.leftBottomTitle.mas_bottom);
    }];
    
    [self.rightBottomMoney makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightBottomTitle.mas_right);
        make.top.equalTo(self.leftBottomTitle.mas_top);
        make.width.equalTo(KProjectScreenWidth * 0.25);
        make.bottom.equalTo(self.leftBottomTitle.mas_bottom);
    }];
    
}

-(void)setHeaderModel:(FMKeepAccountDetailHeaderModel *)headerModel
{
    _headerModel = headerModel;
    
    if (headerModel.leftBottomMoney) {
        [self.leftBottomMoney setTitle:headerModel.leftBottomMoney forState:UIControlStateNormal];
    }
    if (headerModel.rightBottomMoney) {
        [self.rightBottomMoney setTitle:headerModel.rightBottomMoney forState:UIControlStateNormal];
    }
    [self.timeDateButton setTitle:headerModel.dataTime forState:UIControlStateNormal];
}
-(void)timeDateButtonOnClick
{
    if (self.buttonBlock) {
        self.buttonBlock(FMDetailTableViewHeaderViewButtonTypeDataTime);
    }
}
-(void)timeDateButtonleftOnClick
{
    if (self.buttonBlock) {
        self.buttonBlock(FMDetailTableViewHeaderViewButtonTypeDataTimeLeft);
    }
}
-(void)timeDateButtonrightOnClick
{
    if (self.buttonBlock) {
        self.buttonBlock(FMDetailTableViewHeaderViewButtonTypeDataTimeRight);
    }
}
-(void)leftBottomTitleOnClick
{
    if (self.buttonBlock) {
        self.buttonBlock(FMDetailTableViewHeaderViewButtonTypeLeftBottom);
    }
}
-(void)rightBottomTitleOnClick
{
    if (self.buttonBlock) {
        self.buttonBlock(FMDetailTableViewHeaderViewButtonTypeRightBottom);
    }
}

/**
 *  日期背景
 */
-(UIView *)dataBackGround
{
    if (!_dataBackGround) {
        _dataBackGround = [[UIView alloc]init];
        _dataBackGround.backgroundColor = [HXColor colorWithHexString:@"#ebebeb"];
        [self addSubview:_dataBackGround];
    }
    return _dataBackGround;
}
/**
 *  选择时间Button
 */
-(UIButton *)timeDateButton
{
    if (!_timeDateButton) {
        _timeDateButton = [[UIButton alloc]init];
        [_timeDateButton setTitleColor:[HXColor colorWithHexString:@"#e63207"] forState:UIControlStateNormal];
        [_timeDateButton addTarget:self action:@selector(timeDateButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.dataBackGround addSubview:_timeDateButton];
    }
    return _timeDateButton;
}
-(UIButton *)timeDateButtonleft
{
    if (!_timeDateButtonleft) {
        _timeDateButtonleft = [[UIButton alloc]init];
        [_timeDateButtonleft addTarget:self action:@selector(timeDateButtonleftOnClick) forControlEvents:UIControlEventTouchUpInside];
        [_timeDateButtonleft setImage:[UIImage imageNamed:@"记账_红色箭头_03"] forState:UIControlStateNormal];
        _timeDateButtonleft.imageEdgeInsets = UIEdgeInsetsMake(10, 6, 10, 6);
        [self.dataBackGround addSubview:_timeDateButtonleft];
    }
    return _timeDateButtonleft;
}
-(UIButton *)timeDateButtonright
{
    if (!_timeDateButtonright) {
        _timeDateButtonright = [[UIButton alloc]init];
        [_timeDateButtonright addTarget:self action:@selector(timeDateButtonrightOnClick) forControlEvents:UIControlEventTouchUpInside];
        [_timeDateButtonright setImage:[UIImage imageNamed:@"记账_红色箭头_03"] forState:UIControlStateNormal];
        _timeDateButtonright.transform = CGAffineTransformRotate(_timeDateButtonright.transform, M_PI);
        _timeDateButtonright.imageEdgeInsets = UIEdgeInsetsMake(10, 6, 10, 6);

        [self.dataBackGround addSubview:_timeDateButtonright];
    }
    return _timeDateButtonright;
}
-(UIButton *)leftBottomTitle
{
    if (!_leftBottomTitle) {
        _leftBottomTitle = [[UIButton alloc]init];
        [_leftBottomTitle setTitleColor:[HXColor colorWithHexString:@"#e63207"] forState:UIControlStateNormal];
        [_leftBottomTitle setTitle:@"收入" forState:UIControlStateNormal];
        [_leftBottomTitle setBackgroundColor:[HXColor colorWithHexString:@"#ebebeb"]];
        [_leftBottomTitle addTarget:self action:@selector(leftBottomTitleOnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftBottomTitle];
    }
    return _leftBottomTitle;
}
-(UIButton *)leftBottomMoney
{
    if (!_leftBottomMoney) {
        _leftBottomMoney = [[UIButton alloc]init];
        [_leftBottomMoney setTitleColor:[HXColor colorWithHexString:@"#e63207"] forState:UIControlStateNormal];
        [_leftBottomMoney setBackgroundColor:[HXColor colorWithHexString:@"#ebebeb"]];
        [_leftBottomMoney addTarget:self action:@selector(leftBottomTitleOnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftBottomMoney];
    }
    return _leftBottomMoney;
}
-(UIButton *)rightBottomTitle
{
    if (!_rightBottomTitle) {
        _rightBottomTitle = [[UIButton alloc]init];
        [_rightBottomTitle setTitleColor:[HXColor colorWithHexString:@"#e63207"] forState:UIControlStateNormal];
        [_rightBottomTitle setBackgroundColor:[HXColor colorWithHexString:@"#ebebeb"]];
        [_rightBottomTitle setTitle:@"支出" forState:UIControlStateNormal];
        [_rightBottomTitle addTarget:self action:@selector(rightBottomTitleOnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightBottomTitle];
    }
    return _rightBottomTitle;
}
-(UIButton *)rightBottomMoney
{
    if (!_rightBottomMoney) {
        _rightBottomMoney = [[UIButton alloc]init];
        [_rightBottomMoney setTitleColor:[HXColor colorWithHexString:@"#e63207"] forState:UIControlStateNormal];
        [_rightBottomMoney setBackgroundColor:[HXColor colorWithHexString:@"#ebebeb"]];
        [_rightBottomMoney addTarget:self action:@selector(rightBottomTitleOnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightBottomMoney];
    }
    return _rightBottomMoney;
}

/*
 
 
 
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 
*/


/**
 
 
 
 **/

@end
