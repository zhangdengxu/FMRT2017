//
//  XZOptimalMallRecommendView.m
//  fmapp
//
//  Created by admin on 17/1/11.
//  Copyright © 2017年 yk. All rights reserved.
//  优商城的推荐二维码

#import "XZOptimalMallRecommendView.h"
#import "XZActivityModel.h"


@interface XZOptimalMallRecommendView ()<UIActionSheetDelegate,UIGestureRecognizerDelegate>
// 二维码图片
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIActionSheet *actionSheet;
@end

@implementation XZOptimalMallRecommendView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpOptimalMallRecommendView];
    }
    return self;
}

- (void)setUpOptimalMallRecommendView {
    // 黑色背景
    UIView *cover = [[UIView alloc] init];
    [self addSubview:cover];
    [cover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.7;
    
    //
    UIImageView *imgClosed = [[UIImageView alloc] init];
    [self addSubview:imgClosed];
    [imgClosed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-40);
        make.top.equalTo(self).offset(104);
        make.width.equalTo(@25);
        make.height.equalTo(@(25 * 111 / 65.0));
    }];
    imgClosed.image = [UIImage imageNamed:@"优商城_我的二维码-关闭_36"];
    
    // 关闭按钮
    UIButton *buttonClosed = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:buttonClosed];
    [buttonClosed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imgClosed);
        make.top.equalTo(self).offset(104);
        make.size.equalTo(@40);
    }];
    [buttonClosed addTarget:self action:@selector(didClickCloseButton) forControlEvents:UIControlEventTouchUpInside];
    
    // 二维码图片
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(buttonClosed);
        make.size.equalTo((KProjectScreenWidth - 80));
        make.top.equalTo(imgClosed.mas_bottom);
    }];
    imageView.userInteractionEnabled = YES;
    self.imageView = imageView;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didPressLongGestureRecognizer)];
    longPress.delegate = self;
    longPress.minimumPressDuration = 0.5f;
    [imageView addGestureRecognizer:longPress];
}

// 点击关闭按钮
- (void)didClickCloseButton {
    [self removeFromSuperview];
}

// 长按图片
- (void)didPressLongGestureRecognizer {
    [self.actionSheet showInView:self];
}

#pragma mark ---- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        // 取消按钮
    }
    switch (buttonIndex) {
        case 0:// 保存到本地
        {
//            NSLog(@"保存到本地");
            NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:self.modelActivity.sharepic]];
            UIImage *image = [UIImage imageWithData:data]; // 取得图片
            [self saveImageToPhotos:image];
        }
            break;
        case 1:// 识别二维码
        {
            [self didClickCloseButton];
            // title取网页中的
            if (self.blockJumpDetail) {
                self.blockJumpDetail();
            }
        }
            break;
        default:
            break;
    }
}

- (void)saveImageToPhotos:(UIImage *)savedImage {
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

//回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *msg = nil;
    if (error != NULL) {
        msg = @"保存图片失败";
    }else {
        msg = @"保存图片成功";
    }
    ShowAutoHideMBProgressHUD(self,msg);
}

- (void)setModelActivity:(XZActivityModel *)modelActivity {
    _modelActivity = modelActivity;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.modelActivity.sharepic] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
}

#pragma mark --- 懒加载
- (UIActionSheet *)actionSheet {
    if (!_actionSheet) {
        _actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到本地",@"识别二维码", nil];
    }
    return _actionSheet;
}

@end
