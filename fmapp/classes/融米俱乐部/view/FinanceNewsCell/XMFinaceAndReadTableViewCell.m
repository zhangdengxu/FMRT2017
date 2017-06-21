//
//  XMFinaceAndReadTableViewCell.m
//  fmapp
//
//  Created by runzhiqiu on 16/2/24.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "XMFinaceAndReadTableViewCell.h"
#import "FMBeautifulModel.h"
@interface XMFinaceAndReadTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UILabel *timelabel;

@end

@implementation XMFinaceAndReadTableViewCell

-(void)setDataSource:(FMBeautifulModel *)dataSource
{
    _dataSource = dataSource;
    
    if (dataSource) {
        
        if (![dataSource.thumb isMemberOfClass:[NSNull class]]) {
                [self.iconImage sd_setImageWithURL:[NSURL URLWithString:dataSource.thumb] placeholderImage:[UIImage imageNamed:@"敬请稍后new_03"]];
        }else
        {
            [self.iconImage setImage:[UIImage imageNamed:@"敬请稍后new_03"]];
        }
        
        if (![dataSource.title isMemberOfClass:[NSNull class]]) {
             self.titlelabel.text = dataSource.title;
        }else
        {
            self.titlelabel.text = @"";
        }
        
        if (![dataSource.author isMemberOfClass:[NSNull class]]) {
            self.detailLabel.text = dataSource.author;
        }else
        {
         self.detailLabel.text = @"";
        }
        
        if (![dataSource.addtime isMemberOfClass:[NSNull class]]) {
            self.timelabel.text = dataSource.addtime;
        }else
        {
            self.titlelabel.text = @"";
        }
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
