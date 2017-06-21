//
//  XZChoosePictureWayView.m
//  XZFenLeiJieMian
//
//  Created by admin on 16/5/6.
//  Copyright © 2016年 yuyang. All rights reserved.
//

#import "XZChoosePictureWayView.h"

@implementation XZChoosePictureWayView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 设置PublishCommentView子视图
        [self setUpPublishCommentView];
    }
    return self;
}
// 设置PublishCommentView子视图
- (void)setUpPublishCommentView {
    /** 最底部的灰色视图 */
    UIView *cover = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.3;
    [self addSubview:cover];
    /** 白色视图 */
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KProjectScreenHeight - 264, KProjectScreenWidth, 200)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomView];
    /** 提示框 */
    UILabel *labelPrompt = [[UILabel alloc]init];
    [self addSubview:labelPrompt];
    [labelPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top).offset(10);
        make.centerX.equalTo(bottomView.mas_centerX);
    }];
    self.labelPrompt = labelPrompt;
    labelPrompt.text = [NSString stringWithFormat:@"亲，您还可以上传4张图片"];
    /** 拍照 */
    UIButton *btnTakePhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btnTakePhoto];
    [btnTakePhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelPrompt.mas_bottom).offset(10);
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.equalTo(@40);
    }];
    _btnTakePhoto = btnTakePhoto;
    btnTakePhoto.tag = 301;
//    [btnTakePhoto setTitle:@"拍照" forState:UIControlStateNormal];
    [btnTakePhoto setBackgroundColor:XZColor(6, 55, 151)];
    [btnTakePhoto addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    /** 相册 */
    UIButton *btnPhotoAlbum = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btnPhotoAlbum];
    [btnPhotoAlbum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnTakePhoto.mas_bottom).offset(10);
        make.left.equalTo(btnTakePhoto.mas_left);
        make.right.equalTo(btnTakePhoto.mas_right);
        make.height.equalTo(btnTakePhoto.mas_height);
    }];
    _btnPhotoAlbum = btnPhotoAlbum;
    btnPhotoAlbum.tag = 302;
//    [btnPhotoAlbum setTitle:@"相册" forState:UIControlStateNormal];
    [btnPhotoAlbum setBackgroundColor:XZColor(6, 55, 151)];
    [btnPhotoAlbum addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    /** 取消 */
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btnCancel];
    [btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnPhotoAlbum.mas_bottom).offset(10);
        make.left.equalTo(btnTakePhoto.mas_left);
        make.right.equalTo(btnTakePhoto.mas_right);
        make.height.equalTo(btnTakePhoto.mas_height);
    }];
    _btnCancel = btnCancel;
    btnCancel.tag = 303;
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel setBackgroundColor:XZColor(152, 153, 154)];
    [btnCancel addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
}
// button的点击事件
- (void)didClickButton:(UIButton *)button {
    if (self.blockChoosePictureBtn) {
        self.blockChoosePictureBtn(button);
    }
}
// 给button的title赋值
- (void)setWayViewWithFirstButtonTitle:(NSString *)first secondButtonTitle:(NSString *)second withLabelPrompt:(NSString *)profmpt {
    [_btnTakePhoto setTitle:first forState:UIControlStateNormal];
    [_btnPhotoAlbum  setTitle:second forState:UIControlStateNormal];
    self.labelPrompt.text = profmpt;
}
@end
