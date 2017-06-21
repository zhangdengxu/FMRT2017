//
//  FMRTXMleixingTableViewCell.m
//  fmapp
//
//  Created by apple on 2017/2/24.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRTXMleixingTableViewCell.h"
#import "JHChartHeader.h"
#import "FMRTPlatformModel.h"

@interface FMRTXMleixingTableViewCell ()

@property (nonatomic, strong) JHRingChart *lxfbChart;
@property (nonatomic, weak)UILabel *lxfbLabel;

@end

@implementation FMRTXMleixingTableViewCell

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
#pragma mark - 融资项目类型分布
    UILabel *lxfbLabel = [[UILabel alloc]init];
    lxfbLabel.text = @"融资项目类型分布";
    self.lxfbLabel = lxfbLabel;
    lxfbLabel.font = [UIFont systemFontOfSize:25];
    lxfbLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:lxfbLabel];
    [lxfbLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.contentView.centerX);
        make.top.equalTo(self.contentView.top).offset(30);
    }];
    

    [self.lxfbChart makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(lxfbLabel.bottom).offset(-5);
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.height.equalTo(KProjectScreenWidth -110);
    }];
    
}

- (JHRingChart *)lxfbChart{
    if (!_lxfbChart) {
        JHRingChart *ring = [[JHRingChart alloc] initWithFrame:CGRectMake(0, 1500, KProjectScreenWidth, KProjectScreenWidth -110)];
        ring.backgroundColor = [UIColor clearColor];
        
        ring.ringWidth = 28.0;
        
        _lxfbChart = ring;
        [self.contentView addSubview:ring];
        
    }
    return _lxfbChart;
}

- (void)setModel:(FMRTPlatformModel *)model{
    _model = model;
    
    if (model.ProjTypeStats.count) {
        [self.lxfbChart setHidden:NO];
        [self.lxfbLabel setHidden:NO];
                
        NSMutableArray *desArr = [NSMutableArray array];
        NSMutableArray *valueArr = [NSMutableArray array];
        NSMutableArray *coloArr = [NSMutableArray array];
        for (xmqxfb *fbmodel in model.ProjTypeStats) {
            [desArr addObject:fbmodel.Desc];
            [valueArr addObject:fbmodel.Rate];
            if (![fbmodel.Color length]) {
                fbmodel.Color = @"#e4ebf1";
            }
            
            [coloArr addObject:[UIColor colorWithHexString:fbmodel.Color]];
        }
        
        self.lxfbChart.valueDescriptionArr = [NSArray arrayWithArray:desArr];
        
        self.lxfbChart.valueDataArr = [NSArray arrayWithArray:valueArr];
        self.lxfbChart.fillColorArray = [NSArray arrayWithArray:coloArr];
        
        [self.lxfbChart showAnimation];
        [self.lxfbChart setNeedsDisplay];
    }else{
        [self.lxfbChart setHidden:YES];
        [self.lxfbLabel setHidden:YES];
    }
    
}


@end
