//
//  FMBankAddressHeaderView.m
//  fmapp
//
//  Created by runzhiqiu on 16/6/13.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMBankAddressHeaderView.h"
#import "FMBankAddressModel.h"

@interface FMBankAddressHeaderView ()

@property (nonatomic, strong) UILabel * titleContent;
@property (nonatomic, strong) UIButton * backButton;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UIImageView * rightImageView;
@end

@implementation FMBankAddressHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, KProjectScreenWidth, 50);
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self tableViewSectionHeaderView];
    }
    return self;
}
-(void)tableViewSectionHeaderView
{
    self.titleContent.frame = CGRectMake(12, 0, KProjectScreenWidth - 2 * 12, self.frame.size.height);
    self.backButton.frame = self.titleContent.frame;
    self.lineView.frame = CGRectMake(0, self.frame.size.height - 0.5, KProjectScreenWidth, 0.5);
    self.rightImageView.center = CGPointMake(KProjectScreenWidth - 12 - 12, self.frame.size.height * 0.5);
    

}
-(void)setBankModel:(FMBankAddressModel *)bankModel
{
    _bankModel = bankModel;
    self.titleContent.text = bankModel.region_name;
    
    if (self.bankModel.isShowDetail) {
        self.rightImageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }else
    {
        self.rightImageView.transform = CGAffineTransformMakeRotation(0);
    }
    
}

-(void)headerButtonOnClick
{
    self.backButton.selected = !self.bankModel.isShowDetail;
    self.bankModel.isShowDetail = self.backButton.selected;
    if (self.bankModel.isShowDetail) {
        self.rightImageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }else
    {
        self.rightImageView.transform = CGAffineTransformMakeRotation(0);
    }
    
    if (self.bankAddressBlock) {
        self.bankAddressBlock(self.bankModel);
    }
    
}
-(void)prepareForReuse
{
    [super prepareForReuse];
}

-(UILabel *)titleContent
{
    if (!_titleContent) {
        _titleContent = [[UILabel alloc]init];
        _titleContent.font = [UIFont systemFontOfSize:17];
        _titleContent.textColor = [HXColor colorWithHexString:@"363738"];
        [self.contentView addSubview:_titleContent];
    }
    return _titleContent;
}
-(UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [[UIButton alloc]init];
        [_backButton addTarget:self action:@selector(headerButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_backButton];
    }
    return _backButton;
}
-(UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}
-(UIImageView *)rightImageView
{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 9, 15)];
        _rightImageView.image = [UIImage imageNamed:@"确认订单页面（箭头）适合下单页面所有有箭头的地方_07"];
        [self.contentView addSubview:_rightImageView];
        
    }
    return _rightImageView;
}
@end
