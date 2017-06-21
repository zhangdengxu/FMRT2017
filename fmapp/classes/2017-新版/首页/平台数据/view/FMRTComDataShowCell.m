//
//  FMRTComDataShowCell.m
//  fmapp
//
//  Created by apple on 2017/2/24.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRTComDataShowCell.h"

@interface FMRTComDataShowCell ()

@property (nonatomic, weak)UILabel *countLabel,*leijicountLabel,*countLabel2,*leijicountLabel2,*countLabel3,*leijicountLabel3,*comExLabel;

@property (nonatomic, weak)UIView *whiteView,*whiteView2,*whiteView3;

@end

@implementation FMRTComDataShowCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.contentView.backgroundColor = XZColor(249, 249, 249);
        [self createContentView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)createContentView{
    
    UILabel *comExLabel = [[UILabel alloc]init];
    comExLabel.text = @"企业数据预览";
    self.comExLabel = comExLabel;
    comExLabel.font = [UIFont systemFontOfSize:25];
    comExLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:comExLabel];
    [comExLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.contentView.centerX);
        make.top.equalTo(self.contentView.top).offset(30);
    }];
    
    UIView *whiteView = [[UIView alloc]init];
    self.whiteView = whiteView;
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = 5;
    whiteView.layer.borderWidth = 1;
    whiteView.layer.borderColor = [HXColor colorWithHexString:@"#e4ebf1"].CGColor;
    [self.contentView addSubview:whiteView];
    [whiteView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.left).offset(30);
        make.top.equalTo(comExLabel.bottom).offset(30);
        make.right.equalTo(self.contentView.right).offset(-30);
        make.height.equalTo(@250);
    }];
    
    UIView *roundView = [[UIView alloc]init];
    roundView.layer.cornerRadius = 90;
    roundView.backgroundColor = [UIColor colorWithHexString:@"#b7ddf4"];
    [whiteView addSubview:roundView];
    [roundView makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(whiteView.centerX);
        make.top.equalTo(whiteView.top).offset(15);
        make.height.equalTo(@180);
        make.width.equalTo(@180);
    }];
    
    UILabel *countLabel = [[UILabel alloc]init];
    self.countLabel = countLabel;
//    countLabel.text = @"30家";
    countLabel.font = [UIFont systemFontOfSize:18];
    countLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [roundView addSubview:countLabel];
    [countLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(roundView.centerX);
        make.centerY.equalTo(roundView.centerY).offset(-10);
    }];
    
    UILabel *counttext = [[UILabel alloc]init];
    counttext.text = @"供应链核心企业";
    counttext.font = [UIFont systemFontOfSize:15];
    counttext.textColor = [UIColor colorWithHexString:@"#333333"];
    [roundView addSubview:counttext];
    [counttext makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(roundView.centerX);
        make.centerY.equalTo(roundView.centerY).offset(25);
    }];
    
    UILabel *leijicountLabel = [[UILabel alloc]init];
    self.leijicountLabel = leijicountLabel;
    leijicountLabel.font = [UIFont systemFontOfSize:15];
    leijicountLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [roundView addSubview:leijicountLabel];
    [leijicountLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(roundView.centerX);
        make.centerY.equalTo(roundView.bottom).offset(26);
    }];
    
    UIView *whiteView2 = [[UIView alloc]init];
    self.whiteView2 = whiteView2;
    whiteView2.backgroundColor = [UIColor whiteColor];
    whiteView2.layer.cornerRadius = 5;
    whiteView2.layer.borderWidth = 1;
    whiteView2.layer.borderColor = [HXColor colorWithHexString:@"#e4ebf1"].CGColor;
    [self.contentView addSubview:whiteView2];
    [whiteView2 makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.left).offset(30);
        make.top.equalTo(whiteView.bottom).offset(30);
        make.right.equalTo(self.contentView.right).offset(-30);
        make.height.equalTo(@250);
    }];
    
    UIView *roundView2 = [[UIView alloc]init];
    roundView2.layer.cornerRadius = 90;
    roundView2.backgroundColor = [UIColor colorWithHexString:@"#f4e9dd"];
    [whiteView2 addSubview:roundView2];
    [roundView2 makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(whiteView2.centerX);
        make.top.equalTo(whiteView2.top).offset(15);
        make.height.equalTo(@180);
        make.width.equalTo(@180);
    }];
    
    UILabel *countLabel2 = [[UILabel alloc]init];
    self.countLabel2 = countLabel2;
    countLabel2.font = [UIFont systemFontOfSize:18];
    countLabel2.textColor = [UIColor colorWithHexString:@"#333333"];
    [roundView2 addSubview:countLabel2];
    [countLabel2 makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(roundView2.centerX);
        make.centerY.equalTo(roundView2.centerY).offset(-10);
    }];
    
    UILabel *counttext2 = [[UILabel alloc]init];
    counttext2.text = @"供应链付款企业";
    counttext2.font = [UIFont systemFontOfSize:15];
    counttext2.textColor = [UIColor colorWithHexString:@"#333333"];
    [roundView2 addSubview:counttext2];
    [counttext2 makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(roundView2.centerX);
        make.centerY.equalTo(roundView2.centerY).offset(25);
    }];
    
    UILabel *leijicountLabel2 = [[UILabel alloc]init];
    self.leijicountLabel2 = leijicountLabel2;
    leijicountLabel2.font = [UIFont systemFontOfSize:15];
    leijicountLabel2.textColor = [UIColor colorWithHexString:@"#333333"];
    [roundView2 addSubview:leijicountLabel2];
    [leijicountLabel2 makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(roundView2.centerX);
        make.centerY.equalTo(roundView2.bottom).offset(26);
    }];
    
    
    UIView *whiteView3 = [[UIView alloc]init];
    self.whiteView3 = whiteView3;
    whiteView3.backgroundColor = [UIColor whiteColor];
    whiteView3.layer.cornerRadius = 5;
    whiteView3.layer.borderWidth = 1;
    whiteView3.layer.borderColor = [HXColor colorWithHexString:@"#e4ebf1"].CGColor;
    [self.contentView addSubview:whiteView3];
    [whiteView3 makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.left).offset(30);
        make.top.equalTo(whiteView2.bottom).offset(30);
        make.right.equalTo(self.contentView.right).offset(-30);
        make.height.equalTo(@250);
    }];
    
    UIView *roundView3 = [[UIView alloc]init];
    roundView3.layer.cornerRadius = 90;
    roundView3.backgroundColor = [UIColor colorWithHexString:@"#f4ced5"];
    [whiteView3 addSubview:roundView3];
    [roundView3 makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(whiteView3.centerX);
        make.top.equalTo(whiteView3.top).offset(15);
        make.height.equalTo(@180);
        make.width.equalTo(@180);
    }];
    
    UILabel *countLabel3 = [[UILabel alloc]init];
    self.countLabel3 = countLabel3;
    countLabel3.font = [UIFont systemFontOfSize:18];
    countLabel3.textColor = [UIColor colorWithHexString:@"#333333"];
    [roundView3 addSubview:countLabel3];
    [countLabel3 makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(roundView3.centerX);
        make.centerY.equalTo(roundView3.centerY).offset(-10);
    }];
    
    UILabel *counttext3 = [[UILabel alloc]init];
    counttext3.text = @"供应链融资企业";
    counttext3.font = [UIFont systemFontOfSize:15];
    counttext3.textColor = [UIColor colorWithHexString:@"#333333"];
    [roundView3 addSubview:counttext3];
    [counttext3 makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(roundView3.centerX);
        make.centerY.equalTo(roundView3.centerY).offset(25);
    }];
    
    UILabel *leijicountLabel3 = [[UILabel alloc]init];
    self.leijicountLabel3 = leijicountLabel3;
    leijicountLabel3.numberOfLines = 0;
    leijicountLabel3.textAlignment = NSTextAlignmentCenter;
    leijicountLabel3.font = [UIFont systemFontOfSize:15];
    leijicountLabel3.textColor = [UIColor colorWithHexString:@"#333333"];
    [roundView3 addSubview:leijicountLabel3];
    [leijicountLabel3 makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(roundView3.centerX);
        make.centerY.equalTo(roundView3.bottom).offset(26);
    }];
}

- (void)setModel:(Ent *)model{
    _model = model;

    if (model) {
        self.countLabel.text = [NSString stringWithFormat:@"%@",model.Core.CoreSum];
        self.leijicountLabel.text = [NSString stringWithFormat:@"累计承付项目%@个",model.Core.ProjSum];
        self.countLabel2.text = [NSString stringWithFormat:@"%@家",model.Paid.PaidSum];
        self.leijicountLabel2.text = [NSString stringWithFormat:@"付款完成项目%@个",model.Paid.PaidProjSum];
        self.countLabel3.text = [NSString stringWithFormat:@"%@家",model.Loan.LoanSum];
        self.leijicountLabel3.text =[NSString stringWithFormat:@"融资项目平均金额%@万元\n企业融资成本%@%%-%@%%",model.Loan.LoadAvgMoney,model.Loan.MinLoanCost,model.Loan.MaxLoanCost];
        
        [self.comExLabel setHidden:NO];

        
        if (model.Core && model.Paid &&model.Loan) {
            [self.whiteView setHidden:NO];
            [self.whiteView2 setHidden:NO];
            [self.whiteView3 setHidden:NO];
        }else if(!model.Core && model.Paid &&model.Loan){
            [self.whiteView setHidden:YES];
            [self.whiteView2 setHidden:NO];
            [self.whiteView3 setHidden:NO];
            [self.whiteView updateConstraints:^(MASConstraintMaker *make) {

                make.height.equalTo(@0);
            }];
            
        }else if(model.Core && !model.Paid &&model.Loan){
            [self.whiteView setHidden:NO];
            [self.whiteView2 setHidden:YES];
            [self.whiteView3 setHidden:NO];
            [self.whiteView2 updateConstraints:^(MASConstraintMaker *make) {
                
                make.height.equalTo(@0);
            }];
        }else if(model.Core && model.Paid &&!model.Loan){
            [self.whiteView setHidden:NO];
            [self.whiteView2 setHidden:NO];
            [self.whiteView3 setHidden:YES];
            [self.whiteView3 updateConstraints:^(MASConstraintMaker *make) {
                
                make.height.equalTo(@0);
            }];
        }else if(!model.Core && !model.Paid &&model.Loan){
            [self.whiteView setHidden:YES];
            [self.whiteView2 setHidden:YES];
            [self.whiteView3 setHidden:NO];
            [self.whiteView updateConstraints:^(MASConstraintMaker *make) {
                
                make.height.equalTo(@0);
            }];
            
            [self.whiteView2 updateConstraints:^(MASConstraintMaker *make) {
                
                make.height.equalTo(@0);
            }];
        }else if(!model.Core && model.Paid &&!model.Loan){
            [self.whiteView setHidden:YES];
            [self.whiteView2 setHidden:NO];
            [self.whiteView3 setHidden:YES];
            [self.whiteView updateConstraints:^(MASConstraintMaker *make) {
                
                make.height.equalTo(@0);
            }];
            [self.whiteView3 updateConstraints:^(MASConstraintMaker *make) {
                
                make.height.equalTo(@0);
            }];
            
        }else if(model.Core && !model.Paid &&!model.Loan){
            [self.whiteView setHidden:NO];
            [self.whiteView2 setHidden:YES];
            [self.whiteView3 setHidden:YES];
            [self.whiteView2 updateConstraints:^(MASConstraintMaker *make) {
                
                make.height.equalTo(@0);
            }];
            
            [self.whiteView3 updateConstraints:^(MASConstraintMaker *make) {
                
                make.height.equalTo(@0);
            }];
        }else{
            [self.comExLabel setHidden:YES];
            [self.whiteView setHidden:YES];
            [self.whiteView2 setHidden:YES];
            [self.whiteView3 setHidden:YES];
        }
        
    }else{
        [self.comExLabel setHidden:YES];
        [self.whiteView setHidden:YES];
        [self.whiteView2 setHidden:YES];
        [self.whiteView3 setHidden:YES];
    }
}

+(CGFloat)heightForCellWithModel:(Ent *)model{
    
    if (model) {
        
        if (model.Core && model.Paid &&model.Loan) {
            return 900;
        }else if(!model.Core && model.Paid &&model.Loan){
            return 660;
        }else if(model.Core && !model.Paid &&model.Loan){
            return 660;
        }else if(model.Core && model.Paid &&!model.Loan){
            return 660;
        }else if(!model.Core && !model.Paid &&model.Loan){
            return 360;
        }else if(!model.Core && model.Paid &&!model.Loan){
            return 360;

        }else if(model.Core && !model.Paid &&!model.Loan){
            return 360;

        }else{
            return 0;
        }
        
    }else{
        return 0;
    }
}


@end
