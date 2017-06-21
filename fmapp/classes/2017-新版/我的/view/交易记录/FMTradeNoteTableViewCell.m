//
//  FMTradeNoteTableViewCell.m
//  fmapp
//
//  Created by runzhiqiu on 16/6/12.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMTradeNoteTableViewCell.h"
#import "FMTradeNoteModel.h"


@interface FMTradeNoteTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *tradeTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *tradeMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *tradeStyleLabel;

@property (weak, nonatomic) IBOutlet UILabel *tradeDetailLabel;

@end

@implementation FMTradeNoteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

/**
 *  交易时间：transTime
 交易金额：tradeMoneyLabel
 交易状态：change  值为“＋”“－”加为加入，减为支出
 交易细节：memo 交易细节说明：如存管账户转出1000元到零钱罐
 交易类型：transDesc  如在线充值，账户资金转出
 *
 *  @param tradeNote <#tradeNote description#>
 */

-(void)setTradeNote:(FMTradeNoteModel *)tradeNote
{
    _tradeNote = tradeNote;
    
    
    if (tradeNote.isScore == 1) {
        
        self.tradeTimeLabel.text = tradeNote.shijian;
        
        if ([tradeNote.jiajian integerValue] == 1) {
            self.tradeMoneyLabel.text = [NSString stringWithFormat:@"+%@",tradeNote.fenshu];
            self.tradeMoneyLabel.textColor = [HXColor colorWithHexString:@"#ff6633"];
            
        }else
        {
            self.tradeMoneyLabel.text = [NSString stringWithFormat:@"-%@",tradeNote.fenshu];
            self.tradeMoneyLabel.textColor = [HXColor colorWithHexString:@"#17ae7d"];
        }
        self.tradeStyleLabel.text = tradeNote.leixing;
        self.tradeDetailLabel.text = tradeNote.beizhu;
        
        
    }else
    {
        self.tradeTimeLabel.text = tradeNote.transTime;
        self.tradeMoneyLabel.text = [NSString stringWithFormat:@"%@元",tradeNote.transAmount];
        if ([tradeNote.change isEqualToString:@"+"]) {
            self.tradeMoneyLabel.textColor = [HXColor colorWithHexString:@"#ff6633"];
            
        }else
        {
            self.tradeMoneyLabel.textColor = [HXColor colorWithHexString:@"#17ae7d"];
        }
        self.tradeStyleLabel.text = tradeNote.transDesc;
        self.tradeDetailLabel.text = tradeNote.memo;
    }
    
    
}


-(void)setJoinDetail:(FMJoinDetalPrizeNewModel *)joinDetail
{
    _joinDetail = joinDetail;
    
    /*
     
     AwardType	int	"奖励类型
     1：现金 2：红包"
     AwardTrench	int	"奖励渠道
     1：首次 2：三十日内投资"
     */
    //self.numberLabel = ;
    switch (joinDetail.awardType) {
        case 1:
        {
            if (joinDetail.awardTrench == 1) {
                
                NSString * houbianString = @"元";
                NSString * middleString = [NSString stringWithFormat:@"+%.2f%@",joinDetail.awardMoney,houbianString];
                NSRange range=[middleString rangeOfString:houbianString];
                NSMutableAttributedString *attriContent=[[NSMutableAttributedString alloc]initWithString:middleString];
                [attriContent addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:range];
                self.tradeMoneyLabel.attributedText = attriContent;
                self.tradeMoneyLabel.textColor = [HXColor colorWithHexString:@"#ff6633"];
                
                
                
                self.tradeDetailLabel.text = [NSString stringWithFormat:@"好友成功投资%@元,期限%zi个月",[self retMoneyWithMakeBid:[NSString stringWithFormat:@"%.2f",joinDetail.inviteeBidMoney]],joinDetail.projDuration];
                self.tradeTimeLabel.text = [NSString retStringFrom:@"yyyyMMdd" withtimeString:[NSString stringWithFormat:@"%@",joinDetail.awardTime]];
                self.tradeStyleLabel.text = @"现金奖励";
                
            }else if (joinDetail.awardTrench == 2) {
                
                
                NSString * houbianString = @"元";
                NSString * middleString = [NSString stringWithFormat:@"+%@%@",[self retMoneyWithMakeBid:[NSString stringWithFormat:@"%.2f",joinDetail.awardMoney]],houbianString];
                NSRange range=[middleString rangeOfString:houbianString];
                NSMutableAttributedString *attriContent=[[NSMutableAttributedString alloc]initWithString:middleString];
                [attriContent addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:range];
                self.tradeMoneyLabel.attributedText = attriContent;
                self.tradeMoneyLabel.textColor = [HXColor colorWithHexString:@"#ff6633"];
                
                
                
                self.tradeDetailLabel.text = [NSString stringWithFormat:@"好友成功投资%@元,期限%zi个月",[self retMoneyWithMakeBid:[NSString stringWithFormat:@"%.2f",joinDetail.inviteeBidMoney]],joinDetail.projDuration];
                self.tradeTimeLabel.text = [NSString retStringFrom:@"yyyyMMdd" withtimeString:[NSString stringWithFormat:@"%@",joinDetail.awardTime]];
                self.tradeStyleLabel.text = @"现金奖励";

                
            }else
            {
                
            }
        }
            break;
        case 2:
        {
            if (joinDetail.awardTrench == 1) {
                
    
                
                NSString * houbianString = @"元红包";
                NSString * middleString = [NSString stringWithFormat:@"+%.2f%@",joinDetail.awardMoney,houbianString];
                NSRange range=[middleString rangeOfString:houbianString];
                NSMutableAttributedString *attriContent=[[NSMutableAttributedString alloc]initWithString:middleString];
                [attriContent addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:range];
                self.tradeMoneyLabel.attributedText = attriContent;
                self.tradeMoneyLabel.textColor = [HXColor colorWithHexString:@"#ff6633"];
                

                
                
                self.tradeDetailLabel.text = @"好友完成首次投资，获红包奖励1个";
                self.tradeTimeLabel.text = [NSString retStringFrom:@"yyyyMMdd" withtimeString:[NSString stringWithFormat:@"%@",joinDetail.awardTime]];
                self.tradeStyleLabel.text = @"红包奖励";

                
            }else if (joinDetail.awardTrench == 2) {
                
                
                NSString * houbianString = @"元";
                NSString * middleString = [NSString stringWithFormat:@"+%.2f%@",joinDetail.awardMoney,houbianString];
                NSRange range=[middleString rangeOfString:houbianString];
                NSMutableAttributedString *attriContent=[[NSMutableAttributedString alloc]initWithString:middleString];
                [attriContent addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:range];
                self.tradeMoneyLabel.attributedText = attriContent;
                self.tradeMoneyLabel.textColor = [HXColor colorWithHexString:@"#ff6633"];
                

                
                
                self.tradeDetailLabel.text = [NSString stringWithFormat:@"好友成功投资%@元,期限%zi个月",[self retMoneyWithMakeBid:[NSString stringWithFormat:@"%.2f",joinDetail.inviteeBidMoney]],joinDetail.projDuration];
                self.tradeTimeLabel.text = [NSString retStringFrom:@"yyyyMMdd" withtimeString:[NSString stringWithFormat:@"%@",joinDetail.awardTime]];
                self.tradeStyleLabel.text = @"红包奖励";

                
            }else
            {
                
            }
            
        }
            break;
            
        default:
            break;
    }

    
    
}

-(NSString *)retMoneyWithMakeBid:(NSString *)money
{
    NSString * moneyString = money;
    CGFloat  moneyFolat = [moneyString floatValue];
    NSString * retString;
    if ((moneyFolat / 10000 ) >= 1) {
        retString = [NSString stringWithFormat:@"%.2f万",(moneyFolat / 10000 )];
    }else
    {
        retString = moneyString;
    }
    
    return retString;
}



-(void)setSelected:(BOOL)selected animated:(BOOL)animated

{
    
    
    
}



-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated

{
    
}
@end
