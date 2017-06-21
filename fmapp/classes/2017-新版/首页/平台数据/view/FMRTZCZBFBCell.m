//
//  FMRTZCZBFBCell.m
//  fmapp
//
//  Created by apple on 2017/2/24.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRTZCZBFBCell.h"
#import "JHChartHeader.h"
#import "FMRTPlatformModel.h"


@interface FMRTZCZBFBCell ()

@property (nonatomic, strong) JHRingChart *ringChart;
@property (nonatomic, weak) UILabel *fenbuLabel;

@end
@implementation FMRTZCZBFBCell

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
    
#pragma mark - 融资企业注册资本分布
    UILabel *fenbuLabel = [[UILabel alloc]init];
    self.fenbuLabel = fenbuLabel;
    fenbuLabel.text = @"融资企业注册资本分布";
    fenbuLabel.font = [UIFont systemFontOfSize:25];
    fenbuLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:fenbuLabel];
    [fenbuLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.contentView.centerX);
        make.top.equalTo(self.contentView.top).offset(45);
    }];

    [self.ringChart makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(fenbuLabel.bottom).offset(15);
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.height.equalTo(KProjectScreenWidth -110);
    }];
}

- (JHRingChart *)ringChart{
    if (!_ringChart) {
        JHRingChart *ring = [[JHRingChart alloc] initWithFrame:CGRectMake(0, 100, KProjectScreenWidth, KProjectScreenWidth -110)];
        ring.backgroundColor = [UIColor clearColor];
        
        ring.ringWidth = 28.0;
        
        _ringChart = ring;
        [self.contentView addSubview:ring];
        
    }
    return _ringChart;
}

- (void)setModel:(FMRTPlatformModel *)model{
    _model = model;
    if (model.EntCapitalStats.count) {
        [self.fenbuLabel setHidden:NO];
        [self.ringChart setHidden:NO];
        
        NSMutableArray *valueArr = [NSMutableArray array];
        NSMutableArray *dataArr = [NSMutableArray array];
        NSMutableArray *colArr = [NSMutableArray array];

        for (zibenfenbu *ziben in model.EntCapitalStats) {
            [valueArr addObject:ziben.Desc];
            [dataArr addObject:ziben.Rate];
            if (![ziben.Color length]) {
                ziben.Color = @"#e4ebf1";
            }
            
            [colArr addObject:[UIColor colorWithHexString:ziben.Color]];
        }
        
        self.ringChart.valueDescriptionArr = [NSArray arrayWithArray:valueArr];
        
        self.ringChart.valueDataArr = [NSArray arrayWithArray:dataArr];
        
        self.ringChart.fillColorArray = [NSArray arrayWithArray:colArr];
        
        [self.ringChart showAnimation];
        
        [self.ringChart setNeedsDisplay];
        
    }else{
        [self.fenbuLabel setHidden:YES];
        [self.ringChart setHidden:YES];
    }
}


@end
