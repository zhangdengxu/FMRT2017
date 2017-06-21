//
//  XZRongMiSchoolHeader.m
//  fmapp
//
//  Created by admin on 17/2/27.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "XZRongMiSchoolHeader.h"
#import "XZRongMiSchoolModel.h"
// 引入视频播放器头文件
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVPlayerItem.h>
#import <AVFoundation/AVPlayerLayer.h>
#import <AVFoundation/AVAsset.h>
//#import <AVFoundation/AVAudioSession.h>

@interface XZRongMiSchoolHeader ()
{
    // 用来控制上下菜单view隐藏的timer
    NSTimer * _hiddenTimer;
}
// 按钮
@property (nonatomic, strong) UIImageView *imgBegin;
// 图片     
@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UIView *viewPlay;
// 播放
@property (nonatomic, strong) UIButton *btnPlay;
// 全屏
@property (nonatomic, strong) UIButton *btnFullScreen;
// 总时间
@property (nonatomic, strong) UILabel *labelTotalTime;
// 当前时间
@property (nonatomic, strong) UILabel *labelProgress;
// 进度
@property (nonatomic, strong) UISlider *progress;
//// 视频的缓冲进度条
//@property (nonatomic, strong) UIProgressView *videoProgressView;

// 组件
@property (nonatomic, strong) AVPlayerItem *item;

// 播放器
@property (nonatomic, strong) AVPlayer *player;

// 当前时间
@property (nonatomic, assign) float currentTime;

// 总时间
@property (nonatomic, assign) float totalTime;

// 视频播放时间观察者
@property (strong, nonatomic) id timeObserver;

@property (strong, nonatomic) AVPlayerLayer *playerlayer;

@property (nonatomic, strong) UIWindow *window;

// 视频是否正在播放
@property (nonatomic, assign) BOOL isPlayVideo;

// 程序从后台进入前台
@property (nonatomic, assign) BOOL isBecomeActive;

// 视频是否已经播放完毕
@property (nonatomic, assign) BOOL isComplete;

// 轻拍出现播放/暂停栏
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, strong) NSString *videoUrl;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@end

@implementation XZRongMiSchoolHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // XZBackGroundColor
        self.backgroundColor = [UIColor blackColor];
        self.window = [UIApplication sharedApplication].keyWindow;
        // 创建图片
        [self createBgImageView];
        
        // 创建播放view
        [self createPlayVideoView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appwillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];

    }
    return self;
}

#pragma mark ---- 创建player
- (void)setUpRongMiSchoolHeader:(NSString *)videoUrl {
    
    // =====================
    if (!videoUrl) {
        return;
    }
    
    // 2.准备player
    self.player = [AVPlayer playerWithPlayerItem:self.item];

    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    // 3.layer
    AVPlayerLayer *playerlayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerlayer = playerlayer;
    
    // 4.layer fram
    playerlayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    playerlayer.zPosition = 2;
    //视频填充模式
    playerlayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    // 5.subLayer
    [self.layer addSublayer:self.playerlayer];
    
//    // 6.播放
//    [self.player play];
    
//    NSLog(@"%s",__func__);
}

#pragma mark ---- 创建最开始的图片
- (void)createBgImageView {
    UIImageView *imgView = [[UIImageView alloc] init];
    [self addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    imgView.userInteractionEnabled = YES;
    self.imgView = imgView;

    UIImageView *imgBegin = [[UIImageView alloc] init];
    [imgView addSubview:imgBegin];
    [imgBegin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imgView);
        make.centerY.equalTo(imgView);
        make.size.equalTo(@(110 * 0.5));
    }];
    imgBegin.image = [UIImage imageNamed:@"融米学堂_播放-icon_1702"];
    imgBegin.userInteractionEnabled = YES;
    self.imgBegin = imgBegin;

    // 第一次播放
    UIButton *cover = [UIButton buttonWithType:UIButtonTypeCustom];
    [imgBegin addSubview:cover];
    [cover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(imgBegin);
    }];
    [cover addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    cover.tag = 402;
}

#pragma mark ---- 创建播放时的view
- (void)createPlayVideoView {
    UIView *viewPlay = [[UIView alloc] init];
    [self addSubview:viewPlay];
    [viewPlay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(@50);
    }];
    viewPlay.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];;
    self.viewPlay = viewPlay;
    viewPlay.hidden = YES;
    viewPlay.layer.zPosition = 3;
    
    // 播放
    UIButton *btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewPlay addSubview:btnPlay];
    [btnPlay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewPlay).offset(10);
        make.centerY.equalTo(viewPlay);
        make.size.equalTo(@(64 * 0.6));
    }];
    self.btnPlay = btnPlay;
    btnPlay.tag = 403;
    [btnPlay addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    btnPlay.layer.zPosition = 4;
    [btnPlay setBackgroundImage:[UIImage imageNamed:@"融米学堂_打开小icon__1702"] forState:UIControlStateNormal];
    // 选中是关闭
    [btnPlay setBackgroundImage:[UIImage imageNamed:@"融米学堂_关闭小icon__1702"] forState:UIControlStateSelected];
    
    // 全屏
    UIButton *btnFullScreen = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewPlay addSubview:btnFullScreen];
    [btnFullScreen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewPlay).offset(-10);
        make.centerY.equalTo(viewPlay);
        make.size.equalTo(@(36 * 0.8));
    }];
    [btnFullScreen setBackgroundImage:[UIImage imageNamed:@"融米学堂_全屏__1702"] forState:UIControlStateNormal];
    self.btnFullScreen = btnFullScreen;
    btnFullScreen.tag = 404;
    [btnFullScreen addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    btnFullScreen.layer.zPosition = 4;
    
    // 进度
    UISlider *progress = [[UISlider alloc] init];
    [viewPlay addSubview:progress];
    [progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btnPlay.mas_right).offset(10);
        make.right.equalTo(btnFullScreen.mas_left).offset(-10);
        make.centerY.equalTo(viewPlay).offset(-8);
    }];
    self.progress = progress;
    progress.value = 0.0f;
    progress.layer.masksToBounds = YES;
    progress.layer.cornerRadius = 3.0f;
    progress.layer.zPosition = 4;
    [progress addTarget:self action:@selector(userDragSliderChanged:) forControlEvents:UIControlEventValueChanged];
    [progress setThumbImage:[UIImage imageNamed:@"播放的进度条_1702"] forState:UIControlStateNormal];
    
//    // 缓冲的时间
//    UIProgressView *videoProgressView = [[UIProgressView alloc] init];
//    [progress addSubview:videoProgressView];
//    [videoProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(progress);
//    }];
//    self.videoProgressView = videoProgressView;
//    videoProgressView.layer.zPosition = 4;
//    videoProgressView
    
    // 当前时间
    UILabel *labelProgress = [[UILabel alloc] init];
    [viewPlay addSubview:labelProgress];
    [labelProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(progress);
        make.top.equalTo(progress.mas_bottom).offset(5);
    }];
    self.labelProgress = labelProgress;
    labelProgress.textColor = [UIColor whiteColor];
    labelProgress.font = [UIFont systemFontOfSize:13.0f];
//    labelProgress.hidden = YES;
    labelProgress.layer.zPosition = 4;
    
    // 总时间
    UILabel *labelTotalTime = [[UILabel alloc] init];
    [viewPlay addSubview:labelTotalTime];
    [labelTotalTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(progress);
        make.top.equalTo(labelProgress);
    }];
    self.labelTotalTime = labelTotalTime;
    labelTotalTime.textColor = [UIColor whiteColor];
    labelTotalTime.font = [UIFont systemFontOfSize:13.0f];
    labelTotalTime.layer.zPosition = 4;
}

#pragma mark ----- 点击播放、暂停、全屏
- (void)didClickButton:(UIButton *)button {
    if (button.tag == 402) { // 第一次点击播放
        if (self.videoUrl) { // 有播放网址
            _imgView.hidden = YES;
            
            //        [MBProgressHUD showHUDAddedTo:self animated:YES];
            [self addSubview:self.activityIndicatorView];
            [self.activityIndicatorView startAnimating];
            
            self.isPlayVideo = YES;
            
            self.isComplete = NO;
            // 第二次以上再次点击播放的时候，
            self.item = nil;
            
            // 播放视频
            [self setUpRongMiSchoolHeader:self.videoUrl];
        }else {
            ShowAutoHideMBProgressHUD(self, @"数据加载失败");
        }
        
    }else if (button.tag == 403){ // 点击控制栏的"播放/暂停"
        //
        self.isPlayVideo = !self.isPlayVideo;
        
        if (self.isPlayVideo) { // 播放
            if (self.isBecomeActive) { // 从后台进入前台
                // 从当前位置开始播放
                [self replaySeekToTime];
            }else {
                [self.player play];
            }
//            [self.btnPlay setBackgroundImage:[UIImage imageNamed:@"融米学堂_打开小icon__1702"] forState:UIControlStateNormal];
            self.btnPlay.selected = NO;
        }else {// 暂停
            [self.player pause];
//            [self.btnPlay setBackgroundImage:[UIImage imageNamed:@"融米学堂_关闭小icon__1702"] forState:UIControlStateNormal];
            self.btnPlay.selected = YES;
        }

    }else { // 点击全屏
        
        if (self.blockFullScreenBtn) {
            self.blockFullScreenBtn(button);
        }
        
    }
}

#pragma mark ----- 自动检测播放暂停
- (void)playOrPause:(UIButton *)btn {
    if(self.player.rate == 0.0){ //pause
        btn.selected = YES;
        [self.player play];
    }else if(self.player.rate == 1.0f){ //playing
        [self.player pause];
        btn.selected = NO;
    }
}

// 点击播放
- (void)replaySeekToTime {
    
//    [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    [self.item seekToTime:CMTimeMake(self.currentTime, 1)];
    CMTime currentCMTime = CMTimeMake(self.currentTime, 1);
    [self.player seekToTime:currentCMTime completionHandler:^(BOOL finished) {
        if (self.isPlayVideo) {
            [self.player play];
//            [MBProgressHUD hideHUDForView:self animated:YES];
        }
        [self displayControlViewWhenTap];
    }];
}

#pragma mark ---- setModel,给视频URL
- (void)setModelRongMi:(XZRongMiSchoolModel *)modelRongMi {
    _modelRongMi = modelRongMi;
    
//    @"http://baobab.wdjcdn.com/14564977406580.mp4"
    
    self.videoUrl = modelRongMi.videoPath;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:modelRongMi.videoThumb] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-376x126"]];
    
//    NSLog(@"%s",__func__);
}

#pragma mark ----- 进度条值改变的时候
- (void)userDragSliderChanged:(UISlider *)sender {
    
//    [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    [self removeGestureRecognizer:self.tapGesture];
    self.tapGesture = nil;
    
    // 滑动过程中时间不起作用
    [_hiddenTimer invalidate];
    
    [self.item seekToTime:CMTimeMake(sender.value, 1)];
    CMTime currentCMTime = CMTimeMake(sender.value * self.totalTime, 1);
    if (sender.value >= 0 && sender.value <= 1) {
//        if (!self.isPlayVideo) {
//            [MBProgressHUD hideHUDForView:self animated:YES];
//        }
        [self.player seekToTime:currentCMTime completionHandler:^(BOOL finished) {
            if (self.isPlayVideo) {
                [self.player play];
            }
            [self addGestureRecognizer:self.tapGesture];
            [self displayControlViewWhenTap];
//            [MBProgressHUD hideHUDForView:self animated:YES];
        }];
    }
    
//    NSLog(@"进度条值改变的时候 ======= %.2f",sender.value);
}

#pragma mark ----- 实时获取时间
- (void)addProgressObserver {
    AVPlayerItem *playerItem = self.player.currentItem;
    // 这里设置每秒执行一次
    __weak __typeof(self) weakself = self;
    self.timeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds([playerItem duration]);
//        NSLog(@"当前已经播放%f",current);
//        NSLog(@"查看rate=======================%.2f",weakself.player.rate);
//        [MBProgressHUD hideHUDForView:weakself animated:YES];
        // 隐藏
        weakself.activityIndicatorView.hidden = YES;
        [weakself.activityIndicatorView stopAnimating];
        
        weakself.currentTime = current;
        if (current) {
            weakself.labelProgress.text = [weakself timeStrFromTime:current];
            weakself.progress.value = current / total;
        }  
    }];
}

#pragma mark - 通知
// 给AVPlayerItem添加播放完成通知
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
    
    // 监听耳机插入和拔掉通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:) name:AVAudioSessionRouteChangeNotification object:nil];
    
//    NSLog(@"%s",__func__);
}

#pragma mark ----- 播放完成通知
- (void)playbackFinished:(NSNotification *)notification {
//    NSLog(@"视频播放完成.");
    // 暂停视频
    [self.player pause];
    self.isPlayVideo = NO;
//    self.currentPlayStatus = self.isPlayVideo;
    // 显示图片、隐藏控制栏、移除playerlayer
    self.imgView.hidden = NO;
    self.viewPlay.hidden = YES;
    [self.playerlayer removeFromSuperlayer];
    
    // 播放完成
    self.isComplete = YES;
    
    [self hiddenWhenDisplayFiveSeconds];
    [_hiddenTimer invalidate];
    
//    _item = nil;
    
    // 移除手势
    [self removeGestureRecognizer:self.tapGesture];
    _tapGesture = nil;
    
    // 加载中菊花
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
    
//    NSLog(@"%s",__func__);
}

#pragma mark ---- 通过KVO监控播放器状态
/**
 *  通过KVO监控播放器状态
 *  @param keyPath 监控属性
 *  @param object  监视器
 *  @param change  状态改变
 *  @param context 上下文
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    AVPlayerItem *playerItem = object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
        if(status == AVPlayerStatusReadyToPlay){
            self.totalTime = CMTimeGetSeconds(playerItem.duration);
            self.labelTotalTime.text = [self timeStrFromTime:self.totalTime];
            // 添加轻拍手势
            [self addGestureRecognizer:self.tapGesture];
            
            if (self.isPlayVideo) {
                 [_player play];
                 // 添加控制栏
                 [self displayControlViewWhenTap];
            }else{
                 [_player pause];
            }

            // 实时获取时间/总时间
            [self addProgressObserver];
            // 监听播放状态
            [self addNotification];
            
        }else if(status == AVPlayerStatusUnknown){
//            NSLog(@"========================%@",@"AVPlayerStatusUnknown");
        }else if (status == AVPlayerStatusFailed){
//            NSLog(@"========================%@",@"AVPlayerStatusFailed");
        }
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        
        NSArray *array = playerItem.loadedTimeRanges;
        // 本次缓冲时间范围
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        // 缓冲总长度
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;
        CGFloat middleValue = totalBuffer / CMTimeGetSeconds(playerItem.duration);
        // 添加缓冲动画
        if (middleValue <= self.progress.value || (totalBuffer - 1.0) < self.currentTime) {
//            NSLog(@"正在缓冲中。。。。。。");
            self.activityIndicatorView.hidden = NO;
            [self.activityIndicatorView startAnimating];
        }else {
            self.activityIndicatorView.hidden = YES;
            [self.activityIndicatorView stopAnimating];
        }
        
    }else if ([keyPath isEqualToString:@"playbackBufferEmpty"]){
        
//        NSLog(@"========================playbackBufferEmpty");
        
    }else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]){
        
//        NSLog(@"========================playbackLikelyToKeepUp");
        
    }else if([keyPath isEqualToString:@"presentationSize"]){
        
        //用来监测屏幕旋转
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
}

#pragma mark - 通知中心检测到屏幕旋转
-(void)orientationChanged:(NSNotification *)notification {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    switch (orientation) {
        case UIDeviceOrientationPortrait: // 向上旋转
            if (self.blockFullScreen) {
                self.blockFullScreen(YES,@"向上");
            }
            break;
        case UIDeviceOrientationLandscapeLeft: // 向左旋转
            if (self.blockFullScreen) {
                self.blockFullScreen(YES,@"向左");
            }
            break;
        case UIDeviceOrientationLandscapeRight: // 向右旋转
            if (self.blockFullScreen) {
                self.blockFullScreen(YES,@"向右");
            }
            break;
        case UIDeviceOrientationPortraitUpsideDown: // 向下旋转
            if (self.blockFullScreen) {
                self.blockFullScreen(YES,@"向下");
            }
            break;
        default:
            break;
    }
}

#pragma mark ----- 控制条隐藏
- (void)hiddenWhenDisplayFiveSeconds {
    _viewPlay.hidden = YES;
    if (self.isComplete) { // 播放完成，显示图片
        _imgView.hidden = NO;
    }else { // 播放未完成，隐藏图片
        _imgView.hidden = YES;
        
        // 如果已经播放完成，隐藏viewplay,显示imgView;
        if (self.isPlayVideo) {
            self.btnPlay.selected = NO;
        }else {
            self.btnPlay.selected = YES;
        }
    }
    
    [_hiddenTimer invalidate];
}

#pragma mark - 控制条显示
-(void)displayControlViewWhenTap {
    _viewPlay.hidden = NO;
    _imgView.hidden = YES;
    
    if (self.isPlayVideo) {
        self.btnPlay.selected = NO;
    }else {
        self.btnPlay.selected = YES;
    }
    
    if (!_hiddenTimer.valid) {
        _hiddenTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(hiddenWhenDisplayFiveSeconds) userInfo:nil repeats:NO];
    }else{
        [_hiddenTimer invalidate];
        _hiddenTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(hiddenWhenDisplayFiveSeconds) userInfo:nil repeats:NO];
    }
}

#pragma mark ---- 程序进入后台
- (void)appwillResignActive:(NSNotification *)note {
    // 即将进入后台全部暂停，用户进入之后手动点击播放，避免手势解锁之后，用户没有进入app，但是app已经走了appBecomeActive方法，开始播放视频
    [self.player pause];
    self.isPlayVideo = NO;
    
    self.btnPlay.selected = YES;
    
    self.isBecomeActive = NO;
}

// 程序进入前台
- (void)appBecomeActive:(NSNotification *)note {
    self.isBecomeActive = YES;
}

#pragma mark ----- 点击全屏，修改layer的frame
- (void)setPlayLayerFrame:(BOOL)isSetFrame {
    if (isSetFrame) {
        self.playerlayer.frame = CGRectMake(0, 0, self.window.bounds.size.height, self.window.bounds.size.width);
    }else {
        self.playerlayer.frame = CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenWidth * 220 / 350.0);
    }
}

#pragma mark ----- 轻拍手势
- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTappedPhoneScreen)];
    }
    return _tapGesture;
}

#pragma mark ---- 点击屏幕，出现播放/暂停，全屏等
- (void)userTappedPhoneScreen {
    [self displayControlViewWhenTap];
}

#pragma mark ---- 当用户点击左侧返回时
- (void)viewWillDisapperPause {
    if (self.isPlayVideo) {
        [self.player pause];
        self.isPlayVideo = NO;
    }
    [self.player.currentItem cancelPendingSeeks];
    [self.player.currentItem.asset cancelLoading];
    [self.playerlayer removeFromSuperlayer];
}

#pragma mark 时间转字符串 time 秒数 返回字符串
- (NSString *)timeStrFromTime:(float)time {
    int minutes = time / 60;
    int second = (int)time % 60;
    return [NSString stringWithFormat:@"%02d:%02d", minutes, second];
}

- (void)dealloc {
    if (_hiddenTimer && _hiddenTimer.valid) {
        [_hiddenTimer invalidate];
        _hiddenTimer = nil;
    }
    if (_item) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_item];
        
        [_item removeObserver:self forKeyPath:@"status"];
        [_item removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [_item removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
        [_item removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [_item removeObserver:self forKeyPath:@"playbackBufferFull"];
        [_item removeObserver:self forKeyPath:@"presentationSize"];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (_timeObserver) {
        [_player removeTimeObserver:self.timeObserver];
        _timeObserver = nil;
    }
    _item = nil;
    _player = nil;
}

- (AVPlayerItem *)item {
    if (!_item) {
        // 1.准备item
        _item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:self.videoUrl]];
        
        [_item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [_item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [_item addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [_item addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [_item addObserver:self forKeyPath:@"playbackBufferFull" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [_item addObserver:self forKeyPath:@"presentationSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return _item;
}

#pragma mark ---- 耳机插入或者拔出
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification
{
    NSDictionary *interuptionDict = notification.userInfo;
    
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    switch (routeChangeReason) {
            
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:{
            // 耳机插入,视频播放
            [self.player play];
            self.btnPlay.selected = NO;
            self.isPlayVideo = YES;
            break;
        }
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
        {
            // 耳机拔掉,视频暂停
            self.btnPlay.selected = YES;
            [self.player pause];
            self.isPlayVideo = NO;
            break;
        }
            
        case AVAudioSessionRouteChangeReasonCategoryChange:
        {
//            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
        }
            // called at start - also when other audio wants to play
            
        default:
        {
            
        }
            break;
    }
}

#pragma mark ---- 懒加载
- (UIActivityIndicatorView *)activityIndicatorView {
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicatorView.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
        _activityIndicatorView.layer.zPosition = 5;
    }
    return _activityIndicatorView;
}

@end
