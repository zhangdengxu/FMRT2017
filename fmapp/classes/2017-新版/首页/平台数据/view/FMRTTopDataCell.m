//
//  FMRTTopDataCell.m
//  fmapp
//
//  Created by apple on 2017/2/24.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRTTopDataCell.h"
#import "FMRTPlatformModel.h"

@interface FMRTTopDataCell ()

@property (nonatomic, weak) UILabel *topYulanLabel,*cishuLabel,*zhuceLabel,*shouyiLabel,*cehngjiaoText,*chengbenLabel,*thirdlcomLabel,*lishiLabel;
@property (nonatomic, weak) UIImageView *yulanlView,*chengjiaolView,*thirdlView;

@end

@implementation FMRTTopDataCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.contentView.backgroundColor = XZColor(249, 249, 249);
        [self setUpHeaderView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setUpHeaderView{
    
    UILabel *shujuyulanLabel = [[UILabel alloc]init];
//    shujuyulanLabel.text = @"数据预览";
    self.topYulanLabel = shujuyulanLabel;
    shujuyulanLabel.font = [UIFont systemFontOfSize:25];
    shujuyulanLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:shujuyulanLabel];
    [shujuyulanLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView.top).offset(34);
        make.centerX.equalTo(self.contentView.centerX);
    }];
    
    UIImageView *yulanlView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"平台数据_1_1702"]];
    self.yulanlView = yulanlView;
    [self.contentView addSubview:yulanlView];
    [yulanlView makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView.right).offset(-15);
        make.left.equalTo(self.contentView.left).offset(15);
        make.top.equalTo(shujuyulanLabel.bottom).offset(-45);
        make.height.equalTo((KProjectScreenWidth - 30)/670*288);
    }];
    
    NSInteger labelX = 0;
    if (KProjectScreenWidth >=375) {
        labelX = 60;
    }else{
        labelX = 35;
    }
    
    UILabel *cishuLabel = [[UILabel alloc]init];
    self.cishuLabel = cishuLabel;
//    cishuLabel.text = @"•  投资次数   234235234次";
    cishuLabel.font = [UIFont systemFontOfSize:18];
    cishuLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [yulanlView addSubview:cishuLabel];
    [cishuLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(yulanlView.left).offset(labelX);
        make.centerY.equalTo(yulanlView.centerY);
    }];
    
    UILabel *zhuceLabel = [[UILabel alloc]init];
    self.zhuceLabel = zhuceLabel;
//    zhuceLabel.text = @"•  注册用户   102340人";
    zhuceLabel.font = [UIFont systemFontOfSize:18];
    zhuceLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [yulanlView addSubview:zhuceLabel];
    [zhuceLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(yulanlView.left).offset(labelX);
        make.bottom.equalTo(cishuLabel.top).offset(-20);
    }];
    
    UILabel *shouyiLabel = [[UILabel alloc]init];
    self.shouyiLabel = shouyiLabel;
//    shouyiLabel.text = @"•  投资收益   1232423.09万元";
    shouyiLabel.font = [UIFont systemFontOfSize:18];
    shouyiLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [yulanlView addSubview:shouyiLabel];
    [shouyiLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(yulanlView.left).offset(labelX);
        make.top.equalTo(cishuLabel.bottom).offset(20);
    }];
    
    
    UIImageView *chengjiaolView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"平台数据_2_1702"]];
    self.chengjiaolView = chengjiaolView;
    [self.contentView addSubview:chengjiaolView];
    [chengjiaolView makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView.right).offset(-15);
        make.left.equalTo(self.contentView.left).offset(15);
        make.top.equalTo(yulanlView.bottom).offset(20);
        make.height.equalTo((KProjectScreenWidth - 30)/670*288);
    }];
    
    UILabel *chengjiaoLabel = [[UILabel alloc]init];
    chengjiaoLabel.text = @"累计成交金额";
    chengjiaoLabel.font = [UIFont systemFontOfSize:20];
    chengjiaoLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [chengjiaolView addSubview:chengjiaoLabel];
    [chengjiaoLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(chengjiaolView.centerX);
        make.top.equalTo(chengjiaolView.top).offset(40);
    }];
    
    UILabel *cehngjiaoText = [[UILabel alloc]init];
    self.cehngjiaoText = cehngjiaoText;
//    cehngjiaoText.text = @"12.89亿元";
    cehngjiaoText.font = [UIFont boldSystemFontOfSize:25];
    cehngjiaoText.textColor = [UIColor colorWithHexString:@"#ff3366"];
    [chengjiaolView addSubview:cehngjiaoText];
    [cehngjiaoText makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(chengjiaolView.centerX);
        make.top.equalTo(chengjiaoLabel.bottom).offset(20);
    }];
    
    UIImageView *thirdlView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"平台数据_3_1702"]];
    self.thirdlView = thirdlView;
    [self.contentView addSubview:thirdlView];
    [thirdlView makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView.right).offset(-15);
        make.left.equalTo(self.contentView.left).offset(15);
        make.top.equalTo(chengjiaolView.bottom).offset(20);
        make.height.equalTo((KProjectScreenWidth - 30)/670*288);
    }];
    
    
    UILabel *chengbenLabel = [[UILabel alloc]init];
    self.chengbenLabel =chengbenLabel;
//    chengbenLabel.text = @"•  融资成本  10%-15%";
    chengbenLabel.font = [UIFont systemFontOfSize:18];
    chengbenLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [thirdlView addSubview:chengbenLabel];
    [chengbenLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(thirdlView.left).offset(labelX);
        make.centerY.equalTo(thirdlView.centerY);
    }];
    
    UILabel *thirdlcomLabel = [[UILabel alloc]init];
    self.thirdlcomLabel = thirdlcomLabel;
//    thirdlcomLabel.text = @"•  已服务企业   450家";
    thirdlcomLabel.font = [UIFont systemFontOfSize:18];
    thirdlcomLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [thirdlView addSubview:thirdlcomLabel];
    [thirdlcomLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(thirdlView.left).offset(labelX);
        make.bottom.equalTo(chengbenLabel.top).offset(-20);
    }];
    
    UILabel *lishiLabel = [[UILabel alloc]init];
    self.lishiLabel = lishiLabel;
//    lishiLabel.text = @"•  历史按时付款率  100%";
    lishiLabel.font = [UIFont systemFontOfSize:18];
    lishiLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [thirdlView addSubview:lishiLabel];
    [lishiLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(thirdlView.left).offset(labelX);
        make.top.equalTo(chengbenLabel.bottom).offset(20);
    }];
}

- (void)setModel:(FMOverViewModel *)model{
    _model = model;

    if (!model) {
        [self.topYulanLabel setHidden:YES];
        [self.yulanlView setHidden:YES];
        [self.chengjiaolView setHidden:YES];
        [self.thirdlView setHidden:YES];
    }else{
        [self.topYulanLabel setHidden:NO];
        
        if ([model.User.BidSum doubleValue]) {

            NSString *ciall = [NSString stringWithFormat:@"•  投资次数   %@次", model.User.BidSum];
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:ciall];
            
            NSRange range = NSMakeRange(ciall.length - 1, 1);
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:range];
            
            self.cishuLabel.attributedText = attrStr;
            
        }
        if ([model.User.UserSum doubleValue]) {

            NSString *ciall = [NSString stringWithFormat:@"•  注册用户   %@人", model.User.UserSum];
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:ciall];
            
            NSRange range = NSMakeRange(ciall.length - 1, 1);
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:range];
            
            self.zhuceLabel.attributedText = attrStr;
            
        }
        if ([model.User.IncomeAmt doubleValue]) {
            
            NSString *ciall = [NSString stringWithFormat:@"•  投资收益   %@万元", model.User.IncomeAmt];
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:ciall];
            
            NSRange range = NSMakeRange(ciall.length - 2, 2);
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:range];
            
            self.shouyiLabel.attributedText = attrStr;
        }

        if ([model.DealAmt doubleValue]) {
            self.cehngjiaoText.text = [NSString stringWithFormat:@"%@亿元", model.DealAmt];
        }
        
        if ([model.Company.MaxCost doubleValue] && [model.Company.MinCost doubleValue]) {
//            self.chengbenLabel.text = [NSString stringWithFormat:@"•  融资成本  %@%%-%@%%",model.Company.MinCost,model.Company.MaxCost];
            
            NSString *trr = @"%";
            NSString *srr = @"%";
            NSString *ciall = [NSString stringWithFormat:@"•  融资成本  %@%@-%@%@",model.Company.MinCost,trr,model.Company.MaxCost,srr];
            NSRange range =  [ciall rangeOfString:trr];
            NSRange range2 =  NSMakeRange(ciall.length - 1, 1);

            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:ciall];
            
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:range];
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:range2];

            self.chengbenLabel.attributedText = attrStr;
        }
        
        if ([model.Company.CompanySum doubleValue]) {
            NSString *ciall = [NSString stringWithFormat:@"•  已服务企业   %@家",model.Company.CompanySum];
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:ciall];
            
            NSRange range = NSMakeRange(ciall.length - 1, 1);
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:range];
            
            self.thirdlcomLabel.attributedText = attrStr;
        }
        
        if (model.Company.RepayRate) {
            
            NSString *ciall = [NSString stringWithFormat:@"•  历史按时付款率  %g%%",model.Company.RepayRate];
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:ciall];
            
            NSRange range = NSMakeRange(ciall.length - 1, 1);
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:range];
            
            self.lishiLabel.attributedText = attrStr;
        }
        
        if (model.User && model.Company && [model.DealAmt integerValue]) {
            [self.yulanlView setHidden:NO];
            [self.chengjiaolView setHidden:NO];
            [self.thirdlView setHidden:NO];

        }else if(model.User && model.Company && ![model.DealAmt integerValue]){
            [self.yulanlView setHidden:NO];
            [self.chengjiaolView setHidden:YES];
            [self.thirdlView setHidden:NO];
            
            [self.chengjiaolView updateConstraints:^(MASConstraintMaker *make) {
            
                make.height.equalTo(@0);
            }];
            
        }else if(!model.User && model.Company && [model.DealAmt integerValue]){
            [self.yulanlView setHidden:YES];
            [self.chengjiaolView setHidden:NO];
            [self.thirdlView setHidden:NO];
            
            [self.yulanlView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            
        }else if(model.User && !model.Company && [model.DealAmt integerValue]){
            [self.yulanlView setHidden:NO];
            [self.chengjiaolView setHidden:NO];
            [self.thirdlView setHidden:YES];
            
            [self.thirdlView updateConstraints:^(MASConstraintMaker *make) {
                
                make.height.equalTo(@0);
            }];
            
        }else if(model.User && !model.Company && ![model.DealAmt integerValue]){
            [self.yulanlView setHidden:NO];
            [self.chengjiaolView setHidden:YES];
            [self.thirdlView setHidden:YES];
            
            [self.thirdlView updateConstraints:^(MASConstraintMaker *make) {
                
                make.height.equalTo(@0);
            }];
            
            [self.chengjiaolView updateConstraints:^(MASConstraintMaker *make) {
                
                make.height.equalTo(@0);
            }];
            
        }else if(!model.User && model.Company && ![model.DealAmt integerValue]){
            [self.yulanlView setHidden:YES];
            [self.chengjiaolView setHidden:YES];
            [self.thirdlView setHidden:NO];
            
            [self.yulanlView updateConstraints:^(MASConstraintMaker *make) {
                
                make.height.equalTo(@0);
            }];
            
            [self.chengjiaolView updateConstraints:^(MASConstraintMaker *make) {
                
                make.height.equalTo(@0);
            }];
        }else if(!model.User && !model.Company && [model.DealAmt integerValue]){
            [self.yulanlView setHidden:YES];
            [self.chengjiaolView setHidden:NO];
            [self.thirdlView setHidden:YES];
            
            [self.thirdlView updateConstraints:^(MASConstraintMaker *make) {
                
                make.height.equalTo(@0);
            }];
            
            [self.yulanlView updateConstraints:^(MASConstraintMaker *make) {
                
                make.height.equalTo(@0);
            }];
        }
        
        if (model.User) {
            if (![model.User.UserSum integerValue] && [model.User.BidSum integerValue] && [model.User.IncomeAmt integerValue] ) {
                
                [self.cishuLabel updateConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self.yulanlView.centerY).offset(-25);
                }];
                
            }else if ([model.User.UserSum integerValue] && ![model.User.BidSum integerValue] && [model.User.IncomeAmt integerValue] ){
                
                [self.zhuceLabel updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.cishuLabel.top).offset(-10);
                }];
                
                [self.shouyiLabel updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.cishuLabel.bottom).offset(10);
                }];
                
            }else if ([model.User.UserSum integerValue] && [model.User.BidSum integerValue] && ![model.User.IncomeAmt integerValue] ){
                
                [self.cishuLabel updateConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self.yulanlView.centerY).offset(25);
                }];
                
            }else if (![model.User.UserSum integerValue] && ![model.User.BidSum integerValue] && [model.User.IncomeAmt integerValue] ){
                
                [self.shouyiLabel updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.cishuLabel.bottom).offset(-15);
                }];
                
            }else if ([model.User.UserSum integerValue] && ![model.User.BidSum integerValue] && ![model.User.IncomeAmt integerValue] ){
                
                [self.zhuceLabel updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.cishuLabel.top).offset(15);
                }];
            }
        }
        if (model.Company) {
            if (![model.Company.CompanySum integerValue] && model.Company.RepayRate && [model.Company.MinCost integerValue] && [model.Company.MinCost integerValue]) {
                
                [self.chengbenLabel updateConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self.thirdlView.centerY).offset(-20);
                }];
                
            }else if ([model.Company.CompanySum integerValue] && !model.Company.RepayRate && [model.Company.MinCost integerValue] && [model.Company.MinCost integerValue]){
                
                [self.chengbenLabel updateConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self.thirdlView.centerY).offset(20);
                }];
            }else if ([model.Company.CompanySum integerValue] && model.Company.RepayRate && ![model.Company.MinCost integerValue] && ![model.Company.MinCost integerValue]){
                
                [self.thirdlcomLabel updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.chengbenLabel.top).offset(-10);
                }];
                
                [self.lishiLabel updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.chengbenLabel.bottom).offset(10);
                }];
                
            }else if ([model.Company.CompanySum integerValue] && !model.Company.RepayRate && ![model.Company.MinCost integerValue] && ![model.Company.MinCost integerValue]){
                
                [self.thirdlcomLabel updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.chengbenLabel.top).offset(15);
                }];
                
            }else if (![model.Company.CompanySum integerValue] && model.Company.RepayRate && ![model.Company.MinCost integerValue] && ![model.Company.MinCost integerValue]){
                
                [self.lishiLabel updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.chengbenLabel.bottom).offset(-15);
                }];
            }
        }
    }
}

+ (CGFloat)hightForTopDataCellWith:(FMOverViewModel *)model{
    
    if (model.User && model.Company && [model.DealAmt integerValue]) {
        return (KProjectScreenWidth - 30)/670*288*3+30+60+80;
    }else if(model.User && model.Company && ![model.DealAmt integerValue]){
        return (KProjectScreenWidth - 30)/670*288*2+30+40+60;
    }else if(!model.User && model.Company && [model.DealAmt integerValue]){
        return (KProjectScreenWidth - 30)/670*288*2+30+40+60;
    }else if(model.User && !model.Company && [model.DealAmt integerValue]){
        return (KProjectScreenWidth - 30)/670*288*2+30+40+60;
    }else if(model.User && !model.Company && ![model.DealAmt integerValue]){
        return (KProjectScreenWidth - 30)/670*288*1+30+80;
    }else if(!model.User && model.Company && ![model.DealAmt integerValue]){
        return (KProjectScreenWidth - 30)/670*288*1+30+80;
    }else if(!model.User && !model.Company && [model.DealAmt integerValue]){
        return (KProjectScreenWidth - 30)/670*288*1+30+80;
    }else{
        return 0;
    }
}


@end
