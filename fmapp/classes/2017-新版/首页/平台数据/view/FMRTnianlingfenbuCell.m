//
//  FMRTnianlingfenbuCell.m
//  fmapp
//
//  Created by apple on 2017/2/24.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRTnianlingfenbuCell.h"
#import "JHChartHeader.h"
#import "FMRTPlatformModel.h"

@interface FMRTnianlingfenbuCell ()
@property (nonatomic, strong) JHColumnChart *columnChart;
@property (nonatomic, weak)UILabel *nlfbLabel;


@end

@implementation FMRTnianlingfenbuCell

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
    
    UILabel *nlfbLabel = [[UILabel alloc]init];
    nlfbLabel.text = @"年龄分布";
    self.nlfbLabel = nlfbLabel;
    nlfbLabel.font = [UIFont systemFontOfSize:18];
    nlfbLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:nlfbLabel];
    [nlfbLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.left).offset(25);
        make.top.equalTo(self.contentView.top).offset(20);
    }];
    
    [self.columnChart makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.height.equalTo(@320);
        make.top.equalTo(nlfbLabel.bottom).offset(-10);
    }];
    
}


- (JHColumnChart *)columnChart{
    if (!_columnChart) {
        JHColumnChart *column = [[JHColumnChart alloc] initWithFrame:CGRectMake(0, 64, KProjectScreenWidth, 320)];
        _columnChart = column;

        NSInteger leftX = 0;
        if (KProjectScreenWidth >=375) {
            leftX = 0;
        }else{
            leftX = -35;
        }
        
        column.bgVewBackgoundColor = [UIColor clearColor];
        column.originSize = CGPointMake(leftX, 20);
        column.drawTextColorForX_Y = [UIColor colorWithHexString:@"#333333"];
        column.drawFromOriginX = leftX;
        column.typeSpace = 50;
        column.xDescTextFontSize = 12;
        column.isShowYLine = NO;
        column.needXandYLine = NO;
        
        column.columnWidth = 35;
        [self.contentView addSubview:column];
    }
    return _columnChart;
}


- (void)setModel:(FMRTPlatformModel *)model{
    _model = model;
    if (model.UserAgeStats.count) {
        [self.nlfbLabel setHidden:NO];
        [self.columnChart setHidden:NO];
        
        NSMutableArray *xArr = [NSMutableArray array];
        NSMutableArray *valueArr = [NSMutableArray array];
        
        for (UserAgeStats *mmm in model.UserAgeStats) {
            
            [xArr addObject:mmm.Desc];
            NSArray *arr = [NSArray arrayWithObject:mmm.Rate];
            [valueArr addObject:arr];
        }
        
        self.columnChart.xShowInfoText = [NSArray arrayWithArray:xArr];
        self.columnChart.valueArr = [NSArray arrayWithArray:valueArr];
        
        [self.columnChart showAnimation];
        [self.columnChart setNeedsDisplay];
        
    }else{
        [self.nlfbLabel setHidden:YES];
        [self.columnChart setHidden:YES];
    }
}


@end
