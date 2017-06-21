//
//  XMRecommendMidView.m
//  fmapp
//
//  Created by runzhiqiu on 16/3/11.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "XMRecommendMidView.h"

@interface XMRecommendMidView ()

@property (nonatomic, assign) NSInteger grade;

@property (weak, nonatomic) IBOutlet UILabel *recomendMoney;
@property (weak, nonatomic) IBOutlet UILabel *recomendPerson;
@property (weak, nonatomic) IBOutlet UILabel *recomendFriend;
@property (weak, nonatomic) IBOutlet UILabel *friendMoney;

@property (weak, nonatomic) IBOutlet UILabel *secRecomendMoney;
@property (weak, nonatomic) IBOutlet UILabel *secRecomendPerson;

@end


@implementation XMRecommendMidView


/**
 *  创建view并设置类型
 */
-(instancetype)initWithMidViewWithCount:(NSInteger)count;
{
    
    self = [super init];
    if (self) {
        
        if (count == 2) {
//            NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"XMRecommendMidView" owner:self options:nil];
            self = [[[NSBundle mainBundle] loadNibNamed:@"XMRecommendMidView" owner:self options:nil] lastObject];
            CGRect rect = self.frame;
            rect.size.width = rect.size.width * (KProjectScreenWidth / 375);
            self.frame = rect;
            self.secRecomendMoney.text = @"afads";
        }else
        {
            self = [[[NSBundle mainBundle] loadNibNamed:@"XMRecommendMidView" owner:self options:nil] firstObject];
            CGRect rect = self.frame;
            rect.size.width = rect.size.width * (KProjectScreenWidth / 375);
            self.frame = rect;
        }
        self.grade = count;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    Log(@"adfads");
}

-(void)setDataSource:(NSDictionary *)dataSource
{
    _dataSource = dataSource;
    if (self.grade == 2) {
        NSString * secMyRecomendMoney = [NSString stringWithFormat:@"%@",dataSource[@"myzichanjiner"]];
        self.secRecomendMoney.text = secMyRecomendMoney;
        
        NSString * secMyRecomendPerson = [NSString stringWithFormat:@"%@",dataSource[@"myreuserjiner"]];
        self.secRecomendPerson.text = secMyRecomendPerson;
        
        
    }else
    {
        NSString * recomendMoney = [NSString stringWithFormat:@"%@",dataSource[@"myzichanjiner"]];
        self.recomendMoney.text = recomendMoney;
        NSString * recomendPerson = [NSString stringWithFormat:@"%@",dataSource[@"myreuserjiner"]];
        self.recomendPerson.text = recomendPerson;
        NSString * recomendFriend = [NSString stringWithFormat:@"%@",dataSource[@"haoygongxian"]];
        self.recomendFriend.text = recomendFriend;
        NSString * friendMoney = [NSString stringWithFormat:@"%@",dataSource[@"hygxyongjin"]];
        self.friendMoney.text = friendMoney;
    
    }
    
    
}

- (IBAction)indexfiestButtonOnClick:(id)sender {
//    if ([self.delegate respondsToSelector:@selector(XMRecommendMidViewWithView:withDidSelectOnClick:)]) {
//        [self.delegate XMRecommendMidViewWithView:self withDidSelectOnClick:11];
//    }
}
- (IBAction)indexSecondButtonOnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(XMRecommendMidViewWithView:withDidSelectOnClick:)]) {
        [self.delegate XMRecommendMidViewWithView:self withDidSelectOnClick:12];
    }
}
- (IBAction)indexThirdButtonOnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(XMRecommendMidViewWithView:withDidSelectOnClick:)]) {
        [self.delegate XMRecommendMidViewWithView:self withDidSelectOnClick:13];
    }
}
- (IBAction)indexForthButtonOnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(XMRecommendMidViewWithView:withDidSelectOnClick:)]) {
        [self.delegate XMRecommendMidViewWithView:self withDidSelectOnClick:14];
    }
}



- (IBAction)lastFirstButtonOnClick:(id)sender {
//    if ([self.delegate respondsToSelector:@selector(XMRecommendMidViewWithView:withDidSelectOnClick:)]) {
//        [self.delegate XMRecommendMidViewWithView:self withDidSelectOnClick:21];
//    }
}
- (IBAction)lastSecondButtonOnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(XMRecommendMidViewWithView:withDidSelectOnClick:)]) {
        [self.delegate XMRecommendMidViewWithView:self withDidSelectOnClick:22];
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
