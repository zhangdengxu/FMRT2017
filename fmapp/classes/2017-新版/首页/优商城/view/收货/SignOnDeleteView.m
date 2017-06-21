//
//  SignOnDeleteView.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/4/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "SignOnDeleteView.h"

@interface SignOnDeleteView()

@property (nonatomic, weak) UIView * backgroundView;

@end

@implementation SignOnDeleteView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setFrame:CGRectMake(0, 0, 330, 200)];
        
    }
    return self;
}

-(void)showSignViewWithTitle:(NSString *)title detail:(NSString *)detailContent{
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    UIView * backgroundView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.6;
    self.backgroundView = backgroundView;
    [window addSubview:backgroundView];
    [window bringSubviewToFront:backgroundView];
    CGRect rect = self.frame;
    
    rect.size.width = rect.size.width * (KProjectScreenWidth / 375.0);
    
    self.frame = rect;
    self.center = CGPointMake(KProjectScreenWidth * 0.5, KProjectScreenHeight * 0.5);
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, self.frame.size.width-15, 40)];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor colorWithRed:255/255.0f green:102/255.0f blue:51/255.0f alpha:1];
    if (KProjectScreenWidth == 320) {
         titleLabel.font = [UIFont systemFontOfSize:17];
    }else {
         titleLabel.font = [UIFont systemFontOfSize:20];
    }
    [self addSubview:titleLabel];
    
    
    
    UILabel *titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 70, self.frame.size.width-30, self.frame.size.height-60-70)];
    titleLabel1.text = detailContent;
    titleLabel1.numberOfLines = 0;
    if (KProjectScreenWidth == 320) {
        titleLabel1.font = [UIFont systemFontOfSize:16];
    }else {
        titleLabel1.font = [UIFont systemFontOfSize:18];
    }
    [self addSubview:titleLabel1];
    
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, self.frame.size.width, 3)];
    lineView.backgroundColor = [UIColor colorWithRed:252/255.0f green:87/255.0f blue:0/255.0f alpha:1];
    [self addSubview:lineView];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-51, self.frame.size.width, 1)];
    lineView1.backgroundColor = [UIColor colorWithRed:213/255.0f green:213/255.0f blue:213/255.0f alpha:1];
    [self addSubview:lineView1];
    
    for (int i = 0; i<2; i++) {
            UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [bottomButton setBackgroundColor:[UIColor clearColor]];
        if (i==0) {
            [bottomButton setTitle:self.chexiao?@"不撤销":@"取消" forState:UIControlStateNormal];
            
            bottomButton.tag = 10000;
        }else{
            [bottomButton setTitle:@"确定" forState:UIControlStateNormal];
            bottomButton.tag = 10001;

        }
        if (KProjectScreenWidth == 320) {
             bottomButton.titleLabel.font = [UIFont systemFontOfSize:16];
        }else {
             bottomButton.titleLabel.font = [UIFont systemFontOfSize:19];
        }
            [bottomButton setTitleColor:[UIColor colorWithRed:.25f green:.25f blue:.25f alpha:1] forState:UIControlStateNormal];
            [bottomButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [bottomButton setBackgroundImage:[self createImageWithColor:[UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1]] forState:UIControlStateHighlighted];
            [bottomButton setFrame:CGRectMake(self.frame.size.width/2*i, self.frame.size.height-50, self.frame.size.width/2, 50)];
            [self addSubview:bottomButton];

    }
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-0.5, self.frame.size.height-50, 1, 50)];
    lineView2.backgroundColor = [UIColor colorWithRed:213/255.0f green:213/255.0f blue:213/255.0f alpha:1];
    [self addSubview:lineView2];
    
    
    [self setAlpha:1.0f ];
    [self setUserInteractionEnabled:YES];
    [window addSubview:self];
    [window bringSubviewToFront:self];
    
    
}
/**
 *  只有上面和俩个按钮,没有中间说明
 */
-(void)showSignViewWithTitle:(NSString *)title{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    UIView * backgroundView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.6;
    self.backgroundView = backgroundView;
    [window addSubview:backgroundView];
    [window bringSubviewToFront:backgroundView];
    CGRect rect = self.frame;
    
    rect.size.width = rect.size.width * (KProjectScreenWidth / 375.0);
    rect.size.height = 110;
    self.frame = rect;
    self.center = CGPointMake(KProjectScreenWidth * 0.5, KProjectScreenHeight * 0.5);
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, self.frame.size.width-15, 40)];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor colorWithRed:255/255.0f green:102/255.0f blue:51/255.0f alpha:1];
    if (KProjectScreenWidth == 320) {
        titleLabel.font = [UIFont systemFontOfSize:17];
    }else {
        titleLabel.font = [UIFont systemFontOfSize:20];
    }
    [self addSubview:titleLabel];
    
    
    
//    UILabel *titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 70, self.frame.size.width-15, self.frame.size.height-60-70)];
//    titleLabel1.text = detailContent;
//    if (KProjectScreenWidth == 320) {
//        titleLabel1.font = [UIFont systemFontOfSize:16];
//    }else {
//        titleLabel1.font = [UIFont systemFontOfSize:18];
//    }
//    [self addSubview:titleLabel1];
    
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 59, self.frame.size.width, 3)];
    lineView.backgroundColor = [UIColor colorWithRed:252/255.0f green:87/255.0f blue:0/255.0f alpha:1];
    [self addSubview:lineView];
    
//    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-51, self.frame.size.width, 1)];
//    lineView1.backgroundColor = [UIColor colorWithRed:213/255.0f green:213/255.0f blue:213/255.0f alpha:1];
//    [self addSubview:lineView1];
    
    for (int i = 0; i<2; i++) {
        UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [bottomButton setBackgroundColor:[UIColor clearColor]];
        if (i==0) {
            [bottomButton setTitle:@"取消" forState:UIControlStateNormal];
            
            bottomButton.tag = 10000;
        }else{
            [bottomButton setTitle:@"确定" forState:UIControlStateNormal];
            bottomButton.tag = 10001;
            
        }
        if (KProjectScreenWidth == 320) {
            bottomButton.titleLabel.font = [UIFont systemFontOfSize:17];
        }else {
            bottomButton.titleLabel.font = [UIFont systemFontOfSize:20];
        }
        [bottomButton setHighlighted:NO];
        [bottomButton setTitleColor:[UIColor colorWithRed:.25f green:.25f blue:.25f alpha:1] forState:UIControlStateNormal];
        [bottomButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [bottomButton setBackgroundImage:[self createImageWithColor:[UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1]] forState:UIControlStateHighlighted];
        [bottomButton setFrame:CGRectMake(self.frame.size.width/2*i, self.frame.size.height-49, self.frame.size.width/2, 49)];
        [self addSubview:bottomButton];
        
    }
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-0.5, self.frame.size.height-47, 1, 47)];
    lineView2.backgroundColor = [UIColor colorWithRed:213/255.0f green:213/255.0f blue:213/255.0f alpha:1];
    [self addSubview:lineView2];
    
    
    [self setAlpha:1.0f ];
    [self setUserInteractionEnabled:YES];
    [window addSubview:self];
    [window bringSubviewToFront:self];

}
/** 可以修改 title 颜色和 割线line 颜色*/
-(void)showSignViewWithTitle:(NSString *)title withTitleColor:(NSString *)titleColor withLineColor:(NSString *)lineColor{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    UIView * backgroundView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.6;
    self.backgroundView = backgroundView;
    [window addSubview:backgroundView];
    [window bringSubviewToFront:backgroundView];
    CGRect rect = self.frame;
    
    rect.size.width = rect.size.width * (KProjectScreenWidth / 375.0);
    rect.size.height = 110;
    self.frame = rect;
    self.center = CGPointMake(KProjectScreenWidth * 0.5, KProjectScreenHeight * 0.5);
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, self.frame.size.width-15, 40)];
    titleLabel.text = title;
    titleLabel.textColor = [HXColor colorWithHexString:titleColor];
    if (KProjectScreenWidth == 320) {
        titleLabel.font = [UIFont systemFontOfSize:17];
    }else {
        titleLabel.font = [UIFont systemFontOfSize:20];
    }
    [self addSubview:titleLabel];
    
    
    
    //    UILabel *titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 70, self.frame.size.width-15, self.frame.size.height-60-70)];
    //    titleLabel1.text = detailContent;
    //    if (KProjectScreenWidth == 320) {
    //        titleLabel1.font = [UIFont systemFontOfSize:16];
    //    }else {
    //        titleLabel1.font = [UIFont systemFontOfSize:18];
    //    }
    //    [self addSubview:titleLabel1];
    
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, self.frame.size.width, 1)];
    lineView.backgroundColor = [HXColor colorWithHexString:lineColor];
    [self addSubview:lineView];
    
    //    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-51, self.frame.size.width, 1)];
    //    lineView1.backgroundColor = [UIColor colorWithRed:213/255.0f green:213/255.0f blue:213/255.0f alpha:1];
    //    [self addSubview:lineView1];
    
    for (int i = 0; i<2; i++) {
        UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [bottomButton setBackgroundColor:[UIColor clearColor]];
        if (i==0) {
            [bottomButton setTitle:@"取消" forState:UIControlStateNormal];
            
            bottomButton.tag = 10000;
        }else{
            [bottomButton setTitle:@"确定" forState:UIControlStateNormal];
            bottomButton.tag = 10001;
            
        }
        if (KProjectScreenWidth == 320) {
            bottomButton.titleLabel.font = [UIFont systemFontOfSize:17];
        }else {
            bottomButton.titleLabel.font = [UIFont systemFontOfSize:20];
        }
        [bottomButton setTitleColor:[UIColor colorWithRed:.25f green:.25f blue:.25f alpha:1] forState:UIControlStateNormal];
        [bottomButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [bottomButton setBackgroundImage:[self createImageWithColor:[UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1]] forState:UIControlStateHighlighted];
        [bottomButton setFrame:CGRectMake(self.frame.size.width/2*i, self.frame.size.height-50, self.frame.size.width/2, 50)];
        [self addSubview:bottomButton];
        
    }
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-0.5, self.frame.size.height-47, 1, 47)];
    lineView2.backgroundColor = [UIColor colorWithRed:213/255.0f green:213/255.0f blue:213/255.0f alpha:1];
    [self addSubview:lineView2];
    
    
    [self setAlpha:1.0f ];
    [self setUserInteractionEnabled:YES];
    [window addSubview:self];
    [window bringSubviewToFront:self];
    
}

// 没有取消、确定按钮
- (void)showSignViewNoButtonWithTitle:(NSString *)title detail:(NSString *)detailContent {
    //
    [self setFrame:CGRectMake(0, 0, 330, 150)];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    UIView * backgroundView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.6;
    self.backgroundView = backgroundView;
    [window addSubview:backgroundView];
    [window bringSubviewToFront:backgroundView];
    CGRect rect = self.frame;
    
    rect.size.width = rect.size.width * (KProjectScreenWidth / 375.0);
    
    self.frame = rect;
    self.center = CGPointMake(KProjectScreenWidth * 0.5, KProjectScreenHeight * 0.5);
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, self.frame.size.width-15, 40)];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor colorWithRed:255/255.0f green:102/255.0f blue:51/255.0f alpha:1];
    if (KProjectScreenWidth == 320) {
        titleLabel.font = [UIFont systemFontOfSize:17];
    }else {
        titleLabel.font = [UIFont systemFontOfSize:20];
    }
    [self addSubview:titleLabel];
    
    
    UILabel *titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 90, self.frame.size.width-15, self.frame.size.height-60-70)];
    titleLabel1.text = detailContent;
    if (KProjectScreenWidth == 320) {
        titleLabel1.font = [UIFont systemFontOfSize:16];
    }else {
        titleLabel1.font = [UIFont systemFontOfSize:18];
    }
    [self addSubview:titleLabel1];
    
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, self.frame.size.width, 3)];
    lineView.backgroundColor = [UIColor colorWithRed:252/255.0f green:87/255.0f blue:0/255.0f alpha:1];
    [self addSubview:lineView];
    
    [self setAlpha:1.0f ];
    [self setUserInteractionEnabled:YES];
    [window addSubview:self];
    [window bringSubviewToFront:self];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.backgroundView removeFromSuperview];
    [self removeFromSuperview];
}

-(void)hiddenSignView{
    
    [self endEditing:YES];
    [self.backgroundView removeFromSuperview];
    [self removeFromSuperview];
}

-(void)cancelAction:(UIButton *)btn{
    
    [self endEditing:YES];
//    [self.backgroundView removeFromSuperview];
//    [self removeFromSuperview];
//
    self.hidden = YES;
    self.backgroundView.hidden = YES;
    if (btn.tag == 10001) {
        if (self.sureBlock) {
            self.sureBlock(btn);
            [self endEditing:YES];
//            [self.backgroundView removeFromSuperview];
//            [self removeFromSuperview];
            self.hidden = YES;
            self.backgroundView.hidden = YES;
            
        }
        if (self.deleteBlock) {
            self.deleteBlock(btn);
            [self endEditing:YES];
            self.hidden = YES;
            self.backgroundView.hidden = YES;
            
        }
        
    }
}

-(UIImage*)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


@end
