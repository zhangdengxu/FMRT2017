//
//  FMCalenderTypesALLTableViewCell.m
//  fmapp
//
//  Created by runzhiqiu on 2017/2/27.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMCalenderTypesALLTableViewCell.h"


@interface FMCalenderTypesALLTableViewCell()

@property (nonatomic, strong) NSArray * titleLeftArray1;
@property (nonatomic, strong) NSArray * titleLeftArray2;

@property (nonatomic, strong) UILabel * leftTitleLabel1;
@property (nonatomic, strong) UILabel * rightTitleLabel1;
@property (nonatomic, strong) UILabel * leftTitleLabel2;
@property (nonatomic, strong) UILabel * rightTitleLabel2;


@property (nonatomic, strong) UILabel * middleLabel;
@property (nonatomic, strong) UIView * contentBottomView;




@end

@implementation FMCalenderTypesALLTableViewCell

-(NSArray *)titleLeftArray1
{
    if (!_titleLeftArray1) {
        if (self.isRecommendType == 0) {
            _titleLeftArray1 = @[@"本月待收本息（元）",@"本月已收本息（元）"];

        }else
        {
            _titleLeftArray1 = @[@"应发佣金（元）",@"到期资产（万）"];
        }
        
    }
    return _titleLeftArray1;
}
-(NSArray *)titleLeftArray2
{
    if (!_titleLeftArray2) {
        if (self.isRecommendType == 0) {
            _titleLeftArray2 = @[@"当日待收本息（元）",@"当日已收本息（元）"];

        }else
        {
            _titleLeftArray2 = @[@"应发佣金（元）",@"到期资产（万）"];

        }
    }
    return _titleLeftArray2;
}


-(UILabel *)leftTitleLabel1
{
    if (!_leftTitleLabel1) {
        _leftTitleLabel1 = [[UILabel alloc]init];
        _leftTitleLabel1.numberOfLines = 1;
        _leftTitleLabel1.textAlignment = NSTextAlignmentLeft;
        _leftTitleLabel1.font = [UIFont systemFontOfSize:16];
        _leftTitleLabel1.textColor = [HXColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:_leftTitleLabel1];
        
    }
    return _leftTitleLabel1;
}

-(UILabel *)rightTitleLabel1
{
    if (!_rightTitleLabel1) {
        _rightTitleLabel1 = [[UILabel alloc]init];
        _rightTitleLabel1.numberOfLines = 1;
        _rightTitleLabel1.textAlignment = NSTextAlignmentRight;
        _rightTitleLabel1.font = [UIFont systemFontOfSize:16];
        _rightTitleLabel1.textColor = [HXColor colorWithHexString:@"#666666"];
        [self.contentView addSubview:_rightTitleLabel1];
        
    }
    return _rightTitleLabel1;
}

-(UILabel *)leftTitleLabel2
{
    if (!_leftTitleLabel2) {
        _leftTitleLabel2 = [[UILabel alloc]init];
        _leftTitleLabel2.numberOfLines = 1;
        _leftTitleLabel2.textAlignment = NSTextAlignmentLeft;
        _leftTitleLabel2.font = [UIFont systemFontOfSize:16];
        _leftTitleLabel2.textColor = [HXColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:_leftTitleLabel2];
        
    }
    return _leftTitleLabel2;
}

-(UILabel *)rightTitleLabel2
{
    if (!_rightTitleLabel2) {
        _rightTitleLabel2 = [[UILabel alloc]init];
        _rightTitleLabel2.numberOfLines = 1;
        _rightTitleLabel2.textAlignment = NSTextAlignmentRight;
        _rightTitleLabel2.font = [UIFont systemFontOfSize:16];
        _rightTitleLabel2.textColor = [HXColor colorWithHexString:@"#666666"];
        [self.contentView addSubview:_rightTitleLabel2];
        
    }
    return _rightTitleLabel2;
}

-(UILabel *)middleLabel
{
    if (!_middleLabel) {
        _middleLabel = [[UILabel alloc]init];
        _middleLabel.numberOfLines = 1;
        _middleLabel.textAlignment = NSTextAlignmentCenter;
        _middleLabel.font = [UIFont systemFontOfSize:15];
        _middleLabel.textColor = [HXColor colorWithHexString:@"#999999"];
        if (self.isRecommendType == 0) {
            _middleLabel.text = @"无回款记录";
        }else{
            _middleLabel.text = @"无佣金记录";
        }
        [self.contentView addSubview:_middleLabel];
    }
    return _middleLabel;
}

-(UIView *)contentBottomView
{
    if (!_contentBottomView) {
        _contentBottomView = [[UIView alloc]init];
        _contentBottomView.backgroundColor = [HXColor colorWithHexString:@"f9f9f9"];
        
        [self.contentView addSubview:_contentBottomView];
        
        CGFloat widthCell = 100;
        if (KProjectScreenWidth < 375) {
            widthCell = 135;
        }else if(KProjectScreenWidth < 400)
        {
            widthCell = 165;
        }else
        {
            widthCell = 185;
        }

        
        UILabel * firstLabel = [[UILabel alloc]init];
        firstLabel.textAlignment = NSTextAlignmentLeft;
        firstLabel.font = [UIFont systemFontOfSize:15];
        if (self.isRecommendType == 0) {
            firstLabel.text = @"项目编号";
        }else
        {
            firstLabel.text = @"项目编号";
        }
        
        firstLabel.textColor = [HXColor colorWithHexString:@"#333333"];
        [_contentBottomView addSubview:firstLabel];
        
        UILabel * secondLabel = [[UILabel alloc]init];
        secondLabel.textAlignment = NSTextAlignmentRight;
        secondLabel.font = [UIFont systemFontOfSize:15];
        if (self.isRecommendType == 0) {
            secondLabel.text = @"利息(元)";

        }else
        {
            secondLabel.text = @"应发佣金(元)";

        }
        secondLabel.textColor = [HXColor colorWithHexString:@"#333333"];
        [_contentBottomView addSubview:secondLabel];

        UILabel * thirdLabel = [[UILabel alloc]init];
        thirdLabel.textAlignment = NSTextAlignmentRight;
        thirdLabel.font = [UIFont systemFontOfSize:15];
        if (self.isRecommendType == 0) {
            thirdLabel.text = @"本金(元)";

        }else
        {
            thirdLabel.text = @"到期资产(万)";

        }
        thirdLabel.textColor = [HXColor colorWithHexString:@"#333333"];
        [_contentBottomView addSubview:thirdLabel];


        [firstLabel makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_contentBottomView.mas_left).offset(12);
            make.centerY.equalTo(_contentBottomView.mas_centerY);
        }];
        CGFloat margion = 20;
        if (KProjectScreenWidth < 370) {
            margion = 17;
        }else if(KProjectScreenWidth < 400)
        {
            margion = 15;
        }else
        {
             margion = 14;
        }
        
        
        [thirdLabel makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo((KProjectScreenWidth - widthCell - margion)* 0.5);
            make.centerY.equalTo(_contentBottomView.mas_centerY);
            make.right.equalTo(_contentBottomView.mas_right).offset(-8);
            
        }];

        
        [secondLabel makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(thirdLabel.mas_left).offset(-4);
            make.left.equalTo(firstLabel.mas_right);
            make.centerY.equalTo(_contentBottomView.mas_centerY);

        }];
        
        
               
        
        
        
        
    }
    return _contentBottomView;
}






-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self massory];
    }
    return self;
}
-(void)massory
{
    
    [self.leftTitleLabel1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.top.equalTo(self.contentView.mas_top).offset(10);
    }];
    
    [self.rightTitleLabel1 makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.top.equalTo(self.contentView.mas_top).offset(10);
    }];
    
    [self.leftTitleLabel2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.top.equalTo(self.leftTitleLabel1.mas_bottom).offset(15);
    }];
    
    [self.rightTitleLabel2 makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.top.equalTo(self.rightTitleLabel1.mas_bottom).offset(15);
    }];
}

-(void)setDateModel:(FMMonthDateModel *)dateModel
{
    _dateModel = dateModel;
    if ([dateModel.commispabl isMemberOfClass:[NSNull class]]) {
        self.rightTitleLabel1.text = @"0.00";

    }else
    {
        
        self.rightTitleLabel1.text = [NSString stringWithFormat:@"%.2f", [dateModel.commispabl floatValue]];

    }
    if ([dateModel.maturas isMemberOfClass:[NSNull class]]) {
        self.rightTitleLabel2.text = @"0.00";

    }else
    {
        self.rightTitleLabel2.text = [NSString stringWithFormat:@"%.2f",[dateModel.maturas floatValue]];

    }

}

-(void)setReFoundMoney:(FMMonthDateReFoundMoneyModel *)reFoundMoney
{
    _reFoundMoney = reFoundMoney;
    if ([reFoundMoney.outerTotalAmt isMemberOfClass:[NSNull class]]) {
        self.rightTitleLabel1.text = @"0.00";
        
    }else
    {
        self.rightTitleLabel1.text = [NSString stringWithFormat:@"%.2f",[reFoundMoney.outerTotalAmt floatValue]];
        
    }
    if ([reFoundMoney.insideTotalAmt isMemberOfClass:[NSNull class]]) {
        self.rightTitleLabel2.text = @"0.00";
        
    }else
    {
        self.rightTitleLabel2.text = [NSString stringWithFormat:@"%.2f",[reFoundMoney.insideTotalAmt floatValue]];
        
    }
    
}

-(void)setType:(FMCalenderTypesALLTableViewCellType)type
{
    
    self.middleLabel.hidden = YES;;
    self.contentBottomView.hidden = YES;;
    
    _type = type;

    switch (type) {
        case FMCalenderTypesALLTableViewCellTypeMonth:
        {
            //月
            
            self.leftTitleLabel1.text = self.titleLeftArray1[0];
            self.leftTitleLabel2.text = self.titleLeftArray1[1];

            
        }
            break;
        case FMCalenderTypesALLTableViewCellTypeNoneDate:
        {
            
            self.leftTitleLabel1.text = self.titleLeftArray2[0];
            self.leftTitleLabel2.text = self.titleLeftArray2[1];
            //日，无数据
            self.middleLabel.hidden = NO;
            [self.middleLabel remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.contentView);
                make.top.equalTo(self.leftTitleLabel2.mas_bottom).offset(15);
            }];

        }
            break;
        case FMCalenderTypesALLTableViewCellTypeHaveDate:
        {
            //日，有数据
            self.leftTitleLabel1.text = self.titleLeftArray2[0];
            self.leftTitleLabel2.text = self.titleLeftArray2[1];
            self.contentBottomView.hidden = NO;
            [self.contentBottomView remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.contentView);
                make.top.equalTo(self.leftTitleLabel2.mas_bottom).offset(10);
                make.height.equalTo(@40);
            }];

        }
            break;
            
        default:
            break;
    }
    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
}

@end


@implementation FMMonthDateModel;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end




@implementation FMMonthDateReFoundMoneyModel;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
