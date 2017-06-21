//
//  FMWaitDetailViewCell.m
//  fmapp
//
//  Created by runzhiqiu on 16/5/31.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMWaitDetailViewCell.h"

#import "XZMyOrderGoodsModel.h"

#define kLightGrayTextColor XZColor(143, 143, 143)
#define kDarkGrayTextColor XZColor(48, 48, 48)


@interface FMWaitDetailViewCell ()

@property (nonatomic, strong) UIImageView *imgPhoto;
/** 产品介绍 */
@property (nonatomic, strong) UILabel *introduceLabel;
/** 颜色 */
@property (nonatomic, strong) UILabel *colorLabel;

@property (nonatomic, weak) UIButton *btnAfterSales;

@property (nonatomic, assign) NSInteger viewFontStandard;

@property (nonatomic, strong) UIView  * lineView;
@end

@implementation FMWaitDetailViewCell

-(NSInteger)viewFontStandard
{
    if (_viewFontStandard == 0) {
        if (KProjectScreenWidth == 320) {
            _viewFontStandard = 13;
        }else if (KProjectScreenWidth == 375)
        {
            _viewFontStandard = 14;
        }else
        {
            _viewFontStandard = 15;
        }
    }
    return _viewFontStandard;
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 设置TradeSuccessGoodsCell子视图
        [self setUpTradeSuccessGoodsCell];
    }
    return self;
}
// 设置TradeSuccessGoodsCell子视图
- (void)setUpTradeSuccessGoodsCell {
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    /** 商品图片 */
    self.imgPhoto = [[UIImageView alloc]init];
    [self.contentView addSubview:_imgPhoto];
    [self.imgPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.width.and.height.equalTo(@(KProjectScreenWidth * 0.2));
        make.top.equalTo(self.contentView.mas_top).offset(12);
    }];
    
       /** 产品介绍 */
    self.introduceLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.introduceLabel];
    [self.introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgPhoto.mas_right).offset(8);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.imgPhoto.mas_top);
    }];
    
    self.introduceLabel.numberOfLines = 0;
    
    self.introduceLabel.font = [UIFont systemFontOfSize:self.viewFontStandard];
    
    self.introduceLabel.textColor = [UIColor darkGrayColor];
    /** 颜色 */
    self.colorLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.colorLabel];
    [self.colorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.introduceLabel.mas_left);
        make.top.equalTo(self.introduceLabel.mas_bottom).offset(5);
        make.height.equalTo(@18);
    }];
    
    self.colorLabel.font = [UIFont systemFontOfSize:self.viewFontStandard];
    self.colorLabel.textColor = kLightGrayTextColor;
   
    
    
    /** 申请售后button */
    CGFloat radio = KProjectScreenWidth / 414;
    UIButton *btnAfterSales = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnAfterSales = btnAfterSales;
    
    
    [self.contentView addSubview:btnAfterSales];
    [btnAfterSales mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.equalTo(30 * radio);
        make.width.equalTo(80 * radio);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-12);
    }];
    
    [btnAfterSales setTitle:@"申请售后" forState:UIControlStateNormal];
    btnAfterSales.titleLabel.font = [UIFont systemFontOfSize:self.viewFontStandard];
    btnAfterSales.backgroundColor = [UIColor whiteColor];
    [btnAfterSales setTitleColor:kDarkGrayTextColor forState:UIControlStateNormal];
    btnAfterSales.layer.masksToBounds = YES;
    btnAfterSales.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnAfterSales.layer.borderWidth = 0.5f;
    btnAfterSales.layer.cornerRadius = 4;
    
    [btnAfterSales addTarget:self action:@selector(didClickAfterSalesBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    self.lineView = [[UIView alloc]init];
    [self.contentView addSubview:self.lineView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.equalTo(@0.5);
    }];
    self.lineView.backgroundColor = [UIColor lightGrayColor];
    
}
// 点击申请售后按钮
- (void)didClickAfterSalesBtn:(UIButton *)button {
    if (self.blockAfterSalesBtn) {
        self.blockAfterSalesBtn(button);
    }
}
/** 创建cell */
+ (instancetype )cellTradeSuccessGoodsWithTableView:(UITableView *)tableView{
    static NSString *reuseID = @"FMWaitDetailViewCell";
    FMWaitDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setAfterSalesBtnTitle:(NSString *)afterSalesBtnTitle
{
    _afterSalesBtnTitle = afterSalesBtnTitle;
    [self.btnAfterSales setTitle:afterSalesBtnTitle forState:UIControlStateNormal];
}
- (void)setGoodsModel:(XZMyOrderGoodsModel *)goodsModel {
    _goodsModel = goodsModel;
    [self.imgPhoto sd_setImageWithURL:[NSURL URLWithString:goodsModel.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
    self.introduceLabel.text = goodsModel.name;
    self.colorLabel.text = goodsModel.spec_info;
    
    if ([_goodsModel.aftersales integerValue] != 0) {
        self.btnAfterSales.hidden = YES;
    }else
    {
        self.btnAfterSales.hidden = NO;
    }
    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



@end
