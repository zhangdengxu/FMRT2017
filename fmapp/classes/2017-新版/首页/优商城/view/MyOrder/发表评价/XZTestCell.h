//
//  XZPublishCommentView.m
//  XZFenLeiJieMian
//
//  Created by admin on 16/5/4.
//  Copyright © 2016年 yuyang. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface XZTestCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, assign) NSInteger row;


- (UIView *)snapshotView;

@property (nonatomic, copy) void(^blockDelete)(UIButton *);

@end

