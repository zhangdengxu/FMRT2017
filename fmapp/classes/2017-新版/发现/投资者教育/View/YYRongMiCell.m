//
//  YYRongMiCell.m
//  fmapp
//
//  Created by yushibo on 2017/3/10.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "YYRongMiCell.h"
@interface YYRongMiCell ()
/** 标题  */
@property (nonatomic, strong) UILabel *title;
/** 摘要 */
@property (nonatomic, strong) UILabel *zhaiyao;
/** 时间 */
@property (nonatomic, strong) UILabel *addtime;
/** 图片 */
@property (nonatomic, strong) UIImageView *imageV;
/** 作者 */
@property (nonatomic, strong) UILabel *author;
@end
@implementation YYRongMiCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
//        self.backgroundColor = [UIColor greenColor];
    }
    return self;
}

- (void)createContentView{
    
    UIImageView *imageV = [[UIImageView alloc]init];
//    imageV.backgroundColor = [UIColor orangeColor];
    self.imageV = imageV;
    [self.contentView addSubview:imageV];
    [imageV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.width.equalTo(90);
        make.height.equalTo(63);
        make.top.equalTo(self.contentView.mas_top).offset(10);
//        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    UIImageView *centerView = [[UIImageView alloc]init];
    centerView.image = [UIImage imageNamed:@"融米学堂_关闭小icon__1702"];
    centerView.contentMode = UIViewContentModeScaleAspectFit;
    [imageV addSubview:centerView];
    [centerView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(imageV);
    }];

    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"jfkdsjdkls";
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [HXColor colorWithHexString:@"#333333"];
    titleLabel.numberOfLines = 2;
    self.title = titleLabel;
    [self.contentView addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageV.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        //        make.height.equalTo(50);
    }];
    
    UILabel *author = [[UILabel alloc]init];
    author.text =@"小融微言";
    author.font = [UIFont systemFontOfSize:14];
    self.author = author;
    author.textColor = [HXColor colorWithHexString:@"#999999"];
    [self.contentView addSubview:author];
    [author makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_left);
        make.width.equalTo(80);
        make.bottom.equalTo(imageV.mas_bottom);
    }];
    
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.text =@"小融微言";
    self.addtime = timeLabel;
    timeLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.textColor = [HXColor colorWithHexString:@"#999999"];
    [self.contentView addSubview:timeLabel];
    [timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.equalTo(author.mas_bottom);
    }];
    
    
}

-(void)setStatus:(YYLatestInformationModel *)status{
    
    _status = status;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.rongtuojinrong.com%@",status.videoThumb]] placeholderImage:[UIImage imageNamed:@"新版_默认头像_36"]];
    self.title.text = status.title;
    self.zhaiyao.text = status.zhaiyao;
    self.addtime.text = status.addtime;
    self.author.text = status.author;
    
    
}
@end
