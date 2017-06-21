//
//  FMRTyonghuleixingCell.m
//  fmapp
//
//  Created by apple on 2017/2/24.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRTyonghuleixingCell.h"
#import "JHChartHeader.h"
#import "FMRTPlatformModel.h"

@interface FMRTyonghuleixingCell ()
@property (nonatomic, strong) JHRingChart *yhlxChart;
@property (nonatomic, weak)UILabel *yhlxfbLabel;

@end


@implementation FMRTyonghuleixingCell

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
    
    UILabel *yhlxfbLabel = [[UILabel alloc]init];
    yhlxfbLabel.text = @"用户类型分布";
    self.yhlxfbLabel = yhlxfbLabel;
    yhlxfbLabel.font = [UIFont systemFontOfSize:18];
    yhlxfbLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:yhlxfbLabel];
    [yhlxfbLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.left).offset(25);
        make.top.equalTo(self.contentView.top).offset(30);
    }];
    

    [self.yhlxChart makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.height.equalTo(KProjectScreenWidth -110);
        make.top.equalTo(yhlxfbLabel.bottom);
    }];
    
}

- (JHRingChart *)yhlxChart{
    if (!_yhlxChart) {
        JHRingChart *ring = [[JHRingChart alloc] initWithFrame:CGRectMake(0, 100, KProjectScreenWidth, KProjectScreenWidth -110)];
        ring.backgroundColor = [UIColor clearColor];
        
        ring.ringWidth = 28.0;
        
        _yhlxChart = ring;
        [self.contentView addSubview:ring];
        
    }
    return _yhlxChart;
}

- (void)setModel:(FMRTPlatformModel *)model{
    _model = model;
    if (model.UserGradeStats.count) {
        [self.yhlxfbLabel setHidden:NO];
        [self.yhlxChart setHidden:NO];
        
        NSMutableArray *desArr = [NSMutableArray array];
        NSMutableArray *valueArr = [NSMutableArray array];
        NSMutableArray *coloArr = [NSMutableArray array];
        
        NSMutableArray *states = [NSMutableArray arrayWithArray:model.UserGradeStats];
//        [states exchangeObjectAtIndex:0 withObjectAtIndex:1];
        
        for (gradeState *fbmodel in states) {
            [desArr addObject:fbmodel.Desc];
            [valueArr addObject:fbmodel.Rate];
            
            if (![fbmodel.Color length]) {
                fbmodel.Color = @"#e4ebf1";
            }
            
            [coloArr addObject:[UIColor colorWithHexString:fbmodel.Color]];
        }
        
        self.yhlxChart.valueDescriptionArr = [NSArray arrayWithArray:desArr];
        
        self.yhlxChart.valueDataArr = [NSArray arrayWithArray:valueArr];
        self.yhlxChart.fillColorArray = [NSArray arrayWithArray:coloArr];
        
        [self.yhlxChart showAnimation];
        [self.yhlxChart setNeedsDisplay];
        
    }else{
        [self.yhlxfbLabel setHidden:YES];
        [self.yhlxChart setHidden:YES];
    }
}

@end
