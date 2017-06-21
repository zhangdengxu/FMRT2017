//
//  FMPlaceOrderTabbar.m
//  fmapp
//
//  Created by runzhiqiu on 16/4/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMPlaceOrderTabbar.h"
#import "XZLargeButton.h"


@interface FMPlaceOrderTabbar()
@property (nonatomic, strong) XZLargeButton * collectButton;
@end



@implementation FMPlaceOrderTabbar



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [HXColor colorWithHexString:@"ccc"];
        [self createUIview];
    }
    return self;
}
-(void)createUIview
{
    CGFloat  littleButtonWidth = self.frame.size.width * 0.5 * 0.3333;
    CGFloat  largeButtonWidth = self.frame.size.width * 0.5 * 0.5;

    XZLargeButton * customerButton = [[XZLargeButton alloc]initWithFrame:CGRectMake(0, 0, littleButtonWidth - 0.5, self.frame.size.height)];
    customerButton.buttonTypecu = XZLargeButtonTypeTabBarBottom;
    customerButton.tag = 550;
    customerButton.backgroundColor = [UIColor colorWithRed:(228.0/255.0) green:(235.0/255.0) blue:(241.0/255.0) alpha:1];
    [customerButton setImage:[UIImage imageNamed:@"客服按钮_07"] forState:UIControlStateNormal];
    customerButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [customerButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [customerButton setTitle:@"客服" forState:UIControlStateNormal];
    [customerButton addTarget:self action:@selector(buttonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [customerButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self addSubview:customerButton];
    
    XZLargeButton * shareButton = [[XZLargeButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(customerButton.frame) + 0.5, 0, littleButtonWidth - 0.5, self.frame.size.height)];
    shareButton.buttonTypecu = XZLargeButtonTypeTabBarBottom;
    shareButton.tag = 551;
    shareButton.backgroundColor = [UIColor colorWithRed:(228.0/255.0) green:(235.0/255.0) blue:(241.0/255.0) alpha:1];
    [shareButton setImage:[UIImage imageNamed:@"分享按钮_07"] forState:UIControlStateNormal];
    shareButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [shareButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [shareButton setTitle:@"分享" forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(buttonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [shareButton.titleLabel setFont:[UIFont systemFontOfSize:12]];

    [self addSubview:shareButton];
    
    XZLargeButton * collectButton = [[XZLargeButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(shareButton.frame) + 0.5, 0, littleButtonWidth, self.frame.size.height)];
    self.collectButton = collectButton;
    collectButton.buttonTypecu = XZLargeButtonTypeTabBarBottom;
    collectButton.tag = 552;
    collectButton.backgroundColor = [UIColor colorWithRed:(228.0/255.0) green:(235.0/255.0) blue:(241.0/255.0) alpha:1];
    [collectButton setImage:[UIImage imageNamed:@"收藏_07"] forState:UIControlStateNormal];
    collectButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [collectButton setImage:[UIImage imageNamed:@"已收藏_07"] forState:UIControlStateSelected];
    [collectButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [collectButton setTitle:@"收藏" forState:UIControlStateNormal];
    [collectButton setTitle:@"已收藏" forState:UIControlStateSelected];
    [collectButton addTarget:self action:@selector(buttonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [collectButton.titleLabel setFont:[UIFont systemFontOfSize:12]];

    [self addSubview:collectButton];
    
    UIButton * addShopList = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(collectButton.frame) + 0.5, 0, largeButtonWidth-0.5, self.bounds.size.height)];
    addShopList.tag = 553;
    addShopList.backgroundColor = [HXColor colorWithHexString:@"#0159d5"];
    if (KProjectScreenWidth == 320) {
        [addShopList.titleLabel setFont:[UIFont systemFontOfSize:14]];
    }else
    {
        [addShopList.titleLabel setFont:[UIFont systemFontOfSize:16]];
    }
    addShopList.titleLabel.textColor = [UIColor whiteColor];
    [addShopList setTitle:@"加入购物车" forState:UIControlStateNormal];
    [addShopList addTarget:self action:@selector(buttonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addShopList];

    
    UIButton * buyShop = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(addShopList.frame), 0, largeButtonWidth, self.bounds.size.height)];
    buyShop.tag = 554;
    buyShop.backgroundColor = [HXColor colorWithHexString:@"#003d90"];
    if (KProjectScreenWidth == 320) {
        [buyShop.titleLabel setFont:[UIFont systemFontOfSize:14]];
    }else
    {
        [buyShop.titleLabel setFont:[UIFont systemFontOfSize:16]];
    }
    
    buyShop.titleLabel.textColor = [UIColor whiteColor];
    [buyShop setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyShop addTarget:self action:@selector(buttonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buyShop];

}


-(void)collectButtonOnClick;
{
    self.collectButton.selected = YES;
}


-(UIView *)createLittleViewWithFrame:(CGRect)frame WithTag:(NSInteger)tag WithBackGroundColor:(UIColor *)backColor WithBackImage:(UIImage *)backImage WithTitle:(NSString *)title
{
    UIView * contentView = [[UIView alloc]initWithFrame:frame];
    contentView.backgroundColor = backColor;
    
    
    CGFloat imageview_width = frame.size.height - 5 - 5 - 5 - 15;
    UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageview_width, imageview_width)];
    imageview.center = CGPointMake(frame.size.width * 0.5, 5 + imageview_width * 0.5);
    imageview.image = backImage;
    [contentView addSubview:imageview];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageview.frame) + 5, frame.size.width, 15)];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    titleLabel.textColor = [UIColor lightGrayColor];
    [contentView addSubview:titleLabel];
    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    button.tag = tag;
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:@selector(buttonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:button];
    return contentView;
    
}
-(void)buttonOnClick:(UIButton *)button
{
    if (self.block) {
        self.block(button);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 
 
 UIView * firstView = [self createLittleViewWithFrame:CGRectMake(0, 0, littleButtonWidth - 0.5, self.frame.size.height) WithTag:550 WithBackGroundColor:[HXColor colorWithHexString:@"787878"] WithBackImage:[UIImage imageNamed:@"客服按钮_07"] WithTitle:@"客服"];
 [self addSubview:firstView];
 
 UIView * secondView = [self createLittleViewWithFrame:CGRectMake(CGRectGetMaxX(firstView.frame), 0, littleButtonWidth - 0.5, self.frame.size.height) WithTag:551 WithBackGroundColor:[HXColor colorWithHexString:@"787878"] WithBackImage:[UIImage imageNamed:@"分享按钮_07"] WithTitle:@"分享" ];
 [self addSubview:secondView];
 
 
 [self addSubview:[self createLittleViewWithFrame:CGRectMake(CGRectGetMaxX(secondView.frame), 0, littleButtonWidth - 0.5, self.frame.size.height) WithTag:550 WithBackGroundColor:[HXColor colorWithHexString:@"787878"] WithBackImage:[UIImage imageNamed:@"收藏_07"] WithTitle:@"收藏"]];
*/

@end
