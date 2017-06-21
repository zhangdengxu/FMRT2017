//
//  YYinstructionsCell.m
//  fmapp
//
//  Created by yushibo on 2016/12/20.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "YYinstructionsCell.h"
@interface YYinstructionsCell ()
/**  标题 */
@property (nonatomic, strong) UILabel *title;
/**  内容 */
@property (nonatomic, strong) UILabel *content;


@end
@implementation YYinstructionsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        [self createContentView];
    }
    return self;
}
- (void)createContentView{
    /**  第一个问题 */
    UILabel *questionLabel1 = [[UILabel alloc]init];
    questionLabel1.textAlignment = NSTextAlignmentLeft;
    questionLabel1.numberOfLines = 0;
    questionLabel1.font = [UIFont boldSystemFontOfSize:16];
    questionLabel1.textColor = [UIColor colorWithHexString:@"#333333"];
    [questionLabel1 sizeToFit];
    self.title = questionLabel1;
    [self.contentView addSubview:questionLabel1];
    [questionLabel1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        
    }];
    UILabel *answerLabel1 = [[UILabel alloc]init];
    answerLabel1.numberOfLines = 0;
    answerLabel1.textAlignment = NSTextAlignmentLeft;
    answerLabel1.font = [UIFont systemFontOfSize:14];
    answerLabel1.textColor = [UIColor colorWithHexString:@"#666666"];
    self.content = answerLabel1;
    [answerLabel1 sizeToFit];
    [self.contentView addSubview:answerLabel1];
    [answerLabel1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(questionLabel1.mas_bottom).offset(10);
        
    }];
    UIImageView *lineV1 = [[UIImageView alloc]init];
    lineV1.backgroundColor = [UIColor colorWithHexString:@"#e5e9f2"];
    [self.contentView addSubview:lineV1];
    [lineV1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.equalTo(1);
    }];

}
- (void)setStatus:(YYInstructionsModel *)status{

    _status = status;
    self.title.attributedText = [self setLineSpace:0.0f withLabelText:status.title withFont:[UIFont boldSystemFontOfSize:16] withZspace:0];
   // self.content.text = status.content;
    if (status.content.length > 0 ) {
        self.content.attributedText = [self setLineSpace:4.0f withLabelText:status.content withFont:[UIFont systemFontOfSize:14] withZspace:0];
    }

    
}
+(CGFloat )heightForCellWith:(YYInstructionsModel *)model{
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode =NSLineBreakByCharWrapping;
    paraStyle.alignment =NSTextAlignmentLeft;
    paraStyle.lineSpacing = 0.0;
    
    paraStyle.paragraphSpacing = 0.0;
    paraStyle.hyphenationFactor = 0.0;
    paraStyle.firstLineHeadIndent =0.0;
    paraStyle.paragraphSpacingBefore =0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    
    
    // title高度
    
    paraStyle.lineSpacing = 0.0f; //设置行间距
//    paraStyle.paragraphSpacing =  - 3.0; // 设置段落间距


    NSDictionary *dic;
        dic =@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:@1.0f };

    CGFloat width = (KProjectScreenWidth - 30);
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    CGRect rect = [model.title boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];

    
    //内容高度
    if (model.content.length > 0) {
        
        paraStyle.lineSpacing = 4.0f; //设置行间距

        dic =@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:@1.0f };
        CGFloat width2 = (KProjectScreenWidth - 30);
        CGSize size2 = CGSizeMake(width2, CGFLOAT_MAX);
        CGRect rect2 = [model.content boundingRectWithSize:size2 options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
        return rect.size.height + rect2.size.height + 45;
    }else{
        
        return rect.size.height + 45;
    }
}

/**
 *  给UILabel设置行间距和字间距
 *  @param space 间距
 *  @param text  内容
 *  @param font  字体
 *  @param zpace  字间距 --> @10 这样设置  默认的话设置 0 就ok
 */
-(NSAttributedString *)setLineSpace:(CGFloat)space withLabelText:(NSString*)text withFont:(UIFont*)font withZspace:(NSNumber *)zspace
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode =NSLineBreakByCharWrapping;
    paraStyle.alignment =NSTextAlignmentLeft;
    paraStyle.lineSpacing = space; //设置行间距
//    paraStyle.paragraphSpacing = - 3.0; // 设置段落间距

    paraStyle.hyphenationFactor = 0.0;
    paraStyle.firstLineHeadIndent =0.0;
    paraStyle.paragraphSpacingBefore =0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic;
    if (zspace == 0) {
        dic =@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:@1.0f
               };
    }else {
        dic =@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:zspace
               };
    }
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:text attributes:dic];

    return attributeStr;
}

@end
