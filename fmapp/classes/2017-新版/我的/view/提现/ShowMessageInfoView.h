//
//  ShowMessageInfoView.h
//  fmapp
//
//  Created by runzhiqiu on 15/12/31.
//  Copyright © 2015年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    ShowMessageInfoViewLocationUp,
    ShowMessageInfoViewLocationAbove

}ShowMessageInfoViewLocation;

@interface ShowMessageInfoView : UIView
@property (nonatomic,assign)CGFloat font;




+ (instancetype)showMessageinfoViewOnThisViewLocation:(ShowMessageInfoViewLocation) location;

-(void)showMessageInfoViewWithString:(NSString *)contentString showView:(UIView *)fatherView ;

-(void)showMessageInfoViewWithString:(NSString *)contentString showString:(NSString *)showString showView:(UIView *)fatherView;
-(void)showMessageInfoViewWilldealloc;

@end
