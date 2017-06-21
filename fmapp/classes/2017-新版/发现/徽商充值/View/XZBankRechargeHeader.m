//
//  XZBankRechargeHeader.m
//  fmapp
//
//  Created by admin on 17/5/10.
//  Copyright © 2017年 yk. All rights reserved.
//  徽商充值header

#import "XZBankRechargeHeader.h"
#import "XZBankRechargeModel.h"

@interface XZBankRechargeHeader ()
// 快捷充值
@property (nonatomic, strong) UIButton *btnQuick;
// 转账充值
@property (nonatomic, strong) UIButton *btnTransfer;
// 当前正在使用的手机号
@property (nonatomic, strong) UILabel *labelPhone;
// 更换
@property (nonatomic, strong) UIButton *btnChange;
// 开户人
@property (nonatomic, strong) UILabel *labelPerson;
// 开户行
@property (nonatomic, strong) UILabel *labelBankName;
// 账户余额
@property (nonatomic, strong) UILabel *labelMoney;
// 徽商账号
@property (nonatomic, strong) UILabel *labelAcount;
@end

@implementation XZBankRechargeHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpBankRechargeHeader];
    }
    return self;
}

#pragma mark ----- 创建头部
- (void)setUpBankRechargeHeader {
    self.backgroundColor = [HXColor colorWithHexString:@"#f4f5f9"];
    // 白色背景图
    UIView *bgView = [[UIView alloc] init];
    [self addSubview:bgView];
    if (KProjectScreenWidth < 350) {
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.left.equalTo(self).offset(5);
            make.right.equalTo(self).offset(-5);
            make.height.equalTo(@200);
        }];
    }else {
        [bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.left.equalTo(self).offset(5);
            make.right.equalTo(self).offset(-5);
            make.height.equalTo(@210);
        }];
    }
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 5.0;
    
    // 262 67
    UIImageView *imgBankIcon = [[UIImageView alloc] init];
    [bgView addSubview:imgBankIcon];
    [imgBankIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).offset(10);
        make.left.equalTo(bgView).offset(10);
        if (KProjectScreenWidth < 350) {
            make.width.equalTo(@(262 * 0.35));
            make.height.equalTo(@(67 * 0.35));
        }else {
            make.width.equalTo(@(262 * 0.4));
            make.height.equalTo(@(67 * 0.4));
        }
    }];
    imgBankIcon.image = [UIImage imageNamed:@"微商_充值_徽商银行LOGO"];
    
    UILabel *labelTitle = [[UILabel alloc] init];
    [bgView addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.centerY.equalTo(imgBankIcon);
    }];
    labelTitle.text = @"电子交易账户";
    if (KProjectScreenWidth < 350) {
        labelTitle.font = [UIFont systemFontOfSize:15.0f];
    }else {
        labelTitle.font = [UIFont systemFontOfSize:16.0f];
    }
    labelTitle.textColor = XZColor(153, 153, 153);
    
    // 徽商账号
    UILabel *labelAcount = [[UILabel alloc] init];
    [bgView addSubview:labelAcount];
    [labelAcount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgBankIcon.mas_bottom).offset(15);
        make.left.equalTo(bgView).offset(5);
        make.right.equalTo(bgView).offset(-5);
        make.height.equalTo(@30);
    }];
    labelAcount.textAlignment = NSTextAlignmentCenter;
    labelAcount.font = [UIFont systemFontOfSize:18.0f];
    labelAcount.backgroundColor = [HXColor colorWithHexString:@"e8f6ff"];
    self.labelAcount = labelAcount;
    
    // 开户人
    UILabel *labelPerson = [[UILabel alloc] init];
    [bgView addSubview:labelPerson];
    [labelPerson mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelAcount.mas_bottom).offset(20);
        make.left.equalTo(bgView).offset(10);
    }];
    self.labelPerson = labelPerson;
//    labelPerson.textAlignment = NSTextAlignmentCenter;
    
    // 账户余额
    UILabel *labelMoney = [[UILabel alloc] init];
    [bgView addSubview:labelMoney];
    [labelMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelPerson);
        make.left.equalTo(labelPerson.mas_right).offset(30);
    }];
    self.labelMoney = labelMoney;
//    labelMoney.textAlignment = NSTextAlignmentCenter;
    
    // 开户行
//    CGFloat widthBank = [@"开户行" getStringCGSizeWithMaxSize:CGSizeMake(MAXFLOAT, 30) WithFont:[UIFont systemFontOfSize:14.0f]].width;
    UILabel *labelBank = [[UILabel alloc] init];
    [bgView addSubview:labelBank];
    [labelBank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelPerson.mas_bottom).offset(15);
        make.left.equalTo(labelPerson);
//        make.width.equalTo(widthBank);
//        make.right.equalTo(labelAcount);
    }];
//    labelBank.numberOfLines = 0;
    labelBank.text = @"开户行：";
//    self.labelBank = labelBank;
    
    // 开户行
    UILabel *labelBankName = [[UILabel alloc] init];
    [bgView addSubview:labelBankName];
    [labelBankName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(labelBank);
        make.left.equalTo(labelBank.mas_right).priorityHigh();
        make.right.equalTo(labelAcount).priorityLow();
    }];
    labelBankName.numberOfLines = 0;
    self.labelBankName = labelBankName;
    labelBankName.textColor = [HXColor colorWithHexString:@"#FF6633"];
    
    // 设置开户人、账户余额、开户行字体大小
    labelPerson.font = [UIFont systemFontOfSize:14.0f];
    labelMoney.font = [UIFont systemFontOfSize:14.0f];
    labelBank.font = [UIFont systemFontOfSize:14.0f];
    labelBankName.font = [UIFont systemFontOfSize:14.0f];
    
    // 资金存管
    UIImageView *imgIcon = [[UIImageView alloc] init];
    [bgView addSubview:imgIcon];
    [imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelPerson);
        make.top.equalTo(labelBank.mas_bottom).offset(20);
        make.width.equalTo(@(16 * 0.7));
        make.height.equalTo(@(18 * 0.7));
    }];
    imgIcon.image = [UIImage imageNamed:@"微商_充值_注意"];
    
    // 每一笔资金，将充值到您的徽商银行存管账户
    UILabel *labelSave = [[UILabel alloc] init];
    [bgView addSubview:labelSave];
    [labelSave mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgIcon.mas_right).offset(10);
        make.centerY.equalTo(imgIcon);
    }];
    labelSave.text = @"每一笔资金，将充值到您的徽商银行存管账户";
    labelSave.font = [UIFont systemFontOfSize:13.0f];
    labelSave.textColor = XZColor(153, 153, 153);
  
#pragma mark ----- 创建中间部分
    // 转账充值  374 120
    CGFloat width = (KProjectScreenWidth - 1) / 2.0 ;
    UIImageView *imgTransfer = [[UIImageView alloc] init];
    [self addSubview:imgTransfer];
    [imgTransfer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(bgView.mas_bottom).offset(10);
        make.width.equalTo(@(width));
        make.height.equalTo(@(width * 120 / 374.0));
    }];
    imgTransfer.image = [UIImage imageNamed:@"徽商_充值_推荐"];
    imgTransfer.userInteractionEnabled = YES;
    
//    UILabel *labelTransfer = [[UILabel alloc] init];
//    [imgTransfer addSubview:labelTransfer];
//    [labelTransfer mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(imgTransfer);
//        if (KProjectScreenWidth < 350) {
//           make.bottom.equalTo(imgTransfer);
//        }else {
//            make.bottom.equalTo(imgTransfer).offset(-5);
//        }
//    }];
//    labelTransfer.text = @"转账充值送积分";
//    labelTransfer.font = [UIFont systemFontOfSize:13.0f];
//    labelTransfer.textColor = [HXColor colorWithHexString:@"#FF6633"];
    
    //
    UIButton *btnTransfer = [UIButton buttonWithType:UIButtonTypeCustom];
    [imgTransfer addSubview:btnTransfer];
    [btnTransfer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(imgTransfer);
    }];
    [btnTransfer setBackgroundColor:[UIColor clearColor]];
    [btnTransfer setTitle:@"转账充值" forState:UIControlStateNormal];
    [btnTransfer setTitleColor:XZColor(51, 51, 51) forState:UIControlStateNormal];
    [btnTransfer setTitleColor:XZColor(1, 89, 213) forState:UIControlStateSelected];
    btnTransfer.tag = 700;
    [btnTransfer addTarget:self action:@selector(didClickRechargeButton:) forControlEvents:UIControlEventTouchUpInside];
    [btnTransfer.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    self.btnTransfer = btnTransfer;
    
    // 快捷充值
    UIView *viewQuick = [[UIView alloc] init];
    [self addSubview:viewQuick];
    [viewQuick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgTransfer.mas_right).offset(1);
        make.width.equalTo(@(width));
        make.bottom.equalTo(imgTransfer);
        make.height.equalTo(@(width * 110 / 374.0));
    }];
    viewQuick.backgroundColor = [UIColor whiteColor];
 
    //
    UIButton *btnQuick = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewQuick addSubview:btnQuick];
    [btnQuick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(viewQuick);
    }];
    btnQuick.tag = 701;
    [btnQuick setBackgroundColor:[UIColor clearColor]];
    [btnQuick setTitle:@"快捷充值" forState:UIControlStateNormal];
    [btnQuick setTitleColor:XZColor(51, 51, 51) forState:UIControlStateNormal];
    [btnQuick setTitleColor:XZColor(1, 89, 213) forState:UIControlStateSelected];
    [btnQuick addTarget:self action:@selector(didClickRechargeButton:) forControlEvents:UIControlEventTouchUpInside];
    [btnQuick.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    self.btnQuick = btnQuick;
    
#pragma mark ----- 创建中间部分
    // 当前正在使用的手机号
    UILabel *labelPhone = [[UILabel alloc] init];
    [self addSubview:labelPhone];
    [labelPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelPerson);
        make.top.equalTo(imgTransfer.mas_bottom).offset(15);
    }];
    self.labelPhone = labelPhone;
    labelPhone.textColor = XZColor(102, 102, 102);
    labelPhone.font = [UIFont systemFontOfSize:14.0f];
    
    UIButton *btnChange = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btnChange];
    [btnChange mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(labelPhone);
    }];
    [btnChange setTitle:@"更换" forState:UIControlStateNormal];
    [btnChange setTitleColor:XZColor(1, 89, 213) forState:UIControlStateNormal];
    [btnChange.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [btnChange addTarget:self action:@selector(didClickRechargeButton:) forControlEvents:UIControlEventTouchUpInside];
    btnChange.tag = 702;
    self.btnChange = btnChange;
    
}

- (void)didClickRechargeButton:(UIButton *)button {
    if (self.blockRecharge) {
        self.blockRecharge(button);
    }
}

- (void)setModelBankUser:(XZBankRechargeUserModel *)modelBankUser {
    _modelBankUser = modelBankUser;
//    NSLog(@"头视图中的值 ===== %d",modelBankUser.isQuickPay);
    if (modelBankUser.isQuickPay) { // 是快捷充值
        self.btnQuick.selected = YES;
        self.btnTransfer.selected = NO;
        if (modelBankUser.mobile) {
           self.labelPhone.text = [NSString stringWithFormat:@"您正在使用的手机号：%@",modelBankUser.mobile];
        }else {
            self.labelPhone.text = [NSString stringWithFormat:@"您正在使用的手机号："];
        }
        self.btnChange.hidden = NO;
    }else { // 是转账充值
        self.btnQuick.selected = NO;
        self.btnTransfer.selected = YES;
        self.labelPhone.text = [NSString stringWithFormat:@"转账充值方式"];
        self.btnChange.hidden = YES;
    }
    
    
    // 让某些文字变橙色
    NSMutableAttributedString *(^makeStirngOrange)(NSString *,NSString *) = ^(NSString *orange,NSString *black) {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:orange];
        NSInteger length = [orange length];
        NSInteger lenBlack = [black length];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[HXColor colorWithHexString:@"#FF6633"] range:NSMakeRange(lenBlack, length - lenBlack)];
        return  attrStr;
    };

    if (modelBankUser.acctname) {
        
        NSString *acctname = [modelBankUser.acctname stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"*"];
        self.labelPerson.attributedText = makeStirngOrange([NSString stringWithFormat:@"开户人：%@",acctname],@"开户人：");
    }else {
        self.labelPerson.text = @"开户人：";
    }
    
    if (modelBankUser.cardnbr) {
        // @"6236 6400 1000 0155 209"
        NSMutableArray *numberArr = [NSMutableArray array];
        int length = modelBankUser.cardnbr.length % 4 == 0 ? (int)(modelBankUser.cardnbr.length / 4) : (int)(modelBankUser.cardnbr.length / 4 + 1);
        for (int i = 0; i < length; i++) {
            int begin = i * 4;
            int end = (i * 4 + 4) > (int) modelBankUser.cardnbr.length ? (int)(modelBankUser.cardnbr.length) : (i * 4 + 4);
            
            NSString *subString = [modelBankUser.cardnbr substringWithRange:NSMakeRange(begin, end - begin)];
            
            [numberArr addObject:subString];
//            NSLog(@"%d ======= %d ====== %@",begin,end,subString);
        }
        
        NSString *cardnbr = @"";
        for (int i = 0; i < length; i++) {
            cardnbr = [cardnbr stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"%@ ",numberArr[i]]];
        }
        self.labelAcount.text = cardnbr;
//        NSLog(@"cardnbr ========= %@",cardnbr);
    }
    
    if (modelBankUser.acctAmt) {
        self.labelMoney.attributedText = makeStirngOrange([NSString stringWithFormat:@"账户余额：%.2f元",modelBankUser.acctAmt],@"账户余额：");
    }else if (modelBankUser.acctAmt == 0)  {
        self.labelMoney.attributedText = makeStirngOrange([NSString stringWithFormat:@"账户余额：%.2f元",modelBankUser.acctAmt],@"账户余额：");
    }else {
        self.labelMoney.text = @"账户余额：";
    }
    
    self.labelBankName.text = modelBankUser.bankName;
//    makeStirngOrange([NSString stringWithFormat:@"开户行：%@",modelBankUser.bankName],@"开户行：");
    
}

@end
