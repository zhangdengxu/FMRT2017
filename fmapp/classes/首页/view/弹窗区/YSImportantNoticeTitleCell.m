//
//  YSImportantNoticeTitleCell.m
//  fmapp
//
//  Created by yushibo on 2016/9/21.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "YSImportantNoticeTitleCell.h"


@interface YSImportantNoticeTitleCell ()
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *chengweiLabel;

@end
@implementation YSImportantNoticeTitleCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
    }
    return self;
    
}
- (void)createContentView{
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"饭店开房呢四块浪费你屎壳郎饭你说达克罗宁发的啥夸得饭你说快递费你独守空房纳斯达克愤怒地说客服纳斯达克浪费你速度快愤怒地说客服";
    titleLabel.textColor = [UIColor colorWithHexString:@"#000000"];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(25);
        make.right.equalTo(self.contentView.mas_right).offset(-25);
        make.top.equalTo(self.contentView.mas_top).offset(10);
//        make.bottom.equalTo(view.mas_bottom).offset(-60);
    }];

    UILabel *chengweiLabel = [[UILabel alloc]init];
    chengweiLabel.textAlignment = NSTextAlignmentLeft;
//    chengweiLabel.backgroundColor = [UIColor grayColor];
    chengweiLabel.numberOfLines = 0;
//    chengweiLabel.text = self.ImportantNoticeModel.chengwei;
    chengweiLabel.text = @"和发动机的福克斯雷锋精神可浪费就但是看了飞机上都看到了富家大室看到了福建省的刻录机但是看了积分的可视对讲付款了三分就";
    chengweiLabel.textColor = [UIColor colorWithHexString:@"#000000"];
    chengweiLabel.font = [UIFont systemFontOfSize:18];
    self.chengweiLabel = chengweiLabel;
    [self.contentView addSubview:chengweiLabel];
    [chengweiLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(titleLabel.mas_bottom).offset(20);
        //        make.bottom.equalTo(view.mas_bottom).offset(-60);
    }];
}
-(void)setStatu1:(NSString *)statu1{

    self.titleLabel.text = statu1;
}
- (void)setStatu2:(NSString *)statu2{
    
    self.chengweiLabel.text = statu2;
}
@end
