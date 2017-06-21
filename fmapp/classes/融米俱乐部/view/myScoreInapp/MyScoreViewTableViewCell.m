//
//  MyScoreViewTableViewCell.m
//  fmapp
//
//  Created by runzhiqiu on 16/1/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "MyScoreViewTableViewCell.h"

@interface MyScoreViewTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *addAndreduce;

@property (weak, nonatomic) IBOutlet UILabel *addAndReduceType;

@property (weak, nonatomic) IBOutlet UILabel *showTime;

@end

@implementation MyScoreViewTableViewCell

-(void)setDataSource:(NSDictionary *)dataSource
{
    _dataSource = dataSource;
    
    if (dataSource) {
        if ([dataSource[@"jiajian"] isEqualToString:@"1"]) {
            self.addAndreduce.textColor = [UIColor greenColor];
            self.addAndreduce.text = [NSString stringWithFormat:@"+%@",dataSource[@"fenshu"]];
        }else
        {
            self.addAndreduce.textColor = [UIColor redColor];
            self.addAndreduce.text = [NSString stringWithFormat:@"-%@",dataSource[@"fenshu"]];
        }
        self.addAndReduceType.text = dataSource[@"leixing"];
        self.showTime.text = dataSource[@"shijian"];
    }
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
