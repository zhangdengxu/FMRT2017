//
//  FMCommentLayout.m
//  fmapp
//
//  Created by runzhiqiu on 16/4/26.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMCommentLayout.h"

#import "LWTextParser.h"
#import "LWStorage+Constraint.h"
#import "LWConstraintManager.h"
#import "FMShopCommentModel.h"
#import "LWDefine.h"
@interface FMCommentLayout ()


@property (nonatomic, strong) LWStorage * currentStorage;


@end

@implementation FMCommentLayout


- (id)initWithContainer:(LWStorageContainer *)container
            statusModel:(FMShopCommentModel *)statusModel
                  index:(NSInteger)index;

{
    self = [super initWithContainer:container];
    if (self) {
        
        CGFloat currentHeighWithStorage = 0;
        /****************************生成Storage 相当于模型*************************************/
        /*********LWAsyncDisplayView用将所有文本跟图片的模型都抽象成LWStorage，方便你能预先将所有的需要计算的布局内容直接缓存起来***/
        /*******而不是在渲染的时候才进行计算*******************************************/
        
        //头像模型 avatarImageStorage
        LWImageStorage * avatarStorage = [[LWImageStorage alloc] init];
        avatarStorage.type = LWImageStorageWebImage;
        avatarStorage.URL = statusModel.avatar;
        avatarStorage.cornerRadius = 20.0f;
        avatarStorage.cornerBackgroundColor = [UIColor whiteColor];
        
        //名字模型 nameTextStorage
        LWTextStorage* nameTextStorage = [[LWTextStorage alloc] init];
        nameTextStorage.text = statusModel.name;
        nameTextStorage.font = [UIFont systemFontOfSize:15.0f];
        nameTextStorage.textAlignment = NSTextAlignmentLeft;
        nameTextStorage.linespace = 2.0f;
        nameTextStorage.textColor = RGB(40, 40, 40, 1);
        
        
        
        
        //正文内容模型 contentTextStorage
        LWTextStorage* contentTextStorage = [[LWTextStorage alloc] init];
        contentTextStorage.text = statusModel.content;
        contentTextStorage.font = [UIFont systemFontOfSize:15.0f];
        contentTextStorage.textColor = RGB(40, 40, 40, 1);
        contentTextStorage.linespace = 2.0f;
        
        /***********************************  设置约束 自动布局 *********************************************/
        [LWConstraintManager lw_makeConstraint:avatarStorage.constraint.leftMargin(10).topMargin(20).widthLength(40.0f).heightLength(40.0f)];
        [LWConstraintManager lw_makeConstraint:nameTextStorage.constraint.leftMarginToStorage(avatarStorage,10).topMargin(30).widthLength(SCREEN_WIDTH)];
        [LWConstraintManager lw_makeConstraint:contentTextStorage.constraint.leftMarginToStorage(avatarStorage,10).topMarginToStorage(nameTextStorage,10).rightMargin(20)];
        
        
        /*****添加评分**************/
        
        //评分
        NSInteger statusGrade = [statusModel.statusGrade integerValue];
        NSMutableArray* statusGradeArray = [[NSMutableArray alloc] initWithCapacity:statusGrade];
        for (NSInteger i = 0; i < statusGrade; i++) {
            CGRect imageRect = CGRectMake(nameTextStorage.right + 12.0f + (i * (15.0f + 5.0f )),
                                          nameTextStorage.top + 2.0f,
                                          15.0f,
                                          15.0f);
            /***************** 也可以不使用设置约束的方式来布局，而是直接设置frame属性的方式来布局*************************************/
            LWImageStorage* imageStorage = [[LWImageStorage alloc] init];
            imageStorage.frame = imageRect;
            imageStorage.type = LWImageStorageLocalImage;
            imageStorage.image = [UIImage imageNamed:@"星星_03"];
            imageStorage.fadeShow = YES;
            imageStorage.masksToBounds = YES;
            imageStorage.contentMode = kCAGravityResizeAspectFill;
            
            [statusGradeArray addObject:imageStorage];
        }
        
        
        
        [LWTextParser parseEmojiWithTextStorage:contentTextStorage];
        [LWTextParser parseTopicWithLWTextStorage:contentTextStorage
                                        linkColor:RGB(113, 129, 161, 1)
                                   highlightColor:RGB(0, 0, 0, 0.15)
                                   underlineStyle:NSUnderlineStyleNone];
        
        
        //生成时间的模型 dateTextStorage
        LWTextStorage* dateTextStorage = [[LWTextStorage alloc] init];
        dateTextStorage.text = statusModel.date;
        dateTextStorage.font = [UIFont systemFontOfSize:13.0f];
        dateTextStorage.textColor = [UIColor grayColor];
        
        
        /***********************************  设置约束 自动布局 *********************************************/
        [LWConstraintManager lw_makeConstraint:dateTextStorage.constraint.leftEquelToStorage(contentTextStorage).topMarginToStorage(contentTextStorage,10)];
        
        
        self.currentStorage = dateTextStorage;
        
        
        currentHeighWithStorage = dateTextStorage.bottom + 12.0f;
        
#pragma -mark 以下内容为活动内容
        
        if (statusModel.imgs.count > 0) {
            //发布的图片模型 imgsStorage
            NSInteger imageCount = [statusModel.imgs count];
            NSMutableArray* imageStorageArray = [[NSMutableArray alloc] initWithCapacity:imageCount];
            NSMutableArray* imagePositionArray = [[NSMutableArray alloc] initWithCapacity:imageCount];
            NSInteger row = 0;
            NSInteger column = 0;
            
            
            for (NSInteger i = 0; i < statusModel.imgs.count; i ++) {
                CGRect imageRect = CGRectMake(60.0f + (column * 75.0f),
                                              currentHeighWithStorage + (row * 75.0f),
                                              70.0f,
                                              70.0f);
                NSString* imagePositionString = NSStringFromCGRect(imageRect);
                [imagePositionArray addObject:imagePositionString];
                /***************** 也可以不使用设置约束的方式来布局，而是直接设置frame属性的方式来布局*************************************/
                LWImageStorage* imageStorage = [[LWImageStorage alloc] init];
                imageStorage.frame = imageRect;
                /***********************************/
                NSString* URLString = [statusModel.imgs objectAtIndex:i];
                imageStorage.URL = [NSURL URLWithString:URLString];
                imageStorage.type = LWImageStorageWebImage;
                imageStorage.fadeShow = YES;
                imageStorage.masksToBounds = YES;
                imageStorage.placeholder = [UIImage imageNamed:@"美读时光headerBack_02"];
                imageStorage.contentMode = kCAGravityResizeAspectFill;
                
                [imageStorageArray addObject:imageStorage];
                
                column = column + 1;
                if (column > 2) {
                    column = 0;
                    row = row + 1;
                }
            }
            CGFloat imagesHeight = 0.0f;
            row < 3 ? (imagesHeight = (row + 1) * 75.0f):(imagesHeight = row  * 75.0f);
            currentHeighWithStorage = currentHeighWithStorage + (row + 1) * 75.0f;
            //获取最后一张图片的模型
            LWImageStorage* lastImageStorage = (LWImageStorage *)[imageStorageArray lastObject];
            
            
            self.currentStorage = lastImageStorage;
            [container addStorages:imageStorageArray];
            self.imagePostionArray = imagePositionArray;
        }
        
        if (statusModel.shopCommentFirst) {
            //comment
            //生成评论背景Storage
            LWImageStorage* commentBgStorage = [[LWImageStorage alloc] init];
            CGRect commentBgPosition = CGRectZero;
            //正文内容模型 contentTextStorage
            LWTextStorage* shopCommentFirstTextStorage = [[LWTextStorage alloc] init];
            shopCommentFirstTextStorage.text = [NSString stringWithFormat:@"商家回复：%@",statusModel.shopCommentFirst];
            shopCommentFirstTextStorage.font = [UIFont systemFontOfSize:15.0f];
            shopCommentFirstTextStorage.textColor = RGB(40, 40, 40, 1);
            shopCommentFirstTextStorage.linespace = 2.0f;
            
            
            [LWConstraintManager lw_makeConstraint:shopCommentFirstTextStorage.constraint.leftMarginToStorage(avatarStorage,16).topMarginToStorage(self.currentStorage,15).rightMargin(20)];
            
            [LWTextParser parseEmojiWithTextStorage:shopCommentFirstTextStorage];
            [LWTextParser parseTopicWithLWTextStorage:shopCommentFirstTextStorage
                                            linkColor:RGB(113, 129, 161, 1)
                                       highlightColor:RGB(0, 0, 0, 0.15)
                                       underlineStyle:NSUnderlineStyleNone];
            
            //如果商家有评论，设置评论背景Storage
            commentBgPosition = CGRectMake(60.0f,self.currentStorage.bottom + 5.0f, shopCommentFirstTextStorage.width + 10, shopCommentFirstTextStorage.height + 15.0f);
            commentBgStorage.type = LWImageStorageLocalImage;
            commentBgStorage.frame = commentBgPosition;
            commentBgStorage.image = [UIImage imageNamed:@"评价（商家回复）_03"];
            [commentBgStorage stretchableImageWithLeftCapWidth:190 topCapHeight:25];
            
            
            [container addStorage:shopCommentFirstTextStorage];
            [container addStorage:commentBgStorage];
            self.commentBgPosition = commentBgPosition;
            
            
            self.currentStorage = commentBgStorage;
            currentHeighWithStorage = currentHeighWithStorage + commentBgStorage.height + 10;
            
        }
        
        if (statusModel.secondContent || statusModel.secondImgs ||statusModel.shopCommentSecond) {
            
            
            
            //生成追评的模型 dateTextStorage
            LWTextStorage* addcommentStorage = [[LWTextStorage alloc] init];
            addcommentStorage.text = @"追评";
            addcommentStorage.font = [UIFont systemFontOfSize:15.0f];
            addcommentStorage.textColor = [UIColor orangeColor];
            
            
            /***********************************  设置约束 自动布局 *********************************************/
            [LWConstraintManager lw_makeConstraint:addcommentStorage.constraint.leftEquelToStorage(contentTextStorage).topMarginToStorage(self.currentStorage,10)];
            
            
            self.currentStorage = addcommentStorage;
            currentHeighWithStorage = currentHeighWithStorage + addcommentStorage.height + 15;
            
            if (statusModel.secondContent) {
                //正文内容模型 contentTextStorage
                LWTextStorage* secondContentTextStorage = [[LWTextStorage alloc] init];
                secondContentTextStorage.text = statusModel.secondContent;
                secondContentTextStorage.font = [UIFont systemFontOfSize:15.0f];
                secondContentTextStorage.textColor = RGB(40, 40, 40, 1);
                secondContentTextStorage.linespace = 2.0f;
                [LWConstraintManager lw_makeConstraint:secondContentTextStorage.constraint.leftMarginToStorage(avatarStorage,10).topMarginToStorage(self.currentStorage,15).rightMargin(20)];
                
                [LWTextParser parseEmojiWithTextStorage:secondContentTextStorage];
                [LWTextParser parseTopicWithLWTextStorage:secondContentTextStorage
                                                linkColor:RGB(113, 129, 161, 1)
                                           highlightColor:RGB(0, 0, 0, 0.15)
                                           underlineStyle:NSUnderlineStyleNone];
                [container addStorage:addcommentStorage];
                [container addStorage:secondContentTextStorage];
                self.currentStorage = secondContentTextStorage;
                currentHeighWithStorage = currentHeighWithStorage + secondContentTextStorage.height + 15;
            }
            if (statusModel.secondImgs) {
                
                
                //发布的图片模型 imgsStorage
                NSInteger imageCount = [statusModel.secondImgs count];
                NSMutableArray* imageStorageArray = [[NSMutableArray alloc] initWithCapacity:imageCount];
                NSMutableArray* imagePositionArray = [[NSMutableArray alloc] initWithCapacity:imageCount];
                NSInteger row = 0;
                NSInteger column = 0;
                for (NSInteger i = 0; i < statusModel.secondImgs.count; i ++) {
                    CGRect imageRect = CGRectMake(60.0f + (column * 75.0f),
                                                  currentHeighWithStorage + (row * 75.0f),
                                                  70.0f,
                                                  70.0f);
                    NSString* imagePositionString = NSStringFromCGRect(imageRect);
                    [imagePositionArray addObject:imagePositionString];
                    /***************** 也可以不使用设置约束的方式来布局，而是直接设置frame属性的方式来布局*************************************/
                    LWImageStorage* imageStorage = [[LWImageStorage alloc] init];
                    imageStorage.frame = imageRect;
                    /***********************************/
                    NSString* URLString = [statusModel.secondImgs objectAtIndex:i];
                    imageStorage.URL = [NSURL URLWithString:URLString];
                    imageStorage.type = LWImageStorageWebImage;
                    imageStorage.placeholder = [UIImage imageNamed:@"美读时光headerBack_02"];
                    imageStorage.fadeShow = YES;
                    imageStorage.masksToBounds = YES;
                    imageStorage.contentMode = kCAGravityResizeAspectFill;
                    
                    [imageStorageArray addObject:imageStorage];
                    
                    column = column + 1;
                    if (column > 2) {
                        column = 0;
                        row = row + 1;
                    }
                }
                CGFloat imagesHeight = 0.0f;
                row < 3 ? (imagesHeight = (row + 1) * 85.0f):(imagesHeight = row  * 85.0f);
                
                
                
                currentHeighWithStorage = currentHeighWithStorage + (row + 1) * 85.0f;
                
                [container addStorages:imageStorageArray];
                
                self.imagePostionSecondArray = imagePositionArray;
                
                //获取最后一张图片的模型
                LWImageStorage* lastImageStorage = (LWImageStorage *)[imageStorageArray lastObject];
                self.currentStorage = lastImageStorage;
            }
            //第二次商家评论
            if (statusModel.shopCommentSecond) {
                //comment
                //生成评论背景Storage
                LWImageStorage* commentBgStorage = [[LWImageStorage alloc] init];
                CGRect commentBgPosition = CGRectZero;
                //正文内容模型 contentTextStorage
                LWTextStorage* shopCommentFirstTextStorage = [[LWTextStorage alloc] init];
                shopCommentFirstTextStorage.text = [NSString stringWithFormat:@"商家回复：%@",statusModel.shopCommentSecond];
                shopCommentFirstTextStorage.font = [UIFont systemFontOfSize:15.0f];
                shopCommentFirstTextStorage.textColor = RGB(40, 40, 40, 1);
                shopCommentFirstTextStorage.linespace = 2.0f;
                
                
                [LWConstraintManager lw_makeConstraint:shopCommentFirstTextStorage.constraint.leftMarginToStorage(avatarStorage,16).topMarginToStorage(self.currentStorage,15).rightMargin(20)];
                
                [LWTextParser parseEmojiWithTextStorage:shopCommentFirstTextStorage];
                [LWTextParser parseTopicWithLWTextStorage:shopCommentFirstTextStorage
                                                linkColor:RGB(113, 129, 161, 1)
                                           highlightColor:RGB(0, 0, 0, 0.15)
                                           underlineStyle:NSUnderlineStyleNone];
                
                //如果商家有评论，设置评论背景Storage
                commentBgPosition = CGRectMake(60.0f,self.currentStorage.bottom + 5.0f, shopCommentFirstTextStorage.width + 10, shopCommentFirstTextStorage.height + 15.0f);
                commentBgStorage.type = LWImageStorageLocalImage;
                commentBgStorage.frame = commentBgPosition;
                commentBgStorage.image = [UIImage imageNamed:@"评价（商家回复）_03"];
                [commentBgStorage stretchableImageWithLeftCapWidth:190 topCapHeight:25];
                
                
                [container addStorage:shopCommentFirstTextStorage];
                [container addStorage:commentBgStorage];
                self.commentBgPosition = commentBgPosition;
                
                
                self.currentStorage = commentBgStorage;
                currentHeighWithStorage = currentHeighWithStorage + commentBgStorage.height + 10;
            }
            
            
        }
        
        
        
        /**************************将要在同一个LWAsyncDisplayView上显示的Storage要全部放入同一个LWLayout中***************************************/
        /**************************我们将尽量通过合并绘制的方式将所有在同一个View显示的内容全都异步绘制在同一个AsyncDisplayView上**************************/
        /**************************这样的做法能最大限度的节省系统的开销**************************/
        
        
        [container addStorage:avatarStorage];
        [container addStorage:nameTextStorage];
        [container addStorage:contentTextStorage];
        [container addStorages:statusGradeArray];
        [container addStorage:dateTextStorage];
        
        
        //一些其他属性
        
        
        
        self.statusModel = statusModel;
        //如果是使用在UITableViewCell上面，可以通过以下方法快速的得到Cell的高度
        self.cellHeight = [self suggestHeightWithBottomMargin:15.0f];
        /********************* 有任何问题欢迎反馈给我 liuweiself@126.com ****************************************/
        /***************  https://github.com/waynezxcv/Gallop 持续更新完善，如果觉得有帮助，给个Star~[]***************************/
        /******************** 正在不断完善中，谢谢~  Enjoy ******************************************************/
        
    }
    return self;

    
}

@end
