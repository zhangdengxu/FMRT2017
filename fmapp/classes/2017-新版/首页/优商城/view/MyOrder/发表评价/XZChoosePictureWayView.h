//
//  XZChoosePictureWayView.h
//  XZFenLeiJieMian
//
//  Created by admin on 16/5/6.
//  Copyright © 2016年 yuyang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^blockChoosePictureBtn)(UIButton *button);
@interface XZChoosePictureWayView : UIView
/** 拍照 */
@property (nonatomic, strong) UIButton *btnTakePhoto;
/** 相册 */
@property (nonatomic, strong) UIButton *btnPhotoAlbum;
/** 取消 */
@property (nonatomic, strong) UIButton *btnCancel;
/** 提示框 */
@property (nonatomic, strong) UILabel *labelPrompt;
@property (nonatomic, copy) blockChoosePictureBtn blockChoosePictureBtn;
// 给button的title赋值
- (void)setWayViewWithFirstButtonTitle:(NSString *)first secondButtonTitle:(NSString *)second withLabelPrompt:(NSString *)profmpt ;
@end
