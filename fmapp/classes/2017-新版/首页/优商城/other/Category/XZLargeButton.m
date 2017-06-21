//
//  XZLargeButton.m
//  fmapp
//
//  Created by runzhiqiu on 16/4/18.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "XZLargeButton.h"
#import "UIView+Extension.h"
@implementation XZLargeButton

- (void)layoutSubviews{
    [super layoutSubviews];
    switch (self.buttonTypecu) {
        case XZLargeButtonTypeNormal:
        {
            // 1.调整图片的位置和尺寸
            CGRect imgFrame = self.imageView.frame;
            imgFrame.origin.y = 10;
            imgFrame.origin.x = self.frame.size.width * 0.2;
            imgFrame.size.width = self.frame.size.width * 0.6;
            imgFrame.size.height = self.frame.size.height * 0.6;
            self.imageView.frame = imgFrame;
            //    self.imageView.backgroundColor = [UIColor redColor];
            
            // 2.调整下面文字的位置和尺寸
            self.titleLabel.x = 0;
            self.titleLabel.y = self.imageView.frame.size.height+12;
            self.titleLabel.width = self.frame.size.width;
            self.titleLabel.height = self.frame.size.height - self.titleLabel.y;
        }
            break;
        case XZLargeButtonTypeGoodShopMenu:
        {

            if (KProjectScreenWidth == 320) {
                // 1.调整图片的位置和尺寸
                CGRect imgFrame = self.imageView.frame;
                imgFrame.origin.y = 2;
                imgFrame.origin.x = self.frame.size.width * 0.18;
                imgFrame.size.width = self.frame.size.width * 0.64;
                imgFrame.size.height = self.frame.size.height * 0.64;
                self.imageView.frame = imgFrame;
 
                
                // 2.调整下面文字的位置和尺寸
                self.titleLabel.x = 0;
                self.titleLabel.y = self.frame.size.height * 0.64 + 5;
                self.titleLabel.width = self.frame.size.width;
                self.titleLabel.height = self.frame.size.height - self.titleLabel.frame.origin.y;
                
                
            }else
            {
                // 1.调整图片的位置和尺寸

                
                CGRect imgFrame = self.imageView.frame;
                imgFrame.origin.y = 2;
                imgFrame.origin.x = self.frame.size.width * 0.15;
                imgFrame.size.width = self.frame.size.width * 0.7;
                imgFrame.size.height = self.frame.size.height * 0.7;
                self.imageView.frame = imgFrame;
                
                
                // 2.调整下面文字的位置和尺寸

                
                self.titleLabel.x = 0;
                self.titleLabel.y = self.frame.size.height * 0.7 + 5;
                self.titleLabel.width = self.frame.size.width;
                self.titleLabel.height = self.frame.size.height - self.titleLabel.y;
            }
           
        }
            break;
        case XZLargeButtonTypeTabBarBottom:
        {
            // 1.调整图片的位置和尺寸
            CGRect imgFrame = self.imageView.frame;
            imgFrame.origin.y = 7;
            imgFrame.origin.x = self.frame.size.width * 0.35;
            imgFrame.size.width = self.frame.size.width * 0.3;
            imgFrame.size.height = self.frame.size.width * 0.3;
            self.imageView.frame = imgFrame;
            //    self.imageView.backgroundColor = [UIColor redColor];
            
            // 2.调整下面文字的位置和尺寸
            self.titleLabel.x = 0;
            self.titleLabel.y = self.imageView.frame.size.height + 3;
            self.titleLabel.width = self.frame.size.width;
            self.titleLabel.height = self.frame.size.height - self.titleLabel.y;
            
        }
            break;
        case XZLargeButtonTypeTabBar:
        {
            // 1.调整图片的位置和尺寸
            CGRect imgFrame = self.imageView.frame;
            imgFrame.origin.y = 5;
            imgFrame.origin.x = self.frame.size.width * 0.35;
            imgFrame.size.width = self.frame.size.width * 0.3;
            imgFrame.size.height = self.frame.size.width * 0.3;
            self.imageView.frame = imgFrame;
//            self.imageView.backgroundColor = [UIColor redColor];
            
            // 2.调整下面文字的位置和尺寸
            self.titleLabel.x = 0;
            self.titleLabel.y = self.imageView.frame.size.height + 5;
            self.titleLabel.width = self.frame.size.width;
            self.titleLabel.height = self.frame.size.height - self.titleLabel.y;
//            self.titleLabel.backgroundColor = [UIColor greenColor];
            
        }
            break;
        case XZLargeButtonTypeActivityTabBar:
        {
            // 1.调整图片的位置和尺寸
            CGRect imgFrame = self.imageView.frame;
            imgFrame.origin.y = 8;
            imgFrame.origin.x = self.frame.size.width * 0.4;
            imgFrame.size.width = self.frame.size.width * 0.15;
            imgFrame.size.height = self.frame.size.width * 0.15;
            self.imageView.frame = imgFrame;
//            self.imageView.backgroundColor = [UIColor redColor];
            
            // 2.调整下面文字的位置和尺寸
            self.titleLabel.x = 0;
            self.titleLabel.y = self.imageView.frame.size.height + 5;
            self.titleLabel.width = self.frame.size.width;
            self.titleLabel.height = self.frame.size.height - self.titleLabel.y;
//            self.titleLabel.backgroundColor = [UIColor greenColor];
        }
            break;
        default:
            break;
    }
}

@end
