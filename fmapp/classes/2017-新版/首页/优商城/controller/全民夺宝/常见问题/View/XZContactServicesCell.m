//
//  XZContactServicesCell.m
//  fmapp
//
//  Created by admin on 16/8/24.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "XZContactServicesCell.h"
#import "AutoHeightLabel.h"
#import "XZContactSerContentModel.h"

@interface XZContactServicesCell ()
// 问题
@property (nonatomic, strong) UILabel *labelContent;

@end

@implementation XZContactServicesCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupContactServicesCell];
    }
    return self;
}

- (void)setupContactServicesCell {
    self.contentView.backgroundColor = XZColor(217, 45, 64);
    /** View */
    UIView *viewBack = [[UIView alloc] init];
    [self.contentView addSubview:viewBack];
    [viewBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    viewBack.backgroundColor = XZColor(229, 233, 242);
    
    // 内容
    UILabel *labelContent = [[UILabel alloc] init];
    [viewBack addSubview:labelContent];
    [labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewBack.mas_left).offset(10);
        make.centerY.equalTo(viewBack.mas_centerY);
        make.right.equalTo(viewBack.mas_right).offset(-10);
    }];
    self.labelContent = labelContent;
    labelContent.textColor = XZColor(67, 67, 65);
    labelContent.font = [UIFont systemFontOfSize:13];
    labelContent.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModelContact:(XZContactSerContentModel *)modelContact {
    _modelContact = modelContact;
    self.labelContent.text = modelContact.content;
}


@end
