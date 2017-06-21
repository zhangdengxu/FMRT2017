//
//  YSImportantNoticeSecondNewView.m
//  fmapp
//
//  Created by yushibo on 2016/9/22.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "YSImportantNoticeSecondNewView.h"


@interface YSImportantNoticeSecondNewView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *chengweiLabel;
@property (nonatomic, strong) UILabel *neirongLabel;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, assign) CGFloat scHeight;
@property (nonatomic, strong) UIImageView *imageV;
@end
@implementation YSImportantNoticeSecondNewView
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        
    }
    return self;
    
}
- (void)setImportantNoticeModel:(YSImportantNoticeModel *)ImportantNoticeModel{
    
    _ImportantNoticeModel = ImportantNoticeModel;

    /**
     *  标题高度
     */
    CGFloat titleW = KProjectScreenWidth - 130;
    CGSize titleMaxSize = CGSizeMake(titleW, MAXFLOAT);
    NSDictionary *titleAttrs = @{NSFontAttributeName : [UIFont systemFontOfSize:18]};
    CGFloat titleH = [ImportantNoticeModel.title boundingRectWithSize:titleMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttrs context:nil].size.height;
    /**
     *  称谓高度
     */
    CGFloat chengweiW = KProjectScreenWidth - 110;
    CGSize chengweiMaxSize = CGSizeMake(chengweiW, MAXFLOAT);
    NSDictionary *chengweiAttrs = @{NSFontAttributeName : [UIFont systemFontOfSize:18]};
    CGFloat chengweiH = [ImportantNoticeModel.chengwei boundingRectWithSize:chengweiMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:chengweiAttrs context:nil].size.height;
    /**
     *  内容高度
     */
    NSString *content = [NSString string];
    for (int i = 0; i < [ImportantNoticeModel.neirong count] ; i++) {
        
        if (i == 0) {
            
            content =[NSString stringWithFormat:@"        %@", ImportantNoticeModel.neirong[i]];
        }else{
            
            content =[NSString stringWithFormat:@"%@\n\n        %@",content, ImportantNoticeModel.neirong[i]];
        }
    }
    CGFloat textW = KProjectScreenWidth - 110;
    CGSize textMaxSize = CGSizeMake(textW, MAXFLOAT);
    NSDictionary *textAttrs = @{NSFontAttributeName : [UIFont systemFontOfSize:18]};
    CGFloat textH = [content boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttrs context:nil].size.height;
    /**
     *  发布者高度
     */
    CGFloat authorW = KProjectScreenWidth - 130;
    CGSize authorMaxSize = CGSizeMake(authorW, MAXFLOAT);
    NSDictionary *authorAttrs = @{NSFontAttributeName : [UIFont systemFontOfSize:18]};
    CGFloat authorH = [ImportantNoticeModel.author boundingRectWithSize:authorMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:authorAttrs context:nil].size.height;
    /**
     *  时间高度
     */
    CGFloat dateW = KProjectScreenWidth - 110;
    CGSize dateMaxSize = CGSizeMake(dateW, MAXFLOAT);
    NSDictionary *dateAttrs = @{NSFontAttributeName : [UIFont systemFontOfSize:18]};
    CGFloat dateH = [ImportantNoticeModel.date boundingRectWithSize:dateMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dateAttrs context:nil].size.height;
    CGFloat scHeight =titleH + chengweiH + textH + authorH + dateH + 110 + 20;
    /**
     *  滚动高度
     */
    self.scHeight = scHeight;
    /**
     *  创建视图
     */
    [self createContentView];
    /**
     *  赋值
     */
//    [self.imageV sd_setImageWithURL:[NSURL URLWithString:ImportantNoticeModel.pic]];
//    self.imageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:ImportantNoticeModel.pic] placeholderImage:[UIImage imageNamed:@"announce_perch_img"]];
    Log(@"%@",self.imageV);
    self.titleLabel.text = ImportantNoticeModel.title;
    self.chengweiLabel.text = ImportantNoticeModel.chengwei;
    self.neirongLabel.text = content;
    self.authorLabel.text = ImportantNoticeModel.author;
    self.dateLabel.text = ImportantNoticeModel.date;


}

- (void)createContentView{
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    /**
     *  背景backView
     */
    UIView *backView = [[UIView alloc]init];
    backView.userInteractionEnabled = YES;
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    [backView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(40);
        make.right.equalTo(self.mas_right).offset(-40);
        make.top.equalTo(self.mas_top).offset(KProjectScreenHeight / 10);
        make.bottom.equalTo(self.mas_bottom).offset(-(KProjectScreenHeight / 9));
    }];
    /**
     *  上部图片
     */
    UIImageView *imageV = [[UIImageView alloc]init];
    self.imageV = imageV;
    [backView addSubview:imageV];
    [imageV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left);
        make.right.equalTo(backView.mas_right);
        make.top.equalTo(backView.mas_top);
        make.height.equalTo(((KProjectScreenWidth - 80) * 350) / 972);
    }];
    /**
     *  底部按钮
     */
    UIButton *knowBtn = [[UIButton alloc]init];
    knowBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    knowBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [knowBtn setTitle:@"我知道了" forState:UIControlStateNormal];
    [knowBtn setTitleColor:[UIColor colorWithHexString:@"#0159D5"] forState:UIControlStateNormal];
    [knowBtn addTarget:self action:@selector(knowAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:knowBtn];
    [knowBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left);
        make.right.equalTo(backView.mas_right);
        make.bottom.equalTo(backView.mas_bottom);
        make.height.equalTo( (KProjectScreenWidth * 350) / 972 / 2);
    }];
    
    UIView *lineV = [[UIView alloc]init];
    lineV.backgroundColor = [UIColor grayColor];
    [backView addSubview:lineV];
    [lineV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left);
        make.right.equalTo(backView.mas_right);
        make.bottom.equalTo(knowBtn.mas_top);
        make.height.equalTo(@1);
    }];
    /**
     *  滚动scrollView
     */
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.mainScrollView.userInteractionEnabled = YES;
//    self.mainScrollView.backgroundColor = [UIColor redColor];
    self.mainScrollView.showsVerticalScrollIndicator = YES;
    self.mainScrollView.scrollEnabled = YES;
    self.mainScrollView.bounces = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.contentSize = CGSizeMake(0, self.scHeight);
    [backView addSubview:self.mainScrollView];
    [self.mainScrollView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left);
        make.right.equalTo(backView.mas_right);
        make.bottom.equalTo(lineV.mas_top);
        make.top.equalTo(imageV.mas_bottom);
    }];
    
    UIView * contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth - 80, self.scHeight)];
//    contentView.backgroundColor = [UIColor greenColor];
    [self.mainScrollView addSubview:contentView];
    
    /**
     *  标题
     */
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = [UIColor colorWithHexString:@"#000000"];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel = titleLabel;
    [contentView addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(25);
        make.top.equalTo(contentView.mas_top).offset(10);
        make.width.equalTo(KProjectScreenWidth - 130);
    }];
    /**
     *  称谓
     */
    UILabel *chengweiLabel = [[UILabel alloc]init];
    chengweiLabel.textAlignment = NSTextAlignmentLeft;
    chengweiLabel.numberOfLines = 0;
    chengweiLabel.textColor = [UIColor colorWithHexString:@"#000000"];
    chengweiLabel.font = [UIFont systemFontOfSize:18];
    self.chengweiLabel = chengweiLabel;
    [contentView addSubview:chengweiLabel];
    [chengweiLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(15);
        make.width.equalTo(KProjectScreenWidth - 110);
        make.top.equalTo(titleLabel.mas_bottom).offset(20);
    }];
//
    /** 文段落  */
    UILabel * neirongLabel = [[UILabel alloc]init];
    neirongLabel.font = [UIFont systemFontOfSize:18];
//    neirongLabel.backgroundColor = [UIColor greenColor];
    neirongLabel.numberOfLines = 0;
    neirongLabel.textColor = [UIColor colorWithHexString:@"#000000"];
    self.neirongLabel = neirongLabel;
    [contentView addSubview:neirongLabel];
    [neirongLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(15);
        make.width.equalTo(KProjectScreenWidth - 110);
        make.top.equalTo(self.chengweiLabel.mas_bottom).offset(20);
    }];
    /**
     *  发布者
     */
    UILabel *authorLabel = [[UILabel alloc]init];
    authorLabel.textAlignment = NSTextAlignmentRight;
    authorLabel.numberOfLines = 0;
    authorLabel.textColor = [UIColor colorWithHexString:@"#000000"];
    authorLabel.font = [UIFont boldSystemFontOfSize:18];
    self.authorLabel = authorLabel;
    [contentView addSubview:authorLabel];
    [authorLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(15);
        make.width.equalTo(KProjectScreenWidth - 110);
        make.top.equalTo(self.neirongLabel.mas_bottom).offset(40);
    }];
    /**
     *  时间
     */
    UILabel *dateLabel = [[UILabel alloc]init];
    dateLabel.textAlignment = NSTextAlignmentRight;
    dateLabel.numberOfLines = 0;
    dateLabel.textColor = [UIColor colorWithHexString:@"#000000"];
    dateLabel.font = [UIFont systemFontOfSize:18];
    self.dateLabel = dateLabel;
    
    [contentView addSubview:dateLabel];
    [dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(15);
        make.width.equalTo(KProjectScreenWidth - 110);
        make.top.equalTo(authorLabel.mas_bottom).offset(20);
    }];

}

- (void)knowAction:(UIButton *)button{
    
    [self removeFromSuperview];
}
@end
