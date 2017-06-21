//
//  FMSendCommentTableViewCell.m
//  fmapp
//
//  Created by runzhiqiu on 16/5/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMSendCommentTableViewCell.h"
#import "FMSendCommentModel.h"
#import "TZImagePickerController.h"
#import "XZTextView.h"
#import "AXRatingView.h"
#import "XZTestCell.h"
#import "XZChoosePictureWayView.h"
@interface FMSendCommentTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>




/** 填写评价 */
@property (nonatomic, strong) XZTextView *textComment;
/** 是否匿名评价 */
@property (nonatomic, strong) UIButton *btnAnonymousComment;
/** 评价图片 */
@property (nonatomic, strong) UICollectionView *collectionView;
/** 描述相符星星 */
@property (nonatomic, strong) AXRatingView *halfStepRatingView;
/** 发货速度星星 */
@property (nonatomic, strong) AXRatingView *speedView;
/** 描述相符星星 */
@property (nonatomic, strong) AXRatingView *serviceView;



@end

@implementation FMSendCommentTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        /** 商品图片 */
        UIImageView *imgGoods = [[UIImageView alloc]init];
        [self.contentView addSubview:imgGoods];
        [imgGoods mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.width.and.height.equalTo(@((KProjectScreenWidth - 20 - KProjectScreenWidth * 0.08) / 4.0));
        }];
        imgGoods.image = [UIImage imageNamed:@"图片136x136"];
        /** 填写评价 */
        XZTextView *textComment = [[XZTextView alloc]init];
        [self.contentView addSubview:textComment];
        [textComment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgGoods.mas_right).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.top.equalTo(imgGoods.mas_top);
            make.bottom.equalTo(imgGoods.mas_bottom);
        }];
        textComment.font = [UIFont systemFontOfSize:15];
        textComment.placeholder = @"亲！请写下对我们的评价吧！";
        textComment.layer.borderColor = [XZColor(235, 235, 242) CGColor];
        textComment.layer.borderWidth = 1.0f;
        self.textComment = textComment;
        /** 评价图片 */
        UIView *viewPhoto = [[UIView alloc]init];
        viewPhoto.userInteractionEnabled = YES;
        [self.contentView addSubview:viewPhoto];
        [viewPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.top.equalTo(textComment.mas_bottom).offset(10);
            make.width.equalTo(@(KProjectScreenWidth - 20));
            make.height.equalTo(imgGoods.mas_width);
        }];
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat size = (KProjectScreenWidth - 20 - KProjectScreenWidth * 0.08) / 4.0;
        flowLayout.itemSize = CGSizeMake(size, size);
        flowLayout.minimumInteritemSpacing = 0.026 * KProjectScreenWidth;
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [viewPhoto addSubview:self.collectionView];
        [self.collectionView registerClass:[XZTestCell class] forCellWithReuseIdentifier:@"PublishComment"];
        self.collectionView.scrollEnabled = NO;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(viewPhoto.mas_left);
            make.top.equalTo(viewPhoto.mas_top);
            make.width.equalTo(viewPhoto.mas_width);
            make.height.equalTo(viewPhoto.mas_height);
        }];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        /** 图片下方细线 */
        UILabel *line = [[UILabel alloc]init];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(viewPhoto.mas_left);
            make.top.equalTo(viewPhoto.mas_bottom).offset(10);
            make.right.equalTo(viewPhoto.mas_right);
            make.height.equalTo(@1);
        }];
        line.backgroundColor = XZColor(210, 211, 212);
        /** 描述相符 */
        UILabel *labelDescribe = [[UILabel alloc]init];
        [self.contentView addSubview:labelDescribe];
        [labelDescribe mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(viewPhoto.mas_left);
            make.top.equalTo(line.mas_bottom).offset(10);
        }];
        labelDescribe.text = @"描述相符";
        AXRatingView *halfStepRatingView = [[AXRatingView alloc] init];
        [self.contentView addSubview:halfStepRatingView];
        [halfStepRatingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(viewPhoto.mas_right);
            make.top.equalTo(labelDescribe.mas_top);
        }];
        [halfStepRatingView sizeToFit];
        _halfStepRatingView = halfStepRatingView;
        [halfStepRatingView setStepInterval:0.5];
        halfStepRatingView.markImage = [UIImage imageNamed:@"发表评价星星"];
        [halfStepRatingView addTarget:self action:@selector(ratingChanged:) forControlEvents:UIControlEventValueChanged];
        halfStepRatingView.value = 5.00;
        /** 最下面的分割线 */
        UILabel *lineCoarse = [[UILabel alloc]init];
        [self.contentView addSubview:lineCoarse];
        [lineCoarse mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.top.equalTo(halfStepRatingView.mas_bottom).offset(10);
            make.right.equalTo(self.contentView.mas_right);
            make.height.equalTo(@1);
        }];
        lineCoarse.backgroundColor = XZColor(230, 235, 240);
        // 第二个
        UILabel *labelMall = [[UILabel alloc]init];
        [self.contentView addSubview:labelMall];
        [labelMall mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.top.equalTo(lineCoarse.mas_top).offset(20);
        }];
        labelMall.text = @"商城评分";
        // 星星1
        UILabel *labelSpeed = [[UILabel alloc]init];
        [self.contentView addSubview:labelSpeed];
        [labelSpeed mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(labelMall.mas_left);
            make.top.equalTo(labelMall.mas_bottom).offset(10);
        }];
        labelSpeed.text = @"发货速度";
        AXRatingView *speedView = [[AXRatingView alloc] init];
        [self.contentView addSubview:speedView];
        [speedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.top.equalTo(labelSpeed.mas_top);
        }];
        [speedView sizeToFit];
        _speedView = speedView;
        [speedView setStepInterval:0.5];
        speedView.markImage = [UIImage imageNamed:@"发表评价星星"];
        [speedView addTarget:self action:@selector(ratingChanged:) forControlEvents:UIControlEventValueChanged];
        speedView.value = 5.00;
        
        // 星星2
        UILabel *labelService = [[UILabel alloc]init];
        [self.contentView addSubview:labelService];
        [labelService mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(labelMall.mas_left);
            make.top.equalTo(speedView.mas_bottom).offset(10);
        }];
        labelService.text = @"服务态度";
        AXRatingView *serviceView = [[AXRatingView alloc] init];
        [self.contentView addSubview:serviceView];
        [serviceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(speedView.mas_right);
            make.top.equalTo(labelService.mas_top);
        }];
        [serviceView sizeToFit];
        _serviceView = serviceView;
        [serviceView setStepInterval:0.5];
        serviceView.markImage = [UIImage imageNamed:@"发表评价星星"];
        [serviceView addTarget:self action:@selector(ratingChanged:) forControlEvents:UIControlEventValueChanged];
        serviceView.value = 5;
        
        UILabel *lineCoarse2 = [[UILabel alloc]init];
        [self.contentView addSubview:lineCoarse2];
        [lineCoarse2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.top.equalTo(serviceView.mas_bottom).offset(20);
            make.right.equalTo(self.contentView.mas_right);
            make.height.equalTo(@15);
        }];
        lineCoarse2.backgroundColor = XZColor(230, 235, 240);
        
    }
    return self;

}
// 评分
- (void)ratingChanged:(AXRatingView *)sender
{
    Log(@"sender value = %.2f",[sender value]);
}

-(void)setSendComment:(FMSendCommentModel *)sendComment
{
    _sendComment = sendComment;
    
    [self.collectionView reloadData];
}


#pragma mark - Collection view data source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sendComment.imageArray.count + 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PublishComment" forIndexPath:indexPath];
    if (indexPath.item == self.sendComment.imageArray.count) {
        cell.imageView.image = [UIImage imageNamed:@"发表评价相机"];
        cell.imageView.contentMode = UIViewContentModeCenter;
        cell.deleteBtn.hidden = YES;
    } else {
        cell.imageView.image = self.sendComment.imageArray[indexPath.row];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.item;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self)weakSelf = self;
    if (self.sendComment.imageArray.count != 4) {
        XZChoosePictureWayView *choosePicture = [[XZChoosePictureWayView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight)];
//        choosePicture.labelPrompt.text = ;
        [choosePicture setWayViewWithFirstButtonTitle:@"拍照" secondButtonTitle:@"相册" withLabelPrompt:[NSString stringWithFormat:@"亲，您还可以上传%ld张图片",(long)(4 - self.sendComment.imageArray.count)]];
        [self.fatherView addSubview:choosePicture];
        __weak typeof(choosePicture)weakCP = choosePicture;
        choosePicture.blockChoosePictureBtn = ^(UIButton * button) {
            if (button.tag == 301) {
                [self takePicture];
                [weakCP removeFromSuperview];
            }else if (button.tag == 302) {
                if (indexPath.row == self.sendComment.imageArray.count) { [self pickPhotoButtonClick];}
                [weakCP removeFromSuperview];
            }else {
                [weakCP removeFromSuperview];
            }
        };
    }else {
        // 提示请删除一张再重新选;
        ShowAutoHideMBProgressHUD(weakSelf.fatherView,@"请删除一张再重新选");
    }
}

-(void)takePicture
{
    //拍照
    if (self.paizhao) {
        self.paizhao();
    }
}
-(void)pickPhotoButtonClick
{//相册
    if (self.xiangce) {
        self.xiangce();
    }
    
}
#pragma mark Click Event
- (void)deleteBtnClik:(UIButton *)sender {
    [self.sendComment.imageArray removeObjectAtIndex:sender.tag];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    
//    [self.collectionView reloadData];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
