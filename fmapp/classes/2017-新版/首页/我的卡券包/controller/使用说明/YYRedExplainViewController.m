//
//  YYRedExplainViewController.m
//  fmapp
//
//  Created by yushibo on 2016/12/19.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "YYRedExplainViewController.h"

@interface YYRedExplainViewController () <UIScrollViewDelegate>

@end

@implementation YYRedExplainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:@"红包券使用说明"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#e5e9f2"];
    [self createContentView];
}
- (void)createContentView{

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 7, KProjectScreenWidth, KProjectScreenHeight - 64 -7)];
    scrollView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    scrollView.delegate = self;
    // 设置内容大小
    scrollView.contentSize = CGSizeMake(0, KProjectScreenHeight);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.scrollEnabled = YES;
    scrollView.showsVerticalScrollIndicator = YES;

    UIView * contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 64 - 7)];
    //    contentView.backgroundColor = [UIColor greenColor];
    [scrollView addSubview:contentView];

    [self.view addSubview:scrollView];
    
    /**  第一个问题 */
    UILabel *questionLabel1 = [[UILabel alloc]init];
    questionLabel1.text = @"Q: 如何选择红包券？";
    questionLabel1.textAlignment = NSTextAlignmentLeft;
    questionLabel1.font = [UIFont systemFontOfSize:16];
    questionLabel1.textColor = [UIColor colorWithHexString:@"#333333"];
    [contentView addSubview:questionLabel1];
    [questionLabel1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView.mas_left).offset(15);
        make.top.equalTo(scrollView.mas_top).offset(15);
    
    }];
    UILabel *answerLabel1 = [[UILabel alloc]init];
    answerLabel1.text = @"用户投资时，可选择需要使用的红包，选择红包后，可自动抵减投资本金。（如未选择并使用红包，则此次投资不享受红包抵扣）";
    answerLabel1.numberOfLines = 0;
    answerLabel1.textAlignment = NSTextAlignmentLeft;
    answerLabel1.font = [UIFont systemFontOfSize:16];
    answerLabel1.textColor = [UIColor colorWithHexString:@"#666666"];
    [contentView addSubview:answerLabel1];
    [answerLabel1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(questionLabel1.mas_bottom).offset(10);
    }];
    UIImageView *lineV1 = [[UIImageView alloc]init];
    lineV1.backgroundColor = [UIColor colorWithHexString:@"#e5e9f2"];
    [contentView addSubview:lineV1];
    [lineV1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(answerLabel1.mas_bottom).offset(15);
        make.height.equalTo(1);
    }];
    
    /**  第二个问题 */
    UILabel *questionLabel2 = [[UILabel alloc]init];
    questionLabel2.text = @"Q: 每次投资可以使用几个红包券？";
    questionLabel2.textAlignment = NSTextAlignmentLeft;
    questionLabel2.font = [UIFont systemFontOfSize:16];
    questionLabel2.textColor = [UIColor colorWithHexString:@"#333333"];
    [contentView addSubview:questionLabel2];
    [questionLabel2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(lineV1.mas_top).offset(15);
        
    }];
    UILabel *answerLabel2 = [[UILabel alloc]init];
    answerLabel2.text = @"每次投资只能使用一个红包券。";
    answerLabel2.numberOfLines = 0;
    answerLabel2.textAlignment = NSTextAlignmentLeft;
    answerLabel2.font = [UIFont systemFontOfSize:16];
    answerLabel2.textColor = [UIColor colorWithHexString:@"#666666"];
    [contentView addSubview:answerLabel2];
    [answerLabel2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(questionLabel2.mas_bottom).offset(10);
        
    }];
    UIImageView *lineV2 = [[UIImageView alloc]init];
    lineV2.backgroundColor = [UIColor colorWithHexString:@"#e5e9f2"];
    [contentView addSubview:lineV2];
    [lineV2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(answerLabel2.mas_bottom).offset(15);
        make.height.equalTo(1);
    }];
    
    /**  第三个问题 */
    UILabel *questionLabel3 = [[UILabel alloc]init];
    questionLabel3.text = @"Q: 各类红包券的使用条件是什么？";
    questionLabel3.textAlignment = NSTextAlignmentLeft;
    questionLabel3.font = [UIFont systemFontOfSize:16];
    questionLabel3.textColor = [UIColor colorWithHexString:@"#333333"];
    [contentView addSubview:questionLabel3];
    [questionLabel3 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(lineV2.mas_top).offset(15);
        
    }];
    UILabel *answerLabel3 = [[UILabel alloc]init];
    answerLabel3.text = @"各类红包的具体使用条件请参阅该红包券的介绍页面。";
    answerLabel3.numberOfLines = 0;
    answerLabel3.textAlignment = NSTextAlignmentLeft;
    answerLabel3.font = [UIFont systemFontOfSize:16];
    answerLabel3.textColor = [UIColor colorWithHexString:@"#666666"];
    [contentView addSubview:answerLabel3];
    [answerLabel3 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(questionLabel3.mas_bottom).offset(10);
        
    }];
    UIImageView *lineV3 = [[UIImageView alloc]init];
    lineV3.backgroundColor = [UIColor colorWithHexString:@"#e5e9f2"];
    [contentView addSubview:lineV3];
    [lineV3 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(answerLabel3.mas_bottom).offset(15);
        make.height.equalTo(1);
    }];

    /**  第四个问题 */
    UILabel *questionLabel4 = [[UILabel alloc]init];
    questionLabel4.text = @"Q: 使用了红包券投资如何计算收益？";
    questionLabel4.textAlignment = NSTextAlignmentLeft;
    questionLabel4.font = [UIFont systemFontOfSize:16];
    questionLabel4.textColor = [UIColor colorWithHexString:@"#333333"];
    [contentView addSubview:questionLabel4];
    [questionLabel4 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(lineV3.mas_top).offset(15);
        
    }];
    UILabel *answerLabel4 = [[UILabel alloc]init];
    answerLabel4.text = @"使用了红包券抵扣投资本金，系统会按照未抵扣的金额计算实际收益，项目到期，返还实际投资本金。例如，投资1000元，3个月，使用了5元红包，实际支付995元，每月系统会按照1000元计算利息并发放，项目到期，返还995元本金。";
    answerLabel4.numberOfLines = 0;
    answerLabel4.textAlignment = NSTextAlignmentLeft;
    answerLabel4.font = [UIFont systemFontOfSize:16];
    answerLabel4.textColor = [UIColor colorWithHexString:@"#666666"];
    [contentView addSubview:answerLabel4];
    [answerLabel4 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(questionLabel4.mas_bottom).offset(10);
        
    }];
//    UIImageView *lineV4 = [[UIImageView alloc]init];
//    lineV4.backgroundColor = [UIColor colorWithHexString:@"#e5e9f2"];
//    [scrollView addSubview:lineV4];
//    [lineV4 makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(15);
//        make.right.equalTo(self.view.mas_right).offset(-15);
//        make.top.equalTo(answerLabel4.mas_bottom).offset(15);
//        make.height.equalTo(1);
//    }];


    
}
@end
