//
//  XZBankRechargeCell.m
//  fmapp
//
//  Created by admin on 17/5/11.
//  Copyright © 2017年 yk. All rights reserved.
//  充值cell

#import "XZBankRechargeCell.h"
#import "XZBankRechargeModel.h"
#import "FMKeyBoardNumberHeader.h"

@interface XZBankRechargeCell ()<UITextFieldDelegate>
// 方式
@property (nonatomic, strong) UILabel *labelWay;

@property (nonatomic, strong) UILabel *labelWayName;

@property (nonatomic, strong) UIImageView *imgArrow;

// 立即前往
@property (nonatomic, strong) UIButton *btnImmediateGo;
// 快捷充值金额输入框
@property (nonatomic, strong) UITextField *textWayName;

@end

@implementation XZBankRechargeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupBankRechargeCell];
    }
    return self;
}

- (void)setupBankRechargeCell {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    // 方式
    UILabel *labelWay = [[UILabel alloc] init];
    [self.contentView addSubview:labelWay];
    [labelWay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@60);
    }];
    self.labelWay = labelWay;
    labelWay.textColor = [HXColor colorWithHexString:@"#666666"];
    labelWay.font = [UIFont systemFontOfSize:15.0f];
    
    //
    UILabel *labelWayName = [[UILabel alloc] init];
    [self.contentView addSubview:labelWayName];
    [labelWayName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelWay.mas_right); // .offset(15)
        make.centerY.equalTo(self.contentView);
    }];
    self.labelWayName = labelWayName;
    labelWayName.font = [UIFont systemFontOfSize:15.0f];
    labelWayName.textColor = [HXColor colorWithHexString:@"#666666"];
    
    // 快捷充值金额输入框
    UITextField *textWayName = [[UITextField alloc] init];
    [self.contentView addSubview:textWayName];
    [textWayName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelWay.mas_right);
         make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(@40);
    }];
    textWayName.placeholder = @"最低充值1000元";
    textWayName.font = [UIFont systemFontOfSize:15.0f];
    textWayName.textColor = [HXColor colorWithHexString:@"#666666"];
    self.textWayName = textWayName;
    textWayName.keyboardType = UIKeyboardTypeDecimalPad;
    __weak __typeof(&*self)weakSelf = self;
    textWayName.inputAccessoryView = [FMKeyBoardNumberHeader initKeyBoardNumberHeaderCreate:^{
        [weakSelf keyBoardDown];
    }];
    textWayName.clearButtonMode = UITextFieldViewModeAlways;
    textWayName.delegate = self;
    
    // 11 * 20
    UIImageView *imgArrow = [[UIImageView alloc] init];
    [self.contentView addSubview:imgArrow];
    [imgArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@(11 * 0.6));
        make.height.equalTo(@(20 * 0.6));
    }];
    imgArrow.image = [UIImage imageNamed:@"微商_充值_右箭头"];
    self.imgArrow = imgArrow;
    
    // 立即前往
    UIButton *btnImmediateGo = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:btnImmediateGo];
    [btnImmediateGo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imgArrow.mas_left).offset(-10);
        make.centerY.equalTo(imgArrow);
        make.height.equalTo(self.contentView);
        make.width.equalTo(@80);
    }];
    [btnImmediateGo setTitle:@"立即前往" forState:UIControlStateNormal];
    [btnImmediateGo setTitleColor:[HXColor colorWithHexString:@"#FF6633"] forState:UIControlStateNormal];
    [btnImmediateGo addTarget:self action:@selector(didClickImmediateGoButton) forControlEvents:UIControlEventTouchUpInside];
    [btnImmediateGo.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    self.btnImmediateGo = btnImmediateGo;
    [btnImmediateGo.titleLabel setTextAlignment:NSTextAlignmentRight];
    
    //
    UILabel *line = [[UILabel alloc] init];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@1);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
    }];
    line.backgroundColor = XZBackGroundColor;
}

- (void)setModelRecharge:(XZBankRechargeModel *)modelRecharge {
    _modelRecharge = modelRecharge;
    
    if (modelRecharge.isQuickPay) { // 快捷支付
        if ([modelRecharge.way isEqualToString:@"金额"]) {
            self.labelWayName.hidden = YES;
            self.textWayName.hidden = NO;
        }else {
            self.textWayName.hidden = YES;
            self.labelWayName.hidden = NO;
            self.labelWayName.text = modelRecharge.wayName;
        }
        self.labelWay.text = modelRecharge.way;
        self.labelWayName.textColor = XZColor(51, 51, 51);
        self.imgArrow.hidden = YES;
        self.btnImmediateGo.hidden = YES;
    }else { // 转账支付
        self.labelWay.text = modelRecharge.way;
        self.labelWayName.hidden = NO;
        self.labelWayName.text = modelRecharge.wayName;
        self.labelWayName.textColor = XZColor(1, 89, 213);
        self.imgArrow.hidden = NO;
        self.textWayName.hidden = YES;
        if ([modelRecharge.wayName isEqualToString:@"支付宝"] || [modelRecharge.wayName isEqualToString:@"手机银行"]) {
            self.btnImmediateGo.hidden = NO;
        }else {
            self.btnImmediateGo.hidden = YES;
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSMutableString *futureString = [NSMutableString stringWithString:textField.text];
    [futureString  insertString:string atIndex:range.location];
    
    NSInteger flag = 0;
    const NSInteger limited = 2;  //小数点  限制输入两位
    for (int i = (int)(futureString.length - 1); i >= 0;i--) {
        
        if ([futureString characterAtIndex:i] == '.') {
            
            if (flag > limited) {
                return NO;
            }
            
            break;
        }
        flag++;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.blockMoney) {
        self.blockMoney(textField.text);
    }
}

// 点击立即前往
- (void)didClickImmediateGoButton {
    if (self.blockImmediateGo) {
        self.blockImmediateGo();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)keyBoardDown {
    [self.textWayName resignFirstResponder];
}

@end
