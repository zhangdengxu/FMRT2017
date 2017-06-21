//
//  FMWebShopDetailDuobaoViewController.h
//  fmapp
//
//  Created by runzhiqiu on 2016/11/1.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMViewController.h"
@class FMWebShopDetailDuobaoViewController,FMShopDetailDuobaoViewController,FMShopDetailAudioModel,FMShopDetailDuobaoVideoModel;
@protocol FMWebShopDetailDuobaoViewControllerDelegate <NSObject>

@optional

-(void)FMWebShopDetailDuobaoViewController:(FMWebShopDetailDuobaoViewController *)shopDetailWebView withTableView:(UIWebView *)webView withFloatY:(CGFloat)contenty;
@end
@interface FMWebShopDetailDuobaoViewController : FMViewController


@property (nonatomic, strong) UIWebView * webView;

@property (nonatomic, weak) id<FMWebShopDetailDuobaoViewControllerDelegate> delegate;
@property (nonatomic,copy) NSString *html;
@property (nonatomic, weak) FMShopDetailDuobaoViewController * fatherController;

@property (nonatomic, strong) FMShopDetailDuobaoVideoModel * videoModel;

@end

@interface FMShopDetailDuobaoVideoModel : NSObject

@property (nonatomic,copy) NSString *videoString;
@property (nonatomic,copy) NSString *videoHeigh;
@property (nonatomic,copy) NSString *videoWidth;
@property (nonatomic,copy) NSString *video_thumb;


-(void)resetVideoWidthAndHeigh;


@end

