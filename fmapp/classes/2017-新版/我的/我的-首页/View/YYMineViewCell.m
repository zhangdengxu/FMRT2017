//
//  YYMineViewCell.m
//  fmapp
//
//  Created by yushibo on 2017/2/20.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "YYMineViewCell.h"

@implementation YYMineViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [HXColor colorWithHexString:@"#ffffff"];
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    
    UILabel *titleLable = [[UILabel alloc]init];
    if (KProjectScreenWidth > 320) {
        titleLable.font = [UIFont systemFontOfSize:16];
    }else{
        titleLable.font = [UIFont boldSystemFontOfSize:16];
    }
    
    titleLable.textColor = [HXColor colorWithHexString:@"#333333"];
    //    titleLable.backgroundColor = [UIColor redColor];
    self.titleArray = titleLable;
    [self.contentView addSubview:titleLable];
    [titleLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.right.equalTo(self.contentView.mas_right);
        if (KProjectScreenWidth > 320) {
            
            make.bottom.equalTo(self.contentView.mas_centerY).offset(-6);
        }else{
            make.bottom.equalTo(self.contentView.mas_centerY).offset(-3);
            
        }
    }];
    
    UILabel *contentLable = [[UILabel alloc]init];
    contentLable.font = [UIFont systemFontOfSize:14];
    contentLable.textColor = [HXColor colorWithHexString:@"#999999"];
    //    contentLable.backgroundColor = [UIColor redColor];
    self.contentArray = contentLable;
    [self.contentView addSubview:contentLable];
    [contentLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.right.equalTo(self.contentView.mas_right);
        if (KProjectScreenWidth > 320) {
            
            make.top.equalTo(self.contentView.mas_centerY).offset(8);
        }else{
            make.top.equalTo(self.contentView.mas_centerY).offset(5);
            
            
        }
    }];
}


@end
