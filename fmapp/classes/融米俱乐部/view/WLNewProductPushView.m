//
//  WLNewProductPushView.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/9/20.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "WLNewProductPushView.h"
#define XINPINBUTTONTAG 1000
@interface WLNewProductPushView()<UIScrollViewDelegate>

@property (nonatomic, weak) UIView * backgroundView;

@end


@implementation WLNewProductPushView

- (instancetype)initWithDic:(NSDictionary *)chanpin
{
    self = [super init];
   
    self.chanpin = chanpin;
    
    [self showSignView];
    [self setFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight)];
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
    return self;
}

/*
 

 "xinpin": {
 "title": "新品推送",
 "bottom": "明星产品，需开通自动投标才能抢上",
 "chanpin": [
 {
 "tupianyi": "https://www.rongtuojinrong.com/Uploads/Article/20160920034906_76306.png",
 "tupianer": "https://www.rongtuojinrong.com/Uploads/Article/20160920034930_21302.png",
 "wenzier": "8",
 "wenzisan": "%预期",
 "wenzisi": "10元起投 随时随取",
 "wenziwu": "领1%加息券",
 "xiayibu": "1"
 },
 {
 "tupianyi": "https://www.rongtuojinrong.com/Uploads/Article/20160920035000_15773.png",
 "tupianer": "https://www.rongtuojinrong.com/Uploads/Article/20160920035022_93936.png",
 "wenziyi": "定期理财",
 "wenzier": "10~12",
 "wenzisan": "%预期",
 "wenzisi": "100元起 1-6个月",
 "wenziwu": "立即抢购",
 "wenziliu": "明星产品，需开通自动投标才能抢上",
 "xiayibu": "1"
 }
 ]
 }
 
 */

-(void)showSignView{
    
    NSArray *chanpin = [self.chanpin objectForKey:@"chanpin"];
    UIView *backgroundView = [[UIView alloc]init];
    self.backgroundView = backgroundView;
    self.backgroundView.center = CGPointMake(KProjectScreenWidth * 0.5, KProjectScreenHeight * 0.5+64);
    self.backgroundView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.backgroundView];

    if (chanpin.count == 1) {
        
        [self.backgroundView setFrame:CGRectMake(0, 0, KProjectScreenWidth-50, 300)];
        
    }else if (chanpin.count == 2){
        
        [self.backgroundView setFrame:CGRectMake(0, 0, KProjectScreenWidth-50, 490)];
        if (KProjectScreenHeight<500) {
            [self.backgroundView setFrame:CGRectMake(0, 0, KProjectScreenWidth-50, 350)];
        }else if (KProjectScreenHeight<600) {
            [self.backgroundView setFrame:CGRectMake(0, 0, KProjectScreenWidth-50, 445)];
        }
        
    }

 
    
    CGRect rect = self.backgroundView.frame;
    self.backgroundView.frame = rect;
    self.backgroundView.center = CGPointMake(KProjectScreenWidth * 0.5, KProjectScreenHeight * 0.5);
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *mainScrollView = [[UIScrollView alloc] init];
    mainScrollView.delegate = self;
    mainScrollView.scrollEnabled = YES;
    [mainScrollView setBackgroundColor: [UIColor whiteColor]];
    mainScrollView.showsVerticalScrollIndicator = NO;
    
    [self.backgroundView addSubview:mainScrollView];
    [mainScrollView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backgroundView.mas_left);
        make.top.equalTo(self.backgroundView.mas_top);
        make.width.equalTo(self.backgroundView.mas_width);
        make.bottom.equalTo(self.backgroundView.mas_bottom);
    }];
    [mainScrollView setContentSize:CGSizeMake(rect.size.width, 490)];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [titleLabel setText:[NSString stringWithFormat:@"%@",[self.chanpin objectForKey:@"title"]]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont systemFontOfSize:22]];
    [mainScrollView addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainScrollView.mas_left);
        make.top.equalTo(mainScrollView.mas_top);
        make.width.equalTo(mainScrollView.mas_width);
        make.height.equalTo(60);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = KDefaultOrBackgroundColor;
    [mainScrollView addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainScrollView.mas_left);
        make.top.equalTo(mainScrollView.mas_top).offset(60);
        make.width.equalTo(mainScrollView.mas_width);
        make.height.equalTo(1);
    }];
    
    UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomButton setBackgroundImage:[UIImage imageNamed:@"新品推送2"] forState:UIControlStateNormal];
    [bottomButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:bottomButton];
    [bottomButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backgroundView.mas_right).offset(-13);
        make.top.equalTo(mainScrollView.mas_top).offset(18);
        make.width.equalTo(20);
        make.height.equalTo(18);
    }];

    
    
    for (int i=0; i<chanpin.count; i++) {
        UIView *bjView = [[UIView alloc]init];
        [mainScrollView addSubview:bjView];
        //标题图
        UIImageView *imgV = [[UIImageView alloc]init];
        
        [imgV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[chanpin[i] objectForKey:@"tupianyi"]]]];
        
        [bjView addSubview:imgV];
        [imgV makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bjView.mas_centerX);
            make.top.equalTo(bjView.mas_top).offset(7);
           
        }];
        
        //左侧圆形
        UIImageView *leftImgV = [[UIImageView alloc]init];
        [leftImgV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[chanpin[i] objectForKey:@"tupianer"]]]];

        [bjView addSubview:leftImgV];
        [leftImgV makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bjView.mas_left).offset(40);
            make.top.equalTo(imgV.mas_bottom).offset(15);
        }];
        //第一个label
        UILabel *label1 = [[UILabel alloc]init];
        [label1 setText:[NSString stringWithFormat:@"%@%@",[chanpin[i] objectForKey:@"wenzier"],[chanpin[i] objectForKey:@"wenzisan"]]];
        [label1 setTextColor:[UIColor colorWithRed:235/255.0f green:72/255.0f blue:48/255.0f alpha:1]];
        [label1 setFont:[UIFont systemFontOfSize:16]];
        
        NSString *vStr = label1.text;
        NSString *vDStr=[chanpin[i] objectForKey:@"wenzier"];
        NSRange range=[vStr rangeOfString:vDStr];
        NSMutableAttributedString *mstr=[[NSMutableAttributedString alloc]initWithString:vStr];
        [mstr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:25] range:range];
        label1.attributedText=mstr;

        [bjView addSubview:label1];
        [label1 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftImgV.mas_right).offset(25);
            make.top.equalTo(leftImgV.mas_top);
            make.height.equalTo(30);
        }];
        
        //第2个label
        UILabel *label2 = [[UILabel alloc]init];
        [label2 setText:[NSString stringWithFormat:@"%@",[chanpin[i] objectForKey:@"wenzisi"]]];
        [label2 setTextColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:1]];
        [label2 setFont:[UIFont systemFontOfSize:16]];
        [bjView addSubview:label2];
        [label2 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftImgV.mas_right).offset(25);
            make.top.equalTo(label1.mas_bottom).offset(10);
            make.height.equalTo(25);
        }];
        
        //按钮
        UIButton *personalLogoOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [personalLogoOutButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:14/255.0f green:93/255.0f blue:210/255.0f alpha:1])
                                         forState:UIControlStateNormal];
        [personalLogoOutButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:14/255.0f green:93/255.0f blue:210/255.0f alpha:1])
                                         forState:UIControlStateHighlighted];
        [personalLogoOutButton addTarget:self
                                  action:@selector(userLoginOut:)
                        forControlEvents:UIControlEventTouchUpInside];
        personalLogoOutButton.titleLabel.font=[UIFont boldSystemFontOfSize:16.0];
        
        [personalLogoOutButton setTitle:[NSString stringWithFormat:@"%@",[chanpin[i] objectForKey:@"wenziwu"]]
                               forState:UIControlStateNormal];
        
        [personalLogoOutButton setTitleColor:[UIColor whiteColor]
                                    forState:UIControlStateNormal];
        
        [personalLogoOutButton.layer setBorderWidth:0.5f];
        [personalLogoOutButton.layer setCornerRadius:2.0f];
        [personalLogoOutButton.layer setMasksToBounds:YES];
        [personalLogoOutButton setBackgroundColor:KDefaultOrBackgroundColor];
        [personalLogoOutButton.layer setBorderColor:[KDefaultOrNightSepratorColor CGColor]];
        [personalLogoOutButton setTag:XINPINBUTTONTAG+i];
        [bjView addSubview:personalLogoOutButton];
        [personalLogoOutButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mainScrollView.mas_left).offset(25);
            make.top.equalTo(bjView.mas_bottom).offset(-65);
            make.width.equalTo(self.backgroundView.frame.size.width-50);
            make.height.equalTo(40);
        }];
        
        if (i == 0) {
            [bjView makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(mainScrollView.mas_left);
                make.top.equalTo(mainScrollView.mas_top).offset(61);
                make.width.equalTo(mainScrollView.mas_width);
                make.height.equalTo(200);
            }];
  
        }
        if (i == 1) {
            [bjView makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(mainScrollView.mas_left);
                KProjectScreenWidth<330?make.top.equalTo(mainScrollView.mas_top).offset(235):make.top.equalTo(mainScrollView.mas_top).offset(261);
                make.width.equalTo(mainScrollView.mas_width);
                make.height.equalTo(200);
            }];
        }
    }
    
    //底部的label
    UILabel *bottomLabel = [[UILabel alloc]init];
    [bottomLabel setText:[NSString stringWithFormat:@"%@",[self.chanpin objectForKey:@"bottom"]]];
    [bottomLabel setTextAlignment:NSTextAlignmentCenter];
    bottomLabel.numberOfLines = 0;
    [bottomLabel setTextColor:[UIColor colorWithRed:14/255.0f green:93/255.0f blue:210/255.0f alpha:1]];
    [bottomLabel setFont:[UIFont systemFontOfSize:12]];
    [mainScrollView addSubview:bottomLabel];
    [bottomLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainScrollView.mas_left).offset(20);
        KProjectScreenWidth<330?make.top.equalTo(410):make.top.equalTo(460);
        make.width.equalTo(self.backgroundView.frame.size.width-40);
        make.height.equalTo(30);
    }];

    
    [self.backgroundView.layer setCornerRadius:3.0f];
    [self.backgroundView.layer setMasksToBounds:YES];
    [self.backgroundView setAlpha:1.0f ];
    [self.backgroundView setUserInteractionEnabled:YES];
    
    
}

-(void)hiddenSignView{
    
    [self endEditing:YES];
    [self.backgroundView removeFromSuperview];
    [self removeFromSuperview];
}

-(void)cancelAction:(UIButton *)btn{
    
    [self endEditing:YES];
    [self.backgroundView removeFromSuperview];
    [self removeFromSuperview];
}
//点击跳转
-(void)userLoginOut:(UIButton *)button{
/*参数xiayibu：
 1实名
 2充值
 3零钱贯
 4自动投标设置*/

    NSArray *chanpin = [self.chanpin objectForKey:@"chanpin"];
    if (button.tag == 1000) {
        if (self.theXinpinBlock) {
            self.theXinpinBlock([chanpin[0] objectForKey:@"xiayibu"],@"1",[chanpin[0] objectForKey:@"wenziwu"]);
        }
    }
    if (button.tag == 1001) {
        if (self.theXinpinBlock) {
            self.theXinpinBlock([chanpin[1] objectForKey:@"xiayibu"],@"2",[chanpin[1] objectForKey:@"wenziwu"]);
        }
    }
    [self endEditing:YES];
    [self.backgroundView removeFromSuperview];
    [self removeFromSuperview];
}


@end
