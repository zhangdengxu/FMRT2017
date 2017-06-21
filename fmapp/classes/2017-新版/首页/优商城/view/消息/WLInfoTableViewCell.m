//
//  WLInfoTableViewCell.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/4/26.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "WLInfoTableViewCell.h"

@interface WLInfoTableViewCell()

@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UIImageView *titleImageV;
@property(nonatomic,strong)UILabel *titleLabel1;
@property(nonatomic,strong)UILabel *titleLabel2;

@end

@implementation WLInfoTableViewCell

+ (instancetype)cellLingQianHasSaved:(UITableView *)tableView {
    static NSString *ReuseIdentifier = @"RongXiaoxi";
    WLInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReuseIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.contentView.backgroundColor = KDefaultOrBackgroundColor;
        [self createContentView];
    }
    return self;
}

-(void)createContentView{

    UIView *View = [[UIView alloc]initWithFrame:CGRectMake(15, 30, KProjectScreenWidth-30, (KProjectScreenWidth-30)*262/580+104)];
    View.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:View];

    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth-30, (KProjectScreenWidth-30)*262/580)];
    [View addSubview:imageV];
    self.titleImageV = imageV;
    
    [View.layer setCornerRadius:3.0f];
    [View.layer setMasksToBounds:YES];
    [View setUserInteractionEnabled:YES];
    
    UILabel *titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(10, (KProjectScreenWidth-30)*262/580+12, KProjectScreenWidth-50, 20)];
    titleLabel1.text = @"2周年豪礼庆生，缤纷惊喜送不停";
    titleLabel1.font = [UIFont boldSystemFontOfSize:16];
    titleLabel1.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.9];
    [View addSubview:titleLabel1];
    self.titleLabel1 = titleLabel1;
    
    UILabel *titleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(10, (KProjectScreenWidth-30)*262/580+40, KProjectScreenWidth-50, 20)];
    titleLabel2.text = @"2周年豪礼庆生，缤纷惊喜送不停";
    titleLabel2.font = [UIFont boldSystemFontOfSize:14];
    titleLabel2.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.7];
    [View addSubview:titleLabel2];
    self.titleLabel2 = titleLabel2;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, View.frame.size.height-35, KProjectScreenWidth-30, 1)];
    [lineView setBackgroundColor:KDefaultOrBackgroundColor];
    [View addSubview:lineView];
    
    UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, View.frame.size.height-35, KProjectScreenWidth-20-30-5, 35)];
    bottomLabel.text = @"查看详情";
    bottomLabel.font = [UIFont systemFontOfSize:14.0f];
    bottomLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.9];
    bottomLabel.textAlignment = NSTextAlignmentRight;
    [View addSubview:bottomLabel];
    
    UIImageView *imageV1 = [[UIImageView alloc]initWithFrame:CGRectMake(KProjectScreenWidth-20-30, View.frame.size.height-25+1.5, 7, 12)];
    [imageV1 setImage:[UIImage imageNamed:@"箭头_103"]];
    [View addSubview:imageV1];

    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 30)];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.text = @"2014/4/10";
    timeLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.6];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
}

- (void)setModel:(WLInfoModel *)detailModel{

    [self.timeLabel setText:detailModel.time];
    [self.titleLabel1 setText:detailModel.title];
    [self.titleLabel2 setText:detailModel.Info];
    [self.titleImageV sd_setImageWithURL:[NSURL URLWithString:detailModel.img] placeholderImage:nil];

}

+(CGFloat)hightForCell {
    
    return (KProjectScreenWidth-30)*262/580+104+30;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
