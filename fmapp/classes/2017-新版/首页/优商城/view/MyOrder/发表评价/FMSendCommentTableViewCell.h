//
//  FMSendCommentTableViewCell.h
//  fmapp
//
//  Created by runzhiqiu on 16/5/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMSendCommentModel,XZTextView,AXRatingView;

typedef void(^blockCommentImageXiangceBtn)();
typedef void(^blockCommentImagePaizhaoBtn)();

@interface FMSendCommentTableViewCell : UITableViewCell

@property (nonatomic, strong) FMSendCommentModel * sendComment;


@property (nonatomic, copy) blockCommentImageXiangceBtn xiangce;
@property (nonatomic, copy) blockCommentImagePaizhaoBtn paizhao;


@property (nonatomic, weak) UIView * fatherView;

@end
