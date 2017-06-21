//
//  FMRTRegisterAppCell.m
//  fmapp
//
//  Created by apple on 2017/5/11.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRTRegisterAppCell.h"
#import "MZTimerLabel.h"

@interface FMRTRegisterAppCell ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation FMRTRegisterAppCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    
    
    UIView *bottomline = [[UIView alloc]init];
    bottomline.backgroundColor = [HXColor colorWithHexString:@"#e4ebf1"];
    [self.contentView addSubview:bottomline];
    [bottomline makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.height.equalTo(1);
        make.bottom.equalTo(self.contentView.bottom);
    }];
    
    [self.iconView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.left).offset(10);
        make.centerY.equalTo(self.contentView.centerY);
        make.width.equalTo(20);
    }];
    
    [self.leftTextfield makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.iconView.right).offset(10);
        make.centerY.equalTo(self.contentView.centerY);
        make.height.equalTo(40);
        make.right.equalTo(self.contentView.right).offset(-10);
    }];
    
    [self.getCodeBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView.centerY);
        make.height.equalTo(40);
        make.right.equalTo(self.contentView.right).offset(-10);
    }];
    
}

- (UITextField *)leftTextfield{
    if (!_leftTextfield) {
        _leftTextfield = [[UITextField alloc]init];
        _leftTextfield.placeholder = @"输入验证码";
        _leftTextfield.font = [UIFont systemFontOfSize:KProjectScreenWidth<375?13:15];;
        _leftTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.contentView addSubview:_leftTextfield];
    }
    return _leftTextfield;
}

- (UIButton *)getCodeBtn{
    if (!_getCodeBtn) {
        _getCodeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_getCodeBtn setTitle:@"获取验证码" forState:(UIControlStateNormal)];
        _getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_getCodeBtn setTitleColor:[HXColor colorWithHexString:@"#0159d5"] forState:(UIControlStateNormal)];
        [_getCodeBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateDisabled)];
        [_getCodeBtn addTarget:self action:@selector(getCodeAction) forControlEvents:(UIControlEventTouchUpInside)];
        _getCodeBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_getCodeBtn];
    }
    return _getCodeBtn;
}

- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc]init];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        _iconView.image = [UIImage imageNamed:@"微商_注册:取现_实心手机"];
        [self.contentView addSubview:_iconView];
    }
    return _iconView;
}


- (void)getCodeAction{
    if (self.getCodeBlcok) {
        self.getCodeBlcok();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self setSelectionStyle:(UITableViewCellSelectionStyleNone)];
}

- (void)setRow:(NSInteger)row{
    _row = row;
    
    switch (row) {
        case 0:
        {
            _iconView.image = [UIImage imageNamed:@"微商_注册:取现_实心手机"];
            [_iconView setHidden:NO];
            [_getCodeBtn setHidden:YES];
            _leftTextfield.placeholder = @"手机号";

            break;
        }
        case 1:
        {
            [_iconView setHidden:YES];
            [_getCodeBtn setHidden:NO];

            _leftTextfield.placeholder = @"输入验证码";

            [self.leftTextfield remakeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(self.contentView.left).offset(10);
                make.centerY.equalTo(self.contentView.centerY);
                make.height.equalTo(40);
                make.right.equalTo(self.contentView.right).offset(-150);
            }];
            break;
        }
        case 2:
        {
            _iconView.image = [UIImage imageNamed:@"微商_注册:取现_实心锁"];
            [_iconView setHidden:NO];
            [_getCodeBtn setHidden:YES];

            _leftTextfield.placeholder = @"设置登录密码";

            break;
        }
        case 3:
        {
            _iconView.image = [UIImage imageNamed:@"微商_注册:取现_实心锁"];
            [_iconView setHidden:NO];
            [_getCodeBtn setHidden:YES];
            _leftTextfield.placeholder = @"确认登录密码";

            break;
        }
        case 4:
        {
            _iconView.image = [UIImage imageNamed:@"微商_注册:取现_实心手机"];
            [_iconView setHidden:NO];
            [_getCodeBtn setHidden:YES];
            _leftTextfield.placeholder = @"推荐人手机号（选填）";

            break;
        }
        default:
            break;
    }
    
    
}

@end
