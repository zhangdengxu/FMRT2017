//
//  YSBiddingRulesViewCell.m
//  fmapp
//
//  Created by yushibo on 16/8/10.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "YSBiddingRulesViewCell.h"


@interface YSBiddingRulesViewCell ()

@property (nonatomic, strong)UILabel *text_Label;

@end
@implementation YSBiddingRulesViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#e5e9f2"];
    }
    return self;
}

- (void)createContentView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 1)];
    view.backgroundColor = KDefaultOrBackgroundColor;
    UILabel *text_Label = [[UILabel alloc]init];
    text_Label.font = [UIFont systemFontOfSize:14];
    text_Label.numberOfLines = 0;
    [text_Label setLineBreakMode:NSLineBreakByWordWrapping];
    self.text_Label = text_Label;
    [self.contentView addSubview:view];
    [self.contentView addSubview:text_Label];
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat textW = self.contentView.frame.size.width - 20;
    CGSize textMaxSize = CGSizeMake(textW, MAXFLOAT);
    NSDictionary *textAttrs = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
    CGFloat textH = [self.dataSource.content boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttrs context:nil].size.height;
    self.text_Label.frame = CGRectMake(10, 10, textW, textH);
}
- (void)setDataSource:(YSBiddingRulesModel *)dataSource{
    
    _dataSource = dataSource;
    self.text_Label.text = dataSource.content;
    
}

@end
