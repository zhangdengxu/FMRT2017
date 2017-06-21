//
//  FMMakeABadResultStatus.m
//  fmapp
//
//  Created by runzhiqiu on 16/6/13.
//  Copyright © 2016年 yk. All rights reserved.
//


#import "FMMakeABadResultStatus.h"
#import "XZSaveDetailM.h"

@interface FMMakeABadResultStatus ()



/**  提示上面的图片 */
@property (nonatomic, strong) UIImageView *imgResult;
/** 提示 */
@property (nonatomic, strong) UILabel *labelRemind;
/** 失败原因 */
@property (nonatomic, strong) UILabel *labelBecause;
/**  提交时间框 */
@property (nonatomic, strong) UILabel *labelRemindTime;
/**  提交时间 */
@property (nonatomic, strong) UILabel *labelTime;
/**  申请金额 */
@property (nonatomic, strong) UILabel *requreMony;
/**  所属交易日框 */
@property (nonatomic, strong) UILabel *labelDealDay;
/**  所属交易日 */
@property (nonatomic, strong) UILabel *labelTradeDay;
/** 返回零钱贯账户按钮 */
@property (nonatomic, strong) UIButton *btnBackToAccount;

//===

/** 温馨提示*/
@property (nonatomic, strong) UILabel *labelPrompt;
/** 温馨提示详细 */
@property (nonatomic, strong) UILabel *labelPromptDetail;


@end

@implementation FMMakeABadResultStatus


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpSaveDetailView];
    }
    return self;
}



- (void)setUpSaveDetailView {
    self.backgroundColor = KDefaultOrBackgroundColor;
    
    self.imgResult = [[UIImageView alloc]init];
    [self addSubview:self.imgResult];
    [self.imgResult mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(30);
        make.width.equalTo(@80);
        make.height.equalTo(@70);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    
   
    
}

-(void)createNextViewWithSuccess{
    CGFloat left_origin_x;
    CGFloat radioFloat;
    if (KProjectScreenWidth == 320) {
        left_origin_x = 45;
        radioFloat = 0.6;
        
    }else if(KProjectScreenWidth == 375)
    {
        left_origin_x = 65;
        radioFloat = 0.8;
    }else
    {
        left_origin_x = 80;
        radioFloat = 1;
    }
    
    self.labelRemind = [[UILabel alloc]init];
    [self addSubview:self.labelRemind];
    [self.labelRemind mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.imgResult.mas_bottom).offset(25 * radioFloat);
    }];
    self.labelRemind.font = [UIFont boldSystemFontOfSize:30];
    self.labelRemind.textColor = [UIColor colorWithRed:7/255.0 green:64/255.0 blue:143/255.0 alpha:1.0];
    
    
    
    // 时间提示框
    self.labelRemindTime = [[UILabel alloc]init];
    self.labelRemindTime.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.labelRemindTime];
    [self.labelRemindTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(left_origin_x);
        make.width.equalTo(@90);
        make.top.equalTo(self.labelRemind.mas_bottom).offset(68 * radioFloat);
    }];
    self.labelRemindTime.text = [NSString stringWithFormat:@"提交时间"];
    self.labelRemindTime.font = [UIFont systemFontOfSize:19];
    self.labelRemindTime.textColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:0.8];
    // 时间
    self.labelTime = [[UILabel alloc]init];
    [self addSubview:self.labelTime];
    [self.labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labelRemindTime.mas_right).offset(10);
        make.width.equalTo(@180);
        make.top.equalTo(self.labelRemindTime.mas_top);
    }];
    self.labelTime.textColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:0.6];
    
    
    // 申请金额
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentRight;
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.labelRemindTime.mas_right);
        make.width.equalTo(@90);
        make.bottom.equalTo(self.labelRemindTime.mas_top).offset(-15 * radioFloat);
    }];
    label.text = [NSString stringWithFormat:@"投标金额"];
    label.font = [UIFont systemFontOfSize:19];
    label.textColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:0.8];
    // 金额
    self.requreMony = [[UILabel alloc]init];
    self.requreMony.textColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:0.6];
    [self addSubview:self.requreMony];
    [self.requreMony mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labelRemindTime.mas_right).offset(10);
        make.width.equalTo(@180);
        make.top.equalTo(label.mas_top);
    }];
    
    
    
    // 交易日框
    self.labelDealDay = [[UILabel alloc]init];
    self.labelDealDay.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.labelDealDay];
    [self.labelDealDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.labelRemindTime.mas_right);
        make.width.equalTo(@90);
        make.top.equalTo(self.labelRemindTime.mas_bottom).offset(15 * radioFloat);
    }];
    self.labelDealDay.font = [UIFont systemFontOfSize:19];
    self.labelDealDay.text = [NSString stringWithFormat:@"到期时间"];
    self.labelDealDay.textColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:0.8];
    // 交易日
    self.labelTradeDay = [[UILabel alloc]init];
    [self addSubview:self.labelTradeDay];
    [self.labelTradeDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labelTime.mas_left);
        make.width.equalTo(self.labelTime.mas_width);
        make.top.equalTo(self.labelDealDay.mas_top);
    }];
    self.labelTradeDay.textColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:0.6];
    
    self.btnBackToAccount = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.btnBackToAccount];
    [self.btnBackToAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(self.labelTradeDay.mas_bottom).offset(30 * radioFloat);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.equalTo(@49);
    }];
    [self.btnBackToAccount setBackgroundImage:createImageWithColor([UIColor colorWithRed:14/255.0f green:93/255.0f blue:210/255.0f alpha:1]) forState:UIControlStateNormal];
    [self.btnBackToAccount setTitle:@"查看我的债权"forState:UIControlStateNormal];
    [self.btnBackToAccount setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [self.btnBackToAccount addTarget:self action:@selector(buttonOnCLickSuccess) forControlEvents:UIControlEventTouchUpInside];
    [self.btnBackToAccount.layer setBorderWidth:0.5f];
    [self.btnBackToAccount.layer setCornerRadius:7.0f];
    [self.btnBackToAccount.layer setMasksToBounds:YES];
    [self.btnBackToAccount setBackgroundColor:KDefaultOrBackgroundColor];
    [self.btnBackToAccount.layer setBorderColor:[KDefaultOrNightSepratorColor CGColor]];
    // 温馨提示
    self.labelPrompt = [[UILabel alloc]init];
    [self addSubview:self.labelPrompt];
    [self.labelPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnBackToAccount.mas_left);
        make.top.equalTo(self.btnBackToAccount.mas_bottom).offset(25 * radioFloat);
        make.width.equalTo(self.btnBackToAccount.mas_width);
        make.height.equalTo(@25);
    }];
    self.labelPrompt.text = [NSString stringWithFormat:@"温馨提示:"];
    self.labelPrompt.textColor = [HXColor colorWithHexString:@"#ff6532"];
    // 温馨提示详细
    self.labelPromptDetail = [[UILabel alloc]init];
    [self addSubview:self.labelPromptDetail];
    [self.labelPromptDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labelPrompt.mas_left);
        make.top.equalTo(self.labelPrompt.mas_bottom).offset(10);
        make.right.equalTo(self.mas_right).offset(-20);
    }];
    self.labelPromptDetail.text = [NSString stringWithFormat:@"您的投资金额已被锁定至项目成立，请静候募集结果"];
    self.labelPromptDetail.font = [UIFont systemFontOfSize:13];
    self.labelPromptDetail.numberOfLines = 0;
    self.labelPromptDetail.textColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:0.8];
}

-(void)createNextViewWithFail{
    CGFloat left_origin_x;
    CGFloat radioFloat;
    if (KProjectScreenWidth == 320) {
        left_origin_x = 45;
        radioFloat = 0.6;
        
    }else if(KProjectScreenWidth == 375)
    {
        left_origin_x = 65;
        radioFloat = 0.8;
    }else
    {
        left_origin_x = 80;
        radioFloat = 1;
    }
    
    self.labelRemind = [[UILabel alloc]init];
    [self addSubview:self.labelRemind];
    [self.labelRemind mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.imgResult.mas_bottom).offset(25 * radioFloat);
    }];
    self.labelRemind.font = [UIFont boldSystemFontOfSize:30];
    self.labelRemind.textColor = [UIColor colorWithRed:7/255.0 green:64/255.0 blue:143/255.0 alpha:1.0];
    
    
    self.labelBecause = [[UILabel alloc]init];
    [self addSubview:self.labelBecause];
    [self.labelBecause mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.labelRemind.mas_bottom).offset(20 * radioFloat);
    }];
    self.labelBecause.font = [UIFont boldSystemFontOfSize:25];
    self.labelBecause.textColor = [UIColor colorWithRed:7/255.0 green:64/255.0 blue:143/255.0 alpha:1.0];
    
    
    self.btnBackToAccount = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.btnBackToAccount];
    [self.btnBackToAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(self.labelBecause.mas_bottom).offset(25 * radioFloat);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.equalTo(@49);
    }];
    [self.btnBackToAccount setBackgroundImage:createImageWithColor([UIColor colorWithRed:14/255.0f green:93/255.0f blue:210/255.0f alpha:1]) forState:UIControlStateNormal];
    [self.btnBackToAccount setTitle:@"返回我的账户"forState:UIControlStateNormal];
    [self.btnBackToAccount setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [self.btnBackToAccount addTarget:self action:@selector(buttonOnCLickFail) forControlEvents:UIControlEventTouchUpInside];
    [self.btnBackToAccount.layer setBorderWidth:0.5f];
    [self.btnBackToAccount.layer setCornerRadius:7.0f];
    [self.btnBackToAccount.layer setMasksToBounds:YES];
    [self.btnBackToAccount setBackgroundColor:KDefaultOrBackgroundColor];
    [self.btnBackToAccount.layer setBorderColor:[KDefaultOrNightSepratorColor CGColor]];
}
// 给视图赋值
- (void)setSaveM:(XZSaveDetailM *)saveM {
    
    
    if ([saveM.msg isEqualToString:KDefaultFMMakeABadResultStatus]) {
        self.imgResult.image = [UIImage imageNamed:@"融托金融存入-取出图标"];
        [self createNextViewWithSuccess];
        self.labelRemind.text = [NSString stringWithFormat:@"%@",saveM.msg];
        self.labelTradeDay.text = [NSString stringWithFormat:@"%@",saveM.jiaoyi];//message2//到期时间
        self.labelTime.text = [NSString stringWithFormat:@"%@",saveM.tijiao]; //message3//提交时间
        self.requreMony.text = [NSString stringWithFormat:@"%@元",saveM.jiner];
        
    }else
    {
        self.imgResult.image = [UIImage imageNamed:@"投标失败icon_03"];
        [self createNextViewWithFail];
        self.labelRemind.text = [NSString stringWithFormat:@"%@",saveM.msg];
        self.labelBecause.text = [NSString stringWithFormat:@"%@",saveM.tijiao];
        
    }
   
}


-(void)buttonOnCLickSuccess
{
    if (self.withButtonOnClickBlock) {
        //0代表成功
        self.withButtonOnClickBlock(0);
    }
}

-(void)buttonOnCLickFail
{
    if (self.withButtonOnClickBlock) {
        //1代表失败
        self.withButtonOnClickBlock(1);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
