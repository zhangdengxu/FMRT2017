//
//  FMShopDetailWebView.m
//  fmapp
//
//  Created by runzhiqiu on 16/4/26.
//  Copyright © 2016年 yk. All rights reserved.
//
//#define KAudioViewHeight 240.0

#define KDefaultVideoMargion 8

#import "FMShopDetailWebView.h"

#import "FMPlaceOrderViewController.h"

#import "FMShopOtherModel.h"
#import <MediaPlayer/MediaPlayer.h>

#import "LRLAVPlayerView.h"

@interface FMShopDetailWebView ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIView * contentView;
//用来播放视频的view
@property (nonatomic, weak) LRLAVPlayerView * avplayerView;

@end

@implementation FMShopDetailWebView
#pragma mark - 创建用于播放的View

-(void)createAVPlayerView{
    //固定的实例化方法
    self.avplayerView = [LRLAVPlayerView avplayerViewWithVideoUrlStr:self.videoModel.videoString andInitialHeight:[self.videoModel.videoHeigh floatValue] WithWidth:[self.videoModel.videoHeigh floatValue] andSuperView:self.contentView withDefaultVideoUrl:self.videoModel.video_thumb];
    [self.contentView addSubview:self.avplayerView];
    __weak __typeof(&*self)weakSelf = self;
    //我的播放器依赖 Masonry 第三方库
    
    NSString * version = [[UIDevice currentDevice] systemVersion];
    
    
    if ([version floatValue] >= 10 ) {
        
        
        
        //我的播放器依赖 Masonry 第三方库
        [self.avplayerView setPositionWithPortraitBlock:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView);
            make.left.equalTo(weakSelf.contentView);
            make.right.equalTo(weakSelf.contentView);
            //添加竖屏时的限制, 这条也是固定的, 因为: _videoHeight 是float* 类型, 我可以通过它, 动态改视频播放器的高度;
            make.height.equalTo(@(*(weakSelf.avplayerView->_videoHeight)));
        } andLandscapeBlock:^(MASConstraintMaker *make) {
            
            
            make.width.equalTo(@(SCREEN_HEIGHT));
            make.height.equalTo(@(SCREEN_WIDTH));
            make.left.equalTo(Window.mas_left).offset(-(SCREEN_HEIGHT - SCREEN_WIDTH) * 0.5);
            make.top.equalTo(Window.mas_top).offset((SCREEN_HEIGHT - SCREEN_WIDTH) * 0.5);
            
            
        }];
        
        
        
    }else if([version floatValue] >= 7 && [version floatValue] < 8){
        
        
        //我的播放器依赖 Masonry 第三方库
        [self.avplayerView setPositionWithPortraitBlock:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView);
            make.left.equalTo(weakSelf.contentView);
            make.right.equalTo(weakSelf.contentView);
            //添加竖屏时的限制, 这条也是固定的, 因为: _videoHeight 是float* 类型, 我可以通过它, 动态改视频播放器的高度;
            make.height.equalTo(@(*(weakSelf.avplayerView->_videoHeight)));
        } andLandscapeBlock:^(MASConstraintMaker *make) {
            
            
            make.width.equalTo(@(SCREEN_HEIGHT));
            make.height.equalTo(@(SCREEN_WIDTH));
            make.left.equalTo(Window.mas_left);
            make.top.equalTo(Window.mas_top);
            
            
        }];
        
        
    }else
    {
        
        //我的播放器依赖 Masonry 第三方库
        [self.avplayerView setPositionWithPortraitBlock:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView);
            make.left.equalTo(weakSelf.contentView);
            make.right.equalTo(weakSelf.contentView);
            //添加竖屏时的限制, 这条也是固定的, 因为: _videoHeight 是float* 类型, 我可以通过它, 动态改视频播放器的高度;
            make.height.equalTo(@(*(weakSelf.avplayerView->_videoHeight)));
        } andLandscapeBlock:^(MASConstraintMaker *make) {
            make.width.equalTo(@(SCREEN_HEIGHT));
            make.height.equalTo(@(SCREEN_WIDTH));
            make.center.equalTo(Window);
        }];
    }
     
     
    [self.avplayerView playOrPause];
    
}
-(void)disTroyVideo;
{
    
    _avplayerView.delegate = nil;
    _webView.scrollView.delegate = nil;
    
    _delegate = nil;
    _webView.delegate = nil;

    [_avplayerView destoryAVPlayer];
    [_avplayerView removeFromSuperview];

    _avplayerView = nil;
    
    [_contentView removeFromSuperview];
    _contentView = nil;
    [_webView removeFromSuperview];
    _webView = nil;
    

}

-(void)dealloc
{
    
    _avplayerView.delegate = nil;

    [_avplayerView destoryAVPlayer];
    [_avplayerView removeFromSuperview];
    _avplayerView = nil;
//    NSLog(@"delloc -- FMShopDetailWebView");

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.avplayerView.isPlaying) {
        [self.avplayerView playOrPause];
    }
    
//    NSLog(@"delloc -- FMShopDetailWebView   ---viewWillDisappear");

}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:(230.0/255) green:(234.0/255) blue:(241.0/255) alpha:1];
//    
    UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight - 49 - 20 - 35 - 49)];
    webView.backgroundColor = [UIColor colorWithRed:(230.0/255) green:(234.0/255) blue:(241.0/255) alpha:1];
    webView.scrollView.backgroundColor = [UIColor colorWithRed:(230.0/255) green:(234.0/255) blue:(241.0/255) alpha:1];
    webView.scrollView.delegate = self;
    [webView.scrollView addSubview:[self contentShowTitleView]];
    if (self.videoModel.videoString.length > 0) {
        
       UIView * linshiContent = [[UIView alloc]initWithFrame:CGRectMake(0, -([self.videoModel.videoHeigh floatValue]), KProjectScreenWidth, [self.videoModel.videoHeigh floatValue])];
        linshiContent.backgroundColor = [UIColor whiteColor];
        self.contentView = linshiContent;
        
        webView.scrollView.contentInset = UIEdgeInsetsMake(([self.videoModel.videoHeigh floatValue] + KDefaultVideoMargion), 0, 0, 0);
        [webView.scrollView addSubview:self.contentView];
        [self createAVPlayerView];
    }
   
    self.webView = webView;
    webView.scalesPageToFit = YES;
    self.view=webView;
    
    [self createUICollectionView];
    
    
    // Do any additional setup after loading the view.
}

-(void)setHtml:(NSString *)html
{
    _html = [NSString stringWithFormat:@"%@",html];
    [self.webView loadHTMLString:_html baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)createUICollectionView
{
    if (self.fatherController.isLetSonViewScroll) {
        self.webView.scrollView.scrollEnabled = YES;
    }else
    {
        self.webView.scrollView.scrollEnabled = NO;
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
{
    
    if (scrollView.contentOffset.y <= -([self.videoModel.videoHeigh floatValue] + KDefaultVideoMargion)) {
        CGFloat contentY = (fabs(scrollView.contentOffset.y) - ([self.videoModel.videoHeigh floatValue] + KDefaultVideoMargion));
        if (contentY > 20) {
            if ([self.delegate respondsToSelector:@selector(FMShopDetailWebView:withTableView:withFloatY:)]) {
                [self.delegate FMShopDetailWebView:self withTableView:self.webView withFloatY:-contentY];
            }
        }
    }
}

-(UIView *)contentShowTitleView
{
    UIView * contentShow = [[UIView alloc]initWithFrame:CGRectMake(0, -([self.videoModel.videoHeigh floatValue] + KDefaultVideoMargion + 50), KProjectScreenWidth, 50)];
    contentShow.backgroundColor = [UIColor clearColor];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = @"返回上部";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor grayColor];
    [contentShow addSubview:titleLabel];
    titleLabel.center = CGPointMake(KProjectScreenWidth * 0.5, 25);
    return contentShow;
}

#pragma mark - 关闭设备自动旋转, 然后手动监测设备旋转方向来旋转avplayerView
-(BOOL)shouldAutorotate{
    return NO;
}


@end

@implementation FMShopDetailVideoModel


-(void)resetVideoWidthAndHeigh;
{
     if (self.videoString.length > 2) {
        float radio = [self.videoWidth floatValue] / [self.videoHeigh floatValue];
        if (radio >= 1) {
            self.videoWidth = [NSString stringWithFormat:@"%f",KProjectScreenWidth];
            self.videoHeigh = [NSString stringWithFormat:@"%f",KProjectScreenWidth / radio];
        }else
        {
            self.videoHeigh = [NSString stringWithFormat:@"%f",KProjectScreenWidth];
            self.videoWidth = [NSString stringWithFormat:@"%f",KProjectScreenWidth * radio];
        }
     }else
     {
         self.videoWidth = @"0";
         self.videoHeigh = @"0";
     }
}


@end
