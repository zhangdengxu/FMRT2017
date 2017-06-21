//
//  FMKeyBoardNumberHeader.m
//  fmapp
//
//  Created by runzhiqiu on 2017/3/28.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMKeyBoardNumberHeader.h"

@interface FMKeyBoardNumberHeader ()


@end

@implementation FMKeyBoardNumberHeader

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self retTopKeyBoardHeaderView];//initKeyBoardNumberHeaderCreate
    }
    return self;
}



-(void)retTopKeyBoardHeaderView
{
    
    self.backgroundColor = [HXColor colorWithHexString:@"#ffffff"];
    self.frame = CGRectMake(0, 0, KProjectScreenWidth, 49);
    
    UIView * lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@0.5);
        
    }];
    UIView * lineView1 = [[UIView alloc]init];
    lineView1.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineView1];
    [lineView1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@0.5);
        
    }];
    
    UIButton * rightbutton = [[UIButton alloc]init];
    [rightbutton setTitle:@"完成" forState:UIControlStateNormal];
    [rightbutton setTitleColor:[HXColor colorWithHexString:@"#0159d5"] forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(textFiledButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightbutton];
    
    [rightbutton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self.mas_centerY);
        make.top.bottom.equalTo(self);
        
    }];
    
}
-(void)textFiledButtonOnClick:(UIButton *)button
{
    
    if (self.blockKey) {
        self.blockKey();
    }
}


+(instancetype)initKeyBoardNumberHeaderCreate:(keyBoardDownBlock)block
{
    FMKeyBoardNumberHeader * header = [[FMKeyBoardNumberHeader
                                        alloc]init];
    header.blockKey = block;
    
    return header;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
