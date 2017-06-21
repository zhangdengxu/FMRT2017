//
//  FMRTBackEarningSectionView.m
//  fmapp
//
//  Created by apple on 2017/2/21.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRTBackEarningSectionView.h"

@implementation FMRTBackEarningSectionView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = XZColor(249, 249, 249);
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"项目编号";
    nameLabel.textColor = [UIColor colorWithHexString:@"#666"];
    nameLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:nameLabel];
    
    [nameLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.left).offset(10);
        make.centerY.equalTo(self.centerY);
    }];
    
    UILabel *earnLabel = [[UILabel alloc]init];
    earnLabel.text = @"应发佣金(元)";
    earnLabel.textColor = [UIColor colorWithHexString:@"#666"];
    earnLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:earnLabel];
    
    [earnLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.centerX).offset(20);
        make.centerY.equalTo(self.centerY);
    }];
    
    UILabel *totalLabel = [[UILabel alloc]init];
    totalLabel.text = @"到期资产(万)";
    totalLabel.textColor = [UIColor colorWithHexString:@"#666"];

    totalLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:totalLabel];
    
    [totalLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.right).offset(-10);
        make.centerY.equalTo(self.centerY);
    }];
}

@end
