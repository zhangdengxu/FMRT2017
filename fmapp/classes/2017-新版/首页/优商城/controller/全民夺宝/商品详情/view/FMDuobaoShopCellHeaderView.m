//
//  FMDuobaoShopCellHeaderView.m
//  fmapp
//
//  Created by runzhiqiu on 16/10/14.
//  Copyright © 2016年 yk. All rights reserved.
//

#define KItemWidthStep 175

#import "FMDuobaoShopCellHeaderView.h"

#import "FMDuobaoClass.h"
@interface FMDuobaoShopCellHeaderView ()

@property (nonatomic, strong) UIView  * firstViewContent;
@property (nonatomic, strong) UIImageView * firstViewImageView;
@property (nonatomic, strong) UILabel * firstViewLabelView;
@property (nonatomic, strong) UIImageView * firstViewImagetime;
@property (nonatomic, strong) UILabel * firstViewLabeltime;
@property (nonatomic, strong) UIImageView * firstViewImageCount;
@property (nonatomic, strong) UILabel * firstViewLabelCount;


@property (nonatomic, strong) UIView  * secondViewContent;
@property (nonatomic, strong) UILabel * secondViewlabelViewleft;
@property (nonatomic, strong) UILabel * secondViewLabelViewright;
@property (nonatomic, strong) UIView * secondViewStepBack;
@property (nonatomic, strong) UIView * secondViewStep;



@property (nonatomic, strong) UIView  * thirdViewContent;
@property (nonatomic, strong) UILabel * thirdViewcurrentlabel;
@property (nonatomic, strong) UILabel * thirdViewminLabel;
@property (nonatomic, strong) UIButton * thirdViewThrowMoney;
//@property (nonatomic, strong) UILabel * thirdViewnumberLabel;


@property (nonatomic, strong) UIView  * fourViewContent;
@property (nonatomic, strong) UIButton * fourViewThrowMoney;

@end

@implementation FMDuobaoShopCellHeaderView


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor colorWithRed:(230.0/255) green:(234.0/255) blue:(241.0/255) alpha:1];;
    }
    return self;
}
-(void)winTheShopMoneyButtonOnClick:(UIButton *)button
{
    
    if (self.buttonBlock) {
        self.buttonBlock(self.duobaoStyle);
    }
    
}

-(void)buttonSpreadButtonOnClick:(UIButton *)button
{
    if (self.buttonSpread) {
        self.buttonSpread(self.duobaoStyle);
    }
}

-(void)setDuobaoStyle:(FMDuobaoClassStyle *)duobaoStyle
{
    _duobaoStyle = duobaoStyle;
    //进度条和展开匡处理
    [self jindutiaoChuli];
    
    
    //赋值操作
    self.firstViewLabeltime.text = [NSString stringWithFormat:@"%@天",duobaoStyle.residue];
    self.firstViewLabelCount.text = [NSString stringWithFormat:@"%@件",duobaoStyle.online];
    
    if ([duobaoStyle.type integerValue] == 1) {
        //抽奖
        
        
        if ([duobaoStyle.unit_cost integerValue] == 1) {
            [self.firstViewImageView setImage:[UIImage imageNamed:@"1币抽奖1014"]];
            self.firstViewLabelView.text = @"1币抽奖";
            
        }else if([duobaoStyle.unit_cost integerValue] == 5)
        {
            [self.firstViewImageView setImage:[UIImage imageNamed:@"5币抽奖1014"]];
            self.firstViewLabelView.text = @"5币抽奖";
        }else
        {
            
        }
        
         [self.thirdViewThrowMoney setTitle:@"投币" forState:UIControlStateNormal];
        self.thirdViewcurrentlabel.text = [NSString stringWithFormat:@"当前投币数：%@币",duobaoStyle.sold_sum];
        self.thirdViewminLabel.text = [NSString stringWithFormat:@"总需投币数：%@币",duobaoStyle.won_cost];
        self.thirdViewcurrentlabel.textColor = [HXColor colorWithHexString:@"#333333"];
        self.thirdViewminLabel.textColor = [HXColor colorWithHexString:@"#333333"];
       
    }else
    {
         [self.firstViewImageView setImage:[UIImage imageNamed:@"老友价购买1014"]];
        self.firstViewLabelView.text = @"老友价购买";
        
         [self.thirdViewThrowMoney setTitle:@"购买" forState:UIControlStateNormal];
        
        NSString *oldPrice = [NSString stringWithFormat:@"%@",duobaoStyle.won_cost];
        NSUInteger length = [[NSString stringWithFormat:@"老友价：￥%@",oldPrice] length];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"老友价：￥%@",oldPrice]];
        [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(5, length - 5)];
        
        

        self.thirdViewcurrentlabel.attributedText = attri;
        self.thirdViewminLabel.text = [NSString stringWithFormat:@"市场价：￥%@",duobaoStyle.original_cost];
        
        
        self.thirdViewcurrentlabel.textColor = [HXColor colorWithHexString:@"#ff6633"];
        self.thirdViewminLabel.textColor = [HXColor colorWithHexString:@"#333333"];
    }
    
    if (duobaoStyle.buttonStyle  == 1) {
         [self.thirdViewThrowMoney setBackgroundColor:[HXColor colorWithHexString:@"#cccccc"]];
    }else if(duobaoStyle.buttonStyle  == 2)
    {
        [self.thirdViewThrowMoney setTitle:@"售罄" forState:UIControlStateNormal];
        [self.thirdViewThrowMoney setBackgroundColor:[HXColor colorWithHexString:@"#cccccc"]];
    }else
    {
         [self.thirdViewThrowMoney setBackgroundColor:[HXColor colorWithHexString:@"#0099ff"]];
    }
    
}



-(void)jindutiaoChuli
{
    //2为存在进度条
    
    if ([self.duobaoStyle.status integerValue] == 2) {
        //存在进度条
        
        
        if (!self.duobaoStyle.isSpread) {
            //有进度条，不展开
            self.frame = CGRectMake(0, 0, KProjectScreenWidth,KFirstViewHeigh + KSecondViewHeigh + KThirdViewHeigh + KFourViewHeigh + KDefaultMargion * 4);
            
        }else
        {
            //有进度条，展开
           self.frame = CGRectMake(0, 0, KProjectScreenWidth,KFirstViewHeigh + KSecondViewHeigh + KThirdViewHeigh + KDefaultMargion * 3);
        }

        
        
        
        [self tableViewSectionHeaderViewWithJinDuTiao];
        
        
        
    }else
    {
        
        if (!self.duobaoStyle.isSpread) {
            //没有进度条，不展开
             self.frame = CGRectMake(0, 0, KProjectScreenWidth,KFirstViewHeigh + KThirdViewHeigh + KFourViewHeigh + KDefaultMargion * 3);
            
        }else
        {
            //没有进度条，展开
            self.frame = CGRectMake(0, 0, KProjectScreenWidth,KFirstViewHeigh + KThirdViewHeigh + KDefaultMargion * 2);
        }

        
       
        
        [self tableViewSectionHeaderViewWithNOJinDuTiao];
    }
    
    if ([self.duobaoStyle.type integerValue] == 1) {
    
        self.fourViewContent.hidden = NO;
    }else
    {
        //没有进度条，展开
        self.frame = CGRectMake(0, 0, KProjectScreenWidth,KFirstViewHeigh + KThirdViewHeigh + KDefaultMargion * 2);
        
        CGRect rectFrame = self.frame;
        rectFrame.size.height = rectFrame.size.height - KFourViewHeigh - KDefaultMargion;
        self.frame = rectFrame;
        self.fourViewContent.hidden = YES;
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)tableViewSectionHeaderViewWithJinDuTiao
{
    self.firstViewContent.frame =  CGRectMake(0, KDefaultMargion, KProjectScreenWidth, KFirstViewHeigh);
    self.secondViewContent.hidden = NO;
    self.secondViewContent.frame = CGRectMake(0, KFirstViewHeigh + KDefaultMargion * 2, KProjectScreenWidth, KSecondViewHeigh);
    self.thirdViewContent.frame = CGRectMake(0, KFirstViewHeigh + KSecondViewHeigh + KDefaultMargion * 3, KProjectScreenWidth, KThirdViewHeigh);
    
    
    if (!self.duobaoStyle.isSpread) {
        //有进度条，不展开
        self.fourViewContent.hidden = NO;
        self.fourViewContent.frame = CGRectMake(0, KFirstViewHeigh + KSecondViewHeigh + KThirdViewHeigh + KDefaultMargion * 4, KProjectScreenWidth, KFourViewHeigh);
        
    }else
    {
        self.fourViewContent.hidden = YES;
    }

    
    CGFloat  sold_sum_value = [self.duobaoStyle.sold_sum floatValue];
    CGFloat  won_cost_value = [self.duobaoStyle.won_cost floatValue];
    
    CGFloat radioFloat = sold_sum_value/won_cost_value;
    
    
    
    
    self.secondViewLabelViewright.text = [NSString stringWithFormat:@"%.1f%%",radioFloat * 100];
    
    
    radioFloat = radioFloat > 1 ? 1 : radioFloat;
    
    [self.secondViewStepBack remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.secondViewlabelViewleft.mas_right).offset(20);
        make.centerY.equalTo(self.secondViewContent.mas_centerY);
        make.width.equalTo((KProjectScreenWidth - KItemWidthStep));
        make.height.equalTo(@4);
        
    }];
    
    [self.secondViewStep remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.secondViewlabelViewleft.mas_right).offset(20);
        make.centerY.equalTo(self.secondViewContent.mas_centerY);
        make.width.equalTo((KProjectScreenWidth - KItemWidthStep) * radioFloat);
        make.height.equalTo(@4);
    }];

    
    
    
}
-(void)tableViewSectionHeaderViewWithNOJinDuTiao
{
    self.firstViewContent.frame =  CGRectMake(0, KDefaultMargion, KProjectScreenWidth, KFirstViewHeigh);
    self.secondViewContent.hidden = YES;
    self.thirdViewContent.frame = CGRectMake(0, KFirstViewHeigh + KDefaultMargion * 2, KProjectScreenWidth, KThirdViewHeigh);
    
    
    if (!self.duobaoStyle.isSpread) {
        //没有进度条，不展开
        
        self.fourViewContent.hidden = NO;
        self.fourViewContent.frame = CGRectMake(0, KFirstViewHeigh + KThirdViewHeigh + KDefaultMargion * 3, KProjectScreenWidth, KFourViewHeigh);

    }else
    {
        //没有进度条，展开
        self.fourViewContent.hidden = YES;
      
    }
}

-(void)prepareForReuse
{
    [super prepareForReuse];
}

-(UIView *)firstViewContent
{
    if (!_firstViewContent) {
        _firstViewContent = [[UIView alloc]init];
        _firstViewContent.backgroundColor = [UIColor whiteColor];
        
        
        [self.firstViewImageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_firstViewContent.mas_left).offset(15);
            make.centerY.equalTo(_firstViewContent.mas_centerY);
        }];
        
        [self.firstViewLabelView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.firstViewImageView.mas_right).offset(15);
            make.centerY.equalTo(self.firstViewImageView.mas_centerY);
        }];
        
        [self.firstViewLabeltime makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_firstViewContent.mas_right).offset(-20);
            make.centerY.equalTo(_firstViewContent.mas_centerY);
        }];

        
        [self.firstViewImagetime makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.firstViewLabeltime.mas_left).offset(-5);
            make.centerY.equalTo(_firstViewContent.mas_centerY);
        }];
        
        [self.firstViewLabelCount makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.firstViewImagetime.mas_left).offset(-20);
            make.centerY.equalTo(_firstViewContent.mas_centerY);
        }];
        
        [self.firstViewImageCount makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.firstViewLabelCount.mas_left).offset(-5);
            make.centerY.equalTo(_firstViewContent.mas_centerY);
        }];
        
        
        [self.contentView addSubview:_firstViewContent];
    }
    return _firstViewContent;
}
-(UIImageView *)firstViewImageView
{
    if (!_firstViewImageView) {
        _firstViewImageView = [[UIImageView alloc]init];
        _firstViewImageView.image = [UIImage imageNamed:@"1币抽奖1014"];
        [self.firstViewContent addSubview:_firstViewImageView];
    }
    return _firstViewImageView;
}

-(UILabel *)firstViewLabelView
{
    if (!_firstViewLabelView) {
        _firstViewLabelView = [[UILabel alloc]init];
        _firstViewLabelView.textAlignment = NSTextAlignmentLeft;
        _firstViewLabelView.font = [UIFont systemFontOfSize:16];
        _firstViewLabelView.textColor = [HXColor colorWithHexString:@"#333333"];
        _firstViewLabelView.text = @"5币抽奖";
        [self.firstViewContent addSubview:_firstViewLabelView];
    }
    return _firstViewLabelView;
}

-(UIImageView *)firstViewImagetime
{
    if (!_firstViewImagetime) {
        _firstViewImagetime = [[UIImageView alloc]init];
        _firstViewImagetime.image = [UIImage imageNamed:@"时间-改版"];
        [self.firstViewContent addSubview:_firstViewImagetime];
    }
    return _firstViewImagetime;
}

-(UILabel *)firstViewLabeltime
{
    if (!_firstViewLabeltime) {
        _firstViewLabeltime = [[UILabel alloc]init];
        _firstViewLabeltime.textAlignment = NSTextAlignmentLeft;
        _firstViewLabeltime.font = [UIFont systemFontOfSize:14];
        _firstViewLabeltime.textColor = [HXColor colorWithHexString:@"#999999"];
        _firstViewLabeltime.text = @"5天";
        [self.firstViewContent addSubview:_firstViewLabeltime];
    }
    return _firstViewLabeltime;
}



-(UIImageView *)firstViewImageCount
{
    if (!_firstViewImageCount) {
        _firstViewImageCount = [[UIImageView alloc]init];
        _firstViewImageCount.image = [UIImage imageNamed:@"1014库存"];
        [self.firstViewContent addSubview:_firstViewImageCount];
    }
    return _firstViewImageCount;
}


-(UILabel *)firstViewLabelCount
{
    if (!_firstViewLabelCount) {
        _firstViewLabelCount = [[UILabel alloc]init];
        _firstViewLabelCount.textAlignment = NSTextAlignmentLeft;
        _firstViewLabelCount.font = [UIFont systemFontOfSize:14];
        _firstViewLabelCount.textColor = [HXColor colorWithHexString:@"#999999"];
        _firstViewLabelCount.text = @"5件";
        [self.firstViewContent addSubview:_firstViewLabelCount];
    }
    return _firstViewLabelCount;
}



-(UIView *)secondViewContent
{
    if (!_secondViewContent) {
        _secondViewContent = [[UIView alloc]init];
        _secondViewContent.backgroundColor = [UIColor whiteColor];
        
        [self.secondViewlabelViewleft makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_secondViewContent.mas_left).offset(15);
            make.centerY.equalTo(_secondViewContent.mas_centerY);
        }];
        
        [self.secondViewLabelViewright makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_secondViewContent.mas_right).offset(-20);
            make.centerY.equalTo(_secondViewContent.mas_centerY);
        }];
        
        [self.secondViewStepBack makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.secondViewlabelViewleft.mas_right).offset(20);
            make.centerY.equalTo(_secondViewContent.mas_centerY);
            make.width.equalTo(KProjectScreenWidth - 160);
            make.height.equalTo(@4);
            
        }];
        
        [self.secondViewStep makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.secondViewlabelViewleft.mas_right).offset(20);
            make.centerY.equalTo(_secondViewContent.mas_centerY);
            make.width.equalTo(KProjectScreenWidth * 0.48 * 0.6);
            make.height.equalTo(@4);
        }];
        [self.contentView addSubview:_secondViewContent];

    }
    return _secondViewContent;
}


-(UILabel *)secondViewlabelViewleft
{
    if (!_secondViewlabelViewleft) {
        _secondViewlabelViewleft = [[UILabel alloc]init];
        _secondViewlabelViewleft.textAlignment = NSTextAlignmentCenter;
        _secondViewlabelViewleft.font = [UIFont systemFontOfSize:14];
        _secondViewlabelViewleft.textColor = [HXColor colorWithHexString:@"#0099ff"];
        _secondViewlabelViewleft.text = @"投币进度";
        [self.secondViewContent addSubview:_secondViewlabelViewleft];
    }
    return _secondViewlabelViewleft;
}

-(UILabel *)secondViewLabelViewright
{
    if (!_secondViewLabelViewright) {
        _secondViewLabelViewright = [[UILabel alloc]init];
        _secondViewLabelViewright.textAlignment = NSTextAlignmentCenter;
        _secondViewLabelViewright.font = [UIFont systemFontOfSize:14];
        _secondViewLabelViewright.textColor = [HXColor colorWithHexString:@"#0099ff"];
        _secondViewLabelViewright.text = @"100%";
        [self.secondViewContent addSubview:_secondViewLabelViewright];
    }
    return _secondViewLabelViewright;
}

-(UIView *)secondViewStepBack
{
    if (!_secondViewStepBack) {
        _secondViewStepBack = [[UIView alloc]init];
        _secondViewStepBack.backgroundColor = [UIColor colorWithRed:(230.0/255) green:(234.0/255) blue:(241.0/255) alpha:1];
        [self.secondViewContent addSubview:_secondViewStepBack];
        
    }
    return _secondViewStepBack;
}
-(UIView *)secondViewStep
{
    if (!_secondViewStep) {
        _secondViewStep = [[UIView alloc]init];
        _secondViewStep.backgroundColor = [HXColor colorWithHexString:@"#0099ff"];
        [self.secondViewContent addSubview:_secondViewStep];

    }
    return _secondViewStep;
}

//thirdViewContent


-(UIView *)thirdViewContent
{
    if (!_thirdViewContent) {
        _thirdViewContent = [[UIView alloc]init];
        _thirdViewContent.backgroundColor = [UIColor whiteColor];
       
        
        [self.contentView addSubview:_thirdViewContent];

        
        [self.thirdViewcurrentlabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_thirdViewContent.mas_left).offset(15);
            make.top.equalTo(_thirdViewContent.mas_top).offset(10);
        }];
        
        [self.thirdViewminLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_thirdViewContent.mas_left).offset(15);
            make.bottom.equalTo(_thirdViewContent.mas_bottom).offset(-10);
        }];
        
        [self.thirdViewThrowMoney makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_thirdViewContent.mas_right).offset(-20);
            make.top.equalTo(_thirdViewContent.mas_top).offset(18);
            make.width.equalTo(@90);
            make.height.equalTo(30);
            
            
        }];
        
        
        /*
        [self.thirdViewnumberLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.thirdViewThrowMoney.mas_bottom).offset(5);
            make.centerX.equalTo(self.thirdViewThrowMoney.mas_centerX);

        }];
         */
    }
    return _thirdViewContent;
}

-(UILabel *)thirdViewcurrentlabel
{
    if (!_thirdViewcurrentlabel) {
        _thirdViewcurrentlabel = [[UILabel alloc]init];
        _thirdViewcurrentlabel.textAlignment = NSTextAlignmentCenter;
        _thirdViewcurrentlabel.font = [UIFont systemFontOfSize:14];
        _thirdViewcurrentlabel.textColor = [HXColor colorWithHexString:@"#333333"];
        _thirdViewcurrentlabel.text = @"当前投币数：  币";
        [self.thirdViewContent addSubview:_thirdViewcurrentlabel];
    }
    return _thirdViewcurrentlabel;
}

-(UILabel *)thirdViewminLabel
{
    if (!_thirdViewminLabel) {
        _thirdViewminLabel = [[UILabel alloc]init];
        _thirdViewminLabel.textAlignment = NSTextAlignmentCenter;
        _thirdViewminLabel.font = [UIFont systemFontOfSize:14];
        _thirdViewminLabel.textColor = [HXColor colorWithHexString:@"#333333"];
        _thirdViewminLabel.text = @"最低开奖需：  币";
        [self.thirdViewContent addSubview:_thirdViewminLabel];
    }
    return _thirdViewminLabel;
}


-(UIButton *)thirdViewThrowMoney
{
    if (!_thirdViewThrowMoney) {
        _thirdViewThrowMoney = [[UIButton alloc]init];
        _thirdViewThrowMoney.tag = 421;
        [_thirdViewThrowMoney setBackgroundColor:[HXColor colorWithHexString:@"#0099ff"]];
        [_thirdViewThrowMoney setTitle:@"投币" forState:UIControlStateNormal];
        _thirdViewThrowMoney.titleLabel.font = [UIFont systemFontOfSize:13];
        [_thirdViewThrowMoney addTarget:self action:@selector(winTheShopMoneyButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.thirdViewContent addSubview:_thirdViewThrowMoney];
    }
    return _thirdViewThrowMoney;
}
/*
-(UILabel *)thirdViewnumberLabel
{
    if (!_thirdViewnumberLabel) {
        _thirdViewnumberLabel = [[UILabel alloc]init];
        _thirdViewnumberLabel.textAlignment = NSTextAlignmentCenter;
        _thirdViewnumberLabel.font = [UIFont systemFontOfSize:14];
        _thirdViewnumberLabel.textColor = [HXColor colorWithHexString:@"#0099ff"];
        [self.thirdViewContent addSubview:_thirdViewnumberLabel];
    }
    return _thirdViewnumberLabel;
}
 */


-(UIView *)fourViewContent
{
    if (!_fourViewContent) {
        _fourViewContent = [[UIView alloc]init];
        _fourViewContent.backgroundColor = [UIColor whiteColor];
        
        
        
        [self.contentView addSubview:_fourViewContent];
        
        
        [self.fourViewThrowMoney makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_fourViewContent.mas_left);
            make.right.equalTo(_fourViewContent.mas_right);
            make.centerY.equalTo(_fourViewContent.mas_centerY);

        }];
        
      
    }
    return _fourViewContent;
}




-(UIButton *)fourViewThrowMoney
{
    if (!_fourViewThrowMoney) {
        _fourViewThrowMoney = [[UIButton alloc]init];
        _fourViewThrowMoney.tag = 422;
        [_fourViewThrowMoney setBackgroundColor:[UIColor whiteColor]];
        [_fourViewThrowMoney addTarget:self action:@selector(buttonSpreadButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
       
        [_fourViewThrowMoney setImage:[UIImage imageNamed:@"展开1014"] forState:UIControlStateNormal];
        
        [self.fourViewContent addSubview:_fourViewThrowMoney];
    }
    return _fourViewThrowMoney;
}


@end
