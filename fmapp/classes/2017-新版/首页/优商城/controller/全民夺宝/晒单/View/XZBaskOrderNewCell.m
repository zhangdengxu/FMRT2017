//
//  XZBaskOrderNewCell.m
//  fmapp
//
//  Created by admin on 16/10/28.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "XZBaskOrderNewCell.h"
#import "XZBaskOrderListInnerItem.h" // item
#import "XZBaskOrderModel.h" // model
#import "Fm_Tools.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface XZBaskOrderNewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
/** collectionView */
@property (nonatomic, strong) UICollectionView *collectionView;
/** 图片 */
@property (nonatomic, strong) NSMutableArray *selectedPhotos;
/** 头像 */
@property (nonatomic, strong) UIImageView *imgIcon;
/** 时间 */
@property (nonatomic, strong) UILabel *labelTime;
/** 昵称 */
@property (nonatomic, strong) UILabel *labelNickname;
/** 评论标题 */
@property (nonatomic, strong) UILabel *labelTitle;
/** 评论内容 */
@property (nonatomic, strong) UILabel *labelContent;

@end

@implementation XZBaskOrderNewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupXZLatestGoodsBaskOrderCell];
    }
    return self;
}

- (void)setupXZLatestGoodsBaskOrderCell {
    /** 头像 */
    UIImageView *imgIcon = [[UIImageView alloc] init];
    imgIcon.layer.masksToBounds = YES;
    imgIcon.layer.cornerRadius = 25;
    [self.contentView addSubview:imgIcon];
    [imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(10).priorityHigh();
        make.size.equalTo(@50);
    }];
    self.imgIcon = imgIcon;
    //    imgIcon.image = [UIImage imageNamed:@"commtouxiang110"];
    imgIcon.backgroundColor = [UIColor darkGrayColor];
    
    /** 时间 */
    UILabel *labelTime = [[UILabel alloc] init];
    [self.contentView addSubview:labelTime];
    [labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(imgIcon.mas_centerY);
    }];
    self.labelTime = labelTime;
    labelTime.textColor = XZColor(153, 153, 153);
    labelTime.font = [UIFont systemFontOfSize:14];
    labelTime.textAlignment = NSTextAlignmentRight;
    
    /** 昵称 */
    UILabel *labelNickname = [[UILabel alloc] init];
    [self.contentView addSubview:labelNickname];
    [labelNickname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgIcon.mas_right).offset(10);
        make.centerY.equalTo(imgIcon.mas_centerY);;
        make.right.equalTo(labelTime.mas_left);
    }];
    self.labelNickname = labelNickname;
    labelNickname.font = [UIFont systemFontOfSize:15];
    labelNickname.textColor = XZColor(0, 153, 255);
    
    /** 评论标题 */
    UILabel *labelTitle = [[UILabel alloc] init];
    [self.contentView addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelNickname);
        make.top.equalTo(imgIcon.mas_bottom);
        make.right.equalTo(labelTime);
    }];
    self.labelTitle = labelTitle;
    labelTitle.font = [UIFont systemFontOfSize:15];
    labelTitle.textColor = XZColor(51, 51, 51);
    
    /** 评论内容 */
    UILabel *labelContent = [[UILabel alloc] init];
    [self.contentView addSubview:labelContent];
    [labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelTitle);
        make.right.equalTo(labelTime);
        make.top.equalTo(labelTitle.mas_bottom).offset(10);
    }];
    self.labelContent = labelContent;
    labelContent.numberOfLines = 0;
    labelContent.font = [UIFont systemFontOfSize:14];
    labelContent.textColor = XZColor(102, 102, 102);
    
    // collectionView
    CGFloat size = (KProjectScreenWidth - 80 - KProjectScreenWidth * 0.06) / 3.0;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(size, size);
    flowLayout.minimumInteritemSpacing = 0.03 * KProjectScreenWidth;
    //    self.flowLayout = flowLayout;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelTitle.mas_left);
        make.top.equalTo(labelContent.mas_bottom).offset(10);
        make.right.equalTo(labelContent.mas_right);
        make.height.equalTo(size);
    }];
    //    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[XZBaskOrderListInnerItem class] forCellWithReuseIdentifier:@"BaskOrderListInnerItemLastGoods"];
    
    // 线
    UILabel *line = [[UILabel alloc] init];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
    line.backgroundColor = KDefaultOrBackgroundColor;
    
}

#pragma mark ---- UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.selectedPhotos.count; //  self.selectedPhotos.count
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XZBaskOrderListInnerItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BaskOrderListInnerItemLastGoods" forIndexPath:indexPath];
    cell.photoUrl = self.selectedPhotos[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //    if (self.blockClickItem) {
    //        self.blockClickItem(indexPath.item);
    //    }
    XZBaskOrderListInnerItem *cell = (XZBaskOrderListInnerItem *)[collectionView cellForItemAtIndexPath:indexPath];
    NSMutableArray *arrM = [NSMutableArray array];
    for (int i = 0; i < self.selectedPhotos.count; i++) {
        MJPhoto *p = [[MJPhoto alloc] init];
        NSString *urlStr = self.selectedPhotos[i];
        p.url = [NSURL URLWithString:urlStr];
        p.index = i;
        p.srcImageView = [cell.contentView.subviews lastObject];
        [arrM addObject:p];
    }
    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    brower.photos = arrM;
    brower.currentPhotoIndex = indexPath.item;
    [brower show];
}

- (void)setModelBaskOrder:(XZBaskOrderModel *)modelBaskOrder {
    _modelBaskOrder = modelBaskOrder;
//    // 头像
//    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"commtouxiang110"]];
//    // 昵称
//    self.labelNickname.text = @"ID：166****957";
//    // 时间
//    self.labelTime.text = @"2016-10-12 10:36";
//    // 晒单标题
//    self.labelTitle.text = @"随便一投，中奖了！";
//    // 晒单内容
//    self.labelContent.text = @"枯藤老树昏鸦，小桥流水人家，古道西风瘦马，夕阳西下，断肠人在天涯。";
    if ([modelBaskOrder.nickname isKindOfClass:[NSNull class]] || modelBaskOrder.nickname.length == 0) { // 名字为空，显示手机号
        NSString *phone = [modelBaskOrder.phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        self.labelNickname.text = [NSString stringWithFormat:@"ID:%@",phone];
    }else {
        self.labelNickname.text = [NSString stringWithFormat:@"ID:%@",modelBaskOrder.nickname];
    }
    self.labelTime.text = [NSString stringWithFormat:@"%@",[Fm_Tools getTotalTimeFromString:modelBaskOrder.comment_time]];

    self.labelTitle.text = [NSString stringWithFormat:@"%@",modelBaskOrder.comment_title];
    self.labelContent.text = [NSString stringWithFormat:@"%@",modelBaskOrder.comment_content];
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",modelBaskOrder.head_url]] placeholderImage:[UIImage imageNamed:@"commtouxiang110"]];
    self.selectedPhotos = modelBaskOrder.img_list;
    [self.collectionView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
