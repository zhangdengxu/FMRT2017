//
//  FMShopDetailWebView.h
//  fmapp
//
//  Created by runzhiqiu on 16/4/26.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMViewController.h"
@class FMShopDetailWebView,FMPlaceOrderViewController,FMShopDetailAudioModel,FMShopDetailVideoModel;
@protocol FMShopDetailWebViewDelegate <NSObject>

@optional

-(void)FMShopDetailWebView:(FMShopDetailWebView *)shopDetailWebView withTableView:(UIWebView *)webView withFloatY:(CGFloat)contenty;
@end

@interface FMShopDetailWebView : UIViewController
@property (nonatomic, weak) UIWebView * webView;

@property (nonatomic, weak) id<FMShopDetailWebViewDelegate> delegate;
@property (nonatomic,copy) NSString *html;
@property (nonatomic, weak) FMPlaceOrderViewController * fatherController;
//@property (nonatomic, strong) FMShopDetailAudioModel * audioModel;

//@property (nonatomic,copy) NSString *video;
@property (nonatomic, strong) FMShopDetailVideoModel * videoModel;


-(void)disTroyVideo;

@end

@interface FMShopDetailVideoModel : NSObject

@property (nonatomic,copy) NSString *videoString;
@property (nonatomic,copy) NSString *videoHeigh;
@property (nonatomic,copy) NSString *videoWidth;
@property (nonatomic,copy) NSString *video_thumb;


-(void)resetVideoWidthAndHeigh;



@end


