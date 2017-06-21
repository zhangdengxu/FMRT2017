//
//  WLCommentInMyOrderCell.m
//  fmapp
//
//  Created by runzhiqiu on 16/5/4.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "WLCommentInMyOrderCell.h"

#import "LWDefine.h"
#import "LWImageStorage.h"



@interface WLCommentInMyOrderCell()<LWAsyncDisplayViewDelegate>

@property (nonatomic,strong) LWAsyncDisplayView* asyncDisplayView;

@end


@implementation WLCommentInMyOrderCell



#pragma mark - Init

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.asyncDisplayView];
        
    }
    return self;
}


#pragma mark - Actions

- (void)lwAsyncDisplayView:(LWAsyncDisplayView *)asyncDisplayView
   didCilickedImageStorage:(LWImageStorage *)imageStorage
                     touch:(UITouch *)touch{
    
    CGPoint point = [touch locationInView:self];
    for (NSInteger i = 0; i < self.cellLayout.imagePostionArray.count; i ++) {
        CGRect imagePosition = CGRectFromString(self.cellLayout.imagePostionArray[i]);
        
        //点击查看大图
        if (CGRectContainsPoint(imagePosition, point)) {
            if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickedImageWithCellLayout:atIndex:)] &&
                [self.delegate conformsToProtocol:@protocol(WLCommentInMyOrderCellDelegate)]) {
                [self.delegate tableViewCell:self didClickedImageWithCellLayout:self.cellLayout atIndex:i];
            }
        }
        
    }
    //点击菜单按钮
    if (CGRectContainsPoint(CGRectMake(self.cellLayout.menuPosition.origin.x - 10,
                                       self.cellLayout.menuPosition.origin.y - 10,
                                       self.cellLayout.menuPosition.size.width + 20,
                                       self.cellLayout.menuPosition.size.height + 20), point)) {
        [self clickedMenuShow];
    }

    
    //追评查看大图
    for (NSInteger i = 0; i < self.cellLayout.imagePostionSecondArray.count; i ++) {
        CGRect imagePosition = CGRectFromString(self.cellLayout.imagePostionSecondArray[i]);
        
        //点击查看大图
        if (CGRectContainsPoint(imagePosition, point)) {
            if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickedSecondImageWithCellLayout:atIndex:)] &&
                [self.delegate conformsToProtocol:@protocol(WLCommentInMyOrderCellDelegate)]) {
                [self.delegate tableViewCell:self didClickedSecondImageWithCellLayout:self.cellLayout atIndex:i];
            }
        }
        
    }

}

-(void)clickedMenuShow
{
    if (self.blockCommentBtn) {
        self.blockCommentBtn();
    }
}
#pragma mark - Draw and setup

- (void)setCellLayout:(FMCommentLayoutInMyOrder *)cellLayout {
    if (_cellLayout == cellLayout) {
        return;
    }
    _cellLayout = cellLayout;
    self.asyncDisplayView.layout = cellLayout;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.asyncDisplayView.frame = CGRectMake(0,
                                             0,
                                             SCREEN_WIDTH,
                                             self.cellLayout.cellHeight);
    
}

- (void)extraAsyncDisplayIncontext:(CGContextRef)context size:(CGSize)size {
    //绘制分割线
    CGContextMoveToPoint(context, 0.0f, self.bounds.size.height);
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
    CGContextSetLineWidth(context, 0.3f);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextStrokePath(context);
}

- (void)_drawImage:(UIImage *)image rect:(CGRect)rect context:(CGContextRef)context {
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, rect.origin.x, rect.origin.y);
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);
    CGContextDrawImage(context, rect, image.CGImage);
    CGContextRestoreGState(context);
}

#pragma mark - Getter

- (LWAsyncDisplayView *)asyncDisplayView {
    if (!_asyncDisplayView) {
        _asyncDisplayView = [[LWAsyncDisplayView alloc] initWithFrame:CGRectZero maxImageStorageCount:10];
        _asyncDisplayView.delegate = self;
    }
    return _asyncDisplayView;
}

@end
