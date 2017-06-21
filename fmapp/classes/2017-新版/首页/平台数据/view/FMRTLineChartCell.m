//
//  FMRTLineChartCell.m
//  fmapp
//
//  Created by apple on 2017/2/24.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRTLineChartCell.h"
#import "SJAxisView.h"
#import "SJChartLineView.h"
#import "SJLineChart.h"
#import "FMRTPlatformModel.h"

@interface FMRTLineChartCell ()

@property (nonatomic, strong) SJLineChart *lineChart;
@property (nonatomic, weak)UILabel *zhexianLabel;

@end

@implementation FMRTLineChartCell

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
    
    UILabel *zhexianLabel = [[UILabel alloc]init];
    self.zhexianLabel = zhexianLabel;
    zhexianLabel.text = @"近一年累计成交金额";
    zhexianLabel.font = [UIFont systemFontOfSize:25];
    zhexianLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:zhexianLabel];
    [zhexianLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.contentView.centerX);
        make.top.equalTo(self.contentView.top).offset(30);
    }];
    
    [self.lineChart makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.left);
        make.bottom.equalTo(self.contentView.bottom).offset(-10);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(zhexianLabel.bottom).offset(20);

    }];
}

- (SJLineChart *)lineChart{
    if (!_lineChart) {
        
        SJLineChart *lineChart = [[SJLineChart alloc] initWithFrame:CGRectMake(0, 100, KProjectScreenWidth, 300)];
        lineChart.maxValue = 3;
        lineChart.yMarkTitles = @[@"0亿",@"1亿",@"2亿",@"3亿"];
        
        lineChart.xScaleMarkLEN = 60;

        [self.contentView addSubview:lineChart];
        
        _lineChart = lineChart;
    }
    return _lineChart;
}

- (void)setModel:(FMRTPlatformModel *)model{
    _model = model;
    if (model.DealAmtStats.count) {
        [self.zhexianLabel setHidden:NO];
        [self.lineChart setHidden:NO];

        
//        for (int i = 0; i<model.DealAmtStats.count; i++) {
//            if (i == 5) {
//                lineModel *mo = model.DealAmtStats[i];
//                mo.Amt = 990251259;
//            }
//        }
//        
        
        NSMutableArray *arr= [NSMutableArray array];
        for (lineModel *linem in model.DealAmtStats) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:linem.Years forKey:@"item"];
            
//            double money = linem.Amt/100000000;
            
            NSNumber *number = [NSNumber numberWithDouble:linem.Amt];
            [dict setValue:number forKey:@"count"];
            [dict setValue:linem.Desc forKey:@"desp"];
            
            [arr addObject:dict];
        }
        
        NSMutableArray *dataY= [NSMutableArray array];

        for (NSNumber *number in model.DealAmtStatsY) {
            [dataY addObject:[NSString stringWithFormat:@"%@亿",number]];
        }
//        NSLog(@"-======-%@",model.DealAmtStatsY);
        self.lineChart.yMarkTitles = [NSArray arrayWithArray:dataY];
//        self.lineChart.yMarkTitles = @[@"3亿",@"5亿",@"7亿",@"9亿",@"11亿"];

        self.lineChart.maxValue = [[model.DealAmtStatsY lastObject] doubleValue];
        self.lineChart.minValue = [[model.DealAmtStatsY firstObject] doubleValue];

        [self.lineChart setXMarkTitlesAndValues:arr titleKey:@"item" valueKey:@"count" descpKey:@"desp"];
        [self.lineChart mapping];
        
        [self.lineChart updateConstraints];
    }else{
        [self.zhexianLabel setHidden:YES];
        [self.lineChart setHidden:YES];
    }
}


@end
