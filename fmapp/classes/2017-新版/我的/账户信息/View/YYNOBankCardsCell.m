//
//  YYNOBankCardsCell.m
//  fmapp
//
//  Created by yushibo on 2017/2/24.
//  Copyright © 2017年 yk. All rights reserved.
//  未绑定银行卡

#import "YYNOBankCardsCell.h"

@interface YYNOBankCardsCell ()
/**   */
@property (nonatomic, strong) UILabel *upLabel;
/**   */
@property (nonatomic, strong) UILabel *downLabel;
@end
@implementation YYNOBankCardsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
    }
    return self;
}
- (void)createContentView{

    UILabel *upLabel = [[UILabel alloc]init];
    upLabel.text = @"您尚未绑定快捷充值卡";
    self.upLabel = upLabel;
    upLabel.font = [UIFont systemFontOfSize:14];
    upLabel.textColor = [HXColor colorWithHexString:@"#666666"];
    [self.contentView addSubview:upLabel];
    [upLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(20);
    }];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"感叹号-icon_1702"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:imageView];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(upLabel.mas_bottom).offset(16);
        make.left.equalTo(upLabel.mas_left).offset(1);
        
    }];

    UILabel *downLabel = [[UILabel alloc]init];
    downLabel.text = @"绑定后,此卡将同时成为您的默认取现卡";
    self.downLabel = downLabel;
    downLabel.font = [UIFont systemFontOfSize:13];
    downLabel.textColor = [HXColor colorWithHexString:@"#999999"];
    [self.contentView addSubview:downLabel];
    [downLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(4);
        make.centerY.equalTo(imageView.mas_centerY);
    }];
}

-(void)setBankTag:(NSString *)bankTag{
    
    if ([bankTag integerValue] == 1) {
        self.upLabel.text = @"您尚未绑定快捷充值卡";
        self.downLabel.text = @"绑定后,此卡将同时成为您的默认取现卡";
    }else{
        self.upLabel.text = @"新增提现银行卡";
        self.downLabel.text = @"只能绑定您本人名下的银行储蓄卡";
    }

    
}
@end
