//
//  XMShopRongTableViewCell.m
//  fmapp
//
//  Created by runzhiqiu on 16/1/22.
//  Copyright © 2016年 yk. All rights reserved.
//

#define KButtonTag 1000
#import "XMScoreShopModel.h"
#import "XMShopRongTableViewCell.h"
@interface XMShopRongTableViewCell ()
@end

@implementation XMShopRongTableViewCell
- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setSizeCellHeigh:(CGFloat)sizeCellHeigh
{
    _sizeCellHeigh = sizeCellHeigh;
}
-(void)setDataSource:(NSMutableArray *)dataSource
{
    _dataSource = dataSource;
    
    [self createTableViewCell];
    
    
}


-(void)createTableViewCell
{
    
    for (UIView * v in self.contentView.subviews) {
        [v removeFromSuperview];
    }
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    CGFloat height = self.sizeCellHeigh;
    CGFloat width = (KProjectScreenWidth - 20) / 3;
    CGFloat textFont;
    if (KProjectScreenWidth == 320) {
        textFont = 12;
    }else
    {
        textFont = 12;
    }
    
    for (int i = 0; i < self.dataSource.count; i++) {
        
        XMScoreShopModel * model = self.dataSource[i];
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(i * width+10, 0, width, height)];
        view.backgroundColor = [UIColor clearColor];
        
//        边框线
        if (self.dataSource.count == 3) {
          
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, height-1, width, 1)];
            lineView.backgroundColor = KDefaultOrBackgroundColor;
            [view addSubview:lineView];
        }

        if (i!=2) {
           
            UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(width-1, 0, 1, height)];
            lineView1.backgroundColor = KDefaultOrBackgroundColor;
            [view addSubview:lineView1];
        }
        
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, width-20, width-20)];
        imgV.backgroundColor = [UIColor clearColor];
        [imgV sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"敬请稍后new_03"]];
        [view addSubview:imgV];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, width, width, 12)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.8];
        
        titleLabel.font = [UIFont boldSystemFontOfSize:textFont];
        titleLabel.text = model.shangpinmingcheng;
        [view addSubview:titleLabel];
        
        UILabel *integrationLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, width+20, width-6, 10)];
        integrationLabel.textColor = [UIColor colorWithRed:234/255.0f green:22/255.0f blue:66/255.0f alpha:1];
        integrationLabel.textAlignment = NSTextAlignmentCenter;
        integrationLabel.font = [UIFont boldSystemFontOfSize:textFont - 1];
        integrationLabel.text = model.suoxujifen;
        [view addSubview:integrationLabel];
        
        CGFloat length = [self widthForString:integrationLabel.text fontSize:(textFont - 1) andHeight:10];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((width-length)/2-12, width+20, 15, 12)];
        [imageView setImage:[UIImage imageNamed:@"钱图标.png"]];
        [view addSubview:imageView];
        
        [self.contentView addSubview:view];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
        [button addTarget:self action:@selector(xiaoRongAround:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:KButtonTag + i];
        [view addSubview:button];
    }
}

//获取字符串的宽度
-(float) widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(CGFLOAT_MAX, height) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.width;
}

-(void)xiaoRongAround:(UIButton *)button{
    XMScoreShopModel * dict = self.dataSource[(button.tag - KButtonTag)];
    if ([self.delegate respondsToSelector:@selector(XMShopRongTableViewCellDidOnClickItem:withInfo:)]) {
        [self.delegate XMShopRongTableViewCellDidOnClickItem:self withInfo:dict];
    }

}

+(instancetype)XMShopRongTableView:(UITableView *)tableView;
{
    static NSString * flag = @"XMShopRongTableViewCell";
    XMShopRongTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:flag];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XMShopRongTableViewCell" owner:self options:nil] lastObject];
    }
    
    return cell;
}
@end
