//
//  XZChooseCommentAgainView.m
//  fmapp
//
//  Created by admin on 16/5/27.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "XZChooseCommentAgainView.h"

@implementation XZChooseCommentAgainView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 设置ChooseCommentAgainView子视图
        [self setUpChooseCommentAgainView];
    }
    return self;

}
// 设置ChooseCommentAgainView子视图
- (void)setUpChooseCommentAgainView {
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self addSubview:view];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
    /** 取消 */
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self addSubview:btnCancel];
    [btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom).offset(-64);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@50);
    }];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(didClickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btnCancel setBackgroundColor:[UIColor whiteColor]];
    /** 分割线 */
    UILabel *line = [[UILabel alloc]init];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(btnCancel.mas_top);
        make.height.equalTo(@8);
    }];
    [line setBackgroundColor:KDefaultOrBackgroundColor];
    /** 追加评价 */
    UIButton *btnCommentAgain = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self addSubview:btnCommentAgain];
    [btnCommentAgain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(line.mas_top);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@50);
    }];
    [btnCommentAgain setTitle:@"追加评价" forState:UIControlStateNormal];
    [btnCommentAgain setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnCommentAgain addTarget:self action:@selector(didClickCommentAgainBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btnCommentAgain setBackgroundColor:[UIColor whiteColor]];
    
}

// 点击追加评价按钮
- (void)didClickCommentAgainBtn:(UIButton *)button {
    if (self.blockCommentAgainBtn) {
        self.blockCommentAgainBtn(button);
    }
    [self removeFromSuperview];
}

// 点击取消按钮
- (void)didClickCancelBtn:(UIButton *)button {
    [self removeFromSuperview];
}
@end
