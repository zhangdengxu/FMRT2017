//
//  XMRecommendView.m
//  fmapp
//
//  Created by runzhiqiu on 16/3/11.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "XMRecommendView.h"

@interface XMRecommendView ()

@property (weak, nonatomic) IBOutlet UIButton *calenderButton;
@property (weak, nonatomic) IBOutlet UILabel *currentMonthMoney;
@property (weak, nonatomic) IBOutlet UILabel *allMonthMoney;
@property (weak, nonatomic) IBOutlet UILabel *midLabelContent;

@end


@implementation XMRecommendView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"XMRecommendView" owner:self options:nil] lastObject];
        CGRect rect = self.frame;
        rect.size.width = rect.size.width * (KProjectScreenWidth / 375);
        rect.size.height = rect.size.height * (KProjectScreenWidth / 375);
        self.frame = rect;
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.calenderButton.titleEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 0);
}
-(void)setDataSource:(NSDictionary *)dataSource
{
    _dataSource = dataSource;
    
    if (dataSource) {
        NSString * todayNumber = [NSString stringWithFormat:@"%@",dataSource[@"jinrishuzi"]];
        
        [self.calenderButton setTitle:todayNumber forState:UIControlStateNormal];
        [self.calenderButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.calenderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        NSString * todayMoney = [NSString stringWithFormat:@"%@",dataSource[@"jinriyjjiner"]];
        self.midLabelContent.text = todayMoney;
        
        NSString * currentMonth = [NSString stringWithFormat:@"%@",dataSource[@"benyyjjiner"]];
        self.currentMonthMoney.text = currentMonth;
        
        NSString * allMonthMoney =[NSString stringWithFormat:@"%.2f", [[NSString stringWithFormat:@"%@",dataSource[@"leijiyjjiner"]] floatValue]] ;
        self.allMonthMoney.text = allMonthMoney;
        
    }
    
}

- (IBAction)calenderButtonOnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(XMRecommendViewWithView:withOnClickIndex:)]) {
        [self.delegate XMRecommendViewWithView:self withOnClickIndex:0];
    }
}
- (IBAction)currentMonthMoneyButtonOnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(XMRecommendViewWithView:withOnClickIndex:)]) {
        [self.delegate XMRecommendViewWithView:self withOnClickIndex:1];
    }
}
- (IBAction)allMonthMoneyButtonOnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(XMRecommendViewWithView:withOnClickIndex:)]) {
        [self.delegate XMRecommendViewWithView:self withOnClickIndex:2];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
