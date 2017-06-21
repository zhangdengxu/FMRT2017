//
//  XMMyScoreInAppHeaderView.m
//  fmapp
//
//  Created by runzhiqiu on 16/1/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "XMMyScoreInAppHeaderView.h"

@interface XMMyScoreInAppHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *scoreTitlelabel;


@end

@implementation XMMyScoreInAppHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"XMMyScoreInAppHeaderView" owner:self options:nil] lastObject];
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(void)setDataSource:(NSDictionary *)dataSource
{
    _dataSource = dataSource;
    if (dataSource) {
        NSString * allScore = [NSString stringWithFormat:@"%@",dataSource[@"zongjifenshu"]];
        self.scoreTitlelabel.text = allScore;
        self.startTimeLabel.text = dataSource[@"kaishishijian"];
        self.endTimeLabel.text = dataSource[@"jiezhishijian"];
    }
}

- (IBAction)startButtonOnClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(XMMyScoreInAppHeaderViewDidSelectStartTime:)]) {
        [self.delegate XMMyScoreInAppHeaderViewDidSelectStartTime:self];
    }
    
}
- (IBAction)endTimeOnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(XMMyScoreInAppHeaderViewDidSelectEndTime:)]) {
        [self.delegate XMMyScoreInAppHeaderViewDidSelectEndTime:self];
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
