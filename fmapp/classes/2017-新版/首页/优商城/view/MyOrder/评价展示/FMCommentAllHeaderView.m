//
//  FMCommentAllHeaderView.m
//  fmapp
//
//  Created by runzhiqiu on 16/5/4.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMCommentAllHeaderView.h"
#import "FMCountButtonInOrder.h"
#import "FMBottomCommentImOrder.h"
@interface FMCommentAllHeaderView()
@property (nonatomic, weak)FMCountButtonInOrder * sendComment;
@property (nonatomic, weak) FMCountButtonInOrder * haveImage;
@property (nonatomic, weak) FMCountButtonInOrder * waitComment;
@property (nonatomic, weak) FMBottomCommentImOrder * allComment;
@property (nonatomic, weak) FMBottomCommentImOrder * haveImageComment;
@property (nonatomic, weak) FMBottomCommentImOrder * waitCommentBtn;
@property (nonatomic, weak) FMBottomCommentImOrder * currentButton;
@end

@implementation FMCommentAllHeaderView


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, KProjectScreenWidth, 135);
        UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 85)];
        [self addSubview:topView];
        
        CGFloat widthTop = KProjectScreenWidth * 0.3333;
        
        FMCountButtonInOrder * sendComment = [[FMCountButtonInOrder alloc]initWithFrame:CGRectMake(0, 0, widthTop, topView.bounds.size.height - 0.5)];
        self.sendComment = sendComment;
        sendComment.titleComment = @"发布评价";
        sendComment.count = @"0";
        sendComment.tag = 800;
        [sendComment addTarget:self action:@selector(topButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:sendComment];

        FMCountButtonInOrder * haveImage = [[FMCountButtonInOrder alloc]initWithFrame:CGRectMake(widthTop, 0, widthTop, topView.bounds.size.height - 0.5)];
        self.haveImage = haveImage;
        haveImage.titleComment = @"有图评价";
        haveImage.count = @"0";
        haveImage.tag = 801;
        [haveImage addTarget:self action:@selector(topButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:haveImage];
        
        FMCountButtonInOrder * waitComment = [[FMCountButtonInOrder alloc]initWithFrame:CGRectMake( widthTop * 2, 0, widthTop, topView.bounds.size.height - 0.5)];
        self.waitComment = waitComment;
        waitComment.titleComment = @"待评价";
        waitComment.count = @"0";
        waitComment.tag = 802;
        [waitComment addTarget:self action:@selector(topButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:waitComment];
        
        UIView * lineGrayView = [[UIView alloc]initWithFrame:CGRectMake(0, topView.bounds.size.height - 0.5, topView.bounds.size.width, 0.5)];
        lineGrayView.backgroundColor = [UIColor lightGrayColor];
        [topView addSubview:lineGrayView];
        
        
        FMBottomCommentImOrder * allComment = [[FMBottomCommentImOrder alloc]initWithFrame:CGRectMake(0, 85, KProjectScreenWidth * 0.3333, 45)];
        self.allComment = allComment;
        if (KProjectScreenWidth == 320) {
            allComment.titleLabel.font = [UIFont systemFontOfSize:15];
        }else
        {
            allComment.titleLabel.font = [UIFont systemFontOfSize:17];
        }
        
        [allComment setBackgroundColor:[UIColor whiteColor]];
        [allComment setTitle:@"全部评价" forState:UIControlStateNormal];
        [allComment setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        allComment.tag = 803;
        [allComment addTarget:self action:@selector(topButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:allComment];
        [self topButtonOnClick:allComment];
        
        
        FMBottomCommentImOrder * haveImageComment = [[FMBottomCommentImOrder alloc]initWithFrame:CGRectMake(KProjectScreenWidth * 0.3333, 85, KProjectScreenWidth * 0.3333, 45)];
        self.haveImageComment = haveImageComment;
        if (KProjectScreenWidth == 320) {
            haveImageComment.titleLabel.font = [UIFont systemFontOfSize:15];
        }else
        {
            haveImageComment.titleLabel.font = [UIFont systemFontOfSize:17];
        }
        
        [haveImageComment setBackgroundColor:[UIColor whiteColor]];
        [haveImageComment setTitle:@"有图评价" forState:UIControlStateNormal];
        [haveImageComment setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        haveImageComment.tag = 804;
        [haveImageComment addTarget:self action:@selector(topButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:haveImageComment];
        
        
        
        FMBottomCommentImOrder * waitCommentBtn = [[FMBottomCommentImOrder alloc]initWithFrame:CGRectMake(KProjectScreenWidth * 0.6666, 85, KProjectScreenWidth * 0.3333, 45)];
        self.waitCommentBtn = waitCommentBtn;
        if (KProjectScreenWidth == 320) {
            waitCommentBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        }else
        {
            waitCommentBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        }
        
        [waitCommentBtn setBackgroundColor:[UIColor whiteColor]];
        [waitCommentBtn setTitle:@"待评价" forState:UIControlStateNormal];
        [waitCommentBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        waitCommentBtn.tag = 805;
        [waitCommentBtn addTarget:self action:@selector(topButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:waitCommentBtn];

        
    }
    return self;
}

-(void)setCommentArray:(NSArray *)commentArray
{
    _commentArray = commentArray;
    if (commentArray.count >=3 ) {
        self.sendComment.count = commentArray[0];
        self.haveImage.count = commentArray[1];
        self.waitComment.count = commentArray[2];
    }
}

-(void)topButtonOnClick:(UIButton *)button
{
    if ((button.tag - 800) == 3 ||(button.tag - 800) == 4 || (button.tag - 800) == 5) {
        if (self.currentButton != button) {
            self.currentButton.selected = NO;
            self.currentButton = (FMBottomCommentImOrder *)button;
            self.currentButton.selected = YES;
        }else
        {
            self.currentButton = (FMBottomCommentImOrder *)button;
            self.currentButton.selected = YES;
        }
        
        
        
        if ([self.delegate respondsToSelector:@selector(FMCommentAllHeaderView:didOnClickItem:)]) {
            [self.delegate FMCommentAllHeaderView:self didOnClickItem:self.currentButton.tag - 800];
        }
    }
}


@end
