//
//  YSImportantNoticeCell.m
//  fmapp
//
//  Created by yushibo on 16/9/21.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "YSImportantNoticeCell.h"


@interface YSImportantNoticeCell ()
@property (nonatomic, strong)UILabel *neirongLabel;
@end

@implementation YSImportantNoticeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
    }
    return self;
    
}
- (void)createContentView{
    
    /** 文段落  */
    UILabel * neirongLabel = [[UILabel alloc]init];
    neirongLabel.font = [UIFont systemFontOfSize:18];
    neirongLabel.backgroundColor = [UIColor greenColor];
    neirongLabel.numberOfLines = 0;
    neirongLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    neirongLabel.textAlignment = NSTextAlignmentLeft;
    neirongLabel.textColor = [UIColor colorWithHexString:@"#000000"];
    self.neirongLabel = neirongLabel;
    [self.contentView addSubview:neirongLabel];
    [neirongLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
//        make.bottom.equalTo(self.contentView.mas_bottom).offset(-20);
    }];
    Log(@"*****%f******%@", neirongLabel.frame.size.height, neirongLabel.text);
}
///**
// *  布局子控件
// */
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    CGFloat textW = KProjectScreenWidth - 110;
//    CGSize textMaxSize = CGSizeMake(textW, MAXFLOAT);
//    NSDictionary *textAttrs = @{NSFontAttributeName : [UIFont systemFontOfSize:20]};
//    CGFloat textH = [[NSString stringWithFormat:@"      %@", self.status] boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttrs context:nil].size.height;
//    self.neirongLabel.frame = CGRectMake(0, 0, textW, textH);
//
//}
- (void)setStatus:(NSArray *)status{

    NSString *content = [NSString string];

    for (int i = 0; i < [status count] ; i++) {
//        NSString *content = [NSString string];
        if (i == 0) {
            content =[NSString stringWithFormat:@"        %@", status[i]];
        }else{
            content =[NSString stringWithFormat:@"%@\n\n        %@",content, status[i]];
        }
        
    }
//    content = @"打开就看懂巨款是没看电视看vc没贷款率赌命烤串撒旦了妈的了马克思领导们 麦迪时刻拉麻烦考虑到是麻烦考了多少穆克拉麻烦 莫德凯撒两方面的顺口溜麻烦速度快了父母的斯科拉没电了萨没法打了是模仿考了多少麻烦快点拉萨马上到可拉伸到昆明路\n扫防静电咳嗽安静的口水金佛看电视剧空大\n单家三口放大镜看撒娇反倒是咖啡机的顺口溜方\n";
    self.neirongLabel.text = content;
}
//- (void)setStatus:(NSString *)status{

  
//}

+(CGFloat)hightForCellWithModel:(NSString *)status{
    CGFloat textW = KProjectScreenWidth - 110;
    CGSize textMaxSize = CGSizeMake(textW, MAXFLOAT);
    NSDictionary *textAttrs = @{NSFontAttributeName : [UIFont systemFontOfSize:18]};
    CGFloat textH = [status boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttrs context:nil].size.height;
    return textH +30;

}

@end
