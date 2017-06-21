//
//  YSImportantNoticeFooterCell.m
//  fmapp
//
//  Created by yushibo on 2016/9/21.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "YSImportantNoticeFooterCell.h"


@interface YSImportantNoticeFooterCell ()
@property (nonatomic, strong)UILabel *authorLabel;
@property (nonatomic, strong)UILabel *dateLabel;

@end

@implementation YSImportantNoticeFooterCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
    }
    return self;
    
}
- (void)createContentView{
    
    UILabel *authorLabel = [[UILabel alloc]init];
    authorLabel.textAlignment = NSTextAlignmentRight;
    authorLabel.numberOfLines = 0;
    //    titleLabel.text = @"饭店开房呢四块浪费你屎壳郎饭你说达克罗宁发的啥夸得饭你说快递费你独守空房纳斯达克愤怒地说客服纳斯达克浪费你速度快愤怒地说客服";
    authorLabel.textColor = [UIColor colorWithHexString:@"#000000"];
    authorLabel.font = [UIFont boldSystemFontOfSize:18];
    self.authorLabel = authorLabel;
    [self.contentView addSubview:authorLabel];
    [authorLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        //        make.bottom.equalTo(view.mas_bottom).offset(-60);
    }];
    
    UILabel *dateLabel = [[UILabel alloc]init];
    dateLabel.textAlignment = NSTextAlignmentRight;
//    dateLabel.backgroundColor = [UIColor grayColor];
    dateLabel.numberOfLines = 0;
    //    chengweiLabel.text = self.ImportantNoticeModel.chengwei;
    //    chengweiLabel.text = @"和发动机的福克斯雷锋精神可浪费就但是看了飞机上都看到了富家大室看到了福建省的刻录机但是看了积分的可视对讲付款了三分就";
    dateLabel.textColor = [UIColor colorWithHexString:@"#000000"];
    dateLabel.font = [UIFont systemFontOfSize:18];
    self.dateLabel = dateLabel;
    [self.contentView addSubview:dateLabel];
    [dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(authorLabel.mas_bottom).offset(20);
        //        make.bottom.equalTo(view.mas_bottom).offset(-60);
    }];
}
- (void)setAuthorStatu:(NSString *)authorStatu
{
    self.authorLabel.text = authorStatu;
}
- (void)setDateStatu:(NSString *)dateStatu{

    self.dateLabel.text = dateStatu;
}
@end
