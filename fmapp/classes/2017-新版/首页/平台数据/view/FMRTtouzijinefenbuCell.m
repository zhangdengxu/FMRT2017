//
//  FMRTtouzijinefenbuCell.m
//  fmapp
//
//  Created by apple on 2017/2/24.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRTtouzijinefenbuCell.h"
#import "JHChartHeader.h"
#import "FMRTPlatformModel.h"

@interface FMRTtouzijinefenbuCell ()
@property (nonatomic, strong) JHRingChart *tzjeChart;
@property (nonatomic, weak)UILabel *titleLabel;


@end

@implementation FMRTtouzijinefenbuCell

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
    
    
    UILabel *tzjeLabel = [[UILabel alloc]init];
    tzjeLabel.text = @"投资金额分布";
    self.titleLabel = tzjeLabel;
    tzjeLabel.font = [UIFont systemFontOfSize:18];
    tzjeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:tzjeLabel];
    [tzjeLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.left).offset(25);
        make.top.equalTo(self.contentView.top).offset(10);
    }];
    
    

    [self.tzjeChart makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right).offset(0);
        make.height.equalTo(KProjectScreenWidth -110);
        make.top.equalTo(tzjeLabel.bottom);
    }];
}

- (JHRingChart *)tzjeChart{
    if (!_tzjeChart) {
        JHRingChart *ring = [[JHRingChart alloc] initWithFrame:CGRectMake(0, 100, KProjectScreenWidth, KProjectScreenWidth -110)];
        ring.backgroundColor = [UIColor clearColor];
        
        ring.ringWidth = 28.0;
        
        _tzjeChart = ring;
        [self.contentView addSubview:ring];
        
    }
    return _tzjeChart;
}


- (void)setModel:(FMRTPlatformModel *)model{
    _model = model;
    if (model.BidAmtStats.count) {
        [self.titleLabel setHidden:NO];
        [self.tzjeChart setHidden:NO];
        
        NSMutableArray *desArr = [NSMutableArray array];
        NSMutableArray *valueArr = [NSMutableArray array];
        NSMutableArray *coloArr = [NSMutableArray array];
        for (bideState *fbmodel in model.BidAmtStats) {
            [desArr addObject:fbmodel.Desc];
            [valueArr addObject:fbmodel.Rate];
            if (![fbmodel.Color length]) {
                fbmodel.Color = @"#e4ebf1";
            }
            
            [coloArr addObject:[UIColor colorWithHexString:fbmodel.Color]];
        }
        
        self.tzjeChart.valueDescriptionArr = [NSArray arrayWithArray:desArr];
        
        self.tzjeChart.valueDataArr = [NSArray arrayWithArray:valueArr];
        self.tzjeChart.fillColorArray = [NSArray arrayWithArray:coloArr];
        
        [self.tzjeChart showAnimation];
        [self.tzjeChart setNeedsDisplay];
        
    }else{
        [self.titleLabel setHidden:YES];
        [self.tzjeChart setHidden:YES];
    }
    
}


@end
