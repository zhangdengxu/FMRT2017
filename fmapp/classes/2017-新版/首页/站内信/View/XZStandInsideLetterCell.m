//
//  XZStandInsideLetterCell.m
//  fmapp
//
//  Created by admin on 16/11/22.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "XZStandInsideLetterCell.h"
#import "XZStandInsideLetterModel.h"

@interface XZStandInsideLetterCell ()
// 未读红点
@property (nonatomic, strong) UIImageView *imgRedPoint;
// 消息内容
@property (nonatomic, strong) UILabel *labelMsgContent;
// 题目
@property (nonatomic, strong) UILabel *labelTitle;
// 右侧箭头
@property (nonatomic, strong) UIImageView *imgArrow;
// 系统消息
@property (nonatomic, strong) UILabel *labelSystemMsg;
@end

@implementation XZStandInsideLetterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpStandInsideLetterCell];
    }
    return self;
}

- (void)setUpStandInsideLetterCell {
    __weak __typeof(&*self)weakSelf = self;
    // 未读红点
    UIImageView *imgRedPoint = [[UIImageView alloc] init];
    [self.contentView addSubview:imgRedPoint];
    [imgRedPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(10);
        make.top.equalTo(weakSelf.contentView).offset(15);
        make.size.equalTo(@8);
    }];
    self.imgRedPoint = imgRedPoint;
//    imgRedPoint.backgroundColor = [UIColor darkGrayColor];
    imgRedPoint.image = [UIImage imageNamed:@"crowdfund_red_icon"];
    
    // 右侧箭头
    UIImageView *imgArrow = [[UIImageView alloc] init];
    [self.contentView addSubview:imgArrow];
    [imgArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).offset(-10);
        make.centerY.equalTo(weakSelf.contentView);
        make.width.equalTo(@(18 * 0.5));
        make.height.equalTo(@(32 * 0.5));
    }];
    imgArrow.image = [UIImage imageNamed:@"箭头_103"];
    self.imgArrow = imgArrow;
    
    // 系统消息
    UILabel *labelSystemMsg = [[UILabel alloc] init];
    [self.contentView addSubview:labelSystemMsg];
    [labelSystemMsg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgRedPoint.mas_right).offset(10);
        make.top.equalTo(imgRedPoint).offset(-5);
    }];
    labelSystemMsg.text = @"系统消息";
    labelSystemMsg.font = [UIFont systemFontOfSize:15];
    self.labelSystemMsg = labelSystemMsg;
    
    // 题目
    UILabel *labelTitle = [[UILabel alloc] init];
    [self.contentView addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgRedPoint.mas_right).offset(10);
        make.top.equalTo(labelSystemMsg.mas_bottom).offset(10);
        make.right.equalTo(imgArrow.mas_left).offset(-10);
    }];
    self.labelTitle = labelTitle;
    labelTitle.font = [UIFont systemFontOfSize:15];
    
    // 消息内容
    UILabel *labelMsgContent = [[UILabel alloc] init];
    [self.contentView addSubview:labelMsgContent];
    [labelMsgContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelTitle);
        make.top.equalTo(labelTitle.mas_bottom).offset(10);
        make.right.equalTo(labelTitle);
    }];
    self.labelMsgContent = labelMsgContent;
    labelMsgContent.font = [UIFont systemFontOfSize:14];
    labelMsgContent.textColor = [UIColor darkGrayColor];
    labelMsgContent.numberOfLines = 0;
    
    UILabel *line = [[UILabel alloc] init];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView);
        make.bottom.equalTo(weakSelf.contentView);
        make.height.equalTo(@0.5);
    }];
    line.backgroundColor = [UIColor lightGrayColor];
}

- (void)setModelInsideLetter:(XZStandInsideLetterModel *)modelInsideLetter {
    _modelInsideLetter = modelInsideLetter;
    // 未读红点 zhuangtai 3 已读 2 未读
    if ([modelInsideLetter.zhuangtai isEqualToString:@"3"]) { // 已读
//        self.imgRedPoint.image = [UIImage imageNamed:@""];
        self.imgRedPoint.hidden = YES;
        // 系统消息
        [self.labelSystemMsg mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.top.equalTo(self.imgRedPoint).offset(-5);
        }];
        // 题目
        [self.labelTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.labelSystemMsg.mas_bottom).offset(10);
            make.right.equalTo(self.imgArrow.mas_left).offset(-10);
            make.left.equalTo(self.contentView).offset(10);
        }];
        
    }else {
        self.imgRedPoint.hidden = NO;
        self.imgRedPoint.image = [UIImage imageNamed:@"crowdfund_red_icon"];
        // 系统消息
        [self.labelSystemMsg mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgRedPoint.mas_right).offset(10);
            make.top.equalTo(self.imgRedPoint).offset(-5);
        }];
        // 题目
        [self.labelTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgRedPoint.mas_right).offset(10);
            make.top.equalTo(self.labelSystemMsg.mas_bottom).offset(10);
            make.right.equalTo(self.imgArrow.mas_left).offset(-10);
        }];
        
       
    }
    // 题目
    self.labelTitle.text = [NSString stringWithFormat:@"%@",modelInsideLetter.biaoti];
    // 消息内容
    self.labelMsgContent.text  = [NSString stringWithFormat:@"%@",modelInsideLetter.neirong];;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
@end
