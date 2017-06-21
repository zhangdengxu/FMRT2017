//
//  FMSelectShopCollectionReusableView.m
//  fmapp
//
//  Created by runzhiqiu on 16/4/28.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMSelectShopCollectionReusableView.h"
#import "HexColor.h"
@interface FMSelectShopCollectionReusableView()

@property (nonatomic, strong) UIView * grayLine;
@property (nonatomic, weak) UIView * showAddView;
@property (nonatomic, weak) UILabel * countLabel;
@end


@implementation FMSelectShopCollectionReusableView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _grayLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width - 10, 0.5)];
        _grayLine.backgroundColor = [HXColor colorWithHexString:@"#aaaaaa"];
        [self addSubview:_grayLine];
        
        _titleShopLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0.5, self.frame.size.width * 0.5 ,self.frame.size.height - 0.5)];
        _titleShopLabel.textColor = [HXColor colorWithHexString:@"#34353d"];
        _titleShopLabel.font = [UIFont systemFontOfSize:15.0];
        [self addSubview:_titleShopLabel];
        
        
        
        
        
    }
    return self;
}
-(void)setIsShowAddView:(BOOL)isShowAddView
{
 
    if (isShowAddView) {
        [self.showAddView removeFromSuperview];
        UIView * showAddView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width * 0.5, 0.5, self.frame.size.width * 0.5, self.frame.size.height - 0.5)];
        self.showAddView = showAddView;
        [self addSubview:showAddView];
        
        CGFloat buttonItemWidth = 30;
        if (KProjectScreenWidth == 320) {
            buttonItemWidth = 22;
        }
        
        
        UIButton * reduceButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, buttonItemWidth,buttonItemWidth)];
        reduceButton.tag = 1000;
        [reduceButton setTitleColor:[HXColor colorWithHexString:@"#34353d"] forState:UIControlStateNormal];
//        reduceButton.backgroundColor = [HXColor colorWithHexString:@"#e5e9f2"];
//        reduceButton.layer.borderWidth = 0.5;
//        reduceButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        reduceButton.titleLabel.font = [UIFont systemFontOfSize:22];
        [reduceButton setTitle:@"-" forState:UIControlStateNormal];
        [reduceButton addTarget:self action:@selector(operateButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_showAddView addSubview:reduceButton];
        
        
        UIButton * addButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, buttonItemWidth,buttonItemWidth)];
        addButton.tag = 1001;
        addButton.titleLabel.font = [UIFont systemFontOfSize:22];

        [addButton setTitleColor:[HXColor colorWithHexString:@"#34353d"] forState:UIControlStateNormal];
//        addButton.backgroundColor = [HXColor colorWithHexString:@"#e5e9f2"];
//        addButton.layer.borderWidth = 0.5;
//        addButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [addButton setTitle:@"+" forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(operateButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_showAddView addSubview:addButton];
        
        
        UILabel * countLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, buttonItemWidth * 2, buttonItemWidth)];
        self.countLabel = countLabel;
        countLabel.font = [UIFont systemFontOfSize:17];
        countLabel.textAlignment = NSTextAlignmentCenter;
        countLabel.textColor = [HXColor colorWithHexString:@"#34353d"];
        countLabel.text = self.currentCount? self.currentCount : @"1";
        countLabel.center = CGPointMake(_showAddView.bounds.size.width * 0.5, _showAddView.bounds.size.height * 0.5);
        [_showAddView addSubview:countLabel];
        
        reduceButton.center = CGPointMake(_showAddView.bounds.size.width * 0.5 - countLabel.bounds.size.width * 0.5 - reduceButton.bounds.size.width * 0.5 - 12  , _showAddView.bounds.size.height * 0.5);
        addButton.center = CGPointMake(_showAddView.bounds.size.width * 0.5 + countLabel.bounds.size.width * 0.5 + reduceButton.bounds.size.width * 0.5 + 12 , _showAddView.bounds.size.height * 0.5);
        

    }else
    {
        [self.showAddView removeFromSuperview];
    }
    
}

-(void)operateButtonOnClick:(UIButton *)button
{
    if (button.tag == 1000) {
        //减
        NSInteger currentValue = [self.countLabel.text integerValue];
        if (currentValue <= 1) {
            
        }else
        {
            currentValue--;
            self.countLabel.text = [NSString stringWithFormat:@"%zi",currentValue];
        }
    }else
    {
        //加
        NSInteger currentValue = [self.countLabel.text integerValue];
        if (currentValue >= self.maxCount) {
            
        }else
        {
            currentValue++;
            self.countLabel.text = [NSString stringWithFormat:@"%zi",currentValue];
        }

    }
    if (self.selectShopCount) {
        self.selectShopCount([self.countLabel.text integerValue]);
    }
    
}

@end
