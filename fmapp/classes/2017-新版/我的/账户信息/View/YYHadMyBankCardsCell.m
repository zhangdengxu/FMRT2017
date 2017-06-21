//
//  YYHadMyBankCardsCell.m
//  fmapp
//
//  Created by yushibo on 2017/2/24.
//  Copyright © 2017年 yk. All rights reserved.
//  已绑定

#import "YYHadMyBankCardsCell.h"

@interface YYHadMyBankCardsCell ()
/**  银行名字 */
@property (nonatomic, strong) UILabel *bankNameLabel;
/**  卡类型 */
@property (nonatomic, strong) UILabel *typeLabel;
/**  银行卡号 */
@property (nonatomic, strong) UILabel *numBankLabel;

/**  银行图标 */
@property (nonatomic, strong) UIImageView *iconBankView;
@end
@implementation YYHadMyBankCardsCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    
    UIImageView *upView = [[UIImageView alloc]init];
    upView.image = [UIImage imageNamed:@"银行卡背景-（上半部分）_1702"];
    upView.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:upView];
    [upView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.contentView.mas_top).offset(13);
    }];
    
    UIImageView *downView = [[UIImageView alloc]init];
    
    
    downView.image = [UIImage imageNamed:@"银行卡背景-下半部分_1702"];
    downView.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:downView];
    [downView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(upView.mas_bottom);
    }];

    
    UILabel *bankNameLabel = [[UILabel alloc]init];
//    bankNameLabel.text = @"中国工商银行";
    self.bankNameLabel = bankNameLabel;
    bankNameLabel.font = [UIFont systemFontOfSize:14];
    bankNameLabel.textColor = [HXColor colorWithHexString:@"#333333"];
    [upView addSubview:bankNameLabel];
    [bankNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(upView.mas_left).offset(15);
        make.centerY.equalTo(upView.mas_centerY);
    }];
    UILabel *typeLabel = [[UILabel alloc]init];
//    typeLabel.text = @"快捷卡";
    self.typeLabel = typeLabel;
    typeLabel.font = [UIFont systemFontOfSize:13];
    typeLabel.textColor = [HXColor colorWithHexString:@"#333333"];
    [upView addSubview:typeLabel];
    [typeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(upView.mas_right).offset(-15);
        make.centerY.equalTo(upView.mas_centerY);
    }];

    UIImageView *iconBankView = [[UIImageView alloc]init];
//    iconBankView.image = [UIImage imageNamed:@"兴业银行icon_12"];
    self.iconBankView = iconBankView;
//    iconBankView.contentMode = UIViewContentModeScaleAspectFit;
    [downView addSubview:iconBankView];
    [iconBankView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(downView.mas_centerY);
        make.left.equalTo(downView.mas_left).offset(15);
        make.width.height.equalTo(41);
        
    }];

    UILabel *numBankLabel = [[UILabel alloc]init];
//    numBankLabel.text = @"**** **** **** 9800";
    self.numBankLabel = numBankLabel;
    numBankLabel.font = [UIFont systemFontOfSize:15];
    numBankLabel.textColor = [HXColor colorWithHexString:@"#333333"];
    [downView addSubview:numBankLabel];
    [numBankLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconBankView.mas_right).offset(15);
        make.centerY.equalTo(iconBankView.mas_centerY);
    }];

}

-(void)setModel:(YYQuickCardsModel *)model{

    self.numBankLabel.text = model.No;
    self.bankNameLabel.text = model.BankName;
    
    [self.iconBankView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.BankLogo]] placeholderImage:[UIImage imageNamed:@"占位图_1702"]];
    
    if ([model.bankTag integerValue] == 1) {
        self.typeLabel.text = @"快捷卡";

    }else{
        
        if (model.Default == 0) {
            self.typeLabel.text = @"取现卡";
            
        }else{
            
            self.typeLabel.text = @"默认取现卡";
        }
    }
    
}
@end
