//
//  FMTradeDetailViewCell.m
//  fmapp
//
//  Created by runzhiqiu on 16/5/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMTradeDetailViewCell.h"
#import "XZMyOrderGoodsModel.h"

#define kLightGrayTextColor XZColor(143, 143, 143)
#define kDarkGrayTextColor XZColor(48, 48, 48)

@interface FMTradeDetailViewCell ()


@property (nonatomic, strong) UIImageView *imgPhoto;
/** 产品介绍 */
@property (nonatomic, strong) UILabel *introduceLabel;
/** 颜色 */
@property (nonatomic, strong) UILabel *colorLabel;
///** 尺码 */
//@property (nonatomic, strong) UILabel *sizeLabel;
/** 价格 */
@property (nonatomic, strong) UILabel *priceLabel;
/** 数量 */
@property (nonatomic, strong) UILabel *quantityLabel;


/** 价格划线 */
@property (nonatomic, strong) UILabel *priceLineLabel;

@property (nonatomic, weak) UIButton *btnAfterSales;


@property (nonatomic, assign) NSInteger viewFontStandard;
@end
@implementation FMTradeDetailViewCell
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
    self.backgroundColor = XZColor(225, 230, 234);
    self.contentView.backgroundColor = XZColor(255, 255, 255);
    /** 商品图片 */
    self.imgPhoto = [[UIImageView alloc]init];
    [self.contentView addSubview:_imgPhoto];
    [self.imgPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.width.and.height.equalTo(@(KProjectScreenWidth * 0.2));
        make.top.equalTo(self.contentView.mas_top).offset(12);
    }];
    
    /** 价格 */
    self.priceLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.imgPhoto.mas_top);
        make.height.equalTo(@18);
        make.width.equalTo(@80);
    }];
    self.priceLabel.textColor = kDarkGrayTextColor;
    self.priceLabel.font = [UIFont systemFontOfSize:self.viewFontStandard - 1];
    self.priceLabel.textAlignment = NSTextAlignmentRight;
    /** 价格划线 */
    UILabel *priceLineLabel = [[UILabel alloc]init];
    self.priceLineLabel = priceLineLabel;
    [self.contentView addSubview:priceLineLabel];
    [priceLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.priceLabel.mas_bottom).offset(4);
        make.height.equalTo(@18);
        make.width.equalTo(@80);
    }];
    priceLineLabel.textColor = kDarkGrayTextColor;
    priceLineLabel.font = [UIFont systemFontOfSize:self.viewFontStandard - 1];
    priceLineLabel.textAlignment = NSTextAlignmentRight;
    /** 产品介绍 */
    self.introduceLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.introduceLabel];
    [self.introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgPhoto.mas_right).offset(8);
        make.right.equalTo(self.priceLabel.mas_left).offset(-2);
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
    /** 数量 */
    self.quantityLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.quantityLabel];
    [self.quantityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceLineLabel.mas_bottom).offset(5);
        make.height.equalTo(@18);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    self.quantityLabel.textColor = kDarkGrayTextColor;
    self.quantityLabel.font = [UIFont systemFontOfSize:self.viewFontStandard - 1];
    self.quantityLabel.textAlignment = NSTextAlignmentRight;
    
    
    /** 申请售后button */
    CGFloat radio = KProjectScreenWidth / 414;
    UIButton *btnAfterSales = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnAfterSales = btnAfterSales;
    
    
    [self.contentView addSubview:btnAfterSales];
    [btnAfterSales mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.equalTo(30 * radio);
        make.width.equalTo(80 * radio);
        make.top.equalTo(self.quantityLabel.mas_bottom).offset(8);
    }];
    
    [btnAfterSales setTitle:@"申请售后" forState:UIControlStateNormal];
    btnAfterSales.titleLabel.font = [UIFont systemFontOfSize:self.viewFontStandard];
    
    [btnAfterSales setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [btnAfterSales setTintColor:[UIColor whiteColor]];
    btnAfterSales.backgroundColor = XZColor(6, 41, 125);
    btnAfterSales.layer.borderColor = XZColor(6, 41, 125).CGColor;

    btnAfterSales.layer.masksToBounds = YES;
    btnAfterSales.layer.borderWidth = 0.5f;
    btnAfterSales.layer.cornerRadius = 4;
    
    [btnAfterSales addTarget:self action:@selector(didClickAfterSalesBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = XZColor(225, 230, 234);
    [self.contentView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.equalTo(@0.5);
    }];
    
}
// 点击申请售后按钮
- (void)didClickAfterSalesBtn:(UIButton *)button {
    if (self.blockAfterSalesBtn) {
        self.blockAfterSalesBtn(button);
    }
}
/** 创建cell */
+ (instancetype )cellTradeSuccessGoodsWithTableView:(UITableView *)tableView{
    static NSString *reuseID = @"FMTradeDetailViewCell";
    FMTradeDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
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
    CGFloat price = [goodsModel.price floatValue];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",price];
    self.quantityLabel.text = goodsModel.quantity;
    
    if (self.isShowComment) {
        if (self.isOrderDetail == 1) {
            if (([goodsModel.aftersales integerValue] != 0)||(![goodsModel.order_type isMemberOfClass:[NSNull class]]&&[goodsModel.order_type integerValue] != 0)) {
                self.btnAfterSales.hidden = YES;
            }else
            {
                self.btnAfterSales.hidden = NO;
            }
            
        }else{
            if ((![goodsModel.order_type isMemberOfClass:[NSNull class]]&&[goodsModel.order_type integerValue] != 0)) {
                self.btnAfterSales.hidden = YES;
            }else
            {
                self.btnAfterSales.hidden = NO;
            }
            
        }
        
        
    }else
    {
        
        if (self.isOrderDetail == 1) {
            if (goodsModel.orderStatusFM == 1) {
                
                self.btnAfterSales.hidden = YES;
                
            }else if([_goodsModel.aftersales integerValue] == 1){
                
                //已经申请售后
                self.btnAfterSales.hidden = YES;
            
            }else if(goodsModel.orderStatusFM < 22)
            {
                if ([_goodsModel.aftersales integerValue] != 0) {
                    self.btnAfterSales.hidden = YES;
                }else
                {
                    self.btnAfterSales.hidden = NO;
                }
            }else if((goodsModel.orderStatusFM == 41 || goodsModel.orderStatusFM == 51)&&!(![goodsModel.order_type isMemberOfClass:[NSNull class]]&&[goodsModel.order_type integerValue] != 0)){
            
                self.btnAfterSales.hidden = NO;

            }else
            {
                self.btnAfterSales.hidden = YES;
            }
            
            
            
            
        }else
        {
            if (goodsModel.orderStatusFM == 1) {
                
                self.btnAfterSales.hidden = YES;
                
            }else if(goodsModel.orderStatusFM < 22)
            {
                if ([_goodsModel.aftersales integerValue] != 0) {
                    self.btnAfterSales.hidden = YES;
                }else
                {
                    self.btnAfterSales.hidden = NO;
                }
            }else
            {
                self.btnAfterSales.hidden = YES;
            }
            
        }
        
       
        
    }
    
    if (self.isOrderDetail == 1) {
        self.btnAfterSales.backgroundColor = [UIColor whiteColor];
        self.btnAfterSales.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self.btnAfterSales setTitleColor:[HXColor colorWithHexString:@"#1e1e1e"] forState:UIControlStateNormal];
    }else
    {
        [self.btnAfterSales setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.btnAfterSales setTintColor:[UIColor whiteColor]];
        self.btnAfterSales.backgroundColor = XZColor(6, 41, 125);
        self.btnAfterSales.layer.borderColor = XZColor(6, 41, 125).CGColor;
        
    }

    
    if (goodsModel.mktprice != nil) {
        // 给数字划线
        CGFloat price = [goodsModel.mktprice floatValue];
        NSString *oldPrice = [NSString stringWithFormat:@"￥%.2f",price];
        NSUInteger length = [oldPrice length];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
        [attri addAttribute:NSStrikethroughColorAttributeName value:kLightGrayTextColor range:NSMakeRange(0, length)];
        [self.priceLineLabel setAttributedText:attri];
    }
    
    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


@end
