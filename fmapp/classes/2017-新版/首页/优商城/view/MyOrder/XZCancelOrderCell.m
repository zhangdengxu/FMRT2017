//
//  XZCancelOrderCell.m
//  fmapp
//
//  Created by admin on 16/5/16.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "XZCancelOrderCell.h"

@implementation XZCancelOrderCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 设置CancelOrderCell子视图
        [self setUpCancelOrderCell];
    }
    return self;
}
// 设置CancelOrderCell子视图
- (void)setUpCancelOrderCell {
    UILabel *labelCancelInfo = [[UILabel alloc]init];
    [self.contentView addSubview:labelCancelInfo];
    [labelCancelInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    _labelCancelInfo = labelCancelInfo;
    UIButton *btnSelected = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:btnSelected];
    [btnSelected mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.and.width.equalTo(@25);
    }];
    _btnSelected = btnSelected;
    [btnSelected setBackgroundImage:[UIImage imageNamed:@"cancel_order_nochoose"] forState:UIControlStateNormal];
    [btnSelected setBackgroundImage:[UIImage imageNamed:@"cancel_order_choose"] forState:UIControlStateSelected];
    [btnSelected addTarget:self action:@selector(selectedBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}
/** 创建cell */
+ (instancetype )cellCancelOrderWithTableView:(UITableView *)tableView{
    static NSString *reuseID = @"cancelOrder";
    XZCancelOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    return cell;
}
- (void)selectedBtnAction:(UIButton *)button
{
    button.selected = !button.selected;
    if (self.blockSelectedBtn) {
        self.blockSelectedBtn(button);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
     self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

@end
