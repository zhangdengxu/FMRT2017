//
//  XZNoRedEnvelopeView.m
//  fmapp
//
//  Created by admin on 17/2/20.
//  Copyright © 2017年 yk. All rights reserved.
//  暂无可用红包券

#import "XZNoRedEnvelopeView.h"
#import "XZRedEnvelopeModel.h"

@interface XZNoRedEnvelopeView ()
@property (nonatomic, strong) UILabel *labelNoRedEnve;
@end

@implementation XZNoRedEnvelopeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpNoRedEnvelopeView];
    }
    return self;
}

- (void)setUpNoRedEnvelopeView {
    self.backgroundColor = XZBackGroundColor;
    
    // 181 109
    UIImageView *imgNoRedEnve = [[UIImageView alloc] init];
    [self addSubview:imgNoRedEnve];
    [imgNoRedEnve mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-50);
        make.width.equalTo(@(181 * 0.5));
        make.height.equalTo(@(109 * 0.5));
    }];
    imgNoRedEnve.image = [UIImage imageNamed:@"项目详情_暂无可用红包icon_1702"];
    
    //
    UILabel *labelNoRedEnve = [[UILabel alloc] init];
    [self addSubview:labelNoRedEnve];
    [labelNoRedEnve mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgNoRedEnve.mas_bottom).offset(25);
        make.centerX.equalTo(imgNoRedEnve);
    }];
    labelNoRedEnve.textColor = [HXColor colorWithHexString:@"#333333"];
    self.labelNoRedEnve = labelNoRedEnve;
}

- (void)setModelRedEnv:(XZRedEnvelopeModel *)modelRedEnv {
    _modelRedEnv = modelRedEnv;
    
    if (modelRedEnv.isRedEnvelope) {
        if (modelRedEnv.isUseful) {
            self.labelNoRedEnve.text = @"暂无可用红包券";
        }else {
            self.labelNoRedEnve.text = @"暂无不可用红包券";
        }
    }else {
        if (modelRedEnv.isUseful) {
            self.labelNoRedEnve.text = @"暂无可用加息券";
        }else {
            self.labelNoRedEnve.text = @"暂无不可用加息券";
        }
    }
}

@end
