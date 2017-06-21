//
//  BabyPlayDetailTableViewCell.m
//  fmapp
//
//  Created by runzhiqiu on 16/1/4.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "BabyPlayDetailTableViewCell.h"
#import "BabyPlanDetailModel.h"

@interface BabyPlayDetailTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *babyScheduled;

@property (weak, nonatomic) IBOutlet UILabel *holdStates;
@property (weak, nonatomic) IBOutlet UILabel *saveMoneyInMonth;
@property (weak, nonatomic) IBOutlet UILabel *getMoney;
@property (weak, nonatomic) IBOutlet UILabel *saveDayInMonth;
@property (weak, nonatomic) IBOutlet UILabel *babyDetail;
@property (nonatomic, strong) UIButton * thenEndButton;
@property (weak, nonatomic) IBOutlet UIButton *baobeixiugaiButton;

@end


@implementation BabyPlayDetailTableViewCell

-(UIButton *)thenEndButton
{
    if (!_thenEndButton) {
        _thenEndButton = [[UIButton alloc]init];
        [_thenEndButton addTarget:self action:@selector(thenEndButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
        _thenEndButton.layer.borderColor = [HXColor colorWithHexString:@"#ff0000"].CGColor;
        _thenEndButton.layer.masksToBounds = YES;
        _thenEndButton.layer.borderWidth = 0.5;
        _thenEndButton.layer.cornerRadius = 2.0;
        _thenEndButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [_thenEndButton setTitle:@"终止" forState:UIControlStateNormal];
        [_thenEndButton setTitleColor:[HXColor colorWithHexString:@"#ff6633"] forState:UIControlStateNormal];
        
    }
    return _thenEndButton;
}
-(void)thenEndButtonOnClick
{
    if ([self.thenEndButton.currentTitle isEqualToString:@"已终止"]) {
        return;
    }
    if (self.buttonBlock) {
        self.buttonBlock(self);
    }
}


- (IBAction)xiugaibaobeijihua:(id)sender {
    if (self.xiugaiBlcok) {
        self.xiugaiBlcok();
    }
}


-(void)setPlandetail:(BabyPlanDetailModel *)plandetail
{
    _plandetail = plandetail;
    
    
    if ([plandetail.xiugaianniu integerValue] == 0) {
        self.baobeixiugaiButton.hidden = YES;
    }else if([plandetail.xiugaianniu integerValue] == 1){
        self.baobeixiugaiButton.hidden = NO;

    }
    
    self.babyScheduled.text = plandetail.biaoti;
    
    
    if ([plandetail.Zhuangtai isEqualToString:@"4"]) {
        self.holdStates.text = @"持有中";
        if ([self.holdStates.text isEqualToString:@"持有中"]) {
            self.holdStates.textColor = [HXColor colorWithHexString:@"#0f5ed4"];
        }
        
    }else
    {
        self.holdStates.text = @"已到期";
        self.holdStates.textColor = XZColor(147, 147, 147);
    }

    self.saveDayInMonth.text = plandetail.mytouziri;
    
    
    NSDictionary * yizhuanDic = @{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
    //    //第二段
    NSDictionary * attrDict2 = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:12]};

    NSString * yizhuanString = [NSString stringWithFormat:@"%@",plandetail.yizhuan == nil ? @"0" : plandetail.yizhuan];
    NSMutableAttributedString * yizhuanStr1 = [[NSMutableAttributedString alloc] initWithString:yizhuanString attributes:yizhuanDic];
    NSAttributedString *attrStr2 = [[NSAttributedString alloc] initWithString:@" 元"  attributes: attrDict2];
    [yizhuanStr1 appendAttributedString:attrStr2];
    self.getMoney.attributedText = yizhuanStr1;
    
    
    //第一段
    NSDictionary * attrDict1 = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};

    
    NSMutableAttributedString * attrStr1 = [[NSMutableAttributedString alloc] initWithString:plandetail.Jiner == nil ? @"0" : plandetail.Jiner attributes:attrDict1];
    
    [attrStr1 appendAttributedString: attrStr2];
    self.saveMoneyInMonth.attributedText = attrStr1;
    
    
    
    self.babyDetail.text = [NSString stringWithFormat:@"已存入%@/%@个月  本次存款日%@",plandetail.yitoushu,plandetail.zongshu,plandetail.cunkuanri];
    
    
   
    
    if ([plandetail.endisornot integerValue] == 1) {
        
         self.thenEndButton.hidden = NO;
        [self.contentView addSubview:self.thenEndButton];
        [self.thenEndButton setTitle:@"终止" forState:UIControlStateNormal];
        [self.thenEndButton updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.centerY.equalTo(self.babyDetail.mas_centerY);
            make.width.equalTo(@55);
                
        }];
    }else if([plandetail.endisornot integerValue] == 2)
    {
        
        self.thenEndButton.hidden = NO;
        [self.contentView addSubview:self.thenEndButton];
        [self.thenEndButton setTitle:@"已终止" forState:UIControlStateNormal];
        [self.thenEndButton updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.centerY.equalTo(self.babyDetail.mas_centerY);
            make.width.equalTo(@55);
            
        }];

        
    }else
    {
        self.thenEndButton.hidden = YES;

    }
    
    
    
}
-(void)changeBabyPlanDetailStatus;
{
    if ([self.plandetail.Zhuangtai isEqualToString:@"4"]) {
        self.holdStates.text = @"持有中";
    }else
    {
        self.holdStates.text = @"已到期";
    }
    

    [self.thenEndButton setTitle:@"已终止" forState:UIControlStateNormal];
    [self.thenEndButton updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.equalTo(self.babyDetail.mas_centerY);
        
    }];
}
- (void)awakeFromNib {
    // Initialization code
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{ 
    
}

@end
