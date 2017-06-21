//
//  YYWarmPromptView.m
//  fmapp
//
//  Created by yushibo on 2017/5/16.
//  Copyright © 2017年 yk. All rights reserved.
//  更换银行卡 -- 温馨提示

#import "YYWarmPromptView.h"
#import "XZBankRechargeModel.h"

@interface YYWarmPromptView ()

@property (nonatomic, strong) UILabel *Label1;

@end

@implementation YYWarmPromptView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    /**
     *  背景backView
     */
    UIView *backView = [[UIView alloc]init];
    backView.userInteractionEnabled = YES;
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 10.0;
    [self addSubview:backView];
    [backView makeConstraints:^(MASConstraintMaker *make) {
//        if (KProjectScreenWidth > 320) {
            make.left.equalTo(self.mas_left).offset(40);
            make.right.equalTo(self.mas_right).offset(-40);
//        }else{
//            make.left.equalTo(self.mas_left).offset(15);
//            make.right.equalTo(self.mas_right).offset(-15);
//        }
        
        make.top.equalTo(self.mas_top).offset(KProjectScreenHeight / 4 + 30);
        make.height.equalTo(@160);
    }];
    
    /**
     *  标题
     */
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = @"温馨提示";
    //    self.titleLabel = titleLabel;
    [backView addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left);
        make.right.equalTo(backView.mas_right);
        make.top.equalTo(@15);
    }];
    /**
     *  资产总额为0时，可更换银行卡；您当前的资产总额30元，不能更换银行卡；
     */
    UILabel *Label1 = [[UILabel alloc]init];
    Label1.textAlignment = NSTextAlignmentLeft;
    Label1.textColor = [UIColor colorWithHexString:@"#666666"];
    Label1.numberOfLines = 0;
    Label1.font = [UIFont systemFontOfSize:15];
    self.Label1 = Label1;
//    Label1.text = @"资产总额为0时，可更换银行卡；您当前的资产总额30元，不能更换银行卡；";
    //    self.chengweiLabel = chengweiLabel;
    [backView addSubview:Label1];
    [Label1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(20);
        make.right.equalTo(backView.mas_right).offset(-20);
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
    }];
    
    /**
     *  确认
     */
    UIButton *clickBtn = [[UIButton alloc]init];
    clickBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    clickBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [clickBtn setTitle:@"确认" forState:UIControlStateNormal];
    [clickBtn setTitleColor:[UIColor colorWithHexString:@"#0159D5"] forState:UIControlStateNormal];
    [clickBtn addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    //    [clickBtn setBackgroundColor:[UIColor redColor]];
    [backView addSubview:clickBtn];
    [clickBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left);
        make.right.equalTo(backView.mas_right);
        make.top.equalTo(Label1.mas_bottom).offset(5);
        make.height.equalTo(40);
    }];
    
    
    
}

- (void)setModelBankUser:(XZBankRechargeUserModel *)modelBankUser {
    _modelBankUser = modelBankUser;
    
    NSString *str = [NSString stringWithFormat:@"资产总额为0时，可更换银行卡；您当前的资产总额%.2f元，不能更换银行卡；",modelBankUser.acctAmtTotal];
    
    NSString *acctAmtTotal = [NSString stringWithFormat:@"%.2f元",modelBankUser.acctAmtTotal];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
    
    [attrStr addAttribute:NSForegroundColorAttributeName value:[HXColor colorWithHexString:@"#FF6633"] range:NSMakeRange(23, [acctAmtTotal length])];
    
    self.Label1.attributedText = attrStr;
}

- (void)clickAction{
    
    [self removeFromSuperview];
    
}
@end
