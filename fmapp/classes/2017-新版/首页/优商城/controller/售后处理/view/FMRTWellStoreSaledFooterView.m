//
//  FMRTWellStoreSaledFooterView.m
//  fmapp
//
//  Created by apple on 2016/12/12.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTWellStoreSaledFooterView.h"
#import "HexColor.h"

@interface FMRTWellStoreSaledFooterView ()

@property (nonatomic, strong) UIButton *changeBtn,*cancelBtn,*telBtn;

@end

@implementation FMRTWellStoreSaledFooterView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [HXColor colorWithHexString:@"#cccccc"];
    [self addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.top);
        make.left.equalTo(self.left);
        make.right.equalTo(self.right);
        make.height.equalTo(@1);
    }];
    
    [self addSubview:self.changeBtn];
    [self.changeBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.centerX).dividedBy(2).offset(-10);
        make.centerY.equalTo(self.centerY);
        make.width.equalTo(@75);
        make.height.equalTo(@25);
    }];
    
    [self addSubview:self.cancelBtn];
    [self.cancelBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.centerX);
        make.centerY.equalTo(self.centerY);
        make.width.equalTo(@75);
        make.height.equalTo(@25);
    }];
    
    [self addSubview:self.telBtn];
    [self.telBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.centerX).multipliedBy(1.5).offset(10);
        make.centerY.equalTo(self.centerY);
        make.width.equalTo(@75);
        make.height.equalTo(@25);
    }];
    
    
}

- (UIButton *)changeBtn{
    if (!_changeBtn) {
        _changeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_changeBtn setTitleColor:[HXColor colorWithHexString:@"#ff6633"] forState:(UIControlStateNormal)];
        _changeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _changeBtn.layer.borderWidth = 1;
        _changeBtn.layer.borderColor = [HXColor colorWithHexString:@"#ff6633"].CGColor;
        [_changeBtn setTitle:@"修改申请" forState:(UIControlStateNormal)];
        _changeBtn.layer.cornerRadius = 3;
        [_changeBtn addTarget:self action:@selector(changeAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _changeBtn;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_cancelBtn setTitleColor:[HXColor colorWithHexString:@"#666666"] forState:(UIControlStateNormal)];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _cancelBtn.layer.borderWidth = 1;
        _cancelBtn.layer.borderColor = [HXColor colorWithHexString:@"#666666"].CGColor;
        [_cancelBtn setTitle:@"撤销申请" forState:(UIControlStateNormal)];
        _cancelBtn.layer.cornerRadius = 3;
        [_cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:(UIControlEventTouchUpInside)];

    }
    return _cancelBtn;
}

- (UIButton *)telBtn{
    if (!_telBtn) {
        _telBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_telBtn setTitleColor:[HXColor colorWithHexString:@"#0159d5"] forState:(UIControlStateNormal)];
        _telBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _telBtn.layer.borderWidth = 1;
        _telBtn.layer.borderColor = [HXColor colorWithHexString:@"#0159d5"].CGColor;
        [_telBtn setTitle:@"联系客服" forState:(UIControlStateNormal)];
        _telBtn.layer.cornerRadius = 3;
        [_telBtn addTarget:self action:@selector(telAction:) forControlEvents:(UIControlEventTouchUpInside)];

    }
    return _telBtn;
}

-(void)changeAction:(UIButton *)sender{
    
    if (self.saleType == SaleStatusCancel ||self.saleType == SaleStatusDefy || self.saleType == SaleStatusAlreadyDeny) {
        if (self.afterSaleBlock) {
            self.afterSaleBlock();
        }
    }else if(self.saleType == SaleStatusAgree){
        
        if (self.tuihuoBlock) {
            self.tuihuoBlock();
        }
    }else{
        
        if (self.changeBlock) {
            self.changeBlock();
        }
    }
}

-(void)cancelAction:(UIButton *)sender{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

-(void)telAction:(UIButton *)sender{
    if (self.telBlock) {
        self.telBlock();
    }
}

- (void)setSaleType:(SaleStatusType)saleType{
    _saleType = saleType;
    
    if (saleType == SaleStatusCancel || saleType == SaleStatusDefy ||  saleType ==SaleStatusAlreadyDeny) {
        
        [self.cancelBtn setHidden:YES];
        [self.changeBtn setTitle:@"申请售后" forState:(UIControlStateNormal)];
        [self.changeBtn updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerX).dividedBy(2);
        }];
        [self.telBtn updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerX).multipliedBy(1.5);
        }];
    }else{
        [self.changeBtn updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerX).dividedBy(2).offset(-10);
        }];
        [self.telBtn updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerX).multipliedBy(1.5).offset(10);
        }];
        
        switch (saleType) {
            case SaleStatusIn:
            {
                [self.cancelBtn setHidden:NO];
                [_changeBtn setTitle:@"修改申请" forState:(UIControlStateNormal)];
                break;
            }
            case SaleStatusAgree:
            {
                [self.cancelBtn setHidden:NO];
                [self.changeBtn setTitle:@"退货" forState:(UIControlStateNormal)];
                break;
            }
            case SaleStatusFinish:
            {
                [self.cancelBtn setHidden:NO];
                [self.changeBtn setTitle:@"修改申请" forState:(UIControlStateNormal)];
                break;
            }
            default:
                break;
        }
    }
}


@end
