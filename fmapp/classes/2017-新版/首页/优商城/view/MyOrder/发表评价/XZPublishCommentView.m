//
//  XZPublishCommentView.m
//  XZFenLeiJieMian
//
//  Created by admin on 16/5/4.
//  Copyright © 2016年 yuyang. All rights reserved.
//

#import "XZPublishCommentView.h"
#import "XZTextView.h"
#import "AXRatingView.h"
#import "XZMyOrderGoodsModel.h"

#define kDarkGrayTextColor XZColor(48, 48, 48)

@interface XZPublishCommentView ()<UICollectionViewDelegateFlowLayout>
/** 商品图片 */
@property (nonatomic, strong) UIImageView *imgGoods;
@end

@implementation XZPublishCommentView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 设置PublishCommentView子视图
        [self setUpPublishCommentView];
    }
    return self;
}
// 设置PublishCommentView子视图
- (void)setUpPublishCommentView {
    // 上方视图
    [self createTopView];
    // 下方发表评价
    [self createCommentView];
}
// 上方视图
- (void)createTopView {
    self.backgroundColor = [UIColor whiteColor];
    /** 商品图片 */
    UIImageView *imgGoods = [[UIImageView alloc]init];
    [self addSubview:imgGoods];
    [imgGoods mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(10);
        make.width.and.height.equalTo(@((KProjectScreenWidth - 20 - KProjectScreenWidth * 0.08) / 4.0));
    }];
    self.imgGoods = imgGoods;
    imgGoods.image = [UIImage imageNamed:@"图片136x136"];
    /** 填写评价 */
    XZTextView *textComment = [[XZTextView alloc]init];
    [self addSubview:textComment];
    [textComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgGoods.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(imgGoods.mas_top);
        make.bottom.equalTo(imgGoods.mas_bottom);
    }];
    textComment.font = [UIFont systemFontOfSize:15];
    textComment.placeholder = @"亲！请写下对我们的评价吧！";
    textComment.layer.borderColor = [XZColor(235, 235, 242) CGColor];
    textComment.layer.borderWidth = 1.0f;
    self.textComment = textComment;
    /** 评价图片 */
    UIView *viewPhoto = [[UIView alloc]init];
    [self addSubview:viewPhoto];
    [viewPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(textComment.mas_bottom).offset(10);
        make.width.equalTo(@(KProjectScreenWidth - 20));
        make.height.equalTo(imgGoods.mas_width);
    }];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat size = (KProjectScreenWidth - 20 - KProjectScreenWidth * 0.08) / 4.0;
    flowLayout.itemSize = CGSizeMake(size, size);
    flowLayout.minimumInteritemSpacing = 0.026 * KProjectScreenWidth;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [viewPhoto addSubview:self.collectionView];
    self.collectionView.scrollEnabled = NO;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewPhoto.mas_left);
        make.top.equalTo(viewPhoto.mas_top);
        make.width.equalTo(viewPhoto.mas_width);
        make.height.equalTo(viewPhoto.mas_height);
    }];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    UILabel *labelProfmpt = [[UILabel alloc] init];
    [self addSubview:labelProfmpt];
    [labelProfmpt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgGoods);
        make.top.equalTo(viewPhoto.mas_bottom).offset(10);
    }];
    labelProfmpt.font = [UIFont systemFontOfSize:13];
    labelProfmpt.text = @"传图片最多3张，总大小不超过3m";
    labelProfmpt.textColor = XZColor(175, 175, 175);
    
    /** 图片下方细线 */
    UILabel *line = [[UILabel alloc]init];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewPhoto.mas_left);
        make.top.equalTo(labelProfmpt.mas_bottom).offset(10);
        make.right.equalTo(viewPhoto.mas_right);
        make.height.equalTo(@1);
    }];
    line.backgroundColor = XZColor(210, 211, 212);
    
    /** 描述相符 */
    UILabel *labelDescribe = [[UILabel alloc]init];
    [self addSubview:labelDescribe];
    [labelDescribe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewPhoto.mas_left);
        make.top.equalTo(line.mas_bottom).offset(10);
    }];
    labelDescribe.text = @"描述相符";
    AXRatingView *halfStepRatingView = [[AXRatingView alloc] init];
    [self addSubview:halfStepRatingView];
    [halfStepRatingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewPhoto.mas_right);
        make.top.equalTo(labelDescribe.mas_top);
    }];
    [halfStepRatingView sizeToFit];
    _halfStepRatingView = halfStepRatingView;
    [halfStepRatingView setStepInterval:1];
    halfStepRatingView.markImage = [UIImage imageNamed:@"发表评价星星"];
    [halfStepRatingView addTarget:self action:@selector(ratingChanged:) forControlEvents:UIControlEventValueChanged];
    halfStepRatingView.value = 5.00;
    halfStepRatingView.minimumValue = 1.00;
    
    /** 最下面的分割线 */
    UILabel *lineCoarse = [[UILabel alloc]init];
    [self addSubview:lineCoarse];
    [lineCoarse mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(halfStepRatingView.mas_bottom).offset(10);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@15);
    }];
    lineCoarse.backgroundColor = XZColor(230, 235, 240);
    
    // 第二个
    UILabel *labelMall = [[UILabel alloc]init];
    [self addSubview:labelMall];
    [labelMall mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(lineCoarse.mas_top).offset(20);
    }];
    labelMall.text = @"商城评分";
    
    // 星星1
    UILabel *labelSpeed = [[UILabel alloc]init];
    [self addSubview:labelSpeed];
    [labelSpeed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelMall.mas_left);
        make.top.equalTo(labelMall.mas_bottom).offset(10);
    }];
    labelSpeed.text = @"发货速度";
    AXRatingView *speedView = [[AXRatingView alloc] init];
    [self addSubview:speedView];
    [speedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(labelSpeed.mas_top);
    }];
    [speedView sizeToFit];
    _speedView = speedView;
    [speedView setStepInterval:1];
    speedView.markImage = [UIImage imageNamed:@"发表评价星星"];
    [speedView addTarget:self action:@selector(ratingChanged:) forControlEvents:UIControlEventValueChanged];
    speedView.value = 5.00;
    _speedView.minimumValue = 1.00;

    // 星星2
    UILabel *labelService = [[UILabel alloc]init];
    [self addSubview:labelService];
    [labelService mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelMall.mas_left);
        make.top.equalTo(speedView.mas_bottom).offset(10);
    }];
    labelService.text = @"服务态度";
    AXRatingView *serviceView = [[AXRatingView alloc] init];
    [self addSubview:serviceView];
    [serviceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(speedView.mas_right);
        make.top.equalTo(labelService.mas_top);
    }];
    [serviceView sizeToFit];
    _serviceView = serviceView;
    [serviceView setStepInterval:1];
    serviceView.markImage = [UIImage imageNamed:@"发表评价星星"];
    [serviceView addTarget:self action:@selector(ratingChanged:) forControlEvents:UIControlEventValueChanged];
    serviceView.value = 5.00;
    _serviceView.minimumValue = 1.00;
    
    UILabel *lineCoarse2 = [[UILabel alloc]init];
    [self addSubview:lineCoarse2];
    [lineCoarse2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(serviceView.mas_bottom).offset(20);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@15);
    }];
    lineCoarse2.backgroundColor = XZColor(230, 235, 240);
}

// 评分
- (void)ratingChanged:(AXRatingView *)sender
{
    [self endEditing:YES];
    Log(@"sender value = %.2f",[sender value]);
}

// 下方发表评价
- (void)createCommentView {
    // 整体的view
    UIView *commentView = [[UIView alloc]initWithFrame:CGRectMake(0, KProjectScreenHeight - 114, KProjectScreenWidth, 50)];
    [self addSubview:commentView];
    commentView.backgroundColor = [UIColor whiteColor];
    UILabel *line = [[UILabel alloc]init];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(commentView.mas_left);
        make.top.equalTo(commentView.mas_top);
        make.right.equalTo(commentView.mas_right);
        make.height.equalTo(@2);
    }];
    line.backgroundColor = XZColor(235, 236, 236);
    /** 发表评价按钮 */
    UIButton *btnComment = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentView addSubview:btnComment];
    [btnComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(commentView.mas_right);
        make.top.equalTo(commentView.mas_top);
        make.width.equalTo(@100);
        make.height.equalTo(commentView.mas_height);
    }];
    //    self.btnComment = btnComment;
    [btnComment setTitle:@"发表评价" forState:UIControlStateNormal];
    btnComment.backgroundColor = [UIColor colorWithRed:6/255.0 green:41/255.0 blue:125/255.0 alpha:1.0f];
    [btnComment addTarget:self action:@selector(didClickCommentBtn:) forControlEvents:UIControlEventTouchUpInside];
    btnComment.tag = 207;
    /** 是否匿名评价 */
    UIButton *btnAnonymousComment = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentView addSubview:btnAnonymousComment];
    [btnAnonymousComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(commentView.mas_left).offset(30);
        make.centerY.equalTo(commentView.mas_centerY);
    }];
    self.btnAnonymousComment = btnAnonymousComment;
    [btnAnonymousComment setTitle:@"匿名评价" forState:UIControlStateNormal];
    [btnAnonymousComment setImage:[UIImage imageNamed:@"shop_myassess_false"] forState:UIControlStateNormal];
    [btnAnonymousComment setImage:[UIImage imageNamed:@"shop_myassess_true"] forState:UIControlStateSelected];
    [btnAnonymousComment setTitleColor:kDarkGrayTextColor forState:UIControlStateNormal];
    [btnAnonymousComment addTarget:self action:@selector(didClickAnonymousCommentBtn:) forControlEvents:UIControlEventTouchUpInside];
    btnAnonymousComment.selected = YES;
    btnAnonymousComment.tag = 208;
}

// 点击匿名评价
- (void)didClickAnonymousCommentBtn:(UIButton *)button {
    button.selected = !button.selected;
    if (self.blockCommentBtn) {
        self.blockCommentBtn(button);
    }
}

// 发表评价
- (void)didClickCommentBtn:(UIButton *)button {
    if (self.blockCommentBtn) {
        self.blockCommentBtn(button);
    }
}

- (void)setSendModel:(XZMyOrderGoodsModel *)sendModel {
    [self.imgGoods sd_setImageWithURL:[NSURL URLWithString:sendModel.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"敬请稍后new_03"]];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self endEditing:YES];
//}
@end
