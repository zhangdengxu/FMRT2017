//
//  ChangeNameView.h
//  fmapp
//
//  Created by 秦秦文龙 on 16/1/28.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChangeNameView;
@protocol ChangeViewDelegate<NSObject>

@optional
-(void)ChangeNameViewDidChange:(ChangeNameView *)changeView WithContentString:(NSString *)text;
@end

@interface ChangeNameView : UIView
@property(nonatomic,assign)id<ChangeViewDelegate>delegate;
@property(nonatomic,strong)NSString *SweetyName;

-(void)showSignView;
-(void)hiddenSignView;

@end
