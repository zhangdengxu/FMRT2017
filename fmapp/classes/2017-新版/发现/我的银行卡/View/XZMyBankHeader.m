//
//  XZMyBankHeader.m
//  fmapp
//
//  Created by admin on 2017/6/2.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "XZMyBankHeader.h"

@implementation XZMyBankHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpMyBankHeader];
    }
    return self;
}

- (void)setUpMyBankHeader {
    self.backgroundColor = [HXColor colorWithHexString:@"#f4f5f9"];
    //
    UIImageView *imgBackground = [[UIImageView alloc] init];
    [self addSubview:imgBackground];
    [imgBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(20);
        make.height.equalTo(KProjectScreenWidth * 324 / 730.0);
    }];
    imgBackground.image = [UIImage imageNamed:@"微商_注册:取现_绑定银行卡"];
    imgBackground.userInteractionEnabled = YES;
    
    //
    UILabel *labelTitle = [[UILabel alloc] init];
    [imgBackground addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imgBackground).offset(10);
        make.centerY.equalTo(imgBackground);
    }];
    labelTitle.text = @"绑定银行卡";
    labelTitle.font = [UIFont systemFontOfSize:15.0f];
    labelTitle.textColor = [HXColor colorWithHexString:@"#999999"];
    
    UILabel *labelAdd = [[UILabel alloc] init];
    [imgBackground addSubview:labelAdd];
    [labelAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(labelTitle.mas_left).offset(-10);
        make.centerY.equalTo(labelTitle);
    }];
    labelAdd.text = @"+";
    labelAdd.font = [UIFont boldSystemFontOfSize:20];
    labelAdd.textColor = [HXColor colorWithHexString:@"#999999"];
    
    //
    UIButton *btnCover = [UIButton buttonWithType:UIButtonTypeCustom];
    [imgBackground addSubview:btnCover];
    [btnCover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(imgBackground);
    }];
    [btnCover addTarget:self action:@selector(didClickBtnCover) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didClickBtnCover {
    if (self.blockCoverButton) {
        self.blockCoverButton();
    }
}


@end
