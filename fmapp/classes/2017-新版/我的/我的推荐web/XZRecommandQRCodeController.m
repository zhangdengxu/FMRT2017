//
//  XZRecommandQRCodeController.m
//  XZProject
//
//  Created by admin on 16/10/9.
//  Copyright © 2016年 admin. All rights reserved.
//  我的推荐二维码

#import "XZRecommandQRCodeController.h"
#import "ShareViewController.h"
#import "XZActivityModel.h" // 分享model
#import "WLPublishSuccessViewController.h" // 分享

//  测试-------调查问卷
#import "XZQuestionnaireViewController.h"
#import "XZShareView.h"

@interface XZRecommandQRCodeController ()<UIActionSheetDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIImageView *imgQRCodeView;
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) XZShareView *share;
@end

@implementation XZRecommandQRCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNavTitle:self.navTitle];
    self.view.backgroundColor = KDefaultOrBackgroundColor;
    
    [self.view addSubview:self.imgQRCodeView];
    [self.imgQRCodeView sd_setImageWithURL:[NSURL URLWithString:self.modelActivity.sharepic] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
    //
    [self createQRCodeView];
    
}

// 点击分享按钮
- (void)didClickShareButton {
    // 分享1
//    if (_share == nil) {
//        [self.view addSubview:self.share];
//    }else {
//        [self.share removeFromSuperview];
//        _share = nil;
//    }
    // 分享2
    WLPublishSuccessViewController *publishSuccess = [[WLPublishSuccessViewController alloc] init];
    publishSuccess.modelActivity = self.modelActivity;
    [self.navigationController pushViewController:publishSuccess animated:YES];
//    // 调查问卷
//    XZQuestionnaireViewController *questionnaire = [[XZQuestionnaireViewController alloc] init];
//    [self.navigationController pushViewController:questionnaire animated:YES];
}

- (void)createQRCodeView {
    [[UIBarButtonItem appearance] setTintColor:XZColor(51, 51, 51)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStyleDone target:self action:@selector(didClickShareButton)];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didPressLongGestureRecognizer)];
    longPress.delegate = self;
    longPress.minimumPressDuration = 0.5f;
    [_imgQRCodeView addGestureRecognizer:longPress];
}

// 长按图片
- (void)didPressLongGestureRecognizer {
    [self.actionSheet showInView:self.view];
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
            // title取网页中的
            ShareViewController *shareVc = [[ShareViewController alloc] initWithTitle:@"" AndWithShareUrl:self.modelActivity.shareurl];
            shareVc.JumpWay = @"MyRecommand";
            [self.navigationController pushViewController:shareVc animated:YES];
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
    ShowAutoHideMBProgressHUD(self.view,msg);
}

#pragma mark --- 懒加载
- (UIActionSheet *)actionSheet {
    if (!_actionSheet) {
        _actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到本地",@"识别二维码", nil];
    }
    return _actionSheet;
}

- (UIImageView *)imgQRCodeView {
    if (!_imgQRCodeView) {
        _imgQRCodeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenWidth)];
        _imgQRCodeView.userInteractionEnabled = YES;
        
    }
    return _imgQRCodeView;
}

- (XZShareView *)share {
    if (!_share) {
        _share = [[XZShareView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight)];
        _share.modelShare = self.modelActivity;
        __weak __typeof(&*self.share)weakShare = self.share;
        __weak __typeof(&*self)weakSelf = self;
        _share.blockShareAction = ^(UIButton *button){
            [weakShare shareAction:button handlerDelegate:weakSelf];
        };
    }
    return _share;
}

@end
