//
//  WLJYJTableViewCell.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/7/6.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "WLJYJTableViewCell.h"
#import "XZBankListModel.h"

@interface WLJYJTableViewCell ()
@property (nonatomic, strong) UIImageView *imgPhoto;
@property (nonatomic, strong) UILabel *labelName;
@property (nonatomic, strong) UILabel *detailLabelName;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation WLJYJTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setUpBankListCell];
    }
    [self setBackgroundColor:[UIColor colorWithRed:244/255.0f green:245/255.0f blue:246/255.0f alpha:1]];
    return self;
}

- (void)setUpBankListCell {
    
    
    UIImageView *imgPhoto = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 38, 38)];
    imgPhoto.layer.masksToBounds = YES;
    imgPhoto.layer.cornerRadius = 19;
    [self.contentView addSubview:imgPhoto];
    self.imgPhoto = imgPhoto;
//    imgPhoto.contentMode = UIViewContentModeScaleAspectFill;
    
    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(65, 10, KProjectScreenWidth-75, 25)];
    [labelName setFont:[UIFont boldSystemFontOfSize:16]];
    [labelName setTextColor:[UIColor colorWithRed:7/255.0f green:64/255.0f blue:143/255.0f alpha:1]];
    [self.contentView addSubview:labelName];
    self.labelName = labelName;
    
    UILabel *detailLabelName = [[UILabel alloc]initWithFrame:CGRectMake(65, 35, KProjectScreenWidth-75, 20)];
    [detailLabelName setFont:[UIFont boldSystemFontOfSize:14]];
    [detailLabelName setTextColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.9]];
    [self.contentView addSubview:detailLabelName];
    self.detailLabelName = detailLabelName;
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(KProjectScreenWidth-180, 10, 150, 25)];
    [timeLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [timeLabel setTextColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.6]];
    [timeLabel setTextAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth-20, 1)];
    [lineView setBackgroundColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.2]];
    [self.contentView addSubview:lineView];
    
}


- (void)setBankModel:(XZBankListModel *)bankModel {
    _bankModel = bankModel;
    UIImage *placeImg = [UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"];
        
        [self.imgPhoto sd_setImageWithURL:[NSURL URLWithString:bankModel.avatar]  placeholderImage:placeImg];
        self.labelName.text = [NSString stringWithFormat:@"%@",bankModel.uname];
        self.detailLabelName.text = [NSString stringWithFormat:@"%@",bankModel.comment];
        self.timeLabel.text = [NSString stringWithFormat:@"%@",bankModel.commentime];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
