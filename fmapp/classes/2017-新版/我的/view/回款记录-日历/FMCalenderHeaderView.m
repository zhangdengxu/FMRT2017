//
//  FMCalenderHeaderView.m
//  fmapp
//
//  Created by runzhiqiu on 2017/2/27.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMCalenderHeaderView.h"

@interface FMCalenderHeaderView ()

@property (nonatomic, strong) UIButton * middleButton;
@property (nonatomic, strong) UIButton * leftButton;
@property (nonatomic, strong) UIButton * rightButton;


@end

@implementation FMCalenderHeaderView


-(void)setCurrentString:(NSString *)currentString
{
    _currentString = currentString;
    
    [self.middleButton setTitle:currentString forState:UIControlStateNormal];
    //[self remakeMassory];
    
}
-(void)remakeMassory
{
    [self.middleButton remakeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        
    }];
    
    
    [self.leftButton remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(20);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.rightButton remakeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-20);
        make.centerY.equalTo(self.mas_centerY);
        
    }];

}

-(instancetype)initWithFrame:(CGRect)frame
{
   
    self =  [super initWithFrame:frame];
    if (self) {
        
        [self addMassory];
        
    }
    return self;
    
}
-(void)addMassory
{
    
    [self.leftButton makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(20);
        make.centerY.equalTo(self.mas_centerY);

    }];
    
    [self.rightButton makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.mas_right).offset(-20);
        make.centerY.equalTo(self.mas_centerY);

    }];
    
    [self middleButton];
    /*
    [self.middleButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.leftButton.mas_left);
        make.right.equalTo(self.rightButton.mas_right);
        
    }];
     */
    

}
-(UIButton *)middleButton
{
    if (!_middleButton) {
        //添加日期的点击事件
        UIButton * titleMidele = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth - 150, self.frame.size.height)];
        titleMidele.center = CGPointMake(KProjectScreenWidth * 0.5, self.frame.size.height * 0.5);
        [titleMidele setBackgroundColor:[UIColor clearColor]];
        [titleMidele setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        titleMidele.tag = 1000;
        _middleButton = titleMidele;
        [titleMidele addTarget:self action:@selector(rightImageViewButtonButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:titleMidele];
    }
    return _middleButton;
}

-(UIButton *)leftButton
{
    if (!_leftButton) {
        //添加日期的点击事件
        UIButton * titleMidele = [[UIButton alloc]init];
        [titleMidele setBackgroundColor:[UIColor clearColor]];
        titleMidele.tag = 1001;
        _leftButton = titleMidele;
        
        [titleMidele setImage:[UIImage imageNamed:@"我的推荐日历_左箭头_1702"] forState:UIControlStateNormal];
        [titleMidele addTarget:self action:@selector(rightImageViewButtonButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:titleMidele];
    }
    return _leftButton;
}

-(UIButton *)rightButton
{
    if (!_rightButton) {
        //添加日期的点击事件
        UIButton * titleMidele = [[UIButton alloc]init];
        [titleMidele setBackgroundColor:[UIColor clearColor]];
        titleMidele.tag = 1002;
        _rightButton = titleMidele;
        [titleMidele setImage:[UIImage imageNamed:@"我的推荐日历_右箭头_1702"] forState:UIControlStateNormal];

        [titleMidele addTarget:self action:@selector(rightImageViewButtonButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:titleMidele];
    }
    return _rightButton;
}

- (void)rightImageViewButtonButtonOnClick:(UIButton *)button
{
    switch (button.tag) {
        case 1000:
        {
            if (self.buttonBlock) {
                self.buttonBlock(1);
            }
        }
            break;
        case 1001:
        {
            if (self.buttonBlock) {
                self.buttonBlock(2);
            }
        }
            break;
        case 1002:
        {
            if (self.buttonBlock) {
                self.buttonBlock(3);
            }
        }
            break;
            
        default:
            break;
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
