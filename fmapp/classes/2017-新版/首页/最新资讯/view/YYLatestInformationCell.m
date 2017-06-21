//
//  YYLatestInformationCell.m
//  fmapp
//
//  Created by yushibo on 2016/11/30.
//  Copyright © 2016年 yk. All rights reserved.
//  最新资讯展开页

#import "YYLatestInformationCell.h"
#import "HexColor.h"
#import "Fm_Tools.h"
@interface YYLatestInformationCell ()
/** 标题  */
@property (nonatomic, strong) UILabel *title;
/** 摘要 */
@property (nonatomic, strong) UILabel *zhaiyao;
/** 时间 */
@property (nonatomic, strong) UILabel *addtime;
@end
@implementation YYLatestInformationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
    }
    return self;
}

- (void)createContentView{

    UIImageView *rightArrow = [[UIImageView alloc]init];
    rightArrow.image = [UIImage imageNamed:@"投资理财_小返回_36"];
    [self.contentView addSubview:rightArrow];
    [rightArrow makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.title = titleLabel;
    [self.contentView addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-40);
        make.left.equalTo(self.contentView.mas_left).offset(25);
        make.top.equalTo(self.contentView.mas_top).offset(15);
    }];
    
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.numberOfLines = 0;
//    contentLabel.backgroundColor = [UIColor redColor];
    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    self.zhaiyao = contentLabel;
    [self.contentView addSubview:contentLabel];
    [contentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(titleLabel.mas_right);
        make.left.equalTo(self.contentView.mas_left).offset(26);
        make.top.equalTo(titleLabel.mas_bottom).offset(8);
        make.height.equalTo(40);
    }];
    
    UILabel *timeLabel = [[UILabel alloc]init];
//    timeLabel.backgroundColor = [UIColor redColor];
    timeLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    self.addtime = timeLabel;
    [self.contentView addSubview:timeLabel];
    [timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(29);
        make.top.equalTo(contentLabel.mas_bottom).offset(7);
    }];
    
    UIView *lineV = [[UIView alloc]init];
    lineV.backgroundColor = [UIColor colorWithHexString:@"e5e9f2"];
    [self.contentView addSubview:lineV];
    [lineV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(18);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.equalTo(1);
    }];
    
}
- (void)setStatus:(YYLatestInformationModel *)status{

    _status = status;
    
    self.title.text = status.title;
    self.zhaiyao.text = status.zhaiyao;
    self.addtime.text = [Fm_Tools getTimeFromString:status.addtime];
    
}
@end
