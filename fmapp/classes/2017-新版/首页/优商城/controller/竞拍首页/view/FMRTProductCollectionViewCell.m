//
//  FMRTProductCollectionViewCell.m
//  fmapp
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTProductCollectionViewCell.h"


@interface FMRTProductCollectionViewCell ()

@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UILabel *titleLabel, *currentLabel, *disaLabel;
@property (nonatomic, strong) UIButton *bRBtn, *sRBtn, *gRBtn, *pointPBtn, *pointSBtn;
@property (nonatomic, strong) UIButton *aucBtn, *noteButton;
@property (nonatomic, assign) NSInteger buttonType, endCount;
@property (nonatomic, copy) NSString *auctionId, *productId;

@end

@implementation FMRTProductCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createTopView];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)createTopView{
    
    [self.photoView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.equalTo((KProjectScreenWidth - 40)/2);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.photoView.mas_left);
        make.right.equalTo(self.photoView.mas_right);
        make.top.equalTo(self.photoView.mas_bottom).offset(7);
    }];
    
    UILabel *currentLabel = [UILabel new];
    self.currentLabel = currentLabel;
    currentLabel.text = @"当前竞拍价:¥";
    currentLabel.textColor = [UIColor redColor];
    if (KProjectScreenWidth >320) {
        currentLabel.font = [UIFont systemFontOfSize:13];
    }else{
        currentLabel.font = [UIFont systemFontOfSize:11];
    }
    [self.contentView addSubview:currentLabel];
    [currentLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
    
    [self.bRBtn makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(currentLabel.mas_centerY);
        make.left.equalTo(currentLabel.mas_right).offset(2);
        make.width.equalTo(@11);
        make.height.equalTo(@16);
    }];
    
    [self.sRBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(currentLabel.mas_centerY);
        make.left.equalTo(self.bRBtn.mas_right).offset(2);
        make.width.equalTo(@11);
        make.height.equalTo(@16);
    }];
    
    [self.gRBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(currentLabel.mas_centerY);
        make.left.equalTo(self.sRBtn.mas_right).offset(2);
        make.width.equalTo(@11);
        make.height.equalTo(@16);
    }];
    
    UILabel *pointLabel = [[UILabel alloc]init];
    pointLabel.text = @".";
    pointLabel.textColor = [UIColor redColor];
    [self.contentView addSubview:pointLabel];
    [pointLabel makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.gRBtn.mas_right).offset(2);
        make.centerY.equalTo(self.gRBtn.mas_centerY);
    }];
    
    UIButton *zeronBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    zeronBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    zeronBtn.backgroundColor = [UIColor redColor];
    zeronBtn.layer.cornerRadius = 2;
    self.pointSBtn = zeronBtn;
    [zeronBtn setTitle:@"0" forState:(UIControlStateNormal)];
    zeronBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [self.contentView addSubview:zeronBtn];
    [zeronBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(currentLabel.mas_centerY);
        make.left.equalTo(pointLabel.mas_right).offset(2);
        make.width.equalTo(@11);
        make.height.equalTo(@16);
    }];
    
    UIButton *zeronBtn1 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    zeronBtn1 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    zeronBtn1.backgroundColor = [UIColor redColor];
    zeronBtn1.layer.cornerRadius = 2;
    self.pointPBtn = zeronBtn1;
    [zeronBtn1 setTitle:@"0" forState:(UIControlStateNormal)];
    zeronBtn1.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [self.contentView addSubview:zeronBtn1];
    [zeronBtn1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(currentLabel.mas_centerY);
        make.left.equalTo(zeronBtn.mas_right).offset(2);
        make.width.equalTo(@11);
        make.height.equalTo(@16);
    }];
    
    UILabel *disaLabel = [UILabel new];
    self.disaLabel = disaLabel;
    //    disaLabel.text = @"¥60/竞价上限:¥12";
    disaLabel.textColor = [UIColor colorWithHexString:@"#ccc"];
    disaLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:disaLabel];
    [disaLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.photoView.mas_left);
        make.top.equalTo(currentLabel.mas_bottom).offset(7);
    }];
    
    [self.aucBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.photoView.mas_left);
        make.right.equalTo(self.photoView.mas_right);
        make.height.equalTo((KProjectScreenWidth/2 - 20) * 5 / 28);
        make.top.equalTo(disaLabel.mas_bottom).offset(7);
    }];
    
    [self.noteButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.aucBtn.mas_bottom).offset(5);
        make.right.equalTo(self.photoView.mas_right);
    }];
    
}

- (UIButton *)gRBtn{
    if (!_gRBtn) {
        _gRBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _gRBtn.backgroundColor = [UIColor redColor];
        _gRBtn.layer.cornerRadius = 2;
        [_gRBtn setTitle:@"0" forState:(UIControlStateNormal)];
        _gRBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [self.contentView addSubview:self.gRBtn];

    }
    return _gRBtn;
}

- (UIButton *)sRBtn{
    if (!_sRBtn) {
        _sRBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _sRBtn.backgroundColor = [UIColor redColor];
        _sRBtn.layer.cornerRadius = 2;
        [_sRBtn setTitle:@"0" forState:(UIControlStateNormal)];
        _sRBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [self.contentView addSubview:self.sRBtn];

    }
    return _sRBtn;
}

- (UIButton *)bRBtn{
    if (!_bRBtn) {
        
        _bRBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _bRBtn.backgroundColor = [UIColor redColor];
        _bRBtn.layer.cornerRadius = 2;
        [_bRBtn setTitle:@"0" forState:(UIControlStateNormal)];
        _bRBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [self.contentView addSubview:self.bRBtn];

    }
    return _bRBtn;
}

- (UIImageView *)photoView{
    if (!_photoView) {
        _photoView = [[UIImageView alloc]init ];
//        _photoView.backgroundColor = [UIColor purpleColor];
        //        _photoView.image=[UIImage imageNamed:@"竞拍商品_07"];
        _photoView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.photoView];

    }
    return _photoView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"小融珍藏版优盘/4g内存轻巧";
        _titleLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.titleLabel];

    }
    return _titleLabel;
}

- (UIButton *)aucBtn{
    if (!_aucBtn) {
        _aucBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _aucBtn.backgroundColor = [UIColor redColor];
        _aucBtn.imageView.contentMode = UIViewContentModeScaleToFill;
        _aucBtn.layer.cornerRadius = 5;
//        [_aucBtn setTitle:@"我要竞拍" forState:(UIControlStateNormal)];
        _aucBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_aucBtn addTarget:self action:@selector(aucAction:) forControlEvents:(UIControlEventTouchUpInside)];
        _aucBtn.tag = 8080;
        [self.contentView addSubview:self.aucBtn];

    }
    return _aucBtn;
}

- (UIButton *)noteButton{
    if (!_noteButton) {
        _noteButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_noteButton setTitle:@"竞拍记录>" forState:(UIControlStateNormal)];
        _noteButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_noteButton setTitleColor:[HXColor colorWithHexString:@"#ccc"]forState:(UIControlStateNormal)] ;
        _noteButton.tag = 8081;
        [_noteButton addTarget:self action:@selector(noteAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.contentView addSubview:self.noteButton];

    }
    return _noteButton;
}

- (void)aucAction:(UIButton *)sender{
    if (self.PBlock) {
        self.PBlock(sender,self.buttonType,self.auctionId, self.productId,self.endCount);
    }
}

- (void)noteAction:(NSString *)auctionId{
    if (self.RBlock) {
        self.RBlock(self.auctionId);
    }
}

- (void)setModel:(FMRTAucFirstModel *)model{
    
    [self.bRBtn setTitle:@"0" forState:(UIControlStateNormal)];
    [self.sRBtn setTitle:@"0" forState:(UIControlStateNormal)];
    [self.gRBtn setTitle:@"0" forState:(UIControlStateNormal)];
    [self.pointPBtn setTitle:@"0" forState:(UIControlStateNormal)];
    [self.pointSBtn setTitle:@"0" forState:(UIControlStateNormal)];
    
    self.auctionId = model.auction_id;
    self.productId = model.product_id;
    self.buttonType = [model.activity_state integerValue];
    switch ([model.activity_state integerValue]) {

        case 1:{
            [_aucBtn setTitle:@"未开始" forState:(UIControlStateNormal)];
            _aucBtn.backgroundColor = XZColor(169, 170, 171);
            _noteButton.hidden = YES;
            [self.photoView sd_setImageWithURL:model.image_url placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
            break;
        }
        case 2:{
            
            if ([model.current_price floatValue] == [model.max_price floatValue]) {
                
                [_aucBtn setTitle:@"竞拍结束" forState:(UIControlStateNormal)];
                _aucBtn.backgroundColor = XZColor(169, 170, 171);
                _noteButton.hidden = NO;
                [self.photoView sd_setImageWithURL:model.gray_image_url placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
                self.endCount = 1;
            }else{
                
                [_aucBtn setTitle:@"我要竞拍" forState:(UIControlStateNormal)];
                _aucBtn.backgroundColor = [UIColor redColor];
                _noteButton.hidden = NO;
                [self.photoView sd_setImageWithURL:model.image_url placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
                self.endCount = 2;

            }
            
            break;
        }
        case 3:{
            [_aucBtn setTitle:@"竞拍结束" forState:(UIControlStateNormal)];
            _aucBtn.backgroundColor = XZColor(169, 170, 171);
            _noteButton.hidden = NO;
            [self.photoView sd_setImageWithURL:model.gray_image_url placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
            break;
        }
        default:
            break;
    }
    
    self.titleLabel.text = model.goods_name;
    
    NSString *price = [NSString stringWithFormat:@"¥%@",model.price];
    NSString *max_price = [NSString stringWithFormat:@"¥%@",model.max_price];
    
    NSString *titleAll = [NSString stringWithFormat:@"%@/竞价上限:%@",price,max_price];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:titleAll];
    NSRange range = [titleAll rangeOfString:price];
    [attrStr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
    
    self.disaLabel.attributedText = attrStr;
    
    if ([model.current_price floatValue]>=100) {
        self.bRBtn.hidden = NO;
        self.sRBtn.hidden = NO;
        [self.bRBtn updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@11);
        }];
        [self.sRBtn updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@11);
        }];
        [self.bRBtn setTitle:[NSString stringWithFormat:@"%d", [model.current_price intValue]/100] forState:(UIControlStateNormal)];
        [self.sRBtn setTitle:[NSString stringWithFormat:@"%d", [model.current_price intValue]/10%10] forState:(UIControlStateNormal)];
        [self.gRBtn setTitle:[NSString stringWithFormat:@"%d", [model.current_price intValue]%10] forState:(UIControlStateNormal)];

    }else if([model.current_price floatValue]<100 && [model.current_price floatValue]>=10){
        self.bRBtn.hidden = YES;
        self.sRBtn.hidden = NO;
        [self.bRBtn updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0);
        }];
        [self.sRBtn updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@11);
        }];
        [self.sRBtn setTitle:[NSString stringWithFormat:@"%d", [model.current_price intValue]/10] forState:(UIControlStateNormal)];
        [self.gRBtn setTitle:[NSString stringWithFormat:@"%d", [model.current_price intValue]%10] forState:(UIControlStateNormal)];
    }else if([model.current_price floatValue]>0 &&[model.current_price floatValue] < 10){
        self.bRBtn.hidden = YES;
        self.sRBtn.hidden = YES;
        [self.bRBtn updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0);
        }];
        [self.sRBtn updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0);
        }];
        [self.gRBtn setTitle:[NSString stringWithFormat:@"%d", [model.current_price intValue]%10] forState:(UIControlStateNormal)];
        
    }else if ([model.current_price floatValue] == 0){
        self.bRBtn.hidden = YES;
        self.sRBtn.hidden = NO;
        [self.sRBtn updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@11);
        }];
        [self.bRBtn updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0);
        }];
    }
    
    NSString *pr = [NSString stringWithFormat:@"%.2f",[model.current_price floatValue]];
    
    float prFloat = [pr floatValue];
    int ggg = ((int)(prFloat *100)) %10;
    int sss = ((int)(prFloat *10)) %10;
    [self.pointPBtn setTitle:[NSString stringWithFormat:@"%d", ggg] forState:(UIControlStateNormal)];
    [self.pointSBtn setTitle:[NSString stringWithFormat:@"%d", sss] forState:(UIControlStateNormal)];
    
}

@end
