//
//  FMRTProqixianCell.m
//  fmapp
//
//  Created by apple on 2017/2/24.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRTProqixianCell.h"
#import "JHChartHeader.h"
#import "FMRTPlatformModel.h"

@interface FMRTProqixianCell ()

@property (nonatomic, strong) JHRingChart *xmqxfbChart;
@property (nonatomic, weak)UILabel *xmqifbLabel;


@end

@implementation FMRTProqixianCell

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
    
#pragma mark - 融资项目期限分布
    UILabel *xmqifbLabel = [[UILabel alloc]init];
    xmqifbLabel.text = @"融资项目期限分布";
    self.xmqifbLabel= xmqifbLabel;
    xmqifbLabel.font = [UIFont systemFontOfSize:25];
    xmqifbLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:xmqifbLabel];
    [xmqifbLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.contentView.centerX);
        make.top.equalTo(self.contentView.top).offset(45);
    }];
    
    [self.xmqxfbChart makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(xmqifbLabel.bottom).offset(-15);
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.height.equalTo(KProjectScreenWidth - 110);
    }];
    
}


- (JHRingChart *)xmqxfbChart{
    if (!_xmqxfbChart) {
        JHRingChart *ring = [[JHRingChart alloc] initWithFrame:CGRectMake(0, 100, KProjectScreenWidth, KProjectScreenWidth -110)];
        ring.backgroundColor = [UIColor clearColor];
        
        ring.ringWidth = 28.0;
        
        _xmqxfbChart = ring;
        [self.contentView addSubview:ring];
        
    }
    return _xmqxfbChart;
}

- (void)setModel:(FMRTPlatformModel *)model{
    _model = model;
    if (model.ProjPeriod.count) {
        [self.xmqifbLabel setHidden:NO];
        [self.xmqxfbChart setHidden:NO];
        
        
        NSMutableArray *desArr = [NSMutableArray array];
        NSMutableArray *valueArr = [NSMutableArray array];
        NSMutableArray *coloArr = [NSMutableArray array];
        for (xmqxfb *fbmodel in model.ProjPeriod) {
            [desArr addObject:fbmodel.Desc];
            [valueArr addObject:fbmodel.Rate];
            if (![fbmodel.Color length]) {
                fbmodel.Color = @"#e4ebf1";
            }
            
            [coloArr addObject:[UIColor colorWithHexString:fbmodel.Color]];
        }
        
        self.xmqxfbChart.valueDescriptionArr = [NSArray arrayWithArray:desArr];
        
        self.xmqxfbChart.valueDataArr = [NSArray arrayWithArray:valueArr];
        self.xmqxfbChart.fillColorArray = [NSArray arrayWithArray:coloArr];
        
        [self.xmqxfbChart showAnimation];
        [self.xmqxfbChart setNeedsDisplay];
        
    }else{
        [self.xmqifbLabel setHidden:YES];
        [self.xmqxfbChart setHidden:YES];
    }
    
}

@end
