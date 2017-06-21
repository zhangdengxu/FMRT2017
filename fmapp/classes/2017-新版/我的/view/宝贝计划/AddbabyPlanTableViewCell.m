//
//  AddbabyPlanTableViewCell.m
//  fmapp
//
//  Created by runzhiqiu on 16/1/5.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "AddbabyPlanTableViewCell.h"
#import "BabyPlanOneScheduled.h"

@interface AddbabyPlanTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *saveDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *saveMoney;
@property (weak, nonatomic) IBOutlet UILabel *allSaveMoney;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation AddbabyPlanTableViewCell

-(void)setScheduled:(BabyPlanOneScheduled *)scheduled
{
    _scheduled = scheduled;
//    NSLog(@"%@,%@,%@",scheduled.shijian,scheduled.jiner,scheduled.leijijiner);
    self.saveDayLabel.text = scheduled.shijian;
    self.saveMoney.text = scheduled.toubiaobenjin;
    self.allSaveMoney.text = [NSString stringWithFormat:@"%@",scheduled.leijijiner];
    self.titleLabel.text = scheduled.title;
}

- (void)awakeFromNib {
    // Initialization code
}
/**
 *  查看合同
 */
- (IBAction)lookUpContractButtonOnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(AddbabyPlanTableViewCell:ContractButtonOnClick:)]) {
        [self.delegate AddbabyPlanTableViewCell:self ContractButtonOnClick:self.scheduled];
    }
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
}

@end
