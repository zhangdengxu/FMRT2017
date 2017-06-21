//
//  YYHuifuBalanceCashController.m
//  fmapp
//
//  Created by yushibo on 2017/5/11.
//  Copyright © 2017年 yk. All rights reserved.
//  汇付余额提现

#import "YYHuifuBalanceCashController.h"
#import "MoneyTiXianViewController.h"  // 汇付提现界面
@interface YYHuifuBalanceCashController ()

@end

@implementation YYHuifuBalanceCashController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self settingNavTitle:@"汇付余额提现"];
    self.view.backgroundColor = [HXColor colorWithHexString:@"#f4f5f9"];
    [self createContentView];
}

- (void)createContentView{
    /**
     *  背景backView
     */
    UIView *backView = [[UIView alloc]init];
    backView.userInteractionEnabled = YES;
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 10.0;
    [self.view addSubview:backView];
    [backView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        if (KProjectScreenWidth > 320) {
            make.height.equalTo(@370);
        }else{
            make.height.equalTo(@330);
        }
    }];

    //标题
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor colorWithHexString:@"#333"];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.text = @"注意事项：";
    [backView addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(15);
        make.top.equalTo(backView.mas_top).offset(@25);
    }];
  
    UILabel *Label1 = [[UILabel alloc]init];
    Label1.numberOfLines = 0;
    Label1.textColor = [UIColor colorWithHexString:@"#333"];
    NSString *text = @"1.系统并行期间，充值只能通过徽商存管账户进行，原汇付托管账户不再受理充值业务，只可进行资金的转出；\n2.如需将汇付托管账户的余额转移到徽商存管账户上，需要您先将汇付余额提现至您的银行卡，然后在通过充值，充到徽商存管账户上；\n3.系统并行期间，项目所有的结息和回款返还至您的徽商银行账户；\n4.并行期结束，汇付托管账户关闭，若账户中还有余额，用户可自行登录汇付天下官网进行取现。";
    
    if (KProjectScreenWidth > 320) {
        Label1.attributedText = [self setLineSpace:7.0f withLabelText:text withFont:[UIFont systemFontOfSize:15] withZspace:0];
    }else{
        Label1.attributedText = [self setLineSpace:4.0f withLabelText:text withFont:[UIFont systemFontOfSize:15] withZspace:0];
    }
    [backView addSubview:Label1];
    [Label1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(15);
        make.right.equalTo(backView.mas_right).offset(-15);
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
    }];

    /**  我要提现按钮 */
    UIButton *TXBtn = [[UIButton alloc]init];
    TXBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    TXBtn.backgroundColor = [HXColor colorWithHexString:@"#0159d5"];
    TXBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [TXBtn setTitle:@"我要提现" forState:UIControlStateNormal];
    [TXBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [TXBtn addTarget:self action:@selector(TXBtnAction) forControlEvents:UIControlEventTouchUpInside];
    TXBtn.layer.masksToBounds = YES;
    TXBtn.layer.cornerRadius = 4.0f;
    [self.view addSubview:TXBtn];
    [TXBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        if (KProjectScreenWidth > 320) {
            make.top.equalTo(backView.mas_bottom).offset(80);

        }else{
            make.top.equalTo(backView.mas_bottom).offset(40);

        }
        make.height.equalTo(45);
    }];

}
- (void)TXBtnAction{

    NSLog(@"%s", __func__);
    MoneyTiXianViewController * viewController = [[MoneyTiXianViewController alloc]init];
    viewController.hidesBottomBarWhenPushed=YES;
//    __weak typeof (self)weakSelf = self;
//    viewController.refreshBlcok = ^(){
//        [weakSelf requestDatatoCollectionView];
//    };
    [self.navigationController pushViewController:viewController animated:YES];
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
