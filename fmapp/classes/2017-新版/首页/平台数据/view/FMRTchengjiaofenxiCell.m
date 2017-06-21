//
//  FMRTchengjiaofenxiCell.m
//  fmapp
//
//  Created by apple on 2017/2/24.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRTchengjiaofenxiCell.h"
#import "JHChartHeader.h"
#import "FMRTPlatformModel.h"

@interface FMRTchengjiaofenxiCell ()

@property (nonatomic, strong) JHRingChart *cjxmChart;
@property (nonatomic, weak)UILabel *cjfxLabel,*centerCJLabel,*cjfxtext;

@end

@implementation FMRTchengjiaofenxiCell

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
    
    
#pragma mark - 成交项目分析
    UILabel *cjfxLabel = [[UILabel alloc]init];
    cjfxLabel.text = @"成交项目分析";
    self.cjfxLabel =cjfxLabel;
    cjfxLabel.font = [UIFont systemFontOfSize:25];
    cjfxLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:cjfxLabel];
    [cjfxLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.contentView.centerX);
        make.top.equalTo(self.contentView.top).offset(45);
    }];
    

    [self.cjxmChart makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(cjfxLabel.bottom).offset(-15);
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.height.equalTo(KProjectScreenWidth - 110);
    }];
    
    UILabel *centerCJLabel = [[UILabel alloc]init];
    centerCJLabel.text = @"累计成交项目\n3555个";
    centerCJLabel.numberOfLines = 0;
    self.centerCJLabel = centerCJLabel;
    centerCJLabel.textAlignment = NSTextAlignmentCenter;
    centerCJLabel.font = [UIFont systemFontOfSize:11];
    centerCJLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:centerCJLabel];
    [centerCJLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.cjxmChart.centerX);
        make.centerY.equalTo(self.cjxmChart.centerY);
    }];
    
    
    UILabel *cjfxtext = [[UILabel alloc]init];
    self.cjfxtext = cjfxtext;
    cjfxtext.text = @"项目逾期率：0% 逾期金额：0元";
    cjfxtext.font = [UIFont systemFontOfSize:15];
    cjfxtext.textColor = [UIColor colorWithHexString:@"#999999"];
    [self.contentView addSubview:cjfxtext];
    [cjfxtext makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.contentView.centerX);
        make.top.equalTo(self.cjxmChart.bottom);
    }];
    
    
}

- (JHRingChart *)cjxmChart{
    if (!_cjxmChart) {
        JHRingChart *ring = [[JHRingChart alloc] initWithFrame:CGRectMake(0, 100, KProjectScreenWidth, KProjectScreenWidth -110)];
        ring.backgroundColor = [UIColor clearColor];
        
        ring.ringWidth = 28.0;
        
        _cjxmChart = ring;
        [self.contentView addSubview:ring];
        
    }
    return _cjxmChart;
}


- (void)setModel:(Proj *)model{
    _model = model;
    
    if (model) {
        [self.cjxmChart setHidden:NO];
        [self.cjfxtext setHidden:NO];
        [self.cjfxLabel setHidden:NO];
        [self.centerCJLabel setHidden:NO];
        
        self.centerCJLabel.text = [NSString stringWithFormat:@"累计成交项目\n%@个",model.DealSum] ;
        self.cjfxtext.text = [NSString stringWithFormat:@"项目逾期率：%@%% 逾期金额：%@元",model.OverdueRate,model.OverdueAmt] ;
        
        NSMutableArray *desArr = [NSMutableArray array];
        NSMutableArray *valueArr = [NSMutableArray array];
        NSMutableArray *coloArr = [NSMutableArray array];

        if (model.DealStats.count) {
            for (zcjxmfx *fxm in model.DealStats) {
                [desArr addObject:fxm.Desc];
                [valueArr addObject:fxm.Rate];
                if (![fxm.Color length]) {
                    fxm.Color = @"#e4ebf1";
                }
                
                [coloArr addObject:[UIColor colorWithHexString:fxm.Color]];
            }
        }
        
        self.cjxmChart.valueDescriptionArr = [NSArray arrayWithArray:desArr];
        
        self.cjxmChart.valueDataArr = [NSArray arrayWithArray:valueArr];
        self.cjxmChart.fillColorArray = [NSArray arrayWithArray:coloArr];
        
        [self.cjxmChart showAnimation];
        [self.cjxmChart setNeedsDisplay];

    }else{
        [self.cjxmChart setHidden:YES];
        [self.cjfxtext setHidden:YES];
        [self.cjfxLabel setHidden:YES];
        [self.centerCJLabel setHidden:YES];
    }
    
}

@end
